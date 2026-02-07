#####################################################
# COBLE:Reproducible environment: for ctv-app, Romanos
#####################################################
coble:
  - environment: coble-romanos
channels:
# note the reverse order of priority  
  - bioconda
  - conda-forge
languages:  
  - r-base=4.4.2@conda-forge
flags:
  - dependencies: NA
  - system-tools: true
  - compile-tools: 13.1
conda:
  - postgresql
r-package:    
  - shiny
  - shinyjs
  - shinymanager
  - DT
  - RPostgreSQL
  - data.table
  - magrittr
  - shinycssloaders
  - jsonlite
  - plotly
  - viridis
  - RColorBrewer
  - openxlsx
  - bslib
  - bsicons
  - upsetjs
r-package:
  - NGLVieweR

