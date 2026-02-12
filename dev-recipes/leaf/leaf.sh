#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-01-25
# Capture time: 16:17:29 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
# Using conda executable conda: /home/ralcraft/miniforge3/bin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/bin/conda
#####################################################

conda env remove --name leaf -y 2>/dev/null || true
conda create --no-default-packages --name leaf -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# activate environment
conda activate leaf

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
##########################################################
# COBLE: Complex Bioinformatics Example, (c) ICR 2026
##########################################################
# note the reverse order of priority
# languages:
conda install -y  -c conda-forge 'r-base=4.5.2' r-remotes r-biocmanager
conda install -y  'conda-forge::python=3.14.0'
python -m site
conda env config vars set PYTHONNOUSERSITE=1
conda deactivate
conda activate leaf
# flags:
# Flag: Directive: dependencies, Value: na

# Including system dependencies for source installations
# Essential shared packages
conda install -y --no-update-deps -c conda-forge libcurl libprotobuf libpng libtiff libjpeg-turbo gdal proj geos gsl nlopt hdf5 cairo freetype expat fontconfig harfbuzz fribidi imagemagick
# System r packages
conda install -y --no-update-deps -c conda-forge librsvg udunits2
# Essential r packages
conda install -y --no-update-deps -c conda-forge r-cpp11 r-openssl r-rsqlite r-essentials r-rsvg

# Essential python packages
conda install -y --no-update-deps -c conda-forge cython protobuf

# Language build tools
conda install -y --no-update-deps -c conda-forge cmake pkg-config
# Language core system libraries
conda install -y --no-update-deps -c conda-forge zlib bzip2 xz libxcrypt openssl sqlite

# Language compile tools
conda install -y --no-update-deps -c conda-forge 'gcc_linux-64=11' 'gxx_linux-64=11' 'gfortran_linux-64=11'
conda install -y --no-update-deps -c conda-forge sysroot_linux-64 c-compiler cxx-compiler
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
conda deactivate
conda activate leaf

# Flag: Directive: ncpus, Value: 8

# conda:
conda install -y  --no-update-deps \
'tbb<2021' \
'tbb-devel<2021' 

# r-package:
Rscript -e 'install.packages("RcppEigen", repos="https://cloud.r-project.org", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("RcppParallel", repos="https://cloud.r-project.org", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("inline", repos="https://cloud.r-project.org", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("gridExtra", repos="https://cloud.r-project.org", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("loo", repos="https://cloud.r-project.org", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("pkgbuild", repos="https://cloud.r-project.org", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("V8", repos="https://cloud.r-project.org", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("BH", repos="https://cloud.r-project.org", dependencies=NA, Ncpus=8)'

# bash:
# StanHeaders with flags
CXX14FLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive" \
CXX17FLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive" \
CXXFLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive -I$CONDA_PREFIX/include" \
MAKEFLAGS="-j1" \
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/StanHeaders/StanHeaders_2.21.0-7.tar.gz", repos=NULL, type="source")'

# rstan with flags
CXX14FLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive" \
CXX17FLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive" \
CXXFLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive -I$CONDA_PREFIX/include" \
MAKEFLAGS="-j1" \
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/rstan/rstan_2.21.2.tar.gz", repos=NULL, type="source")'

# bioc-package:
Rscript -e 'BiocManager::install("DirichletMultinomial", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("TailRank", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("Biobase", dependencies=NA, Ncpus=8)'

# bash:
# leafcutter with flags
CXX14FLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive" \
CXX17FLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive" \
CXXFLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive -I$CONDA_PREFIX/include" \
MAKEFLAGS="-j1" \
Rscript -e 'remotes::install_github("davidaknowles/leafcutter/leafcutter", upgrade="never", Ncpus=8)'

