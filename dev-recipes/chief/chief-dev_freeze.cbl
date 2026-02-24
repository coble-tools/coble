# COBLE:capture, (c) ICR 2026
# Capture date: 2026-02-24
# Capture time: 11:39:23 GMT
# Captured by: ralcraft

coble:

  - environment: CHIEF-DEV

channels:
  - defaults
  - bioconda
  - conda-forge

languages:
  - python=3.10.19@conda-forge
flags:
  - compile-tools: true
  - dependencies: false
  - priority: flexible
  - export: LD_LIBRARY_PATH="/home/ralcraft/DEV/gh-rse/BCRDS/coble/CHIEF-DEV/lib:/home/ralcraft/miniforge3/envs/pytest/lib:"
  - export: PYTHONNOUSERSITE="1"

conda:
  - icu=78.2@conda-forge
  - libcblas=3.11.0@conda-forge
  - libgcc-ng=15.2.0@conda-forge
  - libgcc=15.2.0@conda-forge
  - libstdcxx-ng=15.2.0@conda-forge
  - libstdcxx=15.2.0@conda-forge
  - libzlib=1.3.1@conda-forge
  - zlib-ng=2.3.3@conda-forge
  - asttokens=3.0.1@conda-forge
  - backports.zstd=1.3.0@conda-forge
  - brotli-python=1.2.0@conda-forge
  - bzip2=1.0.8@conda-forge
  - ca-certificates=2026.1.4@conda-forge
  - certifi=2026.1.4@conda-forge
  - charset-normalizer=3.4.4@conda-forge
  - comm=0.2.3@conda-forge
  - debugpy=1.8.20@conda-forge
  - decorator=5.2.1@conda-forge
  - exceptiongroup=1.3.1@conda-forge
  - executing=2.2.1@conda-forge
  - h2=4.3.0@conda-forge
  - hpack=4.1.0@conda-forge
  - hyperframe=6.1.0@conda-forge
  - idna=3.11@conda-forge
  - ipykernel=7.2.0@conda-forge
  - ipython=8.37.0@conda-forge
  - jedi=0.19.2@conda-forge
  - joblib=1.5.3@conda-forge
  - jupyter_client=8.8.0@conda-forge
  - jupyter_core=5.9.1@conda-forge
  - keyutils=1.6.3@conda-forge
  - krb5=1.21.3@conda-forge
  - lcms2=2.18@conda-forge
  - ld_impl_linux-64=2.45.1@conda-forge
  - lerc=4.0.0@conda-forge
  - libblas=3.11.0@conda-forge
  - libdeflate=1.25@conda-forge
  - libedit=3.1.20250104@conda-forge
  - libexpat=2.7.4@conda-forge
  - libffi=3.5.2@conda-forge
  - libfreetype6=2.14.1@conda-forge
  - libfreetype=2.14.1@conda-forge
  - libgfortran5=15.2.0@conda-forge
  - libgfortran=15.2.0@conda-forge
  - libgomp=15.2.0@conda-forge
  - libjpeg-turbo=3.1.2@conda-forge
  - liblapack=3.11.0@conda-forge
  - liblzma=5.8.2@conda-forge
  - libnsl=2.0.1@conda-forge
  - libopenblas=0.3.30@conda-forge
  - libpng=1.6.55@conda-forge
  - libsodium=1.0.20@conda-forge
  - libsqlite=3.51.2@conda-forge
  - libtiff=4.7.1@conda-forge
  - libuuid=2.41.3@conda-forge
  - libxcb=1.17.0@conda-forge
  - libxcrypt=4.4.36@conda-forge
  - matplotlib-inline=0.2.1@conda-forge
  - ncurses=6.5@conda-forge
  - nest-asyncio=1.6.0@conda-forge
  - numpy=2.2.6@conda-forge
  - openjpeg=2.5.4@conda-forge
  - openssl=3.6.1@conda-forge
  - packaging=26.0@conda-forge
  - pandas=2.3.3@conda-forge
  - parso=0.8.6@conda-forge
  - pexpect=4.9.0@conda-forge
  - pickleshare=0.7.5@conda-forge
  - pillow=12.1.1@conda-forge
  - pip=26.0.1@conda-forge
  - platformdirs=4.9.2@conda-forge
  - prompt-toolkit=3.0.52@conda-forge
  - psutil=7.2.2@conda-forge
  - pthread-stubs=0.4@conda-forge
  - ptyprocess=0.7.0@conda-forge
  - pure_eval=0.2.3@conda-forge
  - pygments=2.19.2@conda-forge
  - pysocks=1.7.1@conda-forge
  - python-dateutil=2.9.0.post0@conda-forge
  - python-tzdata=2025.3@conda-forge
  - python_abi=3.10@conda-forge
  - pytz=2025.2@conda-forge
  - pyyaml=6.0.3@conda-forge
  - pyzmq=27.1.0@conda-forge
  - readline=8.3@conda-forge
  - requests=2.32.5@conda-forge
  - scikit-learn=1.7.2@conda-forge
  - scipy=1.15.2@conda-forge
  - setuptools=82.0.0@conda-forge
  - six=1.17.0@conda-forge
  - stack_data=0.6.3@conda-forge
  - threadpoolctl=3.6.0@conda-forge
  - tk=8.6.13@conda-forge
  - tornado=6.5.4@conda-forge
  - traitlets=5.14.3@conda-forge
  - typing_extensions=4.15.0@conda-forge
  - tzdata=2025c@conda-forge
  - urllib3=2.6.3@conda-forge
  - wcwidth=0.6.0@conda-forge
  - wheel=0.46.3@conda-forge
  - xorg-libxau=1.0.12@conda-forge
  - xorg-libxdmcp=1.1.5@conda-forge
  - yaml=0.2.5@conda-forge
  - zeromq=4.3.5@conda-forge
  - zstd=1.5.7@conda-forge

pip:
  - Jinja2==3.1.6
  - MarkupSafe==3.0.3
  - addict==2.4.0
  - cuda-bindings==12.9.4
  - cuda-pathfinder==1.3.5
  - filelock==3.24.3
  - fsspec==2026.2.0
  - mpmath==1.3.0
  - networkx==3.4.2
  - nvidia-cublas-cu12==12.8.4.1
  - nvidia-cuda-cupti-cu12==12.8.90
  - nvidia-cuda-nvrtc-cu12==12.8.93
  - nvidia-cuda-runtime-cu12==12.8.90
  - nvidia-cudnn-cu12==9.10.2.21
  - nvidia-cufft-cu12==11.3.3.83
  - nvidia-cufile-cu12==1.13.1.3
  - nvidia-curand-cu12==10.3.9.90
  - nvidia-cusolver-cu12==11.7.3.90
  - nvidia-cusparse-cu12==12.5.8.93
  - nvidia-cusparselt-cu12==0.7.1
  - nvidia-nccl-cu12==2.27.5
  - nvidia-nvjitlink-cu12==12.8.93
  - nvidia-nvshmem-cu12==3.4.5
  - nvidia-nvtx-cu12==12.8.90
  - sympy==1.14.0
  - torch==2.10.0
  - torchvision==0.25.0
  - triton==3.6.0
