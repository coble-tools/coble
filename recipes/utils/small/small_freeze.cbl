# COBLE:capture, (c) ICR 2026
# Capture date: 2026-01-24
# Capture time: 22:47:53 GMT
# Captured by: ralcraft

coble:

  - environment: small

channels:
  - defaults
  - bioconda
  - conda-forge

flags:
  - compile-paths: true
  - dependencies: false
  - priority: flexible

languages:
  - r-base=4.5.2@conda-forge
  - python=3.14.2@conda-forge
flags:
  - export: CC="/home/ralcraft/miniforge3/envs/enrichr/bin/gcc"
  - export: CFLAGS="-I/home/ralcraft/miniforge3/envs/small/include"
  - export: CPPFLAGS="-I/home/ralcraft/miniforge3/envs/small/include"
  - export: CXX="/home/ralcraft/miniforge3/envs/enrichr/bin/g++"
  - export: CXXFLAGS="-I/home/ralcraft/miniforge3/envs/small/include"
  - export: F77="/home/ralcraft/miniforge3/envs/enrichr/bin/x86_64-conda-linux-gnu-gfortran"
  - export: FC="/home/ralcraft/miniforge3/envs/enrichr/bin/x86_64-conda-linux-gnu-gfortran"
  - export: LDFLAGS="-L/home/ralcraft/miniforge3/envs/small/lib -Wl,-rpath,/home/ralcraft/miniforge3/envs/small/lib"
  - export: PYTHONNOUSERSITE="1"

conda:
  - binutils=2.40@conda-forge
  - binutils_impl_linux-64=2.40@conda-forge
  - binutils_linux-64=2.40@conda-forge
  - gcc=13.1.0@conda-forge
  - gcc_impl_linux-64=13.1.0@conda-forge
  - gcc_linux-64=13.1.0@conda-forge
  - gxx=13.1.0@conda-forge
  - gxx_impl_linux-64=13.1.0@conda-forge
  - gxx_linux-64=13.1.0@conda-forge
  - icu=75.1@conda-forge
  - libcblas=3.11.0@conda-forge
  - libcurl=8.18.0@conda-forge
  - libgcc-devel_linux-64=13.1.0@conda-forge
  - libgcc-ng=15.2.0@conda-forge
  - libgcc=15.2.0@conda-forge
  - libstdcxx-devel_linux-64=13.1.0@conda-forge
  - libstdcxx-ng=15.2.0@conda-forge
  - libstdcxx=15.2.0@conda-forge
  - libzlib=1.3.1@conda-forge
  - bwidget=1.10.1@conda-forge
  - bzip2=1.0.8@conda-forge
  - c-ares=1.34.6@conda-forge
  - c-compiler=1.10.0@conda-forge
  - ca-certificates=2026.1.4@conda-forge
  - cairo=1.18.4@conda-forge
  - curl=8.18.0@conda-forge
  - cxx-compiler=1.10.0@conda-forge
  - font-ttf-dejavu-sans-mono=2.37@conda-forge
  - font-ttf-inconsolata=3.000@conda-forge
  - font-ttf-source-code-pro=2.038@conda-forge
  - font-ttf-ubuntu=0.83@conda-forge
  - fontconfig=2.15.0@conda-forge
  - fonts-conda-forge=1@conda-forge
  - freetype=2.14.1@conda-forge
  - fribidi=1.0.16@conda-forge
  - gfortran_impl_linux-64=13.1.0@conda-forge
  - gfortran_linux-64=13.1.0@conda-forge
  - glpk=5.0@conda-forge
  - gmp=6.3.0@conda-forge
  - graphite2=1.3.14@conda-forge
  - gsl=2.7@conda-forge
  - harfbuzz=12.2.0@conda-forge
  - kernel-headers_linux-64=6.12.0@conda-forge
  - keyutils=1.6.3@conda-forge
  - krb5=1.21.3@conda-forge
  - ld_impl_linux-64=2.40@conda-forge
  - lerc=4.0.0@conda-forge
  - libblas=3.11.0@conda-forge
  - libdeflate=1.25@conda-forge
  - libedit=3.1.20250104@conda-forge
  - libev=4.33@conda-forge
  - libexpat=2.7.3@conda-forge
  - libffi=3.5.2@conda-forge
  - libfreetype6=2.14.1@conda-forge
  - libfreetype=2.14.1@conda-forge
  - libgfortran-ng=15.2.0@conda-forge
  - libgfortran5=15.2.0@conda-forge
  - libgfortran=15.2.0@conda-forge
  - libglib=2.86.3@conda-forge
  - libgomp=15.2.0@conda-forge
  - libiconv=1.18@conda-forge
  - libjpeg-turbo=3.1.2@conda-forge
  - liblapack=3.11.0@conda-forge
  - liblzma=5.8.2@conda-forge
  - libmpdec=4.0.0@conda-forge
  - libnghttp2=1.67.0@conda-forge
  - libopenblas=0.3.30@conda-forge
  - libpng=1.6.54@conda-forge
  - libsanitizer=13.1.0@conda-forge
  - libsqlite=3.51.2@conda-forge
  - libssh2=1.11.1@conda-forge
  - libtiff=4.7.1@conda-forge
  - libuuid=2.41.3@conda-forge
  - libxcb=1.17.0@conda-forge
  - libxml2-16=2.15.1@conda-forge
  - libxml2=2.15.1@conda-forge
  - make=4.4.1@conda-forge
  - ncurses=6.5@conda-forge
  - numpy=2.4.1@conda-forge
  - openssl=3.6.0@conda-forge
  - pandas=3.0.0@conda-forge
  - pandoc=3.8.3@conda-forge
  - pango=1.56.4@conda-forge
  - pcre2=10.47@conda-forge
  - pip=25.3@conda-forge
  - pixman=0.46.4@conda-forge
  - pthread-stubs=0.4@conda-forge
  - python-dateutil=2.9.0.post0@conda-forge
  - python_abi=3.14@conda-forge
  - readline=8.3@conda-forge
  - sed=4.9@conda-forge
  - six=1.17.0@conda-forge
  - sysroot_linux-64=2.39@conda-forge
  - tk=8.6.13@conda-forge
  - tktable=2.10@conda-forge
  - tzdata=2025c@conda-forge
  - xorg-libice=1.1.2@conda-forge
  - xorg-libsm=1.2.6@conda-forge
  - xorg-libx11=1.8.12@conda-forge
  - xorg-libxau=1.0.12@conda-forge
  - xorg-libxdmcp=1.1.5@conda-forge
  - xorg-libxext=1.3.6@conda-forge
  - xorg-libxrender=0.9.12@conda-forge
  - xorg-libxt=1.3.1@conda-forge
  - zstd=1.5.7@conda-forge

r-conda:
  - askpass=1.2.1@conda-forge
  - assertthat=0.2.1@conda-forge
  - backports=1.5.0@conda-forge
  - base64enc=0.1_3@conda-forge
  - bit64=4.6.0_1@conda-forge
  - bit=4.6.0@conda-forge
  - blob=1.3.0@conda-forge
  - broom=1.0.11@conda-forge
  - bslib=0.9.0@conda-forge
  - cachem=1.1.0@conda-forge
  - callr=3.7.6@conda-forge
  - cellranger=1.1.0@conda-forge
  - cli=3.6.5@conda-forge
  - clipr=0.8.0@conda-forge
  - colorspace=2.1_2@conda-forge
  - conflicted=1.2.0@conda-forge
  - cpp11=0.5.3@conda-forge
  - crayon=1.5.3@conda-forge
  - data.table=1.17.8@conda-forge
  - dbi=1.2.3@conda-forge
  - dbplyr=2.5.1@conda-forge
  - digest=0.6.39@conda-forge
  - dplyr=1.1.4@conda-forge
  - dtplyr=1.3.2@conda-forge
  - ellipsis=0.3.2@conda-forge
  - evaluate=1.0.5@conda-forge
  - fansi=1.0.7@conda-forge
  - farver=2.1.2@conda-forge
  - fastmap=1.2.0@conda-forge
  - fontawesome=0.5.3@conda-forge
  - forcats=1.0.1@conda-forge
  - fs=1.6.6@conda-forge
  - gargle=1.6.0@conda-forge
  - generics=0.1.4@conda-forge
  - ggforce=0.5.0@conda-forge
  - ggplot2=4.0.1@conda-forge
  - ggraph=2.2.2@conda-forge
  - ggrepel=0.9.6@conda-forge
  - glue=1.8.0@conda-forge
  - googledrive=2.1.2@conda-forge
  - googlesheets4=1.1.2@conda-forge
  - graphlayouts=1.2.2@conda-forge
  - gridextra=2.3@conda-forge
  - gtable=0.3.6@conda-forge
  - haven=2.5.5@conda-forge
  - highr=0.11@conda-forge
  - hms=1.1.4@conda-forge
  - htmltools=0.5.9@conda-forge
  - htmlwidgets=1.6.4@conda-forge
  - httr=1.4.7@conda-forge
  - ids=1.0.1@conda-forge
  - igraph=2.1.4@conda-forge
  - isoband=0.3.0@conda-forge
  - jquerylib=0.1.4@conda-forge
  - jsonlite=2.0.0@conda-forge
  - knitr=1.51@conda-forge
  - labeling=0.4.3@conda-forge
  - lattice=0.22_7@conda-forge
  - lifecycle=1.0.5@conda-forge
  - lubridate=1.9.4@conda-forge
  - magrittr=2.0.4@conda-forge
  - mass=7.3_65@conda-forge
  - matrix=1.7_4@conda-forge
  - memoise=2.0.1@conda-forge
  - mime=0.13@conda-forge
  - modelr=0.1.11@conda-forge
  - munsell=0.5.1@conda-forge
  - pillar=1.11.1@conda-forge
  - pkgconfig=2.0.3@conda-forge
  - polyclip=1.10_7@conda-forge
  - prettyunits=1.2.0@conda-forge
  - processx=3.8.6@conda-forge
  - progress=1.2.3@conda-forge
  - ps=1.9.1@conda-forge
  - purrr=1.2.1@conda-forge
  - r6=2.6.1@conda-forge
  - ragg=1.5.0@conda-forge
  - rappdirs=0.3.4@conda-forge
  - rcolorbrewer=1.1_3@conda-forge
  - rcpp=1.1.1@conda-forge
  - rcpparmadillo=15.2.3_1@conda-forge
  - rcppeigen=0.3.4.0.2@conda-forge
  - readr=2.1.6@conda-forge
  - readxl=1.4.5@conda-forge
  - rematch2=2.1.2@conda-forge
  - rematch=2.0.0@conda-forge
  - reprex=2.1.1@conda-forge
  - rlang=1.1.7@conda-forge
  - rmarkdown=2.30@conda-forge
  - rstudioapi=0.18.0@conda-forge
  - rvest=1.0.5@conda-forge
  - s7=0.2.1@conda-forge
  - sass=0.4.10@conda-forge
  - scales=1.4.0@conda-forge
  - selectr=0.5_1@conda-forge
  - stringi=1.8.7@conda-forge
  - stringr=1.6.0@conda-forge
  - sys=3.4.3@conda-forge
  - textshaping=1.0.4@conda-forge
  - tibble=3.3.1@conda-forge
  - tidygraph=1.3.0@conda-forge
  - tidyr=1.3.2@conda-forge
  - tidyselect=1.2.1@conda-forge
  - tidyverse=2.0.0@conda-forge
  - timechange=0.3.0@conda-forge
  - tinytex=0.58@conda-forge
  - tweenr=2.0.3@conda-forge
  - tzdb=0.5.0@conda-forge
  - utf8=1.2.6@conda-forge
  - uuid=1.2_2@conda-forge
  - vctrs=0.6.5@conda-forge
  - viridis=0.6.5@conda-forge
  - viridislite=0.4.2@conda-forge
  - visnetwork=2.1.4@conda-forge
  - vroom=1.6.7@conda-forge
  - withr=3.0.2@conda-forge
  - xfun=0.56@conda-forge
  - xml2=1.5.2@conda-forge
  - yaml=2.3.12@conda-forge

r-package:

# r-package(unknown source):
#  - compiler=4.5.2
#  - datasets=4.5.2
#  - grDevices=4.5.2
#  - graphics=4.5.2
#  - grid=4.5.2
#  - methods=4.5.2
#  - parallel=4.5.2
#  - splines=4.5.2
#  - stats4=4.5.2
#  - stats=4.5.2
#  - tcltk=4.5.2
#  - tools=4.5.2
#  - utils=4.5.2
