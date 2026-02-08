#####################################################
# COBLE:Reproducible environment: Designed to fail, (c) ICR 2026
#####################################################
coble:
  - environment: fails
channels:
  - bioconda
  - conda-forge
languages:
  - python=3.13.1@conda-forge
  - r-base=4.3.1@conda-forge
flags:
  - dependencies: NA  
  - compile-tools: true
conda:    
  - nonsense_fails