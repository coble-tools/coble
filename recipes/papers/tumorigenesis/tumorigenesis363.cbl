#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
# code/coble build --recipe recipes/papers/tumorigenesis/tumorigenesis363.cbl --env tumori363 --rebuild
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
  - ncpus: 8
languages:
  - r-base=3.6.3
conda:
  - libpng
r-conda:
  - testthat
  - isoband
  - rsvd
  - RcppAnnoy=0.0.16
r-package:
  - cowplot
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
  - umap
  - viridis
  - wesanderson
  - RcppAnnoy=0.0.16
bioc-conda:
  - batchelor
  - destiny
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