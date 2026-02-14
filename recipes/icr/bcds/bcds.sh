#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-14
# Capture time: 16:47:10 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi
# Using conda executable conda: /home/ralcraft/miniforge3/bin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/bin/conda
#####################################################

conda env remove --name bcds -y 2>/dev/null || true
conda create --no-default-packages --name bcds -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate bcds

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
##########################################################
# COBLE: Breast Cancer Data Science, (c) ICR 2026
##########################################################
# compilers:
# Flag: Directive: cran-repo, Value: 

# Language compile tools
conda install -y --no-update-deps -c conda-forge compilers
# languages:
CONDA_BASE=$(conda info --base)
ARCH=$(uname -m)

conda install -y  -c conda-forge 'r-base=4.5.2'
conda install -y  'conda-forge::python=3.14.0'
python -m site
conda env config vars set PYTHONNOUSERSITE=1
export PYTHONNOUSERSITE=1
# flags:
# Flag: Directive: dependencies, Value: na
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
Rscript -e 'BiocManager::install("fgsea", dependencies=NA, Ncpus=8)'

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
Rscript -e 'BiocManager::install("stJoincount", dependencies=NA, Ncpus=8)'

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
Rscript -e 'BiocManager::install("limma", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("vsn", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("edgeR", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("org.Hs.eg.db", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("org.Mm.eg.db", dependencies=NA, Ncpus=8)'

# r-conda:
conda install -y  --no-update-deps \
'r-tzdb' \
'r-vroom' \
'r-readr' \
'r-readxl' \
'r-rcppannoy' \
'r-glmnet' 

# r-package:
Rscript -e 'install.packages("gdata", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'

# r-url:
Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/NanoStringNorm/NanoStringNorm_1.2.1.1.tar.gz', repos=NULL, type='source', method='wget')"

# r-package:
Rscript -e 'install.packages("bedr", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("SIMMS", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("haven", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("foreign", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("spatstat", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'

# required for sequenze to work with hg38. Default copy number package from BioConductor does not support beyond hg19
# r-url:
Rscript -e "install.packages('https://github.com/aroneklund/copynumber/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"

# these wont install happily from install.packages (needed for FactoMineR)
# r-conda:
conda install -y  --no-update-deps \
'r-rcpparmadillo' \
'r-conquer' \
'r-minqa' \
'r-lme4' 
# r-package:
Rscript -e 'install.packages("FactoMineR", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("factoextra", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'

# conda:
conda install -y  --no-update-deps \
'patch' 
# r-conda:
conda install -y  --no-update-deps \
'r-gifski' 
# r-package:
Rscript -e 'install.packages("otelsdk", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("knitr", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("rmarkdown", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("inline", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'

# r-conda:
conda install -y  --no-update-deps \
'r-rjson' \
'r-interp' 
# bioc-package:
Rscript -e 'BiocManager::install("biomaRt", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("rtracklayer", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("GenomicFeatures", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("BSgenome", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("VariantAnnotation", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("ensembldb", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("biovizBase", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("Gviz", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("GenomicInteractions", dependencies=NA, Ncpus=8)'

# r-package:
Rscript -e 'install.packages("distributions3", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("mboost", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("AER", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("brglm2", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("flexmix", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("modelsummary", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("nonnest2", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("tinytest", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("UpSetR", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("plotrix", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("gplots", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("drc", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'

# r-github:
Rscript -e 'remotes::install_github("r-forge/countreg", dependencies=NA, upgrade="default", subdir="pkg", Ncpus=8)'
# r-package:
Rscript -e 'install.packages("chicane", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'

# r-conda:
conda install -y  --no-update-deps \
'r-v8' \
'r-arrow' 
# bioc-package:
Rscript -e 'BiocManager::install("multtest", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("GSEABase", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("reshape", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("TeachingDemos", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("tidyverse", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("SingleR", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("scran", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("Rhdf5lib", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("celldex", dependencies=NA, Ncpus=8)'

# # needed for ArchR and scater
# r-conda:
conda install -y  --no-update-deps \
'r-cairo' 
# bioc-package:
Rscript -e 'BiocManager::install("scater", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("cellHTS2", dependencies=NA, Ncpus=8)'

# bioc-package:
Rscript -e 'BiocManager::install("MAST", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("impute", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("genefu", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("fastseg", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("methylKit", dependencies=NA, Ncpus=8)'

# r-package:
Rscript -e 'install.packages("tidyverse", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("argparser", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("stringdist", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'

# bioc-package:
Rscript -e 'BiocManager::install("BSgenome.Hsapiens.NCBI.GRCh38", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("genomation", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("ggbio", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("TxDb.Hsapiens.UCSC.hg38.knownGene", dependencies=NA, Ncpus=8)'

# r-url:
Rscript -e "install.packages('https://github.com/Nik-Zainal-Group/signature.tools.lib/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"

# r-package:
Rscript -e 'install.packages("Signac", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
# bioc-package:
Rscript -e 'BiocManager::install("EnsDb.Hsapiens.v86", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("harmony", dependencies=NA, Ncpus=8)'
# conda:
conda install -y  --no-update-deps \
'hdf5' 
# r-package:
Rscript -e 'install.packages("hdf5r", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'

# r-conda:
conda install -y  --no-update-deps \
'r-rjags' 
# bioc-package:
Rscript -e 'BiocManager::install("infercnv", dependencies=NA, Ncpus=8)'

# r-url:
Rscript -e "install.packages('https://github.com/hdng/clonevol/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"
# r-package:
Rscript -e 'install.packages("packcircles", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'

# r-conda:
conda install -y  --no-update-deps \
'r-pdftools' \
'r-s2' \
'r-sf' 
#r-conda:
#  - TFMPvalue@r
#r-package:
#  - TFMPvalue
#bioc-conda:
#  - tfbstools
#bioc-package:
#  - TFBSTools
# r-github:
Rscript -e 'remotes::install_github("ge11232002/TFMPvalue", dependencies=NA, upgrade="default", Ncpus=8)'
# bioc-package:
Rscript -e 'BiocManager::install("chromVAR", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("ComplexHeatmap", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("motifmatchr", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("slingshot", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("grr", dependencies=NA, Ncpus=8)'
# r-conda:
conda install -y  --no-update-deps \
'r-TFMPvalue' 
# r-url:
Rscript -e "install.packages('https://github.com/GreenleafLab/ArchR/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"
# bash:
Rscript -e "ArchR::installExtraPackages()"

# r-conda:
conda install -y  --no-update-deps \
'r-grr' 
# r-url:
Rscript -e "install.packages('https://github.com/satijalab/seurat-wrappers/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"

# bioc-package:
Rscript -e 'BiocManager::install("ShortRead", dependencies=NA, Ncpus=8)'

# r-conda:
conda install -y  --no-update-deps \
'r-eulerr' 

# r-url:
Rscript -e "install.packages('https://github.com/xmc811/Scillus/archive/refs/heads/development.zip', repos=NULL, type='source', method='wget')"
Rscript -e 'remotes::install_url("https://github.com/VanLoo-lab/ascat/archive/refs/heads/master.zip", dependencies=NA, upgrade="default", subdir="ASCAT", Ncpus=8)'
Rscript -e "install.packages('https://github.com/chris-mcginnis-ucsf/DoubletFinder/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"
# r-package:
Rscript -e 'install.packages("clustree", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'

# bioc-package:
Rscript -e 'BiocManager::install("Chicago", dependencies=NA, Ncpus=8)'

# r-url:
Rscript -e "install.packages('https://github.com/carmonalab/STACAS/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"

# bioc-package:
Rscript -e 'BiocManager::install("batchelor", dependencies=NA, Ncpus=8)'

# r-url:
Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/CIDER/CIDER_0.99.4.tar.gz', repos=NULL, type='source', method='wget')"
Rscript -e "install.packages('https://github.com/zhiyuan-hu-lab/CIDER/archive/refs/heads/main.zip', repos=NULL, type='source', method='wget')"

# bioc-package:
Rscript -e 'BiocManager::install("GSVA", dependencies=NA, Ncpus=8)'
# r-url:
Rscript -e "install.packages('https://github.com/cansysbio/ConsensusTME/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"

# r-conda:
conda install -y  --no-update-deps \
'r-gdtools' 
# bioc-package:
Rscript -e 'BiocManager::install("pcaMethods", dependencies=NA, Ncpus=8)'
# r-url:
Rscript -e "install.packages('https://github.com/Shicheng-Guo/DeconRNASeq/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"
Rscript -e "install.packages('https://github.com/EDePasquale/DoubletDecon/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"

# bioc-package:
Rscript -e 'BiocManager::install("Rsubread", dependencies=NA, Ncpus=8)'

# leafcutter section
# conda:
conda install -y  --no-update-deps \
'tbb<2021' \
'tbb-devel<2021' 
# r-package:
Rscript -e 'install.packages("RcppEigen", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("RcppParallel", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("inline", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("gridExtra", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("loo", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("pkgbuild", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("V8", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("BH", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
# bash:
# StanHeaders with flags
CXX14FLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive" \
CXX17FLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive" \
CXXFLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive -I$CONDA_PREFIX/include" \
MAKEFLAGS="-j1" \
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/StanHeaders/StanHeaders_2.21.0-7.tar.gz", repos=NULL, type="source")'
# rstan with flags
CXX14FLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive" \
CXX17FLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive" \
CXXFLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive -I$CONDA_PREFIX/include" \
MAKEFLAGS="-j1" \
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/rstan/rstan_2.21.2.tar.gz", repos=NULL, type="source")'
# bioc-package:
Rscript -e 'BiocManager::install("DirichletMultinomial", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("TailRank", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("Biobase", dependencies=NA, Ncpus=8)'
# bash:
# leafcutter with flags
CXX14FLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive" \
CXX17FLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive" \
CXXFLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive -I$CONDA_PREFIX/include" \
MAKEFLAGS="-j1" \
Rscript -e 'remotes::install_github("davidaknowles/leafcutter/leafcutter", upgrade="never", Ncpus=8)'
##########################

# bioc-package:
Rscript -e 'BiocManager::install("liftOver", dependencies=NA, Ncpus=8)'

# r-conda:
conda install -y  --no-update-deps \
'r-seqminer' 
# r-package:
Rscript -e 'install.packages("squash", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("iotools", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
# r-url:
Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/sequenza/sequenza_3.0.0.tar.gz', repos=NULL, type='source', method='wget')"

# bioc-package:
Rscript -e 'BiocManager::install("glmGamPoi", dependencies=NA, Ncpus=8)'
# r-url:
Rscript -e "install.packages('https://github.com/satijalab/sctransform/archive/refs/heads/develop.zip', repos=NULL, type='source', method='wget')"

# r-package:
Rscript -e 'install.packages("Ckmeans.1d.dp", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'

# r-url:
Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/modes/modes_0.7.0.tar.gz', repos=NULL, type='source', method='wget')"

# r-package:
Rscript -e 'install.packages("dynamicTreeCut", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("roll", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
# r-url:
Rscript -e "install.packages('https://github.com/cole-trapnell-lab/monocle3/archive/refs/heads/develop.zip', repos=NULL, type='source', method='wget')"

# r-package:
Rscript -e 'install.packages("LDlinkR", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("randomForest", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'

# bioc-package:
Rscript -e 'BiocManager::install("multiGSEA", dependencies=NA, Ncpus=8)'

# r-url:
Rscript -e "install.packages('http://research-pub.gene.com/REdiscoverTEpaper/data/REdiscoverTEdata_1.0.1.tar.gz', repos=NULL, type='source', method='wget')"
Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/Matrix.utils/Matrix.utils_0.9.8.tar.gz', repos=NULL, type='source', method='wget')"
Rscript -e "install.packages('https://github.com/karakulahg/TEffectR/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"

# bioc-package:
Rscript -e 'BiocManager::install("minfi", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("IlluminaHumanMethylationEPICanno.ilm10b4.hg19", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("IlluminaHumanMethylationEPICmanifest", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("missMethyl", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("minfiData", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("DMRcate", dependencies=NA, Ncpus=8)'

# bash:
Rscript -e "BiocManager::install('preprocessCore', configure.args='--disable-threading', force = TRUE)"

# r-package:
Rscript -e 'install.packages("clusterSim", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
# r-url:
Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/clv/clv_0.3-2.5.tar.gz', repos=NULL, type='source', method='wget')"
Rscript -e "install.packages('https://github.com/saeyslab/nichenetr/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"

# bioc-package:
Rscript -e 'BiocManager::install("kstreet13/slingshot", dependencies=NA, Ncpus=8)'

# r-conda:
conda install -y  --no-update-deps \
'r-ncdf4' 
# r-package:
Rscript -e 'install.packages("HiClimR", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("ccaPP", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("egg", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
# bioc-package:
Rscript -e 'BiocManager::install("sva", dependencies=NA, Ncpus=8)'
# r-url:
Rscript -e 'remotes::install_url("https://github.com/digitalcytometry/cytotrace2/archive/refs/heads/main.zip", dependencies=NA, upgrade="default", subdir="cytotrace2_r", Ncpus=8)'
# pip:
python -m pip install 'scanoramaCT' 

# r-conda:
conda install -y  --no-update-deps \
'r-rpostgres' 
# r-url:
Rscript -e "install.packages('https://github.com/PriceLab/ghdb/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"

# bioc-package:
Rscript -e 'BiocManager::install("destiny", dependencies=NA, Ncpus=8)'

# r-package:
Rscript -e 'install.packages("openssl", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("pracma", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'

# r-url:
Rscript -e "install.packages('https://github.com/trevorld/r-optparse/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"

# r-conda:
conda install -y  --no-update-deps \
'r-mcmcpack' 
# r-package:
Rscript -e 'install.packages("mvtnorm", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("ellipse", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("coda", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("Matrix", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("Rtsne", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("gtools", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("foreach", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("doParallel", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("doSNOW", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("snow", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("lattice", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("MASS", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("bayesm", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("robustbase", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("chron", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("mnormt", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("schoolmath", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("RColorBrewer", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'

# bioc-package:
Rscript -e 'BiocManager::install("DEXSeq", dependencies=NA, Ncpus=8)'

# for R package SCENIC
# bioc-package:
Rscript -e 'BiocManager::install("AUCell", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("RcisTarget", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("GENIE3", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("R2HTML", dependencies=NA, Ncpus=8)'
# r-url:
Rscript -e "install.packages('https://github.com/bokeh/rbokeh/archive/refs/heads/main.zip', repos=NULL, type='source', method='wget')"
Rscript -e "install.packages('https://github.com/aertslab/SCopeLoomR/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"
# bash:
Rscript -e 'remotes::install_url("https://github.com/aertslab/SCENIC/archive/refs/heads/master.zip", dependencies=NA, Ncpus=8, upgrade="never")'


# r-package:
Rscript -e 'install.packages("ISOpureR", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("DiffCorr", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'

# r-url:
Rscript -e "install.packages('https://github.com/broadinstitute/cdsr_models/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"
Rscript -e "install.packages('https://github.com/PhanstielLab/Sushi/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"
# bioc-package:
Rscript -e 'BiocManager::install("ChromSCape", dependencies=NA, Ncpus=8)'

# r-url:
Rscript -e "install.packages('https://github.com/sztup/scarHRD/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"
Rscript -e "install.packages('https://github.com/guokai8/scGSVA/archive/refs/heads/main.zip', repos=NULL, type='source', method='wget')"

# bioc-package:
Rscript -e 'BiocManager::install("reactome.db", dependencies=NA, Ncpus=8)'
# pip:
python -m pip install 'spatialde' 

# r-package:
Rscript -e 'install.packages("poolr", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("tsne", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("fpc", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'

# r-url:
Rscript -e "install.packages('https://github.com/cit-bioinfo/mMCP-counter/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"
Rscript -e "install.packages('https://github.com/mojaveazure/seurat-disk/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"

# r-package:
Rscript -e 'install.packages("immunarch", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("strawr", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
# r-url:
Rscript -e "install.packages('https://github.com/kharchenkolab/numbat/archive/refs/heads/main.zip', repos=NULL, type='source', method='wget')"

# r-package:
Rscript -e 'install.packages("keras", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("ijtiff", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("bbmle", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'

# r-url:
Rscript -e "install.packages('https://github.com/choisy/cutoff/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"
Rscript -e "install.packages('https://bioconductor.org/packages/3.19/bioc/src/contrib/zlibbioc_1.50.0.tar.gz', repos=NULL, type='source', method='wget')"

# bioc-package:
Rscript -e 'BiocManager::install("PoisonAlien/maftools", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("illuminaHumanv4.db", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("zellkonverter", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("NanoStringNCTools", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("GeomxTools", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("GeoMxWorkflows", dependencies=NA, Ncpus=8)'

# r-package:
Rscript -e 'install.packages("openxlsx", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'

# for custom gitlab.py script to work if this R is loaded
# pip:
python -m pip install 'requests' 

# bioc-package:
Rscript -e 'BiocManager::install("Orthology.eg.db", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("viper", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("dorothea", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("aracne.networks", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("scDblFinder", dependencies=NA, Ncpus=8)'

# r-package:
Rscript -e 'install.packages("effsize", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("enrichR", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'

# pip:
python -m pip install 'PyYAML' 
python -m pip install 'radian' 

# r-package:
Rscript -e 'install.packages("languageserver", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("unigd", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("AsioHeaders", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'
Rscript -e 'install.packages("seqinr", repos="https://packagemanager.posit.co/cran/2020-04-01", dependencies=NA, Ncpus=8, method="wget")'

# r-url:
Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/httpgd/httpgd_2.0.4.tar.gz', repos=NULL, type='source', method='wget')"
Rscript -e "install.packages('https://github.com/munoztd0/reprtree/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"
Rscript -e "install.packages('https://github.com/carmonalab/ProjecTILs/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"
Rscript -e "install.packages('https://github.com/carmonalab/SignatuR/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"
# bioc-package:
Rscript -e 'BiocManager::install("lpsymphony", dependencies=NA, Ncpus=8)'
# r-url:
Rscript -e "install.packages('https://github.com/nignatiadis/IHW/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"
Rscript -e "install.packages('https://github.com/saeyslab/multinichenetr/archive/refs/heads/main.zip', repos=NULL, type='source', method='wget')"
Rscript -e "install.packages('https://github.com/jinworks/CellChat/archive/refs/heads/main.zip', repos=NULL, type='source', method='wget')"

# Maptools is deprecated but I did a fix to memory allocation
# conda:
conda install -y  --no-update-deps \
'geos' 
# r-url:
Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/sp/sp_2.1-3.tar.gz', repos=NULL, type='source', method='wget')"
Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/rgeos/rgeos_0.6-4.tar.gz', repos=NULL, type='source', method='wget')"
Rscript -e "install.packages('https://github.com/rachelicr/r-maptools/archive/refs/heads/main.zip', repos=NULL, type='source', method='wget')"

# r-github:
Rscript -e 'remotes::install_github("huayc09/SeuratExtend", dependencies=NA, upgrade="default", Ncpus=8)'


# Validate script available in environment at CONDA PREFIX: validate.sh
cp recipes/utils/bcds/validate/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh

