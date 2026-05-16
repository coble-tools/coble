#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-04-26
# Capture time: 13:22:11 BST
# Captured by: ralcraft
#####################################################
# source bashrc for conda
if [ -f ~/.bash_profile ]; then source ~/.bash_profile; elif [ -f ~/.bashrc ]; then source ~/.bashrc; elif command -v conda > /dev/null 2>&1; then eval "$(conda shell.bash hook)"; fi
# Using conda executable conda: /home/ralcraft/miniforge3/condabin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/condabin/conda
#####################################################

conda env remove --name tumori363 -y 2>/dev/null || true
conda create --no-default-packages --name tumori363 -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate tumori363

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --show channels | grep -q 'channels:' && conda config --env --remove-key channels || true
conda config --env --set channel_priority strict
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
# code/coble build --recipe recipes/papers/tumorigenesis/tumorigenesis363.cbl --env tumori363 --rebuild
#######################################
# compilers:
# Flag: Directive: cran-repo, Value: 
# flags:
# Compile version 7.5 on linux for architecture x86_64
conda install -y --solver=libmamba --no-update-deps -c conda-forge sysroot_linux-64 c-compiler cxx-compiler
# Detected Linux x86_64 - using linux-64 compilers
conda install -y --solver=libmamba --no-update-deps -c conda-forge 'gcc_linux-64=7.5' 'gxx_linux-64=7.5' 'gfortran_linux-64=7.5'
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/gcc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran $CONDA_PREFIX/bin/gfortran
ln -sf /usr/bin/ld ${CONDA_PREFIX}/x86_64-conda-linux-gnu/bin/ld
# Flag: Directive: ncpus, Value: 8
# languages:
CONDA_BASE=$(conda info --base)
ARCH=$(uname -m)

# deps: --no-update-deps
conda install -y --solver=libmamba --no-update-deps 'r-base=3.6.3'
conda install -y --solver=libmamba --no-update-deps r-remotes r-biocmanager r-renv
# r-conda:
conda install -y --solver=libmamba --no-update-deps \
'r-testthat' \
'r-isoband' \
'r-rsvd' \
'r-RcppAnnoy=0.0.16' 
# r-package:
Rscript -e 'install.packages("cowplot", repos="https://packagemanager.posit.co/cran/2019-11-01", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("dplyr", repos="https://packagemanager.posit.co/cran/2019-11-01", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("ggplot2", repos="https://packagemanager.posit.co/cran/2019-11-01", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("ggrepel", repos="https://packagemanager.posit.co/cran/2019-11-01", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("igraph", repos="https://packagemanager.posit.co/cran/2019-11-01", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("irlba", repos="https://packagemanager.posit.co/cran/2019-11-01", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("knitr", repos="https://packagemanager.posit.co/cran/2019-11-01", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("Matrix", repos="https://packagemanager.posit.co/cran/2019-11-01", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("mgcv", repos="https://packagemanager.posit.co/cran/2019-11-01", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("pheatmap", repos="https://packagemanager.posit.co/cran/2019-11-01", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("plyr", repos="https://packagemanager.posit.co/cran/2019-11-01", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("RColorBrewer", repos="https://packagemanager.posit.co/cran/2019-11-01", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("Rtsne", repos="https://packagemanager.posit.co/cran/2019-11-01", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("rmarkdown", repos="https://packagemanager.posit.co/cran/2019-11-01", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("schex", repos="https://packagemanager.posit.co/cran/2019-11-01", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("umap", repos="https://packagemanager.posit.co/cran/2019-11-01", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("viridis", repos="https://packagemanager.posit.co/cran/2019-11-01", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("wesanderson", repos="https://packagemanager.posit.co/cran/2019-11-01", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/RcppAnnoy/RcppAnnoy_0.0.16.tar.gz", repos=NULL, type="source")'
# bioc-conda:
conda install -y --solver=libmamba --no-update-deps \
'bioconductor-batchelor' \
'bioconductor-destiny' 
# bioc-package:
Rscript -e 'BiocManager::install("BiocNeighbors", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("BiocParallel", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("BiocSingular", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("biomaRt", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("DropletUtils", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("edgeR", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("scater", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("scran", dependencies=NA, Ncpus=8)'
Rscript -e 'BiocManager::install("topGO", dependencies=NA, Ncpus=8)'

# End of recipe
# Validation script setup
echo "#!/usr/bin/env bash" > ${CONDA_PREFIX}/bin/validate.sh
echo 'echo "COBLE validation: No script has been specified for tumori363 environment."' >> ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
mkdir -p ${CONDA_PREFIX}/coble-recipe
cp recipes/papers/tumorigenesis/tumorigenesis363.cbl ${CONDA_PREFIX}/coble-recipe
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble ${CONDA_PREFIX}/bin/
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble-* ${CONDA_PREFIX}/bin/

