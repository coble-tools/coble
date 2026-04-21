# COBLE:export, (c) ICR 2026
# Capture date: 2026-04-21
# Capture time: 13:19:23 BST
# Captured by: ralcraft

coble:

  - environment: monopogen

channels:
  - defaults
  - bioconda
  - conda-forge

languages:
  - r-base=4.2.3@conda-forge
  - python=3.8.20@conda-forge
flags:
  - compile-tools: true
  - dependencies: false
  - priority: flexible
  - export: PYTHONNOUSERSITE="1"

conda:
  - binutils_impl_linux-64=2.45.1@conda-forge
  - gcc_impl_linux-64=15.2.0@conda-forge
  - gxx_impl_linux-64=15.2.0@conda-forge
  - icu=75.1@conda-forge
  - libcblas=3.9.0@conda-forge
  - libcurl=8.19.0@conda-forge
  - libgcc-devel_linux-64=15.2.0@conda-forge
  - libgcc-ng=15.2.0@conda-forge
  - libgcc=15.2.0@conda-forge
  - libstdcxx-devel_linux-64=15.2.0@conda-forge
  - libstdcxx-ng=15.2.0@conda-forge
  - libstdcxx=15.2.0@conda-forge
  - libzlib=1.3.2@conda-forge
  - zlib=1.3.2@conda-forge

conda:
  - bcftools=1.23.1@bioconda

conda:
  - brotli-python=1.1.0@conda-forge
  - bwidget=1.10.1@conda-forge
  - bzip2=1.0.8@conda-forge
  - c-ares=1.34.6@conda-forge
  - ca-certificates=2026.2.25@conda-forge
  - cairo=1.18.4@conda-forge
  - certifi=2024.8.30@conda-forge
  - cffi=1.17.0@conda-forge
  - charset-normalizer=3.4.0@conda-forge
  - curl=8.19.0@conda-forge
  - font-ttf-dejavu-sans-mono=2.37@conda-forge
  - font-ttf-inconsolata=3.000@conda-forge
  - font-ttf-source-code-pro=2.038@conda-forge
  - font-ttf-ubuntu=0.83@conda-forge
  - fontconfig=2.17.1@conda-forge
  - fonts-conda-forge=1@conda-forge
  - freetype=2.14.3@conda-forge
  - fribidi=1.0.16@conda-forge
  - gfortran_impl_linux-64=15.2.0@conda-forge
  - graphite2=1.3.14@conda-forge
  - gsl=2.7@conda-forge
  - h2=4.1.0@conda-forge
  - harfbuzz=11.4.5@conda-forge
  - hpack=4.0.0@conda-forge

conda:
  - htslib=1.23.1@bioconda

conda:
  - hyperframe=6.0.1@conda-forge
  - idna=3.10@conda-forge
  - kernel-headers_linux-64=6.12.0@conda-forge
  - keyutils=1.6.3@conda-forge
  - krb5=1.22.2@conda-forge
  - lcms2=2.18@conda-forge
  - ld_impl_linux-64=2.45.1@conda-forge
  - lerc=4.1.0@conda-forge
  - libblas=3.9.0@conda-forge
  - libdeflate=1.25@conda-forge
  - libedit=3.1.20250104@conda-forge
  - libev=4.33@conda-forge
  - libexpat=2.7.5@conda-forge
  - libffi=3.4.6@conda-forge
  - libfreetype6=2.14.3@conda-forge
  - libfreetype=2.14.3@conda-forge
  - libgfortran-ng=15.2.0@conda-forge
  - libgfortran5=15.2.0@conda-forge
  - libgfortran=15.2.0@conda-forge
  - libglib=2.84.3@conda-forge
  - libgomp=15.2.0@conda-forge
  - libiconv=1.18@conda-forge
  - libjpeg-turbo=3.1.4.1@conda-forge
  - liblapack=3.9.0@conda-forge
  - liblzma-devel=5.8.3@conda-forge
  - liblzma=5.8.3@conda-forge
  - libnghttp2=1.68.1@conda-forge
  - libnsl=2.0.1@conda-forge
  - libopenblas=0.3.25@conda-forge
  - libpng=1.6.58@conda-forge
  - libsanitizer=15.2.0@conda-forge
  - libsqlite=3.53.0@conda-forge
  - libssh2=1.11.1@conda-forge
  - libtiff=4.7.1@conda-forge
  - libuuid=2.42@conda-forge
  - libxcb=1.17.0@conda-forge
  - libxcrypt=4.4.36@conda-forge
  - make=4.4.1@conda-forge
  - ncurses=6.5@conda-forge
  - numpy=1.24.4@conda-forge
  - openjpeg=2.5.4@conda-forge
  - openssl=3.6.2@conda-forge
  - packaging=26.1@conda-forge
  - pandas=2.0.3@conda-forge
  - pango=1.56.4@conda-forge
  - pcre2=10.45@conda-forge
  - perl=5.32.1@conda-forge
  - pillow=10.4.0@conda-forge
  - pip=24.3.1@conda-forge
  - pixman=0.46.4@conda-forge
  - platformdirs=4.3.6@conda-forge
  - pooch=1.8.2@conda-forge
  - pthread-stubs=0.4@conda-forge
  - pycparser=2.22@conda-forge

conda:
  - pysam=0.22.1@bioconda

conda:
  - pysocks=1.7.1@conda-forge
  - python-dateutil=2.9.0@conda-forge
  - python-tzdata=2024.2@conda-forge
  - python_abi=3.8@conda-forge
  - pytz=2024.2@conda-forge
  - readline=8.3@conda-forge
  - requests=2.32.3@conda-forge

conda:
  - samtools=1.23.1@bioconda

conda:
  - scipy=1.10.1@conda-forge
  - sed=4.9@conda-forge
  - setuptools=75.3.0@conda-forge
  - six=1.16.0@conda-forge
  - sysroot_linux-64=2.39@conda-forge
  - tk=8.6.13@conda-forge
  - tktable=2.10@conda-forge
  - tzdata=2025c@conda-forge
  - urllib3=2.2.3@conda-forge

conda:
  - vcftools=0.1.17@bioconda

conda:
  - wheel=0.45.1@conda-forge
  - xorg-libice=1.1.2@conda-forge
  - xorg-libsm=1.2.6@conda-forge
  - xorg-libx11=1.8.13@conda-forge
  - xorg-libxau=1.0.12@conda-forge
  - xorg-libxdmcp=1.1.5@conda-forge
  - xorg-libxext=1.3.7@conda-forge
  - xorg-libxrender=0.9.12@conda-forge
  - xorg-libxt=1.3.1@conda-forge
  - xz-gpl-tools=5.8.3@conda-forge
  - xz-tools=5.8.3@conda-forge
  - xz=5.8.3@conda-forge
  - zstandard=0.19.0@conda-forge
  - zstd=1.5.7@conda-forge

r-conda:
  - biocmanager=1.30.23@conda-forge
  - class=7.3_22@conda-forge
  - cli=3.6.3@conda-forge
  - colorspace=2.1_0@conda-forge
  - crayon=1.5.3@conda-forge
  - data.table=1.15.4@conda-forge
  - e1071=1.7_14@conda-forge
  - ellipsis=0.3.2@conda-forge
  - fansi=1.0.6@conda-forge
  - farver=2.1.2@conda-forge
  - ggplot2=3.5.1@conda-forge
  - glue=1.7.0@conda-forge
  - gtable=0.3.5@conda-forge
  - isoband=0.2.7@conda-forge
  - labeling=0.4.3@conda-forge
  - lattice=0.22_6@conda-forge
  - lifecycle=1.0.4@conda-forge
  - magrittr=2.0.3@conda-forge
  - mass=7.3_60.0.1@conda-forge
  - matrix=1.6_5@conda-forge
  - mgcv=1.9_1@conda-forge
  - munsell=0.5.1@conda-forge
  - nlme=3.1_165@conda-forge
  - pillar=1.9.0@conda-forge
  - pkgconfig=2.0.3@conda-forge
  - proxy=0.4_27@conda-forge
  - r6=2.5.1@conda-forge
  - rcolorbrewer=1.1_3@conda-forge
  - remotes=2.5.0@conda-forge
  - renv=1.0.7@conda-forge
  - rlang=1.1.4@conda-forge
  - scales=1.3.0@conda-forge
  - tibble=3.2.1@conda-forge
  - utf8=1.2.4@conda-forge
  - vctrs=0.6.5@conda-forge
  - viridislite=0.4.2@conda-forge
  - withr=3.0.0@conda-forge

r-package:

pip:
  - git+https://github.com/KChen-lab/Monopogen.git@2c0a4b0868cb86a77f196cba29b4d4dd3ce482f6@git+https://github.com/KChen-lab/Monopogen.git@2c0a4b0868cb86a77f196cba29b4d4dd3ce482f6

# r-package(unknown source):
#  - compiler=4.2.3
#  - datasets=4.2.3
#  - grDevices=4.2.3
#  - graphics=4.2.3
#  - grid=4.2.3
#  - methods=4.2.3
#  - parallel=4.2.3
#  - splines=4.2.3
#  - stats4=4.2.3
#  - stats=4.2.3
#  - tcltk=4.2.3
#  - tools=4.2.3
#  - utils=4.2.3
