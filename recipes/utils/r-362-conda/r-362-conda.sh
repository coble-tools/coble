#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-12
# Capture time: 09:42:34 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi
# Using conda executable conda: /home/ralcraft/miniforge3/bin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/bin/conda
#####################################################

conda env remove --name r-362-conda -y 2>/dev/null || true
conda create --no-default-packages --name r-362-conda -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y
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
conda config --env --add channels defaults
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
# compilers:
# Flag: Directive: cran-repo, Value: 
# languages:
CONDA_BASE=$(conda info --base)
ARCH=$(uname -m)

conda install -y  'r-base=3.6.2' r-remotes r-biocmanager
# bioc-conda:
conda install -y  --no-update-deps \
'bioconductor-DESeq2' 

# Validate script available in environment at CONDA PREFIX: validate.sh
cp recipes/utils/r-362-conda/validate/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh

