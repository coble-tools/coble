#!/usr/bin/env bash

#######################################
# COBLE:Reproducible environment recipe, (c) ICR 2025
# Capture date: 2025-12-16
# Capture time: 12:17:44 GMT
# Captured by: ralcraft
#######################################
# source bashrc for conda
source "$(conda info --base)/etc/profile.d/conda.sh"
source ~/.bashrc
#######################################


conda create --name latest -y -c conda-forge 'python=3.14.0' 'r-base=4.5.2'
conda activate latest

# Channels section
conda config --remove-key channels
conda config --add channels conda-forge
conda config --add channels bioconda

# INSTALL SECTION FOR CONDA
