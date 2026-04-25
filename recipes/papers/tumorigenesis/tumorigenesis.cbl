#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
# code/coble build --recipe recipes/papers/tumorigenesis/tumorigenesis.cbl --env tumori --rebuild
#######################################
coble:
  - environment: r-362
channels:
  - bioconda
  - conda-forge
compilers:
  - cran-repo: https://packagemanager.posit.co/cran/2019-11-01
flags:
  - compile-version: 7.5
languages:
  - r-base=3.6.3
r-conda:
  - testthat
  - isoband
  - rsvd
r-package:
  - cowplot
  - destiny
  - dplyr
  - ggplot2
  - ggrepel
  - igraph
  - irlba
  - knitr
  - Matrix
  - mgcv
  - pheatmap
  - plyr
  - RColorBrewer
  - Rtsne
  - rmarkdown
  - schex
  - umap
  - viridis
  - wesanderson
  - RcppAnnoy=0.0.18
bioc-conda:
  - batchelor
bioc-package:
  - BiocNeighbors
  - BiocParallel
  - BiocSingular
  - biomaRt
  - DropletUtils
  - edgeR
  - scater
  - scran
  - topGO