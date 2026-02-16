#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-16
# Capture time: 21:24:12 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi
# Using conda executable conda: /home/ralcraft/miniforge3/condabin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/condabin/conda
#####################################################

conda env remove --name r-362-conda -y 2>/dev/null || true
conda create --no-default-packages --name r-362-conda -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate r-362-conda

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
# compilers:
# Flag: Directive: cran-repo, Value: 
# flags:
# Compile version 7.5 on linux for architecture x86_64
conda install -y --solver=libmamba --no-update-deps -c conda-forge sysroot_linux-64 c-compiler cxx-compiler
# Detected Linux x86_64 - using linux-64 compilers
conda install -y --solver=libmamba --no-update-deps -c conda-forge 'gcc_linux-64=7.5' 'gxx_linux-64=7.5' 'gfortran_linux-64=7.5'
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/gcc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran $CONDA_PREFIX/bin/gfortran
ln -sf /usr/bin/ld ${CONDA_PREFIX}/x86_64-conda-linux-gnu/bin/ld
# languages:
CONDA_BASE=$(conda info --base)
ARCH=$(uname -m)

# deps: --no-update-deps
conda install -y --solver=libmamba --no-update-deps 'r-base=3.6.2'
conda install -y --solver=libmamba --no-update-deps r-remotes r-biocmanager
# conda:
conda install -y --solver=libmamba --no-update-deps \
'libcurl' 
# r-conda:
conda install -y --solver=libmamba --no-update-deps \
'r-matrix' \
'r-survival' \
'r-curl' \
'r-httr' \
'r-testthat' \
'r-ggplot2' \
'r-isoband' 
# bioc-conda:
conda install -y --solver=libmamba --no-update-deps \
'bioconductor-s4vectors' 
# r-package:
Rscript -e 'install.packages("remotes", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=1, method="wget")'
Rscript -e 'install.packages("BiocManager", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=1, method="wget")'
Rscript -e 'install.packages("tidyverse", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=1, method="wget")'
Rscript -e 'install.packages("data.table", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=1, method="wget")'
Rscript -e 'install.packages("devtools", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=1, method="wget")'
# bioc-package:
Rscript -e 'BiocManager::install("DESEq2", dependencies=NA, Ncpus=1)'
Rscript -e 'BiocManager::install("GenomicRanges", dependencies=NA, Ncpus=1)'

# Validate script available in environment at CONDA PREFIX: validate.sh
cp recipes/utils/r-362-conda/validate/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh

