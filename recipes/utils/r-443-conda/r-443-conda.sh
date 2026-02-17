#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-16
# Capture time: 23:24:38 GMT
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
# compilers:

# Language compile tools
conda install -y --solver=libmamba --no-update-deps -c conda-forge compilers
# languages:
CONDA_BASE=$(conda info --base)
ARCH=$(uname -m)

# deps: --no-update-deps
conda install -y --solver=libmamba --no-update-deps 'r-base=4.4.3'
conda install -y --solver=libmamba --no-update-deps r-remotes r-biocmanager
conda install -y --solver=libmamba --no-update-deps 'python=3.12'
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
conda env config vars set QT_QPA_PLATFORM=offscreen
export QT_QPA_PLATFORM=offscreen
conda env config vars set OTEL_SDK_DISABLED=true
export OTEL_SDK_DISABLED=true
conda env config vars set R_OTEL_DISABLED=true
export R_OTEL_DISABLED=true
# conda:
conda install -y --solver=libmamba --no-update-deps \
'arviz' 
cat > ${CONDA_PREFIX}/bin/validate.sh << 'VALIDATE_EOF'
#!/usr/bin/env bash
echo "COBLE validation: No script has been specified for r-443-conda environment."
VALIDATE_EOF
chmod +x ${CONDA_PREFIX}/bin/validate.sh

