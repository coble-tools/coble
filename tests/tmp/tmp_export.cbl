# COBLE:export, (c) ICR 2026
# Capture date: 2026-09-20
# Capture time: 11:06:30 BST
# Captured by: rachel.alcraft

coble:

  - environment: tmp

channels:
  - bioconda
  - conda-forge

languages:
  - r-base=4.4.2@conda-forge
  - python=3.12.12@conda-forge
flags:
  - compile-tools: true
  - dependencies: false
  - priority: flexible
  - export: PYTHONNOUSERSITE="1"

conda:
  - clangxx=18.1.8@conda-forge
  - conda-gcc-specs=15.3.0@conda-forge
  - gcc=15.3.0@conda-forge
  - icu=75.1@conda-forge
  - libcblas=3.11.0@conda-forge
  - libclang-cpp18.1=18.1.8@conda-forge
  - libclang-cpp21.1=21.1.8@conda-forge
  - libclang-cpp22.1=22.1.8@conda-forge
  - libclang13=22.1.8@conda-forge
  - libcompiler-rt=21.1.8@conda-forge
  - libcurl=8.21.0@conda-forge
  - libcxx-devel=21.1.8@conda-forge
  - libcxx-headers=21.1.8@conda-forge
  - libcxx=23.1.1@conda-forge
  - libgcc=16.2.0@conda-forge
  - libzlib=1.3.2@conda-forge
  - zlib=1.3.2@conda-forge
  - bwidget=1.10.1@conda-forge
  - bzip2=1.0.8@conda-forge
  - c-ares=1.34.8@conda-forge
  - c-compiler=1.10.0@conda-forge
  - ca-certificates=2026.7.22@conda-forge
  - cairo=1.18.4@conda-forge
  - cctools=1021.4@conda-forge
  - clang-18=18.1.8@conda-forge
  - clang-21=21.1.8@conda-forge
  - clang-scan-deps=21.1.8@conda-forge
  - clang=18.1.8@conda-forge
  - compiler-rt=18.1.8@conda-forge
  - compiler-rt21=21.1.8@conda-forge
  - compilers=1.10.0@conda-forge
  - curl=8.21.0@conda-forge
  - cxx-compiler=1.10.0@conda-forge
  - font-ttf-dejavu-sans-mono=2.37@conda-forge
  - font-ttf-inconsolata=3.000@conda-forge
  - font-ttf-source-code-pro=2.038@conda-forge
  - font-ttf-ubuntu=0.83@conda-forge
  - fontconfig=2.18.3@conda-forge
  - fonts-conda-forge=1@conda-forge
  - fortran-compiler=1.10.0@conda-forge
  - freetype=2.14.3@conda-forge
  - fribidi=1.0.16@conda-forge
  - gfortran=13.4.0@conda-forge
  - gmp=6.3.0@conda-forge
  - graphite2=1.3.15@conda-forge
  - gsl=2.7@conda-forge
  - harfbuzz=11.1.0@conda-forge
  - isl=0.26@conda-forge
  - krb5=1.22.2@conda-forge
  - ld64=954.16@conda-forge
  - lerc=4.2.0@conda-forge
  - libasprintf=0.25.1@conda-forge
  - libblas=3.11.0@conda-forge
  - libdeflate=1.25@conda-forge
  - libedit=3.1.20250104@conda-forge
  - libev=4.33@conda-forge
  - libexpat=2.8.1@conda-forge
  - libffi=3.5.2@conda-forge
  - libfreetype=2.14.3@conda-forge
  - libfreetype6=2.14.3@conda-forge
  - libgettextpo=0.25.1@conda-forge
  - libgfortran=16.2.0@conda-forge
  - libgfortran5=16.2.0@conda-forge
  - libglib=2.84.0@conda-forge
  - libiconv=1.18@conda-forge
  - libintl=0.25.1@conda-forge
  - libjpeg-turbo=3.2.0@conda-forge
  - liblapack=3.11.0@conda-forge
  - libllvm18=18.1.8@conda-forge
  - libllvm21=21.1.8@conda-forge
  - libllvm22=22.1.8@conda-forge
  - liblzma=5.8.3@conda-forge
  - libnghttp2=1.68.1@conda-forge
  - libopenblas=0.3.34@conda-forge
  - libpng=1.6.58@conda-forge
  - libsigtool=0.1.3@conda-forge
  - libsqlite=3.53.4@conda-forge
  - libssh2=1.11.1@conda-forge
  - libtiff=4.7.2@conda-forge
  - libxml2-16=2.15.1@conda-forge
  - libxml2=2.15.1@conda-forge
  - llvm-openmp=23.1.1@conda-forge
  - llvm-tools-18=18.1.8@conda-forge
  - llvm-tools-21=21.1.8@conda-forge
  - llvm-tools=18.1.8@conda-forge
  - make=4.4.1@conda-forge
  - mpc=1.4.0@conda-forge
  - mpfr=4.2.2@conda-forge
  - ncurses=6.6@conda-forge
  - openssl=3.6.4@conda-forge
  - packaging=26.3@conda-forge
  - pango=1.56.3@conda-forge
  - pcre2=10.44@conda-forge
  - pip=26.2.1@conda-forge
  - pixman=0.46.4@conda-forge
  - readline=8.3@conda-forge
  - setuptools=84.0.0@conda-forge
  - sigtool-codesign=0.1.3@conda-forge
  - sigtool=0.1.3@conda-forge
  - tapi=1300.6.5@conda-forge
  - tk=8.6.13@conda-forge
  - tktable=2.10@conda-forge
  - tzdata=2026c@conda-forge
  - wheel=0.48.0@conda-forge
  - zstd=1.5.7@conda-forge

r-conda:
  - biocmanager=1.30.27@conda-forge
  - cli=3.6.6@conda-forge
  - crayon=1.5.3@conda-forge
  - data.table=1.18.6.1@conda-forge
  - dplyr=1.2.1@conda-forge
  - ellipsis=0.3.3@conda-forge
  - fansi=1.0.7@conda-forge
  - generics=0.1.4@conda-forge
  - glue=1.8.1@conda-forge
  - lifecycle=1.0.5@conda-forge
  - magrittr=2.0.5@conda-forge
  - pillar=1.11.1@conda-forge
  - pkgconfig=2.0.3@conda-forge
  - purrr=1.2.2@conda-forge
  - r6=2.6.1@conda-forge
  - remotes=2.5.0@conda-forge
  - renv=1.2.4@conda-forge
  - rlang=1.3.0@conda-forge
  - stringi=1.8.7@conda-forge
  - stringr=1.6.0@conda-forge
  - tibble=3.3.1@conda-forge
  - tidyr=1.3.2@conda-forge
  - tidyselect=1.2.1@conda-forge
  - utf8=1.2.6@conda-forge
  - vctrs=0.7.3@conda-forge
  - withr=3.0.3@conda-forge

r-package:

pip:
  - certifi==2026.7.22
  - charset-normalizer==3.5.1
  - idna==3.20
  - requests==2.34.2
  - urllib3==2.8.0

# r-package(unknown source):
#  - compiler=4.4.2
#  - datasets=4.4.2
#  - graphics=4.4.2
#  - grDevices=4.4.2
#  - grid=4.4.2
#  - methods=4.4.2
#  - parallel=4.4.2
#  - splines=4.4.2
#  - stats=4.4.2
#  - stats4=4.4.2
#  - tcltk=4.4.2
#  - tools=4.4.2
#  - utils=4.4.2
