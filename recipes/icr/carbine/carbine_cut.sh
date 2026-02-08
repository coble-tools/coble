#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-07
# Capture time: 18:29:34 GMT
# Captured by: root
# Platform: 
#####################################################
# source bashrc for conda
source /root/.bashrc
# Using conda executable conda: /opt/conda/bin/conda
# Using conda alias conda: /opt/conda/bin/conda
#####################################################

# Detected platform: OS=linux, ARCH=x86_64, PLATFORM=linux-64
# Compiler packages: c-compiler cxx-compiler fortran-compiler
# Compiler packages: sysroot_linux-64
# Compiler packages: gcc_linux-64 gxx_linux-64 gfortran_linux-64
conda env remove --name carbine -y 2>/dev/null || true
conda create --no-default-packages --name carbine -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# activate environment
conda activate carbine

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels defaults
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
#####################################################
# COBLE:Reproducible environment: carbine, (c) ICR 2026
#####################################################
# languages:
conda install -y  \
  gcc_linux-64 gxx_linux-64 gfortran_linux-64 \
  sysroot_linux-64 \
  c-compiler cxx-compiler fortran-compiler \
  'r-base=4.4.3' r-remotes r-biocmanager
# Recommended tools: 
# Symlink all compiler/binutils tools

# Set up compiler symlinks for R package compilation - Linux x86_64
umask 0022
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++
# Standard compiler aliases
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/gcc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/c++
conda install -y  'python=3.12'
python -m site
conda env config vars set PYTHONNOUSERSITE=1
conda deactivate
conda activate carbine
# flags:
# Flag: Directive: dependencies, Value: na
conda env config vars set QT_QPA_PLATFORM=offscreen
conda deactivate
conda activate carbine

conda install -y \
'arviz' \
'pytz' \
'cmdstan=2.38.0' \
'cmdstanpy=1.3.0' \
'ipython' \
'matplotlib' \
'pandas=3.0.0' \
'scipy=1.17.0' \
'seaborn=0.13.2' \
'xz' 