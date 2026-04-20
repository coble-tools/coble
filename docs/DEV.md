# Developing With COBLE

## The Test Suite
A comprehensive test suite is run in CI/CD when a pull request is made or a commit to main.
The tests are defined in tests/github

## Conda submission
The conda submission is made via a manual CI/CD, in `Actions` go to `Conda Release` -> `Run workflow` and choose the branch and new version.
Note we stay at 0, so a from 0.1.1 a major would be 0.2.0 and a minor would be 0.1.2.  
Conda requires a set of tests to be run, these are in `tests/conda`  

## Container submission
Made from actions in CI/CD, choose `Choose Arch GitHub/Docker Image (Manual)` -> `Run workflow` and specify the branch then 3 options: institution, name and architecture.

## Issues and Pull requests
Please raise an issue for any work to be done, and when ready create a draft pull request relevant to the issue e.g. issue-123-added-container.
The draft pull request alerts to the fact of the work and the files changed, and runs the tests. When ready confirm pull request and notify owner by requesting a review.  

---  

## Release Process

This project release process assumes you always do both manual actions:

1. Run the Conda Release workflow with a new version
2. Manually publish a GitHub Release using the created tag

Tag creation is automatic inside the Conda Release workflow.

This repository already automates most of this through GitHub Actions.

### One-Time Prerequisites

Set these repository secrets (GitHub -> Settings -> Secrets and variables -> Actions):

- `GH_PAT` (token with repo write access)
- `ANACONDA_TOKEN`
- `ANACONDA_USER`

### Version Format

- Enter versions as `X.Y.Z` in the Conda workflow input (example: `0.1.2`).
- Tags are created as `vX.Y.Z` automatically (example: `v0.1.2`).

### Standard Release Steps (Do This Every Time)

1. Go to GitHub Actions -> `Conda Release` workflow.
2. Click `Run workflow` on `main`.
3. Enter `version` as `X.Y.Z`.
4. Wait for the workflow to finish successfully.

What this workflow does:
- Updates versions in:
  - `conda-recipe/meta.yaml`
  - `CITATION.cff`
  - `code/coble`
- Commits to `main` (if changed)
- Creates and pushes tag `vX.Y.Z`
- Builds and uploads the Conda package

5. Go to GitHub -> Releases -> `Draft a new release`.
6. Select existing tag `vX.Y.Z`.
7. Set release title (for example: `vX.Y.Z`) and notes.
8. Click `Publish release`.

### Quick Verification Checklist

After release, confirm:

1. Tag `vX.Y.Z` exists in GitHub.
2. GitHub Release `vX.Y.Z` is published.
3. Zenodo record for `vX.Y.Z` is created/updated.
4. Conda package `coble-X.Y.Z-0` is available on Anaconda.org.
5. Version files (`meta.yaml`, `CITATION.cff`, `code/coble`) are on `X.Y.Z` in `main`.

### If Something Fails

1. Fix the issue on `main`.
2. Re-run the failed workflow if possible.
3. If a bad tag/release was created, clean it up in GitHub, then rerun with the same or next version.



