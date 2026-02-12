#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-12
# Capture time: 13:59:52 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi
# Using conda executable conda: /home/ralcraft/miniforge3/condabin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/condabin/conda
#####################################################

conda env remove --name r-360-conda -y 2>/dev/null || true
conda create --no-default-packages --name r-360-conda -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate r-360-conda

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels r

# INSTALL SECTION FOR CONDA
#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
# compilers:
# Flag: Directive: cran-repo, Value: 
# languages:
CONDA_BASE=$(conda info --base)
ARCH=$(uname -m)

conda install -y  -c r 'r-base=3.6.0'
# bash:
conda config --env --remove channels r
# flags:
conda config --env --add channels bioconda
conda config --env --add channels conda-forge
# compilers:

# Language compile tools
conda install -y --no-update-deps -c conda-forge 'gcc_linux-64=7' 'gxx_linux-64=7' 'gfortran_linux-64=7'
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
conda env config vars set CC="$CONDA_PREFIX/bin/gcc"
conda env config vars set CXX="$CONDA_PREFIX/bin/g++"
conda env config vars set FC="$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran"
conda env config vars set F77="$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran"
conda env config vars set CFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set CXXFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set CPPFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib --sysroot=$CONDA_PREFIX/x86_64-conda-linux-gnu/sysroot"
# Also as export to avoid de/activations
export CC="$CONDA_PREFIX/bin/gcc"
export CXX="$CONDA_PREFIX/bin/g++"
export FC="$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran"
export F77="$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran"
export CFLAGS="-I$CONDA_PREFIX/include"
export CXXFLAGS="-I$CONDA_PREFIX/include"
export CPPFLAGS="-I$CONDA_PREFIX/include"
export LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib --sysroot=$CONDA_PREFIX/x86_64-conda-linux-gnu/sysroot"

# r-package:
Rscript -e 'install.packages("remotes", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=TRUE, Ncpus=1, method="wget")'
Rscript -e 'install.packages("biocmanager", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=TRUE, Ncpus=1, method="wget")'
Rscript -e 'install.packages("tidyverse", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=TRUE, Ncpus=1, method="wget")'

# Validate script available in environment at CONDA PREFIX: validate.sh
cp recipes/utils/r-360-conda/validate/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh

