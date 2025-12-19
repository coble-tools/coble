#!/usr/bin/env bash

#######################################
# COBLE:Reproducible environment recipe, (c) ICR 2025
# Capture date: 2025-12-18
# Capture time: 12:11:18 GMT
# Captured by: ralcraft
#######################################
# source bashrc for conda
source "$(conda info --base)/etc/profile.d/conda.sh"
source ~/.bashrc
#######################################


conda create --name scomatic -y
conda activate scomatic

# Channels section
conda config --remove-key channels
conda config --add channels conda-forge
conda config --add channels bioconda
conda config --add channels r
conda config --add channels defaults

# INSTALL SECTION FOR CONDA
conda install -y -c r 'r-base=3.6.1'
conda install -y 'python=3.7'

# Including build tools for source installations
conda install -c conda-forge gcc_linux-64 gxx_linux-64 gfortran_linux-64 make -y
conda install -y -c conda-forge make pkg-config
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-gfortran

conda install -y -c bioconda 'pysam=0.16.0.1'  --no-update-deps
conda install -y -c conda-forge 'samtools'  --no-update-deps
conda install -y -c conda-forge 'datamash'  --no-update-deps
conda install -y -c conda-forge 'bedtools'  --no-update-deps
conda install -y -c conda-forge 'about-time=3.1.1'  --no-update-deps
conda install -y -c conda-forge 'numpy=1.21.6'  --no-update-deps
conda install -y -c conda-forge 'pandas=1.3.5'  --no-update-deps
conda install -y -c bioconda 'pybedtools=0.8.1'  --no-update-deps
conda install -y -c conda-forge 'rpy2=2.9.4'  --no-update-deps
conda install -y -c conda-forge 'scipy=1.7.3'  --no-update-deps
python -m pip install 'numpy-groupies=0.9.14' 
conda install -y -c conda-forge 'r-VGAM'  --no-update-deps
