#####################################################
# COBLE:Reproducible environment: icr-muspan, (c) ICR 2026
#####################################################
coble:
  - environment: icr-muspan
channels:
# note the reverse order of priority
  - defaults
  - r
  - bioconda
  - conda-forge
languages:
  - python=3.12@conda-forge
conda:
  - pip
conda:  
  - jupyterlab
  - ipykernel
  - ipywidgets
bash:  
echo -e 'GetMuSpAn\nSpatialBiology' | python -m pip install https://docs.muspan.co.uk/code/latest.zip
