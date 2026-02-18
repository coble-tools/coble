#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
coble:
  - environment: r-nightly
channels:  
  - defaults
  - bioconda
  - conda-forge  
compilers:  
  - compile-tools: true  
languages:
  - r-base=devel@source
flags:
  - dependencies: NA  
  - build-tools: false   
r-package:    
  - tidyverse