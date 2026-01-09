#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2025
#######################################
coble:
  - environment: coble-env
channels:
# note the reverse order of priority  
  - r
  - bioconda
  - conda-forge
  - defaults
languages:
  - r-base=3.6.0@r
flags:
  - dependencies: NA
  - compile-tools: 13.3.0
  - priority: strict
  - channel: bioconda
  - channel: conda-forge  
r-conda:
  - BiocManager
  - remotes
  - tidyverse=1.3.1
  - effsize=0.8.1
  - magrittr=2.0.1
  - tidyverse=1.3.1
  - ggplot2
  - ggrepel=0.9.1
  - VennDiagram=1.6.20
bioc-conda:
  - affy=1.64.0
  - fgsea=1.12.0
  - GSVA=1.34.0
  - org.Hs.eg.db=3.10.0
r-package:
  - survival=3.2-11
bioc-package:
  - limma=3.42.2
