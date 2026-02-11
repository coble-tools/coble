# COBLE:capture, (c) ICR 2026
# Capture date: 2026-02-11
# Capture time: 15:01:44 GMT
# Captured by: ralcraft

coble:

  - environment: r-360

channels:
  - r
  - defaults
  - bioconda
  - conda-forge

languages:
flags:
  - compile-tools: true
  - dependencies: false
  - priority: flexible

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
  - libgcc-devel_linux-64=13.1.0@conda-forge
  - libgcc-ng=15.2.0@conda-forge
  - libgcc=15.2.0@conda-forge
  - libstdcxx-devel_linux-64=13.1.0@conda-forge
  - libstdcxx-ng=15.2.0@conda-forge
  - libstdcxx=15.2.0@conda-forge
  - c-compiler=1.10.0@conda-forge
  - cxx-compiler=1.10.0@conda-forge
  - gfortran_impl_linux-64=13.1.0@conda-forge
  - gfortran_linux-64=13.1.0@conda-forge
  - kernel-headers_linux-64=6.12.0@conda-forge
  - ld_impl_linux-64=2.40@conda-forge
  - libgfortran5=15.2.0@conda-forge
  - libgomp=15.2.0@conda-forge
  - libsanitizer=13.1.0@conda-forge
  - sysroot_linux-64=2.39@conda-forge
  - tzdata=2025c@conda-forge

r-package:
