coble:
  - environment: r-362
channels: 
  - defaults
  - bioconda
  - conda-forge  
languages:  
  - r-base=3.6.2@source
flags:
  - dependencies: NA
  - system-tools: false
  - compile-tools: 7.5.0  
  - cran-repo: https://packagemanager.posit.co/cran/2020-04-01
bioc-conda:
  - DESeq2