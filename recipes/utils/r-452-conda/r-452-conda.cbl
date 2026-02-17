##########################################################
# COBLE: Complex Bioinformatics Example, (c) ICR 2026
##########################################################
coble:
  - environment: 4-452
channels:
  - defaults
  - r
  - bioconda
  - conda-forge

compilers:  
  - compile-tools: true  

languages:
  - r-base=4.5.2@conda-forge
  - python=3.14.0@conda-forge

flags:  
  - system-tools: True
  - compile-version: 11.4  
  - ncpus: 8
  
r-conda:
  - matrix
  - survival
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