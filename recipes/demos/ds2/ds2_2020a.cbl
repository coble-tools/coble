# code/coble build --recipe recipes/papers/DESeq2/DESeq2_2020.cbl --env deseq206 --rebuild
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
r-package:
  - rlang
  - vctrs
  - Matrix
  - cachem
  - memoise
  - blob
  - cpp11
  - RSQLite
  - RcppArmadillo
  - XML
  - locfit
  - testthat=1.0.2
  - ggplot2
  - Hmisc
bioc-package:
  - DESeq2

