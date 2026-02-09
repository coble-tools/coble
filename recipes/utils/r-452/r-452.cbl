##########################################################
# COBLE: Complex Bioinformatics Example, (c) ICR 2026
##########################################################
coble:
  - environment: 4-452
channels:
  - defaults
  - r
  - bioconda
  - conda-forge

languages:
  - r-base=4.5.2@conda-forge
  - python=3.14.0@conda-forge

flags:
  - dependencies: NA   
  - system-tools: True
  - compile-tools: 11.4
  - network-viz: true
  - ncpus: 8
  
bash:
  - # Special installs outside of conda for awkward pysamstats package  
  - python -m pip install "setuptools>=59.0"
  - python -m pip install --upgrade "Cython>=3.0.11"
  - python -m pip install pysam
  - CFLAGS="-Wno-error=incompatible-pointer-types" CPPFLAGS="-Wno-error=incompatible-pointer-types" python -m pip install --no-build-isolation git+https://github.com/rachelicr/pysamstats.git

r-conda:  
  - devtools
  