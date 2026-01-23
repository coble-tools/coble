#####################################################
# COBLE:Reproducible environment: BASIC, (c) ICR 2026
#####################################################
coble:
  - environment: coble-env-basic
channels:
# note the reverse order of priority  
  - bioconda
  - conda-forge
languages:
  - python=3.14@conda-forge
  - r-base=4.5.2@conda-forge
flags:
  - dependencies: NA
  - compile-tools: true
conda:
  - rust
  - pandas
r-conda:  
  - ggplot2
  - dplyr
  - stringr
  - tidyr
