#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
coble:
  - environment: coble-env
channels:    
  - r
compilers:    
  - cran-repo: https://packagemanager.posit.co/cran/2020-04-01  
languages:
 - r-base=3.6.0@override:r,defaults
bash:
  - conda config --env --remove channels r
compilers:  
  - compile-tools: true
flags:      
  - system-tools: false
  - channel: bioconda
  - channel: conda-forge   
bash:
  - # This sed line is required when mixing r versions from the r channel with conda-forge source installs
  - sed -i 's/x86_64-conda_cos6-linux-gnu/x86_64-conda-linux-gnu/g' ${CONDA_PREFIX}/lib/R/etc/Makeconf
conda:
  - libcurl
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
