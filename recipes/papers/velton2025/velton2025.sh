#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-05-09
# Capture time: 18:35:37 BST
# Captured by: ralcraft
#####################################################
# source bashrc for conda
if [ -f ~/.bash_profile ]; then source ~/.bash_profile; elif [ -f ~/.bashrc ]; then source ~/.bashrc; elif command -v conda > /dev/null 2>&1; then eval "$(conda shell.bash hook)"; fi
# Using conda executable conda: /home/ralcraft/miniforge3/condabin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/condabin/conda
#####################################################

conda env remove --name velton2025 -y 2>/dev/null || true
conda create --no-default-packages --name velton2025 -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate velton2025

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
# code/coble build --recipe recipes/papers/velton2025/velton2025.cbl --env velton2025 --rebuild --val-folder recipes/papers/velton2025/validate --validate recipes/papers/velton2025/validate/validate.sh
#######################################
# comments:
# compilers:
# Flag: Directive: cran-repo, Value: 
# conda:
conda install -y --solver=libmamba --no-update-deps \
r-base=4.2.2 
# r-conda:
conda install -y --solver=libmamba --no-update-deps \
'r-ggplot2=3.4.1' \
'r-Seurat=4.3.0' \
'r-ROCR=1.0' \
'r-fossil=0.4.0' \
'r-reshape2=1.4.4' \
'r-RCurl' \
'r-xml2' \
'r-XML' \
'r-locfit' \
'r-corrplot' \
'r-harmony' \
'r-infotheo' \
'r-caret' \
'r-randomForest' \
'r-uwot' 
# bioc-conda:
conda install -y --solver=libmamba --no-update-deps \
'bioconductor-biomaRt' \
'bioconductor-GenomicFeatures' \
'bioconductor-rtracklayer' \
'bioconductor-HDF5Array' \
'bioconductor-Rhdf5lib' \
'bioconductor-rhdf5filters' \
'bioconductor-rhdf5' \
'bioconductor-ComplexHeatmap=2.14.0' \
'bioconductor-GenomeInfoDb' \
'bioconductor-XVector' 
# r-package:
Rscript -e 'install.packages("BiocManager", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
# bioc-package:
Rscript -e 'BiocManager::install("methylumi", dependencies=NA, Ncpus=1)'
Rscript -e 'BiocManager::install("RnBeads", dependencies=NA, Ncpus=1)'
Rscript -e 'BiocManager::install("GenomicRanges", dependencies=NA, Ncpus=1)'
# r-conda:
conda install -y --solver=libmamba --no-update-deps \
'r-pheatmap=1.0.12' \
'r-viridis=0.6.2' 

# bash:
mkdir -p $CONDA_PREFIX/GitHub/
git clone https://github.com/veltenlab/EPI-clone.git $CONDA_PREFIX/GitHub/EPI-clone
mkdir -p $CONDA_PREFIX/GitHub/EPI-clone/data/
curl -L -o $CONDA_PREFIX/GitHub/EPI-clone/data/larry_seurat.rds 'https://api.figshare.com/v2/file/download/42479346'


# End of recipe
# Validation script setup
echo "#!/usr/bin/env bash" > ${CONDA_PREFIX}/bin/validate.sh
echo 'echo "COBLE validation: No script has been specified for velton2025 environment."' >> ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
mkdir -p ${CONDA_PREFIX}/coble-recipe
cp recipes/papers/velton2025/velton2025.cbl ${CONDA_PREFIX}/coble-recipe
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble ${CONDA_PREFIX}/bin/
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble-* ${CONDA_PREFIX}/bin/

