
coble:
  - environment: coble4cosmx
channels:
  - bioconda
  - conda-forge  
languages:
  - r-base=4.4@conda-forge
flags:
  - dependencies: NA
  - compile-tools: True 
  - system-tools: True  
r-conda: 
  - seurat
  - spatspat
r-package:
  - Matrix
  - irlba
bioc-conda:
  - xvector
  - sparsearray
  - genomicranges
bioc-package:
  - SingleCellExperiment
  - sparseMatrixStats    
r-github:
  - https://github.com/Nanostring-Biostats/InSituType
 