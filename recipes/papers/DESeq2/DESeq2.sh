#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-11
# Capture time: 22:03:43 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi
# Using conda executable conda: /home/ralcraft/miniforge3/condabin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/condabin/conda
#####################################################

conda env remove --name deseq2 -y 2>/dev/null || true
conda create --no-default-packages --name deseq2 -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate deseq2

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels defaults
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
# channels: # note the reverse order of priority
# compilers:

# Language compile tools
conda install -y --no-update-deps -c conda-forge 'gcc_linux-64=7.5.0' 'gxx_linux-64=7.5.0' 'gfortran_linux-64=7.5.0'
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
conda env config vars set CC="/home/ralcraft/miniforge3/envs/deseq2/bin/gcc"
conda env config vars set CXX="/home/ralcraft/miniforge3/envs/deseq2/bin/g++"
conda env config vars set FC="/home/ralcraft/miniforge3/envs/deseq2/bin/x86_64-conda-linux-gnu-gfortran"
conda env config vars set F77="/home/ralcraft/miniforge3/envs/deseq2/bin/x86_64-conda-linux-gnu-gfortran"
conda env config vars set CFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set CXXFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set CPPFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib --sysroot=$CONDA_PREFIX/x86_64-conda-linux-gnu/sysroot"
# Also as export to avoid de/activations
export CC="/home/ralcraft/miniforge3/envs/deseq2/bin/gcc"
export CXX="/home/ralcraft/miniforge3/envs/deseq2/bin/g++"
export FC="/home/ralcraft/miniforge3/envs/deseq2/bin/x86_64-conda-linux-gnu-gfortran"
export F77="/home/ralcraft/miniforge3/envs/deseq2/bin/x86_64-conda-linux-gnu-gfortran"
export CFLAGS="-I$CONDA_PREFIX/include"
export CXXFLAGS="-I$CONDA_PREFIX/include"
export CPPFLAGS="-I$CONDA_PREFIX/include"
export LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib --sysroot=$CONDA_PREFIX/x86_64-conda-linux-gnu/sysroot"

# Flag: Directive: cran-repo, Value: 
# languages:
CONDA_BASE=$(conda info --base)
ARCH=$(uname -m)

# R source installation requested
bash "/home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble-r-source.sh" "3.6.2"
# conda:
conda install -y  --no-update-deps \
'binutils>=2.38' \
'binutils_impl_linux-64>=2.38' 
# r-package:
Rscript -e 'install.packages("cli", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=TRUE, Ncpus=1, method="wget")'
Rscript -e 'install.packages("crayon", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=TRUE, Ncpus=1, method="wget")'
Rscript -e 'install.packages("digest", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=TRUE, Ncpus=1, method="wget")'
Rscript -e 'install.packages("ellipsis", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=TRUE, Ncpus=1, method="wget")'
Rscript -e 'install.packages("evaluate", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=TRUE, Ncpus=1, method="wget")'
Rscript -e 'install.packages("magrittr", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=TRUE, Ncpus=1, method="wget")'
Rscript -e 'install.packages("pkgload", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=TRUE, Ncpus=1, method="wget")'
Rscript -e 'install.packages("praise", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=TRUE, Ncpus=1, method="wget")'
Rscript -e 'install.packages("R6", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=TRUE, Ncpus=1, method="wget")'
Rscript -e 'install.packages("rlang", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=TRUE, Ncpus=1, method="wget")'
Rscript -e 'install.packages("withr", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=TRUE, Ncpus=1, method="wget")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/testthat/testthat_2.3.2.tar.gz", repos="https://packagemanager.posit.co/cran/2020-04-01", type="source", method="wget" )'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/mockery/mockery_0.4.2.tar.gz", repos="https://packagemanager.posit.co/cran/2020-04-01", type="source", method="wget" )'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/remotes/remotes_2.1.1.tar.gz", repos="https://packagemanager.posit.co/cran/2020-04-01", type="source", method="wget" )'
# bioc-package:
Rscript -e 'BiocManager::install("DESeq2", dependencies=TRUE, Ncpus=1)'
Rscript -e 'BiocManager::install("DESeq", dependencies=TRUE, Ncpus=1)'
Rscript -e 'BiocManager::install("edgeR", dependencies=TRUE, Ncpus=1)'
Rscript -e 'BiocManager::install("DSS", dependencies=TRUE, Ncpus=1)'
Rscript -e 'BiocManager::install("limma", dependencies=TRUE, Ncpus=1)'
Rscript -e 'BiocManager::install("EBSeq", dependencies=TRUE, Ncpus=1)'
Rscript -e 'BiocManager::install("parathyroidSE", dependencies=TRUE, Ncpus=1)'
Rscript -e 'BiocManager::install("pasilla", dependencies=TRUE, Ncpus=1)'
# conda:
conda install -y  --no-update-deps \
'GFOLD' 
# r-package:
Rscript -e 'install.packages("samr", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=TRUE, Ncpus=1, method="wget")'
Rscript -e 'install.packages("PoiClaClu", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=TRUE, Ncpus=1, method="wget")'
#bash:
#cp recipes/publications/DESeq2/DESeq2.R 
#$CONDA_PREFIX/bin/DESeq2.R





# Validate script available in environment at CONDA PREFIX: validate.sh
cp recipes/papers/DESeq2/validate/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
# Extra validation file: DESeq2.R
cp recipes/papers/DESeq2/validate/DESeq2.R ${CONDA_PREFIX}/bin/DESeq2.R
chmod +x ${CONDA_PREFIX}/bin/DESeq2.R

