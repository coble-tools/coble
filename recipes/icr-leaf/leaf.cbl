##########################################################
# COBLE: Complex Bioinformatics Example, (c) ICR 2026
##########################################################
coble:
  - environment: coble-env-bioinf
channels:
# note the reverse order of priority  
  - bioconda
  - conda-forge
languages:
  - r-base=4.5.2@conda-forge
  - python=3.14.0@conda-forge
flags:
  - dependencies: NA
  - system-tools: True
  - compile-tools: 11
  - ncpus: 8    
  - export: CXX14FLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive"
  - export: CXX17FLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive"
  - export: CXXFLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive"
  - export: MAKEFLAGS="-j1"
conda:
  - tbb<2021
  - tbb-devel<2021    
r-package:
  - RcppEigen
  - StanHeaders=2.21.0-7
  - rstan=2.21.2  
bioc-package:
  - DirichletMultinomial
  - TailRank  
  - Biobase  
r-github:  
  - davidaknowles/leafcutter/leafcutter
