#!/usr/bin/env bash

#######################################
# COBLE:Reproducible environment recipe, (c) ICR 2025
# Capture date: 2025-12-19
# Capture time: 00:06:09 GMT
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
conda install -y -c conda-forge -c r 'r-base=3.6.0'

# Including build tools for source installations
conda install -y -c conda-forge gcc_linux-64 gxx_linux-64 gfortran_linux-64 make r-remotes
conda install -y -c conda-forge -c bioconda r-cpp11 r-openssl r-rsqlite
conda install -y -c conda-forge make pkg-config
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-gfortran

conda install -y -c conda-forge 'r-BiocManager'  --no-update-deps
Rscript -e 'BiocManager::install(version = "3.10")'
conda install -y -c conda-forge -c bioconda 'bioconductor-fgsea=1.12.0' --no-update-deps
conda install -y -c conda-forge 'r-ashr'
conda install -y -c conda-forge 'r-ranger'
conda install -y -c bioconda 'r-readr'
conda install -y -c conda-forge 'r-tidyverse'
conda install -y -c conda-forge 'r-useful'
conda install -y -c bioconda 'r-WGCNA'
Rscript -e 'remotes::install_url("https://github.com/broadinstitute/cdsr_models/archive/refs/heads/master.zip", dependencies=TRUE)'
# Unknown package: - hsentrezgcdf
Rscript -e 'remotes::install_url("https://github.com/broadinstitute/cdsr_models/archive/refs/heads/master.zip", dependencies=TRUE)'
Rscript -e 'remotes::install_version("limma", version="3.42.2", dependencies=TRUE, repos=BiocManager::repositories())'
conda install -y -c conda-forge 'r-effsize=0.8.1'
conda install -y -c conda-forge 'r-magrittr=2.0.1'
conda install -y -c conda-forge 'r-tidyverse=1.3.1'
conda install -y -c conda-forge 'r-ggplot2=3.3.5'
conda install -y -c conda-forge 'r-ggrepel=0.9.1'
conda install -y -c conda-forge -c bioconda 'bioconductor-org.Hs.eg.db=3.10.0'
conda install -y -c conda-forge 'r-VennDiagram=1.6.20'
Rscript -e 'remotes::install_version("survival", version="3.2-11", repos="http://cran.us.r-project.org", dependencies=TRUE)'
conda install -y -c conda-forge -c bioconda 'bioconductor-affy=1.64.0'
conda install -y -c conda-forge -c bioconda 'bioconductor-GSVA=1.34.0'
