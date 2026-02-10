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
languages:
  - r-base=3.6.0@source
flags:
  - dependencies: NA
  - compile-tools: 13.1
  - build-tools: false
  - priority: strict
  - channel: bioconda
  - channel: conda-forge  
r-conda:    
  - tidyverse=1.3.1