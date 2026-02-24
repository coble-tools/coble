coble:
  - environment: chief-dev
channels:
  - conda-forge
languages:
  - python=3.10
flags:
  # flags for gpu-dev
  #- export: CUDA="cu118"
  #- export: TORCH="2.3.0"
  #- export: TORCHVISION="0.18.0"
  #- export: TORCHAUDIO="2.3.0"
  # flags for RA laptop
  - export: CUDA="cu128"
  - export: TORCH="2.6.0"
  - export: TORCHVISION="0.21.0"
  - export: TORCHAUDIO="2.6.0"
conda:
  - typing_extensions
  - pillow
  - pyyaml
  - pandas
  - scikit-learn
  - ipykernel
  - requests
  - openslide
  - openslide-python
bash:
  - python -m pip install pip install torch==$TORCH torchvision==$TORCHVISION torchaudio==$TORCHAUDIO --index-url https://download.pytorch.org/whl/$CUDA
  - wget "https://drive.google.com/uc?export=download&id=1JV7aj9rKqGedXY1TdDfi3dP07022hcgZ" -O timm-0.5.4.tar
  - python -m pip install timm-0.5.4.tar
  - rm -rf timm-0.5.4.tar
pip:
  - addict
  - gdown
flags:
  - export: LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH
bash:
  # Download the CHIEF github repo and install the CHIEF model files - clone to the conda env so they are on the python path and can be found by CHIEF
  - git clone https://github.com/hms-dbmi/CHIEF.git $CONDA_PREFIX/CHIEF
  # These are the CHIEF model files - we put the CTransPath file in the conda env so it is on the python path and can be found by CHIEF
  - mkdir -p $CONDA_PREFIX/CHIEF/model_weight
  - gdown "1_vgRF1QXa8sPCOpJ1S9BihwZhXQMOVJc" -O $CONDA_PREFIX/CHIEF/model_weight/CHIEF_CTransPath.pth
  - gdown "1OCxAy37PfT8wVdbFzq2Lq963R7zlut3u" -O $CONDA_PREFIX/CHIEF/model_weight/CHIEF_finetune.pth
  - gdown "10bJq_ayX97_1w95omN8_mESrYAGIBAPb" -O $CONDA_PREFIX/CHIEF/model_weight/CHIEF_pretraining.pth
  - gdown "1sVGmlTdnSJdcCK1vuswsuReKMUjvSEmX" -O $CONDA_PREFIX/CHIEF/model_weight/Text_embedding.pth
  # rename some of the misnamed folders
  - mv $CONDA_PREFIX/CHIEF/example $CONDA_PREFIX/CHIEF/exsample
  - mv $CONDA_PREFIX/CHIEF/example_csv $CONDA_PREFIX/CHIEF/exsample_csvconda activate
  - mv ./model_weight/Text_embedding.pth ./model_weight/Text_emdding.pth
  # need to edit some code if pytirch version is > 2.5

