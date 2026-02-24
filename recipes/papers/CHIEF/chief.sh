#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-24
# Capture time: 22:18:48 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi
# Using conda executable conda: /home/ralcraft/miniforge3/bin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/bin/conda
#####################################################

conda env remove --name chief -y 2>/dev/null || true
conda create --no-default-packages --name chief -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate chief

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
# flags:
# flags for gpu-dev
#- export: CUDA="cu118"
#- export: TORCH="2.3.0"
#- export: TORCHVISION="0.18.0"
#- export: TORCHAUDIO="2.3.0"
# flags for RA laptop
conda env config vars set CUDA="cu128"
export CUDA="cu128"
conda env config vars set TORCH="2.6.0"
export TORCH="2.6.0"
conda env config vars set TORCHVISION="0.21.0"
export TORCHVISION="0.21.0"
conda env config vars set TORCHAUDIO="2.6.0"
export TORCHAUDIO="2.6.0"
# conda:
conda install -y --solver=libmamba --no-update-deps \
'typing_extensions' \
'pillow' \
'pyyaml' \
'pandas' \
'scikit-learn' \
'ipykernel' \
'requests' \
'openslide' \
'openslide-python' 
# bash:
python -m pip install pip install torch==$TORCH torchvision==$TORCHVISION torchaudio==$TORCHAUDIO --index-url https://download.pytorch.org/whl/$CUDA
wget "https://drive.google.com/uc?export=download&id=1JV7aj9rKqGedXY1TdDfi3dP07022hcgZ" -O timm-0.5.4.tar
python -m pip install timm-0.5.4.tar
rm -rf timm-0.5.4.tar
# pip:
python -m pip install 'addict' 
# flags:
conda env config vars set LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH
# bash:
# Download the CHIEF github repo and install the CHIEF model files - clone to the conda env so they are on the python path and can be found by CHIEF
git clone https://github.com/hms-dbmi/CHIEF.git $CONDA_PREFIX/CHIEF
# These are the CHIEF model files - we put the CTransPath file in the conda env so it is on the python path and can be found by CHIEF
mkdir -p $CONDA_PREFIX/CHIEF/model_weight
wget "https://drive.google.com/uc?export=download&id=1_vgRF1QXa8sPCOpJ1S9BihwZhXQMOVJc" -O $CONDA_PREFIX/CHIEF/model_weight/CHIEF_CTransPath.pth
wget "https://drive.google.com/uc?export=download&id=1OCxAy37PfT8wVdbFzq2Lq963R7zlut3u" -O $CONDA_PREFIX/CHIEF/model_weight/CHIEF_finetune.pth
wget "https://drive.google.com/uc?export=download&id=10bJq_ayX97_1w95omN8_mESrYAGIBAPb" -O $CONDA_PREFIX/CHIEF/model_weight/CHIEF_pretraining.pth
wget "https://drive.google.com/uc?export=download&id=1sVGmlTdnSJdcCK1vuswsuReKMUjvSEmX" -O $CONDA_PREFIX/CHIEF/model_weight/Text_embedding.pth
# rename some of the misnamed folders
mv $CONDA_PREFIX/CHIEF/example $CONDA_PREFIX/CHIEF/exsample
mv $CONDA_PREFIX/CHIEF/example_csv $CONDA_PREFIX/CHIEF/exsample_csvconda activate
echo "CONDA_PREFIX=${CONDA_PREFIX}"

# Validate script available in environment at CONDA PREFIX: validate.sh
cp recipes/papers/CHIEF/validate/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh

