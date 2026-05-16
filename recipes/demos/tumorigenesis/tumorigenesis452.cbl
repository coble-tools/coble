#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
# code/coble build --recipe recipes/papers/tumorigenesis/tumorigenesis452.cbl --env tumori452 --rebuild
#######################################
coble:
  - environment: r-452
channels:
  - bioconda
  - conda-forge
compilers:
  - cran-repo: https://packagemanager.posit.co/cran/2025-11-01
flags:
  - compile-version: 11.4
  - system-tools: true
  - ncpus: 8
languages:
  - r-base=4.5.2
conda:
  - libpng
r-conda:
  - testthat
  - isoband
  - rsvd
  - igraph
r-package:
  - cowplot
  - dplyr
  - ggplot2
  - ggrepel
  - irlba
  - knitr
  - Matrix
  - mgcv
  - pheatmap
  - plyr
  - RColorBrewer
  - Rtsne
  - rmarkdown
  - umap
  - viridis
  - wesanderson
  - RcppAnnoy
bioc-conda:
  - batchelor
bioc-package:
  - destiny
  - schex
  - BiocNeighbors
  - BiocParallel
  - BiocSingular
  - biomaRt
  - DropletUtils
  - edgeR
  - scater
  - scran
  - topGO
