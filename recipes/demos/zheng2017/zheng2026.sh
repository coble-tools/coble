#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-05-13
# Capture time: 21:21:25 BST
# Captured by: ralcraft
#####################################################
# source bashrc for conda
if [ -f ~/.bash_profile ]; then source ~/.bash_profile; elif [ -f ~/.bashrc ]; then source ~/.bashrc; elif command -v conda > /dev/null 2>&1; then eval "$(conda shell.bash hook)"; fi
# Using conda executable conda: /home/ralcraft/miniforge3/condabin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/condabin/conda
#####################################################

conda env remove --name zheng2026 -y 2>/dev/null || true
conda create --no-default-packages --name zheng2026 -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate zheng2026

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
# code/coble build --recipe recipes/demos/zheng2017/zheng2026.cbl --env zheng2026 --rebuild
# code/coble build --recipe recipes/demos/zheng2017/zheng2026.cbl --env zheng2026 --containers docker,singularity --code-source local --validate recipes/papers/zheng2017/validate.sh --ubuntu 16.04
#######################################
# comments:
# compilers:
# Flag: Directive: cran-repo, Value: 
# flags:
# Flag: Directive: ncpus, Value: 1
# conda:
conda install -y --solver=libmamba --no-update-deps \
r-base=4.5.2 
# r-package:
Rscript -e 'install.packages("lattice", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("chron", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("DBI", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("BH", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("assertthat", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("MASS", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("digest", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("RColorBrewer", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("dichromat", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("munsell", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("labeling", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("stringi", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("stringr", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("R6", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("lazyeval", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("codetools", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
# r-conda:
conda install -y --solver=libmamba --no-update-deps \
'r-Rcpp' \
'r-plyr' \
'r-data.table' \
'r-svd' 
# r-package:
Rscript -e 'install.packages("Matrix", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("gtable", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("scales", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("reshape2", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
# r-package:
Rscript -e 'install.packages("ggplot2", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("dplyr", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("Rtsne", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
# r-package:
Rscript -e 'install.packages("pheatmap", repos="https://packagemanager.posit.co/cran/2025-10-10", dependencies=NA, Ncpus=1)'
# conda:
conda install -y --solver=libmamba --no-update-deps \
cairo \
pango \
fonts-anaconda \
fontconfig 

# End of recipe
# Validation script setup
echo "#!/usr/bin/env bash" > ${CONDA_PREFIX}/bin/validate.sh
echo 'echo "COBLE validation: No script has been specified for zheng2026 environment."' >> ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
mkdir -p ${CONDA_PREFIX}/coble-recipe
cp recipes/demos/zheng2017/zheng2026.cbl ${CONDA_PREFIX}/coble-recipe
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble ${CONDA_PREFIX}/bin/
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble-* ${CONDA_PREFIX}/bin/

