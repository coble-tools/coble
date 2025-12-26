#!/usr/bin/env bash

#######################################
# COBLE:Reproducible environment recipe, (c) ICR 2025
# Capture date: 2025-12-26
# Capture time: 13:49:16 GMT
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
conda install -y -c conda-forge 'r-base=4.5.2'

# flags:
# Flag: Directive: dependencies, Value: true
# Flag: Directive: build-tools, Value: true

# Including build tools for source installations
conda install -y -c conda-forge gsl nlopt
conda install -y -c conda-forge -c bioconda r-cpp11 r-openssl r-rsqlite r-remotes r-biocmanager r-essentials
conda install -y -c conda-forge librsvg cairo freetype expat fontconfig
conda install -y -c conda-forge libxcrypt sysroot_linux-64 gcc_linux-64 gxx_linux-64 gfortran_linux-64 c-compiler cxx-compiler
conda install -y -c conda-forge make cmake pkg-config protobuf libprotobuf openssl cython bzip2 xz libcurl zlib
# Compiler symlinks for R packages
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-gfortran
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-c++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/gcc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/c++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/cc
# Set compiler flags for R package compilation
export CFLAGS="-I$CONDA_PREFIX/include"
export CXXFLAGS="-I$CONDA_PREFIX/include"
export CPPFLAGS="-I$CONDA_PREFIX/include"
export LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib"


# conda:
conda install -y  --no-update-deps \
'conda-forge::devtools' \
'conda-forge::r-devtools' 

# r-url:
Rscript -e 'remotes::install_url("cdsr_models@https://github.com/broadinstitute/cdsr_models/archive/refs/heads/master.zip", dependencies=TRUE)'

# r-package:
Rscript -e 'install.packages("countreg", repos="https://R-Forge.R-project.org", dependencies=TRUE)'

