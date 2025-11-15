# COBLE - COnda BuiLdEr

<img src="docs/coble.png" alt="COBLE logo" width="200" style="float: left; margin-right: 20px; margin-bottom: 10px;" />

**COBLE - COnda BuiLdEr: Build and manage conda environments from the RSE team at the ICR**

COBLE is a set of scripts to help build and manage conda environments, particularly for R and Bioconductor packages, along with Python packages. It allows you to define environments using YAML files or bash recipes, automates the installation process, captures logs for error analysis, and generates reproducible outputs including combined environment files and installation scripts.

COBLE packages are built on Docker and made available via DockerHub for easy use with Singularity. This enables the same conda environments to be used on secure systems without internet access.

For local builds bash or slurm can be used to run the scripts directly, see full details of the usage below.

## 📚 Documentation

**Full documentation is available at: [https://icr-rse.gitlab.io/apps/coble/](https://icr-rse.gitlab.io/apps/coble/)** 

## Running COBLE

The config/coble-*.yml files define conda environments with R, Python, BioConductor and other packages. All of these environments are available as docker images on dockerhub in the same format, eg `icrsc/coble:*` for the environment defined in `config/coble-*.yml`.

### Install with singularity
To pull an image and give it a specific file name you can use (with r 4.5.2 full config as the example):
```bash
singularity pull -F coble-452.sif docker://icrsc/coble:452
```
You can then run the container with:
```bash
singularity shell coble-452.sif
```
This opens up a shell inside the container. There is an activation script that runs automatically to activate the envirtonment so you are immediately inside the singularity container with an actove conda environment. Due to the way singularity works you will have access to the files on the host system so you can continue to work in the same way as you would were this a conda environment, interactig with files on the host system and running scripts, accessing image files etc.

The singularity images are entirely self contained so once downloaded as a file they can be, for example, copied to a TRE or other secure non-internet connected system and run there without any further downloads or setup.

### Install from GitLab

Install by git clone, the script is intended to be run from the `conda-builds` folder.  
```
git clone https://gitlab.com/icr-rse/apps/coble.git
cd coble
```
## Example use

### From slurm
The main command takes the following parameters:
**sbatch**   
**bin/coble-slurm.sh**   
-o stdout log file  
-e stderr log file  
Then use the script bin/coble-slurm.sh with the following parameters that are the same as the bash script.

### From bash
**bin/coble-bash.sh**  
Usage: coble-bash.sh [OPTIONS]
```

Options:
  --steps STEPS           Colon-separated steps to execute
                          Available: conda, anaconda, create, install, recipe,
                          update, export, errors, missing, diff, diff-r, dry
                          Examples: 'conda:create:export' or 'create:export:missing'
  --input FILE            Input YAML/recipe(bash) file with package specifications
  --results DIR           Directory to store results (required)
  --r-version VERSION     R version (e.g., 4.4.2, 4.5.2)
  --python-version VER    Python version (e.g., 3.13.1, 3.14.0)
  --env DIR               Environment folder path
  --pkg DIR               Package cache folder path
  --output FILE           Output log file (for sbatch)
  --error FILE            Error log file (for sbatch)
  --extra VALUE           Extra parameter (used by some steps)
  ---- step=compare options ----
  --lhs-env PATH          Left-hand side conda environment path
  --rhs-env PATH          Right-hand side conda environment path
  --lhs-coble FILE        Left-hand side coble.yml file (contains all 3 package types)
  --rhs-coble FILE        Right-hand side coble.yml file (contains all 3 package types)
  --lhs-conda FILE        Left-hand side conda YAML file
  --rhs-conda FILE        Right-hand side conda YAML file
  --lhs-r FILE            Left-hand side R packages file
  --rhs-r FILE            Right-hand side R packages file
  --lhs-pip FILE          Left-hand side pip packages file
  --rhs-pip FILE          Right-hand side pip packages file
  --results DIR           Results directory (required)
  --output FILE           Output comparison file (optional)

Step Descriptions (all optional):
  conda/mamba/anaconda    - Select conda executable (conda vs mamba vs /opt/...anaconda)
  create                  - Create new conda environment with R and Python versions
  install                 - Install packages from input YAML file
  recipe                  - Execute bash recipe file line by line
  update                  - Add more packages to existing environment
  export                  - Export environment to YAML and package lists
  errors                  - Generate error report from logs
  missing                 - Report packages that failed to install
  convert                 - Convert recipe file to YAML format
  diff                    - Compare conda package versions between files
  diff-r                  - Compare R package versions between files
  dry                     - Dry run mode (log commands without executing)

Examples:
  # Create and export environment
  bin/coble-bash.sh --steps conda:create:export \
     --input ./data/full.yml \
     --results ./results/test \
     --r-version 4.5.2 \
     --python-version 3.14.0 \
     --env ./envs/test \
     --pkg ./pkgs/test

  # Run recipe and export
  bin/coble-bash.sh --steps conda:recipe:export \
     --input ./config/recipe.txt \
     --results ./results/recipe-run \
     --env ./envs/myenv \
     --pkg ./pkgs/myenv

  # Compare package versions
  bin/coble-bash.sh --steps compare \
  # Compare two environments
  bin/coble-bash.sh --lhs-env ./envs/old --rhs-env ./envs/new --results ./results

  # Compare environment to files
  bin/coble-bash.sh --lhs-env ./envs/current --rhs-conda ./old/env.yml --results ./results

  # Compare two coble.yml files
  bin/coble-bash.sh --lhs-coble ./v1/coble.yml --rhs-coble ./v2/coble.yml --results ./results

  # Compare two file sets
  bin/coble-bash.sh --lhs-conda ./v1/env.yml --lhs-r ./v1/r.txt --lhs-pip ./v1/pip.txt \
     --rhs-conda ./v2/env.yml --rhs-r ./v2/r.txt --rhs-pip ./v2/pip.txt \
     --results ./results

```

## Outputs

### Folder structure

**logs/**: Installation logs for troubleshooting (used by the 'errors' step). Written to from slurm in the -o and -e params.
```
logs/
├── output.log             # Standard output from installation (stdout)
└── error.log              # Standard error from installation (stderr)
```

### Key outputs
- **results/coble.yml**: Unified YAML containing all package types (conda, mamba, pip, R packages, BioConductor, GitHub repos, wget URLs, bash commands)
- **results/built-conda.yml**: Standard conda environment export
- **results/r_packages.txt**: R package list with versions
- **results/pip_packages.txt**: Python pip package list with versions
- **results/recipe.sh**: Executable bash script documenting all installation steps
```
results/
├── recipe.sh              # Auto-generated bash script to recreate the environment (from 'create', 'update' and 'recipe' steps)
├── error-report.txt       # Error analysis report (from 'errors' step)
├── installed-report.txt   # Missing packages report (from 'missing' step)
├── coble.yml              # Combined conda environment YAML with conda, pip, and R packages
├── built-conda.yml        # Conda environment YAML export
├── r_packages.txt         # List of installed R packages with versions
└── pip_packages.txt       # List of installed pip packages with versions
```

