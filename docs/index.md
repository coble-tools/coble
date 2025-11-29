<img src="coble.png" alt="COBLE logo" width="200" style="float: right; margin-right: 20px; margin-bottom: 10px;" />

# COBLE: COnda BuiLdEr

COBLE is a tool to build and manage conda environments, developed by the RSE team at the ICR.

## How to Run

1. **Edit your email address** in `code/coble-recipe-slurm.sh`:
   - Change the line:
     ```bash
     #SBATCH --mail-user=your.email@domain.com
     ```
   - Use your own email address to receive SLURM notifications.

2. **Submit your build job**:
   ```bash
   sbatch code/coble-recipe-slurm.sh \
   --results results/r-452 \
   --input config/r-452.sh \
   --env ./envs/r-452
   ```
   Adjust the paths as needed for your results, input, environment, or package locations.

   The environment is passed as a prefix path and set as the `CONDA_COBLE_ENV` variable for use in config scripts. Example usage in scripts:
   ```bash
   conda create -y -p ${CONDA_COBLE_ENV} r-base=4.5.2 python=3.14.0
   conda activate ${CONDA_COBLE_ENV}
   ```
   This is optional; you can hardcode paths if preferred.

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
