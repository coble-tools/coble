#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-04-10
# Capture time: 09:59:28 BST
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi
# Using conda executable conda: /home/ralcraft/miniforge3/condabin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/condabin/conda
#####################################################

conda env remove --name netvis -y 2>/dev/null || true
conda create --no-default-packages --name netvis -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate netvis

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
# compilers:

# Language compile tools
conda install -y --solver=libmamba --no-update-deps -c conda-forge compilers
# languages:
CONDA_BASE=$(conda info --base)
ARCH=$(uname -m)

# deps: --no-update-deps
conda install -y --solver=libmamba --no-update-deps 'r-base=4.4.2'
conda install -y --solver=libmamba --no-update-deps r-remotes r-biocmanager r-renv
conda install -y --solver=libmamba --no-update-deps 'python=3.12.12'
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
# conda:
conda install -y --solver=libmamba --no-update-deps \
cairo=1.18 \
pango=1.56 
# r-conda:
conda install -y --solver=libmamba --no-update-deps \
'r-data.table' \
'r-tidyr' 
# r-package:
Rscript -e 'install.packages("tidyverse", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=1, method="wget")'
Rscript -e 'install.packages("visNetwork", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=1, method="wget")'
# pip:
python -m pip install 'requests' 
echo "#!/usr/bin/env bash" > ${CONDA_PREFIX}/bin/validate.sh
echo 'echo "COBLE validation: No script has been specified for netvis environment."' >> ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
mkdir -p ${CONDA_PREFIX}/coble-recipe
cp dev-recipes/netvis/netvis.cbl ${CONDA_PREFIX}/coble-recipe
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble ${CONDA_PREFIX}/bin/
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble-* ${CONDA_PREFIX}/bin/

