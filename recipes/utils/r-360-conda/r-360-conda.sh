#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-16
# Capture time: 17:32:40 GMT
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

conda install -y --solver=libmamba  -c r 'r-base=3.6.0'
# bash:
conda config --env --remove channels r
# compilers:

# Language compile tools
conda install -y --solver=libmamba --no-update-deps -c conda-forge compilers
# flags:
conda config --env --add channels bioconda
conda config --env --add channels conda-forge
# bash:
# This sed line is required when mixing r versions from the r channel with conda-forge source installs
sed -i 's/x86_64-conda_cos6-linux-gnu/x86_64-conda-linux-gnu/g' ${CONDA_PREFIX}/lib/R/etc/Makeconf
# conda:
conda install -y --solver=libmamba --no-update-deps \
'libcurl' 
# r-conda:
conda install -y --solver=libmamba --no-update-deps \
'r-matrix' \
'r-survival' \
'r-curl' \
'r-httr' 
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
cp recipes/utils/r-360-conda/validate/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh

