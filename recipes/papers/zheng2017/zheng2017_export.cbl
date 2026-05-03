# COBLE:export, (c) ICR 2026
# Capture date: 2026-05-03
# Capture time: 14:34:06 BST
# Captured by: ralcraft

coble:

  - environment: zheng2017

channels:
  - conda-forge
  - defaults
  - bioconda
  - https://software.repos.intel.com/python/conda/
  - https://repo.anaconda.com/pkgs/r
  - https://repo.anaconda.com/pkgs/free
  - https://repo.anaconda.com/pkgs/main

languages:
  - r-base=3.3.1@defaults
flags:
  - compile-tools: true
  - dependencies: false
  - priority: flexible
  - export: CXX1X="g++ -std=c++14"
  - export: FONTCONFIG_PATH="/home/ralcraft/miniforge3/envs/zheng2017/etc/fonts"
  - export: PKG_CFLAGS="-fcommon"

conda:
  - binutils_impl_linux-64=2.44@defaults
  - binutils_linux-64=2.44@defaults
  - gcc_impl_linux-64=15.2.0@defaults
  - gcc_linux-64=15.2.0@defaults
  - gxx_impl_linux-64=15.2.0@defaults
  - gxx_linux-64=15.2.0@defaults

conda:
  - icu=54.1@https://repo.anaconda.com/pkgs/free

conda:
  - libcurl=7.69.1@defaults

conda:
  - libgcc=15.2.0@conda-forge

conda:
  - libgcc-devel_linux-64=15.2.0@defaults

conda:
  - libgcc-ng=15.2.0@conda-forge
  - libstdcxx=15.2.0@conda-forge

conda:
  - libstdcxx-devel_linux-64=15.2.0@defaults

conda:
  - libstdcxx-ng=15.2.0@conda-forge

conda:
  - zlib=1.2.13@defaults
  - bzip2=1.0.8@defaults
  - ca-certificates=2026.3.19@defaults

conda:
  - cairo=1.14.8@https://repo.anaconda.com/pkgs/free

conda:
  - curl=7.69.1@defaults

conda:
  - fontconfig=2.12.1@https://repo.anaconda.com/pkgs/free

conda:
  - fonts-anaconda=1@defaults
  - font-ttf-dejavu-sans-mono=2.37@defaults
  - font-ttf-inconsolata=2.001@defaults
  - font-ttf-source-code-pro=2.030@defaults
  - font-ttf-ubuntu=0.83@defaults

conda:
  - freetype=2.5.5@https://repo.anaconda.com/pkgs/free
  - glib=2.50.2@https://repo.anaconda.com/pkgs/free

conda:
  - gsl=2.7.1@defaults

conda:
  - harfbuzz=0.9.39@https://repo.anaconda.com/pkgs/free

conda:
  - jpeg=9f@defaults
  - kernel-headers_linux-64=4.18.0@defaults

conda:
  - krb5=1.17.1@conda-forge

conda:
  - ld_impl_linux-64=2.44@defaults
  - lerc=4.1.0@defaults
  - libdeflate=1.22@defaults

conda:
  - libedit=3.1.20170329@conda-forge

conda:
  - libffi=3.4.8@defaults

conda:
  - libgfortran=3.0.0@https://repo.anaconda.com/pkgs/free

conda:
  - libgomp=15.2.0@conda-forge

conda:
  - libiconv=1.14@https://repo.anaconda.com/pkgs/free

conda:
  - libpng=1.6.54@defaults
  - libsanitizer=15.2.0@defaults
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
  - sysroot_linux-64=2.28@defaults
  - tk=8.6.15@defaults
  - tzdata=2026a@defaults
  - xorg-libx11=1.8.12@defaults
  - xorg-libxau=1.0.12@defaults
  - xorg-libxdmcp=1.1.5@defaults
  - xorg-xorgproto=2024.1@defaults
  - xz=5.2.10@defaults
  - zstd=1.5.5@defaults

r-conda:
  - plyr=1.8.4@defaults
  - rcpp=0.12.5@defaults

r-package:

# r-package(unknown source):
#  - compiler=3.3.1
#  - datasets=3.3.1
#  - graphics=3.3.1
#  - grDevices=3.3.1
#  - grid=3.3.1
#  - methods=3.3.1
#  - parallel=3.3.1
#  - splines=3.3.1
#  - stats=3.3.1
#  - stats4=3.3.1
#  - tcltk=3.3.1
#  - tools=3.3.1
#  - utils=3.3.1
