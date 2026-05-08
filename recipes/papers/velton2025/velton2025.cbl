#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
# code/coble build --recipe recipes/demos/velton2025/velton2025.cbl --env velton2025 --rebuild
#######################################
coble:
  - environment: velton2025
comments:
  This recipe is for the environment used in Velton et al. 2025,
channels:
  - bioconda
  - conda-forge
compilers:
  - cran-repo: https://packagemanager.posit.co/cran/2025-10-10
conda:
  - r-base=4.2.2
r-conda:
  - ggplot2=3.4.1
  - Seurat=4.3.0
  - ROCR=1.0
  - fossil=0.4.0
  - reshape2=1.4.4
  - RCurl
  - xml2
  - XML
  - locfit
bioc-conda:
  - biomaRt
  - GenomicFeatures
  - rtracklayer
  - HDF5Array
  - Rhdf5lib
  - rhdf5filters
  - rhdf5
  - ComplexHeatmap=2.14.0
  - GenomeInfoDb
  - XVector
r-package:
  - BiocManager
bioc-package:
  - methylumi
  - RnBeads=2.20.0
  - GenomicRanges=1.50.2
r-conda:
  - pheatmap=1.0.12
  - viridis=0.6.2
