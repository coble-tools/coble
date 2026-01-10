#####################################################
# COBLE:Reproducible environment: BASIC, (c) ICR 2026
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
  - system-tools: False
  - compile-tools: True  
conda:
  - pandas
r-conda:  
  - ggplot2
bioc-conda:
  - fgsea
r-package:
  - dplyr