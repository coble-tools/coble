#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-16
# Capture time: 11:09:22 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi
# Using conda executable conda: /home/ralcraft/miniforge3/envs/pytest/bin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/envs/pytest/bin/conda
#####################################################

conda env remove --name r-nightly -y 2>/dev/null || true
conda create --no-default-packages --name r-nightly -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate r-nightly

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels defaults
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
# compilers:

# Language compile tools
conda install -y --solver=libmamba --no-update-deps -c conda-forge compilers
# languages:
CONDA_BASE=$(conda info --base)
ARCH=$(uname -m)

# R source installation requested
bash "/home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble-r-source.sh" "devel"
# flags:
# Flag: Directive: dependencies, Value: na
# r-package:
Rscript -e 'install.packages("tidyverse", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=1, method="wget")'

# Validate script available in environment at CONDA PREFIX: validate.sh
cp recipes/utils/r-nightly/validate/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh

