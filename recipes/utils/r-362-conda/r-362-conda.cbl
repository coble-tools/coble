coble:
  - environment: r-362-conda
channels: 
  - defaults
  - bioconda
  - conda-forge  
compilers:  
  - cran-repo: https://packagemanager.posit.co/cran/2020-04-01
languages:  
  - r-base=3.6.2
bioc-conda:
  - DESeq2