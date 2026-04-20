##########################################################
# COBLE: boltz-2: https://github.com/jwohlwend/boltz
##########################################################
coble:
  - environment: boltz2
channels:
  - bioconda
  - conda-forge
languages:
  - python=3.12
conda:
  - pip
bash:
pip install boltz[cuda] -U
