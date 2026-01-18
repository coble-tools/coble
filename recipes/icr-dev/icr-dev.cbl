#####################################################
# COBLE:Reproducible environment: DEV for pytest, (c) ICR 2026
#####################################################
coble:
  - environment: ptest-dev-env
channels:
  - conda-forge
languages:
  - python=3.13.1@conda-forge
conda:
  - requests
  - conda-build
  - anaconda-client
  - conda-index
pip:  
  - pytest
  - https://github.com/ICR-RSE-Group/gitalma.git