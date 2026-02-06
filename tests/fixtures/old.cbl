coble:
  - environment: DESeq2
channels: # note the reverse order of priority  
  - defaults
  - bioconda
  - conda-forge  
languages:  
  - r-base=3.6.2@conda-forge
flags:
  - dependencies: NA
  - system-tools: false
  - compile-tools: 7.5.0  
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