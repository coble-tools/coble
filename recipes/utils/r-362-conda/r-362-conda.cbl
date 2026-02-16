#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
coble:
  - environment: r-362
channels:    
  - bioconda
  - conda-forge
compilers:    
  - cran-repo: https://packagemanager.posit.co/cran/2020-04-01  
flags:            
  - compile-version: 7.5
languages:
  - r-base=3.6.2
conda:
  - libcurl
r-conda:
  - matrix
  - survival
  - curl
  - httr
  - testthat
  - ggplot2
  - isoband
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