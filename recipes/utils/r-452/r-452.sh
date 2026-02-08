#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-08
# Capture time: 17:26:49 GMT
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
# Target environment r-452
# Target path /home/ralcraft/miniforge3/envs/pytest/envs/r-452
#####################################################

# Detected platform: OS=linux, ARCH=x86_64, PLATFORM=linux-64
# Compiler packages: c-compiler cxx-compiler fortran-compiler
# Compiler packages: sysroot_linux-64
# Compiler packages: gcc_linux-64 gxx_linux-64 gfortran_linux-64
/home/ralcraft/miniforge3/condabin/conda env remove --name r-452 -y 2>/dev/null || true
/home/ralcraft/miniforge3/condabin/conda create --no-default-packages --name r-452 -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
umask 0022
# activate environment
conda activate r-452

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
/home/ralcraft/miniforge3/condabin/conda config --env --remove-key channels || true
/home/ralcraft/miniforge3/condabin/conda config --env --set channel_priority strict
/home/ralcraft/miniforge3/condabin/conda config --env --add channels defaults
/home/ralcraft/miniforge3/condabin/conda config --env --add channels r
/home/ralcraft/miniforge3/condabin/conda config --env --add channels bioconda
/home/ralcraft/miniforge3/condabin/conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
##########################################################
# COBLE: Complex Bioinformatics Example, (c) ICR 2026
##########################################################
# note the reverse order of priority

# languages:
# Setting compile tools version to 13.1
# Setting compile order: with
# Setting env sims: true
conda install -y  \
  'gcc_linux-64=13.1' 'gxx_linux-64=13.1' 'gfortran_linux-64=13.1' \
  c-compiler cxx-compiler fortran-compiler \
  sysroot_linux-64 \
  'r-base=4.5.2' r-remotes r-biocmanager

# Set up compiler symlinks for R package compilation - Linux x86_64
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
conda activate r-452

conda install -y  'conda-forge::python=3.14.0'
python -m site
/home/ralcraft/miniforge3/condabin/conda env config vars set PYTHONNOUSERSITE=1
conda deactivate
conda activate r-452

# flags:
# Flag: Directive: dependencies, Value: na

# Including system dependencies for source installations
# Essential shared packages
conda install -y --no-update-deps -c conda-forge libcurl libprotobuf libpng libtiff libjpeg-turbo gdal proj geos gsl nlopt hdf5 cairo freetype expat fontconfig harfbuzz fribidi imagemagick
# System r packages
# Essential r packages

# Essential python packages

# Language build tools
conda install -y --no-update-deps -c conda-forge make cmake pkg-config
# Language core system libraries
conda install -y --no-update-deps -c conda-forge zlib bzip2 xz libxcrypt openssl sqlite
# Flag: Directive: ncpus, Value: 8

# bash:
# Special installs outside of conda for awkward pysamstats package
python -m pip install "setuptools>=59.0"
python -m pip install --upgrade "Cython>=3.0.11"
python -m pip install pysam
CFLAGS="-Wno-error=incompatible-pointer-types" CPPFLAGS="-Wno-error=incompatible-pointer-types" python -m pip install --no-build-isolation git+https://github.com/rachelicr/pysamstats.git

# r-conda:
conda install -y  --no-update-deps \
'r-biocmanager' \
'r-devtools' \
'r-data.table' 
# bioc-package:
Rscript -e 'BiocManager::install("fgsea", dependencies=NA, Ncpus=8)'

# r-conda:
conda install -y  --no-update-deps \
'r-stringi' \
'r-rcpp' \
'r-plyr' \
'r-reticulate' \
'r-sitmo' \
'r-seurat' \
'r-units' 

# r-conda:
conda install -y  --no-update-deps \
'r-raster' \
'r-spdep' \
'r-magick' 
# bioc-package:
Rscript -e 'BiocManager::install("stJoincount", dependencies=NA, Ncpus=8)'


# Validate script available in environment at CONDA PREFIX: validate.sh
cp recipes/utils/r-452/validate/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh

