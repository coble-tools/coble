#!/usr/bin/env bash

#######################################
# COBLE:Reproducible environment recipe, (c) ICR 2025
# Capture date: 2025-12-17
# Capture time: 22:30:02 GMT
# Captured by: ralcraft
#######################################
# source bashrc for conda
source "$(conda info --base)/etc/profile.d/conda.sh"
source ~/.bashrc
#######################################


conda create --name coble -y -c conda-forge -c defaults -c r
conda activate coble

# Channels section
conda config --remove-key channels
conda config --add channels conda-forge
conda config --add channels r
conda config --add channels bioconda
conda config --add channels defaults

# INSTALL SECTION FOR CONDA
conda install -c r r-base=3.6.0
conda install -y 'r-BiocManager' -c conda-forge  --no-update-deps
conda install -y -c bioconda limma=3.24.15
conda install -y -c conda-forge effsize=0.7.1
conda install -y -c bioconda magrittr=1.5
conda install -y -c conda-forge tidyverse=1.1.1
conda install -y -c bioconda fgsea=1.2.1
conda install -y -c bioconda ggrepel=0.5
conda install -y -c bioconda org.Hs.eg.db=3.2.3
conda install -y -c bioconda VennDiagram=1.6.16
conda install -y -c conda-forge survival=2.40_1
conda install -y -c bioconda affy=1.48.0
conda install -y -c bioconda GSVA=1.24.1
