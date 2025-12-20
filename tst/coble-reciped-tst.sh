#!/usr/bin/env bash

#######################################
# COBLE:Reproducible environment recipe, (c) ICR 2025
# Capture date: 2025-12-20
# Capture time: 16:50:43 GMT
# Captured by: ralcraft
#######################################
# source bashrc for conda
source "$(conda info --base)/etc/profile.d/conda.sh"
source ~/.bashrc
#######################################


conda create --name tst -y
conda activate tst

# Channels section
conda config --remove-key channels

# INSTALL SECTION FOR CONDA

# languages:
conda install -y 'python=3.14.0'

# flags:
# Flag: Directive: dependencies, Value: true
# Flag: Directive: build-tools, Value: true

# Including build tools for source installations
conda install -y -c conda-forge gcc_linux-64 gxx_linux-64 gfortran_linux-64 make r-remotes
conda install -y -c conda-forge -c bioconda r-cpp11 r-openssl r-rsqlite
conda install -y -c conda-forge make pkg-config
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-gfortran


# conda:
conda install -y -c conda-forge -c bioconda  --no-update-deps \
'pandas' 

# pip:
python -m pip install numpy 
python -m pip install git+https://github.com/ICR-RSE-Group/gitalma.git 
