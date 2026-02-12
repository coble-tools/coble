#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-12
# Capture time: 17:54:10 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi
# Using conda executable conda: /home/ralcraft/miniforge3/envs/pytest/bin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/envs/pytest/bin/conda
#####################################################

conda env remove --name r-443-conda -y 2>/dev/null || true
conda create --no-default-packages --name r-443-conda -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate r-443-conda

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels defaults
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
#####################################################
# COBLE:Reproducible environment: carbine, (c) ICR 2026
#####################################################
# languages:
CONDA_BASE=$(conda info --base)
ARCH=$(uname -m)

conda install -y  'r-base=4.4.3'
conda install -y  'python=3.12'
python -m site
conda env config vars set PYTHONNOUSERSITE=1
export PYTHONNOUSERSITE=1
# flags:

# Language compile tools
conda install -y --no-update-deps -c conda-forge gcc_linux-64 gxx_linux-64 gfortran_linux-64
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
conda env config vars set CC="$CONDA_PREFIX/bin/gcc"
conda env config vars set CXX="$CONDA_PREFIX/bin/g++"
conda env config vars set FC="$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran"
conda env config vars set F77="$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran"
conda env config vars set CFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set CXXFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set CPPFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib --sysroot=$CONDA_PREFIX/x86_64-conda-linux-gnu/sysroot"
# Also as export to avoid de/activation
export CC="/home/ralcraft/miniforge3/envs/pytest/bin/gcc"
export CXX="/home/ralcraft/miniforge3/envs/pytest/bin/g++"
export FC="/home/ralcraft/miniforge3/envs/pytest/bin/x86_64-conda-linux-gnu-gfortran"
export F77="/home/ralcraft/miniforge3/envs/pytest/bin/x86_64-conda-linux-gnu-gfortran"
export CFLAGS="-I$CONDA_PREFIX/include"
export CXXFLAGS="-I$CONDA_PREFIX/include"
export CPPFLAGS="-I$CONDA_PREFIX/include"
export LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib --sysroot=$CONDA_PREFIX/x86_64-conda-linux-gnu/sysroot"


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
conda env config vars set QT_QPA_PLATFORM=offscreen
export QT_QPA_PLATFORM=offscreen
conda env config vars set OTEL_SDK_DISABLED=true
export OTEL_SDK_DISABLED=true
conda env config vars set R_OTEL_DISABLED=true
export R_OTEL_DISABLED=true
# conda:
conda install -y  --no-update-deps \
'arviz' 

# Validate script available in environment at CONDA PREFIX: validate.sh
cp recipes/utils/r-443-conda/validate/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
# Extra validation file: validate.sh:Zone.Identifier
cp recipes/utils/r-443-conda/validate//validate.sh:Zone.Identifier ${CONDA_PREFIX}/bin/validate.sh:Zone.Identifier
chmod +x ${CONDA_PREFIX}/bin/validate.sh:Zone.Identifier

