# COBLE:capture, (c) ICR 2026
# Capture date: 2026-01-12
# Capture time: 11:05:08 GMT
# Captured by: ralcraft

coble:

  - environment: small

channels:
  - https://repo.anaconda.com/pkgs/r
  - https://repo.anaconda.com/pkgs/main
  - defaults
  - r
  - bioconda
  - conda-forge

flags:
  - dependencies: false
  - priority: flexible

languages:
  - r-base=4.3.1@conda-forge
  - python=3.13.1@conda-forge
flags:
  - export CFLAGS="-I/home/ralcraft/.conda/envs/small/include"
  - export CXXFLAGS="-I/home/ralcraft/.conda/envs/small/include"
  - export CPPFLAGS="-I/home/ralcraft/.conda/envs/small/include"
  - export LDFLAGS="-L/home/ralcraft/.conda/envs/small/lib -Wl,-rpath,/home/ralcraft/.conda/envs/small/lib"

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
  - icu=73.2@conda-forge
  - libcblas=3.11.0@conda-forge
  - libcurl=8.18.0@conda-forge
  - libgcc-devel_linux-64=13.1.0@conda-forge
  - libgcc-ng=15.2.0@conda-forge
  - libgcc=15.2.0@conda-forge
  - libstdcxx-devel_linux-64=13.1.0@conda-forge
  - libstdcxx-ng=15.2.0@conda-forge
  - libstdcxx=15.2.0@conda-forge
  - libzlib=1.3.1@conda-forge
  - zlib=1.3.1@conda-forge
  - bwidget=1.10.1@conda-forge
  - bzip2=1.0.8@conda-forge
  - c-ares=1.34.6@conda-forge
  - c-compiler=1.10.0@conda-forge
  - ca-certificates=2026.1.4@conda-forge
  - cairo=1.18.0@conda-forge
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
  - gettext-tools=0.25.1@conda-forge
  - gettext=0.25.1@conda-forge
  - gfortran_impl_linux-64=13.1.0@conda-forge
  - gfortran_linux-64=13.1.0@conda-forge
  - graphite2=1.3.14@conda-forge
  - harfbuzz=8.3.0@conda-forge
  - kernel-headers_linux-64=6.12.0@conda-forge
  - keyutils=1.6.3@conda-forge
  - krb5=1.21.3@conda-forge
  - ld_impl_linux-64=2.40@conda-forge
  - lerc=4.0.0@conda-forge
  - libasprintf-devel=0.25.1@conda-forge
  - libasprintf=0.25.1@conda-forge
  - libblas=3.11.0@conda-forge
  - libdeflate=1.25@conda-forge
  - libedit=3.1.20250104@conda-forge
  - libev=4.33@conda-forge
  - libexpat=2.7.3@conda-forge
  - libffi=3.5.2@conda-forge
  - libfreetype6=2.14.1@conda-forge
  - libfreetype=2.14.1@conda-forge
  - libgettextpo-devel=0.25.1@conda-forge
  - libgettextpo=0.25.1@conda-forge
  - libgfortran-ng=15.2.0@conda-forge
  - libgfortran5=15.2.0@conda-forge
  - libgfortran=15.2.0@conda-forge
  - libglib=2.78.1@conda-forge
  - libgomp=15.2.0@conda-forge
  - libiconv=1.18@conda-forge
  - libjpeg-turbo=3.1.2@conda-forge
  - liblapack=3.11.0@conda-forge
  - liblzma-devel=5.8.1@conda-forge
  - liblzma=5.8.1@conda-forge
  - libmpdec=4.0.0@conda-forge
  - libnghttp2=1.67.0@conda-forge
  - libopenblas=0.3.30@conda-forge
  - libpng=1.6.53@conda-forge
  - libsanitizer=13.1.0@conda-forge
  - libsqlite=3.51.2@conda-forge
  - libssh2=1.11.1@conda-forge
  - libtiff=4.7.1@conda-forge
  - libuuid=2.41.3@conda-forge
  - libxcb=1.15@conda-forge
  - make=4.4.1@conda-forge
  - ncurses=6.5@conda-forge
  - numpy=2.4.1@conda-forge
  - openssl=3.6.0@conda-forge
  - pandas=2.3.3@conda-forge
  - pango=1.50.14@conda-forge
  - pcre2=10.40@conda-forge
  - pip=25.3@conda-forge
  - pixman=0.46.4@conda-forge
  - pthread-stubs=0.4@conda-forge
  - python-dateutil=2.9.0.post0@conda-forge
  - python-tzdata=2025.3@conda-forge
  - python_abi=3.13@conda-forge
  - pytz=2025.2@conda-forge
  - readline=8.3@conda-forge
  - sed=4.9@conda-forge
  - six=1.17.0@conda-forge
  - sysroot_linux-64=2.39@conda-forge
  - tk=8.6.13@conda-forge
  - tktable=2.10@conda-forge
  - tzdata=2025c@conda-forge
  - xorg-kbproto=1.0.7@conda-forge
  - xorg-libice=1.1.2@conda-forge
  - xorg-libsm=1.2.6@conda-forge
  - xorg-libx11=1.8.9@conda-forge
  - xorg-libxau=1.0.12@conda-forge
  - xorg-libxdmcp=1.1.5@conda-forge
  - xorg-libxext=1.3.4@conda-forge
  - xorg-libxrender=0.9.11@conda-forge
  - xorg-libxt=1.3.0@conda-forge
  - xorg-renderproto=0.11.1@conda-forge
  - xorg-xextproto=7.3.0@conda-forge
  - xorg-xproto=7.0.31@conda-forge
  - xz-gpl-tools=5.8.1@conda-forge
  - xz-tools=5.8.1@conda-forge
  - xz=5.8.1@conda-forge
  - zstd=1.5.7@conda-forge

r-conda:
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
  - rlang=1.1.6@conda-forge
  - scales=1.4.0@conda-forge
  - tibble=3.3.0@conda-forge
  - utf8=1.2.6@conda-forge
  - vctrs=0.6.5@conda-forge
  - viridislite=0.4.2@conda-forge
  - withr=3.0.2@conda-forge

r-package:
  - MASS=7.3-60.0.1
  - Matrix=1.6-5
  - RColorBrewer=1.1-3

# r-package(unknown source):
#  - compiler=4.3.1
#  - datasets=4.3.1
#  - grDevices=4.3.1
#  - graphics=4.3.1
#  - grid=4.3.1
#  - methods=4.3.1
#  - parallel=4.3.1
#  - splines=4.3.1
#  - stats4=4.3.1
#  - stats=4.3.1
#  - tcltk=4.3.1
#  - tools=4.3.1
#  - utils=4.3.1
