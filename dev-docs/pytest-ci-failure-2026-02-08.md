# Pytest CI Failure Analysis - February 8, 2026

## Summary

**Workflow Run ID:** 21802507828  
**Job ID:** 62900322312  
**Branch:** mac-2  
**Date:** February 8, 2026 at 17:43 UTC  
**Duration:** ~47 minutes (2841.43s)  
**Result:** 3 FAILED, 10 PASSED

## Failed Tests

All three failures occurred in `tests/github/test_sh.py`:

1. `test_deseq2` - AssertionError: `assert 1 == 0`
2. `test_r_360` - AssertionError: `assert 1 == 0`
3. `test_r_362` - AssertionError: `assert 1 == 0`

## Detailed Failure Analysis

### 1. test_r_360 - Multiple Conda Errors

This test encountered several critical conda-related failures:

#### CondaError: Initialization Issue
```
CondaError: Run 'conda init' before 'conda deactivate'
```
The conda environment attempted to deactivate without proper initialization.

#### SafetyError: Package Corruption
```
SafetyError: The package for r-base located at /usr/share/miniconda/pkgs/r-base-3.6.0-hce969dd_0
appears to be corrupted. The path 'lib/R/doc/html/packages.html'
has an incorrect size.
  reported size: 2946 bytes
  actual size: 33276 bytes
```
The r-base-3.6.0 package is corrupted with file size mismatches, indicating potential cache corruption or incomplete download.

#### ClobberError: Path Conflicts
```
ClobberError: This transaction has incompatible packages due to a shared path.
  packages: conda-forge/linux-64::c-compiler-1.1.2-h36c2ea0_0, 
            conda-forge/linux-64::fortran-compiler-1.1.2-h30e8c20_0
  path: 'bin/cc'

ClobberError: This transaction has incompatible packages due to a shared path.
  packages: conda-forge/linux-64::c-compiler-1.1.2-h36c2ea0_0, 
            conda-forge/linux-64::fortran-compiler-1.1.2-h30e8c20_0
  path: 'bin/cpp'
```
Both c-compiler and fortran-compiler packages are attempting to install files to the same paths (`bin/cc` and `bin/cpp`), causing installation conflicts.

#### Test Output
```
Running recipes/utils r-360 test
[coble] Detected OS: Linux, Install context: github
[coble 1/5] Resolving cbl...
[coble 2/5] Resolved cbl, proceeding to rationalise.
[coble 3/5] Created recipe, rebuilding environment.
[coble-update] ~~~ Already done recipe: tests/github/r-360.done ~~~ New recipe: tests/github/r-360.sh ~~~
[coble 4/5] Created recipe, proceeding to creation from tests/github/r-360.delta
[coble-create] Updating environment 'r-360x' from recipe file: tests/github/r-360.delta
```
The test proceeded through recipe generation but failed during conda environment creation.

### 2. test_r_362 - Missing CBL File

This test failed early in the process due to a missing input file:

```
[coble-find] !!!error no cbl input please --recipe CBL
/home/runner/work/coble/coble/code/coble-rationalise.sh: line 65: tests/github/r-362.cbl: No such file or directory
[coble-rationalise] CBL not ordered, please fix before proceeding to rationalise: tests/github/r-362.cbl
```

The test is looking for `tests/github/r-362.cbl` but the file does not exist in the repository. The subsequent errors about CBL ordering are secondary to the missing file issue.

#### Test Command
```
coble build --recipe tests/github/r-362.cbl --validate recipes/utils/r-362/validate/validate.sh --val-folder recipes/utils/r-362/validate/ --env r-362x --containers conda --rebuild
```

### 3. test_deseq2

Similar issues to test_r_360 with conda package corruption and initialization errors. (Detailed logs were truncated in the output but likely mirror the r-360 failures.)

## Common Issues Across Tests

### Conda Version Warning
All tests showed warnings about an outdated conda version:
```
==> WARNING: A newer version of conda exists. <==
    current version: 25.11.1
    latest version: 26.1.0
```

### Coble Workflow Steps
The tests follow a consistent 5-step workflow:
1. Resolving cbl
2. Rationalising cbl
3. Creating recipe and rebuilding environment
4. Creating from delta file
5. (Final validation step)

Most failures occur during steps 2-4 when interacting with conda.

## Root Cause Analysis

### Primary Issues

1. **Corrupted Conda Cache**: The r-base package corruption suggests the conda package cache on the CI runner is damaged. This could be from:
   - Interrupted downloads
   - Disk space issues
   - Concurrent access issues
   - Stale cache from previous runs

2. **Missing Test Fixtures**: The r-362.cbl file is referenced in tests but doesn't exist in the repository, indicating either:
   - Test file was deleted but test wasn't updated
   - Test file should be generated during test setup
   - Test configuration is incorrect

3. **Compiler Package Conflicts**: The c-compiler and fortran-compiler packages from conda-forge have overlapping files, suggesting:
   - Incompatible package versions
   - Upstream packaging issue
   - Incorrect package specification in the CBL file

4. **Conda Initialization**: The "Run 'conda init' before 'conda deactivate'" error suggests the test environment setup doesn't properly initialize conda shells.

### Secondary Issues

- **Outdated conda version**: While likely not causing failures, the version mismatch could contribute to unexpected behavior
- **Assertion failures at line 40**: All three tests fail at the same assertion line in `tests/github/test_sh.py`, suggesting this is where the exit code is checked (likely `assert exit_code == 0`)

## Potential Solutions (Not Implemented)

To fix these issues, consider:

1. **Clear conda cache** before or during CI runs:
   ```bash
   conda clean --all
   ```

2. **Add missing test file** `tests/github/r-362.cbl` or remove the test if it's obsolete

3. **Investigate compiler package conflicts** - may need to:
   - Pin specific package versions
   - Use different compiler packages
   - Modify package specifications in the CBL files

4. **Ensure conda initialization** in test setup:
   ```bash
   conda init bash
   source ~/.bashrc
   ```

5. **Update conda version** in CI workflow to 26.1.0

6. **Add retry logic** for conda operations to handle transient failures

## CI Environment Details

- **Runner**: ubuntu-latest (GitHub Actions hosted runner)
- **Platform**: linux-64 (x86_64)
- **Conda Base**: /usr (system conda)
- **Conda Executable**: /usr/bin/conda

## Logs Location

Full logs can be retrieved using:
- Workflow Run ID: 21802507828
- Job ID: 62900322312
- Direct link: https://github.com/ICR-RSE-Group/coble/actions/runs/21802507828/job/62900322312

## Additional Notes

- 10 out of 13 tests passed successfully, indicating the coble system generally works
- All failures are in the `test_sh.py` test suite which tests shell-based recipe execution
- The failures appear to be environment-specific (CI runner issues) rather than code logic issues
- The mac-2 branch has had consistent pytest failures over multiple runs throughout the day

## Date of Analysis

This analysis was performed on February 8, 2026 by examining CI logs from the most recent failed pytest workflow run.
