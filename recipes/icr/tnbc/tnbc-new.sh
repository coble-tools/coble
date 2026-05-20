#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-05-20
# Capture time: 11:31:12 BST
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
'r-SeuratObject=4.1.3' 
# r-package:
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/fgsea/fgsea_1.18.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/limma/limma_3.50.1.tar.gz", repos=NULL, type="source")'

# r-package:
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/fastmatch/fastmatch_1.1-3.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/plyr/plyr_1.8.7.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/igraph/igraph_1.2.6.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/lazyeval/lazyeval_0.2.2.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/sp/sp_1.5-1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/GSEABase/GSEABase_1.56.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/splines/splines_4.1.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/BiocParallel/BiocParallel_1.28.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/listenv/listenv_0.8.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/scattermore/scattermore_0.7.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/GenomeInfoDb/GenomeInfoDb_1.28.4.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/digest/digest_0.6.29.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/htmltools/htmltools_0.5.2.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/viridis/viridis_0.6.3.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/fansi/fansi_1.0.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/magrittr/magrittr_2.0.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/memoise/memoise_2.0.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/tensor/tensor_1.5.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/cluster/cluster_2.1.2.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/ROCR/ROCR_1.0-11.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/globals/globals_0.15.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/Biostrings/Biostrings_2.62.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/annotate/annotate_1.72.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/matrixStats/matrixStats_0.61.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/spatstat.sparse/spatstat.sparse_3.0-0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/colorspace/colorspace_2.0-2.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/blob/blob_1.2.2.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/ggrepel/ggrepel_0.9.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/dplyr/dplyr_1.0.8.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/RCurl/RCurl_1.98-1.6.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/crayon/crayon_1.4.2.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/jsonlite/jsonlite_1.7.2.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/graph/graph_1.72.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/progressr/progressr_0.9.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/spatstat.data/spatstat.data_3.0-0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/survival/survival_3.2-13.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/zoo/zoo_1.8-11.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/glue/glue_1.6.2.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/polyclip/polyclip_1.10-0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/gtable/gtable_0.3.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/zlibbioc/zlibbioc_1.40.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/XVector/XVector_0.34.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/leiden/leiden_0.3.9.tar.gz", repos=NULL, type="source")'
#- future.apply=1.8.1
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/BiocGenerics/BiocGenerics_0.40.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/abind/abind_1.4-5.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/scales/scales_1.1.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/futile.options/futile.options_1.0.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/DBI/DBI_1.1.2.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/spatstat.random/spatstat.random_3.0-1.tar.gz", repos=NULL, type="source")'
#- miniUI=0.1.1.1
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/Rcpp/Rcpp_1.0.7.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/viridisLite/viridisLite_0.4.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/xtable/xtable_1.8-4.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/reticulate/reticulate_1.25.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/bit/bit_4.0.4.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/stats4/stats4_4.1.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/htmlwidgets/htmlwidgets_1.5.4.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/httr/httr_1.4.2.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/gplots/gplots_3.1.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/RColorBrewer/RColorBrewer_1.1-3.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/ellipsis/ellipsis_0.3.2.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/ica/ica_1.0-2.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/pkgconfig/pkgconfig_2.0.3.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/XML/XML_3.99-0.6.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/farver/farver_2.1.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/uwot/uwot_0.1.14.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/deldir/deldir_1.0-6.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/utf8/utf8_1.2.2.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/tidyselect/tidyselect_1.2.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/rlang/rlang_1.0.6.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/reshape2/reshape2_1.4.4.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/later/later_1.2.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/AnnotationDbi/AnnotationDbi_1.56.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/munsell/munsell_0.5.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/tools/tools_4.1.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/cachem/cachem_1.0.6.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/cli/cli_3.4.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/generics/generics_0.1.2.tar.gz", repos=NULL, type="source")'
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

