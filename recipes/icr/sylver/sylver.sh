#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-08
# Capture time: 14:17:27 GMT
# Captured by: ralcraft
# Platform: 
#####################################################
# source bashrc for conda
CONDA_BASE=$(conda info --base 2>/dev/null)
[ -z "$CONDA_BASE" ] && CONDA_BASE="/home/ralcraft/miniforge3"
source "${CONDA_BASE}/etc/profile.d/conda.sh"
conda deactivate 2>/dev/null || true
# Using conda executable /home/ralcraft/miniforge3/condabin/conda: /home/ralcraft/miniforge3/condabin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/condabin/conda
# CONDA base /home/ralcraft/miniforge3/envs/pytest
# Target environment sylver
# Target path /home/ralcraft/miniforge3/envs/pytest/envs/sylver
#####################################################

# Detected platform: OS=linux, ARCH=x86_64, PLATFORM=linux-64
# Compiler packages: c-compiler cxx-compiler fortran-compiler
# Compiler packages: sysroot_linux-64
# Compiler packages: gcc_linux-64 gxx_linux-64 gfortran_linux-64
/home/ralcraft/miniforge3/condabin/conda env remove --name sylver -y 2>/dev/null || true
/home/ralcraft/miniforge3/condabin/conda create --no-default-packages --name sylver -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# activate environment
conda activate sylver

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
/home/ralcraft/miniforge3/condabin/conda config --env --remove-key channels
/home/ralcraft/miniforge3/condabin/conda config --env --set channel_priority strict
/home/ralcraft/miniforge3/condabin/conda config --env --add channels r
/home/ralcraft/miniforge3/condabin/conda config --env --add channels bioconda
/home/ralcraft/miniforge3/condabin/conda config --env --add channels conda-forge
/home/ralcraft/miniforge3/condabin/conda config --env --add channels defaults

# INSTALL SECTION FOR CONDA
#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
# note the reverse order of priority
# flags:
/home/ralcraft/miniforge3/condabin/conda config --env --set channel_priority flexible
# languages:
# Setting compile tools version to 7.5.0
# Setting compile order: with
# Setting env sims: true
# Setting base sims: false
conda install -y  \
  'gcc_linux-64=7.5.0' 'gxx_linux-64=7.5.0' 'gfortran_linux-64=7.5.0' \
  c-compiler cxx-compiler fortran-compiler \
  sysroot_linux-64 \
  'r::r-base=3.6.0' r-remotes r-biocmanager

# Set up compiler symlinks for R package compilation - Linux x86_64
umask 0022
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++
# Standard compiler aliases
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/gcc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/c++
/home/ralcraft/miniforge3/condabin/conda env config vars set CC="$CONDA_PREFIX/bin/gcc"
/home/ralcraft/miniforge3/condabin/conda env config vars set CXX="$CONDA_PREFIX/bin/g++"
/home/ralcraft/miniforge3/condabin/conda env config vars set FC="$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran"
/home/ralcraft/miniforge3/condabin/conda env config vars set F77="$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran"
/home/ralcraft/miniforge3/condabin/conda env config vars set CFLAGS="-I$CONDA_PREFIX/include"
/home/ralcraft/miniforge3/condabin/conda env config vars set CXXFLAGS="-I$CONDA_PREFIX/include"
/home/ralcraft/miniforge3/condabin/conda env config vars set CPPFLAGS="-I$CONDA_PREFIX/include"
/home/ralcraft/miniforge3/condabin/conda env config vars set LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib"
/home/ralcraft/miniforge3/condabin/conda env config vars set LD_LIBRARY_PATH="$CONDA_PREFIX/lib:$LD_LIBRARY_PATH"
conda deactivate
conda activate sylver

# flags:
# Flag: Directive: dependencies, Value: na
/home/ralcraft/miniforge3/condabin/conda config --env --set channel_priority strict
/home/ralcraft/miniforge3/condabin/conda config --env --add channels bioconda
/home/ralcraft/miniforge3/condabin/conda config --env --add channels conda-forge
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

