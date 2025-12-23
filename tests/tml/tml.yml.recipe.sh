#!/usr/bin/env bash

#######################################
# COBLE:Reproducible environment recipe, (c) ICR 2025
# Capture date: 2025-12-23
# Capture time: 20:40:32 GMT
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
conda config --env --add channels defaults
conda config --env --add channels r
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA

# languages:
conda install -y -c conda-forge 'r-base=4.4.2'
conda install -y 'conda-forge::python=3.13.1'

# flags:
# Flag: Directive: dependencies, Value: true
# Flag: Directive: build-tools, Value: true

# Including build tools for source installations
conda install -y -c conda-forge gsl nlopt
conda install -y -c conda-forge -c bioconda r-cpp11 r-openssl r-rsqlite r-remotes r-biocmanager r-essentials
conda install -y -c conda-forge librsvg cairo freetype expat fontconfig
conda install -y -c conda-forge protobuf libprotobuf openssl cython bzip2 xz libcurl zlib gcc_linux-64 gxx_linux-64 gfortran_linux-64 make cmake pkg-config c-compiler cxx-compiler
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-gfortran


# conda:
conda install -y  --no-update-deps \
'pandas' 

# r-conda:
conda install -y  --no-update-deps \
'r-tidyverse' \
'r-devtools' \
'r-remotes' 

# bioc-conda:
conda install -y  --no-update-deps \
'bioconda::bioconductor-affy' 

# r-package:
Rscript -e 'install.packages("survival", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("countreg", repos="https://cloud.r-project.org", dependencies=TRUE)'

# bioc-package:
Rscript -e 'BiocManager::install("limma", dependencies=TRUE)'

# r-github:
Rscript -e 'devtools::install_github("seedgeorge/SQUEAK", dependencies=TRUE)'

# r-url:
Rscript -e 'remotes::install_url("https://github.com/choisy/cutoff/archive/refs/heads/master.zip", dependencies=TRUE)'

# pip:
python -m pip install numpy 
python -m pip install git+https://github.com/ICR-RSE-Group/gitalma.git 

