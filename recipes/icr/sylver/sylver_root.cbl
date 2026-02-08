#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
coble:
  - environment: coble-env
channels:
# note the reverse order of priority  
  - r
  - bioconda
  - conda-forge
  - defaults
flags:    
  - priority: flexible
languages:
  - compile-version=7.5.0
  - separate-r=true
  - r-base=3.6.0@r
flags:
  - dependencies: NA  
  - build-tools: false
  - priority: strict
  - channel: bioconda
  - channel: conda-forge  
