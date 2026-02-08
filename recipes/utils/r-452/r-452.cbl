##########################################################
# COBLE: Complex Bioinformatics Example, (c) ICR 2026
##########################################################
coble:
  - environment: bioinf
channels:
# note the reverse order of priority
  - defaults
  - r
  - bioconda
  - conda-forge

languages:
  - compile-version=13.1
  - compile-order=with
  - env-sims=true  
  - r-base=4.5.2
  - python=3.14.0@conda-forge

flags:
  - dependencies: NA
  - system-tools: True  
  - ncpus: 8
  
bash:
  - # Special installs outside of conda for awkward pysamstats package  
  - python -m pip install "setuptools>=59.0"
  - python -m pip install --upgrade "Cython>=3.0.11"
  - python -m pip install pysam
  - CFLAGS="-Wno-error=incompatible-pointer-types" CPPFLAGS="-Wno-error=incompatible-pointer-types" python -m pip install --no-build-isolation git+https://github.com/rachelicr/pysamstats.git

r-conda:
  - biocmanager
  - devtools
  - data.table  
bioc-package:  
  - fgsea

r-conda:
  - stringi 
  - rcpp 
  - plyr 
  - reticulate 
  - sitmo
  - seurat
  - units

r-conda:
  - raster
  - spdep
  - magick
bioc-package:
  - stJoincount

