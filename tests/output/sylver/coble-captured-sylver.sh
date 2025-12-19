#!/usr/bin/env bash

#######################################
# COBLE:Reproducible environment recipe, (c) ICR 2025
# Capture date: 2025-12-18
# Capture time: 09:07:07 GMT
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
conda install -y -c r 'r-base=3.6.0'
conda install -c conda-forge gcc_linux-64 gxx_linux-64 gfortran_linux-64 make -y
conda install -y -c conda-forge make pkg-config
ln -sf /home/ralcraft/.conda/envs/sylver/bin/x86_64-conda-linux-gnu-gcc /home/ralcraft/.conda/envs/sylver/bin/x86_64-conda_cos6-linux-gnu-cc
ln -sf /home/ralcraft/.conda/envs/sylver/bin/x86_64-conda-linux-gnu-g++ /home/ralcraft/.conda/envs/sylver/bin/x86_64-conda_cos6-linux-gnu-c++
ln -sf /home/ralcraft/.conda/envs/sylver/bin/x86_64-conda-linux-gnu-gfortran /home/ralcraft/.conda/envs/sylver/bin/x86_64-conda_cos6-linux-gnu-gfortran
conda install -y -c conda-forge 'r-remotes'  --no-update-deps
conda install -y -c conda-forge 'r-devtools'  --no-update-deps
conda install -y -c conda-forge 'r-biocmanager'  --no-update-deps
Rscript -e 'remotes::install_version("limma", version="3.42.2", dependencies=TRUE, repos=BiocManager::repositories())'
