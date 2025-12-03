<img src="coble.png" alt="COBLE logo" width="200" style="float: right; margin-right: 20px; margin-bottom: 10px;" />

# COBLE: COnda BuiLdEr

COBLE is a tool to build and manage conda environments, developed by the RSE team at the ICR.

## How to Run

1. **Edit your email address** in `code/coble-recipe-slurm.sh`:
   
   Put your own email address so you get SLURM notifications.

2. **Submit your build job** with one command:
   ```bash
   sbatch --mail-user=your.email@domain.com \
   code/coble-recipe-slurm.sh \
   --results results/r-452 \
   --input config/r-452.sh \
   --env ./envs/r-452 \
   --r-version 4.5.2 \
   --python-version 3.14.0 \
   --skip-errors \
   --override-envs
   ```
   Adjust the paths as needed for your results, input, environment. 
   Some of the arguments are optional, some required:
    - `--results`: Directory to store logs and outputs (required)
    - `--input`: Configuration script for the environment (required)
    - `--env`: Path to the conda environment to create/use (required)
    - `--r-version`: R version to install (optional, default: 4.5.2)
    - `--python-version`: Python version to install (optional, default: 3.14.0)
    - `--skip-errors`: Continue processing even if errors are detected (optional, default is to stop)
    - `--override-envs`: Override R_LIBS_USER and CONDA_PKGS_DIRS to isolate environments locally next to the prefix (optional, default is not to override)

   The environment is passed as a prefix path and set as the `CONDA_COBLE_ENV` variable for use in config scripts. 
   Example usage in scripts:
   ```bash
   conda create -y -p ${CONDA_COBLE_ENV} r-base=4.5.2 python=3.14.0
   conda activate ${CONDA_COBLE_ENV}
   ```
   This is optional; you can hardcode paths if preferred.


## Activating the environment
To activate the created environment, use:
```bash
conda activate ./envs/r-452
```
If you choose to override the R_LIBS_USER and CONDA_PKGS_DIRS, ensure these environment variables are set accordingly before activating the environment:
```bash
export R_LIBS_USER="./envs/r-452_rlibs"
export CONDA_PKGS_DIRS="./envs/r-452_pkgs"
conda activate ./envs/r-452
```

## What This Does
- Builds a conda environment and installs R/Python packages.
- Exits on error, allowing you to fix and rerun from the last fail point.
- Logs output to the results directory.
- Sends an email if the job fails.

## Output Structure
- Results directory contains:
  - `coble-stdout.log`: Standard output log
  - `coble-stderr.log`: Standard error log
  - `recipe.sh`: The generated recipe script
  - `done.txt`: Log of completed R library installs
- Environment-specific directories for installed packages and R libraries.

## Requirements
- SLURM cluster
- Conda installed and initialized
