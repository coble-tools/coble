#######################################
# COBLE:Reproducible environment, (c) ICR 2026
# code/coble build --recipe recipes/icr/tnbc/tnbc.cbl --env tnbc --rebuild
#######################################
coble:
  - environment: tnbc
comments:
Internal ICR-BCDS
Build directly from:
SHARED/analysis/RachaelNatrajan/
TNBC_PDX_residual/snrseq/logs/
2023-08-21-Session-Info-3_plot_metamarkers_oc.txt
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

r-conda:
  - gridExtra=2.3
  - plotly
  - ggraph=2.0.5
  - ggpubr=0.4.0
  - tidyverse=1.3.1
  - optparse=1.7.3
  - irlba=2.3.3
  - png=0.1-7
  - Seurat=4.2.1
  - ggplot2=3.3.5
  - data.table=1.14.2
  - pracma=2.4.2
  - SeuratObject=4.1.3
  - future=1.25.0
  - future.apply=1.8.0
bioc-conda:
  - fgsea=1.18.0
  - limma=3.50.1
  - GSEABase=1.56.0

r-conda:
  - spatstat.sparse=3.0-0
  - spatstat.data=3.0-0
  - spatstat.random=3.0-1
  - spatstat.utils=3.0-1
  - spatstat.geom=3.0-3
  - spatstat.explore=3.0-5


r-package:
  - fastmatch=1.1-3
  - plyr=1.8.7
  - igraph=1.2.6
  - lazyeval=0.2.2
  - sp=1.5-1
  - splines=4.1.0
  - BiocParallel=1.28.0
  - listenv=0.8.0
  - scattermore=0.7
  - GenomeInfoDb=1.28.4
  - digest=0.6.29
  - htmltools=0.5.2
  - viridis=0.6.3
  - fansi=1.0.0
  - magrittr=2.0.1
  - memoise=2.0.1
  - tensor=1.5
  - cluster=2.1.2
  - ROCR=1.0-11
  - globals=0.15.0
  - Biostrings=2.62.0
  - annotate=1.72.0
  - matrixStats=0.61.0
  - colorspace=2.0-2
  - blob=1.2.2
  - ggrepel=0.9.1
  - dplyr=1.0.8
  - RCurl=1.98-1.6
  - crayon=1.4.2
  - jsonlite=1.7.2
  - graph=1.72.0
  - progressr=0.9.0
  - survival=3.2-13
  - zoo=1.8-11
  - glue=1.6.2
  - polyclip=1.10-0
  - gtable=0.3.0
  - zlibbioc=1.40.0
  - XVector=0.34.0
  - leiden=0.3.9
  - BiocGenerics=0.40.0
  - abind=1.4-5
  - scales=1.1.1
  - futile.options=1.0.1
  - DBI=1.1.2
  #- miniUI=0.1.1.1
  - Rcpp=1.0.7
  - viridisLite=0.4.0
  - xtable=1.8-4
  - reticulate=1.25
  - bit=4.0.4
  - stats4=4.1.0
  - htmlwidgets=1.5.4
  - httr=1.4.2
  - gplots=3.1.1
  - RColorBrewer=1.1-3
  - ellipsis=0.3.2
  - ica=1.0-2
  - pkgconfig=2.0.3
  - XML=3.99-0.6
  - farver=2.1.0
  - uwot=0.1.14
  - deldir=1.0-6
  - utf8=1.2.2
  - tidyselect=1.2.0
  - rlang=1.0.6
  - reshape2=1.4.4
  - later=1.2.0
  - AnnotationDbi=1.56.1
  - munsell=0.5.0
  - tools=4.1.0
  - cachem=1.0.6
  - cli=3.4.1
  - generics=0.1.2
r-conda:
  - RSQLite=2.2.8
  - plotly=4.10.0
  - tibble=3.1.8
r-package:
  #- ggridges=0.5.3
  - stringr=1.4.0
  - fastmap=1.1.0
  - goftest=1.2-2
  - org.Hs.eg.db=3.13.0
  - bit64=4.0.5
  - fitdistrplus=1.1-5
  - caTools=1.18.2
  - purrr=0.3.4
  - RANN=2.6.1
  - KEGGREST=1.34.0
  - pbapply=1.5-0
  - nlme=3.1-152
  - mime=0.12
  - formatR=1.11
  - compiler=4.1.0
  - stringi=1.7.5
  - lattice=0.20-45
  - Matrix=1.5-3
  - vctrs=0.5.0
  - pillar=1.8.1
  - lifecycle=1.0.3
  - lmtest=0.9-38
  - RcppAnnoy=0.0.19
  - bitops=1.0-7
  - cowplot=1.1.1
  - irlba=2.3.5
  - httpuv=1.6.5
  - patchwork=1.1.1
  - R6=2.5.1
  - promises=1.2.0.1
  - KernSmooth=2.23-20
  - gridExtra=2.3
  - IRanges=2.28.0
  - parallelly=1.31.1
  - codetools=0.2-18
  - lambda.r=1.2.4
  - gtools=3.9.4
  - MASS=7.3-58.1
  - assertthat=0.2.1
  - withr=2.5.0
r-conda:
  - sctransform=0.3.5
r-package:
  - GenomeInfoDbData=1.2.7
  - S4Vectors=0.32.4
  - parallel=4.1.0
  - tidyr=1.2.0
  - Rtsne=0.16
  - Biobase=2.54.0
  - shiny=1.7.1

r-conda:
  - remotes
  - FactoMineR
  - factoextra
  - biocmanager

bioc-package:
  - multtest
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
