coble:
  - environment: DESeq2
channels: # note the reverse order of priority  
  - r
  - bioconda
  - conda-forge
  - defaults
flags:    
  - priority: flexible
languages:  
  - compile-version=7.5.0
  - compile-order=with
  - env-sims=true
  - base-sims=true
  - r-base=3.6.2
flags:
  - dependencies: NA  
  - build-tools: false
  - priority: strict
  - channel: bioconda
  - channel: conda-forge  
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




