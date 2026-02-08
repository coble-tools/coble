#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-07
# Capture time: 22:28:59 GMT
# Captured by: ralcraft
# Platform: 
#####################################################
# source bashrc for conda
source /home/ralcraft/.bashrc
# Using conda executable conda: /home/ralcraft/miniforge3/envs/pytest/bin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/envs/pytest/bin/conda
#####################################################

# Detected platform: OS=linux, ARCH=x86_64, PLATFORM=linux-64
# Compiler packages: c-compiler cxx-compiler fortran-compiler
# Compiler packages: sysroot_linux-64
# Compiler packages: gcc_linux-64 gxx_linux-64 gfortran_linux-64
conda env remove --name carbine -y 2>/dev/null || true
conda create --no-default-packages --name carbine -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# activate environment
conda activate carbine

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels defaults
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
#####################################################
# COBLE:Reproducible environment: carbine, (c) ICR 2026
#####################################################
# languages:
# Language package: add: cmdstan, version: 
# cmdstan=2.38.0 adding to init installs
# Language package: r-base, version: 
conda install -y  \
  gcc_linux-64 gxx_linux-64 gfortran_linux-64 \
  sysroot_linux-64 \
  c-compiler cxx-compiler fortran-compiler 'cmdstan=2.38.0' \
'r-base=4.4.3' r-remotes r-biocmanager
# Recommended tools: 
# Symlink all compiler/binutils tools

# Set up compiler symlinks for R package compilation - Linux x86_64
umask 0022
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++
# Standard compiler aliases
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/gcc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/c++
# Language package: python, version: 
conda install -y  'python=3.12'
python -m site
conda env config vars set PYTHONNOUSERSITE=1
conda deactivate
conda activate carbine
# flags:
# Flag: Directive: dependencies, Value: na

# Including system dependencies for source installations
# Essential shared packages
conda install -y --no-update-deps -c conda-forge libcurl libprotobuf libpng libtiff libjpeg-turbo gdal proj geos gsl nlopt hdf5 cairo freetype expat fontconfig harfbuzz fribidi imagemagick
# System r packages
# Essential r packages

# Essential python packages

# Language build tools
conda install -y --no-update-deps -c conda-forge make cmake pkg-config
# Language core system libraries
conda install -y --no-update-deps -c conda-forge zlib bzip2 xz libxcrypt openssl sqlite
conda env config vars set QT_QPA_PLATFORM=offscreen
conda deactivate
conda activate carbine
# conda:
conda install -y  --no-update-deps \
'cmdstanpy=1.3.0' \
'arviz' \
'pytz' \
'ipython' \
'matplotlib' \
'pandas=3.0.0' \
'scipy=1.17.0' \
'seaborn=0.13.2' \
'xz' 
# r-conda:
conda install -y  --no-update-deps \
'r-ctree' \
'r-doBy' \
'r-pbkrtest' \
'r-car' \
'r-rstatix' \
'r-sads' \
'r-tidyverse' \
'r-tidytable' \
'r-pio' \
'r-easypar' \
'r-dndscv' 
# r-package:
Rscript -e 'install.packages("vcfR", repos="https://cloud.r-project.org", dependencies=NA, Ncpus=4)'
Rscript -e 'install.packages("covr", repos="https://cloud.r-project.org", dependencies=NA, Ncpus=4)'
Rscript -e 'install.packages("partykit", repos="https://cloud.r-project.org", dependencies=NA, Ncpus=4)'
# r-conda:
conda install -y  --no-update-deps \
'r-ggthemes' \
'r-clisymbols' \
'r-reshape2' \
'r-BMix' \
'r-gtools' \
'r-akima' \
'r-peakPick' \
'r-R.utils' \
'r-XML' \
'r-restfulr' \
'r-rjson' \
'r-interp' \
'r-reticulate' 
# r-package:
Rscript -e 'install.packages("ggpubr", repos="https://cloud.r-project.org", dependencies=NA, Ncpus=4)'
Rscript -e 'install.packages("ggsci", repos="https://cloud.r-project.org", dependencies=NA, Ncpus=4)'
# bioc-conda:
conda install -y  --no-update-deps \
'bioconda::bioconductor-rtracklayer=1.66.0' \
'bioconda::bioconductor-genomicfeatures=1.58.0' \
'bioconda::bioconductor-delayedarray=0.32.0' \
'bioconda::bioconductor-summarizedexperiment=1.36.0' \
'bioconda::bioconductor-genomicalignments=1.42.0' 
# bioc-package:
Rscript -e 'BiocManager::install("TxDb.Hsapiens.UCSC.hg19.knownGene", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("BSgenome.Hsapiens.UCSC.hg19", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("AnnotationDbi", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("ComplexHeatmap", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("VariantAnnotation", dependencies=NA, Ncpus=4)'
# r-url:
Rscript -e 'remotes::install_url("https://github.com/im3sanger/dndscv/archive/refs/heads/master.zip", dependencies=NA, upgrade="default", Ncpus=4)'
Rscript -e 'remotes::install_url("https://github.com/caravagnalab/CNAqc/archive/refs/heads/master.zip", dependencies=NA, upgrade="default", Ncpus=4)'
Rscript -e 'remotes::install_url("https://github.com/caravagnalab/VIBER/archive/refs/heads/master.zip", dependencies=NA, upgrade="default", Ncpus=4)'
Rscript -e 'remotes::install_url("https://github.com/caravagnalab/mobster/archive/refs/heads/binomial_noise.zip", dependencies=NA, upgrade="default", Ncpus=4)'
Rscript -e 'remotes::install_url("https://github.com/caravagn/evoverse/archive/refs/heads/development.zip", dependencies=NA, upgrade="default", Ncpus=4)'

# Validate script available in environment at CONDA PREFIX: validate.sh
cp recipes/icr/carbine/validate/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
# Extra validation file: run.stan
cp recipes/icr/carbine/validate//run.stan ${CONDA_PREFIX}/bin/run.stan
chmod +x ${CONDA_PREFIX}/bin/run.stan
# Extra validation file: run_stan.py
cp recipes/icr/carbine/validate//run_stan.py ${CONDA_PREFIX}/bin/run_stan.py
chmod +x ${CONDA_PREFIX}/bin/run_stan.py

