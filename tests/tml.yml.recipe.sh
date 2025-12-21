#!/usr/bin/env bash

#######################################
# COBLE:Reproducible environment recipe, (c) ICR 2025
# Capture date: 2025-12-21
# Capture time: 21:48:20 GMT
# Captured by: ralcraft
#######################################
# source bashrc for conda
source "$(conda info --base)/etc/profile.d/conda.sh"
source ~/.bashrc
#######################################


conda create --name tml -y
conda activate tml

# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels conda-forge
conda config --env --add channels bioconda
conda config --env --add channels r
conda config --env --add channels defaults

# INSTALL SECTION FOR CONDA

# languages:
conda install -y -c conda-forge 'r-base=4.4.2'

# flags:
# Flag: Directive: dependencies, Value: true
# Flag: Directive: build-tools, Value: true

# Including build tools for source installations
conda install -y -c conda-forge gsl nlopt
conda install -y -c conda-forge -c bioconda r-cpp11 r-openssl r-rsqlite r-remotes r-biocmanager r-essentials
conda install -y -c conda-forge gcc_linux-64 gxx_linux-64 gfortran_linux-64 make pkg-config
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-gfortran


# r-conda:
conda install -y -c conda-forge -c bioconda  --no-update-deps \
'r-tidyverse' \
'r-devtools' \
'r-remotes' 

# bioc-conda:
conda install -y -c conda-forge -c bioconda  --no-update-deps \
'bioconductor-affy' 

# r-package:

# bioc-package:

# r-github:
Rscript -e 'devtools::install_github("", dependencies=TRUE)'

# r-url:
Rscript -e 'remotes::install_url("https://github.com/choisy/cutoff/archive/refs/heads/master.zip", dependencies=TRUE)'

