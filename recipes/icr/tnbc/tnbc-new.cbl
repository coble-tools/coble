#######################################
# COBLE:Reproducible environment, (c) ICR 2026
# code/coble build --recipe recipes/icr/tnbc/tnbc.cbl --env tnbc --rebuild
#######################################
coble:
  - environment: tnbc
comments:
Internal ICR-BCDS
channels:
  - bioconda
  - conda-forge
compilers:
  - cran-repo: https://packagemanager.posit.co/cran/2024-04-01
flags:
  - ncpus: 4
conda:
  - r-base=4.1.0
  - libopenblas=0.3.15
  - compilers
  - curl
  - libcurl
r-package:
  - KernSmooth=2.23-20
  - dotCall64
  - spam=2.8-0
  - viridisLite=0.4.0
  - glue=1.6.2
  - digest=0.6.29
  - gtable=0.3.0
  - MASS=7.3-58.1
  - rlang=1.0.6
  - fansi=1.0.0
  - lifecycle
  - magrittr
  - pillar
  - pkgconfig
  - vctrs
  - tibble=3.1.8
  - withr=2.5.0
  - isoband
  - mgcv
  - scales
  - ggplot2=3.3.5

r-conda:
  - gridExtra=2.3
  - plotly
  - ggraph=2.0.5
  - ggpubr=0.4.0
  - tidyverse=1.3.1
  - optparse=1.7.3
  - irlba=2.3.3

r-package:
  - viridis=0.6.3
  - maps=3.4.0
  - fields=13.3
  - pracma=2.4.2
  - globals
  - listenv
  - parallelly
  - future=1.25.0
  - jsonlite
  - RCurl
  - tidyr=1.2.0
  - crosstalk
  - dplyr=1.1.0
  - gprofiler2=0.2.1
  - checkmate
  - ggrepel=0.9.1
  - clustree=0.4.4
  - forcats=0.5.1
  - stringr=1.4.0
  - purrr=0.3.4
  - readr=2.0.1
  - scDblFinder=1.6.0
  - SingleR=1.6.1
  - SummarizedExperiment=1.24.0
  - Biobase=2.54.0
  - GenomicRanges=1.46.1
  - GenomeInfoDb=1.28.4
  - IRanges=2.28.0
  - S4Vectors=0.32.4
  - BiocGenerics=0.40.0
  - MatrixGenerics=1.6.0
  - matrixStats=0.61.0
  - SeuratObject=4.1.3
r-conda:
  - Seurat=4.2.1
  - remotes
  - FactoMineR
  - factoextra
bioc-conda::
  - GSEABase
  - multtest
  - limma
  - fgsea
  - SingleR
  - scDblFinder
bash:
Rscript -e 'remotes::install_github("chris-mcginnis-ucsf/DoubletFinder", ref="243b02f5badfed677ef7500b8753fd651f21a67f", dependencies=NA, upgrade="never", Ncpus=4)'

Rscript -e 'Sys.setenv(GITLAB_PAT=Sys.getenv("GITLAB_PAT")); \
remotes::install_gitlab("bcr_ds_team/bcrbioinformatics/Resources/R_Packages/FC14.genesets.DB", \
host="git.icr.ac.uk", ref="main", dependencies=NA, upgrade="never")'

Rscript -e 'Sys.setenv(GITLAB_PAT=Sys.getenv("GITLAB_PAT")); \
remotes::install_gitlab("bcr_ds_team/bcrbioinformatics/Resources/R_Packages/FC14.statistics.lib", \
host="git.icr.ac.uk", ref="main", dependencies=NA, upgrade="never")'

Rscript -e 'Sys.setenv(GITLAB_PAT=Sys.getenv("GITLAB_PAT")); \
remotes::install_gitlab("bcr_ds_team/bcrbioinformatics/Resources/R_Packages/FC14.genome.annotations", \
host="git.icr.ac.uk", ref="main", dependencies=NA, upgrade="never")'

Rscript -e 'Sys.setenv(GITLAB_PAT=Sys.getenv("GITLAB_PAT")); \
remotes::install_gitlab("bcr_ds_team/bcrbioinformatics/Resources/R_Packages/BCN.genesets.utilities", \
host="git.icr.ac.uk", ref="main", dependencies=NA, upgrade="never")'

Rscript -e 'Sys.setenv(GITLAB_PAT=Sys.getenv("GITLAB_PAT")); \
remotes::install_gitlab("bcr_ds_team/bcrbioinformatics/Resources/R_Packages/FC14.plotting.lib", \
host="git.icr.ac.uk", ref="main", dependencies=NA, upgrade="never")'

Rscript -e 'Sys.setenv(GITLAB_PAT=Sys.getenv("GITLAB_PAT")); \
remotes::install_gitlab("bcr_ds_team/bcrbioinformatics/Resources/R_Packages/BCN.general.utilities", \
host="git.icr.ac.uk", ref="main", dependencies=NA, upgrade="never")'

Rscript -e 'Sys.setenv(GITLAB_PAT=Sys.getenv("GITLAB_PAT")); \
remotes::install_gitlab("bcr_ds_team/bcrbioinformatics/Resources/R_Packages/BCN.singlecell.utilities", \
host="git.icr.ac.uk", ref="main", dependencies=NA, upgrade="never")'
#Rscript -e 'remove.packages("BCN.singlecell.utilities")'
#Rscript -e 'remove.packages("irlba")'
#Rscript -e 'remotes::install_version("irlba", version = "2.3.3", repos = "http://cran.r-project.org")'