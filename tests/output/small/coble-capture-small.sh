#!/usr/bin/env bash

#######################################
# COBLE:Reproducible environment recipe, (c) ICR 2025
# Capture date: 2025-12-16
# Capture time: 12:13:21 GMT
# Captured by: ralcraft
#######################################
# source bashrc for conda
source "$(conda info --base)/etc/profile.d/conda.sh"
source ~/.bashrc
#######################################


conda create --name small -y -c conda-forge 'python=3.14.0'
conda activate small

# Channels section
conda config --remove-key channels
conda config --add channels conda-forge
conda config --add channels bioconda

# INSTALL SECTION FOR CONDA
python -m pip install requests 
