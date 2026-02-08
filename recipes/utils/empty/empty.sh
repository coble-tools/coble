#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-08
# Capture time: 17:02:53 GMT
# Captured by: ralcraft
# Platform: 
#####################################################
# source bashrc for conda
CONDA_BASE=$(conda info --base 2>/dev/null)
[ -z "$CONDA_BASE" ] && CONDA_BASE="/home/ralcraft/miniforge3"
source "${CONDA_BASE}/etc/profile.d/conda.sh"
conda deactivate 2>/dev/null || true
# Using conda executable /home/ralcraft/miniforge3/condabin/conda: /home/ralcraft/miniforge3/condabin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/condabin/conda
# CONDA base /home/ralcraft/miniforge3/envs/pytest
# Target environment empty
# Target path /home/ralcraft/miniforge3/envs/pytest/envs/empty
#####################################################

# Detected platform: OS=linux, ARCH=x86_64, PLATFORM=linux-64
# Compiler packages: c-compiler cxx-compiler fortran-compiler
# Compiler packages: sysroot_linux-64
# Compiler packages: gcc_linux-64 gxx_linux-64 gfortran_linux-64
/home/ralcraft/miniforge3/condabin/conda env remove --name empty -y 2>/dev/null || true
/home/ralcraft/miniforge3/condabin/conda create --no-default-packages --name empty -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
umask 0022
# activate environment
conda activate empty

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
/home/ralcraft/miniforge3/condabin/conda config --env --remove-key channels || true
/home/ralcraft/miniforge3/condabin/conda config --env --set channel_priority strict
/home/ralcraft/miniforge3/condabin/conda config --env --add channels bioconda
/home/ralcraft/miniforge3/condabin/conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
# languages:
conda install -y  'python=3.12'
python -m site
/home/ralcraft/miniforge3/condabin/conda env config vars set PYTHONNOUSERSITE=1
conda deactivate
conda activate empty
# flags:
# Flag: Directive: dependencies, Value: na

# Validate script available in environment at CONDA PREFIX: validate.sh
cp recipes/utils/empty/validate/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh

