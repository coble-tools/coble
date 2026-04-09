#!/usr/bin/env bash

# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi

conda env remove --name carbine -y 2>/dev/null || true
conda create --no-default-packages --name carbine -y
conda activate carbine

conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels defaults
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

conda install -y --solver=libmamba --no-update-deps 'r-base=4.4.3'
conda install -y --solver=libmamba --no-update-deps r-remotes r-biocmanager r-renv
conda install -y --solver=libmamba --no-update-deps 'python=3.12'

conda install -y --solver=libmamba --no-update-deps -c conda-forge compilers
R CMD javareconf

conda install -y --solver=libmamba --no-update-deps -c conda-forge compilers
conda env config vars set QT_QPA_PLATFORM=offscreen
export QT_QPA_PLATFORM=offscreen
conda env config vars set OTEL_SDK_DISABLED=true
export OTEL_SDK_DISABLED=true
conda env config vars set R_OTEL_DISABLED=true
export R_OTEL_DISABLED=true

conda install -y --solver=libmamba --no-update-deps \
cmdstan=2.38.0

conda env config vars set CMDSTAN=$CONDA_PREFIX/bin/cmdstan
export CMDSTAN=$CONDA_PREFIX/bin/cmdstan

conda install -y --solver=libmamba --no-update-deps \
zlib \
arviz=0.23.4 \
pytz \
cmdstanpy=1.3.0

ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ]; then TRIPLET="${ARCH}-conda-linux-gnu"; fi
if [ "$ARCH" = "aarch64" ]; then CMDSTAN_PATH=$(python -c 'import cmdstanpy; print(cmdstanpy.cmdstan_path())'); fi
if [ "$ARCH" = "aarch64" ]; then echo "CXXFLAGS_OS = --sysroot=$CONDA_PREFIX/${TRIPLET}/sysroot" >> "$CMDSTAN_PATH/make/local"; fi
if [ "$ARCH" = "aarch64" ]; then echo "TBB_CXX_TYPE = gcc" >> "$CMDSTAN_PATH/make/local"; fi
if [ "$ARCH" = "aarch64" ]; then echo "CPPFLAGS =" >> "$CMDSTAN_PATH/make/local"; fi

conda install -y --solver=libmamba --no-update-deps \
ipython \
matplotlib \
pandas=3.0.0 \
scipy=1.17.0 \
seaborn=0.13.2 \
xz

conda install -y --solver=libmamba --no-update-deps \
'r-doBy' \
'r-pbkrtest' \
'r-car' \
'r-rstatix' \
'r-sads' \
'r-tidyverse' \
'r-tidytable' \
'r-pio' \
'r-easypar' \
'r-dndscv' \
'r-permute' \
'r-vegan' \
'r-shiny'

Rscript -e 'install.packages("vcfR", repos="https://packagemanager.posit.co/cran/2026-02-01", dependencies=NA, Ncpus=1, method="wget")'
Rscript -e 'install.packages("covr", repos="https://packagemanager.posit.co/cran/2026-02-01", dependencies=NA, Ncpus=1, method="wget")'
Rscript -e 'install.packages("partykit", repos="https://packagemanager.posit.co/cran/2026-02-01", dependencies=NA, Ncpus=1, method="wget")'

conda install -y --solver=libmamba --no-update-deps \
'r-biocmanager' \
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

Rscript -e 'install.packages("ggpubr", repos="https://packagemanager.posit.co/cran/2026-02-01", dependencies=NA, Ncpus=1, method="wget")'
Rscript -e 'install.packages("ggsci", repos="https://packagemanager.posit.co/cran/2026-02-01", dependencies=NA, Ncpus=1, method="wget")'

conda install -y --solver=libmamba --no-update-deps \
'bioconda::bioconductor-rtracklayer=1.66.0' \
'bioconda::bioconductor-genomicfeatures=1.58.0' \
'bioconda::bioconductor-delayedarray=0.32.0' \
'bioconda::bioconductor-summarizedexperiment=1.36.0' \
'bioconda::bioconductor-genomicalignments=1.42.0'

Rscript -e 'BiocManager::install("TxDb.Hsapiens.UCSC.hg19.knownGene", dependencies=NA, Ncpus=1)'
Rscript -e 'BiocManager::install("BSgenome.Hsapiens.UCSC.hg19", dependencies=NA, Ncpus=1)'
Rscript -e 'BiocManager::install("AnnotationDbi", dependencies=NA, Ncpus=1)'
Rscript -e 'BiocManager::install("ComplexHeatmap", dependencies=NA, Ncpus=1)'
Rscript -e 'BiocManager::install("VariantAnnotation", dependencies=NA, Ncpus=1)'

Rscript -e 'remotes::install_url("https://github.com/im3sanger/dndscv/archive/refs/heads/master.tar.gz", repos="https://packagemanager.posit.co/cran/2026-02-01",dependencies=NA, upgrade="default", Ncpus=1)'
Rscript -e 'remotes::install_url("https://github.com/caravagnalab/CNAqc/archive/refs/heads/master.tar.gz", repos="https://packagemanager.posit.co/cran/2026-02-01",dependencies=NA, upgrade="default", Ncpus=1)'
Rscript -e 'remotes::install_url("https://github.com/caravagnalab/ctree/archive/refs/heads/master.tar.gz", repos="https://packagemanager.posit.co/cran/2026-02-01",dependencies=NA, upgrade="default", Ncpus=1)'
Rscript -e 'remotes::install_url("https://github.com/caravagnalab/VIBER/archive/refs/heads/master.tar.gz", repos="https://packagemanager.posit.co/cran/2026-02-01",dependencies=NA, upgrade="default", Ncpus=1)'
Rscript -e 'remotes::install_url("https://github.com/caravagn/evoverse/archive/refs/heads/development.tar.gz", repos="https://packagemanager.posit.co/cran/2026-02-01",dependencies=NA, upgrade="default", Ncpus=1)'
Rscript -e 'remotes::install_url("https://github.com/caravagnalab/mobster/archive/refs/heads/binomial_noise.tar.gz", repos="https://packagemanager.posit.co/cran/2026-02-01",dependencies=NA, upgrade="default", Ncpus=1)'


