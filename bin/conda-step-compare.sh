#!/usr/bin/env bash

# Unified comparison script for conda environments
# Can compare environments directly, exported files, or a mix of both
# Automatically exports missing files to results directory

# Usage examples:
# Compare two environments:
#   conda-compare-unified.sh --lhs-env ./envs/env1 --rhs-env ./envs/env2 --results ./results/comparison
#
# Compare environment to exported files:
#   conda-compare-unified.sh --lhs-env ./envs/env1 --rhs-conda ./results/env2.yml --rhs-r ./results/r_pkgs.txt --results ./results
#
# Compare two sets of files:
#   conda-compare-unified.sh --lhs-conda ./old/conda.yml --lhs-r ./old/r.txt --lhs-pip ./old/pip.txt \
#                            --rhs-conda ./new/conda.yml --rhs-r ./new/r.txt --rhs-pip ./new/pip.txt --results ./results

# Initialize variables
lhs_env=$1
rhs_env=$2
lhs_coble=$3
rhs_coble=$4
lhs_conda=$5
rhs_conda=$6
lhs_r=$7
rhs_r=$8
lhs_pip=$9
rhs_pip="${10}"
results_dir="${11}"
comparison_output="${12}"

# Validate inputs
if [ -z "$results_dir" ]; then
  echo "Error: --results directory is required"
  exit 1
fi

if [ -z "$lhs_env" ] && [ -z "$lhs_conda" ] && [ -z "$lhs_coble" ]; then
  echo "Error: Must specify either --lhs-env, --lhs-coble, or --lhs-conda"
  exit 1
fi

if [ -z "$rhs_env" ] && [ -z "$rhs_conda" ] && [ -z "$rhs_coble" ]; then
  echo "Error: Must specify either --rhs-env, --rhs-coble, or --rhs-conda"
  exit 1
fi

# Create results directory
mkdir -p "$results_dir"

# Set default comparison output
if [ -z "$comparison_output" ]; then
  comparison_output="$results_dir/comparison.txt"
fi

echo "========================================" | tee $comparison_output
echo "UNIFIED CONDA ENVIRONMENT COMPARISON" | tee -a $comparison_output
echo "========================================" | tee -a $comparison_output
echo "Comparison Date: $(date)" | tee -a $comparison_output
echo "Results Directory: $results_dir" | tee -a $comparison_output
echo "========================================" | tee -a $comparison_output
echo "" | tee -a $comparison_output

source ~/.bashrc

# Initialize conda for bash shell
if [ -f "${CONDA_EXE%/bin/conda}/etc/profile.d/conda.sh" ]; then
    source "${CONDA_EXE%/bin/conda}/etc/profile.d/conda.sh"
elif [ -f "/opt/conda/etc/profile.d/conda.sh" ]; then
    source "/opt/conda/etc/profile.d/conda.sh"
elif [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
    source "$HOME/miniconda3/etc/profile.d/conda.sh"
elif [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
    source "$HOME/anaconda3/etc/profile.d/conda.sh"
fi

# Function to handle environment export or file copy
process_side() {
  local side=$1
  local env_var=$2
  local coble_var=$3
  local conda_var=$4
  local r_var=$5
  local pip_var=$6
  local prefix=$7
  
  if [ -n "$env_var" ]; then
    echo ">>> Exporting $side environment from $env_var" | tee -a $comparison_output
    # Current export script expects 5 args and writes a single coble file
    bash bin/conda-step-export.sh "$env_var" \
      "$results_dir/${prefix}_conda.yml" \
      "$results_dir/${prefix}_r.txt" \
      "$results_dir/${prefix}_pip.txt" \
      "$results_dir/${prefix}_coble.yml"

    # Set variables to exported files
    eval "${prefix}_conda=\"$results_dir/${prefix}_conda.yml\""
    eval "${prefix}_r=\"$results_dir/${prefix}_r.txt\""
    eval "${prefix}_pip=\"$results_dir/${prefix}_pip.txt\""
    eval "${prefix}_coble=\"$results_dir/${prefix}_coble.yml\""
  else
    if [ -n "$coble_var" ]; then
      echo ">>> Copying $side coble file $coble_var" | tee -a $comparison_output
      cp "$coble_var" "$results_dir/${prefix}_coble.yml"
      eval "${prefix}_coble=\"$results_dir/${prefix}_coble.yml\""
    fi
    if [ -n "$conda_var" ]; then
      echo ">>> Copying $side conda file $conda_var" | tee -a $comparison_output
      cp "$conda_var" "$results_dir/${prefix}_conda.yml"
      eval "${prefix}_conda=\"$results_dir/${prefix}_conda.yml\""
    fi
    if [ -n "$r_var" ]; then
      echo ">>> Copying $side R packages file $r_var" | tee -a $comparison_output
      cp "$r_var" "$results_dir/${prefix}_r.txt"
      eval "${prefix}_r=\"$results_dir/${prefix}_r.txt\""
    fi
    if [ -n "$pip_var" ]; then
      echo ">>> Copying $side pip packages file $pip_var" | tee -a $comparison_output
      cp "$pip_var" "$results_dir/${prefix}_pip.txt"
      eval "${prefix}_pip=\"$results_dir/${prefix}_pip.txt\""
    fi    
  fi
}

# Process left-hand side
process_side "left-hand side" "$lhs_env" "$lhs_coble" "$lhs_conda" "$lhs_r" "$lhs_pip" "lhs"

# Process right-hand side
process_side "right-hand side" "$rhs_env" "$rhs_coble" "$rhs_conda" "$rhs_r" "$rhs_pip" "rhs"





# Cleanup
rm -rf $tmp_dir

echo ">>> Comparison complete!"
