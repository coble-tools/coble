# COBLE:export, (c) ICR 2026
# Capture date: 2026-05-13
# Capture time: 21:21:47 BST
# Captured by: ralcraft

coble:

  - environment: zheng2026

channels:
  - defaults
  - bioconda
  - conda-forge

languages:
  - r-base=4.5.2@conda-forge
flags:
  - compile-tools: true
  - dependencies: false
  - priority: flexible

conda:
  - binutils_impl_linux-64=2.45.1@conda-forge
  - gcc_impl_linux-64=15.2.0@conda-forge
  - gxx_impl_linux-64=15.2.0@conda-forge
  - icu=78.3@conda-forge
  - libcblas=3.11.0@conda-forge
  - libcurl=8.20.0@conda-forge
  - libgcc=15.2.0@conda-forge
  - libgcc-devel_linux-64=15.2.0@conda-forge
  - libgcc-ng=15.2.0@conda-forge
  - libstdcxx=15.2.0@conda-forge
  - libstdcxx-devel_linux-64=15.2.0@conda-forge
  - libstdcxx-ng=15.2.0@conda-forge
  - libzlib=1.3.2@conda-forge
  - bwidget=1.10.1@conda-forge
  - bzip2=1.0.8@conda-forge
  - ca-certificates=2026.4.22@conda-forge
  - cairo=1.18.4@conda-forge
  - c-ares=1.34.6@conda-forge
  - curl=8.20.0@conda-forge
  - fontconfig=2.17.1@conda-forge

conda:
  - fonts-anaconda=1@defaults

conda:
  - fonts-conda-forge=1@conda-forge
  - font-ttf-dejavu-sans-mono=2.37@conda-forge
  - font-ttf-inconsolata=3.000@conda-forge
  - font-ttf-source-code-pro=2.038@conda-forge
  - font-ttf-ubuntu=0.83@conda-forge
  - fribidi=1.0.16@conda-forge
  - gfortran_impl_linux-64=15.2.0@conda-forge
  - graphite2=1.3.14@conda-forge
  - gsl=2.7@conda-forge
  - harfbuzz=14.2.0@conda-forge
  - kernel-headers_linux-64=6.12.0@conda-forge
  - keyutils=1.6.3@conda-forge
  - krb5=1.22.2@conda-forge
  - ld_impl_linux-64=2.45.1@conda-forge
  - lerc=4.1.0@conda-forge
  - libblas=3.11.0@conda-forge
  - libdeflate=1.25@conda-forge
  - libedit=3.1.20250104@conda-forge
  - libev=4.33@conda-forge
  - libexpat=2.8.0@conda-forge
  - libffi=3.5.2@conda-forge
  - libfreetype=2.14.3@conda-forge
  - libfreetype6=2.14.3@conda-forge
  - libgfortran=15.2.0@conda-forge
  - libgfortran5=15.2.0@conda-forge
  - libgfortran-ng=15.2.0@conda-forge
  - libglib=2.88.1@conda-forge
  - libgomp=15.2.0@conda-forge
  - libiconv=1.18@conda-forge
  - libjpeg-turbo=3.1.4.1@conda-forge
  - liblapack=3.11.0@conda-forge
  - liblzma=5.8.3@conda-forge
  - libnghttp2=1.68.1@conda-forge
  - libopenblas=0.3.33@conda-forge
  - libpng=1.6.58@conda-forge
  - libsanitizer=15.2.0@conda-forge
  - libssh2=1.11.1@conda-forge
  - libtiff=4.7.1@conda-forge
  - libuuid=2.42@conda-forge
  - libxcb=1.17.0@conda-forge
  - make=4.4.1@conda-forge
  - ncurses=6.6@conda-forge
  - openssl=3.6.2@conda-forge
  - pango=1.56.4@conda-forge
  - pcre2=10.47@conda-forge
  - pixman=0.46.4@conda-forge
  - pthread-stubs=0.4@conda-forge
  - readline=8.3@conda-forge
  - sed=4.10@conda-forge
  - sysroot_linux-64=2.39@conda-forge
  - tk=8.6.13@conda-forge
  - tktable=2.10@conda-forge
  - tzdata=2025c@conda-forge
  - xorg-libice=1.1.2@conda-forge
  - xorg-libsm=1.2.6@conda-forge
  - xorg-libx11=1.8.13@conda-forge
  - xorg-libxau=1.0.12@conda-forge
  - xorg-libxdmcp=1.1.5@conda-forge
  - xorg-libxext=1.3.7@conda-forge
  - xorg-libxrender=0.9.12@conda-forge
  - xorg-libxt=1.3.1@conda-forge
  - zstd=1.5.7@conda-forge

r-conda:
  - data.table=1.17.8@conda-forge
  - plyr=1.8.9@conda-forge
  - rcpp=1.1.1_1.1@conda-forge
  - svd=0.5.8@conda-forge

r-package:
  - assertthat=0.2.1@RSPM
  - BH=1.87.0-1@RSPM
  - chron=2.3-62@RSPM
  - cli=3.6.5@RSPM
  - codetools=0.2-20@RSPM
  - colorspace=2.1-2@RSPM
  - DBI=1.2.3@RSPM
  - dichromat=2.0-0.1@RSPM
  - digest=0.6.37@RSPM
  - dplyr=1.1.4@RSPM
  - farver=2.1.2@RSPM
  - generics=0.1.4@RSPM
  - ggplot2=4.0.0@RSPM
  - glue=1.8.0@RSPM
  - gtable=0.3.6@RSPM
  - isoband=0.2.7@RSPM
  - labeling=0.4.3@RSPM
  - lattice=0.22-7@RSPM
  - lazyeval=0.2.2@RSPM
  - lifecycle=1.0.4@RSPM
  - magrittr=2.0.4@RSPM
  - MASS=7.3-65@RSPM
  - Matrix=1.7-4@RSPM
  - munsell=0.5.1@RSPM
  - pheatmap=1.0.13@RSPM
  - pillar=1.11.1@RSPM
  - pkgconfig=2.0.3@RSPM
  - R6=2.6.1@RSPM
  - RColorBrewer=1.1-3@RSPM
  - reshape2=1.4.4@RSPM
  - rlang=1.1.6@RSPM
  - Rtsne=0.17@RSPM
  - S7=0.2.0@RSPM
  - scales=1.4.0@RSPM
  - stringi=1.8.7@RSPM
  - stringr=1.5.2@RSPM
  - tibble=3.3.0@RSPM
  - tidyselect=1.2.1@RSPM
  - utf8=1.2.6@RSPM
  - vctrs=0.6.5@RSPM
  - viridisLite=0.4.2@RSPM
  - withr=3.0.2@RSPM

# r-package(unknown source):
#  - compiler=4.5.2
#  - datasets=4.5.2
#  - graphics=4.5.2
#  - grDevices=4.5.2
#  - grid=4.5.2
#  - methods=4.5.2
#  - parallel=4.5.2
#  - splines=4.5.2
#  - stats4=4.5.2
#  - stats=4.5.2
#  - tcltk=4.5.2
#  - tools=4.5.2
#  - utils=4.5.2
