#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-16
# Capture time: 10:25:59 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi
# Using conda executable conda: /home/ralcraft/miniforge3/envs/pytest/bin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/envs/pytest/bin/conda
#####################################################

conda env remove --name r-452-conda -y 2>/dev/null || true
conda create --no-default-packages --name r-452-conda -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate r-452-conda

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels defaults
conda config --env --add channels r
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
##########################################################
# COBLE: Complex Bioinformatics Example, (c) ICR 2026
##########################################################

# compilers:

# Language compile tools
conda install -y --solver=libmamba --no-update-deps -c conda-forge compilers

# languages:
CONDA_BASE=$(conda info --base)
ARCH=$(uname -m)

conda install -y --solver=libmamba  -c conda-forge 'r-base=4.5.2'
conda install -y --solver=libmamba  'conda-forge::python=3.14.0'
python -m site
conda env config vars set PYTHONNOUSERSITE=1
export PYTHONNOUSERSITE=1

# flags:

# Including system dependencies for source installations
# Essential shared packages
conda install -y --solver=libmamba --no-update-deps -c conda-forge libcurl libprotobuf libpng libtiff libjpeg-turbo gdal proj geos gsl nlopt hdf5 cairo freetype expat fontconfig harfbuzz fribidi imagemagick
# System r packages
conda install -y --solver=libmamba --no-update-deps -c conda-forge librsvg udunits2
# Essential r packages
conda install -y --solver=libmamba --no-update-deps -c conda-forge r-cpp11 r-openssl r-rsqlite r-essentials r-rsvg

# Essential python packages
conda install -y --solver=libmamba --no-update-deps -c conda-forge cython protobuf

# Language build tools
conda install -y --solver=libmamba --no-update-deps -c conda-forge libtool autoconf cmake pkg-config
# Language core system libraries
conda install -y --solver=libmamba --no-update-deps -c conda-forge zlib bzip2 xz libxcrypt openssl sqlite
conda install -y --solver=libmamba --no-update-deps -c conda-forge 'gcc_linux-64=11.4' 'gxx_linux-64=11.4' 'gfortran_linux-64=11.4'
# Flag: Directive: ncpus, Value: 8

# r-conda:
conda install -y --solver=libmamba --no-update-deps \
'r-matrix' \
'r-survival' 
# bioc-conda:
conda install -y --solver=libmamba --no-update-deps \
'bioconductor-s4vectors' 
# r-package:
Rscript -e 'install.packages("remotes", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("BiocManager", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("tidyverse", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("data.table", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("devtools", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=8, method="wget")'
# bioc-package:
Rscript -e 'BiocManager::install("DESEq2", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("GenomicRanges", dependencies=NA, Ncpus=8)'

# Validate script available in environment at CONDA PREFIX: validate.sh
cp recipes/utils/r-452-conda/validate/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh

