#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-05-08
# Capture time: 18:31:30 BST
# Captured by: ralcraft
#####################################################
# source bashrc for conda
if [ -f ~/.bash_profile ]; then source ~/.bash_profile; elif [ -f ~/.bashrc ]; then source ~/.bashrc; elif command -v conda > /dev/null 2>&1; then eval "$(conda shell.bash hook)"; fi
# Using conda executable conda: /home/ralcraft/miniforge3/bin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/bin/conda
#####################################################

conda env remove --name velton_r46 -y 2>/dev/null || true
conda create --no-default-packages --name velton_r46 -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate velton_r46

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --show channels | grep -q 'channels:' && conda config --env --remove-key channels || true
conda config --env --set channel_priority strict
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
# code/coble build --recipe recipes/papers/velton2025/velton_r46.cbl --env velton_r46 --rebuild
#######################################
# comments:


# compilers:
# Flag: Directive: cran-repo, Value: 

# Language compile tools
conda install -y --solver=libmamba --no-update-deps -c conda-forge compilers

# conda:
conda install -y --solver=libmamba --no-update-deps \
r-base=4.6.0 

# flags:
# Flag: Directive: ncpus, Value: 8

# Including system dependencies for source installations
# Essential shared packages
conda install -y --solver=libmamba --no-update-deps -c conda-forge libcurl libprotobuf libpng libtiff libjpeg-turbo gdal proj geos gsl nlopt hdf5 cairo freetype expat fontconfig harfbuzz fribidi imagemagick
# Language build tools
conda install -y --solver=libmamba --no-update-deps -c conda-forge libtool autoconf cmake pkg-config
# Language core system libraries
conda install -y --solver=libmamba --no-update-deps -c conda-forge zlib bzip2 xz libxcrypt openssl sqlite

# r-package:
Rscript -e 'install.packages("ggplot2", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("data.table", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("curl", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=8)'

# r-package:
Rscript -e 'install.packages("igraph", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("Seurat", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("ROCR", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("fossil", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("reshape2", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("RCurl", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("BiocManager", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=8)'

# bioc-package:
Rscript -e 'BiocManager::install("biomaRt", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("GenomicFeatures", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("rtracklayer", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("HDF5Array", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("Rhdf5lib", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("rhdf5filters", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("rhdf5", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("ComplexHeatmap", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("GenomeInfoDb", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("XVector", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("methylumi", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("RnBeads", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("GenomicRanges", dependencies=NA, Ncpus=8)'

# r-package:
Rscript -e 'install.packages("pheatmap", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("viridis", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=8)'


# End of recipe
# Validation script setup
echo "#!/usr/bin/env bash" > ${CONDA_PREFIX}/bin/validate.sh
echo 'echo "COBLE validation: No script has been specified for velton_r46 environment."' >> ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
mkdir -p ${CONDA_PREFIX}/coble-recipe
cp recipes/papers/velton2025/velton_r46.cbl ${CONDA_PREFIX}/coble-recipe
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble ${CONDA_PREFIX}/bin/
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble-* ${CONDA_PREFIX}/bin/

