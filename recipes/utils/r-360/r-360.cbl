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
  - cran-repo: https://packagemanager.posit.co/cran/2020-04-01
r-url:
  - https://cran.r-project.org/src/contrib/Archive/remotes/remotes_2.4.2.tar.gz  
r-package:    
  - biocmanager=1.30.22
  - tidyverse=1.3.1