#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-09-20
# Capture time: 11:03:03 BST
# Captured by: rachel.alcraft
#####################################################
# source bashrc for conda
if [ -f ~/.bash_profile ]; then source ~/.bash_profile; elif [ -f ~/.bashrc ]; then source ~/.bashrc; elif command -v conda > /dev/null 2>&1; then eval "$(conda shell.bash hook)"; fi
# Using conda executable conda: /Users/rachel.alcraft/miniforge3/bin/conda
# Using conda alias conda: /Users/rachel.alcraft/miniforge3/bin/conda
#####################################################

conda env remove --name tmp -y 2>/dev/null || true
conda create --no-default-packages --name tmp -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate tmp

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --show channels | grep -q 'channels:' && conda config --env --remove-key channels || true
conda config --env --set channel_priority strict
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
# /Users/rachel.alcraft/dev/gh-bcds/COBLE/coble/code/coble build --recipe tmp.cbl --env tmp --rebuild
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
# conda:
conda install -y --solver=libmamba --no-update-deps \
cairo=1.18 \
pango=1.56 
# r-conda:
conda install -y --solver=libmamba --no-update-deps \
'r-data.table' \
'r-tidyr' 
# pip:
python -m pip install 'requests' 

# End of recipe
# Validation script setup
echo "#!/usr/bin/env bash" > ${CONDA_PREFIX}/bin/validate.sh
echo 'echo "COBLE validation: No script has been specified for tmp environment."' >> ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
mkdir -p ${CONDA_PREFIX}/coble-recipe
cp tmp.cbl ${CONDA_PREFIX}/coble-recipe
cp /Users/rachel.alcraft/dev/gh-bcds/COBLE/coble/code/coble ${CONDA_PREFIX}/bin/
cp /Users/rachel.alcraft/dev/gh-bcds/COBLE/coble/code/coble-* ${CONDA_PREFIX}/bin/

