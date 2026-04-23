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
bioc-conda:
  - DESeq2

