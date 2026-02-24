coble:
  - environment: chief-dev
channels:
  - conda-forge
languages:
  - python=3.10
conda:
  - typing_extensions
  - pillow
  - pyyaml
  - pandas
  - scikit-learn
  - ipykernel
  - requests
bash:
  #- python -m pip install torch --index-url https://download.pytorch.org/whl/cu128
  - python -m pip install pip install torch==2.3.0 torchvision==0.18.0 torchaudio==2.3.0 --index-url https://download.pytorch.org/whl/cu118
  - wget "https://drive.google.com/uc?export=download&id=1JV7aj9rKqGedXY1TdDfi3dP07022hcgZ" -O timm-0.5.4.tar
  - python -m pip install timm-0.5.4.tar
  - rm -rf timm-0.5.4.tar
pip:
  - addict
flags:
  - export: LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH