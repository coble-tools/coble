# COBLE:capture, (c) ICR 2026
# Capture date: 2026-01-23
# Capture time: 12:50:11 GMT
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
  - export: CC="/home/ralcraft/miniforge3/bin/gcc"
  - export: CFLAGS="-I/home/ralcraft/miniforge3/envs/small/include"
  - export: CPPFLAGS="-I/home/ralcraft/miniforge3/envs/small/include"
  - export: CXX="/home/ralcraft/miniforge3/bin/g++"
  - export: CXXFLAGS="-I/home/ralcraft/miniforge3/envs/small/include"
  - export: F77="/home/ralcraft/miniforge3/bin/x86_64-conda-linux-gnu-gfortran"
  - export: FC="/home/ralcraft/miniforge3/bin/x86_64-conda-linux-gnu-gfortran"
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
  - make=4.4.1@conda-forge
  - ncurses=6.5@conda-forge
  - numpy=2.4.1@conda-forge
  - openssl=3.6.0@conda-forge
  - pandas=3.0.0@conda-forge
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
  - cli=3.6.5@conda-forge
  - colorspace=2.1_2@conda-forge
  - cpp11=0.5.3@conda-forge
  - farver=2.1.2@conda-forge
  - ggplot2=4.0.1@conda-forge
  - glue=1.8.0@conda-forge
  - gtable=0.3.6@conda-forge
  - isoband=0.3.0@conda-forge
  - labeling=0.4.3@conda-forge
  - lifecycle=1.0.5@conda-forge
  - munsell=0.5.1@conda-forge
  - r6=2.6.1@conda-forge
  - rcolorbrewer=1.1_3@conda-forge
  - rlang=1.1.7@conda-forge
  - s7=0.2.1@conda-forge
  - scales=1.4.0@conda-forge
  - vctrs=0.6.5@conda-forge
  - viridislite=0.4.2@conda-forge
  - withr=3.0.2@conda-forge

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
