# Test Revert-Mac Workflow

## Purpose
This workflow (`test-revert-mac.yml`) is specifically designed to test the `revert-mac` branch with the necessary compiler toolchain fixes.

## Problem It Solves
The revert-mac branch tests were failing with:
```
LibMambaUnsatisfiableError: nothing provides package_has_been_revoked 
needed by gfortran_linux-64-7.2.0-24
```

This occurred because conda environments with old R versions (like r-base=3.6.2) require compiler toolchains that have been revoked in conda repositories.

## Solution
This workflow installs system-level compilers (`build-essential` and `gfortran`) via `apt-get` before setting up conda, allowing the environments to build successfully without depending on revoked conda packages.

## How to Deploy to revert-mac Branch

### Method 1: Direct Copy (Recommended)
```bash
# Checkout revert-mac branch
git checkout revert-mac

# Copy the workflow file from this branch
git checkout copilot/add-apt-get-for-toolchain -- .github/workflows/test-revert-mac.yml

# Commit and push
git add .github/workflows/test-revert-mac.yml
git commit -m "Add CI workflow with compiler toolchain fix"
git push origin revert-mac
```

### Method 2: Manual Copy
1. Copy the contents of `.github/workflows/test-revert-mac.yml`
2. Switch to revert-mac branch
3. Create the file in `.github/workflows/test-revert-mac.yml`
4. Commit and push

## What It Does

1. **Triggers on**: Pushes and PRs to `revert-mac` branch
2. **Frees up disk space**: Removes unnecessary files to prevent disk full issues
3. **Installs compilers**: `sudo apt-get install -y build-essential gfortran`
4. **Sets up conda**: Uses conda-incubator/setup-miniconda@v3
5. **Installs pytest**: Via conda for consistency
6. **Runs tests**: All tests in `tests/github/` directory (13 tests)

## Expected Test Results
When running on revert-mac branch, should execute:
- test_set1_basic.py (3 tests)
- test_set1_circle.py (1 test)
- test_set1_docker.py (1 test)
- test_set2_small.py (2 tests)
- test_set3_icr.py (2 tests)
- test_set3_papers.py (1 test)
- test_set3_utils.py (3 tests)

**Total: 13 tests**

## Removal
When testing is complete and no longer needed:
```bash
git checkout revert-mac
git rm .github/workflows/test-revert-mac.yml
git commit -m "Remove temporary revert-mac test workflow"
git push origin revert-mac
```

## Security
- Uses explicit permissions: `contents: read`
- No secrets or credentials exposed
- CodeQL security scan: ✅ Passed (0 alerts)

## Notes
- This is a standalone workflow that won't interfere with other CI workflows
- The workflow file name `test-revert-mac.yml` makes it easy to identify and remove
- System compilers mirror the approach used in `coble.Dockerfile` (lines 57-58)
