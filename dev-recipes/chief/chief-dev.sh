#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-24
# Capture time: 11:35:37 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi
# Using conda executable conda: /home/ralcraft/miniforge3/envs/pytest/bin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/envs/pytest/bin/conda
#####################################################

conda env remove --prefix ./CHIEF-DEV -y 2>/dev/null || true
conda create --no-default-packages --prefix ./CHIEF-DEV -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate ./CHIEF-DEV

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
# languages:
conda install -y --solver=libmamba --no-update-deps 'python=3.10'
python -m site
conda env config vars set PYTHONNOUSERSITE=1
export PYTHONNOUSERSITE=1
# conda:
conda install -y --solver=libmamba --no-update-deps \
'typing_extensions' \
'pillow' \
'pyyaml' \
'pandas' \
'scikit-learn' \
'ipykernel' \
'requests' 
# bash:
#- python -m pip install torch --index-url https://download.pytorch.org/whl/cu128
python -m pip install pip install torch==2.3.0 torchvision==0.18.0 torchaudio==2.3.0 --index-url https://download.pytorch.org/whl/cu118
wget "https://drive.google.com/uc?export=download&id=1JV7aj9rKqGedXY1TdDfi3dP07022hcgZ" -O timm-0.5.4.tar
python -m pip install timm-0.5.4.tar
rm -rf timm-0.5.4.tar
# pip:
python -m pip install 'addict' 
# flags:
conda env config vars set LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH
echo "CONDA_PREFIX=${CONDA_PREFIX}"

# Validate script available in environment at CONDA PREFIX: validate.sh
cp dev-recipes/chief/validate/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh

