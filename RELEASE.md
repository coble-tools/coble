# Releasing COBLE

This describes the actual, currently-used process for releasing the `coble` CLI tool itself. It does not cover publishing Docker/Singularity container images built *from* coble recipes — that's a separate, downstream process (see "Container images" at the bottom).

## Where releases go

`coble` is published as a conda package to **Anaconda.org**, under the `rachelsa` channel (not conda-forge or bioconda):

```bash
conda install rachelsa::coble
```
## How to cut a release

Releasing is a manual step, not automatic on merge or tag push.

1. Go to the repo's **Actions** tab → **Conda Release** workflow → **Run workflow**.
2. Enter the new version number (e.g. `0.1.8`), following the existing `MAJOR.MINOR.PATCH` convention used by every tag so far (`v0.1.0` … `v0.1.7`).
3. Run it.

The workflow (`.github/workflows/conda-build.yml`) then does all of this automatically:
- Bumps the version in three places: `conda-recipe/meta.yaml`, `CITATION.cff`, and the `VERSION=` line in `code/coble`.
- Commits that as `Release vX.Y.Z`, tags it `vX.Y.Z`, and pushes both the commit and the tag to `main`.
- Builds the conda package with `conda build conda-recipe/`.
- Uploads the built package to Anaconda.org under the `rachelsa` user with the `main` label.

There's no separate manual version-bump step - entering the version in the workflow's input is the only place you type it.

### Required secrets

The workflow needs these set as repository secrets (it checks `ANACONDA_TOKEN`/`ANACONDA_USER` up front and fails fast if either is missing):
- `ANACONDA_TOKEN` - an Anaconda.org API token with upload permission for the `rachelsa` channel.
- `ANACONDA_USER` - the Anaconda.org username/channel to publish under (currently `rachelsa`).
- `GH_PAT` - a GitHub PAT used to check out and push the release commit/tag back to `main`.

### Before running it

- Make sure `pytest_test.yml`/`pytest_pub.yml`/`pytest_work.yml` (the CI test suites) are green on `main` first - the release workflow itself doesn't run the test suite, it just builds and publishes.
- There's no CHANGELOG.md maintained in this repo - the record of what changed between versions lives in `git log`/`git tag` history on `main`, not a curated file. If you want a changelog for a release, write it from the commits since the last `vX.Y.Z` tag.

## Container images (separate process)

Docker/Singularity images built from `.cbl` recipes (the community environments published to `ghcr.io`) are a downstream consumer of the released conda package, not part of releasing `coble` itself - they run `conda install rachelsa::coble` (or build from local/GitHub source, see `--code-source` in `coble/CLAUDE.md`) to get the tool, then use it to build a specific recipe's environment. Those are triggered separately via `coble-community/.github/workflows/container.yml` and `cont-conda.yml`.
