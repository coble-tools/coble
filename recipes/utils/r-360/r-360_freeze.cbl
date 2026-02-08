# COBLE:capture, (c) ICR 2026
# Capture date: 2026-02-08
# Capture time: 22:26:45 GMT
# Captured by: ralcraft

coble:

  - environment: r-360

channels:
  - defaults
  - r
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
  - binutils_impl_linux-64=2.36.1@conda-forge
  - binutils_linux-64=2.36@conda-forge
  - gcc_impl_linux-64=7.5.0@conda-forge
  - gcc_linux-64=7.5.0@conda-forge
  - gxx_impl_linux-64=7.5.0@conda-forge
  - gxx_linux-64=7.5.0@conda-forge
  - icu=58.2@conda-forge
  - libcurl=7.68.0@conda-forge
  - libgcc-ng=15.2.0@conda-forge
  - libgcc=15.2.0@conda-forge
  - libstdcxx-ng=15.2.0@conda-forge
  - libstdcxx=15.2.0@conda-forge
  - libzlib=1.2.13@conda-forge
  - zlib=1.2.13@conda-forge
  - bwidget=1.10.1@conda-forge
  - bzip2=1.0.8@conda-forge
  - ca-certificates=2026.1.4@conda-forge

conda:
  - cairo=1.14.12@defaults

conda:
  - curl=7.68.0@conda-forge

conda:
  - fontconfig=2.13.0@defaults

conda:
  - freetype=2.12.1@conda-forge
  - fribidi=1.0.16@conda-forge
  - gettext-tools=0.25.1@conda-forge
  - gettext=0.25.1@conda-forge
  - gfortran_impl_linux-64=7.5.0@conda-forge
  - gfortran_linux-64=7.5.0@conda-forge
  - glib=2.56.2@conda-forge
  - graphite2=1.3.14@conda-forge
  - harfbuzz=1.9.0@conda-forge
  - jpeg=9e@conda-forge
  - kernel-headers_linux-64=6.12.0@conda-forge
  - krb5=1.16.4@conda-forge
  - ld_impl_linux-64=2.36.1@conda-forge
  - libasprintf-devel=0.25.1@conda-forge
  - libasprintf=0.25.1@conda-forge
  - libedit=3.1.20250104@conda-forge
  - libffi=3.2.1@conda-forge
  - libgettextpo-devel=0.25.1@conda-forge
  - libgettextpo=0.25.1@conda-forge
  - libgfortran-ng=7.5.0@conda-forge
  - libgfortran4=7.5.0@conda-forge
  - libgomp=15.2.0@conda-forge
  - libiconv=1.18@conda-forge
  - liblzma-devel=5.8.2@conda-forge
  - liblzma=5.8.2@conda-forge
  - libpng=1.6.43@conda-forge
  - libssh2=1.10.0@conda-forge
  - libtiff=4.2.0@conda-forge

conda:
  - libuuid=1.41.5@defaults

conda:
  - libxcb=1.17.0@conda-forge
  - libxml2=2.9.9@conda-forge
  - make=4.4.1@conda-forge
  - ncurses=6.5@conda-forge
  - openssl=1.1.1w@conda-forge

conda:
  - pango=1.42.4@defaults

conda:
  - pcre=8.45@conda-forge
  - pixman=0.46.4@conda-forge
  - pthread-stubs=0.4@conda-forge
  - readline=7.0@conda-forge
  - sysroot_linux-64=2.39@conda-forge
  - tk=8.6.13@conda-forge
  - tktable=2.10@conda-forge
  - tzdata=2025c@conda-forge
  - xorg-libxau=1.0.12@conda-forge
  - xorg-libxdmcp=1.1.5@conda-forge
  - xz-gpl-tools=5.8.2@conda-forge
  - xz-tools=5.8.2@conda-forge
  - xz=5.8.2@conda-forge
  - zstd=1.5.6@conda-forge

r-conda:
  - biocmanager=1.30.4@r
  - remotes=2.0.4@r

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
