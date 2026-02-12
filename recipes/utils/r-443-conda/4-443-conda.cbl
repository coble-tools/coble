#####################################################
# COBLE:Reproducible environment: carbine, (c) ICR 2026
#####################################################
coble:
  - environment: 4-443
channels:
# note the reverse order of priority
  - defaults  
  - bioconda
  - conda-forge
languages:  
  - r-base=4.4.3
  - python=3.12
flags:
  - dependencies: NA
  - compile-tools: True
  - system-tools: True
  - export: QT_QPA_PLATFORM=offscreen  
  - export: OTEL_SDK_DISABLED=true
  - export: R_OTEL_DISABLED=true
conda:  
  - arviz