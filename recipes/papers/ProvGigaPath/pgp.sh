#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-27
# Capture time: 10:42:03 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi
# Using conda executable conda: /home/ralcraft/miniforge3/condabin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/condabin/conda
#####################################################

conda env remove --name pgp -y 2>/dev/null || true
conda create --no-default-packages --name pgp -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate pgp

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels defaults
conda config --env --add channels nvidia
conda config --env --add channels pytorch

# INSTALL SECTION FOR CONDA
#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
# ProvGigaPath
#######################################
# languages:
conda install -y --solver=libmamba --no-update-deps 'python=3.9'
python -m site
conda env config vars set PYTHONNOUSERSITE=1
export PYTHONNOUSERSITE=1
# conda:
conda install -y --solver=libmamba --no-update-deps \
pip
# conda:
conda install -y --solver=libmamba --no-update-deps \
cuda \
packaging \
pytorch::pytorch=2.0.0 \
pytorch::torchvision=0.15.0 \
pytorch::torchaudio=2.0.0 \
pytorch::pytorch-cuda=11.8
# conda:
conda install -y --solver=libmamba --no-update-deps \
nvidia::cuda-cudart
# bash:
conda config --env --remove channels nvidia
# flags:
conda env config vars set CUDA_HOME=$CONDA_PREFIX
export CUDA_HOME=$CONDA_PREFIX
conda env config vars set TORCH_CUDA_ARCH_LIST="8.0"
export TORCH_CUDA_ARCH_LIST="8.0"
# bash:
python -m pip install flash-attn==2.5.8 --no-build-isolation
# pip:
python -m pip install 'numpy==1.26.4'
python -m pip install 'omegaconf'
python -m pip install 'torchmetrics==0.10.3'
python -m pip install 'fvcore'
python -m pip install 'iopath'
python -m pip install 'xformers==0.0.18'
python -m pip install 'huggingface-hub==0.20.2'
python -m pip install 'h5py'
python -m pip install 'pandas'
python -m pip install 'pillow'
python -m pip install 'tqdm'
python -m pip install 'einops'
python -m pip install 'webdataset'
python -m pip install 'matplotlib'
python -m pip install 'lifelines'
python -m pip install 'scikit-survival'
python -m pip install 'scikit-learn'
python -m pip install 'tensorboard'
python -m pip install 'fairscale'
python -m pip install 'wandb'
python -m pip install 'timm>=1.0.3'
python -m pip install 'packaging==23.2'
python -m pip install 'ninja==1.11.1.1'
python -m pip install 'transformers==4.36.2'
python -m pip install 'monai==1.3.1'
python -m pip install 'openslide-python'
python -m pip install 'openslide-bin'
python -m pip install 'scikit-image'
# bash:
# Cloning the repo to CONDA_PREFIX for easy access in notebooks
mkdir -p $CONDA_PREFIX/GitHub/prov-gigapath
git clone https://github.com/rachelicr/prov-gigapath.git $CONDA_PREFIX/GitHub/prov-gigapath
cd $CONDA_PREFIX/GitHub/prov-gigapath && git switch fix/respect-device-parameter && python -m pip install -e .

# Validate script available in environment at CONDA PREFIX: validate.sh
cp recipes/papers/ProvGigaPath/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh

