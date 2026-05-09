#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
# code/coble build --recipe recipes/papers/velton2025/velton_r46.cbl --env velton_r46 --rebuild
#######################################
coble:
  - environment: velton_r46
comments:
  This recipe is for the environment used in Velton et al. 2025,

channels:
  - bioconda
  - conda-forge

compilers:
  - cran-repo: https://packagemanager.posit.co/cran/latest
  - compile-tools: 15.2

#flags:
#  - ncpus: 8
#  - system-tools: true

conda:
  - r-base=4.6.0

r-package:
  - ggplot2
  - data.table
  - curl

r-package:
  - igraph
  - Seurat
  - ROCR
  - fossil
  - reshape2
  - RCurl
bioc-package:
  - BiocManager
  - biomaRt
  - GenomicFeatures
  - rtracklayer
  - HDF5Array
  - Rhdf5lib
  - rhdf5filters
  - rhdf5
  - ComplexHeatmap
  - GenomeInfoDb
  - XVector
  - methylumi
  - RnBeads
  - GenomicRanges
r-conda:
  - pheatmap
  - viridis
