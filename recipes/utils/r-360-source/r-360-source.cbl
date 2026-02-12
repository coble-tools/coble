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
  - cran-repo: https://packagemanager.posit.co/cran/2020-04-01
conda:
  - sysroot_linux-64=2.17
bash:
  - unset LD_LIBRARY_PATH
languages:
  - r-base=3.6.0@source
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