# COBLE:capture, (c) ICR 2025
# Capture date: 2026-01-10
# Capture time: 00:26:11 GMT
# Captured by: ralcraft

coble:

  - environment: sylver

channels:
  - https://repo.anaconda.com/pkgs/r
  - https://repo.anaconda.com/pkgs/main  
  - bioconda
  - conda-forge
  - r  
  - defaults

languages:
  - r-base=3.6.0@r

flags:
  - dependencies: false
  - priority: strict
# should change channel to conda-forge binutils=2.40

flags:
  - channel: conda-forge
conda:
  - binutils=2.40@conda-forge
  - binutils_impl_linux-64=2.40@conda-forge
  - binutils_linux-64=2.40@conda-forge
# should change channel to defaults bwidget=1.10.1

flags:
  - channel: defaults
conda:
  - bwidget=1.10.1@defaults
# should change channel to conda-forge bzip2=1.0.8

flags:
  - channel: conda-forge
conda:
  - bzip2=1.0.8@conda-forge
  - c-compiler=1.10.0@conda-forge
  - ca-certificates=2026.1.4@conda-forge
# should change channel to defaults cairo=1.14.12

flags:
  - channel: defaults
conda:
  - cairo=1.14.12@defaults
# should change channel to conda-forge cmake=3.17.0

flags:
  - channel: conda-forge
conda:
  - cmake=3.17.0@conda-forge
# should change channel to defaults curl=7.67.0

flags:
  - channel: defaults
conda:
  - curl=7.67.0@defaults
# should change channel to conda-forge cxx-compiler=1.10.0

flags:
  - channel: conda-forge
conda:
  - cxx-compiler=1.10.0@conda-forge
# should change channel to defaults expat=2.7.3

flags:
  - channel: defaults
conda:
  - expat=2.7.3@defaults
  - fontconfig=2.14.1@defaults
  - freetype=2.13.3@defaults
  - fribidi=1.0.10@defaults
# should change channel to conda-forge gcc=13.1.0

flags:
  - channel: conda-forge
conda:
  - gcc=13.1.0@conda-forge
  - gcc_impl_linux-64=13.1.0@conda-forge
  - gcc_linux-64=13.1.0@conda-forge
  - gfortran_impl_linux-64=13.1.0@conda-forge
  - gfortran_linux-64=13.1.0@conda-forge
# should change channel to defaults glib=2.56.2

flags:
  - channel: defaults
conda:
  - glib=2.56.2@defaults
  - graphite2=1.3.14@defaults
# should change channel to conda-forge gxx=13.1.0

flags:
  - channel: conda-forge
conda:
  - gxx=13.1.0@conda-forge
  - gxx_impl_linux-64=13.1.0@conda-forge
  - gxx_linux-64=13.1.0@conda-forge
# should change channel to defaults harfbuzz=1.8.8

flags:
  - channel: defaults
conda:
  - harfbuzz=1.8.8@defaults
  - icu=58.2@defaults
  - jpeg=9f@defaults
  - kernel-headers_linux-64=4.18.0@defaults
  - krb5=1.16.4@defaults
# should change channel to conda-forge ld_impl_linux-64=2.40

flags:
  - channel: conda-forge
conda:
  - ld_impl_linux-64=2.40@conda-forge
# should change channel to defaults lerc=4.0.0

flags:
  - channel: defaults
conda:
  - lerc=4.0.0@defaults
# should change channel to conda-forge libblas=3.9.0

flags:
  - channel: conda-forge
conda:
  - libblas=3.9.0@conda-forge
# should change channel to defaults libcurl=7.67.0

flags:
  - channel: defaults
conda:
  - libcurl=7.67.0@defaults
  - libdeflate=1.22@defaults
  - libedit=3.1.20230828@defaults
  - libexpat=2.7.3@defaults
  - libffi=3.2.1@defaults
# should change channel to conda-forge libgcc-devel_linux-64=13.1.0

flags:
  - channel: conda-forge
conda:
  - libgcc-devel_linux-64=13.1.0@conda-forge
# should change channel to defaults libgcc-ng=15.2.0

flags:
  - channel: defaults
conda:
  - libgcc-ng=15.2.0@defaults
  - libgcc=15.2.0@defaults
  - libgfortran-ng=7.5.0@defaults
  - libgfortran4=7.5.0@defaults
  - libgfortran5=15.2.0@defaults
  - libgomp=15.2.0@defaults
# should change channel to conda-forge libiconv=1.18

flags:
  - channel: conda-forge
conda:
  - libiconv=1.18@conda-forge
  - liblapack=3.9.0@conda-forge
  - liblzma-devel=5.8.1@conda-forge
  - liblzma=5.8.1@conda-forge
  - libopenblas=0.3.28@conda-forge
# should change channel to defaults libpng=1.6.50

flags:
  - channel: defaults
conda:
  - libpng=1.6.50@defaults
# should change channel to conda-forge libsanitizer=13.1.0

flags:
  - channel: conda-forge
conda:
  - libsanitizer=13.1.0@conda-forge
# should change channel to defaults libssh2=1.10.0

flags:
  - channel: defaults
conda:
  - libssh2=1.10.0@defaults
# should change channel to conda-forge libstdcxx-devel_linux-64=13.1.0

flags:
  - channel: conda-forge
conda:
  - libstdcxx-devel_linux-64=13.1.0@conda-forge
# should change channel to defaults libstdcxx-ng=15.2.0

flags:
  - channel: defaults
conda:
  - libstdcxx-ng=15.2.0@defaults
  - libstdcxx=15.2.0@defaults
  - libtiff=4.7.1@defaults
  - libuuid=1.41.5@defaults
# should change channel to conda-forge libuv=1.51.0

flags:
  - channel: conda-forge
conda:
  - libuv=1.51.0@conda-forge
# should change channel to defaults libxcb=1.17.0

flags:
  - channel: defaults
conda:
  - libxcb=1.17.0@defaults
# should change channel to conda-forge libxcrypt=4.4.36

flags:
  - channel: conda-forge
conda:
  - libxcrypt=4.4.36@conda-forge
# should change channel to defaults libxml2=2.9.14

flags:
  - channel: defaults
conda:
  - libxml2=2.9.14@defaults
# should change channel to conda-forge libzlib=1.2.13

flags:
  - channel: conda-forge
conda:
  - libzlib=1.2.13@conda-forge
# should change channel to defaults lz4-c=1.9.4

flags:
  - channel: defaults
conda:
  - lz4-c=1.9.4@defaults
  - make=4.2.1@defaults
  - ncurses=6.5@defaults
  - openssl=1.1.1w@defaults
# should change channel to conda-forge pandoc=2.19.2

flags:
  - channel: conda-forge
conda:
  - pandoc=2.19.2@conda-forge
# should change channel to defaults pango=1.42.4

flags:
  - channel: defaults
conda:
  - pango=1.42.4@defaults
  - pcre=8.45@defaults
  - pixman=0.46.4@defaults
# should change channel to conda-forge pkg-config=0.29.2

flags:
  - channel: conda-forge
conda:
  - pkg-config=0.29.2@conda-forge
# should change channel to defaults pthread-stubs=0.3

flags:
  - channel: defaults
conda:
  - pthread-stubs=0.3@defaults
  - readline=7.0@defaults
# should change channel to conda-forge rhash=1.4.3

flags:
  - channel: conda-forge
conda:
  - rhash=1.4.3@conda-forge
  - sqlite=3.28.0@conda-forge
# should change channel to defaults sysroot_linux-64=2.28

flags:
  - channel: defaults
conda:
  - sysroot_linux-64=2.28@defaults
  - tk=8.6.15@defaults
  - tktable=2.10@defaults
  - tzdata=2025b@defaults
  - xorg-libx11=1.8.12@defaults
  - xorg-libxau=1.0.12@defaults
  - xorg-libxdmcp=1.1.5@defaults
  - xorg-xorgproto=2024.1@defaults
# should change channel to conda-forge xz-gpl-tools=5.8.1

flags:
  - channel: conda-forge
conda:
  - xz-gpl-tools=5.8.1@conda-forge
  - xz-tools=5.8.1@conda-forge
  - xz=5.8.1@conda-forge
  - zlib=1.2.13@conda-forge
# should change channel to defaults zstd=1.5.6

flags:
  - channel: defaults
conda:
  - zstd=1.5.6@defaults
# should change channel to conda-forge askpass=1.1

flags:
  - channel: conda-forge
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
  - curl=4.3.1@conda-forge
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
  - openssl=1.4.4@conda-forge
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
# should change channel to bioconda affy=1.64.0

flags:
  - channel: bioconda
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
# should change channel to CRAN BH=1.75.0-0

flags:
  - channel: CRAN
r-package:
  - BH=1.75.0-0
  - MASS=7.3-54
  - Matrix=1.3-3
  - RColorBrewer=1.1-2
  - RCurl=1.98-1.1
  - XML=3.99-0.3
  - base64enc=0.1-3
  - bitops=1.0-7
  - colorspace=2.0-1
  - fastmatch=1.1-0
  - lattice=0.20-44
  - mgcv=1.8-35
  - nlme=3.1-152
  - selectr=0.4-2
  - snow=0.4-3
  - survival=3.2-11
  - uuid=0.1-4
  - xtable=1.8-4
# should change channel to Bioconductor BiocVersion=3.10.1

flags:
  - channel: Bioconductor
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
