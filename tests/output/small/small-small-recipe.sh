#!/usr/bin/env bash

#######################################
# COBLE:Reproducible environment recipe, (c) ICR 2025
# Capture date: 2025-12-15
# Capture time: 21:49:51 GMT
# Captured by: ralcraft
#######################################


conda create --name small -y -c conda-forge 'python=3.14.0'
conda activate small

# Channels section
conda config --remove-key channels
conda config --add channels conda-forge
conda config --add channels bioconda

# INSTALL SECTION FOR CONDA
python -m pip install requests 
