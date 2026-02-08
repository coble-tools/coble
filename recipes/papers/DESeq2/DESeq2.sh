#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-08
# Capture time: 11:13:25 GMT
# Captured by: ralcraft
# Platform: 
#####################################################
# source bashrc for conda
CONDA_BASE=$(conda info --base 2>/dev/null)
[ -z "$CONDA_BASE" ] && CONDA_BASE="/home/ralcraft/miniforge3"
source "${CONDA_BASE}/etc/profile.d/conda.sh"
conda deactivate 2>/dev/null || true
# Using conda executable /home/ralcraft/miniforge3/bin/conda: /home/ralcraft/miniforge3/bin/conda
# Using conda alias /home/ralcraft/miniforge3/bin/conda: /home/ralcraft/miniforge3/bin/conda
# CONDA base /home/ralcraft/miniforge3
# Target environment deseq2
# Target path /home/ralcraft/miniforge3/envs/deseq2
#####################################################

# Detected platform: OS=linux, ARCH=x86_64, PLATFORM=linux-64
# Compiler packages: c-compiler cxx-compiler fortran-compiler
# Compiler packages: sysroot_linux-64
# Compiler packages: gcc_linux-64 gxx_linux-64 gfortran_linux-64
/home/ralcraft/miniforge3/bin/conda env remove --name deseq2 -y 2>/dev/null || true
/home/ralcraft/miniforge3/bin/conda create --no-default-packages --name deseq2 -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# activate environment
conda activate deseq2

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
/home/ralcraft/miniforge3/bin/conda config --env --remove-key channels
/home/ralcraft/miniforge3/bin/conda config --env --set channel_priority strict
/home/ralcraft/miniforge3/bin/conda config --env --add channels defaults
/home/ralcraft/miniforge3/bin/conda config --env --add channels bioconda
/home/ralcraft/miniforge3/bin/conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
# channels: # note the reverse order of priority
# flags:
/home/ralcraft/miniforge3/bin/conda config --env --set channel_priority flexible
# languages:
# Setting compile tools version to 7.5.0
# Setting separate R version to true
# Installing R base version 3.6.2 separately
/home/ralcraft/miniforge3/bin/conda install -y  \
  'gcc_linux-64=7.5.0' 'gxx_linux-64=7.5.0' 'gfortran_linux-64=7.5.0' \
  sysroot_linux-64 \
  c-compiler cxx-compiler fortran-compiler
# Recommended tools: 
# Symlink all compiler/binutils tools

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
# Creating compiler symlinks in base conda for R 3.6.0 compatibility...
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc /home/ralcraft/miniforge3/bin/x86_64-conda-linux-gnu-gcc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran /home/ralcraft/miniforge3/bin/x86_64-conda-linux-gnu-gfortran
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-f95 /home/ralcraft/miniforge3/bin/x86_64-conda-linux-gnu-f95
ln -sf $CONDA_PREFIX/bin/gcc /home/ralcraft/miniforge3/bin/gcc
ln -sf $CONDA_PREFIX/bin/g++ /home/ralcraft/miniforge3/bin/g++
ln -sf $CONDA_PREFIX/bin/gfortran /home/ralcraft/miniforge3/bin/gfortran
ln -sf $CONDA_PREFIX/bin/c++ /home/ralcraft/miniforge3/bin/c++
ln -sf $CONDA_PREFIX/bin/cc /home/ralcraft/miniforge3/bin/cc
/home/ralcraft/miniforge3/bin/conda env config vars set CC="$CONDA_PREFIX/bin/gcc"
/home/ralcraft/miniforge3/bin/conda env config vars set CXX="$CONDA_PREFIX/bin/g++"
/home/ralcraft/miniforge3/bin/conda env config vars set FC="$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran"
/home/ralcraft/miniforge3/bin/conda env config vars set F77="$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran"
/home/ralcraft/miniforge3/bin/conda env config vars set CFLAGS="-I$CONDA_PREFIX/include"
/home/ralcraft/miniforge3/bin/conda env config vars set CXXFLAGS="-I$CONDA_PREFIX/include"
/home/ralcraft/miniforge3/bin/conda env config vars set CPPFLAGS="-I$CONDA_PREFIX/include"
/home/ralcraft/miniforge3/bin/conda env config vars set LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib"
/home/ralcraft/miniforge3/bin/conda env config vars set LD_LIBRARY_PATH="$CONDA_PREFIX/lib:$LD_LIBRARY_PATH"
conda deactivate
conda activate deseq2

# Installing R base version 3.6.2 separately
/home/ralcraft/miniforge3/bin/conda install -y  -c conda-forge r-base=3.6.2 r-remotes r-biocmanager
# flags:
# Flag: Directive: dependencies, Value: na
/home/ralcraft/miniforge3/bin/conda config --env --set channel_priority strict
# bioc-conda:
/home/ralcraft/miniforge3/bin/conda install -y  --no-update-deps \
'bioconductor-DESeq2' \
'bioconductor-DESeq' \
'bioconductor-edgeR' \
'bioconductor-DSS' \
'bioconductor-limma' \
'bioconductor-EBSeq' \
'bioconductor-parathyroidSE' \
'bioconductor-pasilla' 
# conda:
/home/ralcraft/miniforge3/bin/conda install -y  --no-update-deps \
'GFOLD' 
# r-conda:
/home/ralcraft/miniforge3/bin/conda install -y  --no-update-deps \
'r-samr' \
'r-PoiClaClu' 
#bash:
#cp recipes/publications/DESeq2/DESeq2.R 
#$CONDA_PREFIX/bin/DESeq2.R





# Validate script available in environment at CONDA PREFIX: validate.sh
cp recipes/papers/DESeq2/validate/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
# Extra validation file: DESeq2.R
cp recipes/papers/DESeq2/validate/DESeq2.R ${CONDA_PREFIX}/bin/DESeq2.R
chmod +x ${CONDA_PREFIX}/bin/DESeq2.R

