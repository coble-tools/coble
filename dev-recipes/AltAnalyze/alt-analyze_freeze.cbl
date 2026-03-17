# COBLE:capture, (c) ICR 2026
# Capture date: 2026-03-16
# Capture time: 09:41:44 GMT
# Captured by: ralcraft

coble:

  - environment: alt-analyze

channels:
  - defaults
  - bioconda
  - conda-forge

languages:
  - python=2.7.15@conda-forge
flags:
  - compile-tools: true
  - dependencies: false
  - priority: flexible
  - export: PYTHONNOUSERSITE="1"

conda:
  - icu=64.2@conda-forge
  - libcblas=3.9.0@conda-forge
  - libclang=9.0.1@conda-forge
  - libcurl=7.87.0@conda-forge
  - libgcc-ng=15.2.0@conda-forge
  - libgcc=15.2.0@conda-forge
  - libstdcxx-ng=15.2.0@conda-forge
  - libstdcxx=15.2.0@conda-forge
  - libzlib=1.2.13@conda-forge
  - zlib=1.2.13@conda-forge
  - backports.functools_lru_cache=1.6.1@conda-forge
  - backports=1.0@conda-forge
  - backports_abc=0.5@conda-forge
  - blas=1.1@conda-forge
  - bzip2=1.0.8@conda-forge
  - c-ares=1.34.6@conda-forge
  - ca-certificates=2026.2.25@conda-forge
  - certifi=2019.11.28@conda-forge
  - cycler=0.10.0@conda-forge
  - dbus=1.13.6@conda-forge
  - decorator=4.4.2@conda-forge
  - enum34=1.1.10@conda-forge
  - expat=2.7.4@conda-forge
  - fastcluster=1.1.26@conda-forge
  - fontconfig=2.14.2@conda-forge
  - freetype=2.12.1@conda-forge
  - funcsigs=1.0.2@conda-forge
  - functools32=3.2.3.2@conda-forge
  - futures=3.3.0@conda-forge
  - gettext-tools=0.25.1@conda-forge
  - gettext=0.25.1@conda-forge
  - glib=2.66.3@conda-forge
  - gstreamer=1.14.5@conda-forge
  - jpeg=9e@conda-forge
  - keyutils=1.6.3@conda-forge
  - kiwisolver=1.1.0@conda-forge
  - krb5=1.20.1@conda-forge
  - ld_impl_linux-64=2.45.1@conda-forge
  - libasprintf-devel=0.25.1@conda-forge
  - libasprintf=0.25.1@conda-forge
  - libblas=3.9.0@conda-forge
  - libdeflate=1.25@conda-forge
  - libedit=3.1.20250104@conda-forge
  - libev=4.33@conda-forge
  - libexpat=2.7.4@conda-forge
  - libffi=3.2.1@conda-forge
  - libgettextpo-devel=0.25.1@conda-forge
  - libgettextpo=0.25.1@conda-forge
  - libgfortran-ng=7.5.0@conda-forge
  - libgfortran4=7.5.0@conda-forge
  - libgfortran5=15.2.0@conda-forge
  - libglib=2.66.3@conda-forge
  - libgomp=15.2.0@conda-forge
  - libiconv=1.18@conda-forge
  - liblapack=3.9.0@conda-forge
  - libllvm8=8.0.1@conda-forge
  - libllvm9=9.0.1@conda-forge
  - libnghttp2=1.51.0@conda-forge
  - libpng=1.6.43@conda-forge
  - libsqlite=3.46.0@conda-forge
  - libssh2=1.10.0@conda-forge
  - libtiff=4.2.0@conda-forge
  - libuuid=2.41.3@conda-forge
  - libxcb=1.17.0@conda-forge
  - libxkbcommon=0.10.0@conda-forge
  - libxml2=2.9.10@conda-forge
  - libxslt=1.1.33@conda-forge
  - llvmlite=0.31.0@conda-forge
  - lxml=4.5.0@conda-forge
  - matplotlib=2.2.5@conda-forge
  - ncurses=6.5@conda-forge
  - networkx=2.2@conda-forge
  - nspr=4.38@conda-forge
  - nss=3.100@conda-forge
  - numba=0.47.0@conda-forge
  - numpy=1.16.5@conda-forge
  - olefile=0.46@conda-forge
  - openblas=0.3.3@conda-forge
  - openssl=1.1.1w@conda-forge
  - pandas=0.24.2@conda-forge
  - patsy=0.5.1@conda-forge
  - pcre=8.45@conda-forge
  - pillow=6.2.1@conda-forge
  - pip=20.1.1@conda-forge
  - pthread-stubs=0.4@conda-forge
  - pyparsing=2.4.7@conda-forge
  - pyqt=5.12.3@conda-forge

conda:
  - pysam=0.20.0@bioconda

conda:
  - python-dateutil=2.8.1@conda-forge
  - python_abi=2.7@conda-forge
  - pytz=2020.1@conda-forge
  - qt=5.12.5@conda-forge
  - readline=8.3@conda-forge
  - scikit-learn=0.20.4@conda-forge
  - scipy=1.2.1@conda-forge
  - setuptools=44.0.0@conda-forge
  - singledispatch=3.6.1@conda-forge
  - six=1.16.0@conda-forge
  - sqlite=3.46.0@conda-forge
  - subprocess32=3.5.4@conda-forge
  - tk=8.6.13@conda-forge
  - tornado=5.1.1@conda-forge
  - umap-learn=0.3.10@conda-forge
  - wheel=0.37.1@conda-forge
  - xorg-libxau=1.0.12@conda-forge
  - xorg-libxdmcp=1.1.5@conda-forge
  - xz=5.2.6@conda-forge
  - zstd=1.5.6@conda-forge

pip:
  - AltAnalyze==2.1.3.15
  - Flask==1.1.4
  - Jinja2==2.11.3
  - MarkupSafe==1.1.1
  - PyQt5-sip==4.19.18
  - PyQt5==5.12.3
  - PyQtWebEngine==5.12.1
  - Werkzeug==1.0.1
  - backports-abc==0.5
  - backports.functools-lru-cache==1.6.1
  - chardet==4.0.0
  - click==7.1.2
  - community==1.0.0b1
  - idna==2.10
  - itsdangerous==1.1.0
  - nimfa==1.4.0
  - requests==2.27.1
  - urllib3==1.26.20
