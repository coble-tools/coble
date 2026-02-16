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
compilers:  
  - compile-tools: true
flags:      
  - system-tools: false
  - channel: bioconda
  - channel: conda-forge   
bash:
  - # This sed line is required when mixing r versions from the r channel with conda-forge source installs
  - sed -i 's/x86_64-conda_cos6-linux-gnu/x86_64-conda-linux-gnu/g' ${CONDA_PREFIX}/lib/R/etc/Makeconf
conda:
  - libcurl
r-conda:
  - matrix
  - survival
  - curl
  - httr
bioc-conda:
  - s4vectors
r-package:  
  - remotes   
  - BiocManager  
  - tidyverse
  - data.table
  - devtools
bioc-package:  
  - DESEq2
  - GenomicRanges
