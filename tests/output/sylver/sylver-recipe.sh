#!/usr/bin/env bash

#######################################
# COBLE:Reproducible environment recipe, (c) ICR 2025
# Capture date: 2025-12-18
# Capture time: 11:31:51 GMT
# Captured by: ralcraft
#######################################
# source bashrc for conda
source "$(conda info --base)/etc/profile.d/conda.sh"
source ~/.bashrc
#######################################


conda create --name sylver -y
conda activate sylver

# Channels section
conda config --remove-key channels
conda config --add channels conda-forge
conda config --add channels r
conda config --add channels bioconda
conda config --add channels defaults

# INSTALL SECTION FOR CONDA
conda install -y -c r 'r-base=3.6.0'
conda install -y -c conda-forge 'r-BiocManager'  --no-update-deps
# Unknown package: - hsentrezgcdf=18
# Unknown package: - cdsrmodels=0.1.0
Rscript -e 'remotes::install_version("limma", version="3.42.2", dependencies=TRUE, repos=BiocManager::repositories())'
conda install -y -c conda-forge 'r-effsize=0.8.1'
conda install -y -c conda-forge 'r-magrittr=2.0.1'
conda install -y -c conda-forge 'r-tidyverse=1.3.1'
conda install -y -c bioconda 'bioconductor-fgsea=1.12.0'
# Unknown package: - ggplots=2_3.3.5
conda install -y -c conda-forge 'r-ggrepel=0.9.1'
conda install -y -c bioconda 'bioconductor-org.Hs.eg.db=3.10.0'
conda install -y -c conda-forge 'r-VennDiagram=1.6.20'
Rscript -e 'devtools::install_version("survival", version="3.2-11", repos="http://cran.us.r-project.org", dependencies=TRUE)'
conda install -y -c bioconda 'bioconductor-affy=1.64.0'
conda install -y -c bioconda 'bioconductor-GSVA=1.34.0'
