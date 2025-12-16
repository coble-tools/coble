#!/usr/bin/env bash

#######################################
# COBLE:Reproducible environment recipe, (c) ICR 2025
# Capture date: 2025-12-16
# Capture time: 21:15:39 GMT
# Captured by: ralcraft
#######################################
# source bashrc for conda
source "$(conda info --base)/etc/profile.d/conda.sh"
source ~/.bashrc
#######################################


conda create --name sylver -y -c conda-forge -c defaults -c r 'r-base=3.6.0'
conda activate sylver

# Channels section
conda config --remove-key channels
conda config --add channels conda-forge
conda config --add channels r
conda config --add channels bioconda
conda config --add channels defaults

# INSTALL SECTION FOR CONDA
