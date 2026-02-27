# COBLE:capture, (c) ICR 2026
# Capture date: 2026-02-27
# Capture time: 09:10:41 GMT
# Captured by: rachel

coble:

  - environment: pgp

channels:
  - conda-forge
  - defaults
  - nvidia
  - pytorch

languages:
  - python=3.9.25@defaults
flags:
  - compile-tools: true
  - dependencies: false
  - priority: flexible
  - export: PYTHONNOUSERSITE="1"

conda:
  - icu=73.1@defaults

conda:
  - libcublas-dev=11.11.3.6@nvidia
  - libcublas=11.11.3.6@nvidia
  - libcufft-dev=10.9.0.58@nvidia
  - libcufft=10.9.0.58@nvidia
  - libcufile-dev=1.9.1.3@nvidia
  - libcufile=1.9.1.3@nvidia
  - libcurand-dev=10.3.5.147@nvidia
  - libcurand=10.3.5.147@nvidia
  - libcusolver-dev=11.4.1.48@nvidia
  - libcusolver=11.4.1.48@nvidia
  - libcusparse-dev=11.7.5.86@nvidia
  - libcusparse=11.7.5.86@nvidia

conda:
  - libgcc-ng=15.2.0@defaults
  - libgcc=15.2.0@defaults
  - libstdcxx-ng=15.2.0@defaults
  - libstdcxx=15.2.0@defaults
  - zlib=1.2.13@defaults
  - aom=3.12.1@defaults
  - blas=1.0@defaults
  - brotlicffi=1.0.9.2@defaults
  - bzip2=1.0.8@defaults
  - ca-certificates=2025.12.2@defaults
  - cairo=1.18.4@defaults
  - certifi=2025.10.5@defaults
  - cffi=2.0.0@defaults
  - charset-normalizer=3.4.4@defaults

conda:
  - cuda-cccl=12.4.127@nvidia
  - cuda-command-line-tools=11.8.0@nvidia
  - cuda-compiler=12.6.2@nvidia
  - cuda-cudart-dev=11.8.89@nvidia
  - cuda-cudart=11.8.89@nvidia
  - cuda-cuobjdump=12.4.127@nvidia
  - cuda-cupti=11.8.87@nvidia
  - cuda-cuxxfilt=12.4.127@nvidia
  - cuda-demo-suite=12.4.127@nvidia
  - cuda-documentation=12.4.127@nvidia
  - cuda-driver-dev=12.4.127@nvidia
  - cuda-gdb=12.4.127@nvidia
  - cuda-libraries-dev=12.6.0@nvidia
  - cuda-libraries=11.8.0@nvidia
  - cuda-memcheck=11.8.86@nvidia
  - cuda-nsight=12.4.127@nvidia
  - cuda-nvcc=12.4.131@nvidia
  - cuda-nvdisasm=12.4.127@nvidia
  - cuda-nvml-dev=12.4.127@nvidia
  - cuda-nvprof=12.4.127@nvidia
  - cuda-nvprune=12.4.127@nvidia
  - cuda-nvrtc-dev=11.8.89@nvidia
  - cuda-nvrtc=11.8.89@nvidia
  - cuda-nvtx=11.8.86@nvidia
  - cuda-nvvp=12.4.127@nvidia
  - cuda-opencl-dev=12.4.127@nvidia
  - cuda-opencl=12.4.127@nvidia
  - cuda-profiler-api=12.4.127@nvidia
  - cuda-runtime=11.8.0@nvidia
  - cuda-sanitizer-api=12.4.127@nvidia
  - cuda-toolkit=11.8.0@nvidia
  - cuda-tools=11.8.0@nvidia
  - cuda-visual-tools=12.6.0@nvidia
  - cuda=11.8.0@nvidia

conda:
  - dav1d=1.2.1@defaults
  - expat=2.7.4@defaults

conda:
  - ffmpeg=4.3@pytorch

conda:
  - filelock=3.17.0@defaults
  - fontconfig=2.15.0@defaults
  - freetype=2.14.1@defaults
  - fribidi=1.0.16@defaults

conda:
  - gds-tools=1.9.1.3@nvidia

conda:
  - gmp=6.3.0@defaults
  - gmpy2=2.2.1@defaults
  - gnutls=3.6.15@defaults
  - graphite2=1.3.14@defaults
  - harfbuzz=10.2.0@defaults
  - idna=3.11@defaults
  - intel-openmp=2023.1.0@defaults
  - jinja2=3.1.6@defaults
  - jpeg=9f@defaults
  - lame=3.100@defaults
  - lcms2=2.17@defaults
  - ld_impl_linux-64=2.44@defaults
  - lerc=4.0.0@defaults
  - libavif=1.3.0@defaults
  - libdeflate=1.22@defaults
  - libexpat=2.7.4@defaults
  - libffi=3.4.4@defaults
  - libglib=2.86.3@defaults
  - libgomp=15.2.0@defaults
  - libiconv=1.18@defaults
  - libidn2=2.3.4@defaults

conda:
  - libnpp-dev=11.8.0.86@nvidia
  - libnpp=11.8.0.86@nvidia

conda:
  - libnsl=2.0.0@defaults

conda:
  - libnvfatbin-dev=12.4.127@nvidia
  - libnvfatbin=12.4.127@nvidia
  - libnvjitlink-dev=12.4.127@nvidia
  - libnvjitlink=12.4.127@nvidia
  - libnvjpeg-dev=11.9.0.86@nvidia
  - libnvjpeg=11.9.0.86@nvidia

conda:
  - libopenjpeg=2.5.4@defaults
  - libpng=1.6.54@defaults
  - libtasn1=4.21.0@defaults
  - libtiff=4.7.1@defaults
  - libunistring=0.9.10@defaults
  - libuuid=1.41.5@defaults
  - libxcb=1.17.0@defaults
  - libxml2=2.13.9@defaults
  - lz4-c=1.9.4@defaults
  - markupsafe=3.0.2@defaults
  - mkl-service=2.4.0@defaults
  - mkl=2023.1.0@defaults
  - mkl_fft=1.3.11@defaults
  - mkl_random=1.2.8@defaults
  - mpc=1.3.1@defaults
  - mpfr=4.2.1@defaults
  - mpmath=1.3.0@defaults
  - ncurses=6.5@defaults
  - nettle=3.7.3@defaults
  - networkx=3.2.1@defaults

conda:
  - nsight-compute=2024.1.1.4@nvidia

conda:
  - numpy=2.0.1@defaults
  - openh264=2.1.1@defaults
  - openjpeg=2.5.4@defaults
  - openssl=3.0.19@defaults
  - packaging=25.0@defaults
  - pcre2=10.46@defaults
  - pillow=11.3.0@defaults
  - pip=26.0.1@defaults
  - pixman=0.46.4@defaults
  - pthread-stubs=0.3@defaults
  - pycparser=2.23@defaults
  - pysocks=1.7.1@defaults

conda:
  - pytorch-cuda=11.8@pytorch
  - pytorch-mutex=1.0@pytorch
  - pytorch=2.0.0@pytorch

conda:
  - readline=8.3@defaults
  - requests=2.32.5@defaults
  - setuptools=80.9.0@defaults
  - sqlite=3.51.1@defaults
  - sympy=1.14.0@defaults
  - tbb=2021.8.0@defaults
  - tk=8.6.15@defaults

conda:
  - torchaudio=2.0.0@pytorch
  - torchtriton=2.0.0@pytorch
  - torchvision=0.15.0@pytorch

conda:
  - typing_extensions=4.15.0@defaults
  - tzdata=2025c@defaults
  - urllib3=2.5.0@defaults
  - wheel=0.45.1@defaults
  - xorg-libx11=1.8.12@defaults
  - xorg-libxau=1.0.12@defaults
  - xorg-libxdmcp=1.1.5@defaults
  - xorg-libxext=1.3.6@defaults
  - xorg-libxrender=0.9.12@defaults
  - xorg-xorgproto=2024.1@defaults
  - xz=5.6.4@defaults
  - zstd=1.5.6@defaults

pip:
  - torch==2.0.0
  - triton==2.0.0
