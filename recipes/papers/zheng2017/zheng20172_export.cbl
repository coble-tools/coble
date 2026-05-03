# COBLE:export, (c) ICR 2026
# Capture date: 2026-05-03
# Capture time: 09:56:50 BST
# Captured by: ralcraft

coble:

  - environment: zheng20172

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

conda:
  - binutils=2.36.1@conda-forge
  - binutils_impl_linux-64=2.36.1@conda-forge
  - binutils_linux-64=2.36@conda-forge
  - gcc_impl_linux-64=7.5.0@conda-forge
  - gcc_linux-64=7.5.0@conda-forge
  - gxx_impl_linux-64=7.5.0@conda-forge
  - gxx_linux-64=7.5.0@conda-forge

conda:
  - icu=54.1@https://repo.anaconda.com/pkgs/free

conda:
  - libcurl=8.16.0@defaults
  - libgcc=15.2.0@defaults

conda:
  - libgcc-devel_linux-64=14.3.0@conda-forge

conda:
  - libgcc-ng=15.2.0@defaults
  - libstdcxx=15.2.0@defaults

conda:
  - libstdcxx-devel_linux-64=14.3.0@conda-forge

conda:
  - libstdcxx-ng=15.2.0@defaults

conda:
  - libzlib=1.2.13@conda-forge
  - zlib=1.2.13@conda-forge

conda:
  - bzip2=1.0.8@defaults

conda:
  - ca-certificates=2026.4.22@conda-forge

conda:
  - cairo=1.14.8@https://repo.anaconda.com/pkgs/free

conda:
  - c-ares=1.34.6@defaults

conda:
  - c-compiler=1.1.2@conda-forge

conda:
  - curl=8.16.0@defaults

conda:
  - cxx-compiler=1.1.2@conda-forge

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

conda:
  - gfortran_impl_linux-64=7.5.0@conda-forge
  - gfortran_linux-64=7.5.0@conda-forge

conda:
  - glib=2.50.2@https://repo.anaconda.com/pkgs/free

conda:
  - gsl=2.7.1@defaults

conda:
  - harfbuzz=0.9.39@https://repo.anaconda.com/pkgs/free

conda:
  - jpeg=9f@defaults

conda:
  - kernel-headers_linux-64=6.12.0@conda-forge
  - ld_impl_linux-64=2.36.1@conda-forge

conda:
  - lerc=4.1.0@defaults
  - libdeflate=1.22@defaults
  - libev=4.33@defaults
  - libffi=3.4.8@defaults
  - libgfortran=15.2.0@defaults

conda:
  - libgfortran4=7.5.0@conda-forge

conda:
  - libgfortran5=15.2.0@defaults
  - libgomp=15.2.0@defaults

conda:
  - libiconv=1.14@https://repo.anaconda.com/pkgs/free

conda:
  - libidn2=2.3.4@defaults
  - libnghttp2=1.57.0@defaults
  - libpng=1.6.54@defaults

conda:
  - libsanitizer=14.3.0@conda-forge

conda:
  - libssh2=1.11.1@defaults
  - libtiff=4.5.1@defaults
  - libunistring=1.4.2@defaults
  - libxcb=1.17.0@defaults
  - libxml2=2.9.9@defaults
  - make=4.2.1@defaults

conda:
  - ncurses=5.9@https://repo.anaconda.com/pkgs/free

conda:
  - openssl=3.6.2@conda-forge

conda:
  - pango=1.40.3@https://repo.anaconda.com/pkgs/free
  - pcre=8.39@https://repo.anaconda.com/pkgs/free

conda:
  - pixman=0.34.0@defaults
  - pthread-stubs=0.3@defaults
  - readline=7.0@defaults

conda:
  - sysroot_linux-64=2.39@conda-forge

conda:
  - tk=8.6.15@defaults

conda:
  - tzdata=2025c@conda-forge

conda:
  - xorg-libx11=1.8.12@defaults
  - xorg-libxau=1.0.12@defaults
  - xorg-libxdmcp=1.1.5@defaults
  - xorg-xorgproto=2024.1@defaults
  - xz=5.2.10@defaults

conda:
  - zstd=1.5.6@conda-forge

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
