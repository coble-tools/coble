#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-16
# Capture time: 22:15:59 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi
# Using conda executable conda: /home/ralcraft/miniforge3/condabin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/condabin/conda
#####################################################

conda env remove --name sylver -y 2>/dev/null || true
conda create --no-default-packages --name sylver -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate sylver

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

conda install -y --solver=libmamba --no-update-deps -c r 'r-base=3.6.0'
conda install -y --solver=libmamba --no-update-deps r-remotes r-biocmanager
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
'r-BiocManager' \
'r-remotes' \
'r-tidyverse=1.3.1' \
'r-effsize=0.8.1' \
'r-magrittr=2.0.1' \
'r-tidyverse=1.3.1' \
'r-ggplot2' \
'r-ggrepel=0.9.1' \
'r-VennDiagram=1.6.20' 
# bioc-conda:
conda install -y --solver=libmamba --no-update-deps \
'bioconductor-affy=1.64.0' \
'bioconductor-fgsea=1.12.0' \
'bioconductor-GSVA=1.34.0' \
'bioconductor-org.Hs.eg.db=3.10.0' 
# r-package:
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/survival/survival_3.2-11.tar.gz", repos="https://packagemanager.posit.co/cran/2020-04-01", type="source", method="wget" )'
# bioc-package:
Rscript -e 'BiocManager::install("limma", dependencies=NA, Ncpus=1)'

# Validate script available in environment at CONDA PREFIX: validate.sh
cp recipes/icr/sylver/validate/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh

