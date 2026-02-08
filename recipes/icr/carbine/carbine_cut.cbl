#####################################################
# COBLE:Reproducible environment: carbine, (c) ICR 2026
#####################################################
coble:
  - environment: carbine  
channels:
  - defaults  
  - bioconda
  - conda-forge
languages:
  - r-base=4.4.3
  - python=3.12  
flags:
  - dependencies: NA  
  - export: QT_QPA_PLATFORM=offscreen    
