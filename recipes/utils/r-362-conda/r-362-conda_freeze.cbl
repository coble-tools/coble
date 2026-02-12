# COBLE:capture, (c) ICR 2026
# Capture date: 2026-02-12
# Capture time: 09:53:10 GMT
# Captured by: ralcraft

coble:

  - environment: r-362-conda

channels:
  - defaults
  - bioconda
  - conda-forge

languages:
  - r-base=3.6.2@conda-forge
  - python=3.11.0@conda-forge
flags:
  - compile-tools: true
  - dependencies: false
  - priority: flexible

conda:
  - binutils_impl_linux-64=2.36.1@conda-forge
  - binutils_linux-64=2.36@conda-forge
  - gcc_impl_linux-64=7.5.0@conda-forge
  - gcc_linux-64=7.5.0@conda-forge
  - gxx_impl_linux-64=7.5.0@conda-forge
  - gxx_linux-64=7.5.0@conda-forge
  - icu=64.2@conda-forge
  - libcblas=3.9.0@conda-forge
  - libcurl=7.68.0@conda-forge
  - libgcc-ng=15.2.0@conda-forge
  - libgcc=15.2.0@conda-forge
  - libstdcxx-ng=15.2.0@conda-forge
  - libstdcxx=15.2.0@conda-forge
  - libzlib=1.2.13@conda-forge
  - zlib=1.2.13@conda-forge
  - bwidget=1.10.1@conda-forge
  - bzip2=1.0.8@conda-forge
  - ca-certificates=2026.1.4@conda-forge
  - cairo=1.16.0@conda-forge
  - curl=7.68.0@conda-forge
  - expat=2.7.3@conda-forge
  - fontconfig=2.14.2@conda-forge
  - freetype=2.12.1@conda-forge
  - fribidi=1.0.16@conda-forge
  - gfortran_impl_linux-64=7.5.0@conda-forge
  - gfortran_linux-64=7.5.0@conda-forge
  - glib-tools=2.80.2@conda-forge
  - glib=2.80.2@conda-forge
  - graphite2=1.3.14@conda-forge
  - gsl=2.6@conda-forge
  - harfbuzz=2.4.0@conda-forge
  - jpeg=9e@conda-forge
  - kernel-headers_linux-64=6.12.0@conda-forge
  - krb5=1.16.4@conda-forge
  - ld_impl_linux-64=2.36.1@conda-forge
  - lerc=4.0.0@conda-forge
  - libblas=3.9.0@conda-forge
  - libdeflate=1.14@conda-forge
  - libedit=3.1.20250104@conda-forge
  - libexpat=2.7.3@conda-forge
  - libffi=3.5.2@conda-forge
  - libgfortran-ng=7.5.0@conda-forge
  - libgfortran4=7.5.0@conda-forge
  - libgfortran5=15.2.0@conda-forge
  - libglib=2.80.2@conda-forge
  - libgomp=15.2.0@conda-forge
  - libiconv=1.18@conda-forge
  - liblapack=3.9.0@conda-forge
  - liblzma-devel=5.8.2@conda-forge
  - liblzma=5.8.2@conda-forge
  - libnsl=2.0.1@conda-forge
  - libopenblas=0.3.28@conda-forge
  - libpng=1.6.43@conda-forge
  - libsqlite=3.46.0@conda-forge
  - libssh2=1.10.0@conda-forge
  - libtiff=4.4.0@conda-forge
  - libuuid=2.41.3@conda-forge
  - libxcb=1.17.0@conda-forge
  - libxml2=2.9.10@conda-forge
  - make=4.4.1@conda-forge
  - ncurses=6.5@conda-forge
  - openssl=1.1.1w@conda-forge
  - packaging=26.0@conda-forge
  - pango=1.42.4@conda-forge
  - pcre2=10.43@conda-forge
  - pcre=8.45@conda-forge
  - pip=26.0.1@conda-forge
  - pixman=0.38.0@conda-forge
  - pthread-stubs=0.4@conda-forge
  - readline=8.3@conda-forge
  - sed=4.9@conda-forge
  - setuptools=82.0.0@conda-forge
  - sysroot_linux-64=2.39@conda-forge
  - tk=8.6.13@conda-forge
  - tktable=2.10@conda-forge
  - tzdata=2025c@conda-forge
  - wheel=0.46.3@conda-forge
  - xorg-libice=1.1.2@conda-forge
  - xorg-libsm=1.2.6@conda-forge
  - xorg-libx11=1.8.13@conda-forge
  - xorg-libxau=1.0.12@conda-forge
  - xorg-libxdmcp=1.1.5@conda-forge
  - xorg-libxext=1.3.7@conda-forge
  - xorg-libxrender=0.9.12@conda-forge
  - xz-gpl-tools=5.8.2@conda-forge
  - xz-tools=5.8.2@conda-forge
  - xz=5.8.2@conda-forge
  - zstd=1.5.6@conda-forge

r-conda:
  - acepack=1.4.1@conda-forge
  - assertthat=0.2.1@conda-forge
  - backports=1.2.1@conda-forge
  - base64enc=0.1_3@conda-forge
  - bh=1.75.0_0@conda-forge
  - biocmanager=1.30.15@conda-forge
  - bit64=4.0.5@conda-forge
  - bit=4.0.4@conda-forge
  - bitops=1.0_7@conda-forge
  - blob=1.2.1@conda-forge
  - checkmate=2.0.0@conda-forge
  - cli=2.5.0@conda-forge
  - cluster=2.1.2@conda-forge
  - colorspace=2.0_1@conda-forge
  - crayon=1.4.1@conda-forge
  - data.table=1.14.0@conda-forge
  - dbi=1.1.1@conda-forge
  - digest=0.6.27@conda-forge
  - ellipsis=0.3.2@conda-forge
  - evaluate=0.14@conda-forge
  - fansi=0.4.2@conda-forge
  - foreign=0.8_76@conda-forge
  - formatr=1.9@conda-forge
  - formula=1.2_4@conda-forge
  - futile.logger=1.4.3@conda-forge
  - futile.options=1.0.1@conda-forge
  - ggplot2=3.2.1@conda-forge
  - glue=1.4.2@conda-forge
  - gridextra=2.3@conda-forge
  - gtable=0.3.0@conda-forge
  - highr=0.9@conda-forge
  - hmisc=4.5_0@conda-forge
  - htmltable=2.2.1@conda-forge
  - htmltools=0.5.1.1@conda-forge
  - htmlwidgets=1.5.3@conda-forge
  - jsonlite=1.7.2@conda-forge
  - knitr=1.33@conda-forge
  - labeling=0.4.2@conda-forge
  - lambda.r=1.2.4@conda-forge
  - lattice=0.20_44@conda-forge
  - latticeextra=0.6_28@conda-forge
  - lazyeval=0.2.2@conda-forge
  - lifecycle=1.0.0@conda-forge
  - locfit=1.5_9.4@conda-forge
  - magrittr=2.0.1@conda-forge
  - markdown=1.1@conda-forge
  - mass=7.3_54@conda-forge
  - matrix=1.3_3@conda-forge
  - matrixstats=0.58.0@conda-forge
  - memoise=1.1.0@conda-forge
  - mgcv=1.8_35@conda-forge
  - mime=0.10@conda-forge
  - munsell=0.5.0@conda-forge
  - nlme=3.1_152@conda-forge
  - nnet=7.3_16@conda-forge
  - pillar=1.6.1@conda-forge
  - pkgconfig=2.0.3@conda-forge
  - plogr=0.2.0@conda-forge
  - plyr=1.8.6@conda-forge
  - r6=2.5.0@conda-forge
  - rcolorbrewer=1.1_2@conda-forge
  - rcpp=1.0.6@conda-forge
  - rcpparmadillo=0.10.4.0.0@conda-forge
  - rcurl=1.98_1.2@conda-forge
  - remotes=2.3.0@conda-forge
  - reshape2=1.4.4@conda-forge
  - rlang=0.4.11@conda-forge
  - rpart=4.1_15@conda-forge
  - rsqlite=2.2.5@conda-forge
  - rstudioapi=0.13@conda-forge
  - scales=1.0.0@conda-forge
  - snow=0.4_3@conda-forge
  - stringi=1.4.6@conda-forge
  - stringr=1.4.0@conda-forge
  - survival=3.2_11@conda-forge
  - tibble=3.1.2@conda-forge
  - utf8=1.2.1@conda-forge
  - vctrs=0.3.8@conda-forge
  - viridis=0.6.1@conda-forge
  - viridislite=0.4.0@conda-forge
  - withr=2.4.2@conda-forge
  - xfun=0.23@conda-forge
  - xml=3.99_0.3@conda-forge
  - xtable=1.8_4@conda-forge
  - yaml=2.2.1@conda-forge

bioc-conda:
  - annotate=1.64.0@bioconda
  - annotationdbi=1.48.0@bioconda
  - biocgenerics=0.32.0@bioconda
  - biocparallel=1.20.0@bioconda
  - delayedarray=0.12.0@bioconda
  - deseq2=1.26.0@bioconda
  - genefilter=1.68.0@bioconda
  - geneplotter=1.64.0@bioconda
  - genomeinfodb=1.22.0@bioconda
  - genomeinfodbdata=1.2.2@bioconda
  - genomicranges=1.38.0@bioconda
  - iranges=2.20.0@bioconda
  - s4vectors=0.24.0@bioconda
  - summarizedexperiment=1.16.0@bioconda
  - xvector=0.26.0@bioconda
  - zlibbioc=1.32.0@bioconda

r-package:

# r-package(unknown source):
#  - compiler=3.6.2
#  - datasets=3.6.2
#  - grDevices=3.6.2
#  - graphics=3.6.2
#  - grid=3.6.2
#  - methods=3.6.2
#  - parallel=3.6.2
#  - splines=3.6.2
#  - stats4=3.6.2
#  - stats=3.6.2
#  - tcltk=3.6.2
#  - tools=3.6.2
#  - utils=3.6.2
