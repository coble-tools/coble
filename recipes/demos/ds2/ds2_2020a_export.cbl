# COBLE:export, (c) ICR 2026
# Capture date: 2026-04-23
# Capture time: 12:30:34 BST
# Captured by: ralcraft

coble:

  - environment: ds20a

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
  - binutils=2.36.1@conda-forge
  - binutils_impl_linux-64=2.36.1@conda-forge
  - binutils_linux-64=2.36@conda-forge
  - gcc_impl_linux-64=7.5.0@conda-forge
  - gcc_linux-64=7.5.0@conda-forge
  - gxx_impl_linux-64=7.5.0@conda-forge
  - gxx_linux-64=7.5.0@conda-forge
  - icu=64.2@conda-forge
  - libcblas=3.9.0@conda-forge
  - libcurl=7.68.0@conda-forge
  - libgcc-devel_linux-64=14.3.0@conda-forge
  - libgcc-ng=15.2.0@conda-forge
  - libgcc=15.2.0@conda-forge
  - libstdcxx-devel_linux-64=14.3.0@conda-forge
  - libstdcxx-ng=15.2.0@conda-forge
  - libstdcxx=15.2.0@conda-forge
  - libzlib=1.2.13@conda-forge
  - zlib=1.2.13@conda-forge
  - bwidget=1.10.1@conda-forge
  - bzip2=1.0.8@conda-forge
  - c-compiler=1.1.2@conda-forge
  - ca-certificates=2026.4.22@conda-forge
  - cairo=1.16.0@conda-forge
  - curl=7.68.0@conda-forge
  - cxx-compiler=1.1.2@conda-forge
  - expat=2.7.5@conda-forge
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
  - lerc=4.1.0@conda-forge
  - libblas=3.9.0@conda-forge
  - libdeflate=1.14@conda-forge
  - libedit=3.1.20250104@conda-forge
  - libexpat=2.7.5@conda-forge
  - libffi=3.5.2@conda-forge
  - libgfortran-ng=7.5.0@conda-forge
  - libgfortran4=7.5.0@conda-forge
  - libgfortran5=15.2.0@conda-forge
  - libglib=2.80.2@conda-forge
  - libgomp=15.2.0@conda-forge
  - libiconv=1.18@conda-forge
  - liblapack=3.9.0@conda-forge
  - liblzma-devel=5.8.3@conda-forge
  - liblzma=5.8.3@conda-forge
  - libnsl=2.0.1@conda-forge
  - libopenblas=0.3.28@conda-forge
  - libpng=1.6.43@conda-forge
  - libsanitizer=14.3.0@conda-forge
  - libsqlite=3.46.0@conda-forge
  - libssh2=1.10.0@conda-forge
  - libtiff=4.4.0@conda-forge
  - libuuid=2.42@conda-forge
  - libxcb=1.17.0@conda-forge
  - libxml2=2.9.10@conda-forge
  - make=4.4.1@conda-forge
  - ncurses=6.5@conda-forge
  - openssl=1.1.1w@conda-forge
  - packaging=26.1@conda-forge
  - pango=1.42.4@conda-forge
  - pcre2=10.43@conda-forge
  - pcre=8.45@conda-forge
  - pip=26.0.1@conda-forge
  - pixman=0.38.0@conda-forge
  - pthread-stubs=0.4@conda-forge
  - readline=8.3@conda-forge
  - sed=4.10@conda-forge
  - setuptools=82.0.1@conda-forge
  - sysroot_linux-64=2.39@conda-forge
  - tk=8.6.13@conda-forge
  - tktable=2.10@conda-forge
  - tzdata=2025c@conda-forge
  - wheel=0.47.0@conda-forge
  - xorg-libice=1.1.2@conda-forge
  - xorg-libsm=1.2.6@conda-forge
  - xorg-libx11=1.8.13@conda-forge
  - xorg-libxau=1.0.12@conda-forge
  - xorg-libxdmcp=1.1.5@conda-forge
  - xorg-libxext=1.3.7@conda-forge
  - xorg-libxrender=0.9.12@conda-forge
  - xz-gpl-tools=5.8.3@conda-forge
  - xz-tools=5.8.3@conda-forge
  - xz=5.8.3@conda-forge
  - zstd=1.5.6@conda-forge

r-conda:
  - biocmanager=1.30.15@conda-forge
  - remotes=2.3.0@conda-forge
  - renv=0.13.2@conda-forge

r-package:
  - BH=1.72.0-3@RSPM
  - DBI=1.1.0@RSPM
  - Formula=1.2-3@RSPM
  - Hmisc=4.4-0@RSPM
  - MASS=7.3-51.5@RSPM
  - Matrix=1.2-18@RSPM
  - R6=2.4.1@RSPM
  - RColorBrewer=1.1-2@RSPM

r-package:
  - RCurl=1.98-1.18

r-package:
  - RSQLite=2.2.0@RSPM
  - Rcpp=1.0.4@RSPM
  - RcppArmadillo=0.9.850.1.0@RSPM
  - XML=3.99-0.3@RSPM
  - acepack=1.4.1@RSPM
  - assertthat=0.2.1@RSPM
  - backports=1.1.5@RSPM
  - base64enc=0.1-3@RSPM
  - bit64=0.9-7@RSPM
  - bit=1.1-15.2@RSPM

r-package:
  - bitops=1.0-9

r-package:
  - blob=1.2.1@RSPM
  - callr=3.4.3@RSPM
  - checkmate=2.0.0@RSPM
  - cli=2.0.2@RSPM
  - cluster=2.1.0@RSPM
  - colorspace=1.4-1@RSPM
  - crayon=1.3.4@RSPM
  - data.table=1.12.8@RSPM
  - desc=1.2.0@RSPM
  - digest=0.6.25@RSPM
  - ellipsis=0.3.0@RSPM
  - evaluate=0.14@RSPM
  - fansi=0.4.1@RSPM
  - farver=2.0.3@RSPM
  - foreign=0.8-76@RSPM

r-package:
  - formatR=1.14
  - futile.logger=1.4.9
  - futile.options=1.0.1

r-package:
  - ggplot2=3.3.0@RSPM
  - glue=1.3.2@RSPM
  - gridExtra=2.3@RSPM
  - gtable=0.3.0@RSPM
  - highr=0.8@RSPM
  - htmlTable=1.13.3@RSPM
  - htmltools=0.4.0@RSPM
  - htmlwidgets=1.5.1@RSPM
  - isoband=0.2.0@RSPM
  - jsonlite=1.6.1@RSPM
  - knitr=1.28@RSPM
  - labeling=0.3@RSPM

r-package:
  - lambda.r=1.2.4

r-package:
  - lattice=0.20-40@RSPM
  - latticeExtra=0.6-29@RSPM
  - lifecycle=0.2.0@RSPM
  - locfit=1.5-9.4@RSPM
  - magrittr=1.5@RSPM
  - markdown=1.1@RSPM

r-package:
  - matrixStats=1.5.0

r-package:
  - memoise=1.1.0@RSPM
  - mgcv=1.8-31@RSPM
  - mime=0.9@RSPM
  - munsell=0.5.0@RSPM
  - nlme=3.1-145@RSPM
  - nnet=7.3-13@RSPM
  - pillar=1.4.3@RSPM
  - pkgbuild=1.0.6@RSPM
  - pkgconfig=2.0.3@RSPM
  - pkgload=1.0.2@RSPM
  - plogr=0.2.0@RSPM
  - png=0.1-7@RSPM
  - praise=1.0.0@RSPM
  - prettyunits=1.1.1@RSPM
  - processx=3.4.2@RSPM
  - ps=1.3.2@RSPM
  - rlang=0.4.5@RSPM
  - rpart=4.1-15@RSPM
  - rprojroot=1.3-2@RSPM
  - rstudioapi=0.11@RSPM
  - scales=1.1.0@RSPM

r-package:
  - snow=0.4-4

r-package:
  - stringi=1.4.6@RSPM
  - stringr=1.4.0@RSPM
  - survival=3.1-11@RSPM

r-package:
  - testthat=1.0.2

r-package:
  - tibble=2.1.3@RSPM
  - utf8=1.1.4@RSPM
  - vctrs=0.2.4@RSPM
  - viridis=0.5.1@RSPM
  - viridisLite=0.3.0@RSPM
  - withr=2.1.2@RSPM
  - xfun=0.12@RSPM

r-package:
  - xtable=1.8-8

r-package:
  - yaml=2.2.1@RSPM

bioc-package:
  - AnnotationDbi=1.48.0
  - BiocGenerics=0.32.0
  - BiocParallel=1.20.1
  - BiocVersion=3.10.1
  - DESeq2=1.26.0
  - DelayedArray=0.12.3
  - GenomeInfoDb=1.22.1
  - GenomeInfoDbData=1.2.2
  - GenomicRanges=1.38.0
  - IRanges=2.20.2
  - S4Vectors=0.24.4
  - SummarizedExperiment=1.16.1
  - XVector=0.26.0
  - annotate=1.64.0
  - genefilter=1.68.0
  - geneplotter=1.64.0
  - zlibbioc=1.32.0

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
