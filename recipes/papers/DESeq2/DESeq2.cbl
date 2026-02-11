coble:
  - environment: DESeq2
channels: # note the reverse order of priority  
  - defaults
  - bioconda
  - conda-forge  
compilers:
  - compile-tools: 7.5.0
  - cran-repo: https://packagemanager.posit.co/cran/2020-04-01
languages:  
  - r-base=3.6.2@source
conda:
  - binutils>=2.38
  - binutils_impl_linux-64>=2.38
r-package:
  - cli
  - crayon
  - digest
  - ellipsis
  - evaluate
  - magrittr
  - pkgload
  - praise
  - R6
  - rlang
  - withr  
  - testthat=2.3.2
  - mockery=0.4.2
  - remotes=2.1.1
bioc-package:
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
r-package:
  - samr
  - PoiClaClu
#bash:
#cp recipes/publications/DESeq2/DESeq2.R \
#$CONDA_PREFIX/bin/DESeq2.R




