
coble:
  - environment: coble-env-basic
channels:
# note the reverse order of priority
  - conda-forge
  - bioconda
languages:
  - r-base=4.4@conda-forge
flags:
  - dependencies: NA
  - system-tools: False
  - compile-tools: True 
conda:
  - zlib@conda-forge
r-conda: 
  - BiocManager
  - remotes
bioc-conda:
  - xvector
  - genomicranges
r-package:
  - data.table
  - umap
  - png
  - Matrix
  - irlba
  - matrixStats
  - Seurat
  - spatstat
  - reticulate

bioc-package:
  - sparseMatrixStats
  - SingleCellExperiment
  - SummarizedExperiment
  - SparseArray
  - MatrixGenerics
r-github:
  - https://github.com/Nanostring-Biostats/InSituType
 