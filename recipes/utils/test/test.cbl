#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
coble:
  - environment: DESeq2
channels:    
  - bioconda
  - conda-forge
compilers:    
  - cran-repo: https://packagemanager.posit.co/cran/2020-04-01  
flags:            
  - compile-version: 7.5
languages:
  - r-base=3.6.2
#conda:
#  - binutils>=2.38
#  - binutils_impl_linux-64>=2.38

bioc-conda:
  - DESeq2
  - DESeq
  - edgeR
  - DSS
  - limma  
  - EBSeq
  - parathyroidSE
  - pasilla 
conda:
  - GFOLD
r-conda:
  - samr
  - PoiClaClu

