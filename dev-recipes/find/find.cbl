#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################

coble:
  - environment: stjc
channels:
  - bioconda
  - conda-forge
languages:
  - r-base=4.5.2
  - python=3.14
r-conda:
  - png
  - terra
  - units
  - s2
  - magick
  - reticulate
  - raster
  - httpuv  
  - sf
  - shiny  
  - miniUI
  - spdep
bioc-package:
  - stJoincount

  
