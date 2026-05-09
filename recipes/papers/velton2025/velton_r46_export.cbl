# COBLE:export, (c) ICR 2026
# Capture date: 2026-05-08
# Capture time: 18:31:54 BST
# Captured by: ralcraft

coble:

  - environment: velton_r46

channels:
  - defaults
  - bioconda
  - conda-forge

languages:
  - r-base=4.6.0@conda-forge
  - python=3.14.4@conda-forge
flags:
  - compile-tools: true
  - dependencies: false
  - priority: flexible

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
  - icu=78.3@conda-forge
  - libcblas=3.11.0@conda-forge
  - libcups=2.3.3@conda-forge
  - libcurl=8.20.0@conda-forge
  - libgcc=15.2.0@conda-forge
  - libgcc-devel_linux-64=14.3.0@conda-forge
  - libgcc-ng=15.2.0@conda-forge
  - libstdcxx=15.2.0@conda-forge
  - libstdcxx-devel_linux-64=14.3.0@conda-forge
  - libstdcxx-ng=15.2.0@conda-forge
  - libzlib=1.3.2@conda-forge
  - zlib=1.3.2@conda-forge
  - adwaita-icon-theme=49.0@conda-forge
  - aom=3.9.1@conda-forge
  - atk-1.0=2.38.0@conda-forge
  - at-spi2-atk=2.38.0@conda-forge
  - at-spi2-core=2.40.3@conda-forge
  - autoconf=2.72@conda-forge
  - aws-c-auth=0.10.1@conda-forge
  - aws-c-cal=0.9.13@conda-forge
  - aws-c-common=0.12.6@conda-forge
  - aws-c-compression=0.3.2@conda-forge
  - aws-checksums=0.2.10@conda-forge
  - aws-c-http=0.10.13@conda-forge
  - aws-c-io=0.26.3@conda-forge
  - aws-c-s3=0.12.2@conda-forge
  - aws-c-sdkutils=0.2.4@conda-forge
  - blosc=1.21.6@conda-forge
  - bwidget=1.10.1@conda-forge
  - bzip2=1.0.8@conda-forge
  - ca-certificates=2026.4.22@conda-forge
  - cairo=1.18.4@conda-forge
  - c-ares=1.34.6@conda-forge
  - c-compiler=1.11.0@conda-forge
  - cmake=4.3.2@conda-forge
  - compilers=1.11.0@conda-forge
  - curl=8.20.0@conda-forge
  - cxx-compiler=1.11.0@conda-forge
  - dav1d=1.2.1@conda-forge
  - dbus=1.16.2@conda-forge
  - epoxy=1.5.10@conda-forge
  - expat=2.8.0@conda-forge
  - fftw=3.3.11@conda-forge
  - fontconfig=2.17.1@conda-forge
  - fonts-conda-forge=1@conda-forge
  - font-ttf-dejavu-sans-mono=2.37@conda-forge
  - font-ttf-inconsolata=3.000@conda-forge
  - font-ttf-source-code-pro=2.038@conda-forge
  - font-ttf-ubuntu=0.83@conda-forge
  - fortran-compiler=1.11.0@conda-forge
  - freetype=2.14.3@conda-forge
  - freexl=2.0.0@conda-forge
  - fribidi=1.0.16@conda-forge
  - gdal=3.12.4@conda-forge
  - gdk-pixbuf=2.44.6@conda-forge
  - geos=3.14.1@conda-forge
  - gfortran=14.3.0@conda-forge
  - gfortran_impl_linux-64=14.3.0@conda-forge
  - gfortran_linux-64=14.3.0@conda-forge
  - ghostscript=10.07.0@conda-forge
  - giflib=5.2.2@conda-forge
  - glib-tools=2.88.1@conda-forge
  - graphite2=1.3.14@conda-forge
  - graphviz=14.1.2@conda-forge
  - gsl=2.7@conda-forge
  - gtk3=3.24.52@conda-forge
  - gts=0.7.6@conda-forge
  - harfbuzz=14.2.0@conda-forge
  - hdf5=2.1.0@conda-forge
  - hicolor-icon-theme=0.17@conda-forge
  - imagemagick=7.1.2_21@conda-forge
  - jbig=2.1@conda-forge
  - json-c=0.18@conda-forge
  - kernel-headers_linux-64=6.12.0@conda-forge
  - keyutils=1.6.3@conda-forge
  - krb5=1.22.2@conda-forge
  - ld_impl_linux-64=2.45.1@conda-forge
  - lerc=4.1.0@conda-forge
  - libabseil=20260107.1@conda-forge
  - libaec=1.1.5@conda-forge
  - libarchive=3.8.7@conda-forge
  - libavif16=1.4.1@conda-forge
  - libblas=3.11.0@conda-forge
  - libbrotlicommon=1.2.0@conda-forge
  - libbrotlidec=1.2.0@conda-forge
  - libbrotlienc=1.2.0@conda-forge
  - libde265=1.0.15@conda-forge
  - libdeflate=1.25@conda-forge
  - libdrm=2.4.125@conda-forge
  - libedit=3.1.20250104@conda-forge
  - libegl=1.7.0@conda-forge
  - libegl-devel=1.7.0@conda-forge
  - libev=4.33@conda-forge
  - libexpat=2.8.0@conda-forge
  - libffi=3.5.2@conda-forge
  - libfreetype=2.14.3@conda-forge
  - libfreetype6=2.14.3@conda-forge
  - libgd=2.3.3@conda-forge
  - libgdal-core=3.12.4@conda-forge
  - libgfortran=15.2.0@conda-forge
  - libgfortran5=15.2.0@conda-forge
  - libgfortran-ng=15.2.0@conda-forge
  - libgl=1.7.0@conda-forge
  - libgl-devel=1.7.0@conda-forge
  - libglib=2.88.1@conda-forge
  - libglvnd=1.7.0@conda-forge
  - libglx=1.7.0@conda-forge
  - libglx-devel=1.7.0@conda-forge
  - libgomp=15.2.0@conda-forge
  - libheif=1.19.7@conda-forge
  - libhwy=1.4.0@conda-forge
  - libiconv=1.18@conda-forge
  - libjpeg-turbo=3.1.4.1@conda-forge
  - libjxl=0.11.2@conda-forge
  - libkml=1.3.0@conda-forge
  - liblapack=3.11.0@conda-forge
  - libltdl=2.4.3a@conda-forge
  - liblzma=5.8.3@conda-forge
  - liblzma-devel=5.8.3@conda-forge
  - libmpdec=4.0.0@conda-forge
  - libnghttp2=1.68.1@conda-forge
  - libnsl=2.0.1@conda-forge
  - libopenblas=0.3.32@conda-forge
  - libpciaccess=0.18@conda-forge
  - libpng=1.6.58@conda-forge
  - libprotobuf=7.34.1@conda-forge
  - librsvg=2.62.1@conda-forge
  - librttopo=1.1.0@conda-forge
  - libsanitizer=14.3.0@conda-forge
  - libspatialite=5.1.0@conda-forge
  - libsqlite=3.53.1@conda-forge
  - libssh2=1.11.1@conda-forge
  - libtiff=4.7.1@conda-forge
  - libtool=2.5.4@conda-forge
  - libuuid=2.42@conda-forge
  - libuv=1.51.0@conda-forge
  - libwebp=1.6.0@conda-forge
  - libxcb=1.17.0@conda-forge
  - libxcrypt=4.4.36@conda-forge
  - libxkbcommon=1.13.1@conda-forge
  - libxml2-16=2.15.3@conda-forge
  - libxml2=2.15.3@conda-forge
  - libxml2-devel=2.15.3@conda-forge
  - lz4-c=1.10.0@conda-forge
  - lzo=2.10@conda-forge
  - m4=1.4.21@conda-forge
  - make=4.4.1@conda-forge
  - minizip=4.2.1@conda-forge
  - muparser=2.3.5@conda-forge
  - ncurses=6.6@conda-forge
  - nlopt=2.10.1@conda-forge
  - numpy=2.4.3@conda-forge
  - openjpeg=2.5.4@conda-forge
  - openssl=3.6.2@conda-forge
  - pango=1.56.4@conda-forge
  - pcre2=10.47@conda-forge
  - perl=5.32.1@conda-forge
  - pip=26.1.1@conda-forge
  - pixman=0.46.4@conda-forge
  - pkg-config=0.29.2@conda-forge
  - proj=9.8.1@conda-forge
  - pthread-stubs=0.4@conda-forge
  - python_abi=3.14@conda-forge
  - rav1e=0.8.1@conda-forge
  - readline=8.3@conda-forge
  - rhash=1.4.6@conda-forge
  - s2n=1.7.2@conda-forge
  - sed=4.10@conda-forge
  - snappy=1.2.2@conda-forge
  - sqlite=3.53.1@conda-forge
  - svt-av1=4.0.1@conda-forge
  - sysroot_linux-64=2.39@conda-forge
  - tk=8.6.13@conda-forge
  - tktable=2.10@conda-forge
  - tzdata=2025c@conda-forge
  - uriparser=0.9.8@conda-forge
  - wayland=1.25.0@conda-forge
  - x265=3.5@conda-forge
  - xerces-c=3.3.0@conda-forge
  - xkeyboard-config=2.47@conda-forge
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
  - xorg-libxinerama=1.1.6@conda-forge
  - xorg-libxrandr=1.5.5@conda-forge
  - xorg-libxrender=0.9.12@conda-forge
  - xorg-libxt=1.3.1@conda-forge
  - xorg-libxtst=1.2.5@conda-forge
  - xorg-libxxf86vm=1.1.7@conda-forge
  - xorg-xorgproto=2025.1@conda-forge
  - xz=5.8.3@conda-forge
  - xz-gpl-tools=5.8.3@conda-forge
  - xz-tools=5.8.3@conda-forge
  - zstd=1.5.7@conda-forge

r-package:
  - abind=1.4-8@RSPM
  - askpass=1.2.1@RSPM

r-package:
  - base64=2.0.2

r-package:
  - base64enc=0.1-6@RSPM

r-package:
  - beanplot=1.3.1

r-package:
  - BH=1.90.0-1@RSPM
  - BiocManager=1.30.27@RSPM

r-package:
  - bit=4.6.0
  - bit64=4.8.0

r-package:
  - bitops=1.0-9@RSPM

r-package:
  - blob=1.3.0

r-package:
  - bslib=0.10.0@RSPM
  - cachem=1.1.0@RSPM
  - caTools=1.18.3@RSPM

r-package:
  - circlize=0.4.18

r-package:
  - cli=3.6.6@RSPM

r-package:
  - clipr=0.8.0
  - clue=0.3-68

r-package:
  - cluster=2.1.8.2@RSPM
  - codetools=0.2-20@RSPM

r-package:
  - colorspace=2.1-2

r-package:
  - commonmark=2.0.0@RSPM
  - cowplot=1.2.0@RSPM
  - cpp11=0.5.5@RSPM

r-package:
  - crayon=1.5.3

r-package:
  - crosstalk=1.2.2@RSPM
  - data.table=1.18.4@RSPM

r-package:
  - DBI=1.3.0
  - dbplyr=2.5.2

r-package:
  - deldir=2.0-4@RSPM
  - digest=0.6.39@RSPM

r-package:
  - doParallel=1.0.17
  - doRNG=1.8.6.3

r-package:
  - dotCall64=1.2@RSPM
  - dplyr=1.2.1@RSPM
  - dqrng=0.4.1@RSPM
  - evaluate=1.0.5@RSPM
  - farver=2.1.2@RSPM
  - fastDummies=1.7.6@RSPM
  - fastmap=1.2.0@RSPM

r-package:
  - ff=4.5.2
  - fields=17.3
  - filelock=1.0.3

r-package:
  - fitdistrplus=1.2-6@RSPM
  - FNN=1.1.4.1@RSPM
  - fontawesome=0.5.3@RSPM

r-package:
  - foreach=1.5.2

r-package:
  - foreign=0.8-91@RSPM

r-package:
  - formatR=1.14

r-package:
  - fossil=0.4.0@RSPM
  - fs=2.1.0@RSPM

r-package:
  - futile.logger=1.4.9
  - futile.options=1.0.1

r-package:
  - future=1.70.0@RSPM
  - future.apply=1.20.2@RSPM
  - generics=0.1.4@RSPM

r-package:
  - GetoptLong=1.1.1

r-package:
  - ggplot2=4.0.3@RSPM
  - ggrepel=0.9.8@RSPM
  - ggridges=0.5.7@RSPM

r-package:
  - GlobalOptions=0.1.4

r-package:
  - globals=0.19.1@RSPM
  - glue=1.8.1@RSPM
  - goftest=1.2-3@RSPM
  - gplots=3.3.0@RSPM
  - gridExtra=2.3@RSPM
  - gtable=0.3.6@RSPM
  - gtools=3.9.5@RSPM
  - here=1.0.2@RSPM
  - highr=0.12@RSPM

r-package:
  - hms=1.1.4

r-package:
  - htmltools=0.5.9@RSPM
  - htmlwidgets=1.6.4@RSPM
  - httpuv=1.6.17@RSPM
  - httr=1.4.8@RSPM

r-package:
  - httr2=1.2.2

r-package:
  - ica=1.0-3@RSPM
  - igraph=2.3.1@RSPM
  - irlba=2.3.7@RSPM
  - isoband=0.3.0@RSPM

r-package:
  - iterators=1.0.14

r-package:
  - jquerylib=0.1.4@RSPM
  - jsonlite=2.0.0@RSPM
  - KernSmooth=2.23-26@RSPM
  - knitr=1.51@RSPM
  - labeling=0.4.3@RSPM

r-package:
  - lambda.r=1.2.4

r-package:
  - later=1.4.8@RSPM
  - lattice=0.22-9@RSPM
  - lazyeval=0.2.3@RSPM
  - lifecycle=1.0.5@RSPM
  - listenv=0.10.1@RSPM
  - lmtest=0.9-40@RSPM

r-package:
  - locfit=1.5-9.12

r-package:
  - magrittr=2.0.5@RSPM
  - maps=3.4.3@RSPM
  - MASS=7.3-65@RSPM
  - Matrix=1.7-5@RSPM
  - matrixStats=1.5.0@RSPM

r-package:
  - mclust=6.1.2

r-package:
  - memoise=2.0.1@RSPM
  - mime=0.13@RSPM
  - miniUI=0.1.2@RSPM
  - nlme=3.1-169@RSPM

r-package:
  - nor1mix=1.3-3

r-package:
  - otel=0.2.0@RSPM
  - parallelly=1.47.0@RSPM
  - patchwork=1.3.2@RSPM
  - pbapply=1.7-4@RSPM
  - pheatmap=1.0.13@RSPM
  - pillar=1.11.1@RSPM
  - pkgconfig=2.0.3@RSPM
  - plotly=4.12.0@RSPM
  - plyr=1.8.9@RSPM
  - png=0.1-9@RSPM
  - polyclip=1.10-7@RSPM

r-package:
  - prettyunits=1.2.0
  - progress=1.2.3

r-package:
  - progressr=0.19.0@RSPM
  - promises=1.5.0@RSPM
  - purrr=1.2.2@RSPM

r-package:
  - quadprog=1.5-8

r-package:
  - R6=2.6.1@RSPM
  - RANN=2.6.2@RSPM
  - rappdirs=0.3.4@RSPM
  - RColorBrewer=1.1-3@RSPM
  - Rcpp=1.1.1-1.1@RSPM
  - RcppAnnoy=0.0.23@RSPM
  - RcppArmadillo=15.2.6-1@RSPM
  - RcppEigen=0.3.4.0.2@RSPM
  - RcppHNSW=0.6.0@RSPM
  - RcppProgress=0.4.2@RSPM
  - RcppTOML=0.2.3@RSPM
  - RCurl=1.98-1.18@RSPM

r-package:
  - readr=2.2.0
  - rentrez=1.2.4
  - reshape=0.8.10

r-package:
  - reshape2=1.4.5@RSPM

r-package:
  - restfulr=0.0.16

r-package:
  - reticulate=1.46.0@RSPM

r-package:
  - rjson=0.2.23

r-package:
  - rlang=1.2.0@RSPM
  - rmarkdown=2.31@RSPM

r-package:
  - R.methodsS3=1.8.2
  - rngtools=1.5.2

r-package:
  - ROCR=1.0-12@RSPM

r-package:
  - R.oo=1.27.1

r-package:
  - rprojroot=2.1.1@RSPM
  - RSpectra=0.16-2@RSPM

r-package:
  - RSQLite=2.4.6

r-package:
  - Rtsne=0.17@RSPM

r-package:
  - R.utils=2.13.0
  - rvest=1.0.5

r-package:
  - S7=0.2.2@RSPM
  - sass=0.4.10@RSPM
  - scales=1.4.0@RSPM
  - scattermore=1.2@RSPM

r-package:
  - scrime=1.3.7

r-package:
  - sctransform=0.4.3@RSPM

r-package:
  - selectr=0.5-1

r-package:
  - Seurat=5.5.0@RSPM
  - SeuratObject=5.4.0@RSPM

r-package:
  - shape=1.4.6.1

r-package:
  - shapefiles=0.7.2@RSPM
  - shiny=1.13.0@RSPM
  - sitmo=2.0.2@RSPM

r-package:
  - snow=0.4-4

r-package:
  - sourcetools=0.1.7-2@RSPM
  - sp=2.2-1@RSPM
  - spam=2.11-3@RSPM
  - spatstat.data=3.1-9@RSPM
  - spatstat.explore=3.8-0@RSPM
  - spatstat.geom=3.7-3@RSPM
  - spatstat.random=3.4-5@RSPM
  - spatstat.sparse=3.1-0@RSPM
  - spatstat.univar=3.1-7@RSPM
  - spatstat.utils=3.2-2@RSPM

r-package:
  - statmod=1.5.1

r-package:
  - stringi=1.8.7@RSPM
  - stringr=1.6.0@RSPM
  - survival=3.8-6@RSPM
  - sys=3.4.3@RSPM
  - tensor=1.5.1@RSPM
  - tibble=3.3.1@RSPM
  - tidyr=1.3.2@RSPM
  - tidyselect=1.2.1@RSPM
  - tinytex=0.59@RSPM

r-package:
  - tzdb=0.5.0

r-package:
  - utf8=1.2.6@RSPM
  - uwot=0.2.4@RSPM
  - vctrs=0.7.3@RSPM
  - viridis=0.6.5@RSPM
  - viridisLite=0.4.3@RSPM

r-package:
  - vroom=1.7.1

r-package:
  - withr=3.0.2@RSPM
  - xfun=0.57@RSPM

r-package:
  - xml2=1.5.2
  - XML=3.99-0.23

r-package:
  - xtable=1.8-8@RSPM
  - yaml=2.3.12@RSPM
  - zoo=1.8-15@RSPM

bioc-package:
  - annotate=1.90.0
  - AnnotationDbi=1.74.0
  - BiocFileCache=3.2.0
  - BiocGenerics=0.58.0
  - BiocIO=1.22.0
  - biocmake=1.4.0
  - BiocParallel=1.46.0
  - BiocVersion=3.23.1
  - biomaRt=2.68.0
  - Biostrings=2.80.0
  - bumphunter=1.54.0
  - cigarillo=1.2.0
  - ComplexHeatmap=2.28.0
  - DelayedArray=0.38.1
  - DelayedMatrixStats=1.34.0
  - dir.expiry=1.20.0
  - FDb.InfiniumMethylation.hg19=2.2.0
  - genefilter=1.94.0
  - GenomeInfoDb=1.48.0
  - GenomicAlignments=1.48.0
  - GenomicFeatures=1.64.0
  - GenomicRanges=1.64.0
  - GEOquery=2.80.0
  - h5mread=1.4.0
  - HDF5Array=1.40.0
  - illuminaio=0.54.0
  - IRanges=2.46.0
  - KEGGREST=1.52.0
  - limma=3.68.2
  - MatrixGenerics=1.24.0
  - methylumi=2.58.0
  - minfi=1.58.0
  - multtest=2.68.0
  - org.Hs.eg.db=3.23.1
  - preprocessCore=1.74.0
  - rhdf5=2.56.0
  - rhdf5filters=1.24.0
  - Rhdf5lib=2.0.0
  - Rhtslib=3.8.0
  - RnBeads=2.30.0
  - Rsamtools=2.28.0
  - rtracklayer=1.72.0
  - S4Arrays=1.12.0
  - S4Vectors=0.50.0
  - Seqinfo=1.2.0
  - siggenes=1.86.0
  - SparseArray=1.12.2
  - sparseMatrixStats=1.24.0
  - SummarizedExperiment=1.42.0
  - TxDb.Hsapiens.UCSC.hg19.knownGene=3.22.1
  - UCSC.utils=1.8.0
  - XVector=0.52.0

# r-package(unknown source):
#  - compiler=4.6.0
#  - datasets=4.6.0
#  - graphics=4.6.0
#  - grDevices=4.6.0
#  - grid=4.6.0
#  - methods=4.6.0
#  - parallel=4.6.0
#  - splines=4.6.0
#  - stats4=4.6.0
#  - stats=4.6.0
#  - tcltk=4.6.0
#  - tools=4.6.0
#  - utils=4.6.0
