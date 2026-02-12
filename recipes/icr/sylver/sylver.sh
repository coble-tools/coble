#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-11
# Capture time: 09:23:55 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi
# Using conda executable conda: /home/ralcraft/miniforge3/envs/pytest/bin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/envs/pytest/bin/conda
#####################################################

conda env remove --name sylver -y 2>/dev/null || true
conda create --no-default-packages --name sylver -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
# activate environment
conda activate sylver

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels r
conda config --env --add channels bioconda
conda config --env --add channels conda-forge
conda config --env --add channels defaults

# INSTALL SECTION FOR CONDA
#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
# note the reverse order of priority
# languages:
CONDA_BASE=$(conda info --base)
ARCH=$(uname -m)

conda install -y  -c r 'r-base=3.6.0' r-remotes r-biocmanager
# flags:
# Flag: Directive: dependencies, Value: na

# Language compile tools
conda install -y --no-update-deps -c conda-forge 'gcc_linux-64=13.1' 'gxx_linux-64=13.1' 'gfortran_linux-64=13.1'
conda install -y --no-update-deps -c conda-forge sysroot_linux-64 c-compiler cxx-compiler
# Set up compiler symlinks for R package compilation - COS6 compatibility
umask 0022
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-gfortran
# Set up compiler symlinks for R package compilation - standard aliases
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/gcc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/c++
# Set compiler flags for R package compilation
conda env config vars set CC="/home/ralcraft/miniforge3/envs/pytest/bin/gcc"
conda env config vars set CXX="/home/ralcraft/miniforge3/envs/pytest/bin/g++"
conda env config vars set FC="/home/ralcraft/miniforge3/envs/pytest/bin/x86_64-conda-linux-gnu-gfortran"
conda env config vars set F77="/home/ralcraft/miniforge3/envs/pytest/bin/x86_64-conda-linux-gnu-gfortran"
conda env config vars set CFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set CXXFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set CPPFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib"
conda deactivate
conda activate sylver

conda config --env --set channel_priority strict
conda config --env --add channels bioconda
conda config --env --add channels conda-forge
# r-conda:
conda install -y  --no-update-deps \
'r-BiocManager' \
'r-remotes' \
'r-tidyverse=1.3.1' \
'r-effsize=0.8.1' \
'r-magrittr=2.0.1' \
'r-tidyverse=1.3.1' \
'r-ggplot2' \
'r-ggrepel=0.9.1' \
'r-VennDiagram=1.6.20' 
# bioc-conda:
conda install -y  --no-update-deps \
'bioconductor-affy=1.64.0' \
'bioconductor-fgsea=1.12.0' \
'bioconductor-GSVA=1.34.0' \
'bioconductor-org.Hs.eg.db=3.10.0' 
# r-package:
Rscript -e 'remotes::install_version("survival", version="3.2-11", repos="https://cloud.r-project.org", dependencies=NA, upgrade="default", Ncpus=4)'
# bioc-package:
Rscript -e 'BiocManager::install("limma", dependencies=NA, Ncpus=4)'

# Validate script available in environment at CONDA PREFIX: validate.sh
cp recipes/icr/sylver/validate/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh

