#####################################################
# COBLE:Reproducible environment: carbine, (c) ICR 2026
#####################################################
coble:
  - environment: carbine
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
  - system-tools: False
  - export: QT_QPA_PLATFORM=offscreen
conda:  
  - arviz
  - pytz
  - cmdstan=2.38.0
  - cmdstanpy=1.3.0
  - ipython
  - matplotlib
  - pandas=3.0.0
  - scipy=1.17.0
  - seaborn=0.13.2
  - xz
r-conda:
  - doBy
  - pbkrtest
  - car
  - rstatix
  - sads
  - tidyverse
  - tidytable
  - pio
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
r-package:
  - ggpubr
  - ggsci
  - vcfR
  - partykit
  - covr
bioc-conda:
  - rtracklayer=1.66.0@bioconda
  - genomicfeatures=1.58.0@bioconda
  - delayedarray=0.32.0@bioconda
  - summarizedexperiment=1.36.0@bioconda
  - genomicalignments=1.42.0@bioconda
bioc-package:
  - TxDb.Hsapiens.UCSC.hg19.knownGene=3.2.2
  - BSgenome.Hsapiens.UCSC.hg19=1.4.3
  - AnnotationDbi=1.68.0
  - ComplexHeatmap=2.22.0
  - VariantAnnotation  
flags:
  - dependencies: FALSE
r-url:
  - https://github.com/im3sanger/dndscv/archive/refs/heads/master.zip
  - https://github.com/caravagnalab/CNAqc/archive/refs/heads/master.zip
  - https://github.com/caravagnalab/VIBER/archive/refs/heads/master.zip
  - https://github.com/caravagnalab/mobster/archive/refs/heads/binomial_noise.zip
  - https://github.com/caravagn/evoverse/archive/refs/heads/development.zip
  

  