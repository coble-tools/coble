#!/usr/bin/env bash

#######################################
# COBLE:Reproducible environment recipe, (c) ICR 2025
# Capture date: 2025-12-18
# Capture time: 10:58:50 GMT
# Captured by: ralcraft
#######################################
# source bashrc for conda
source "$(conda info --base)/etc/profile.d/conda.sh"
source ~/.bashrc
#######################################


conda create --name scomatic -y -c conda-forge -c defaults -c r
conda activate scomatic

# Channels section
conda config --remove-key channels
conda config --add channels conda-forge
conda config --add channels bioconda
conda config --add channels r
conda config --add channels defaults

# INSTALL SECTION FOR CONDA
conda install -y -c r 'r-base=3.6.1'
ln -sf /bin/x86_64-conda-linux-gnu-gcc /bin/x86_64-conda_cos6-linux-gnu-cc
Python python=3.7   python 3.7

# Including build tools for source installations
conda install -c conda-forge gcc_linux-64 gxx_linux-64 gfortran_linux-64 make -y
conda install -y -c conda-forge make pkg-config
ln -sf /bin/x86_64-conda-linux-gnu-gcc /bin/x86_64-conda_cos6-linux-gnu-cc
ln -sf /bin/x86_64-conda-linux-gnu-g++ /bin/x86_64-conda_cos6-linux-gnu-c++
ln -sf /bin/x86_64-conda-linux-gnu-gfortran /bin/x86_64-conda_cos6-linux-gnu-gfortran

conda install -y -c conda-forge 'samtools'  --no-update-deps
conda install -y -c conda-forge 'datamash'  --no-update-deps
conda install -y -c conda-forge 'bedtools'  --no-update-deps
python -m pip install about-time===3.1.1 
python -m pip install numpy===1.21.6 
python -m pip install numpy-groupies===0.9.14 
python -m pip install pandas===1.3.5 
python -m pip install pybedtools===0.8.1 
python -m pip install pysam===0.16.0.1 
python -m pip install rpy2===2.9.4 
python -m pip install scipy===1.7.3 
conda install -y -c bioconda 'r-VGAM=1.0_2'
