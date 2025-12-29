#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2025
# Capture date: 2025-12-29
# Capture time: 14:43:26 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source "$(conda info --base)/etc/profile.d/conda.sh"
source ~/.bashrc
#####################################################


conda create --prefix ./myenv -y
conda activate ./myenv

# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels defaults
conda config --env --add channels r
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
#####################################################
# COBLE:Reproducible environment: BASIC, (c) ICR 2025
#####################################################
# note the reverse order of priority
# languages:
conda install -y 'conda-forge::python=3.13.1'
conda install -y -c conda-forge 'r-base=4.3.1'
# conda:
conda install -y  --no-update-deps \
'pandas' 
# r-conda:
conda install -y  --no-update-deps \
'r-tidyverse' \
'r-ggplot2' 
# pip:
python -m pip install 'requests' 
python -m pip install 'numpy' 

