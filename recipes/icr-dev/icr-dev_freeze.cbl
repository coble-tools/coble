# COBLE:capture, (c) ICR 2026
# Capture date: 2026-01-18
# Capture time: 10:26:11 GMT
# Captured by: rachel

coble:

  - environment: DEV

channels:
  - defaults
  - conda-forge

flags:
  - dependencies: false
  - priority: flexible

languages:
  - python=3.13.1@conda-forge
flags:
  - export PYTHONNOUSERSITE="1"

conda:
  - icu=78.2@conda-forge
  - libcurl=8.18.0@conda-forge
  - libgcc-ng=15.2.0@conda-forge
  - libgcc=15.2.0@conda-forge
  - libstdcxx-ng=15.2.0@conda-forge
  - libstdcxx=15.2.0@conda-forge
  - libzlib=1.3.1@conda-forge
  - zlib-ng=2.3.2@conda-forge
  - anaconda-client=1.13.1@conda-forge
  - annotated-types=0.7.0@conda-forge
  - archspec=0.2.5@conda-forge
  - attrs=25.4.0@conda-forge
  - backports.zstd=1.3.0@conda-forge
  - beautifulsoup4=4.14.3@conda-forge
  - boltons=25.0.0@conda-forge
  - brotli-python=1.2.0@conda-forge
  - bzip2=1.0.8@conda-forge
  - c-ares=1.34.6@conda-forge
  - ca-certificates=2026.1.4@conda-forge
  - certifi=2026.1.4@conda-forge
  - cffi=2.0.0@conda-forge
  - chardet=5.2.0@conda-forge
  - charset-normalizer=3.4.4@conda-forge
  - click=8.3.1@conda-forge
  - colorama=0.4.6@conda-forge
  - conda-build=25.11.1@conda-forge
  - conda-index=0.7.0@conda-forge
  - conda-libmamba-solver=25.11.0@conda-forge
  - conda-package-handling=2.4.0@conda-forge
  - conda-package-streaming=0.12.0@conda-forge
  - conda=25.11.1@conda-forge
  - cpp-expected=1.3.1@conda-forge
  - defusedxml=0.7.1@conda-forge
  - distro=1.9.0@conda-forge
  - evalidate=2.0.5@conda-forge
  - filelock=3.20.3@conda-forge
  - fmt=12.1.0@conda-forge
  - frozendict=2.4.7@conda-forge
  - h2=4.3.0@conda-forge
  - hpack=4.1.0@conda-forge
  - hyperframe=6.1.0@conda-forge
  - idna=3.11@conda-forge
  - jinja2=3.1.6@conda-forge
  - jsonpatch=1.33@conda-forge
  - jsonpointer=3.0.0@conda-forge
  - jsonschema-specifications=2025.9.1@conda-forge
  - jsonschema=4.26.0@conda-forge
  - jupyter_core=5.9.1@conda-forge
  - keyutils=1.6.3@conda-forge
  - krb5=1.21.3@conda-forge
  - lcms2=2.18@conda-forge
  - ld_impl_linux-64=2.45@conda-forge
  - lerc=4.0.0@conda-forge
  - libarchive=3.8.5@conda-forge
  - libdeflate=1.25@conda-forge
  - libedit=3.1.20250104@conda-forge
  - libev=4.33@conda-forge
  - libexpat=2.7.3@conda-forge
  - libffi=3.5.2@conda-forge
  - libfreetype6=2.14.1@conda-forge
  - libfreetype=2.14.1@conda-forge
  - libgomp=15.2.0@conda-forge
  - libiconv=1.18@conda-forge
  - libjpeg-turbo=3.1.2@conda-forge
  - liblief=0.16.6@conda-forge
  - liblzma=5.8.1@conda-forge
  - libmamba-spdlog=2.5.0@conda-forge
  - libmamba=2.5.0@conda-forge
  - libmambapy=2.5.0@conda-forge
  - libmpdec=4.0.0@conda-forge
  - libnghttp2=1.67.0@conda-forge
  - libpng=1.6.54@conda-forge
  - libsolv=0.7.35@conda-forge
  - libsqlite=3.51.2@conda-forge
  - libssh2=1.11.1@conda-forge
  - libtiff=4.7.1@conda-forge
  - libuuid=2.41.3@conda-forge
  - libxcb=1.17.0@conda-forge
  - libxml2-16=2.15.1@conda-forge
  - libxml2=2.15.1@conda-forge
  - lz4-c=1.10.0@conda-forge
  - lzo=2.10@conda-forge
  - markdown-it-py=4.0.0@conda-forge
  - markupsafe=3.0.3@conda-forge
  - mbedtls=3.6.3.1@conda-forge
  - mdurl=0.1.2@conda-forge
  - menuinst=2.4.2@conda-forge
  - msgpack-python=1.1.2@conda-forge
  - nbformat=5.10.4@conda-forge
  - ncurses=6.5@conda-forge
  - nlohmann_json-abi=3.12.0@conda-forge
  - openjpeg=2.5.4@conda-forge
  - openssl=3.6.0@conda-forge
  - packaging=25.0@conda-forge
  - patch=2.8@conda-forge
  - patchelf=0.17.2@conda-forge
  - pillow=12.1.0@conda-forge
  - pip=25.3@conda-forge
  - pkginfo=1.12.1.2@conda-forge
  - platformdirs=4.5.1@conda-forge
  - pluggy=1.6.0@conda-forge
  - psutil=7.2.1@conda-forge
  - pthread-stubs=0.4@conda-forge
  - py-lief=0.16.6@conda-forge
  - pybind11-abi=11@conda-forge
  - pycosat=0.6.6@conda-forge
  - pycparser=2.22@conda-forge
  - pydantic-core=2.41.5@conda-forge
  - pydantic-settings=2.12.0@conda-forge
  - pydantic=2.12.5@conda-forge
  - pygments=2.19.2@conda-forge
  - pysocks=1.7.1@conda-forge
  - python-dateutil=2.9.0.post0@conda-forge
  - python-dotenv=1.2.1@conda-forge
  - python-fastjsonschema=2.21.2@conda-forge
  - python-libarchive-c=5.3@conda-forge
  - python_abi=3.13@conda-forge
  - pytz=2025.2@conda-forge
  - pyyaml=6.0.3@conda-forge
  - readchar=4.2.1@conda-forge
  - readline=8.3@conda-forge
  - referencing=0.37.0@conda-forge
  - reproc-cpp=14.2.5.post0@conda-forge
  - reproc=14.2.5.post0@conda-forge
  - requests-toolbelt=1.0.0@conda-forge
  - requests=2.32.5@conda-forge
  - rich=14.2.0@conda-forge
  - ripgrep=15.1.0@conda-forge
  - rpds-py=0.30.0@conda-forge
  - ruamel.yaml.clib=0.2.15@conda-forge
  - ruamel.yaml=0.18.17@conda-forge
  - setuptools=80.9.0@conda-forge
  - shellingham=1.5.4@conda-forge
  - simdjson=4.2.4@conda-forge
  - six=1.17.0@conda-forge
  - soupsieve=2.8.1@conda-forge
  - spdlog=1.17.0@conda-forge
  - tk=8.6.13@conda-forge
  - tomli=2.4.0@conda-forge
  - tqdm=4.67.1@conda-forge
  - traitlets=5.14.3@conda-forge
  - truststore=0.10.4@conda-forge
  - typer-slim-standard=0.21.1@conda-forge
  - typer-slim=0.21.1@conda-forge
  - typer=0.21.1@conda-forge
  - typing-extensions=4.15.0@conda-forge
  - typing-inspection=0.4.2@conda-forge
  - typing_extensions=4.15.0@conda-forge
  - urllib3=2.6.3@conda-forge
  - xorg-libxau=1.0.12@conda-forge
  - xorg-libxdmcp=1.1.5@conda-forge
  - yaml-cpp=0.8.0@conda-forge
  - yaml=0.2.5@conda-forge
  - zstandard=0.25.0@conda-forge
  - zstd=1.5.7@conda-forge

pip:
  - git+https://github.com/ICR-RSE-Group/gitalma.git@b3fcee73c9f6269faa3cb1954cc16bffffd3eb6f@git+https://github.com/ICR-RSE-Group/gitalma.git@b3fcee73c9f6269faa3cb1954cc16bffffd3eb6f

pip:
  - iniconfig==2.3.0
  - numpy==2.4.1
  - pandas==2.3.3
  - pytest==9.0.2
  - tzdata==2025.3
