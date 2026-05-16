#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-05-05
# Capture time: 13:55:53 BST
# Captured by: ralcraft
#####################################################
# source bashrc for conda
if [ -f ~/.bash_profile ]; then source ~/.bash_profile; elif [ -f ~/.bashrc ]; then source ~/.bashrc; elif command -v conda > /dev/null 2>&1; then eval "$(conda shell.bash hook)"; fi
# Using conda executable conda: /home/ralcraft/miniforge3/condabin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/condabin/conda
#####################################################

conda env remove --name coulton2024 -y 2>/dev/null || true
conda create --no-default-packages --name coulton2024 -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate coulton2024

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
# code/coble build --recipe recipes/demos/coulton2024/coulton2024.cbl --env coulton2024 --rebuild
#######################################
# comments:
# compilers:
# Flag: Directive: cran-repo, Value: 
# conda:
conda install -y --solver=libmamba --no-update-deps \
r-base=4.2.2 
# r-conda:
conda install -y --solver=libmamba --no-update-deps \
'r-Seurat' \
'r-ggsci' \
'r-harmony' \
'r-patchwork' \
'r-dplyr' \
'r-Matrix' 
# bioc-conda:
conda install -y --solver=libmamba --no-update-deps \
'bioconductor-rhdf5' 


# End of recipe
# Validation script setup
echo "#!/usr/bin/env bash" > ${CONDA_PREFIX}/bin/validate.sh
echo 'echo "COBLE validation: No script has been specified for coulton2024 environment."' >> ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
mkdir -p ${CONDA_PREFIX}/coble-recipe
cp recipes/demos/coulton2024/coulton2024.cbl ${CONDA_PREFIX}/coble-recipe
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble ${CONDA_PREFIX}/bin/
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble-* ${CONDA_PREFIX}/bin/

