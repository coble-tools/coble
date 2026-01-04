#####################################################
# COBLE:Reproducible environment: BASIC, (c) ICR 2025
#####################################################
coble:
  - environment: coble-env-basic
channels:
# note the reverse order of priority
  - defaults
  - r
  - bioconda
  - conda-forge
languages:
  - python=3.13.1@conda-forge
  - r-base=4.3.1@conda-forge
flags:
  - dependencies: NA
  - build-tools: False
  - export: CFLAGS="-I$CONDA_PREFIX/include"
conda:
  - pandas
r-conda:  
  - ggplot2
bioc-conda:
  - fgsea