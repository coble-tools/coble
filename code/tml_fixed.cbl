#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################

coble:
  - environment: coble-env
channels:
# note the reverse order of priority
  - defaults
  - r
  - bioconda
  - conda-forge
flags:
  - dependencies: True
  - system-tools: True
find:
  - countreg  
  - r-base=4.4.2