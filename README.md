# COBLE: COnda BuiLdEr
`COBLE - COnda BuiLdEr: Build and manage conda environments from the RSE team at the ICR`  

## How to Run

1. **Edit your email address** in `code/coble-recipe-slurm.sh`:
   - Change the line:
     ```bash
     #SBATCH --mail-user=your.email@domain.com
     ```
   - Put your own email address so you get SLURM notifications.

2. **Submit your build job** with one command:
   ```bash
   sbatch code/coble-recipe-slurm.sh \
   --results results/r-452 \
   --input config/r-452.sh \
   --env ./envs/r-452   
   ```
   Change the paths if you want different results, input, environment, or package locations.  
   There is an assumption that you will be isolating your environmnts and want to set the pkg enviroment variable and use prefix rather than name environments.  
  
3. Be aware that the environment is passed in as a prefic path, and then is set as an environment variable `CONDA_COBLE_ENV` for use in the config script. This makes the scripts re-usable when creating additional environments. In the scripts the environments are like:
   ```
   conda create -y -p ${CONDA_COBLE_ENV} r-base=4.5.2 python=3.14.0    
   conda activate ${CONDA_COBLE_ENV}
   ```
This is not a requirement, they can be hardcoded, but this option is there for flexibility.

## What This Does
- Builds a conda environment and installs R/Python packages.  
- Exits on error and allows you to fix and rerun from last fail point.   
- Logs output to the results directory.
- Sends you an email if the job fails.  

## Output structure
- Results directory will contain:
  - `coble-stdout.log`: Standard output log file.
  - `coble-stderr.log`: Standard error log file.
  - `recipe.sh`: The generated recipe script that was executed.
  - `done.txt`: A log file indicating R libs that are logged as DONE (lib)
- Environment as specified, but additional
  - `${env}-pkgs` for the packages installed.
  - `${env}-rlibs` for the R libraries installed.

## Requirements
- SLURM cluster  
- Conda installed and initialized  



