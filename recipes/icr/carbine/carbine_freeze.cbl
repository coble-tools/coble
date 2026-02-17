# COBLE:capture, (c) ICR 2026
# Capture date: 2026-02-16
# Capture time: 22:40:05 GMT
# Captured by: ralcraft

coble:

  - environment: carbine

channels:
  - defaults
  - bioconda
  - conda-forge

languages:
  - r-base=4.4.3@conda-forge
  - python=3.12.12@conda-forge
flags:
  - compile-tools: true
  - dependencies: false
  - priority: flexible
  - export: CMDSTAN="/home/ralcraft/miniforge3/envs/carbine/bin/cmdstan"
  - export: OTEL_SDK_DISABLED="true"
  - export: PYTHONNOUSERSITE="1"
  - export: QT_QPA_PLATFORM="offscreen"
  - export: R_OTEL_DISABLED="true"

conda:
  - binutils=2.45.1@conda-forge
  - binutils_impl_linux-64=2.45.1@conda-forge
  - binutils_linux-64=2.45.1@conda-forge
  - conda-gcc-specs=14.3.0@conda-forge
  - gcc=14.3.0@conda-forge
  - gcc_impl_linux-64=14.3.0@conda-forge
  - gcc_linux-64=14.3.0@conda-forge
  - gxx=14.3.0@conda-forge
  - gxx_impl_linux-64=14.3.0@conda-forge
  - gxx_linux-64=14.3.0@conda-forge
  - icu=75.1@conda-forge
  - libcblas=3.11.0@conda-forge
  - libclang-cpp21.1=21.1.8@conda-forge
  - libclang13=21.1.8@conda-forge
  - libcups=2.3.3@conda-forge
  - libcurl=8.18.0@conda-forge
  - libgcc-devel_linux-64=14.3.0@conda-forge
  - libgcc-ng=15.2.0@conda-forge
  - libgcc=15.2.0@conda-forge
  - libstdcxx-devel_linux-64=14.3.0@conda-forge
  - libstdcxx-ng=15.2.0@conda-forge
  - libstdcxx=15.2.0@conda-forge
  - libzlib=1.3.1@conda-forge
  - zlib-ng=2.3.3@conda-forge
  - zlib=1.3.1@conda-forge
  - alsa-lib=1.2.15.3@conda-forge
  - argcomplete=3.6.3@conda-forge
  - arviz=0.23.4@conda-forge
  - asttokens=3.0.1@conda-forge
  - brotli-bin=1.2.0@conda-forge
  - brotli=1.2.0@conda-forge
  - bwidget=1.10.1@conda-forge
  - bzip2=1.0.8@conda-forge
  - c-ares=1.34.6@conda-forge
  - c-compiler=1.11.0@conda-forge
  - ca-certificates=2026.1.4@conda-forge
  - cached-property=1.5.2@conda-forge
  - cached_property=1.5.2@conda-forge
  - cairo=1.18.4@conda-forge
  - cmdstan=2.38.0@conda-forge
  - cmdstanpy=1.3.0@conda-forge
  - compilers=1.11.0@conda-forge
  - contourpy=1.3.3@conda-forge
  - curl=8.18.0@conda-forge
  - cxx-compiler=1.11.0@conda-forge
  - cycler=0.12.1@conda-forge
  - cyrus-sasl=2.1.28@conda-forge
  - dbus=1.16.2@conda-forge
  - decorator=5.2.1@conda-forge
  - double-conversion=3.4.0@conda-forge
  - executing=2.2.1@conda-forge
  - font-ttf-dejavu-sans-mono=2.37@conda-forge
  - font-ttf-inconsolata=3.000@conda-forge
  - font-ttf-source-code-pro=2.038@conda-forge
  - font-ttf-ubuntu=0.83@conda-forge
  - fontconfig=2.15.0@conda-forge
  - fonts-conda-forge=1@conda-forge
  - fonttools=4.61.1@conda-forge
  - fortran-compiler=1.11.0@conda-forge
  - freetype=2.14.1@conda-forge
  - fribidi=1.0.16@conda-forge
  - gfortran=14.3.0@conda-forge
  - gfortran_impl_linux-64=14.3.0@conda-forge
  - gfortran_linux-64=14.3.0@conda-forge
  - graphite2=1.3.14@conda-forge
  - gsl=2.7@conda-forge
  - h5netcdf=1.8.1@conda-forge
  - h5py=3.15.1@conda-forge
  - harfbuzz=12.2.0@conda-forge
  - hdf5=1.14.6@conda-forge
  - ipython=9.10.0@conda-forge
  - ipython_pygments_lexers=1.1.1@conda-forge
  - jedi=0.19.2@conda-forge
  - jq=1.8.1@conda-forge
  - kernel-headers_linux-64=3.10.0@conda-forge
  - keyutils=1.6.3@conda-forge
  - kiwisolver=1.4.9@conda-forge
  - krb5=1.21.3@conda-forge
  - lcms2=2.18@conda-forge
  - ld_impl_linux-64=2.45.1@conda-forge
  - lerc=4.0.0@conda-forge
  - libaec=1.1.5@conda-forge
  - libblas=3.11.0@conda-forge
  - libbrotlicommon=1.2.0@conda-forge
  - libbrotlidec=1.2.0@conda-forge
  - libbrotlienc=1.2.0@conda-forge
  - libdeflate=1.25@conda-forge
  - libdrm=2.4.125@conda-forge
  - libedit=3.1.20250104@conda-forge
  - libegl=1.7.0@conda-forge
  - libev=4.33@conda-forge
  - libexpat=2.7.4@conda-forge
  - libffi=3.5.2@conda-forge
  - libfreetype6=2.14.1@conda-forge
  - libfreetype=2.14.1@conda-forge
  - libgfortran-ng=15.2.0@conda-forge
  - libgfortran5=15.2.0@conda-forge
  - libgfortran=15.2.0@conda-forge
  - libgl=1.7.0@conda-forge
  - libglib=2.86.3@conda-forge
  - libglvnd=1.7.0@conda-forge
  - libglx=1.7.0@conda-forge
  - libgomp=15.2.0@conda-forge
  - libhwloc=2.12.2@conda-forge
  - libiconv=1.18@conda-forge
  - libjpeg-turbo=3.1.2@conda-forge
  - liblapack=3.11.0@conda-forge
  - libllvm21=21.1.8@conda-forge
  - liblzma-devel=5.8.2@conda-forge
  - liblzma=5.8.2@conda-forge
  - libnghttp2=1.67.0@conda-forge
  - libnsl=2.0.1@conda-forge
  - libntlm=1.8@conda-forge
  - libopenblas=0.3.30@conda-forge
  - libopengl=1.7.0@conda-forge
  - libpciaccess=0.18@conda-forge
  - libpng=1.6.55@conda-forge
  - libpq=18.1@conda-forge
  - libsanitizer=14.3.0@conda-forge
  - libsqlite=3.51.2@conda-forge
  - libssh2=1.11.1@conda-forge
  - libtiff=4.7.1@conda-forge
  - libuuid=2.41.3@conda-forge
  - libuv=1.51.0@conda-forge
  - libvulkan-loader=1.4.341.0@conda-forge
  - libxcb=1.17.0@conda-forge
  - libxcrypt=4.4.36@conda-forge
  - libxkbcommon=1.13.1@conda-forge
  - libxml2-16=2.15.1@conda-forge
  - libxml2-devel=2.15.1@conda-forge
  - libxml2=2.15.1@conda-forge
  - libxslt=1.1.43@conda-forge
  - make=4.4.1@conda-forge
  - matplotlib-inline=0.2.1@conda-forge
  - matplotlib=3.10.8@conda-forge
  - munkres=1.1.4@conda-forge
  - ncurses=6.5@conda-forge
  - nlopt=2.10.0@conda-forge
  - numpy=2.4.2@conda-forge
  - oniguruma=6.9.10@conda-forge
  - openjpeg=2.5.4@conda-forge
  - openldap=2.6.10@conda-forge
  - openssl=3.6.1@conda-forge
  - packaging=26.0@conda-forge
  - pandas=3.0.0@conda-forge
  - pandoc=3.9@conda-forge
  - pango=1.56.4@conda-forge
  - parso=0.8.6@conda-forge
  - patsy=1.0.2@conda-forge
  - pcre2=10.47@conda-forge
  - pexpect=4.9.0@conda-forge
  - pillow=12.1.1@conda-forge
  - pip=26.0.1@conda-forge
  - pixman=0.46.4@conda-forge
  - platformdirs=4.9.2@conda-forge
  - prompt-toolkit=3.0.52@conda-forge
  - pthread-stubs=0.4@conda-forge
  - ptyprocess=0.7.0@conda-forge
  - pure_eval=0.2.3@conda-forge
  - pygments=2.19.2@conda-forge
  - pyparsing=3.3.2@conda-forge
  - pyside6=6.10.1@conda-forge
  - python-dateutil=2.9.0.post0@conda-forge
  - python_abi=3.12@conda-forge
  - pytz=2025.2@conda-forge
  - pyyaml=6.0.3@conda-forge
  - qhull=2020.2@conda-forge
  - qt6-main=6.10.1@conda-forge
  - readline=8.3@conda-forge
  - scipy=1.17.0@conda-forge
  - seaborn=0.13.2@conda-forge
  - sed=4.9@conda-forge
  - setuptools=82.0.0@conda-forge
  - six=1.17.0@conda-forge
  - stack_data=0.6.3@conda-forge
  - stanio=0.5.1@conda-forge
  - statsmodels=0.14.6@conda-forge
  - sysroot_linux-64=2.17@conda-forge
  - tbb-devel=2022.3.0@conda-forge
  - tbb=2022.3.0@conda-forge
  - tk=8.6.13@conda-forge
  - tktable=2.10@conda-forge
  - toml=0.10.2@conda-forge
  - tomlkit=0.14.0@conda-forge
  - tornado=6.5.4@conda-forge
  - tqdm=4.67.3@conda-forge
  - traitlets=5.14.3@conda-forge
  - typing_extensions=4.15.0@conda-forge
  - tzdata=2025c@conda-forge
  - unicodedata2=17.0.1@conda-forge
  - wayland=1.24.0@conda-forge
  - wcwidth=0.6.0@conda-forge
  - wheel=0.46.3@conda-forge
  - xarray-einstats=0.9.1@conda-forge
  - xarray=2026.2.0@conda-forge
  - xcb-util-cursor=0.1.6@conda-forge
  - xcb-util-image=0.4.0@conda-forge
  - xcb-util-keysyms=0.4.1@conda-forge
  - xcb-util-renderutil=0.3.10@conda-forge
  - xcb-util-wm=0.4.2@conda-forge
  - xcb-util=0.4.1@conda-forge
  - xkeyboard-config=2.46@conda-forge
  - xmltodict=1.0.3@conda-forge
  - xorg-libice=1.1.2@conda-forge
  - xorg-libsm=1.2.6@conda-forge
  - xorg-libx11=1.8.13@conda-forge
  - xorg-libxau=1.0.12@conda-forge
  - xorg-libxcomposite=0.4.7@conda-forge
  - xorg-libxcursor=1.2.3@conda-forge
  - xorg-libxdamage=1.1.6@conda-forge
  - xorg-libxdmcp=1.1.5@conda-forge
  - xorg-libxext=1.3.7@conda-forge
  - xorg-libxfixes=6.0.2@conda-forge
  - xorg-libxi=1.8.2@conda-forge
  - xorg-libxrandr=1.5.5@conda-forge
  - xorg-libxrender=0.9.12@conda-forge
  - xorg-libxt=1.3.1@conda-forge
  - xorg-libxtst=1.2.5@conda-forge
  - xorg-libxxf86vm=1.1.7@conda-forge
  - xz-gpl-tools=5.8.2@conda-forge
  - xz-tools=5.8.2@conda-forge
  - xz=5.8.2@conda-forge
  - yaml=0.2.5@conda-forge
  - yq=3.4.3@conda-forge
  - zstd=1.5.7@conda-forge

r-conda:
  - abind=1.4_8@conda-forge
  - ade4=1.7_23@conda-forge
  - akima=0.6_3.6@conda-forge
  - askpass=1.2.1@conda-forge
  - assertthat=0.2.1@conda-forge
  - backports=1.5.0@conda-forge
  - base64enc=0.1_6@conda-forge
  - bbmle=1.0.25.1@conda-forge
  - bdsmatrix=1.3_7@conda-forge
  - bh=1.87.0_1@conda-forge
  - biocmanager=1.30.27@conda-forge
  - bit64=4.6.0_1@conda-forge
  - bit=4.6.0@conda-forge
  - bitops=1.0_9@conda-forge
  - blob=1.3.0@conda-forge

r-conda:
  - bmix=1.0.0@bioconda

r-conda:
  - boot=1.3_32@conda-forge
  - brew=1.0_10@conda-forge
  - broom=1.0.12@conda-forge
  - bslib=0.10.0@conda-forge
  - cachem=1.1.0@conda-forge
  - callr=3.7.6@conda-forge
  - car=3.1_5@conda-forge
  - cardata=3.0_6@conda-forge
  - caret=7.0_1@conda-forge
  - cellranger=1.1.0@conda-forge
  - class=7.3_23@conda-forge
  - cli=3.6.5@conda-forge
  - clipr=0.8.0@conda-forge
  - clisymbols=1.2.0@conda-forge
  - clock=0.7.4@conda-forge
  - cluster=2.1.8.2@conda-forge
  - codetools=0.2_20@conda-forge
  - colorspace=2.1_2@conda-forge
  - commonmark=2.0.0@conda-forge
  - conflicted=1.2.0@conda-forge
  - conquer=1.3.3@conda-forge
  - corrplot=0.95@conda-forge
  - cowplot=1.2.0@conda-forge
  - cpp11=0.5.3@conda-forge
  - crayon=1.5.3@conda-forge
  - data.table=1.17.8@conda-forge
  - dbi=1.2.3@conda-forge
  - dbplyr=2.5.2@conda-forge
  - deldir=2.0_4@conda-forge
  - deriv=4.2.0@conda-forge
  - desc=1.4.3@conda-forge
  - diagram=1.6.5@conda-forge
  - digest=0.6.39@conda-forge

r-conda:
  - dndscv=0.1.0@bioconda

r-conda:
  - doby=4.7.1@conda-forge
  - doparallel=1.0.17@conda-forge
  - dplyr=1.2.0@conda-forge
  - dtplyr=1.3.3@conda-forge
  - e1071=1.7_17@conda-forge

r-conda:
  - easypar=1.0.0@bioconda

r-conda:
  - ellipsis=0.3.2@conda-forge
  - evaluate=1.0.5@conda-forge
  - fansi=1.0.7@conda-forge
  - farver=2.1.2@conda-forge
  - fastmap=1.2.0@conda-forge
  - fontawesome=0.5.3@conda-forge
  - forcats=1.0.1@conda-forge
  - foreach=1.5.2@conda-forge
  - forecast=9.0.1@conda-forge
  - formatr=1.14@conda-forge
  - formula=1.2_5@conda-forge
  - fracdiff=1.5_3@conda-forge
  - fs=1.6.6@conda-forge
  - futile.logger=1.4.9@conda-forge
  - futile.options=1.0.1@conda-forge
  - future.apply=1.20.1@conda-forge
  - future=1.69.0@conda-forge
  - gargle=1.6.1@conda-forge
  - gbrd=0.4.12@conda-forge
  - generics=0.1.4@conda-forge
  - ggplot2=4.0.2@conda-forge
  - ggthemes=5.2.0@conda-forge
  - globals=0.19.0@conda-forge
  - glue=1.8.0@conda-forge
  - googledrive=2.1.2@conda-forge
  - googlesheets4=1.1.2@conda-forge
  - gower=1.0.2@conda-forge
  - gtable=0.3.6@conda-forge
  - gtools=3.9.5@conda-forge
  - guilds=1.4.7@conda-forge
  - hardhat=1.4.2@conda-forge
  - haven=2.5.5@conda-forge
  - here=1.0.2@conda-forge
  - highr=0.11@conda-forge
  - hms=1.1.4@conda-forge
  - htmltools=0.5.9@conda-forge
  - httpuv=1.6.16@conda-forge
  - httr=1.4.8@conda-forge
  - ids=1.0.1@conda-forge
  - interp=1.1_6@conda-forge
  - ipred=0.9_15@conda-forge
  - isoband=0.3.0@conda-forge
  - iterators=1.0.14@conda-forge
  - jquerylib=0.1.4@conda-forge
  - jsonlite=2.0.0@conda-forge
  - kernsmooth=2.23_26@conda-forge
  - knitr=1.51@conda-forge
  - labeling=0.4.3@conda-forge
  - lambda.r=1.2.4@conda-forge
  - later=1.4.6@conda-forge
  - lattice=0.22_9@conda-forge
  - lava=1.8.2@conda-forge
  - lifecycle=1.0.5@conda-forge
  - listenv=0.10.0@conda-forge
  - litedown=0.9@conda-forge
  - lme4=1.1_38@conda-forge
  - lmtest=0.9_40@conda-forge
  - lubridate=1.9.5@conda-forge
  - magrittr=2.0.4@conda-forge
  - markdown=2.0@conda-forge
  - mass=7.3_65@conda-forge
  - matrix=1.7_4@conda-forge
  - matrixmodels=0.5_4@conda-forge
  - matrixstats=1.5.0@conda-forge
  - memoise=2.0.1@conda-forge
  - mgcv=1.9_4@conda-forge
  - microbenchmark=1.5.0@conda-forge
  - mime=0.13@conda-forge
  - minqa=1.2.8@conda-forge
  - modelmetrics=1.2.2.2@conda-forge
  - modelr=0.1.11@conda-forge
  - munsell=0.5.1@conda-forge
  - mvtnorm=1.3_3@conda-forge
  - nlme=3.1_168@conda-forge
  - nloptr=2.2.1@conda-forge
  - nnet=7.3_20@conda-forge
  - numderiv=2016.8_1.1@conda-forge
  - otel=0.2.0@conda-forge
  - parallelly=1.46.1@conda-forge
  - pbkrtest=0.5.5@conda-forge

r-conda:
  - peakpick=0.11@bioconda

r-conda:
  - permute=0.9_10@conda-forge
  - pillar=1.11.1@conda-forge

r-conda:
  - pio=0.1.0@bioconda

r-conda:
  - pixmap=0.4_14@conda-forge
  - pkgbuild=1.4.8@conda-forge
  - pkgconfig=2.0.3@conda-forge
  - pkgload=1.5.0@conda-forge
  - plogr=0.2.0@conda-forge
  - plyr=1.8.9@conda-forge
  - png=0.1_8@conda-forge
  - poilog=0.4.2.1@conda-forge
  - powerlaw=1.0.0@conda-forge
  - pracma=2.4.6@conda-forge
  - prettydoc=0.4.1@conda-forge
  - prettyunits=1.2.0@conda-forge
  - proc=1.19.0.1@conda-forge
  - processx=3.8.6@conda-forge
  - prodlim=2025.04.28@conda-forge
  - progress=1.2.3@conda-forge
  - progressr=0.18.0@conda-forge
  - promises=1.5.0@conda-forge
  - proxy=0.4_29@conda-forge
  - ps=1.9.1@conda-forge
  - purrr=1.2.1@conda-forge
  - quadprog=1.5_8@conda-forge
  - quantmod=0.4.28@conda-forge
  - quantreg=6.1@conda-forge
  - r.methodss3=1.8.2@conda-forge
  - r.oo=1.27.1@conda-forge
  - r.utils=2.13.0@conda-forge
  - r6=2.6.1@conda-forge
  - ragg=1.5.0@conda-forge
  - rappdirs=0.3.4@conda-forge
  - rbibutils=2.4.1@conda-forge
  - rcolorbrewer=1.1_3@conda-forge
  - rcpp=1.1.1@conda-forge
  - rcpparmadillo=15.2.3_1@conda-forge
  - rcppeigen=0.3.4.0.2@conda-forge
  - rcpptoml=0.2.3@conda-forge
  - rcurl=1.98_1.17@conda-forge
  - rdpack=2.6.6@conda-forge
  - readr=2.1.6@conda-forge
  - readxl=1.4.5@conda-forge
  - recipes=1.3.1@conda-forge
  - reformulas=0.4.4@conda-forge
  - rematch2=2.1.2@conda-forge
  - rematch=2.0.0@conda-forge
  - remotes=2.5.0@conda-forge
  - reprex=2.1.1@conda-forge
  - reshape2=1.4.5@conda-forge

r-conda:
  - restfulr=0.0.16@bioconda

r-conda:
  - reticulate=1.45.0@conda-forge
  - rjson=0.2.23@conda-forge
  - rlang=1.1.7@conda-forge
  - rmarkdown=2.30@conda-forge
  - roxygen2=7.3.3@conda-forge
  - rpart=4.1.24@conda-forge
  - rprojroot=2.1.1@conda-forge
  - rsqlite=2.4.6@conda-forge
  - rstatix=0.7.3@conda-forge
  - rstudioapi=0.18.0@conda-forge
  - rvest=1.0.5@conda-forge
  - s7=0.2.1@conda-forge
  - sads=0.6.5@conda-forge
  - sass=0.4.10@conda-forge
  - scales=1.4.0@conda-forge
  - segmented=2.2_1@conda-forge
  - selectr=0.5_1@conda-forge
  - seqinr=4.2_36@conda-forge
  - shape=1.4.6.1@conda-forge
  - shiny=1.12.1@conda-forge
  - snow=0.4_4@conda-forge
  - sourcetools=0.1.7_1@conda-forge
  - sp=2.2_1@conda-forge
  - sparsem=1.84_2@conda-forge
  - sparsevctrs=0.3.5@conda-forge
  - squarem=2021.1@conda-forge
  - stringi=1.8.7@conda-forge
  - stringr=1.6.0@conda-forge
  - survival=3.8_6@conda-forge
  - sys=3.4.3@conda-forge
  - textshaping=1.0.4@conda-forge
  - tibble=3.3.1@conda-forge
  - tidyr=1.3.2@conda-forge
  - tidyselect=1.2.1@conda-forge
  - tidytable=0.11.1@conda-forge
  - tidyverse=2.0.0@conda-forge
  - timechange=0.4.0@conda-forge
  - timedate=4052.112@conda-forge
  - tinytex=0.58@conda-forge
  - tseries=0.10_59@conda-forge
  - ttr=0.24.4@conda-forge
  - tzdb=0.5.0@conda-forge
  - urca=1.3_4@conda-forge
  - utf8=1.2.6@conda-forge
  - uuid=1.2_2@conda-forge
  - vctrs=0.7.1@conda-forge
  - vegan=2.7_2@conda-forge
  - vgam=1.1_14@conda-forge
  - viridislite=0.4.3@conda-forge
  - vroom=1.6.7@conda-forge
  - withr=3.0.2@conda-forge
  - xfun=0.56@conda-forge
  - xml2=1.5.2@conda-forge
  - xml=3.99_0.22@conda-forge
  - xtable=1.8_4@conda-forge
  - xts=0.14.1@conda-forge
  - zoo=1.8_15@conda-forge

bioc-conda:
  - annotationdbi=1.68.0@bioconda
  - biocgenerics=0.52.0@bioconda
  - biocio=1.16.0@bioconda
  - biocparallel=1.40.0@bioconda
  - biostrings=2.74.0@bioconda
  - data-packages=20260207@bioconda
  - delayedarray=0.32.0@bioconda
  - genomeinfodb=1.42.0@bioconda
  - genomeinfodbdata=1.2.13@bioconda
  - genomicalignments=1.42.0@bioconda
  - genomicfeatures=1.58.0@bioconda
  - genomicranges=1.58.0@bioconda
  - iranges=2.40.0@bioconda
  - keggrest=1.46.0@bioconda
  - matrixgenerics=1.18.0@bioconda
  - rhtslib=3.2.0@bioconda
  - rsamtools=2.22.0@bioconda
  - rtracklayer=1.66.0@bioconda
  - s4arrays=1.6.0@bioconda
  - s4vectors=0.44.0@bioconda
  - sparsearray=1.6.0@bioconda
  - summarizedexperiment=1.36.0@bioconda
  - ucsc.utils=1.2.0@bioconda
  - xvector=0.46.0@bioconda
  - zlibbioc=1.52.0@bioconda

r-package:
  - GetoptLong=1.1.0
  - GlobalOptions=0.1.3

r-package:
  - ape=5.8-1@RSPM

r-package:
  - circlize=0.4.17
  - clue=0.3-66

r-package:
  - covr=3.6.5@RSPM
  - entropy=1.3.2@RSPM
  - filelock=1.0.3@RSPM
  - ggforce=0.5.0@RSPM
  - ggpubr=0.6.2@RSPM
  - ggraph=2.2.2@RSPM
  - ggrepel=0.9.6@RSPM
  - ggsci=4.2.0@RSPM
  - ggsignif=0.6.4@RSPM
  - graphlayouts=1.2.2@RSPM
  - gridExtra=2.3@RSPM
  - igraph=2.2.2@RSPM
  - inum=1.0-5@RSPM
  - lazyeval=0.2.2@RSPM
  - libcoin=1.0-10@RSPM
  - matrixcalc=1.0-6@RSPM
  - memuse=4.2-3@RSPM
  - partykit=1.2-25@RSPM
  - pinfsc50=1.3.0@RSPM
  - polyclip=1.10-7@RSPM
  - polynom=1.4-1@RSPM
  - rex=1.2.1@RSPM
  - tidygraph=1.3.1@RSPM
  - tweenr=2.0.3@RSPM
  - vcfR=1.15.0@RSPM
  - viridis=0.6.5@RSPM

bioc-package:
  - BSgenome.Hsapiens.UCSC.hg19=1.4.3
  - BSgenome=1.74.0
  - BiocFileCache=2.10.2
  - BiocVersion=3.20.0
  - CNAqc=1.1.3
  - ComplexHeatmap=2.22.0
  - TxDb.Hsapiens.UCSC.hg19.knownGene=3.2.2
  - VariantAnnotation=1.52.0
  - biomaRt=2.58.2

r-github:
  - ctree=1.1.0@github@caravagn/ctree/df8dc8395725f396e9f7cefa3a9e46d3b7b113ec
  - mobster=1.0.0@github@caravagn/mobster/85c898f087b46e15f79144bf57bdc019678e2481

pip:
  - shiboken6==6.10.1

# r-package(unknown source):
#  - VIBER=1.0.0
#  - compiler=4.4.3
#  - datasets=4.4.3
#  - evoverse=0.1.0
#  - grDevices=4.4.3
#  - graphics=4.4.3
#  - grid=4.4.3
#  - methods=4.4.3
#  - parallel=4.4.3
#  - splines=4.4.3
#  - stats4=4.4.3
#  - stats=4.4.3
#  - tcltk=4.4.3
#  - tools=4.4.3
#  - utils=4.4.3
