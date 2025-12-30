#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2025
# Capture date: 2025-12-30
# Capture time: 11:28:43 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source "$(conda info --base)/etc/profile.d/conda.sh"
source ~/.bashrc
#####################################################


conda create --name 452 -y
conda activate 452

# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels defaults
conda config --env --add channels r
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
##########################################################
# COBLE: Complex Bioinformatics Example, (c) ICR 2025
##########################################################
# note the reverse order of priority
# languages:
conda install -y -c conda-forge 'r-base=4.5.2'
conda install -y 'conda-forge::python=3.14.0'
# flags:
# Flag: Directive: dependencies, Value: true
# Flag: Directive: build-tools, Value: true

# Including build tools for source installations
# Essential r packages
conda install -y --no-update-deps -c conda-forge r-cpp11 r-openssl r-rsqlite r-remotes r-biocmanager r-essentials
# Essential r geo-spatial libraries
conda install -y --no-update-deps -c conda-forge gdal proj geos
# Essential r mathematical libraries
conda install -y --no-update-deps -c conda-forge gsl nlopt udunits2 hdf5
# Essential r image libraries
conda install -y --no-update-deps -c conda-forge libpng libtiff libjpeg-turbo librsvg r-rsvg imagemagick cairo freetype expat fontconfig harfbuzz fribidi
# Essential python packages
conda install -y --no-update-deps -c conda-forge cython
# Language compile tools
conda install -y --no-update-deps -c conda-forge sysroot_linux-64 gcc_linux-64 gxx_linux-64 gfortran_linux-64 c-compiler cxx-compiler
# Language build tools
conda install -y --no-update-deps -c conda-forge cmake pkg-config
# Language core system libraries
conda install -y --no-update-deps -c conda-forge zlib bzip2 xz libxcrypt openssl sqlite
# Language XML/data libraries
conda install -y --no-update-deps -c conda-forge 'libxml2>=2.12,<2.15' libcurl protobuf libprotobuf
# Set up compiler symlinks for R package compilation - COS6 compatibility
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-gfortran
# Set up compiler symlinks for R package compilation - standard aliases
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/gcc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/c++
# Set compiler flags for R package compilation
export CFLAGS="-I$CONDA_PREFIX/include"
export CXXFLAGS="-I$CONDA_PREFIX/include"
export CPPFLAGS="-I$CONDA_PREFIX/include"
export LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib"

# Flag: Directive: ncpus, Value: 8

# bash:
# Special installs outside of conda for awkward pysamstats package
python -m pip install "setuptools>=59.0"
python -m pip install --upgrade "Cython>=3.0.11"
python -m pip install pysam
CFLAGS="-Wno-error=incompatible-pointer-types" CPPFLAGS="-Wno-error=incompatible-pointer-types" python -m pip install --no-build-isolation git+https://github.com/rachelicr/pysamstats.git

# r-conda:
conda install -y  --no-update-deps \
'r-biocmanager' \
'r-devtools' \
'r-data.table' 
# bioc-package:
Rscript -e 'BiocManager::install("fgsea", dependencies=TRUE, Ncpus=8)'

# r-conda:
conda install -y  --no-update-deps \
'r-stringi' \
'r-rcpp' \
'r-plyr' \
'r-reticulate' \
'r-sitmo' \
'r-seurat' \
'r-units' 

# r-conda:
conda install -y  --no-update-deps \
'r-raster' \
'r-spdep' \
'r-magick' 
# bioc-package:
Rscript -e 'BiocManager::install("stJoincount", dependencies=TRUE, Ncpus=8)'

# conda:
conda install -y  --no-update-deps \
'pandoc' \
'pypandoc' \
'boost-cpp' 
# r-conda:
conda install -y  --no-update-deps \
'r-xml' \
'r-xlconnect' \
'r-xml2' \
'r-testthat' \
'r-systemfonts' \
'r-ragg' 

# for fonts to work otherwise default unix ones are DejaVu
# conda:
conda install -y  --no-update-deps \
'fonts-conda-ecosystem' \
'mscorefonts' 
# r-conda:
conda install -y  --no-update-deps \
'r-nloptr' \
'r-polyclip' 
# bioc-package:
Rscript -e 'BiocManager::install("limma", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("vsn", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("edgeR", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("org.Hs.eg.db", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("org.Mm.eg.db", dependencies=TRUE, Ncpus=8)'

# r-conda:
conda install -y  --no-update-deps \
'r-tzdb' \
'r-vroom' \
'r-readr' \
'r-readxl' \
'r-rcppannoy' \
'r-glmnet' 

# r-package:
Rscript -e 'install.packages("gdata", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'

# r-url:
Rscript -e 'remotes::install_url("https://cran.r-project.org/src/contrib/Archive/NanoStringNorm/NanoStringNorm_1.2.1.1.tar.gz", dependencies=TRUE, Ncpus=8)'

# r-package:
Rscript -e 'install.packages("bedr", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("SIMMS", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("haven", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("foreign", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("spatstat", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'

# required for sequenze to work with hg38. Default copy number package from BioConductor does not support beyond hg19
# r-url:
Rscript -e 'remotes::install_url("https://github.com/aroneklund/copynumber/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'

# these wont install happily from install.packages (needed for FactoMineR)
# r-conda:
conda install -y  --no-update-deps \
'r-rcpparmadillo' \
'r-conquer' \
'r-minqa' \
'r-lme4' 
# r-package:
Rscript -e 'install.packages("FactoMineR", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("factoextra", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'

# conda:
conda install -y  --no-update-deps \
'patch' 
# r-conda:
conda install -y  --no-update-deps \
'r-gifski' 
# r-package:
#- TFMPvalue
Rscript -e 'install.packages("otelsdk", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("knitr", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("rmarkdown", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("inline", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'

# r-conda:
conda install -y  --no-update-deps \
'r-rjson' \
'r-interp' 
# bioc-package:
Rscript -e 'BiocManager::install("biomaRt", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("rtracklayer", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("GenomicFeatures", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("BSgenome", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("VariantAnnotation", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("ensembldb", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("biovizBase", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("Gviz", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("GenomicInteractions", dependencies=TRUE, Ncpus=8)'

# r-package:
Rscript -e 'install.packages("distributions3", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("mboost", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("AER", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("brglm2", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("flexmix", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("modelsummary", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("nonnest2", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("tinytest", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("UpSetR", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("plotrix", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("gplots", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("drc", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'

# r-package:
Rscript -e 'install.packages("countreg", repos="https://R-Forge.R-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("chicane", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'

# r-conda:
conda install -y  --no-update-deps \
'r-v8' 
# bioc-package:
Rscript -e 'BiocManager::install("multtest", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("GSEABase", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("reshape", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("TeachingDemos", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("tidyverse", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("SingleR", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("scran", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("celldex", dependencies=TRUE, Ncpus=8)'

# # needed for ArchR and scater
# r-conda:
conda install -y  --no-update-deps \
'r-cairo' 
# bioc-package:
Rscript -e 'BiocManager::install("scater", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("cellHTS2", dependencies=TRUE, Ncpus=8)'

# bioc-package:
Rscript -e 'BiocManager::install("MAST", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("impute", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("genefu", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("fastseg", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("methylKit", dependencies=TRUE, Ncpus=8)'

# r-package:
Rscript -e 'install.packages("tidyverse", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("argparser", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("stringdist", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'

# bioc-package:
Rscript -e 'BiocManager::install("BSgenome.Hsapiens.NCBI.GRCh38", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("genomation", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("ggbio", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("TxDb.Hsapiens.UCSC.hg38.knownGene", dependencies=TRUE, Ncpus=8)'

# r-url:
Rscript -e 'remotes::install_url("https://github.com/Nik-Zainal-Group/signature.tools.lib/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'

# r-package:
Rscript -e 'install.packages("Signac", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
# bioc-package:
Rscript -e 'BiocManager::install("EnsDb.Hsapiens.v86", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("harmony", dependencies=TRUE, Ncpus=8)'
# conda:
conda install -y  --no-update-deps \
'hdf5' 
# r-package:
Rscript -e 'install.packages("hdf5r", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'

# r-conda:
conda install -y  --no-update-deps \
'r-rjags' 
# bioc-package:
Rscript -e 'BiocManager::install("infercnv", dependencies=TRUE, Ncpus=8)'

# r-url:
Rscript -e 'remotes::install_url("https://github.com/hdng/clonevol/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'
# r-package:
Rscript -e 'install.packages("packcircles", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'

#r-conda:
#  - pdftools
#  - s2
#  - sf
#bioc-conda:
#  - tfbstools
#bioc-package:
#  - chromVAR
#  - ComplexHeatmap
#  - motifmatchr
#  - slingshot
#  - grr
# r-conda:
#  - TFMPvalue
#r-url:
#  - https://github.com/GreenleafLab/ArchR/archive/refs/heads/master.zip

#bash:
#  - Rscript -e "ArchR::installExtraPackages()"

# r-url:
Rscript -e 'remotes::install_url("https://github.com/satijalab/seurat-wrappers/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'

# bioc-package:
Rscript -e 'BiocManager::install("ShortRead", dependencies=TRUE, Ncpus=8)'

# r-conda:
conda install -y  --no-update-deps \
'r-eulerr' 

# r-url:
Rscript -e 'remotes::install_url("https://github.com/xmc811/Scillus/archive/refs/heads/development.zip", dependencies=TRUE, Ncpus=8)'
Rscript -e 'remotes::install_url("https://github.com/VanLoo-lab/ascat/archive/refs/heads/master.zip@ASCAT", dependencies=TRUE, subdir=ASCAT, Ncpus=8)'
Rscript -e 'remotes::install_url("https://github.com/chris-mcginnis-ucsf/DoubletFinder/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'
# r-package:
Rscript -e 'install.packages("clustree", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'

# bioc-package:
Rscript -e 'BiocManager::install("Chicago", dependencies=TRUE, Ncpus=8)'

# r-url:
Rscript -e 'remotes::install_url("https://github.com/carmonalab/STACAS/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'

# bioc-package:
Rscript -e 'BiocManager::install("batchelor", dependencies=TRUE, Ncpus=8)'

# r-url:
Rscript -e 'remotes::install_url("https://cran.r-project.org/src/contrib/Archive/CIDER/CIDER_0.99.4.tar.gz", dependencies=TRUE, Ncpus=8)'
Rscript -e 'remotes::install_url("https://github.com/zhiyuan-hu-lab/CIDER/archive/refs/heads/main.zip", dependencies=TRUE, Ncpus=8)'

# bioc-package:
Rscript -e 'BiocManager::install("GSVA", dependencies=TRUE, Ncpus=8)'
# r-url:
Rscript -e 'remotes::install_url("https://github.com/cansysbio/ConsensusTME/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'

# r-conda:
conda install -y  --no-update-deps \
'r-gdtools' 
# bioc-package:
Rscript -e 'BiocManager::install("pcaMethods", dependencies=TRUE, Ncpus=8)'
# r-url:
Rscript -e 'remotes::install_url("https://github.com/Shicheng-Guo/DeconRNASeq/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'
Rscript -e 'remotes::install_url("https://github.com/EDePasquale/DoubletDecon/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'

# bioc-package:
Rscript -e 'BiocManager::install("Rsubread", dependencies=TRUE, Ncpus=8)'

# # conda install -c davidaknowles r-leafcutter # FAILED see below for an alternative route
# Rscript -e "install.packages('rstan', repos='https://cloud.r-project.org')"
# Rscript -e "devtools::install_url('https://github.com/stan-dev/rstantools/archive/refs/heads/master.zip', dependencies = FALSE)"
# Rscript -e "devtools::install_url('https://github.com/davidaknowles/leafcutter/archive/refs/heads/master.zip', subdir='leafcutter', dependencies = TRUE)"
# conda install -y davidaknowles::r-leafcutter --freeze-installed

# bioc-package:
Rscript -e 'BiocManager::install("liftOver", dependencies=TRUE, Ncpus=8)'

# r-conda:
conda install -y  --no-update-deps \
'r-seqminer' 
# r-package:
Rscript -e 'install.packages("squash", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("iotools", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
# r-url:
Rscript -e 'remotes::install_url("https://cran.r-project.org/src/contrib/Archive/sequenza/sequenza_3.0.0.tar.gz", dependencies=TRUE, Ncpus=8)'

# bioc-package:
Rscript -e 'BiocManager::install("glmGamPoi", dependencies=TRUE, Ncpus=8)'
# r-url:
Rscript -e 'remotes::install_url("https://github.com/satijalab/sctransform/archive/refs/heads/develop.zip", dependencies=TRUE, Ncpus=8)'

# r-package:
Rscript -e 'install.packages("Ckmeans.1d.dp", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'

# r-url:
Rscript -e 'remotes::install_url("https://cran.r-project.org/src/contrib/Archive/modes/modes_0.7.0.tar.gz", dependencies=TRUE, Ncpus=8)'

# r-package:
Rscript -e 'install.packages("dynamicTreeCut", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("roll", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
# r-url:
Rscript -e 'remotes::install_url("https://github.com/cole-trapnell-lab/monocle3/archive/refs/heads/develop.zip", dependencies=TRUE, Ncpus=8)'

# r-package:
Rscript -e 'install.packages("LDlinkR", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("randomForest", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'

# bioc-package:
Rscript -e 'BiocManager::install("multiGSEA", dependencies=TRUE, Ncpus=8)'

# r-url:
Rscript -e 'remotes::install_url("http://research-pub.gene.com/REdiscoverTEpaper/data/REdiscoverTEdata_1.0.1.tar.gz", dependencies=TRUE, Ncpus=8)'
Rscript -e 'remotes::install_url("https://cran.r-project.org/src/contrib/Archive/Matrix.utils/Matrix.utils_0.9.8.tar.gz", dependencies=TRUE, Ncpus=8)'
Rscript -e 'remotes::install_url("https://github.com/karakulahg/TEffectR/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'

# bioc-package:
Rscript -e 'BiocManager::install("minfi", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("IlluminaHumanMethylationEPICanno.ilm10b4.hg19", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("IlluminaHumanMethylationEPICmanifest", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("missMethyl", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("minfiData", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("DMRcate", dependencies=TRUE, Ncpus=8)'

# bash:
Rscript -e "BiocManager::install('preprocessCore', configure.args='--disable-threading', force = TRUE)"

# r-package:
Rscript -e 'install.packages("clusterSim", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("clv", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
# r-url:
Rscript -e 'remotes::install_url("https://github.com/saeyslab/nichenetr/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'

# bioc-package:
Rscript -e 'BiocManager::install("kstreet13/slingshot", dependencies=TRUE, Ncpus=8)'

# r-conda:
conda install -y  --no-update-deps \
'r-ncdf4' 
# r-package:
Rscript -e 'install.packages("HiClimR", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("ccaPP", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("egg", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
# bioc-package:
Rscript -e 'BiocManager::install("sva", dependencies=TRUE, Ncpus=8)'
# r-url:
Rscript -e 'remotes::install_url("https://github.com/digitalcytometry/cytotrace2/archive/refs/heads/main.zip@cytotrace2_r", dependencies=TRUE, subdir=cytotrace2_r, Ncpus=8)'
# pip:
python -m pip install 'scanoramaCT' 

# r-conda:
conda install -y  --no-update-deps \
'r-rpostgres' 
# r-url:
Rscript -e 'remotes::install_url("https://github.com/PriceLab/ghdb/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'

# bioc-package:
Rscript -e 'BiocManager::install("destiny", dependencies=TRUE, Ncpus=8)'

# r-package:
Rscript -e 'install.packages("openssl", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("pracma", repos="https://R-Forge.R-project.org", dependencies=TRUE, Ncpus=8)'

# r-url:
Rscript -e 'remotes::install_url("https://github.com/trevorld/r-optparse/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'

# r-conda:
conda install -y  --no-update-deps \
'r-mcmcpack' 
# r-package:
Rscript -e 'install.packages("mvtnorm", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("ellipse", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("coda", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("Matrix", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("Rtsne", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("gtools", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("foreach", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("doParallel", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("doSNOW", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("snow", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("lattice", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("MASS", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("bayesm", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("robustbase", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("chron", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("mnormt", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("schoolmath", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("RColorBrewer", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'

# bioc-package:
Rscript -e 'BiocManager::install("DEXSeq", dependencies=TRUE, Ncpus=8)'

# # for R package SCENIC
# r-conda:
conda install -y  --no-update-deps \
'r-arrow' 
# bioc-package:
Rscript -e 'BiocManager::install("AUCell", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("RcisTarget", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("GENIE3", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("R2HTML", dependencies=TRUE, Ncpus=8)'
# r-url:
Rscript -e 'remotes::install_url("https://github.com/bokeh/rbokeh/archive/refs/heads/main.zip", dependencies=TRUE, Ncpus=8)'
Rscript -e 'remotes::install_url("https://github.com/aertslab/SCopeLoomR/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'
Rscript -e 'remotes::install_url("https://github.com/aertslab/SCENIC/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'
# r-package:
Rscript -e 'install.packages("ISOpureR", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("DiffCorr", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'

# r-url:
Rscript -e 'remotes::install_url("https://github.com/broadinstitute/cdsr_models/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'
Rscript -e 'remotes::install_url("https://github.com/PhanstielLab/Sushi/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'
# bioc-package:
Rscript -e 'BiocManager::install("ChromSCape", dependencies=TRUE, Ncpus=8)'

# r-url:
Rscript -e 'remotes::install_url("https://github.com/sztup/scarHRD/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'
Rscript -e 'remotes::install_url("https://github.com/guokai8/scGSVA/archive/refs/heads/main.zip", dependencies=TRUE, Ncpus=8)'

# bioc-package:
Rscript -e 'BiocManager::install("reactome.db", dependencies=TRUE, Ncpus=8)'
# pip:
python -m pip install 'spatialde' 

# r-package:
Rscript -e 'install.packages("poolr", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("tsne", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("fpc", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'

# r-url:
Rscript -e 'remotes::install_url("https://github.com/cit-bioinfo/mMCP-counter/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'
Rscript -e 'remotes::install_url("https://github.com/mojaveazure/seurat-disk/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'

# r-package:
Rscript -e 'install.packages("immunarch", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("strawr", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
# r-url:
Rscript -e 'remotes::install_url("https://github.com/kharchenkolab/numbat/archive/refs/heads/main.zip", dependencies=TRUE, Ncpus=8)'

# r-package:
Rscript -e 'install.packages("keras", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("ijtiff", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("bbmle", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'

# r-url:
Rscript -e 'remotes::install_url("https://github.com/choisy/cutoff/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'
Rscript -e 'remotes::install_url("https://bioconductor.org/packages/3.19/bioc/src/contrib/zlibbioc_1.50.0.tar.gz", dependencies=TRUE, Ncpus=8)'

# bioc-package:
Rscript -e 'BiocManager::install("PoisonAlien/maftools", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("illuminaHumanv4.db", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("zellkonverter", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("NanoStringNCTools", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("GeomxTools", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("GeoMxWorkflows", dependencies=TRUE, Ncpus=8)'

# r-package:
Rscript -e 'install.packages("openxlsx", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'

# conda install -y bioconda::bioconductor-cellhts2 --freeze-installed # FAILED

# # for custom gitlab.py script to work if this R is loaded
# pip:
python -m pip install 'requests' 

# bioc-package:
Rscript -e 'BiocManager::install("Orthology.eg.db", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("viper", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("dorothea", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("aracne.networks", dependencies=TRUE, Ncpus=8)'
Rscript -e 'BiocManager::install("scDblFinder", dependencies=TRUE, Ncpus=8)'

# r-package:
Rscript -e 'install.packages("effsize", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("enrichR", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'

# pip:
python -m pip install 'PyYAML' 
python -m pip install 'radian' 

# r-package:
Rscript -e 'install.packages("languageserver", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("unigd", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("AsioHeaders", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'
Rscript -e 'install.packages("seqinr", repos="https://cloud.r-project.org", dependencies=TRUE, Ncpus=8)'

# r-url:
Rscript -e 'remotes::install_url("https://cran.r-project.org/src/contrib/Archive/httpgd/httpgd_2.0.4.tar.gz", dependencies=TRUE, Ncpus=8)'
Rscript -e 'remotes::install_url("https://github.com/munoztd0/reprtree/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'
Rscript -e 'remotes::install_url("https://github.com/carmonalab/ProjecTILs/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'
Rscript -e 'remotes::install_url("https://github.com/carmonalab/SignatuR/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'
Rscript -e 'remotes::install_url("https://github.com/vladchimescu/lpsymphony/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'
Rscript -e 'remotes::install_url("https://github.com/nignatiadis/IHW/archive/refs/heads/master.zip", dependencies=TRUE, Ncpus=8)'
Rscript -e 'remotes::install_url("https://github.com/saeyslab/multinichenetr/archive/refs/heads/main.zip", dependencies=TRUE, Ncpus=8)'
Rscript -e 'remotes::install_url("https://github.com/jinworks/CellChat/archive/refs/heads/main.zip", dependencies=TRUE, Ncpus=8)'

# Install rgeos from CRAN archive with compiler flags
# conda:
conda install -y  --no-update-deps \
'geos' 
# r-url:
Rscript -e 'remotes::install_url("https://cran.r-project.org/src/contrib/Archive/sp/sp_2.1-3.tar.gz", dependencies=TRUE, Ncpus=8)'
#bash:
#  - CFLAGS="-std=gnu89" R -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/rgeos/rgeos_0.6-4.tar.gz", repos=NULL, type="source")'
# r-url:
Rscript -e 'remotes::install_url("https://cran.r-project.org/src/contrib/Archive/rgeos/rgeos_0.6-4.tar.gz", dependencies=TRUE, Ncpus=8)'
Rscript -e 'remotes::install_url("https://github.com/rachelicr/r-maptools/archive/refs/heads/main.zip", dependencies=TRUE, Ncpus=8)'



