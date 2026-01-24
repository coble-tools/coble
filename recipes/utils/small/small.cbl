#####################################################
# COBLE:Reproducible environment: BASIC, (c) ICR 2026
#####################################################
coble:
  - environment: small
channels:
# note the reverse order of priority  
  - bioconda
  - conda-forge
languages:  
  - r-base=4.3.1@conda-forge
flags:
  - dependencies: NA
  - system-tools: False
  - compile-tools: 13.1    
  - network-viz: true
r-conda:  
  - ggplot2