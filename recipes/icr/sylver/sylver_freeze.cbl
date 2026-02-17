# COBLE:capture, (c) ICR 2026
# Capture date: 2026-02-16
# Capture time: 22:43:58 GMT
# Captured by: ralcraft

coble:

  - environment: sylver

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
  - libiconv=1.18@conda-forge
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

conda:
  - pandoc=2.19.2@conda-forge

conda:
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
  - assertthat=0.2.1@conda-forge
  - backports=1.2.1@conda-forge
  - base64enc=0.1_3@conda-forge
  - bh=1.75.0_0@conda-forge
  - biocmanager=1.30.15@conda-forge
  - bit64=4.0.5@conda-forge
  - bit=4.0.4@conda-forge
  - bitops=1.0_7@conda-forge
  - blob=1.2.1@conda-forge
  - brio=1.1.2@conda-forge
  - broom=0.7.6@conda-forge
  - bslib=0.2.5.1@conda-forge
  - cachem=1.0.5@conda-forge
  - callr=3.7.0@conda-forge
  - cellranger=1.1.0@conda-forge
  - cli=2.5.0@conda-forge
  - clipr=0.7.1@conda-forge
  - colorspace=2.0_1@conda-forge
  - commonmark=1.7@conda-forge
  - cpp11=0.2.7@conda-forge
  - crayon=1.4.1@conda-forge
  - data.table=1.14.0@conda-forge
  - dbi=1.1.1@conda-forge
  - dbplyr=2.1.1@conda-forge
  - desc=1.3.0@conda-forge
  - diffobj=0.3.4@conda-forge
  - digest=0.6.27@conda-forge
  - dplyr=1.0.6@conda-forge
  - dtplyr=1.1.0@conda-forge
  - effsize=0.8.1@conda-forge
  - ellipsis=0.3.2@conda-forge
  - evaluate=0.14@conda-forge
  - fansi=0.4.2@conda-forge
  - farver=2.1.0@conda-forge
  - fastmap=1.1.0@conda-forge
  - fastmatch=1.1_0@conda-forge
  - forcats=0.5.1@conda-forge
  - formatr=1.9@conda-forge
  - fs=1.5.0@conda-forge
  - futile.logger=1.4.3@conda-forge
  - futile.options=1.0.1@conda-forge
  - gargle=1.1.0@conda-forge
  - generics=0.1.0@conda-forge
  - ggplot2=3.3.3@conda-forge
  - ggrepel=0.9.1@conda-forge
  - glue=1.4.2@conda-forge
  - googledrive=1.0.1@conda-forge
  - googlesheets4=0.3.0@conda-forge
  - gridextra=2.3@conda-forge
  - gtable=0.3.0@conda-forge
  - haven=2.4.1@conda-forge
  - highr=0.9@conda-forge
  - hms=1.1.0@conda-forge
  - htmltools=0.5.1.1@conda-forge
  - httpuv=1.6.1@conda-forge
  - httr=1.4.2@conda-forge
  - ids=1.0.1@conda-forge
  - isoband=0.2.4@conda-forge
  - jquerylib=0.1.4@conda-forge
  - jsonlite=1.7.2@conda-forge
  - knitr=1.33@conda-forge
  - labeling=0.4.2@conda-forge
  - lambda.r=1.2.4@conda-forge
  - later=1.2.0@conda-forge
  - lattice=0.20_44@conda-forge
  - lifecycle=1.0.0@conda-forge
  - lubridate=1.7.10@conda-forge
  - magrittr=2.0.1@conda-forge
  - markdown=1.1@conda-forge
  - mass=7.3_54@conda-forge
  - matrix=1.3_3@conda-forge
  - memoise=2.0.0@conda-forge
  - mgcv=1.8_35@conda-forge
  - mime=0.10@conda-forge
  - modelr=0.1.8@conda-forge
  - munsell=0.5.0@conda-forge
  - nlme=3.1_152@conda-forge
  - pillar=1.6.1@conda-forge
  - pkgconfig=2.0.3@conda-forge
  - pkgload=1.2.1@conda-forge
  - plogr=0.2.0@conda-forge
  - plyr=1.8.6@conda-forge
  - praise=1.0.0@conda-forge
  - prettyunits=1.1.1@conda-forge
  - processx=3.5.2@conda-forge
  - progress=1.2.2@conda-forge
  - promises=1.2.0.1@conda-forge
  - ps=1.6.0@conda-forge
  - purrr=0.3.4@conda-forge
  - r6=2.5.0@conda-forge
  - rappdirs=0.3.3@conda-forge
  - rcolorbrewer=1.1_2@conda-forge
  - rcpp=1.0.6@conda-forge
  - rcurl=1.98_1.1@conda-forge
  - readr=1.4.0@conda-forge
  - readxl=1.3.1@conda-forge
  - rematch2=2.1.2@conda-forge
  - rematch=1.0.1@conda-forge
  - remotes=2.3.0@conda-forge
  - reprex=2.0.0@conda-forge
  - reshape2=1.4.4@conda-forge
  - rlang=0.4.11@conda-forge
  - rmarkdown=2.8@conda-forge
  - rprojroot=2.0.2@conda-forge
  - rsqlite=2.2.5@conda-forge
  - rstudioapi=0.13@conda-forge
  - rvest=1.0.0@conda-forge
  - sass=0.4.0@conda-forge
  - scales=1.1.1@conda-forge
  - selectr=0.4_2@conda-forge
  - shiny=1.6.0@conda-forge
  - shinythemes=1.2.0@conda-forge
  - snow=0.4_3@conda-forge
  - sourcetools=0.1.7@conda-forge
  - stringi=1.4.3@conda-forge
  - stringr=1.4.0@conda-forge
  - sys=3.4@conda-forge
  - testthat=3.0.2@conda-forge
  - tibble=3.1.2@conda-forge
  - tidyr=1.1.3@conda-forge
  - tidyselect=1.1.1@conda-forge
  - tidyverse=1.3.1@conda-forge
  - tinytex=0.31@conda-forge
  - utf8=1.2.1@conda-forge
  - uuid=0.1_4@conda-forge
  - vctrs=0.3.8@conda-forge
  - venndiagram=1.6.20@conda-forge
  - viridislite=0.4.0@conda-forge
  - waldo=0.2.5@conda-forge
  - withr=2.4.2@conda-forge
  - xfun=0.23@conda-forge
  - xml2=1.3.2@conda-forge
  - xml=3.99_0.3@conda-forge
  - xtable=1.8_4@conda-forge
  - yaml=2.2.1@conda-forge

bioc-conda:
  - affy=1.64.0@bioconda
  - affyio=1.56.0@bioconda
  - annotate=1.64.0@bioconda
  - annotationdbi=1.48.0@bioconda
  - biocgenerics=0.32.0@bioconda
  - biocparallel=1.20.0@bioconda
  - fgsea=1.12.0@bioconda
  - geneplotter=1.64.0@bioconda
  - graph=1.64.0@bioconda
  - gsva=1.34.0@bioconda
  - iranges=2.20.0@bioconda
  - org.hs.eg.db=3.10.0@bioconda
  - preprocesscore=1.48.0@bioconda
  - s4vectors=0.24.0@bioconda
  - zlibbioc=1.32.0@bioconda

r-package:

bioc-package:
  - BiocVersion=3.10.1
  - limma=3.42.2

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
