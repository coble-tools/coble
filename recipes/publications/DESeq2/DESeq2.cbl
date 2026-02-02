coble:
  - environment: DESeq2
channels: # note the reverse order of priority  
  - defaults
  - R
  - bioconda
  - conda-forge  
languages:  
  - r-base=3.6.2@conda-forge
flags:
  - dependencies: NA
  - system-tools: false
  - compile-tools: true
bash:
  - Rscript -e 'BiocManager::install(version="2.14")'
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
bash:
cp recipes/publications/DESeq2/DESeq2.R \
$CONDA_PREFIX/bin/DESeq2.R




