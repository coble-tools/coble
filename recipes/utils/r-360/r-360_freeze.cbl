# COBLE:capture, (c) ICR 2026
# Capture date: 2026-02-08
# Capture time: 18:42:49 GMT
# Captured by: ralcraft

coble:

  - environment: r-360

channels:
  - r
  - defaults
  - bioconda
  - conda-forge

languages:
  - r-base=3.6.0@r
flags:
  - compile-tools: true
  - dependencies: false
  - priority: flexible
  - export: LD_LIBRARY_PATH="/home/ralcraft/miniforge3/envs/r-360/lib:"

conda:
  - binutils=2.35.1@defaults
  - binutils_impl_linux-64=2.35.1@defaults
  - binutils_linux-64=2.35.1@defaults
  - gcc_impl_linux-64=7.5.0@defaults
  - gcc_linux-64=7.5.0@defaults
  - gxx_impl_linux-64=7.5.0@defaults
  - gxx_linux-64=7.5.0@defaults
  - icu=58.2@defaults
  - libcurl=7.67.0@defaults
  - libgcc-devel_linux-64=7.5.0@defaults
  - libgcc-ng=15.2.0@defaults
  - libgcc=15.2.0@defaults
  - libstdcxx-devel_linux-64=7.5.0@defaults
  - libstdcxx-ng=15.2.0@defaults
  - libstdcxx=15.2.0@defaults
  - zlib=1.2.13@defaults
  - bwidget=1.10.1@defaults
  - bzip2=1.0.8@defaults

conda:
  - c-compiler=1.1.2@conda-forge
  - ca-certificates=2026.1.4@conda-forge

conda:
  - cairo=1.14.12@defaults
  - curl=7.67.0@defaults

conda:
  - cxx-compiler=1.1.2@conda-forge

conda:
  - expat=2.7.4@defaults
  - fontconfig=2.14.1@defaults

conda:
  - fortran-compiler=1.1.2@conda-forge

conda:
  - freetype=2.14.1@defaults
  - fribidi=1.0.16@defaults
  - gfortran_impl_linux-64=7.5.0@defaults
  - gfortran_linux-64=7.5.0@defaults
  - glib=2.56.2@defaults
  - graphite2=1.3.14@defaults
  - harfbuzz=1.8.8@defaults
  - jpeg=9f@defaults
  - kernel-headers_linux-64=4.18.0@defaults
  - krb5=1.16.4@defaults
  - ld_impl_linux-64=2.35.1@defaults
  - lerc=4.0.0@defaults

conda:
  - libblas=3.9.0@conda-forge

conda:
  - libdeflate=1.22@defaults
  - libedit=3.1.20230828@defaults
  - libexpat=2.7.4@defaults
  - libffi=3.2.1@defaults
  - libgfortran-ng=7.5.0@defaults
  - libgfortran4=7.5.0@defaults

conda:
  - libgfortran5=15.2.0@conda-forge

conda:
  - libgomp=15.2.0@defaults

conda:
  - liblapack=3.9.0@conda-forge
  - libopenblas=0.3.28@conda-forge

conda:
  - libpng=1.6.54@defaults
  - libssh2=1.10.0@defaults
  - libtiff=4.7.1@defaults
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
  - assertthat=0.2.1@conda-forge
  - backports=1.2.1@conda-forge

r-conda:
  - biocmanager=1.30.4@defaults

r-conda:
  - brio=1.1.2@conda-forge
  - callr=3.7.0@conda-forge
  - cli=2.5.0@conda-forge
  - colorspace=2.0_1@conda-forge
  - crayon=1.4.1@conda-forge
  - desc=1.3.0@conda-forge
  - diffobj=0.3.4@conda-forge
  - digest=0.6.27@conda-forge
  - ellipsis=0.3.2@conda-forge
  - evaluate=0.14@conda-forge
  - fansi=0.4.2@conda-forge
  - farver=2.1.0@conda-forge
  - ggplot2=3.3.3@conda-forge
  - glue=1.4.2@conda-forge
  - gtable=0.3.0@conda-forge
  - isoband=0.2.4@conda-forge
  - jsonlite=1.7.2@conda-forge
  - labeling=0.4.2@conda-forge
  - lattice=0.20_44@conda-forge
  - lifecycle=1.0.0@conda-forge
  - magrittr=2.0.1@conda-forge
  - mass=7.3_54@conda-forge
  - matrix=1.3_3@conda-forge
  - mgcv=1.8_35@conda-forge
  - munsell=0.5.0@conda-forge
  - nlme=3.1_152@conda-forge
  - pillar=1.6.1@conda-forge
  - pkgconfig=2.0.3@conda-forge
  - pkgload=1.2.1@conda-forge
  - praise=1.0.0@conda-forge
  - processx=3.5.2@conda-forge
  - ps=1.6.0@conda-forge
  - r6=2.5.0@conda-forge
  - rcolorbrewer=1.1_2@conda-forge
  - rcpp=1.0.6@conda-forge
  - rematch2=2.1.2@conda-forge

r-conda:
  - remotes=2.0.4@defaults

r-conda:
  - rlang=0.4.11@conda-forge
  - rprojroot=2.0.2@conda-forge
  - rstudioapi=0.13@conda-forge
  - scales=1.1.1@conda-forge
  - testthat=3.0.2@conda-forge
  - tibble=3.1.2@conda-forge
  - utf8=1.2.1@conda-forge
  - vctrs=0.3.8@conda-forge
  - viridislite=0.4.0@conda-forge
  - waldo=0.2.5@conda-forge
  - withr=2.4.2@conda-forge

r-package:

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
