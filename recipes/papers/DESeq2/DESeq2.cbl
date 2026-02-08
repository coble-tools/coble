coble:
  - environment: DESeq2
channels: # note the reverse order of priority  
  - defaults
  - bioconda
  - conda-forge  
flags:    
  - priority: flexible
languages:  
  - compile-version=7.5.0
  - separate-r=true
  - r-base=3.6.2@conda-forge
flags:
  - dependencies: NA
  - system-tools: false  
  - priority: strict
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
#bash:
#cp recipes/publications/DESeq2/DESeq2.R \
#$CONDA_PREFIX/bin/DESeq2.R




