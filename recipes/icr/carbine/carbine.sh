#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-11
# Capture time: 22:03:46 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi
# Using conda executable conda: /home/ralcraft/miniforge3/condabin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/condabin/conda
#####################################################

conda env remove --name carbine -y 2>/dev/null || true
conda create --no-default-packages --name carbine -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y
# deactivate environment
conda deactivate | true
conda deactivate | true
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
# note the reverse order of priority
# compilers:

# Language compile tools
conda install -y --no-update-deps -c conda-forge 'gcc_linux-64=11' 'gxx_linux-64=11' 'gfortran_linux-64=11'
conda install -y --no-update-deps -c conda-forge sysroot_linux-64 c-compiler cxx-compiler
# Set up compiler symlinks for R package compilation - COS6 compatibility
umask 0022
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-gfortran
# Set up compiler symlinks for R package compilation - standard aliases
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/gcc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/c++
# Set compiler flags for R package compilation
conda env config vars set CC="/home/ralcraft/miniforge3/envs/carbine/bin/gcc"
conda env config vars set CXX="/home/ralcraft/miniforge3/envs/carbine/bin/g++"
conda env config vars set FC="/home/ralcraft/miniforge3/envs/carbine/bin/x86_64-conda-linux-gnu-gfortran"
conda env config vars set F77="/home/ralcraft/miniforge3/envs/carbine/bin/x86_64-conda-linux-gnu-gfortran"
conda env config vars set CFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set CXXFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set CPPFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib --sysroot=$CONDA_PREFIX/x86_64-conda-linux-gnu/sysroot"
# Also as export to avoid de/activations
export CC="/home/ralcraft/miniforge3/envs/carbine/bin/gcc"
export CXX="/home/ralcraft/miniforge3/envs/carbine/bin/g++"
export FC="/home/ralcraft/miniforge3/envs/carbine/bin/x86_64-conda-linux-gnu-gfortran"
export F77="/home/ralcraft/miniforge3/envs/carbine/bin/x86_64-conda-linux-gnu-gfortran"
export CFLAGS="-I$CONDA_PREFIX/include"
export CXXFLAGS="-I$CONDA_PREFIX/include"
export CPPFLAGS="-I$CONDA_PREFIX/include"
export LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib --sysroot=$CONDA_PREFIX/x86_64-conda-linux-gnu/sysroot"

# languages:
CONDA_BASE=$(conda info --base)
ARCH=$(uname -m)

conda install -y  'r-base=4.4.3' r-remotes r-biocmanager
conda install -y  'python=3.12'
python -m site
conda env config vars set PYTHONNOUSERSITE=1
export PYTHONNOUSERSITE=1
# flags:
# Flag: Directive: dependencies, Value: na
#- system-tools: True
conda env config vars set QT_QPA_PLATFORM=offscreen
export QT_QPA_PLATFORM=offscreen
conda env config vars set OTEL_SDK_DISABLED=true
export OTEL_SDK_DISABLED=true
conda env config vars set R_OTEL_DISABLED=true
export R_OTEL_DISABLED=true
# conda:
conda install -y  --no-update-deps \
'cmdstan=2.38.0' 
# conda:
conda install -y  --no-update-deps \
'arviz' \
'pytz' \
'cmdstanpy=1.3.0' \
'ipython' \
'matplotlib' \
'pandas=3.0.0' \
'scipy=1.17.0' \
'seaborn=0.13.2' \
'xz' 
# r-conda:
conda install -y  --no-update-deps \
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
Rscript -e 'install.packages("vcfR", repos="https://cloud.r-project.org/", dependencies=NA, Ncpus=1, method="wget")'
Rscript -e 'install.packages("covr", repos="https://cloud.r-project.org/", dependencies=NA, Ncpus=1, method="wget")'
Rscript -e 'install.packages("partykit", repos="https://cloud.r-project.org/", dependencies=NA, Ncpus=1, method="wget")'
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
Rscript -e 'install.packages("ggpubr", repos="https://cloud.r-project.org/", dependencies=NA, Ncpus=1, method="wget")'
Rscript -e 'install.packages("ggsci", repos="https://cloud.r-project.org/", dependencies=NA, Ncpus=1, method="wget")'
# bioc-conda:
conda install -y  --no-update-deps \
'bioconda::bioconductor-rtracklayer=1.66.0' \
'bioconda::bioconductor-genomicfeatures=1.58.0' \
'bioconda::bioconductor-delayedarray=0.32.0' \
'bioconda::bioconductor-summarizedexperiment=1.36.0' \
'bioconda::bioconductor-genomicalignments=1.42.0' 
# bioc-package:
Rscript -e 'BiocManager::install("TxDb.Hsapiens.UCSC.hg19.knownGene", dependencies=NA, Ncpus=1)'
Rscript -e 'BiocManager::install("BSgenome.Hsapiens.UCSC.hg19", dependencies=NA, Ncpus=1)'
Rscript -e 'BiocManager::install("AnnotationDbi", dependencies=NA, Ncpus=1)'
Rscript -e 'BiocManager::install("ComplexHeatmap", dependencies=NA, Ncpus=1)'
Rscript -e 'BiocManager::install("VariantAnnotation", dependencies=NA, Ncpus=1)'
# flags:
# Flag: Directive: dependencies, Value: false
# r-url:
Rscript -e "install.packages('https://github.com/im3sanger/dndscv/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"
Rscript -e "install.packages('https://github.com/caravagnalab/CNAqc/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"
Rscript -e "install.packages('https://github.com/caravagnalab/VIBER/archive/refs/heads/master.zip', repos=NULL, type='source', method='wget')"
Rscript -e "install.packages('https://github.com/caravagnalab/mobster/archive/refs/heads/binomial_noise.zip', repos=NULL, type='source', method='wget')"
Rscript -e "install.packages('https://github.com/caravagn/evoverse/archive/refs/heads/development.zip', repos=NULL, type='source', method='wget')"




# Validate script available in environment at CONDA PREFIX: validate.sh
cp recipes/icr/carbine/validate/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
# Extra validation file: run.stan
cp recipes/icr/carbine/validate//run.stan ${CONDA_PREFIX}/bin/run.stan
chmod +x ${CONDA_PREFIX}/bin/run.stan
# Extra validation file: run_stan.py
cp recipes/icr/carbine/validate//run_stan.py ${CONDA_PREFIX}/bin/run_stan.py
chmod +x ${CONDA_PREFIX}/bin/run_stan.py

