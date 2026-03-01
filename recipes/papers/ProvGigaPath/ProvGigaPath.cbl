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
  - packaging
  - pytorch::pytorch=2.0.0
  - pytorch::torchvision=0.15.0
  - pytorch::torchaudio=2.0.0
  - pytorch::pytorch-cuda=11.8
conda:
  - nvidia::cuda-cudart
  - nvidia::cuda-nvcc=11.8
bash:
  - conda config --env --remove channels nvidia
flags:
  - export: CUDA_HOME=$CONDA_PREFIX
  - export: TORCH_CUDA_ARCH_LIST="8.0"
  - export: LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$CONDA_PREFIX/lib/python3.9/site-packages/torch/lib:$LD_LIBRARY_PATH
#bash:
  # this is set for the build and in conda activate it is set for the environment
  #- export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$CONDA_PREFIX/lib/python3.9/site-packages/torch/lib:$LD_LIBRARY_PATH
bash:
pip:
  - psutil
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
  - mkdir -p $CONDA_PREFIX/GitHub/prov-gigapath
  - git clone https://github.com/rachelicr/prov-gigapath.git $CONDA_PREFIX/GitHub/prov-gigapath
  - mydir=$(pwd) && cd $CONDA_PREFIX/GitHub/prov-gigapath && python -m pip install -e . && cd $mydir
  - # necessary sim links
  - ln -s $CONDA_PREFIX/lib/libnvrtc.so.11.2 $CONDA_PREFIX/lib/libnvrtc.so
  - # correct LD_LIB on activation
  - unset LD_LIBRARY_PATH
  - conda env config vars unset LD_LIBRARY_PATH
  - mkdir -p $CONDA_PREFIX/etc/conda/activate.d
  - echo 'if [ -n "$APPTAINER_CONTAINER" ] || [ -n "$SINGULARITY_CONTAINER" ]; then' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
  - echo '    export LD_LIBRARY_PATH=/.singularity.d/libs:$LD_LIBRARY_PATH' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
  - echo 'fi' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
  - echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib:$CONDA_PREFIX/lib/python3.9/site-packages/torch/lib' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh