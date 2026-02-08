#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
coble:
  - environment: cbl-362
channels:
  - r
  - bioconda
  - conda-forge
  - defaults
flags:    
  - priority: flexible
languages:
  - compile-version=7.5.0
  - compile-order=with
  - env-sims=true
  - base-sims=true
  - r-base=3.6.2
flags:
  - dependencies: NA  
  - build-tools: false
  - priority: strict
  - channel: bioconda
  - channel: conda-forge  
r-conda:  
  - ggplot2
  