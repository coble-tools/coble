#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-06
# Capture time: 13:07:58 GMT
# Captured by: ralcraft
# Platform: linux-64
#####################################################
# source bashrc for conda
source /home/ralcraft/.bashrc
# Using conda executable conda: /home/ralcraft/miniforge3/envs/pytest/bin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/envs/pytest/bin/conda
#####################################################

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
# note the reverse order of priority
# languages:
conda install -y  'python=3.12'
python -m site
conda env config vars set PYTHONNOUSERSITE=1
conda deactivate
conda activate carbine
# Recommended tools: 
# Symlink all compiler/binutils tools
conda install -y  'r-base=4.4.3' r-remotes r-biocmanager
# flags:
# Flag: Directive: dependencies, Value: na
conda env config vars set QT_QPA_PLATFORM=offscreen
conda deactivate
conda activate carbine
#- export: OTEL_SDK_DISABLED=true
#- export: R_OTEL_DISABLED=true
# conda:
conda install -y  --no-update-deps \
'arviz' \
'pytz' \
'cmdstan=2.38.0' \
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
# flags: