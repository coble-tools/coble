#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-04-23
# Capture time: 12:49:43 BST
# Captured by: ralcraft
#####################################################
# source bashrc for conda
if [ -f ~/.bash_profile ]; then source ~/.bash_profile; elif [ -f ~/.bashrc ]; then source ~/.bashrc; elif command -v conda > /dev/null 2>&1; then eval "$(conda shell.bash hook)"; fi
# Using conda executable conda: /home/ralcraft/miniforge3/condabin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/condabin/conda
#####################################################

conda env remove --name ds26b -y 2>/dev/null || true
conda create --no-default-packages --name ds26b -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate ds26b

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --show channels | grep -q 'channels:' && conda config --env --remove-key channels || true
conda config --env --set channel_priority strict
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
# code/coble build --recipe recipes/papers/DESeq2/DESeq2_2026.cbl --env deseq206 --rebuild

# code/coble-disentangle.py recipes/papers/DESeq2/DESeq2_2026_export.cbl recipes/papers/DESeq2/DESeq2_2026_network.txt
# python code/coble-plot-network.py recipes/papers/DESeq2/DESeq2_2026_network.txt --hue date --out recipes/papers/DESeq2/DESeq2_2026_networkd.html
# python code/coble-plot-network.py recipes/papers/DESeq2/DESeq2_2026_network.txt --hue manager --out recipes/papers/DESeq2/DESeq2_2026_networkm.html

# languages:
CONDA_BASE=$(conda info --base)
ARCH=$(uname -m)

# deps: --no-update-deps
conda install -y --solver=libmamba --no-update-deps 'r-base=4.5.2'
conda install -y --solver=libmamba --no-update-deps r-remotes r-biocmanager r-renv
# compilers:

# Language compile tools
conda install -y --solver=libmamba --no-update-deps -c conda-forge compilers
# Flag: Directive: cran-repo, Value: 
# flags:

# Including system dependencies for source installations
# Essential shared packages
conda install -y --solver=libmamba --no-update-deps -c conda-forge libcurl libprotobuf libpng libtiff libjpeg-turbo gdal proj geos gsl nlopt hdf5 cairo freetype expat fontconfig harfbuzz fribidi imagemagick
# System r packages
conda install -y --solver=libmamba --no-update-deps -c conda-forge librsvg udunits2
# Essential r packages
conda install -y --solver=libmamba --no-update-deps -c conda-forge r-cpp11 r-openssl r-rsqlite r-essentials r-rsvg

# Language build tools
conda install -y --solver=libmamba --no-update-deps -c conda-forge libtool autoconf cmake pkg-config
# Language core system libraries
conda install -y --solver=libmamba --no-update-deps -c conda-forge zlib bzip2 xz libxcrypt openssl sqlite
# bioc-conda:
conda install -y --solver=libmamba --no-update-deps \
'bioconductor-DESeq2' 






# End of recipe
# Validation script setup
echo "#!/usr/bin/env bash" > ${CONDA_PREFIX}/bin/validate.sh
echo 'echo "COBLE validation: No script has been specified for ds26b environment."' >> ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
mkdir -p ${CONDA_PREFIX}/coble-recipe
cp recipes/demos/ds2/ds2_2026b.cbl ${CONDA_PREFIX}/coble-recipe
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble ${CONDA_PREFIX}/bin/
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble-* ${CONDA_PREFIX}/bin/

