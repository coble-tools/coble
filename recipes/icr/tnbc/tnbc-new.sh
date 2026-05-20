#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-05-20
# Capture time: 13:23:09 BST
# Captured by: ralcraft
#####################################################
# source bashrc for conda
if [ -f ~/.bash_profile ]; then source ~/.bash_profile; elif [ -f ~/.bashrc ]; then source ~/.bashrc; elif command -v conda > /dev/null 2>&1; then eval "$(conda shell.bash hook)"; fi
# Using conda executable conda: /home/ralcraft/miniforge3/condabin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/condabin/conda
#####################################################

conda env remove --name tnbc-new -y 2>/dev/null || true
conda create --no-default-packages --name tnbc-new -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate tnbc-new

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
libopenblas=0.3.15 \
compilers \
curl \
libcurl 

# r-conda:
conda install -y --solver=libmamba --no-update-deps \
'r-gridExtra=2.3' \
'r-plotly' \
'r-ggraph=2.0.5' \
'r-ggpubr=0.4.0' \
'r-tidyverse=1.3.1' \
'r-optparse=1.7.3' \
'r-irlba=2.3.3' \
'r-png=0.1-7' \
'r-Seurat=4.2.1' \
'r-ggplot2=3.3.5' \
'r-data.table=1.14.2' \
'r-pracma=2.4.2' \
'r-SeuratObject=4.1.3' \
'r-BiocManager' 
# bioc-package:
Rscript -e 'BiocManager::install("fgsea", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("limma", dependencies=NA, Ncpus=4)'

# r-package:
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/fastmatch/fastmatch_1.1-3.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/plyr/plyr_1.8.7.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/igraph/igraph_1.2.6.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/lazyeval/lazyeval_0.2.2.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/sp/sp_1.5-1.tar.gz", repos=NULL, type="source")'
# bioc-package:
Rscript -e 'BiocManager::install("GSEABase", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("splines", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("BiocParallel", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("listenv", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("scattermore", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("GenomeInfoDb", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("digest", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("htmltools", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("viridis", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("fansi", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("magrittr", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("memoise", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("tensor", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("cluster", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("ROCR", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("globals", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("Biostrings", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("annotate", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("matrixStats", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("spatstat.sparse", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("colorspace", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("blob", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("ggrepel", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("dplyr", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("RCurl", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("crayon", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("jsonlite", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("graph", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("progressr", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("spatstat.data", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("survival", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("zoo", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("glue", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("polyclip", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("gtable", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("zlibbioc", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("XVector", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("leiden", dependencies=NA, Ncpus=4)'
#- future.apply=1.8.1
Rscript -e 'BiocManager::install("BiocGenerics", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("abind", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("scales", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("futile.options", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("DBI", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("spatstat.random", dependencies=NA, Ncpus=4)'
#- miniUI=0.1.1.1
Rscript -e 'BiocManager::install("Rcpp", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("viridisLite", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("xtable", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("reticulate", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("bit", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("stats4", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("htmlwidgets", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("httr", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("gplots", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("RColorBrewer", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("ellipsis", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("ica", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("pkgconfig", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("XML", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("farver", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("uwot", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("deldir", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("utf8", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("tidyselect", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("rlang", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("reshape2", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("later", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("AnnotationDbi", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("munsell", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("tools", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("cachem", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("cli", dependencies=NA, Ncpus=4)'
Rscript -e 'BiocManager::install("generics", dependencies=NA, Ncpus=4)'
# r-conda:
conda install -y --solver=libmamba --no-update-deps \
'r-RSQLite=2.2.8' \
'r-plotly=4.10.0' \
'r-tibble=3.1.8' 
# r-package:
#- ggridges=0.5.3
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/stringr/stringr_1.4.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/fastmap/fastmap_1.1.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/goftest/goftest_1.2-2.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/org.Hs.eg.db/org.Hs.eg.db_3.13.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/bit64/bit64_4.0.5.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/fitdistrplus/fitdistrplus_1.1-5.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/caTools/caTools_1.18.2.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/purrr/purrr_0.3.4.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/RANN/RANN_2.6.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/KEGGREST/KEGGREST_1.34.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/pbapply/pbapply_1.5-0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/future/future_1.25.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/nlme/nlme_3.1-152.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/mime/mime_0.12.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/formatR/formatR_1.11.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/compiler/compiler_4.1.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/spatstat.utils/spatstat.utils_3.0-1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/stringi/stringi_1.7.5.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/lattice/lattice_0.20-45.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/Matrix/Matrix_1.5-3.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/vctrs/vctrs_0.5.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/pillar/pillar_1.8.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/lifecycle/lifecycle_1.0.3.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/spatstat.geom/spatstat.geom_3.0-3.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/lmtest/lmtest_0.9-38.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/RcppAnnoy/RcppAnnoy_0.0.19.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/bitops/bitops_1.0-7.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/cowplot/cowplot_1.1.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/irlba/irlba_2.3.5.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/httpuv/httpuv_1.6.5.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/patchwork/patchwork_1.1.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/R6/R6_2.5.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/promises/promises_1.2.0.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/KernSmooth/KernSmooth_2.23-20.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/gridExtra/gridExtra_2.3.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/IRanges/IRanges_2.28.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/parallelly/parallelly_1.31.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/codetools/codetools_0.2-18.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/lambda.r/lambda.r_1.2.4.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/gtools/gtools_3.9.4.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/MASS/MASS_7.3-58.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/assertthat/assertthat_0.2.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/withr/withr_2.5.0.tar.gz", repos=NULL, type="source")'
# r-conda:
conda install -y --solver=libmamba --no-update-deps \
'r-sctransform=0.3.5' 
# r-package:
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/GenomeInfoDbData/GenomeInfoDbData_1.2.7.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/S4Vectors/S4Vectors_0.32.4.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/parallel/parallel_4.1.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/tidyr/tidyr_1.2.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/Rtsne/Rtsne_0.16.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/spatstat.explore/spatstat.explore_3.0-5.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/Biobase/Biobase_2.54.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/shiny/shiny_1.7.1.tar.gz", repos=NULL, type="source")'

# r-conda:
conda install -y --solver=libmamba --no-update-deps \
'r-remotes' \
'r-FactoMineR' \
'r-factoextra' 

# bioc-conda::
conda install -y --solver=libmamba --no-update-deps \
'bioconductor-GSEABase' \
'bioconductor-multtest' \
'bioconductor-SingleR' \
'bioconductor-scDblFinder' 

# bash:
Rscript -e 'remotes::install_github("chris-mcginnis-ucsf/DoubletFinder", ref="243b02f5badfed677ef7500b8753fd651f21a67f", dependencies=NA, upgrade="never", Ncpus=4)'

Rscript -e 'Sys.setenv(GITLAB_PAT=Sys.getenv("GITLAB_PAT")); \
remotes::install_gitlab("bcr_ds_team/bcrbioinformatics/Resources/R_Packages/FC14.genesets.DB", \
host="git.icr.ac.uk", ref="main", dependencies=NA, upgrade="never")'

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
host="git.icr.ac.uk", ref="main", dependencies=NA, upgrade="never")'

Rscript -e 'Sys.setenv(GITLAB_PAT=Sys.getenv("GITLAB_PAT")); \
remotes::install_gitlab("bcr_ds_team/bcrbioinformatics/Resources/R_Packages/BCN.general.utilities", \
host="git.icr.ac.uk", ref="main", dependencies=NA, upgrade="never")'

Rscript -e 'Sys.setenv(GITLAB_PAT=Sys.getenv("GITLAB_PAT")); \
remotes::install_gitlab("bcr_ds_team/bcrbioinformatics/Resources/R_Packages/BCN.singlecell.utilities", \
host="git.icr.ac.uk", ref="main", dependencies=NA, upgrade="never")'
#Rscript -e 'remove.packages("BCN.singlecell.utilities")'
#Rscript -e 'remove.packages("irlba")'
#Rscript -e 'remotes::install_version("irlba", version = "2.3.3", repos = "http://cran.r-project.org")'

# End of recipe
# Validation script setup
echo "#!/usr/bin/env bash" > ${CONDA_PREFIX}/bin/validate.sh
echo 'echo "COBLE validation: No script has been specified for tnbc-new environment."' >> ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
mkdir -p ${CONDA_PREFIX}/coble-recipe
cp recipes/icr/tnbc/tnbc-new.cbl ${CONDA_PREFIX}/coble-recipe
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble ${CONDA_PREFIX}/bin/
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble-* ${CONDA_PREFIX}/bin/

