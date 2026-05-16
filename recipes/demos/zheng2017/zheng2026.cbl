#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
# code/coble build --recipe recipes/demos/zheng2017/zheng2026.cbl --env zheng2026 --rebuild
# code/coble build --recipe recipes/demos/zheng2017/zheng2026.cbl --env zheng2026 --containers docker,singularity --code-source local --validate recipes/papers/zheng2017/validate.sh --ubuntu 16.04
#######################################
coble:
  - environment: zheng2026
comments:
Zheng2017 with modern toolchain
channels:
  - bioconda
  - conda-forge
compilers:
  - cran-repo: https://packagemanager.posit.co/cran/2025-10-10
flags:
  - ncpus: 1
conda:
  - r-base=4.5.2
r-package:
  - lattice
  - chron
  - DBI
  - BH
  - assertthat
  - MASS
  - digest
  - RColorBrewer
  - dichromat
  - munsell
  - labeling
  - stringi
  - stringr
  - R6
  - lazyeval
  - codetools
r-conda:
  - Rcpp
  - plyr
  - data.table
  - svd
r-package:
  - Matrix
  - gtable
  - scales
  - reshape2
r-package:
  - ggplot2
  - dplyr
  - Rtsne
r-package:
  - pheatmap
conda:
  - cairo
  - pango
  - fonts-anaconda
  - fontconfig
