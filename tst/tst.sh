#!/usr/bin/env bash

#######################################
# COBLE:Reproducible environment recipe, (c) ICR 2025
# Capture date: 2025-12-20
# Capture time: 21:55:20 GMT
# Captured by: ralcraft
#######################################
# source bashrc for conda
source "$(conda info --base)/etc/profile.d/conda.sh"
source ~/.bashrc
#######################################


conda create --name coble -y
conda activate coble

# Channels section
conda config --remove-key channels
conda config --add channels conda-forge
conda config --add channels bioconda
conda config --add channels r
conda config --add channels defaults

# INSTALL SECTION FOR CONDA

# languages:

# flags:
# Flag: Directive: dependencies, Value: true
# Flag: Directive: build-tools, Value: true

# Including build tools for source installations
conda install -y -c conda-forge gcc_linux-64 gxx_linux-64 gfortran_linux-64 make
conda install -y -c conda-forge -c bioconda r-cpp11 r-openssl r-rsqlite r-remotes
conda install -y -c conda-forge -c bioconda r-preprocesscore bioconductor-vsn
conda install -y -c conda-forge gcc_linux-64 gxx_linux-64 gfortran_linux-64 make pkg-config
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-gfortran


# languages:
conda install -y -c r 'r-base=3.6.0'
conda install -y -c conda-forge 'r-base=4.1.0'

# conda:
conda install -y -c conda-forge -c bioconda  --no-update-deps \
'r-BiocManager=1.30.4' \
'r-tidyverse=1.3.1' \
'r-effsize=0.8.1' \
'r-magrittr=2.0.1' \
'r-tidyverse=1.3.1' \
'r-ggplot2=2.0.0' \
'r-ggrepel=0.9.1' \
'r-VennDiagram=1.6.20' \
'bioconductor-affy=1.64.0' \
'bioconductor-fgsea=1.12.0' \
'bioconductor-GSVA=1.34.0' \
'bioconductor-org.Hs.eg.db=3.10.0' 

# r-package:

# r-url:
Rscript -e 'remotes::install_url("https://github.com/broadinstitute/cdsr_models/archive/refs/heads/master.zip@https://github.com/broadinstitute/cdsr_models/archive/refs/heads/master.zip", dependencies=TRUE)'

