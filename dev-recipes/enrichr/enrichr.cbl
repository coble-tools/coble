#####################################################
# COBLE:Reproducible environment: for ctv-app, Romanos
#####################################################
coble:
  - environment: coble-enrichr
channels:
# note the reverse order of priority  
  - bioconda
  - conda-forge
languages:  
  - r-base=4.5.2@conda-forge
flags:
  - dependencies: NA
  - system-tools: true
  - compile-tools: 13.1
r-conda:    
  - enrichR
r-package:
  - enrichR
  - enrichR=3.4
  - enrichR=3.2
  - clv=0.3-2.5
  
  
