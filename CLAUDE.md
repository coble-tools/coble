# COBLE — notes for Claude

Repo-specific facts and gotchas — read this before editing coble-recipise.sh, coble-create.sh, coble-container.sh, or the GitHub workflow.

## Execution model of a generated recipe

coble-recipise.sh turns a `.cbl` file into a `recipe.sh`. coble-create.sh does
**not** run `recipe.sh` as a normal contiguous bash script — it reads it
line-by-line and `eval`s each logical line independently
(coble/code/coble-create.sh:246-289).

- A "logical line" is one physical line, OR a run of physical lines joined by a
  trailing `\` (the backslash is stripped and lines are concatenated with a
  space before eval — coble-create.sh:274-284).
- Comment lines (`#...`) and blank lines are skipped entirely and never
  reach `eval` (coble-create.sh:266-268).
- Consequence: any bash control flow (`if`/`fi`, `for`/`done`, function defs)
  that spans more than one physical line **must** either be a single physical
  line (use `&&` / `||` / `;` / `{ }` grouping), or every line it spans must
  end in a trailing `\`. A bare multi-line `if ... then` / body / `fi` with no
  continuation backslashes gets `eval`'d as separate, independently-broken
  statements — this was a real bug caught in this repo, in an early version of
  the `<os=,arch=>` conditional export mechanism below (now fixed properly:
  see next bullet).
- All eval'd lines run in the *same* persistent shell process, not a
  subshell per line — `export` / `conda activate` on one line correctly
  carries forward to later lines.
- The recipe.sh is not supposed to replicate the coble recipe it is supposed to be the resolution of it, don't defer if statements forever they are resolved and the statement is in the sh file or it is not.

Whenever you generate new lines for `recipe.sh` from coble-recipise.sh, sanity
check them against this model, not against "is this valid as a whole script."

## coble-recipise.sh: the .cbl → recipe.sh generator

- It's a section-based line-oriented parser, not a YAML parser. Section
  header lines (`languages:`, `conda:`, `flags:`, `channels:`, etc — see the
  big `if` at coble-recipise.sh:290) set `CURRENT_SECTION`; each following
  `- ` line is dispatched on that.
- An unrecognized bare `word:` header is a hard error, by design: a recipe
  is meant to reproduce a specific environment exactly, so a typo'd or
  made-up section name aborts generation (`This is an invalid header "..."
  please fix the recipe file and then resume`, exit 1,
  coble-recipise.sh:353-356) rather than silently dropping whatever was
  under it and producing a plausible-looking but wrong environment. Add any
  genuinely new section to the recognized-header list rather than letting
  it fall through here.
- `coble:` is a recognized header/section (coble-recipise.sh:316,
  coble-recipise.sh:374). Its `- environment: NAME` entry is read in a
  pre-scan right after CLI arg parsing, before `--env`/`--recipe` defaults
  are resolved (coble-recipise.sh:114-133) — if `--env` wasn't passed on the
  command line, `NAME` becomes the environment name; an explicit `--env`
  always wins. This has to happen before `CONDA_ENV`/`ENV_NAME` are derived,
  because the `conda create`/`env remove` lines using them are written out
  earlier in the file than the `coble:` section itself is parsed.
- `flags:` directives support an optional `<key=value,key=value>` condition
  suffix on the directive name, e.g.
  `export<os=darwin,arch=arm64>: CONDA_SUBDIR=osx-64`. Only `os=` and `arch=`
  keys are understood (arm64/aarch64 treated as aliases). The condition is
  resolved **immediately, against the machine coble-recipise.sh is currently
  running on** (`uname -s`/`uname -m` checked right there in the generator,
  coble-recipise.sh:356-386) — not embedded as a runtime check into
  `recipe.sh`. It prints which way it resolved
  (`[coble-recipise] Conditional export on ..., adding/skipping ...`) and
  either writes the plain, unconditional `export`/`conda env config vars set`
  lines, or writes nothing at all. This matches the execution-model rule
  above: `recipe.sh` holds the *already-resolved* result for this machine,
  never a deferred `if`. Currently wired into the `export` directive only
  (coble-recipise.sh:407-419) — adding a condition to any other directive is
  silently ignored.
- Directive ordering in the `.cbl` matters: `recipe.sh` is written out in the
  same order the `.cbl` is read, so a `flags:` line (e.g. the `export<...>`
  above) only affects package installs that come **after** it in the file.
  Putting it after the `languages:`/`conda:` block it's meant to affect is a
  real bug that will silently resolve too late (hit this exact issue with
  `CONDA_SUBDIR` being set after `r-base` had already failed to solve).
- Standalone comment lines are gathered into a `comment_gather` buffer
  instead of being written immediately, and get flushed (prefixed `#^`,
  meaning "belongs to the block above") whenever `remove_trailing_backslash`
  runs — on a new section header, a blank line, or EOF. This exists so a
  stray `#comment` sitting between package lines in the `.cbl` doesn't
  truncate an in-progress `\`-continued `conda install` command.
- Several per-line-parse variables (`value_lower`, `pkg_entry`, etc.) are
  script-global and not reset between sections — a directive handler in one
  section can accidentally echo a stale value left over from a previous
  section's iteration. Found and fixed two real instances of this (the old
  `compilers:` → `cran-repo` handler, and the old `flags: - compile-tools:`
  handler — see the migration note below); be alert for more if you touch
  this parser.

## Retired directives: migrate compile-tools/compile-version/compile-paths/system-tools/compilers:

These no longer exist — they were consolidated into a single `flags:`
directive, `compile: <key>=<value>`, with `tools=`/`version=`/`paths=`/
`system=` sub-keys (coble-recipise.sh:492-567, hard-fail for the old names
at coble-recipise.sh:568-572). The `compilers:` section
header was retired entirely; anything that lived under it moves into
`flags:`.

If you find a `.cbl` still using the old names, migrate it like this:

| Old | New |
|---|---|
| `flags: - compile-tools: V` | `flags: - compile: tools=V` |
| `flags: - compile-version: V` | `flags: - compile: version=V` |
| `flags: - compile-paths: V` | `flags: - compile: paths=V` |
| `flags: - system-tools: V` | `flags: - compile: system=V` |
| `compilers:` (section header) | rename in place to `flags:` |
| `compilers: - cran-repo: V` | `flags: - cran-repo: V` (directive name unchanged, just moves section) |

Rename in place rather than physically relocating lines — directive order
in the file matters (see the ordering note above), and an in-place rename
preserves it automatically. Ending up with two separate `flags:` blocks in
the same file (e.g. one renamed from `compilers:`, one already there) is
fine — they don't need merging.

coble-recipise.sh hard-fails with a clear message if it sees any of the
four old directive names or a `compilers:` header, the same way it does for
any other unrecognized header — that error is the signal a file needs this
migration, not a sign of a new bug.

**Status: this migration is done.** Every real `.cbl` in the repo (85 files)
was migrated and verified in this session — each has a `.premigration.bak`
alongside it (this repo has no git, so that's the only rollback path; don't
delete them). If you see the old syntax anywhere now, it's a new file that
was written with stale knowledge, not a leftover from this migration.

Two real bugs were fixed as part of this consolidation — expect these
specific differences (and only these) if you diff a migrated file's
generated recipe.sh against its pre-migration version:
- The old `compile-version` unconditionally installed the Linux-only
  `sysroot_linux-64` package before even checking the OS, and had no real
  logic for any platform but Linux x86_64 (every other platform just got a
  comment, nothing installed). `compile: version=` only installs
  `sysroot_linux-64` on genuine Linux x86_64, and installs a generic
  `c-compiler cxx-compiler` everywhere else instead of doing nothing.
- The old `flags: - compile-tools:` handler read a stale, possibly
  uninitialized global `$version` variable instead of its own directive's
  value, so `compile-tools: false` could be silently ignored if an earlier
  `compile-version`/`compile-paths` line in the same block had already set
  `$version` to something else (this genuinely happened in
  `coble/code/tml_full.cbl`). `compile: tools=false` now reliably skips.

Any other difference in a migrated file's output is not expected — treat it
as a real bug to investigate, not as one of these two known fixes.

## Platform / architecture facts (verified, don't re-derive from scratch)

- Singularity/Apptainer has no macOS build — it depends on Linux kernel
  namespaces. `.sif` images are Linux-only; there is no "mac SIF." The
  `--containers singularity` path in coble-container.sh can only ever run on
  a real Linux host or CI runner.
- `CONDA_SUBDIR=osx-64` on Apple Silicon runs **macOS** Intel (x86_64) conda
  packages via Rosetta — it has nothing to do with Linux. It must never leak
  onto a Linux run: a bare `arch=arm64` condition would also match Linux
  ARM64 (`uname -m == aarch64`, e.g. GitHub's `ubuntu-24.04-arm` runner),
  which is why the guard always pairs `os=darwin` with `arch=arm64`.
- coble-community/.github/workflows/container.yml's multi-arch strategy is
  native-runner-per-arch: `ubuntu-latest` builds amd64, `ubuntu-24.04-arm`
  builds arm64, each with a plain `docker build` (no buildx). A separate
  `manifest` job then uses `docker buildx imagetools create` only to merge
  the two arch-specific images into one manifest list — buildx is not used
  to cross-build.
- coble-container.sh has dead `--dual` / `--dual-ci` flags: parsed into
  `DUAL` / `DUAL_CI` but never referenced afterward. Confirmed history: an
  earlier buildx-with-`--platform` implementation was deliberately deleted,
  because the approach that actually works is the one container.yml uses —
  native runner per architecture, each doing a plain build, merged
  afterward into one manifest (see the bullet above) — not a single job
  cross-building multiple platforms with buildx. `--dual`/`--dual-ci` are
  leftovers from that deleted approach; don't assume they do anything.
- `coble-platform.sh` is a separate sibling script for the one case the
  native-runner approach doesn't cover: building a specific *non-native*
  platform *locally* (e.g. testing linux/arm64 on an amd64 dev machine, or
  vice versa) via `docker buildx build --platform ... --load`. It is not
  used by container.yml or by coble-container.sh's normal path.
  **Full dispatch chain**, since users invoke the top-level `coble` wrapper,
  not coble-container.sh directly: `coble build --containers docker
  --platform <value> ...` → `coble` forwards `"${@:2}"` to
  coble-container.sh whenever `$container_type` contains `docker` or
  `singularity` (coble:271-274) → coble-container.sh detects `--platform`
  right after its own arg parsing and does
  `exec coble-platform.sh "${ORIGINAL_ARGS[@]}"` before any of its own
  validation runs (coble-container.sh:132-135). Because of that hand-off,
  coble-platform.sh has to fully validate its own arguments rather than
  relying on the caller having done it — `--env`/`--recipe`/`--platform`
  are required; `--validate` is optional in both coble-container.sh and
  coble-platform.sh (skips the validation layer if omitted). `--platform`
  takes the same syntax `docker buildx` itself does (e.g. `linux/arm64`),
  but only a single platform — `--load` cannot load a multi-platform
  manifest into the local Docker daemon, so coble-platform.sh rejects a
  comma-separated value outright rather than attempting it.
- coble-platform.sh never builds Singularity, even if `--containers`
  mentions it (it just warns and ignores that part) — a buildx `--platform`
  build is routinely cross-arch (and cross-OS, from a Mac), and per the
  no-macOS-Singularity fact above there's no guarantee singularity/apptainer
  is even present on the machine running it. Use coble-container.sh's
  normal native-runner-per-arch path for Singularity images.
- The top-level `coble` wrapper (coble/code/coble) had a real bug, same
  class as the stale-global-variable ones above: two separate variables
  both meant to track `--containers` — a dead `containers` (hardcoded to
  `"conda"`, never updated after declaration) and the real one,
  `container_type` (correctly parsed from `--containers`, correctly used
  everywhere the actual routing logic depends on it, e.g. coble:156,
  coble:271). One log line read the dead variable, so it always printed
  `Containers to build: conda` regardless of what `--containers` actually
  was — purely cosmetic, the real routing was never affected, but confusing
  enough to look like `--containers`/`--platform` weren't working. Fixed by
  removing the dead variable and pointing the log line at `container_type`.
  If you see two near-identical variable names for the same concept
  anywhere in this codebase, assume one of them is dead until proven
  otherwise — this is the third time it's happened in one session.
- `--code-source` (coble-container.sh, coble-platform.sh) controls which
  version of the coble tool itself gets installed *inside* the Docker
  image — it is never conda, and never actually your local working copy by
  default. coble.Dockerfile always either `git clone`s
  `github.com/coble-tools/coble.git` fresh and does `git checkout
  ${CODE_SOURCE}`, or (only for `local`) copies in a staged local checkout —
  see below. Three values:
  - `main` (the default): passed straight through as the literal string
    `"main"` and resolved by `git checkout main` at actual Docker-build
    time — deliberately **not** pre-resolved to a SHA beforehand (an
    earlier version of coble-container.sh did resolve it via `git
    ls-remote` ahead of the build, which defeated the point of choosing
    `main` over a pin - removed). Running the identical command twice on
    different days can produce different images, by design.
  - a specific git SHA (or any real ref name) — used as-is via `git
    checkout <value>`. This is how you pin an exact, reproducible coble
    version; `main` is not a pin.
  - `local` — debug/dev only, never used by the published community/CI
    builds. Docker's `COPY` can only reach files inside the build context
    (which is wherever you happen to run the command from, not this
    checkout), so coble-container.sh/coble-platform.sh stage this
    checkout's own root (`$SCRIPT_DIR/..`, no path argument needed or
    offered - if you want a different local source, it isn't this
    mechanism) into `.coble-local-src-stage/` in the build context just
    before invoking `docker build`, and clean it up again right after
    (success or failure). coble.Dockerfile's `COPY .coble-local-src-stage
    ...` runs unconditionally — the staging step always creates that
    directory, empty unless `local` was requested, so the same Dockerfile
    line works for every case without needing BuildKit's multi-context
    features.
  - Verified all three paths directly: an isolated Dockerfile test
    confirmed `local` picks up a staged marker file and `main` does not
    (falls through to a real git clone); the staging shell logic was
    checked separately to confirm it resolves to this checkout's actual
    root and contains `code/coble-recipise.sh`.

## Working style for this repo

- After any edit to a `.sh` file, run `bash -n` on it before calling the
  change done.
- For coble-recipise.sh specifically, don't just eyeball the generated
  logic — actually run it against a real `.cbl`
  (`bash coble-recipise.sh --recipe <file> --env test --output <scratch>/test.sh --outdir <scratch>`),
  grep the emitted lines, and, for anything conditional, sanity-test that
  exact snippet standalone with `bash -c` (mocking `conda`/`uname` as
  needed). This caught two real bugs in one session that reading the
  generator's source code alone missed.

**Never touch git state in this repo unless explicitly asked to, in that moment** — no `git add`, `git rm`, `git commit`, staging, or offering to commit. Git here is the user's own review and control layer over changes made in this session: they inspect `git status`/`git diff` and decide what to stage or commit themselves. An agent staging or committing on its own removes exactly the review step git exists to provide. Make changes with plain file operations (`rm`, edits) and leave every git command to the user, even `git add` of something you just deleted.
