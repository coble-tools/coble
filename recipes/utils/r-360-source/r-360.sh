#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-11
# Capture time: 23:54:26 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi
# Using conda executable conda: /home/ralcraft/miniforge3/condabin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/condabin/conda
#####################################################

conda env remove --name r-360 -y 2>/dev/null || true
conda create --no-default-packages --name r-360 -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate r-360

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels r
conda config --env --add channels bioconda
conda config --env --add channels conda-forge
conda config --env --add channels defaults

# INSTALL SECTION FOR CONDA
#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
# compilers:

# Language compile tools
conda install -y --no-update-deps -c conda-forge 'gcc_linux-64=7.5.0' 'gxx_linux-64=7.5.0' 'gfortran_linux-64=7.5.0'
conda install -y --no-update-deps -c conda-forge sysroot_linux-64 c-compiler cxx-compiler
# Set up compiler symlinks for R package compilation - COS6 compatibility
umask 0022
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-gfortran
# Set up compiler symlinks for R package compilation - standard aliases
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/gcc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/c++
# Set compiler flags for R package compilation
conda env config vars set CC="/home/ralcraft/miniforge3/envs/r-360/bin/gcc"
conda env config vars set CXX="/home/ralcraft/miniforge3/envs/r-360/bin/g++"
conda env config vars set FC="/home/ralcraft/miniforge3/envs/r-360/bin/x86_64-conda-linux-gnu-gfortran"
conda env config vars set F77="/home/ralcraft/miniforge3/envs/r-360/bin/x86_64-conda-linux-gnu-gfortran"
conda env config vars set CFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set CXXFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set CPPFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib --sysroot=$CONDA_PREFIX/x86_64-conda-linux-gnu/sysroot"
# Also as export to avoid de/activations
export CC="/home/ralcraft/miniforge3/envs/r-360/bin/gcc"
export CXX="/home/ralcraft/miniforge3/envs/r-360/bin/g++"
export FC="/home/ralcraft/miniforge3/envs/r-360/bin/x86_64-conda-linux-gnu-gfortran"
export F77="/home/ralcraft/miniforge3/envs/r-360/bin/x86_64-conda-linux-gnu-gfortran"
export CFLAGS="-I$CONDA_PREFIX/include"
export CXXFLAGS="-I$CONDA_PREFIX/include"
export CPPFLAGS="-I$CONDA_PREFIX/include"
export LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib --sysroot=$CONDA_PREFIX/x86_64-conda-linux-gnu/sysroot"

# Flag: Directive: cran-repo, Value: 
# conda:
conda install -y  --no-update-deps \
'sysroot_linux-64=2.17' 
# bash:
unset LD_LIBRARY_PATH
# languages:
CONDA_BASE=$(conda info --base)
ARCH=$(uname -m)

# R source installation requested
bash "/home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble-r-source.sh" "3.6.0"
# flags:
# Flag: Directive: dependencies, Value: na
conda config --env --set channel_priority strict
conda config --env --add channels bioconda
conda config --env --add channels conda-forge
# r-package:
Rscript -e 'install.packages("remotes", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=1, method="wget")'
Rscript -e 'install.packages("biocmanager", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=1, method="wget")'
Rscript -e 'install.packages("tidyverse", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=1, method="wget")'

# Validate script available in environment at CONDA PREFIX: validate.sh
cp recipes/utils/r-360/validate/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh

