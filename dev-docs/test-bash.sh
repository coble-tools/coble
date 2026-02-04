#!/usr/bin/env bash

# Source the conda profile script directly (more reliable in scripts)
source /home/rachel/miniforge3/etc/profile.d/conda.sh

# Try to activate a test environment (replace base with your env if needed)
conda activate base

#!/bin/bash
#set -x
#export PS1="force-interactive"
#source ~/.bashrc
#type conda
#conda activate base
#echo "CONDA_DEFAULT_ENV=$CONDA_DEFAULT_ENV"
which python
python --version

# Check if conda environment is activated
if [[ "$CONDA_DEFAULT_ENV" == "base" ]]; then
    echo "SUCCESS: Conda environment 'base' activated."
    which python
    python --version
else
    echo "ERROR: Failed to activate Conda environment 'base'."
    exit 1
fi