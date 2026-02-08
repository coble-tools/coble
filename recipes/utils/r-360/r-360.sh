#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-08
# Capture time: 22:05:57 GMT
# Captured by: ralcraft
# Platform: 
#####################################################
# source bashrc for conda
CONDA_BASE=$(conda info --base 2>/dev/null)
[ -z "$CONDA_BASE" ] && CONDA_BASE="/home/ralcraft/miniforge3"
source "${CONDA_BASE}/etc/profile.d/conda.sh"
conda deactivate 2>/dev/null || true
# Using conda executable /home/ralcraft/miniforge3/bin/conda
# Using conda alias /home/ralcraft/miniforge3/bin/conda
# CONDA base /home/ralcraft/miniforge3
# Target environment r-360
# Target path /home/ralcraft/miniforge3/envs/r-360
#####################################################

# Detected platform: OS=linux, ARCH=x86_64, PLATFORM=linux-64
# Compiler packages: c-compiler cxx-compiler fortran-compiler
# Compiler packages: sysroot_linux-64
# Compiler packages: gcc_linux-64 gxx_linux-64 gfortran_linux-64
conda env remove --name r-360 -y 2>/dev/null || true
conda create --no-default-packages --name r-360 -y
conda config --env --set solver classic
export PYTHONNOUSERSITE=1
unset PYTHONPATH
umask 0022
# activate environment
conda activate r-360

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels || true
conda config --env --set channel_priority strict
echo '=== Channel Config Check ===' >&2
conda config --env --show channels >&2
conda config --env --show channel_priority >&2
echo '===========================' >&2
conda config --env --add channels defaults
conda config --env --add channels conda-forge
conda config --env --add channels bioconda
conda config --env --add channels r

# INSTALL SECTION FOR CONDA
#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
# flags:
conda config --env --set channel_priority flexible
# languages:
# Setting compile tools version to 7.5.0
# Setting compile order: first
# Setting env sims: true
# Setting base sims: true
echo '=== Channel Config Check ===' >&2
conda config --env --show channels >&2
conda config --env --show channel_priority >&2
echo '===========================' >&2
# Detected R package: r-base=3.6.0 with compile order first
# Installing compilers first
conda install -y  \
  'gcc_linux-64=7.5.0' 'gxx_linux-64=7.5.0' 'gfortran_linux-64=7.5.0' \
  sysroot_linux-64

# Set up compiler symlinks for R package compilation - Linux x86_64
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++
# Standard compiler aliases
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/gcc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/c++
conda env config vars set CC="$CONDA_PREFIX/bin/gcc"
conda env config vars set CXX="$CONDA_PREFIX/bin/g++"
conda env config vars set FC="$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran"
conda env config vars set F77="$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran"
conda env config vars set CFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set CXXFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set CPPFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib"
conda env config vars set LD_LIBRARY_PATH="$CONDA_PREFIX/lib:$LD_LIBRARY_PATH"
conda deactivate
conda activate r-360

# Base sims enabled - adding base simlinks prior to installation
# Creating compiler symlinks in base conda for R 3.6.0 compatibility...
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc /home/ralcraft/miniforge3/bin/x86_64-conda-linux-gnu-gcc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran /home/ralcraft/miniforge3/bin/x86_64-conda-linux-gnu-gfortran
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-f95 /home/ralcraft/miniforge3/bin/x86_64-conda-linux-gnu-f95
ln -sf $CONDA_PREFIX/bin/gcc /home/ralcraft/miniforge3/bin/gcc
ln -sf $CONDA_PREFIX/bin/g++ /home/ralcraft/miniforge3/bin/g++
ln -sf $CONDA_PREFIX/bin/gfortran /home/ralcraft/miniforge3/bin/gfortran
ln -sf $CONDA_PREFIX/bin/f95 /home/ralcraft/miniforge3/bin/f95
ln -sf $CONDA_PREFIX/bin/c++ /home/ralcraft/miniforge3/bin/c++
ln -sf $CONDA_PREFIX/bin/cc /home/ralcraft/miniforge3/bin/cc
# Installing R base version 3.6.0 separately
conda install -y  r-base=3.6.0 r-remotes r-biocmanager
# flags:
# Flag: Directive: dependencies, Value: na
conda config --env --set channel_priority strict
conda config --env --add channels bioconda
conda config --env --add channels conda-forge
# r-conda:
conda install -y  --no-update-deps \
'r-ggplot2' 


# Validate script available in environment at CONDA PREFIX: validate.sh
cp recipes/utils/r-360/validate/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh

