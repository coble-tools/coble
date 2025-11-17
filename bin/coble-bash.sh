#!/usr/bin/env bash

# COBLE - COnda BuiLdEr
# Build and manage conda environments with support for conda, R, and pip packages
#
# Usage examples:
#   coble-bash.sh --steps create:export --input ./data/full.yml --results ./results --r-version 4.4.2 --python-version 3.13.1 --env ./envs/myenv --pkg ./pkgs/myenv
#
#   coble-bash.sh --steps conda:create:export:missing --input ./data/full.yml --results ./results/test --r-version 4.5.2 --python-version 3.14.0 --env ./envs/test --pkg ./pkgs/test

# Initialize variables
COBLE_SCRIPT_VERSION="0.1.0"  # Increment manually when releasing a new script version
steps=""
INPUT_YAML=""
RESULTS_DIR=""
R_VERSION=""
PYTHON_VERSION=""
ENV_FLDR=""
PKG_FLDR=""
OUTPUT_FILE=""
ERROR_FILE=""
extra="none"
quiet="n"
divert="n"
lhs_env=""
rhs_env=""
lhs_coble=""
rhs_coble=""
lhs_conda=""
rhs_conda=""
lhs_r=""
rhs_r=""
lhs_pip=""
rhs_pip=""
results_dir=""
comparison_output=""
# Check for help flag first
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] || [[ "$*" == *"--help"* ]] || [[ "$*" == *"-h"* ]]; then
  echo "Usage: coble-bash.sh [OPTIONS]"
  echo ""
  echo "COBLE - COnda BuiLdEr: Build and manage conda environments from the RSE team at the ICR"
  echo ""
  echo "(c) 2025 Rachel Alcraft"
  echo "Options:"
  echo "  --steps STEPS           Colon-separated steps to execute"
  echo "                          Available: conda, anaconda, create, install, recipe,"
  echo "                          update, export, errors, missing, diff, diff-r, dry"
  echo "                          Examples: 'conda:create:export' or 'create:export:missing'"
  echo "  --input FILE            Input YAML/recipe(bash) file with package specifications"
  echo "  --results DIR           Directory to store results (required)"
  echo "  --r-version VERSION     R version (e.g., 4.4.2, 4.5.2)"
  echo "  --python-version VER    Python version (e.g., 3.13.1, 3.14.0)"
  echo "  --env DIR               Environment folder path"
  echo "  --pkg DIR               Package cache folder path"
  echo "  --stdout FILE           Output log file (for sbatch)"
  echo "  --stderr FILE           Error log file (for sbatch)"
  echo "  --extra VALUE           Extra parameter (used by some steps)"
  echo "  --quiet y|n             Suppress informational messages (default: n)"
  echo "  --divert y|n            Divert output to files (default: n)"
  echo "  ---- step=compare options ----"
  echo "  --lhs-env PATH          Left-hand side conda environment path"
  echo "  --rhs-env PATH          Right-hand side conda environment path"
  echo "  --lhs-coble FILE        Left-hand side coble.yml file (contains all 3 package types)"
  echo "  --rhs-coble FILE        Right-hand side coble.yml file (contains all 3 package types)"
  echo "  --lhs-conda FILE        Left-hand side conda YAML file"
  echo "  --rhs-conda FILE        Right-hand side conda YAML file"
  echo "  --lhs-r FILE            Left-hand side R packages file"
  echo "  --rhs-r FILE            Right-hand side R packages file"
  echo "  --lhs-pip FILE          Left-hand side pip packages file"
  echo "  --rhs-pip FILE          Right-hand side pip packages file"
  echo "  --results DIR           Results directory (required)"
  echo "  --comparison-output FILE           Output comparison file (optional)"
  echo "  --version               Print COBLE script version and exit"
  echo ""
  echo "Step Descriptions (all optional):"
  echo "  conda/mamba/anaconda    - Select conda executable (conda vs mamba vs /opt/...anaconda)"
  echo "  create                  - Create new conda environment with R and Python versions"
  echo "  install                 - Install packages from input YAML file"
  echo "  recipe                  - Execute bash recipe file line by line"
  echo "  update                  - Add more packages to existing environment"
  echo "  export                  - Export environment to YAML and package lists"
  echo "  errors                  - Generate error report from logs"
  echo "  missing                 - Report packages that failed to install"
  echo "  convert                 - Convert recipe file to YAML format"
  echo "  diff                    - Compare conda package versions between files"
  echo "  diff-r                  - Compare R package versions between files"
  echo "  dry                     - Dry run mode (log commands without executing)"
  echo ""
  echo "Examples:"
  echo "  # Create and export environment"
  echo "  $0 --steps conda:create:export \\"
  echo "     --input ./data/full.yml \\"
  echo "     --results ./results/test \\"
  echo "     --r-version 4.5.2 \\"
  echo "     --python-version 3.14.0 \\"
  echo "     --env ./envs/test \\"
  echo "     --pkg ./pkgs/test"
  echo ""
  echo "  # Run recipe and export"
  echo "  $0 --steps conda:recipe:export \\"
  echo "     --input ./config/recipe.txt \\"
  echo "     --results ./results/recipe-run \\"
  echo "     --env ./envs/myenv \\"
  echo "     --pkg ./pkgs/myenv"
  echo ""
  echo "  # Compare package versions"
  echo "  $0 --steps compare \\"  
  echo "  # Compare two environments"
  echo "  $0 --lhs-env ./envs/old --rhs-env ./envs/new --results ./results"
  echo ""
  echo "  # Compare environment to files"
  echo "  $0 --lhs-env ./envs/current --rhs-conda ./old/env.yml --results ./results"
  echo ""
  echo "  # Compare two coble.yml files"
  echo "  $0 --lhs-coble ./v1/coble.yml --rhs-coble ./v2/coble.yml --results ./results"
  echo ""
  echo "  # Compare two file sets"
  echo "  $0 --lhs-conda ./v1/env.yml --lhs-r ./v1/r.txt --lhs-pip ./v1/pip.txt \\"
  echo "     --rhs-conda ./v2/env.yml --rhs-r ./v2/r.txt --rhs-pip ./v2/pip.txt \\"
  echo "     --results ./results"

  exit 0
fi

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --steps)
      steps="$2"
      shift 2
      ;;
    --input)
      INPUT_YAML="$2"
      shift 2
      ;;
    --results)
      RESULTS_DIR="$2"
      shift 2
      ;;
    --r-version)
      R_VERSION="$2"
      shift 2
      ;;
    --python-version)
      PYTHON_VERSION="$2"
      shift 2
      ;;
    --env)
      ENV_FLDR="$2"
      shift 2
      ;;
    --pkg)
      PKG_FLDR="$2"
      shift 2
      ;;
    --stdout)
      OUTPUT_FILE="$2"
      shift 2
      ;;
    --stderr)
      ERROR_FILE="$2"
      shift 2
      ;;
    --extra)
      extra="$2"
      shift 2
      ;;    
    --quiet)
      quiet="$2"
      shift 2
      ;;
    --divert)
      divert="$2"
      shift 2
      ;;
    --lhs-env)
      lhs_env="$2"
      shift 2
      ;;      
    --rhs-env)
      rhs_env="$2"
      shift 2
      ;;
    --lhs-coble)
      lhs_coble="$2"
      shift 2
      ;;
    --rhs-coble)
      rhs_coble="$2"
      shift 2
      ;;
    --lhs-conda)
      lhs_conda="$2"
      shift 2
      ;;
    --rhs-conda)
      rhs_conda="$2"
      shift 2
      ;;
    --lhs-r)
      lhs_r="$2"
      shift 2
      ;;
    --rhs-r)
      rhs_r="$2"
      shift 2
      ;;
    --lhs-pip)
      lhs_pip="$2"
      shift 2
      ;;
    --rhs-pip)
      rhs_pip="$2"
      shift 2
      ;;
    --comparison-output)
      comparison_output="$2"
      shift 2
      ;;
    --version)
      echo "coble-bash.sh version: ${COBLE_SCRIPT_VERSION}"; exit 0 ;;
    -h|--help)
      # Already handled above, this is just for completeness
      exit 0
      ;;    
    *)
      echo "Unknown option: $1"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

# Validate required inputs
if [ -z "$steps" ]; then
  echo "Error: --steps is required"
  echo "Use --help for usage information"
  exit 1
fi

if [ -z "$RESULTS_DIR" ]; then
  echo "Error: --results directory is required"
  exit 1
fi

# Set defaults for optional parameters
if [ -z "$OUTPUT_FILE" ]; then
  OUTPUT_FILE="$RESULTS_DIR/stdout.log"
fi

if [ -z "$ERROR_FILE" ]; then
  ERROR_FILE="$RESULTS_DIR/stderr.log"
fi

echo "Mamba environment creation script started at $(date)"
echo "Mamba environment creation script started at $(date)" >&2
echo "#################################################"
echo "CMD: steps: ${steps}"
echo "CMD: INPUT_YAML: ${INPUT_YAML}"
echo "CMD: RESULTS_DIR: ${RESULTS_DIR}"
echo "CMD: R_VERSION: ${R_VERSION}"
echo "CMD: PYTHON_VERSION: ${PYTHON_VERSION}"
echo "CMD: ENV_FLDR: ${ENV_FLDR}"
echo "CMD: PKG_FLDR: ${PKG_FLDR}"
echo "CMD: OUTPUT_FILE: ${OUTPUT_FILE}"
echo "CMD: ERROR_FILE: ${ERROR_FILE}"
echo "CMD: extra: ${extra}"


mkdir -p $RESULTS_DIR

conda_exe="conda"
if [[ $steps == "conda"* ]]; then
  conda_exe="conda"
elif [[ $steps == "anaconda"* ]]; then
  conda_exe="/opt/software/applications/anaconda/3/bin/conda"
elif [[ $steps == "mamba"* ]]; then
  conda_exe="mamba"
fi
# echo out the conda and the version
echo "Using conda executable: $conda_exe"
$conda_exe --version

dry_run="run"
if [[ $steps == *"dry"* ]]; then
  dry_run="dry"
fi
results_dir="$RESULTS_DIR"
new_mamba_prefix="$ENV_FLDR"
new_mamba_pkgs="$PKG_FLDR"
mamba_yaml_input="$INPUT_YAML"
mamba_yaml_output="$results_dir/built-conda.yml"
r_packages_output="$results_dir/r_packages.txt"
pip_packages_output="$results_dir/pip_packages.txt"
bash_script_output="$results_dir/recipe.sh"
coble_output="$results_dir/coble.yml"
error_report="$results_dir/error-report.txt"
done_report="$results_dir/done-report.txt"
installed_report="$results_dir/installed-report.txt"
r_version="r-base=$R_VERSION"
python_version="python=$PYTHON_VERSION"
copy_stdout="$results_dir/stdout.log"
copy_stderr="$results_dir/stderr.log"
mkdir -p $results_dir
#################################################


start_time=$(date +%s)
echo "Input-R version: $r_version"
echo "Input-Python version: $python_version"
echo "Input-New Mamba prefix: $new_mamba_prefix"
echo "Package folder: $new_mamba_pkgs"
echo "Input-Mamba environment file: $mamba_yaml_input"
echo "Output-New Mamba environment file: $mamba_yaml_output"
echo "Output-bash script file: $bash_script_output"
echo "Output-error report file: $error_report"
echo "Output-done report file: $done_report"
echo "Output-installed report file: $installed_report"
echo "Is dry or run: ${dry_run}"
echo "Set env varibale for export CONDA_PKGS_DIRS=$new_mamba_pkgs"
export CONDA_PKGS_DIRS=$new_mamba_pkgs
#################################################

source ~/.bashrc

# if the OUTPUT_FILE and ERROR_FILE are set, redirect stdout and stderr
if [ -n "$OUTPUT_FILE" ] && [ -n "$ERROR_FILE" ] && [ "$divert" == "y" ] ; then
  # first make sure the directory exists
  mkdir -p "$(dirname "$OUTPUT_FILE")"
  mkdir -p "$(dirname "$ERROR_FILE")"
  echo "Redirecting stdout to $OUTPUT_FILE and stderr to $ERROR_FILE"
  exec > >(tee -a "$OUTPUT_FILE") 2> >(tee -a "$ERROR_FILE" >&2)
fi

# init the bash script as empty if create or install is selected
if [[ $steps == *"create"* || $steps == *"install"* || $steps == *"recipe"* ]]; then
  echo "#!/bin/sh" > $bash_script_output
  echo "" >> $bash_script_output
  echo "#################################################" >> $bash_script_output
  echo "# Auto-generated script to recreate conda env" >> $bash_script_output
  echo "# Generated at $(date)" >> $bash_script_output
  echo "#################################################" >> $bash_script_output
  echo "" >> $bash_script_output
fi

#-CREATE-CREATE-CREATE-CREATE-CREATE-CREATE-CREATE-CREATE-CREATE-CREATE-CREATE-CREATE-CREATE-CREATE
if [[ $steps == *"create"* ]]; then  
  echo "=== >>> Creating initial conda environment: $conda_exe"
  echo "bin/conda-step-create.sh $conda_exe $new_mamba_prefix $new_mamba_pkgs $r_version $python_version $bash_script_output $quiet $dry_run"
  bash bin/conda-step-create.sh $conda_exe $new_mamba_prefix $new_mamba_pkgs $r_version $python_version $bash_script_output $quiet $dry_run
  echo "bin/conda-step-install.sh $conda_exe $new_mamba_prefix $new_mamba_pkgs $bash_script_output $mamba_yaml_input $quiet $dry_run"
  bash bin/conda-step-install.sh $conda_exe $new_mamba_prefix $new_mamba_pkgs $bash_script_output $mamba_yaml_input $quiet $dry_run
fi

#-RECIPE-RECIPE-RECIPE-RECIPE-RECIPE-RECIPE-RECIPE-RECIPE-RECIPE-RECIPE-RECIPE-RECIPE-RECIPE
if [[ $steps == *"recipe"* ]]; then  
  echo "=== >>> Running recipe from bash script: $mamba_yaml_input $bash_script_output $dry_run"
  echo "bin/conda-step-recipe.sh $mamba_yaml_input $bash_script_output $dry_run"
  bash bin/conda-step-recipe.sh $mamba_yaml_input $bash_script_output $dry_run
fi

#-UPDATE-UPDATE-UPDATE-UPDATE-UPDATE-UPDATE-UPDATE-UPDATE-UPDATE-UPDATE-UPDATE-UPDATE-UPDATE-UPDATE
if [[ $steps == *"update"* ]]; then  
  echo "=== >>> Additional conda file to process: $mamba_yaml_input"  
  bash bin/conda-step-install.sh $conda_exe $new_mamba_prefix $new_mamba_pkgs $bash_script_output $mamba_yaml_input $quiet $dry_run
fi
#-EXPORT-EXPORT-EXPORT-EXPORT-EXPORT-EXPORT-EXPORT-EXPORT-EXPORT-EXPORT-EXPORT-EXPORT-EXPORT-EXPORT
if [[ $steps == *"export"* ]]; then
  echo "=== >>> Exporting conda environment to yaml file: $mamba_yaml_output"
  echo "bin/conda-step-export.sh $new_mamba_prefix $mamba_yaml_output $r_packages_output $pip_packages_output $coble_output"
  bash bin/conda-step-export.sh $new_mamba_prefix $mamba_yaml_output $r_packages_output $pip_packages_output $coble_output
fi

# Copy stdout and stderr
# don't copy if they are the same file
if [ "$OUTPUT_FILE" != "$copy_stdout" ]; then
  cp $OUTPUT_FILE $copy_stdout
fi
if [ "$ERROR_FILE" != "$copy_stderr" ]; then
  cp $ERROR_FILE $copy_stderr
fi

#-COMPARE-COMPARE-COMPARE-COMPARE-COMPARE-COMPARE-COMPARE-COMPARE-COMPARE-COMPARE-COMPARE-COMPARE-COMPARE-COMPARE
if [[ $steps == *"compare"* ]]; then  
  echo "=== >>> Comparing package versions"
  echo "bin/conda-step-compare.sh $lhs_env $rhs_env $lhs_coble $rhs_coble $lhs_conda $rhs_conda $lhs_r $rhs_r $lhs_pip $rhs_pip $results_dir $comparison_output"
  bash bin/conda-step-compare.sh "$lhs_env" "$rhs_env" "$lhs_coble" "$rhs_coble" "$lhs_conda" "$rhs_conda" "$lhs_r" "$rhs_r" "$lhs_pip" "$rhs_pip" "$results_dir" "$comparison_output"
fi
#-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR-ERROR
if [[ $steps == *"errors"* ]]; then
  echo "=== >>> Producing error report to $error_report and $done_report..."
  echo "bash bin/conda-step-errors.sh $error_report $done_report $OUTPUT_FILE $ERROR_FILE"
  bash bin/conda-step-errors.sh $error_report $done_report $OUTPUT_FILE $ERROR_FILE
fi
#-MISSING-MISSING-MISSING-MISSING-MISSING-MISSING-MISSING-MISSING-MISSING-MISSING-MISSING-MISSING
if [[ $steps == *"missing"* ]]; then    
  if [[ $steps == *"update"* ]]; then
    echo "=== >>> Producing missing report to $extra..."
    echo "bin/conda-step-missing.sh $installed_report $extra $mamba_yaml_output $r_packages_output $pip_packages_output"
    bash bin/conda-step-missing.sh $installed_report $extra $mamba_yaml_output $r_packages_output $pip_packages_output
  else
    echo "=== >>> Producing missing report to $installed_report..."
    echo "bin/conda-step-missing.sh $installed_report $mamba_yaml_input $mamba_yaml_output $r_packages_output $pip_packages_output"
    bash bin/conda-step-missing.sh $installed_report $mamba_yaml_input $mamba_yaml_output $r_packages_output $pip_packages_output
  fi
fi
#-CONVERT-CONVERT-CONVERT-CONVERT-CONVERT-CONVERT-CONVERT-CONVERT-CONVERT-CONVERT-CONVERT-CONVERT
if [[ $steps == *"convert"* ]]; then  
  echo "=== >>> Converting recipe file to YAML: $mamba_yaml_input to $results_dir/coble-recipe.yml"
  echo "bin/conda-step-recipe-scan.sh $mamba_yaml_input $results_dir/coble-recipe.yml"
  bash bin/conda-step-recipe-scan.sh $mamba_yaml_input "$results_dir/coble-recipe.yml"
fi
#-DIFF-DIFF==-DIFF-DIFF==-DIFF-DIFF==-DIFF-DIFF==-DIFF-DIFF==-DIFF-DIFF==-DIFF-DIFF==-DIFF-DIFF==
if [[ $steps == *"diff"* ]]; then
  diff_file="$extra"
  is_versions=False
  if [[ $steps == *"diff-r"* ]]; then
    echo "=== >>> Diffing r packages: $diff_file vs $r_packages_output"
    bash bin/conda-step-diff.sh $installed_report $r_packages_output $diff_file
  else
    echo "=== >>> Diffing conda packages: $diff_file vs $mamba_yaml_output"
    bash bin/conda-step-diff.sh $installed_report $mamba_yaml_output $diff_file
  fi
  
fi

echo "###################################################################"
echo "All steps completed successfully at $(date)."
echo "Time taken: $(($(date +%s) - $start_time)) seconds."
echo "###################################################################"
