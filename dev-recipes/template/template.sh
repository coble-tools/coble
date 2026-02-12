#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-01-19
# Capture time: 20:51:46 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
# Using conda executable conda: /home/ralcraft/miniforge3/bin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/bin/conda
#####################################################

conda env remove --name template -y 2>/dev/null || true
conda create --no-default-packages --name template -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# activate environment
conda activate template

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
#####################################################
# COBLE:Reproducible environment: BASIC, (c) ICR 2026
#####################################################
# This template demomnstaes all thepossible features along with the defaults
# Note that the recipe can be called with --alias mamba to use mamba instead of conda
# but that there is also an alias directive to set the alias within the recipe itself
#####################################################
# channels: # note the reverse order of priority
# languages:
conda install -y  'conda-forge::python=3.13.1'
python -m site
conda env config vars set PYTHONNOUSERSITE=1
conda install -y  -c conda-forge 'r-base=4.3.1' r-remotes r-biocmanager
# flags:
# Flag: Directive: dependencies, Value: na


# Set up compiler symlinks for R package compilation - COS6 compatibility
umask 0022
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-gfortran
# Set up compiler symlinks for R package compilation - standard aliases
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/gcc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/c++
# Set compiler flags for R package compilation
conda env config vars set CC="/home/ralcraft/miniforge3/bin/gcc"
conda env config vars set CXX="/home/ralcraft/miniforge3/bin/g++"
conda env config vars set FC="/home/ralcraft/miniforge3/bin/x86_64-conda-linux-gnu-gfortran"
conda env config vars set F77="/home/ralcraft/miniforge3/bin/x86_64-conda-linux-gnu-gfortran"
conda env config vars set CFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set CXXFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set CPPFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib"

conda env config vars set VAR1=VALUE1
# Flag: Directive: updates, Value: false
# Flag: Directive: alias, Value: conda
# conda:
conda install -y  --no-update-deps \
'pandas' 
# r-conda:
conda install -y  --no-update-deps \
'r-data.table' 
# bioc-package:
Rscript -e 'BiocManager::install("snow", dependencies=NA, Ncpus=4)'
# bioc-conda:
conda install -y  --no-update-deps \
'bioconductor-biobase' 
# r-package:
Rscript -e 'install.packages("generics", repos="https://cloud.r-project.org", dependencies=NA, Ncpus=4)'
# pip:
python -m pip install 'scanoramaCT' 
python -m pip install "git+https://github.com/ICR-RSE-Group/gitalma.git" 
# r-url:
Rscript -e 'remotes::install_url("https://github.com/tidyverse/magrittr/archive/refs/heads/main.zip", dependencies=NA, Ncpus=4)'
# bash:
mkdir -p "HelloWorld"
# r-github:
Rscript -e 'remotes::install_github("deepayan/lattice", dependencies=NA, Ncpus=4)'

