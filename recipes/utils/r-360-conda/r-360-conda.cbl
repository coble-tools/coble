#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
coble:
  - environment: r-360
channels:    
  - r
compilers:  
  - cran-repo: https://packagemanager.posit.co/cran/2020-04-01  
languages:
  - r-base=3.6.0@r
bash:
  - conda config --env --remove channels r
flags:      
  - channel: bioconda
  - channel: conda-forge   
compilers:  
  - compile-tools: 7
r-package:  
  - remotes 
  - BiocManager
  - tidyverse
