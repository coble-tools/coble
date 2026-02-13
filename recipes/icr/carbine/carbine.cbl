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
  - r-base=4.4.3
  - python=3.12
bash:
  - R CMD javareconf
flags:
  - compile-tools: True
  - system-tools: False
  - export: QT_QPA_PLATFORM=offscreen  
  - export: OTEL_SDK_DISABLED=true
  - export: R_OTEL_DISABLED=true
  - dependencies: NA
  - export: CXXFLAGS="--sysroot=$CONDA_PREFIX/aarch64-conda-linux-gnu/sysroot"
  - export: CPPFLAGS="--sysroot=$CONDA_PREFIX/aarch64-conda-linux-gnu/sysroot"
  - export: LDFLAGS="--sysroot=$CONDA_PREFIX/aarch64-conda-linux-gnu/sysroot"
  - export: LD_LIBRARY_PATH="$CONDA_PREFIX/aarch64-conda-linux-gnu/sysroot/usr/lib:$CONDA_PREFIX/lib:$LD_LIBRARY_PATH"

conda:
  - cmdstan=2.38.0  
bash:
  - ARCH=$(uname -m)
  - if [ "$ARCH" = "aarch64" ]; then TRIPLET="${ARCH}-conda-linux-gnu" && \
  - CMDSTAN_PATH=$(python -c "import cmdstanpy; print(cmdstanpy.cmdstan_path())") && \
  - printf "CXXFLAGS_OS = --sysroot=$CONDA_PREFIX/${TRIPLET}/sysroot\nTBB_CXX_TYPE = gcc\nCPPFLAGS =\n" >> $CMDSTAN_PATH/make/local; fi
flags:
  - export: CMDSTAN=$CONDA_PREFIX/bin/cmdstan
  - export: CPPFLAGS=$(echo $CPPFLAGS | sed 's|-I/usr/include||g')
  - export: CXXFLAGS=$(echo $CXXFLAGS | sed 's|-I/usr/include||g')
conda:  
  - zlib
  - arviz
  - pytz  
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
  - permute
  - vegan
  - shiny
r-package:
  - vcfR
  - covr
  - partykit
r-conda:  
  - biocmanager
  - ggthemes
  - clisymbols
  - reshape2
  - BMix  
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
  

  