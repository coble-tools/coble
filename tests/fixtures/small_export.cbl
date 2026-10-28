# COBLE:export, (c) ICR 2026
# Capture date: 2026-10-28
# Capture time: 22:17:57 GMT
# Captured by: rachel.alcraft

coble:

  - environment: xxsmall

channels:
  - defaults
  - r
  - bioconda
  - conda-forge

languages:
  - r-base=4.3.1@conda-forge
  - python=3.13.1@conda-forge
flags:
  - compile: tools=true
  - dependencies: false
  - priority: flexible
  - export: PYTHONNOUSERSITE="1"

conda:
  - clangxx=16.0.6@conda-forge
  - icu=73.2@conda-forge
  - libcblas=3.11.0@conda-forge
  - libclang-cpp16=16.0.6@conda-forge
  - libclang-cpp19.1=19.1.2@conda-forge
  - libcurl=8.21.0@conda-forge
  - libcxx-devel=19.1.7@conda-forge
  - libcxx-headers=19.1.7@conda-forge
  - libcxx=23.1.4@conda-forge
  - libgcc=16.2.0@conda-forge
  - libzlib=1.3.2@conda-forge
  - zlib=1.3.2@conda-forge
  - bwidget=1.10.1@conda-forge
  - bzip2=1.0.8@conda-forge
  - c-ares=1.34.9@conda-forge
  - c-compiler=1.7.0@conda-forge
  - ca-certificates=2026.10.23@conda-forge
  - cairo=1.18.0@conda-forge
  - cctools=1010.6@conda-forge
  - clang-16=16.0.6@conda-forge
  - clang-19=19.1.2@conda-forge
  - clang=16.0.6@conda-forge
  - compiler-rt=16.0.6@conda-forge
  - compilers=1.7.0@conda-forge
  - curl=8.21.0@conda-forge
  - cxx-compiler=1.7.0@conda-forge
  - font-ttf-dejavu-sans-mono=2.37@conda-forge
  - font-ttf-inconsolata=3.000@conda-forge
  - font-ttf-source-code-pro=2.038@conda-forge
  - font-ttf-ubuntu=0.83@conda-forge
  - fontconfig=2.18.3@conda-forge
  - fonts-conda-forge=1@conda-forge
  - fortran-compiler=1.7.0@conda-forge
  - freetype=2.14.3@conda-forge
  - fribidi=1.0.17@conda-forge
  - gettext-tools=0.25.1@conda-forge
  - gettext=0.25.1@conda-forge
  - gfortran=12.4.0@conda-forge
  - gmp=6.3.0@conda-forge
  - graphite2=1.3.15@conda-forge
  - harfbuzz=8.3.0@conda-forge
  - isl=0.26@conda-forge
  - krb5=1.22.2@conda-forge
  - ld64=951.9@conda-forge
  - lerc=4.2.0@conda-forge
  - libasprintf-devel=0.25.1@conda-forge
  - libasprintf=0.25.1@conda-forge
  - libblas=3.11.0@conda-forge
  - libdeflate=1.25@conda-forge
  - libedit=3.1.20260512@conda-forge
  - libev=4.33@conda-forge
  - libexpat=2.9.0@conda-forge
  - libffi=3.7.0@conda-forge
  - libfreetype=2.14.3@conda-forge
  - libfreetype6=2.14.3@conda-forge
  - libgettextpo-devel=0.25.1@conda-forge
  - libgettextpo=0.25.1@conda-forge
  - libgfortran=16.2.0@conda-forge
  - libgfortran5=16.2.0@conda-forge
  - libglib=2.78.1@conda-forge
  - libiconv=1.18@conda-forge
  - libintl-devel=0.25.1@conda-forge
  - libintl=0.25.1@conda-forge
  - libjpeg-turbo=3.2.1@conda-forge
  - liblapack=3.11.0@conda-forge
  - libllvm16=16.0.6@conda-forge
  - libllvm19=19.1.2@conda-forge
  - liblzma-devel=5.8.3@conda-forge
  - liblzma=5.8.3@conda-forge
  - libmpdec=4.0.0@conda-forge
  - libnghttp2=1.70.0@conda-forge
  - libopenblas=0.3.34@conda-forge
  - libpng=1.6.59@conda-forge
  - libsigtool=0.1.3@conda-forge
  - libsqlite=3.53.4@conda-forge
  - libssh2=1.11.1@conda-forge
  - libtiff=4.7.2@conda-forge
  - libxml2=2.12.7@conda-forge
  - llvm-openmp=23.1.4@conda-forge
  - llvm-tools-19=19.1.2@conda-forge
  - llvm-tools=16.0.6@conda-forge
  - make=4.4.1@conda-forge
  - mpc=1.4.0@conda-forge
  - mpfr=4.2.2@conda-forge
  - ncurses=6.6@conda-forge
  - numpy=2.5.4@conda-forge
  - openssl=3.6.5@conda-forge
  - pandas=3.1.0@conda-forge
  - pango=1.50.14@conda-forge
  - pcre2=10.40@conda-forge
  - pip=26.2.2@conda-forge
  - pixman=0.46.4@conda-forge
  - python_abi=3.13@conda-forge
  - python-dateutil=3.0.0@conda-forge
  - python-tzdata=2026.6@conda-forge
  - readline=8.3@conda-forge
  - sigtool-codesign=0.1.3@conda-forge
  - sigtool=0.1.3@conda-forge
  - six=1.17.0@conda-forge
  - tapi=1300.6.5@conda-forge
  - tk=8.6.13@conda-forge
  - tktable=2.10@conda-forge
  - tzdata=2026e@conda-forge
  - xz-gpl-tools=5.8.3@conda-forge
  - xz-tools=5.8.3@conda-forge
  - xz=5.8.3@conda-forge
  - zstd=1.5.7@conda-forge

r-conda:
  - biocmanager=1.30.26@conda-forge
  - cli=3.6.5@conda-forge
  - colorspace=2.1_1@conda-forge
  - crayon=1.5.3@conda-forge
  - ellipsis=0.3.2@conda-forge
  - fansi=1.0.6@conda-forge
  - farver=2.1.2@conda-forge
  - ggplot2=3.5.2@conda-forge
  - glue=1.8.0@conda-forge
  - gtable=0.3.6@conda-forge
  - isoband=0.2.7@conda-forge
  - labeling=0.4.3@conda-forge
  - lattice=0.22_7@conda-forge
  - lifecycle=1.0.4@conda-forge
  - magrittr=2.0.3@conda-forge
  - mass=7.3_60.0.1@conda-forge
  - matrix=1.6_5@conda-forge
  - mgcv=1.9_3@conda-forge
  - munsell=0.5.1@conda-forge
  - nlme=3.1_168@conda-forge
  - pillar=1.11.0@conda-forge
  - pkgconfig=2.0.3@conda-forge
  - r6=2.6.1@conda-forge
  - rcolorbrewer=1.1_3@conda-forge
  - remotes=2.5.0@conda-forge
  - renv=1.1.5@conda-forge
  - rlang=1.1.6@conda-forge
  - scales=1.4.0@conda-forge
  - tibble=3.3.0@conda-forge
  - utf8=1.2.6@conda-forge
  - vctrs=0.6.5@conda-forge
  - viridislite=0.4.2@conda-forge
  - withr=3.0.2@conda-forge

r-package:

# r-package(unknown source):
#  - compiler=4.3.1
#  - datasets=4.3.1
#  - graphics=4.3.1
#  - grDevices=4.3.1
#  - grid=4.3.1
#  - methods=4.3.1
#  - parallel=4.3.1
#  - splines=4.3.1
#  - stats=4.3.1
#  - stats4=4.3.1
#  - tcltk=4.3.1
#  - tools=4.3.1
#  - utils=4.3.1
