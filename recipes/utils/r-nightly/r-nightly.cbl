#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
coble:
  - environment: r-nightly
channels:  
  - defaults
  - bioconda
  - conda-forge  
languages:
  - r-base=devel@source
flags:
  - dependencies: NA
  - compile-tools: true
  - build-tools: false   
r-conda:    
  - tidyverse