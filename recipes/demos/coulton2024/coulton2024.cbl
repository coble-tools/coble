#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
# code/coble build --recipe recipes/demos/coulton2024/coulton2024.cbl --env coulton2024 --rebuild
#######################################
coble:
  - environment: coulton2024
comments:
  This recipe is for the environment used in Coulton et al. 2024,
channels:
  - bioconda
  - conda-forge
compilers:
  - cran-repo: https://packagemanager.posit.co/cran/2024-10-10
conda:
  - r-base=4.2.2
r-conda:
  - Seurat
  - ggsci
  - harmony
  - patchwork
  - dplyr
  - Matrix
bioc-conda:
  - rhdf5

