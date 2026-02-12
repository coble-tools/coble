#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
coble:
  - environment: r-360
channels:
  - r
  - bioconda
  - conda-forge
  - defaults
compilers:
  - compile-tools: 7.5.0
languages:
  - r-base=3.6.0
flags:
  - dependencies: NA  
  - build-tools: false
  - priority: strict
  - channel: bioconda
  - channel: conda-forge    
r-package:  
  - remotes 
  - biocmanager
  - tidyverse