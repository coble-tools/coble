##########################################################
# COBLE: Complex Bioinformatics Example, (c) ICR 2026
##########################################################
coble:
  - environment: coble-env-bioinf
channels:
# note the reverse order of priority
  - defaults
  - r
  - bioconda
  - conda-forge

languages:
  - r-base=4.5.2@conda-forge
  - python=3.14.0@conda-forge

flags:
  - dependencies: NA
  - system-tools: True
  - compile-tools: 13.1
  - ncpus: 8
conda:
  - tbb<2021
  - tbb-devel<2021  
r-package:
  - rstan
bash:
  - devtools::install_github("stan-dev/rstantools")
  - devtools::install_github("davidaknowles/leafcutter/leafcutter")