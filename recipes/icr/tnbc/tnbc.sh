#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-05-17
# Capture time: 14:45:11 BST
# Captured by: ralcraft
#####################################################
# source bashrc for conda
if [ -f ~/.bash_profile ]; then source ~/.bash_profile; elif [ -f ~/.bashrc ]; then source ~/.bashrc; elif command -v conda > /dev/null 2>&1; then eval "$(conda shell.bash hook)"; fi
# Using conda executable conda: /home/ralcraft/miniforge3/bin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/bin/conda
#####################################################

conda env remove --name tnbc -y 2>/dev/null || true
conda create --no-default-packages --name tnbc -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate tnbc

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --show channels | grep -q 'channels:' && conda config --env --remove-key channels || true
conda config --env --set channel_priority strict
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
#######################################
# COBLE:Reproducible environment, (c) ICR 2026
# code/coble build --recipe recipes/icr/tnbc/tnbc.cbl --env tnbc --rebuild
#######################################
# comments:
# compilers:
# Flag: Directive: cran-repo, Value: 
# flags:
# Flag: Directive: ncpus, Value: 4
# conda:
conda install -y --solver=libmamba --no-update-deps \
r-base=4.1.0 \
compilers \
curl \
libcurl 
# r-package:
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/KernSmooth/KernSmooth_2.23-20.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("dotCall64", repos="https://packagemanager.posit.co/cran/2024-04-01", dependencies=NA, Ncpus=4)'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/spam/spam_2.8-0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/viridisLite/viridisLite_0.4.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/glue/glue_1.6.2.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/digest/digest_0.6.29.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/gtable/gtable_0.3.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/MASS/MASS_7.3-58.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/rlang/rlang_1.0.6.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/fansi/fansi_1.0.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("lifecycle", repos="https://packagemanager.posit.co/cran/2024-04-01", dependencies=NA, Ncpus=4)'
Rscript -e 'install.packages("magrittr", repos="https://packagemanager.posit.co/cran/2024-04-01", dependencies=NA, Ncpus=4)'
Rscript -e 'install.packages("pillar", repos="https://packagemanager.posit.co/cran/2024-04-01", dependencies=NA, Ncpus=4)'
Rscript -e 'install.packages("pkgconfig", repos="https://packagemanager.posit.co/cran/2024-04-01", dependencies=NA, Ncpus=4)'
Rscript -e 'install.packages("vctrs", repos="https://packagemanager.posit.co/cran/2024-04-01", dependencies=NA, Ncpus=4)'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/tibble/tibble_3.1.8.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/withr/withr_2.5.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("isoband", repos="https://packagemanager.posit.co/cran/2024-04-01", dependencies=NA, Ncpus=4)'
Rscript -e 'install.packages("mgcv", repos="https://packagemanager.posit.co/cran/2024-04-01", dependencies=NA, Ncpus=4)'
Rscript -e 'install.packages("scales", repos="https://packagemanager.posit.co/cran/2024-04-01", dependencies=NA, Ncpus=4)'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/ggplot2/ggplot2_3.3.5.tar.gz", repos=NULL, type="source")'

# r-conda:
conda install -y --solver=libmamba --no-update-deps \
'r-gridExtra=2.3' \
'r-plotly' \
'r-ggraph=2.0.5' \
'r-ggpubr=0.4.0' \
'r-tidyverse=1.3.1' \
'r-optparse=1.7.3' 

# r-package:
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/viridis/viridis_0.6.3.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/maps/maps_3.4.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/fields/fields_13.3.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/pracma/pracma_2.4.2.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("globals", repos="https://packagemanager.posit.co/cran/2024-04-01", dependencies=NA, Ncpus=4)'
Rscript -e 'install.packages("listenv", repos="https://packagemanager.posit.co/cran/2024-04-01", dependencies=NA, Ncpus=4)'
Rscript -e 'install.packages("parallelly", repos="https://packagemanager.posit.co/cran/2024-04-01", dependencies=NA, Ncpus=4)'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/future/future_1.25.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("jsonlite", repos="https://packagemanager.posit.co/cran/2024-04-01", dependencies=NA, Ncpus=4)'
Rscript -e 'install.packages("RCurl", repos="https://packagemanager.posit.co/cran/2024-04-01", dependencies=NA, Ncpus=4)'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/tidyr/tidyr_1.2.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("crosstalk", repos="https://packagemanager.posit.co/cran/2024-04-01", dependencies=NA, Ncpus=4)'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/dplyr/dplyr_1.1.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/gprofiler2/gprofiler2_0.2.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("checkmate", repos="https://packagemanager.posit.co/cran/2024-04-01", dependencies=NA, Ncpus=4)'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/ggrepel/ggrepel_0.9.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/clustree/clustree_0.4.4.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/forcats/forcats_0.5.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/stringr/stringr_1.4.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/purrr/purrr_0.3.4.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/readr/readr_2.0.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/scDblFinder/scDblFinder_1.6.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/SingleR/SingleR_1.6.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/SummarizedExperiment/SummarizedExperiment_1.24.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/Biobase/Biobase_2.54.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/GenomicRanges/GenomicRanges_1.46.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/GenomeInfoDb/GenomeInfoDb_1.28.4.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/IRanges/IRanges_2.28.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/S4Vectors/S4Vectors_0.32.4.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/BiocGenerics/BiocGenerics_0.40.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/MatrixGenerics/MatrixGenerics_1.6.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/matrixStats/matrixStats_0.61.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/SeuratObject/SeuratObject_4.1.3.tar.gz", repos=NULL, type="source")'
# r-conda:
conda install -y --solver=libmamba --no-update-deps \
'r-Seurat=4.2.1' \
'r-remotes' \
'r-FactoMineR' \
'r-factoextra' 
# bioc-conda::
conda install -y --solver=libmamba --no-update-deps \
'bioconductor-GSEABase' \
'bioconductor-multtest' \
'bioconductor-limma' \
'bioconductor-fgsea' \
'bioconductor-SingleR' \
'bioconductor-scDblFinder' 
# bash:
Rscript -e 'remotes::install_github("chris-mcginnis-ucsf/DoubletFinder", ref="03e9f37f891ef76a23cc55ea69f940c536ae8f9f", dependencies=NA, upgrade="never", Ncpus=4)'

Rscript -e 'Sys.setenv(GITLAB_PAT=Sys.getenv("GITLAB_PAT")); \
remotes::install_gitlab("bcr_ds_team/bcrbioinformatics/Resources/R_Packages/FC14.genesets.DB", \
host="git.icr.ac.uk", ref="71458584580db2f463945076b73e897b2c6efec8", dependencies=NA, upgrade="never")'

Rscript -e 'Sys.setenv(GITLAB_PAT=Sys.getenv("GITLAB_PAT")); \
remotes::install_gitlab("bcr_ds_team/bcrbioinformatics/Resources/R_Packages/FC14.statistics.lib", \
host="git.icr.ac.uk", ref="main", dependencies=NA, upgrade="never")'

Rscript -e 'Sys.setenv(GITLAB_PAT=Sys.getenv("GITLAB_PAT")); \
remotes::install_gitlab("bcr_ds_team/bcrbioinformatics/Resources/R_Packages/FC14.genome.annotations", \
host="git.icr.ac.uk", ref="main", dependencies=NA, upgrade="never")'

Rscript -e 'Sys.setenv(GITLAB_PAT=Sys.getenv("GITLAB_PAT")); \
remotes::install_gitlab("bcr_ds_team/bcrbioinformatics/Resources/R_Packages/BCN.genesets.utilities", \
host="git.icr.ac.uk", ref="main", dependencies=NA, upgrade="never")'

Rscript -e 'Sys.setenv(GITLAB_PAT=Sys.getenv("GITLAB_PAT")); \
remotes::install_gitlab("bcr_ds_team/bcrbioinformatics/Resources/R_Packages/FC14.plotting.lib", \
host="git.icr.ac.uk", ref="912c674ebb2dc7bcdfe6fa3013de5952e8c77c4c", dependencies=NA, upgrade="never")'

Rscript -e 'Sys.setenv(GITLAB_PAT=Sys.getenv("GITLAB_PAT")); \
remotes::install_gitlab("bcr_ds_team/bcrbioinformatics/Resources/R_Packages/BCN.general.utilities", \
host="git.icr.ac.uk", ref="505467ce5e9cb0bc4f9f301c624e751f01667afc", dependencies=NA, upgrade="never")'

#Rscript -e 'Sys.setenv(GITLAB_PAT=Sys.getenv("GITLAB_PAT")); \
#remotes::install_gitlab("bcr_ds_team/bcrbioinformatics/Resources/R_Packages/BCN.singlecell.utilities", \
#host="git.icr.ac.uk", ref="70f04179565510c10095ecca753f5cf983331bb0", dependencies=NA, upgrade="never")'
#Rscript -e 'remove.packages("BCN.singlecell.utilities")'

# End of recipe
# Validation script setup
echo "#!/usr/bin/env bash" > ${CONDA_PREFIX}/bin/validate.sh
echo 'echo "COBLE validation: No script has been specified for tnbc environment."' >> ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
mkdir -p ${CONDA_PREFIX}/coble-recipe
cp recipes/icr/tnbc/tnbc.cbl ${CONDA_PREFIX}/coble-recipe
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble ${CONDA_PREFIX}/bin/
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble-* ${CONDA_PREFIX}/bin/

