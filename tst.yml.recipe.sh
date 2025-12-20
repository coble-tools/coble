#!/usr/bin/env bash

#######################################
# COBLE:Reproducible environment recipe, (c) ICR 2025
# Capture date: 2025-12-20
# Capture time: 17:05:06 GMT
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


# find:
conda install -y -c r 'r-base=3.6.0' --no-update-deps
conda install -y -c conda-forge 'r-base=4.1.0' --no-update-deps
conda install -y -c conda-forge 'r-BiocManager' --no-update-deps
conda install -y -c conda-forge 'r-tidyverse=1.3.1' --no-update-deps
conda install -y -c conda-forge 'r-effsize=0.8.1' --no-update-deps
conda install -y -c conda-forge 'r-magrittr=2.0.1' --no-update-deps
conda install -y -c conda-forge 'r-tidyverse=1.3.1' --no-update-deps
conda install -y -c bioconda 'r-ggplot2' --no-update-deps
conda install -y -c conda-forge 'r-ggrepel=0.9.1' --no-update-deps
conda install -y -c conda-forge 'r-VennDiagram=1.6.20' --no-update-deps
conda install -y -c conda-forge -c bioconda 'bioconductor-affy=1.64.0' --no-update-deps
conda install -y -c conda-forge -c bioconda 'bioconductor-fgsea=1.12.0' --no-update-deps
conda install -y -c conda-forge -c bioconda 'bioconductor-GSVA=1.34.0' --no-update-deps
conda install -y -c conda-forge -c bioconda 'bioconductor-org.Hs.eg.db=3.10.0' --no-update-deps
Rscript -e 'remotes::install_version("survival", version="3.2-11", repos="http://cran.us.r-project.org", dependencies=TRUE)'
Rscript -e 'remotes::install_version("limma", version="3.42.2", dependencies=TRUE, repos=BiocManager::repositories())'
Rscript -e 'remotes::install_url("https://github.com/broadinstitute/cdsr_models/archive/refs/heads/master.zip", dependencies=TRUE)'
