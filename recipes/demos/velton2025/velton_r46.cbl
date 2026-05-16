#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
# code/coble build --recipe recipes/demos/velton2025/velton_r46.cbl --env velton_r46 --rebuild
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
conda:
  - r-base=4.6.0
r-conda:
  - ggplot2
  - Seurat
  - ROCR
  - fossil
  - reshape2
  - RCurl
bioc-conda:
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
r-package:
  - BiocManager
bioc-package:
  - methylumi
  - RnBeads
  - GenomicRanges
r-conda:
  - pheatmap
  - viridis
