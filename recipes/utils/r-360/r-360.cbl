#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
coble:
  - environment: cbl-360
channels:  
  - defaults  
  - conda-forge  
  - bioconda
  - r
flags:    
  - priority: flexible
languages:
  - compile-version=7.5.0
  - compile-order=first
  - env-sims=true
  - base-sims=true
  - r-base=3.6.0
flags:
  - dependencies: NA  
  - build-tools: false
  - priority: strict
  - channel: bioconda
  - channel: conda-forge  
r-conda:  
  - ggplot2
  