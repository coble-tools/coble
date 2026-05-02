# COBLE:export, (c) ICR 2026
# Capture date: 2026-05-02
# Capture time: 08:22:14 BST
# Captured by: ralcraft

coble:

  - environment: Zheng2017

channels:
  - conda-forge
  - defaults
  - bioconda
  - intel
  - https://repo.anaconda.com/pkgs/r
  - https://repo.anaconda.com/pkgs/free
  - https://repo.anaconda.com/pkgs/main

languages:
  - r-base=3.3.1@defaults
flags:
  - compile-tools: true
  - dependencies: false
  - priority: flexible
  - export: PKG_CFLAGS="-fcommon"

conda:
  - icu=54.1@https://repo.anaconda.com/pkgs/free

conda:
  - libcurl=7.69.1@defaults

conda:
  - libgcc-ng=15.2.0@conda-forge
  - libgcc=15.2.0@conda-forge

conda:
  - libstdcxx-ng=11.2.0@defaults
  - zlib=1.2.13@defaults
  - bzip2=1.0.8@defaults
  - ca-certificates=2026.3.19@defaults

conda:
  - cairo=1.14.8@https://repo.anaconda.com/pkgs/free

conda:
  - curl=7.69.1@defaults

conda:
  - fontconfig=2.12.1@https://repo.anaconda.com/pkgs/free
  - freetype=2.5.5@https://repo.anaconda.com/pkgs/free
  - glib=2.50.2@https://repo.anaconda.com/pkgs/free

conda:
  - gsl=2.7.1@defaults

conda:
  - harfbuzz=0.9.39@https://repo.anaconda.com/pkgs/free

conda:
  - jpeg=9f@defaults

conda:
  - krb5=1.17.1@conda-forge

conda:
  - lerc=4.0.0@defaults
  - libdeflate=1.22@defaults

conda:
  - libedit=3.1.20170329@conda-forge

conda:
  - libffi=3.4.4@defaults
  - libgfortran5=15.2.0@defaults
  - libgfortran=15.2.0@defaults

conda:
  - libgomp=15.2.0@conda-forge

conda:
  - libiconv=1.14@https://repo.anaconda.com/pkgs/free

conda:
  - libpng=1.6.54@defaults
  - libssh2=1.10.0@defaults
  - libtiff=4.5.1@defaults
  - libxcb=1.17.0@defaults
  - libxml2=2.9.9@defaults
  - lz4-c=1.9.4@defaults

conda:
  - ncurses=5.9@https://repo.anaconda.com/pkgs/free

conda:
  - openssl=1.1.1w@defaults

conda:
  - pango=1.40.3@https://repo.anaconda.com/pkgs/free
  - pcre=8.39@https://repo.anaconda.com/pkgs/free

conda:
  - pixman=0.34.0@defaults
  - pthread-stubs=0.3@defaults
  - readline=7.0@defaults
  - tk=8.6.15@defaults
  - xorg-libx11=1.8.12@defaults
  - xorg-libxau=1.0.12@defaults
  - xorg-libxdmcp=1.1.5@defaults
  - xorg-xorgproto=2024.1@defaults
  - xz=5.2.10@defaults
  - zstd=1.5.5@defaults

r-package:
  - BH=1.65.0-1@RSPM
  - MASS=7.3-47@RSPM

r-package:
  - Matrix=1.2-6

r-package:
  - R6=2.2.2@RSPM
  - RColorBrewer=1.1-2@RSPM
  - Rcpp=0.12.13@RSPM
  - Rtsne=0.13@RSPM
  - assertthat=0.2.0@RSPM
  - bindr=0.1@RSPM
  - bindrcpp=0.2@RSPM
  - chron=2.3-51@RSPM
  - colorspace=1.3-2@RSPM

r-package:
  - data.table=1.9.6

r-package:
  - dichromat=2.0-0@RSPM
  - digest=0.6.12@RSPM
  - dplyr=0.7.4@RSPM
  - ggplot2=2.2.1@RSPM
  - glue=1.1.1@RSPM
  - gtable=0.2.0@RSPM
  - labeling=0.3@RSPM
  - lattice=0.20-35@RSPM
  - lazyeval=0.2.0@RSPM
  - magrittr=1.5@RSPM
  - munsell=0.4.3@RSPM
  - pheatmap=1.0.8@RSPM
  - pkgconfig=2.0.1@RSPM
  - plogr=0.1-1@RSPM
  - plyr=1.8.4@RSPM
  - reshape2=1.4.2@RSPM
  - rlang=0.1.2@RSPM
  - scales=0.5.0@RSPM
  - stringi=1.1.5@RSPM
  - stringr=1.2.0@RSPM
  - svd=0.4.1@RSPM
  - tibble=1.3.4@RSPM
  - viridisLite=0.2.0@RSPM

# r-package(unknown source):
#  - compiler=3.3.1
#  - datasets=3.3.1
#  - grDevices=3.3.1
#  - graphics=3.3.1
#  - grid=3.3.1
#  - methods=3.3.1
#  - parallel=3.3.1
#  - splines=3.3.1
#  - stats4=3.3.1
#  - stats=3.3.1
#  - tcltk=3.3.1
#  - tools=3.3.1
#  - utils=3.3.1
