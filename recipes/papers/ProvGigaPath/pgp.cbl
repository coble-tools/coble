#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
# ProvGigaPath
#######################################
coble:
  - environment: pgp
channels:
  - defaults
  - nvidia
  - pytorch
languages:
  - python=3.9
conda:
  - pip
conda:
  - cuda
  - packaging
  - pytorch=2.0.0
  - torchvision=0.15.0
  - torchaudio=2.0.0
  - pytorch-cuda=11.8
flags:
  - export: CUDA_HOME=$CONDA_PREFIX
  - export: TORCH_CUDA_ARCH_LIST="8.0"
bash:
  - python -m pip install flash-attn==2.5.8 --no-build-isolation
pip:
  - numpy==1.26.4
  - omegaconf
  - torchmetrics==0.10.3
  - fvcore
  - iopath
  - xformers==0.0.18
  - huggingface-hub==0.20.2
  - h5py
  - pandas
  - pillow
  - tqdm
  - einops
  - webdataset
  - matplotlib
  - lifelines
  - scikit-survival
  - scikit-learn
  - tensorboard
  - fairscale
  - wandb
  - timm>=1.0.3
  - packaging==23.2
  - ninja==1.11.1.1
  - transformers==4.36.2
  - monai==1.3.1
  - openslide-python
  - openslide-bin
  - scikit-image
bash:
  - # Cloning the repo to CONDA_PREFIX for easy access in notebooks
  - mkdir -p $CONDA_PREFIX/GitHub
  - git clone https://github.com/prov-gigapath/prov-gigapath.git $CONDA_PREFIX/GitHub
  - python -m pip install -e $CONDA_PREFIX/GitHub
  - python -m pip uninstall xformers -y