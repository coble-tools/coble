#!/usr/bin/env bash

#######################################
# COBLE:Reproducible environment recipe, (c) ICR 2025
# Capture date: 2025-12-24
# Capture time: 22:59:57 GMT
# Captured by: ralcraft
#######################################
# source bashrc for conda
source "$(conda info --base)/etc/profile.d/conda.sh"
source ~/.bashrc
#######################################


conda create --name tml -y
conda activate tml

# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels defaults
conda config --env --add channels r
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA

# languages:
conda install -y -c conda-forge 'r-base=4.5.2'
conda install -y 'conda-forge::python=3.14.0'

# flags:
# Flag: Directive: dependencies, Value: true
# Flag: Directive: build-tools, Value: true

# Including build tools for source installations
conda install -y -c conda-forge gsl nlopt
conda install -y -c conda-forge -c bioconda r-cpp11 r-openssl r-rsqlite r-remotes r-biocmanager r-essentials
conda install -y -c conda-forge librsvg cairo freetype expat fontconfig
conda install -y -c conda-forge libxcrypt sysroot_linux-64 gcc_linux-64 gxx_linux-64 gfortran_linux-64 c-compiler cxx-compiler
conda install -y -c conda-forge make cmake pkg-config protobuf libprotobuf openssl cython bzip2 xz libcurl zlib
# Compiler symlinks for R packages
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-gfortran
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-c++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/gcc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/c++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/cc
# Set compiler flags for R package compilation
export CFLAGS="-I$CONDA_PREFIX/include"
export CXXFLAGS="-I$CONDA_PREFIX/include"
export CPPFLAGS="-I$CONDA_PREFIX/include"
export LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib"


# bash:
python -m pip install "setuptools>=59.0"
python -m pip install --upgrade "Cython>=3.0.11"

# conda:
conda install -y   \
'numpy' 

# pip:
python -m pip install pysam 

# bash:
export CFLAGS="-Wno-error=incompatible-pointer-types"
python -m pip install --no-build-isolation git+https://github.com/rachelicr/pysamstats.git

# r-conda:
conda install -y   \
'r-data.table' \
'r-stringi' \
'r-rsvg' \
'r-plyr' \
'r-sitmo' \
'r-rcpp' \
'r-seurat' \
'r-units' \
'r-raster' \
'r-spdep' \
'r-magick' \
'r-rcpparmadillo' \
'r-conquer' \
'r-minqa' \
'r-lme4' \
'r-gifski' \
'r-tzdb' \
'r-vroom' \
'r-readr' \
'r-readxl' \
'r-rcppannoy' \
'r-glmnet' \
'r-rjson' \
'r-interp' \
'r-v8' \
'r-cairo' \
'r-gdtools' \
'r-flextable' \
'r-rstanarm' 

# bioc-package:
Rscript -e 'BiocManager::install("fgsea", dependencies=TRUE)'
Rscript -e 'BiocManager::install("stJoincount", dependencies=TRUE)'
Rscript -e 'BiocManager::install("limma", dependencies=TRUE)'
Rscript -e 'BiocManager::install("vsn", dependencies=TRUE)'
Rscript -e 'BiocManager::install("edgeR", dependencies=TRUE)'
Rscript -e 'BiocManager::install("org.Hs.eg.db", dependencies=TRUE)'
Rscript -e 'BiocManager::install("org.Mm.eg.db", dependencies=TRUE)'

# r-package:
Rscript -e 'install.packages("gdata", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("bedr", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("SIMMS", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("haven", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("foreign", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("spatstat", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("FactoMineR", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("otelsdk", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("knitr", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("rmarkdown", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("inline", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("distributions3", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("mboost", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("AER", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("brglm2", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("flexmix", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("modelsummary", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("nonnest2", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("tinytest", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("UpSetR", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("plotrix", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("gplots", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("drc", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("chicane", repos="https://cloud.r-project.org", dependencies=TRUE)'
Rscript -e 'install.packages("countreg", repos="https://cloud.r-project.org", dependencies=TRUE)'

# bioc-package:
Rscript -e 'BiocManager::install("scater", dependencies=TRUE)'
Rscript -e 'BiocManager::install("cellHTS2", dependencies=TRUE)'
Rscript -e 'BiocManager::install("PoisonAlien/maftools", dependencies=TRUE)'
Rscript -e 'BiocManager::install("illuminaHumanv4.db", dependencies=TRUE)'
Rscript -e 'BiocManager::install("zellkonverter", dependencies=TRUE)'
Rscript -e 'BiocManager::install("NanoStringNCTools", dependencies=TRUE)'
Rscript -e 'BiocManager::install("GeomxTools", dependencies=TRUE)'
Rscript -e 'BiocManager::install("GeoMxWorkflows", dependencies=TRUE)'
Rscript -e 'BiocManager::install("Orthology.eg.db", dependencies=TRUE)'
Rscript -e 'BiocManager::install("viper", dependencies=TRUE)'
Rscript -e 'BiocManager::install("dorothea", dependencies=TRUE)'
Rscript -e 'BiocManager::install("aracne.networks", dependencies=TRUE)'
Rscript -e 'BiocManager::install("scDblFinder", dependencies=TRUE)'
Rscript -e 'BiocManager::install("biomaRt", dependencies=TRUE)'
Rscript -e 'BiocManager::install("rtracklayer", dependencies=TRUE)'
Rscript -e 'BiocManager::install("GenomicFeatures", dependencies=TRUE)'
Rscript -e 'BiocManager::install("BSgenome", dependencies=TRUE)'
Rscript -e 'BiocManager::install("VariantAnnotation", dependencies=TRUE)'
Rscript -e 'BiocManager::install("ensembldb", dependencies=TRUE)'
Rscript -e 'BiocManager::install("biovizBase", dependencies=TRUE)'
Rscript -e 'BiocManager::install("Gviz", dependencies=TRUE)'
Rscript -e 'BiocManager::install("GenomicInteractions", dependencies=TRUE)'
Rscript -e 'BiocManager::install("multtest", dependencies=TRUE)'
Rscript -e 'BiocManager::install("GSEABase", dependencies=TRUE)'
Rscript -e 'BiocManager::install("reshape", dependencies=TRUE)'
Rscript -e 'BiocManager::install("TeachingDemos", dependencies=TRUE)'
Rscript -e 'BiocManager::install("tidyverse", dependencies=TRUE)'
Rscript -e 'BiocManager::install("SingleR", dependencies=TRUE)'
Rscript -e 'BiocManager::install("scran", dependencies=TRUE)'
Rscript -e 'BiocManager::install("celldex", dependencies=TRUE)'
Rscript -e 'BiocManager::install("MAST", dependencies=TRUE)'
Rscript -e 'BiocManager::install("impute", dependencies=TRUE)'
Rscript -e 'BiocManager::install("genefu", dependencies=TRUE)'
Rscript -e 'BiocManager::install("fastseg", dependencies=TRUE)'
Rscript -e 'BiocManager::install("methylKit", dependencies=TRUE)'
Rscript -e 'BiocManager::install("BSgenome.Hsapiens.NCBI.GRCh38", dependencies=TRUE)'
Rscript -e 'BiocManager::install("genomation", dependencies=TRUE)'
Rscript -e 'BiocManager::install("ggbio", dependencies=TRUE)'
Rscript -e 'BiocManager::install("TxDb.Hsapiens.UCSC.hg38.knownGene", dependencies=TRUE)'
Rscript -e 'BiocManager::install("EnsDb.Hsapiens.v86", dependencies=TRUE)'
Rscript -e 'BiocManager::install("harmony", dependencies=TRUE)'
Rscript -e 'BiocManager::install("infercnv", dependencies=TRUE)'
Rscript -e 'BiocManager::install("ShortRead", dependencies=TRUE)'
Rscript -e 'BiocManager::install("Chicago", dependencies=TRUE)'
Rscript -e 'BiocManager::install("pcaMethods", dependencies=TRUE)'
Rscript -e 'BiocManager::install("Rsubread", dependencies=TRUE)'
Rscript -e 'BiocManager::install("batchelor", dependencies=TRUE)'
Rscript -e 'BiocManager::install("liftOver", dependencies=TRUE)'
Rscript -e 'BiocManager::install("glmGamPoi", dependencies=TRUE)'
Rscript -e 'BiocManager::install("multiGSEA", dependencies=TRUE)'
Rscript -e 'BiocManager::install("GSVA", dependencies=TRUE)'
Rscript -e 'BiocManager::install("minfi", dependencies=TRUE)'
Rscript -e 'BiocManager::install("IlluminaHumanMethylationEPICanno.ilm10b4.hg19", dependencies=TRUE)'
Rscript -e 'BiocManager::install("IlluminaHumanMethylationEPICmanifest", dependencies=TRUE)'
Rscript -e 'BiocManager::install("missMethyl", dependencies=TRUE)'
Rscript -e 'BiocManager::install("minfiData", dependencies=TRUE)'
Rscript -e 'BiocManager::install("DMRcate", dependencies=TRUE)'
Rscript -e 'BiocManager::install("kstreet13/slingshot", dependencies=TRUE)'
Rscript -e 'BiocManager::install("sva", dependencies=TRUE)'
Rscript -e 'BiocManager::install("destiny", dependencies=TRUE)'
Rscript -e 'BiocManager::install("DEXSeq", dependencies=TRUE)'
Rscript -e 'BiocManager::install("AUCell", dependencies=TRUE)'
Rscript -e 'BiocManager::install("RcisTarget", dependencies=TRUE)'
Rscript -e 'BiocManager::install("GENIE3", dependencies=TRUE)'
Rscript -e 'BiocManager::install("R2HTML", dependencies=TRUE)'
Rscript -e 'BiocManager::install("ChromSCape", dependencies=TRUE)'
Rscript -e 'BiocManager::install("reactome.db", dependencies=TRUE)'

# r-github:

# r-url:

# pip:

