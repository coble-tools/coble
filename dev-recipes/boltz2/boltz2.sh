#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-03-18
# Capture time: 22:21:37 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi
# Using conda executable conda: /home/ralcraft/miniforge3/bin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/bin/conda
#####################################################

conda env remove --name boltz2 -y 2>/dev/null || true
conda create --no-default-packages --name boltz2 -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate boltz2

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
##########################################################
# COBLE: boltz-2: https://github.com/jwohlwend/boltz
##########################################################
# languages:
conda install -y --solver=libmamba --no-update-deps 'python=3.12'
python -m site
conda env config vars set PYTHONNOUSERSITE=1
export PYTHONNOUSERSITE=1
# conda:
conda install -y --solver=libmamba --no-update-deps \
pip 
# bash:
pip install boltz[cuda] -U

# Validate script available in environment at CONDA PREFIX: validate.sh
cp dev-recipes/boltz2/validate/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
# Extra validation file: affinity.yaml
cp dev-recipes/boltz2/validate/affinity.yaml ${CONDA_PREFIX}/bin/affinity.yaml
chmod +x ${CONDA_PREFIX}/bin/affinity.yaml

