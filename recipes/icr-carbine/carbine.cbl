#####################################################
# COBLE:Reproducible environment: BASIC, (c) ICR 2026
#####################################################
coble:
  - environment: coble-env-basic
channels:
# note the reverse order of priority
  - defaults  
  - bioconda
  - conda-forge
languages:
  - python=3.12
  - r-base=4.4.3
flags:
  - dependencies: NA
  - compile-tools: True
  - system-tools: True
  - export: QT_QPA_PLATFORM=offscreen
pip:
  - https://github.com/stan-dev/cmdstanpy.git@develop  
conda:  
  - arviz
  - pytz
  - cmdstanpy
  - ipython
  - matplotlib
  - pandas
  - scipy
  - seaborn
r-conda:
  - doBy
  - pbkrtest
  - car
  - rstatix
  - sads
  - tidyverse
  - tidytable
  - pio
  - ggpubr
  - easypar
  - dndscv
  - ctree
  - ggthemes
  - clisymbols
  - reshape2
  - BMix
  - vcfR
  - gtools
  - akima
  - peakPick
  - R.utils
  - XML
  - restfulr
  - rjson
  - interp
  - reticulate
bioc-conda:
  - rtracklayer
  - genomicfeatures
  - delayedarray
  - summarizedexperiment
  - genomicalignments
bioc-package:
  - TxDb.Hsapiens.UCSC.hg19.knownGene
  - BSgenome.Hsapiens.UCSC.hg19
  - AnnotationDbi
  - ComplexHeatmap
r-url:
  - https://github.com/im3sanger/dndscv/archive/refs/heads/master.zip
  - https://github.com/caravagnalab/CNAqc/archive/refs/heads/master.zip
  - https://github.com/caravagnalab/VIBER/archive/refs/heads/master.zip
  - https://github.com/caravagn/evoverse/archive/refs/heads/development.zip
  - https://github.com/caravagnalab/mobster/archive/refs/heads/binomial_noise.zip
pip:
  - https://${GITHUB_PAT}@github.com/CalumGabbutt/carbine.git@container
  