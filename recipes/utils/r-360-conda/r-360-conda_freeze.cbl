# COBLE:capture, (c) ICR 2026
# Capture date: 2026-02-16
# Capture time: 17:55:52 GMT
# Captured by: ralcraft

coble:

  - environment: r-360-conda

channels:
  - defaults
  - bioconda
  - conda-forge

languages:
  - r-base=3.6.0@r
flags:
  - compile-tools: true
  - dependencies: false
  - priority: flexible

conda:
  - binutils=2.44@conda-forge

conda:
  - binutils_impl_linux-64=2.44@defaults
  - binutils_linux-64=2.44@defaults

conda:
  - conda-gcc-specs=14.3.0@conda-forge
  - gcc=14.3.0@conda-forge
  - gcc_impl_linux-64=14.3.0@conda-forge
  - gcc_linux-64=14.3.0@conda-forge
  - gxx=14.3.0@conda-forge
  - gxx_impl_linux-64=14.3.0@conda-forge
  - gxx_linux-64=14.3.0@conda-forge

conda:
  - icu=58.2@defaults
  - libcurl=7.67.0@defaults

conda:
  - libgcc-devel_linux-64=14.3.0@conda-forge

conda:
  - libgcc-ng=15.2.0@defaults
  - libgcc=15.2.0@defaults

conda:
  - libstdcxx-devel_linux-64=14.3.0@conda-forge

conda:
  - libstdcxx-ng=15.2.0@defaults
  - libstdcxx=15.2.0@defaults
  - zlib=1.2.13@defaults
  - bwidget=1.10.1@defaults
  - bzip2=1.0.8@defaults

conda:
  - c-compiler=1.11.0@conda-forge
  - ca-certificates=2026.1.4@conda-forge

conda:
  - cairo=1.14.12@defaults

conda:
  - compilers=1.11.0@conda-forge

conda:
  - curl=7.67.0@defaults

conda:
  - cxx-compiler=1.11.0@conda-forge

conda:
  - expat=2.7.4@defaults
  - fontconfig=2.14.1@defaults

conda:
  - fortran-compiler=1.11.0@conda-forge

conda:
  - freetype=2.14.1@defaults
  - fribidi=1.0.16@defaults

conda:
  - gfortran=14.3.0@conda-forge
  - gfortran_impl_linux-64=14.3.0@conda-forge
  - gfortran_linux-64=14.3.0@conda-forge

conda:
  - glib=2.56.2@defaults
  - graphite2=1.3.14@defaults
  - harfbuzz=1.8.8@defaults
  - jpeg=9f@defaults
  - kernel-headers_linux-64=4.18.0@defaults
  - krb5=1.16.4@defaults
  - ld_impl_linux-64=2.44@defaults

conda:
  - libblas=3.9.0@conda-forge

conda:
  - libedit=3.1.20230828@defaults
  - libexpat=2.7.4@defaults
  - libffi=3.2.1@defaults
  - libgfortran-ng=7.5.0@defaults
  - libgfortran4=7.5.0@defaults
  - libgfortran5=15.2.0@defaults
  - libgomp=15.2.0@defaults

conda:
  - liblapack=3.9.0@conda-forge
  - libopenblas=0.3.28@conda-forge

conda:
  - libpng=1.6.54@defaults

conda:
  - libsanitizer=14.3.0@conda-forge

conda:
  - libssh2=1.10.0@defaults
  - libtiff=4.2.0@defaults
  - libuuid=1.41.5@defaults
  - libxcb=1.17.0@defaults
  - libxml2=2.9.14@defaults
  - lz4-c=1.9.4@defaults
  - make=4.2.1@defaults
  - ncurses=6.5@defaults
  - openssl=1.1.1w@defaults
  - pango=1.42.4@defaults
  - pcre=8.45@defaults
  - pixman=0.46.4@defaults
  - pthread-stubs=0.3@defaults
  - readline=7.0@defaults
  - sysroot_linux-64=2.28@defaults
  - tk=8.6.15@defaults
  - tktable=2.10@defaults
  - tzdata=2025c@defaults
  - xorg-libx11=1.8.12@defaults
  - xorg-libxau=1.0.12@defaults
  - xorg-libxdmcp=1.1.5@defaults
  - xorg-xorgproto=2024.1@defaults
  - xz=5.6.4@defaults
  - zstd=1.5.6@defaults

r-conda:
  - askpass=1.1@conda-forge
  - httr=1.4.2@conda-forge
  - jsonlite=1.7.2@conda-forge
  - lattice=0.20_44@conda-forge
  - matrix=1.3_3@conda-forge
  - mime=0.10@conda-forge
  - r6=2.5.0@conda-forge
  - survival=3.2_11@conda-forge
  - sys=3.4@conda-forge

bioc-conda:
  - biocgenerics=0.32.0@bioconda
  - s4vectors=0.24.0@bioconda

r-package:
  - BH=1.72.0-3@RSPM
  - BiocManager=1.30.10@RSPM
  - DBI=1.1.0@RSPM
  - DT=0.13@RSPM
  - MASS=7.3-51.5@RSPM
  - RColorBrewer=1.1-2@RSPM

r-package:
  - RCurl=1.98-1.17

r-package:
  - Rcpp=1.0.4@RSPM
  - assertthat=0.2.1@RSPM
  - backports=1.1.5@RSPM
  - base64enc=0.1-3@RSPM

r-package:
  - bitops=1.0-9

r-package:
  - brew=1.0-6@RSPM
  - broom=0.5.5@RSPM
  - callr=3.4.3@RSPM
  - cellranger=1.1.0@RSPM
  - cli=2.0.2@RSPM
  - clipr=0.7.0@RSPM
  - clisymbols=1.2.0@RSPM
  - colorspace=1.4-1@RSPM
  - commonmark=1.7@RSPM
  - covr=3.5.0@RSPM
  - crayon=1.3.4@RSPM
  - crosstalk=1.1.0.1@RSPM
  - data.table=1.12.8@RSPM
  - dbplyr=1.4.2@RSPM
  - desc=1.2.0@RSPM
  - devtools=2.2.2@RSPM
  - digest=0.6.25@RSPM
  - dplyr=0.8.5@RSPM
  - ellipsis=0.3.0@RSPM
  - evaluate=0.14@RSPM
  - fansi=0.4.1@RSPM
  - farver=2.0.3@RSPM
  - forcats=0.5.0@RSPM
  - fs=1.3.2@RSPM
  - generics=0.0.2@RSPM
  - ggplot2=3.3.0@RSPM
  - gh=1.1.0@RSPM
  - git2r=0.26.1@RSPM
  - glue=1.3.2@RSPM
  - gtable=0.3.0@RSPM
  - haven=2.2.0@RSPM
  - highr=0.8@RSPM
  - hms=0.5.3@RSPM
  - htmltools=0.4.0@RSPM
  - htmlwidgets=1.5.1@RSPM
  - ini=0.3.1@RSPM
  - isoband=0.2.0@RSPM
  - knitr=1.28@RSPM
  - labeling=0.3@RSPM
  - later=1.0.0@RSPM
  - lazyeval=0.2.2@RSPM
  - lifecycle=0.2.0@RSPM
  - lubridate=1.7.4@RSPM
  - magrittr=1.5@RSPM
  - markdown=1.1@RSPM
  - memoise=1.1.0@RSPM
  - mgcv=1.8-31@RSPM
  - modelr=0.1.6@RSPM
  - munsell=0.5.0@RSPM
  - nlme=3.1-145@RSPM
  - pillar=1.4.3@RSPM
  - pkgbuild=1.0.6@RSPM
  - pkgconfig=2.0.3@RSPM
  - pkgload=1.0.2@RSPM
  - plogr=0.2.0@RSPM
  - plyr=1.8.6@RSPM
  - praise=1.0.0@RSPM
  - prettyunits=1.1.1@RSPM
  - processx=3.4.2@RSPM
  - progress=1.2.2@RSPM
  - promises=1.1.0@RSPM
  - ps=1.3.2@RSPM
  - purrr=0.3.3@RSPM
  - rcmdcheck=1.3.3@RSPM
  - readr=1.3.1@RSPM
  - readxl=1.3.1@RSPM
  - rematch=1.0.1@RSPM
  - remotes=2.1.1@RSPM
  - reprex=0.3.0@RSPM
  - reshape2=1.4.3@RSPM
  - rex=1.1.2@RSPM
  - rlang=0.4.5@RSPM
  - rmarkdown=2.1@RSPM
  - roxygen2=7.1.0@RSPM
  - rprojroot=1.3-2@RSPM
  - rstudioapi=0.11@RSPM
  - rversions=2.0.1@RSPM
  - rvest=0.3.5@RSPM
  - scales=1.1.0@RSPM
  - selectr=0.4-2@RSPM
  - sessioninfo=1.1.1@RSPM
  - stringi=1.4.6@RSPM
  - stringr=1.4.0@RSPM
  - testthat=2.3.2@RSPM
  - tibble=2.1.3@RSPM
  - tidyr=1.0.2@RSPM
  - tidyselect=1.0.0@RSPM
  - tidyverse=1.3.0@RSPM
  - tinytex=0.20@RSPM
  - usethis=1.5.1@RSPM
  - utf8=1.1.4@RSPM
  - vctrs=0.2.4@RSPM
  - viridisLite=0.3.0@RSPM
  - whisker=0.4@RSPM
  - withr=2.1.2@RSPM
  - xfun=0.12@RSPM
  - xml2=1.2.5@RSPM
  - xopen=1.0.0@RSPM
  - yaml=2.2.1@RSPM

bioc-package:
  - BiocVersion=3.10.1
  - GenomeInfoDb=1.22.1
  - GenomeInfoDbData=1.2.2
  - GenomicRanges=1.38.0
  - IRanges=2.20.2
  - XVector=0.26.0
  - zlibbioc=1.32.0

# r-package(unknown source):
#  - compiler=3.6.0
#  - datasets=3.6.0
#  - grDevices=3.6.0
#  - graphics=3.6.0
#  - grid=3.6.0
#  - methods=3.6.0
#  - parallel=3.6.0
#  - splines=3.6.0
#  - stats4=3.6.0
#  - stats=3.6.0
#  - tcltk=3.6.0
#  - tools=3.6.0
#  - utils=3.6.0
