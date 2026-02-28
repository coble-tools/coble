# COBLE:capture, (c) ICR 2026
# Capture date: 2026-02-28
# Capture time: 07:50:14 GMT
# Captured by: ralcraft

coble:

  - environment: ProvGigaPath

channels:
  - conda-forge
  - bioconda
  - defaults
  - pytorch

languages:
  - python=3.9.25@defaults
flags:
  - compile-tools: true
  - dependencies: false
  - priority: flexible
  - export: CUDA_HOME="/home/ralcraft/miniforge3/envs/ProvGigaPath"
  - export: PYTHONNOUSERSITE="1"
  - export: TORCH_CUDA_ARCH_LIST="8.0"

conda:
  - binutils_impl_linux-64=2.44@defaults
  - binutils_linux-64=2.44@defaults
  - gcc_impl_linux-64=15.2.0@defaults
  - gcc_linux-64=15.2.0@defaults
  - gxx_impl_linux-64=15.2.0@defaults
  - gxx_linux-64=15.2.0@defaults
  - icu=73.1@defaults

conda:
  - libcublas-dev=11.11.3.6@nvidia
  - libcublas=11.11.3.6@nvidia
  - libcufft-dev=10.9.0.58@nvidia
  - libcufft=10.9.0.58@nvidia
  - libcufile-dev=1.16.1.26@nvidia
  - libcufile=1.16.1.26@nvidia
  - libcurand-dev=10.4.1.81@nvidia
  - libcurand=10.4.1.81@nvidia
  - libcusolver-dev=11.4.1.48@nvidia
  - libcusolver=11.4.1.48@nvidia
  - libcusparse-dev=11.7.5.86@nvidia
  - libcusparse=11.7.5.86@nvidia

conda:
  - libgcc-devel_linux-64=15.2.0@defaults
  - libgcc-ng=15.2.0@defaults
  - libgcc=15.2.0@defaults
  - libstdcxx-devel_linux-64=15.2.0@defaults
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
  - cuda-cccl=13.1.115@nvidia
  - cuda-cccl_linux-64=13.1.115@nvidia
  - cuda-command-line-tools=11.8.0@nvidia
  - cuda-compiler=13.1.0@nvidia
  - cuda-crt-dev_linux-64=13.1.80@nvidia
  - cuda-crt-tools=13.1.80@nvidia
  - cuda-ctadvisor=13.1.80@nvidia
  - cuda-cudart-dev=11.8.89@nvidia
  - cuda-cudart-dev_linux-64=13.1.80@nvidia
  - cuda-cudart-static_linux-64=13.1.80@nvidia
  - cuda-cudart=11.8.89@nvidia
  - cuda-cudart_linux-64=13.1.80@nvidia
  - cuda-cuobjdump=13.1.80@nvidia
  - cuda-cupti=11.8.87@nvidia
  - cuda-cuxxfilt=13.1.80@nvidia
  - cuda-demo-suite=12.4.127@nvidia
  - cuda-documentation=12.4.127@nvidia
  - cuda-driver-dev=13.1.80@nvidia
  - cuda-driver-dev_linux-64=13.1.80@nvidia
  - cuda-gdb=13.1.115@nvidia
  - cuda-libraries-dev=12.6.2@nvidia
  - cuda-libraries=11.8.0@nvidia
  - cuda-memcheck=11.8.86@nvidia
  - cuda-nsight=13.1.115@nvidia
  - cuda-nvcc-dev_linux-64=13.1.80@nvidia
  - cuda-nvcc-impl=13.1.80@nvidia
  - cuda-nvcc-tools=13.1.80@nvidia
  - cuda-nvcc=13.1.80@nvidia
  - cuda-nvcc_linux-64=13.1.80@nvidia
  - cuda-nvdisasm=13.1.115@nvidia
  - cuda-nvml-dev=13.1.115@nvidia
  - cuda-nvprof=12.4.127@nvidia
  - cuda-nvprune=13.1.80@nvidia
  - cuda-nvrtc-dev=11.8.89@nvidia
  - cuda-nvrtc=11.8.89@nvidia
  - cuda-nvtx=11.8.86@nvidia
  - cuda-nvvm-dev_linux-64=13.1.80@nvidia
  - cuda-nvvm-impl=13.1.80@nvidia
  - cuda-nvvm-tools=13.1.80@nvidia
  - cuda-nvvp=12.4.127@nvidia
  - cuda-opencl-dev=13.1.115@nvidia
  - cuda-opencl=13.1.115@nvidia
  - cuda-profiler-api=13.1.115@nvidia
  - cuda-runtime=11.8.0@nvidia
  - cuda-sanitizer-api=13.1.118@nvidia
  - cuda-tileiras=13.1.80@nvidia
  - cuda-toolkit=11.8.0@nvidia
  - cuda-tools=11.8.0@nvidia
  - cuda-version=13.1@nvidia
  - cuda-visual-tools=12.6.2@nvidia
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
  - gds-tools=1.16.1.26@nvidia

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
  - kernel-headers_linux-64=4.18.0@defaults
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
  - libnvfatbin-dev=13.1.115@nvidia
  - libnvfatbin=13.1.115@nvidia
  - libnvjitlink-dev=13.1.115@nvidia
  - libnvjitlink=13.1.115@nvidia
  - libnvjpeg-dev=11.9.0.86@nvidia
  - libnvjpeg=11.9.0.86@nvidia
  - libnvptxcompiler-dev=13.1.80@nvidia
  - libnvptxcompiler-dev_linux-64=13.1.80@nvidia

conda:
  - libopenjpeg=2.5.4@defaults
  - libpng=1.6.54@defaults
  - libsanitizer=15.2.0@defaults
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
  - ocl-icd=2.3.3@defaults
  - opencl-headers=2025.07.22@defaults
  - openh264=2.1.1@defaults
  - openjpeg=2.5.4@defaults
  - openssl=3.5.5@defaults
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
  - sysroot_linux-64=2.28@defaults
  - tbb=2021.8.0@defaults
  - tk=8.6.15@defaults

conda:
  - torchaudio=2.0.0@pytorch
  - torchtriton=2.0.0@pytorch
  - torchvision=0.15.0@pytorch

conda:
  - typing_extensions=4.15.0@defaults
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
  - GitPython==3.1.46
  - ImageIO==2.37.2
  - Markdown==3.9
  - PyYAML==6.0.3
  - Werkzeug==3.1.6
  - absl-py==2.3.1
  - annotated-types==0.7.0
  - antlr4-python3-runtime==4.9.3
  - autograd-gamma==0.5.0
  - autograd==1.8.0
  - braceexpand==0.1.7
  - click==8.1.8
  - contourpy==1.3.0
  - cycler==0.12.1
  - ecos==2.0.14
  - einops==0.8.2
  - eval_type_backport==0.3.1
  - fairscale==0.4.13
  - flash-attn==2.5.8
  - fonttools==4.60.2
  - formulaic==1.2.1
  - fsspec==2025.10.0
  - fvcore==0.1.5.post20221221
  - git+https://github.com/rachelicr/prov-gigapath.git@19ee6896b2118c1c273f0df9587fd8fce43a458e#egg==
  - gitdb==4.0.12
  - grpcio==1.78.0
  - h5py==3.14.0
  - huggingface-hub==0.20.2
  - importlib_metadata==8.7.1
  - importlib_resources==6.5.2
  - interface-meta==1.3.0
  - iopath==0.1.10
  - joblib==1.5.3
  - kiwisolver==1.4.7
  - lazy_loader==0.4
  - lifelines==0.30.1
  - matplotlib==3.9.4
  - monai==1.3.1
  - mypy_extensions==1.1.0
  - narwhals==2.17.0
  - ninja==1.11.1.1
  - numexpr==2.10.2
  - numpy==1.26.4
  - omegaconf==2.3.0
  - openslide-bin==4.0.0.11
  - openslide-python==1.4.2
  - osqp==1.1.1
  - packaging==23.2
  - pandas==2.3.3
  - platformdirs==4.4.0
  - portalocker==3.2.0
  - protobuf==6.33.5
  - psutil==7.2.2
  - pydantic==2.12.5
  - pydantic_core==2.41.5
  - pyparsing==3.3.2
  - pyre-extensions==0.0.23
  - python-dateutil==2.9.0.post0
  - pytz==2025.2
  - regex==2026.1.15
  - safetensors==0.7.0
  - scikit-image==0.24.0
  - scikit-learn==1.5.2
  - scikit-survival==0.23.1
  - scipy==1.13.1
  - sentry-sdk==2.53.0
  - six==1.17.0
  - smmap==5.0.2
  - tabulate==0.9.0
  - tensorboard-data-server==0.7.2
  - tensorboard==2.20.0
  - termcolor==3.1.0
  - threadpoolctl==3.6.0
  - tifffile==2024.8.30
  - timm==1.0.25
  - tokenizers==0.15.2
  - torch==2.0.0
  - torchmetrics==0.10.3
  - tqdm==4.67.3
  - transformers==4.36.2
  - triton==2.0.0
  - typing-inspect==0.9.0
  - typing-inspection==0.4.2
  - tzdata==2025.3
  - wandb==0.25.0
  - webdataset==0.2.100
  - wrapt==2.1.1
  - xformers==0.0.18
  - yacs==0.1.8
  - zipp==3.23.0
