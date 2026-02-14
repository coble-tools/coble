#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-13
# Capture time: 21:44:00 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi
# Using conda executable conda: /home/ralcraft/miniforge3/bin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/bin/conda
#####################################################

conda env remove --name carbine -y 2>/dev/null || true
conda create --no-default-packages --name carbine -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
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
# languages:
CONDA_BASE=$(conda info --base)
ARCH=$(uname -m)

conda install -y  'r-base=4.4.3'
conda install -y  'python=3.12'
python -m site
conda env config vars set PYTHONNOUSERSITE=1
export PYTHONNOUSERSITE=1
# bash:
R CMD javareconf
# flags:

# Language compile tools
conda install -y --no-update-deps -c conda-forge compilers
conda env config vars set QT_QPA_PLATFORM=offscreen
export QT_QPA_PLATFORM=offscreen
conda env config vars set OTEL_SDK_DISABLED=true
export OTEL_SDK_DISABLED=true
conda env config vars set R_OTEL_DISABLED=true
export R_OTEL_DISABLED=true
# Flag: Directive: dependencies, Value: na
conda env config vars set CXXFLAGS="--sysroot=$CONDA_PREFIX/aarch64-conda-linux-gnu/sysroot"
export CXXFLAGS="--sysroot=$CONDA_PREFIX/aarch64-conda-linux-gnu/sysroot"
conda env config vars set CPPFLAGS="--sysroot=$CONDA_PREFIX/aarch64-conda-linux-gnu/sysroot"
export CPPFLAGS="--sysroot=$CONDA_PREFIX/aarch64-conda-linux-gnu/sysroot"
conda env config vars set LDFLAGS="--sysroot=$CONDA_PREFIX/aarch64-conda-linux-gnu/sysroot"
export LDFLAGS="--sysroot=$CONDA_PREFIX/aarch64-conda-linux-gnu/sysroot"
conda env config vars set LD_LIBRARY_PATH="$CONDA_PREFIX/aarch64-conda-linux-gnu/sysroot/usr/lib:$CONDA_PREFIX/lib:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="$CONDA_PREFIX/aarch64-conda-linux-gnu/sysroot/usr/lib:$CONDA_PREFIX/lib:$LD_LIBRARY_PATH"

# conda:
conda install -y  --no-update-deps \
'cmdstan=2.38.0' 
# bash:
ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ]; then TRIPLET="${ARCH}-conda-linux-gnu" && \
CMDSTAN_PATH=$(python -c "import cmdstanpy; print(cmdstanpy.cmdstan_path())") && \
printf "CXXFLAGS_OS = --sysroot=$CONDA_PREFIX/${TRIPLET}/sysroot
TBB_CXX_TYPE = gcc
CPPFLAGS =
" >> $CMDSTAN_PATH/make/local; fi
# flags:
conda env config vars set CMDSTAN=$CONDA_PREFIX/bin/cmdstan
export CMDSTAN=$CONDA_PREFIX/bin/cmdstan
#- export: CPPFLAGS=$(echo $CPPFLAGS | sed 's|-I/usr/include||g')
#- export: CXXFLAGS=$(echo $CXXFLAGS | sed 's|-I/usr/include||g')
# conda:
conda install -y  --no-update-deps \
'zlib' \
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
'r-dndscv' \
'r-permute' \
'r-vegan' \
'r-shiny' 
# r-package:
Rscript -e 'install.packages("vcfR", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=1, method="wget")'
Rscript -e 'install.packages("covr", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=1, method="wget")'
Rscript -e 'install.packages("partykit", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=1, method="wget")'
# r-conda:
conda install -y  --no-update-deps \
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
# r-package:
Rscript -e 'install.packages("ggpubr", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=1, method="wget")'
Rscript -e 'install.packages("ggsci", repos="https://packagemanager.posit.co/cran/latest", dependencies=NA, Ncpus=1, method="wget")'
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



cat > ${CONDA_PREFIX}/bin/validate.sh << 'VALIDATE_EOF'
#!/usr/bin/env bash
echo "COBLE validation: No script has been specified for carbine environment."
VALIDATE_EOF
chmod +x ${CONDA_PREFIX}/bin/validate.sh

