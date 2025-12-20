#!/usr/bin/env bash

#######################################
# COBLE:Reproducible environment recipe, (c) ICR 2025
# Capture date: 2025-12-19
# Capture time: 21:08:26 GMT
# Captured by: ralcraft
#######################################
# source bashrc for conda
source "$(conda info --base)/etc/profile.d/conda.sh"
source ~/.bashrc
#######################################


conda create --name sylver4 -y
conda activate sylver4

# Channels section
conda config --remove-key channels
conda config --add channels conda-forge
conda config --add channels r
conda config --add channels bioconda
conda config --add channels defaults

# INSTALL SECTION FOR CONDA

# languages:
conda install -y -c conda-forge 'r-base=4.1.0'

# flags:
# Flag: Directive: dependencies, Value: true
# Flag: Directive: build-tools, Value: true

# Including build tools for source installations
conda install -y -c conda-forge gcc_linux-64 gxx_linux-64 gfortran_linux-64 make r-remotes
conda install -y -c conda-forge -c bioconda r-cpp11 r-openssl r-rsqlite
conda install -y -c conda-forge make pkg-config
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-gfortran


# conda-r:
conda install -y -c conda-forge -c bioconda  --no-update-deps \
'r-BiocManager' 

# bash:
Rscript -e 'BiocManager::install(version = "3.10")'

# conda:
conda install -y -c conda-forge -c bioconda  --no-update-deps \
'r-tidyverse' \
'r-effsize' \
'r-magrittr' \
'r-ggplot2=3.3.5' \
'r-ggrepel' \
'r-VennDiagram' \
'bioconductor-affy' \
'bioconductor-fgsea' \
'bioconductor-GSVA' \
'bioconductor-org.Hs.eg.db' 

# r-package:

# r-url:
Rscript -e 'remotes::install_url("https://github.com/broadinstitute/cdsr_models/archive/refs/heads/master.zip", dependencies=TRUE)'
