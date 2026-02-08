# COBLE:capture, (c) ICR 2026
# Capture date: 2026-02-08
# Capture time: 17:03:34 GMT
# Captured by: ralcraft

coble:

  - environment: empty

channels:
  - defaults
  - bioconda
  - conda-forge

languages:
  - python=3.12.12@conda-forge
flags:
  - compile-tools: true
  - dependencies: false
  - priority: flexible
  - export: PYTHONNOUSERSITE="1"

conda:
  - icu=78.2@conda-forge
  - libgcc-ng=15.2.0@conda-forge
  - libgcc=15.2.0@conda-forge
  - libstdcxx=15.2.0@conda-forge
  - libzlib=1.3.1@conda-forge
  - bzip2=1.0.8@conda-forge
  - ca-certificates=2026.1.4@conda-forge
  - ld_impl_linux-64=2.45.1@conda-forge
  - libexpat=2.7.3@conda-forge
  - libffi=3.5.2@conda-forge
  - libgomp=15.2.0@conda-forge
  - liblzma=5.8.2@conda-forge
  - libnsl=2.0.1@conda-forge
  - libsqlite=3.51.2@conda-forge
  - libuuid=2.41.3@conda-forge
  - libxcrypt=4.4.36@conda-forge
  - ncurses=6.5@conda-forge
  - openssl=3.6.1@conda-forge
  - packaging=26.0@conda-forge
  - pip=26.0.1@conda-forge
  - readline=8.3@conda-forge
  - setuptools=81.0.0@conda-forge
  - tk=8.6.13@conda-forge
  - tzdata=2025c@conda-forge
  - wheel=0.46.3@conda-forge
  - zstd=1.5.7@conda-forge
