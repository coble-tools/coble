#!/usr/bin/env bash

#######################################
# COBLE:Reproducible environment recipe, (c) ICR 2025
# Capture date: 2025-12-17
# Capture time: 12:41:23 GMT
# Captured by: ralcraft
#######################################
# source bashrc for conda
source "$(conda info --base)/etc/profile.d/conda.sh"
source ~/.bashrc
#######################################


conda create --name sylver -y -c conda-forge -c defaults -c r
conda activate sylver

# Channels section
conda config --remove-key channels
conda config --add channels conda-forge
conda config --add channels r
conda config --add channels bioconda
conda config --add channels defaults

# INSTALL SECTION FOR CONDA
conda install -c r r-base=3.6.0
conda install -y 'r-BiocManager' -c conda-forge  --no-update-deps
unknown
unknown
conda install -c bioconda bioconductor-limma
conda install -c conda-forge r-effsize
conda install -c conda-forge r-magrittr
conda install -c conda-forge r-tidyverse
conda install -y 'r-BiocManager' -c conda-forge  --no-update-deps
conda install -y 'r-BiocManager' -c conda-forge  --no-update-deps
unknown
unknown
