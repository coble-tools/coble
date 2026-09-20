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
  statements.
- All eval'd lines run in the *same* persistent shell process, not a
  subshell per line — `export` / `conda activate` on one line correctly
  carries forward to later lines.
- `recipe.sh` holds the already-resolved result for whichever machine
  generated it — coble-recipise.sh resolves any machine-dependent choices
  (see the `<os=,arch=>` condition syntax below) at generation time, not as
  runtime `if` statements in the recipe.

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
  lines, or writes nothing at all. Currently wired into the `export`
  directive only (coble-recipise.sh:407-419) — adding a condition to any
  other directive is silently ignored.
- Directive ordering in the `.cbl` matters: `recipe.sh` is written out in the
  same order the `.cbl` is read, so a `flags:` line only affects package
  installs that come **after** it in the file. Some directives need to
  precede `languages:`/package sections they configure (e.g. a `CONDA_SUBDIR`
  export), while others need to *follow* R being installed (e.g. `cran-repo:`,
  which emits a direct `Rscript -e 'options(repos=...)'` call). If a single
  `flags:` block would need to sit both before and after `languages:` to
  satisfy every directive in it, split it into two blocks instead — this is
  a normal, supported pattern; a file can have as many `flags:` blocks as it
  needs, in whatever order the individual directives require.
- Standalone comment lines are gathered into a `comment_gather` buffer
  instead of being written immediately, and get flushed (prefixed `#^`,
  meaning "belongs to the block above") whenever `remove_trailing_backslash`
  runs — on a new section header, a blank line, or EOF. This exists so a
  stray `#comment` sitting between package lines in the `.cbl` doesn't
  truncate an in-progress `\`-continued `conda install` command.
- Several per-line-parse variables (`value_lower`, `pkg_entry`, etc.) are
  script-global and not reset between sections — a directive handler in one
  section can accidentally echo or act on a stale value left over from a
  previous section's iteration. Be alert for this if you add or move
  directive handlers in this parser.

## The `compile:` flags directive

Compiler/build-tool settings live under one `flags:` directive, `compile:
<key>=<value>` (coble-recipise.sh:492-567):

| Sub-key | Effect |
|---|---|
| `compile: system=true` | Installs a fixed bundle of common system libraries for building R/Python packages from source (libcurl, gdal/proj/geos/cairo, HDF5, libtool/autoconf/cmake/pkg-config, zlib/openssl/sqlite, plus R- or Python-specific extras if that language is present). |
| `compile: tools=true` or `compile: tools=13.1` | Installs conda-forge's generic `compilers` meta-package. The version number is not currently used to pin an exact version — use `version=` for that. |
| `compile: version=11.4` | Installs and pins an exact compiler version. On Linux x86_64 this pins `gcc`/`g++`/`gfortran` to that version with symlinks; on any other platform it installs a generic compiler instead (the exact version isn't available there). |
| `compile: paths=true` | Sets `umask 0022` before subsequent installs. Nothing is installed by this alone. |

There is no `compilers:` section — everything here lives under `flags:`.

## Platform / architecture facts

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
- coble-container.sh has unused `--dual` / `--dual-ci` flags: parsed into
  `DUAL` / `DUAL_CI` but never referenced afterward. Don't assume they do
  anything. For building a specific non-native platform, use `--platform`
  (below), not these.
- `coble-platform.sh` is a separate sibling script for the one case the
  native-runner approach doesn't cover: building a specific *non-native*
  platform *locally* (e.g. testing linux/arm64 on an amd64 dev machine, or
  vice versa) via `docker buildx build --platform ... --load`. It is not
  used by container.yml or by coble-container.sh's normal path.
  **Dispatch chain**, since users invoke the top-level `coble` wrapper, not
  coble-container.sh directly: `coble build --containers docker --platform
  <value> ...` → `coble` forwards `"${@:2}"` to coble-container.sh whenever
  `$container_type` contains `docker` or `singularity` (coble:271-274) →
  coble-container.sh detects `--platform` right after its own arg parsing
  and does `exec coble-platform.sh "${ORIGINAL_ARGS[@]}"` before any of its
  own validation runs (coble-container.sh:132-135). Because of that
  hand-off, coble-platform.sh fully validates its own arguments rather than
  relying on the caller having done it — `--env`/`--recipe`/`--platform`
  are required; `--validate` is optional. `--platform` takes the same
  syntax `docker buildx` itself does (e.g. `linux/arm64`), but only a
  single platform — `--load` cannot load a multi-platform manifest into the
  local Docker daemon, so a comma-separated value is rejected outright.
- coble-platform.sh never builds Singularity, even if `--containers`
  mentions it (it warns and ignores that part) — a buildx `--platform`
  build is routinely cross-arch (and cross-OS, from a Mac), and there's no
  guarantee singularity/apptainer is even present on the machine running
  it. Use coble-container.sh's normal native-runner-per-arch path for
  Singularity images.
- `container_type` (parsed from `--containers` in the top-level `coble`
  wrapper, coble:63-69) is what actually drives routing — the `conda`
  branch (coble:156) and the docker/singularity dispatch to
  coble-container.sh (coble:271). If you're tracing what a `--containers`
  value does, follow `container_type`, not any other similarly-named
  variable.
- `--code-source` (coble-container.sh, coble-platform.sh) controls which
  version of the coble tool itself gets installed *inside* the Docker
  image — never conda, and never your local working copy unless you ask
  for it. `coble.Dockerfile` either `git clone`s
  `github.com/coble-tools/coble.git` fresh and does `git checkout
  ${CODE_SOURCE}`, or (only for `local`) copies in a staged local checkout.
  Three values:
  - `main` (the default): passed straight through as the literal string
    `"main"` and resolved by `git checkout main` at actual Docker-build
    time — not pre-resolved to a SHA. Running the identical command on
    different days can produce different images, by design; use a SHA if
    you need a pin.
  - a specific git SHA (or any real ref name) — used as-is via `git
    checkout <value>`. This is how you pin an exact, reproducible coble
    version.
  - `local` — debug/dev only, never used by the published community/CI
    builds. Docker's `COPY` can only reach files inside the build context
    (wherever you happen to run the command from, not this checkout), so
    coble-container.sh/coble-platform.sh stage this checkout's own root
    (`$SCRIPT_DIR/..`, no path argument needed or offered) into
    `.coble-local-src-stage/` in the build context just before invoking
    `docker build`, and clean it up again right after. `coble.Dockerfile`'s
    `COPY .coble-local-src-stage ...` runs unconditionally — the staging
    step always creates that directory, empty unless `local` was
    requested, so the same Dockerfile line works for every case.
- `--validate` is optional in coble-container.sh/coble-platform.sh. Since
  Docker's `COPY` needs a real source either way, both scripts stage a
  fixed file at `.coble-validate-stage` before `docker build` — a copy of
  the given validate script, or an empty placeholder if none was given —
  and `coble.Dockerfile` always `COPY`s from that fixed path rather than
  from `$VAL_FILE` directly.

## Working style for this repo

- After any edit to a `.sh` file, run `bash -n` on it before calling the
  change done.
- For coble-recipise.sh specifically, don't just eyeball the generated
  logic — actually run it against a real `.cbl`
  (`bash coble-recipise.sh --recipe <file> --env test --output <scratch>/test.sh --outdir <scratch>`),
  grep the emitted lines, and, for anything conditional, sanity-test that
  exact snippet standalone with `bash -c` (mocking `conda`/`uname` as
  needed). Reading the generator's source alone doesn't reliably tell you
  what it actually emits for a given input.

**Never touch git state in this repo unless explicitly asked to, in that moment** — no `git add`, `git rm`, `git commit`, staging, or offering to commit. Git here is the user's own review and control layer over changes made in a session: they inspect `git status`/`git diff` and decide what to stage or commit themselves. An agent staging or committing on its own removes exactly the review step git exists to provide. Make changes with plain file operations (`rm`, edits) and leave every git command to the user, even `git add` of something you just deleted.