#!/usr/bin/env bash

#######################################
# COBLE:Reproducible environment recipe, (c) ICR 2025
# Capture date: 2025-12-15
# Capture time: 22:13:48 GMT
# Captured by: ralcraft
#######################################
# source bashrc for conda
source "$(conda info --base)/etc/profile.d/conda.sh"
source ~/.bashrc
#######################################


conda create --name sylver -y -c conda-forge 'r-base=3.6.0'
conda activate sylver

# Channels section
conda config --remove-key channels
conda config --add channels conda-forge
conda config --add channels bioconda

# INSTALL SECTION FOR CONDA
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/affy/affy_1.64.0.tar.gz", repos = NULL, type = "source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/hsentrezgcdf/hsentrezgcdf_18.tar.gz", repos = NULL, type = "source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/cdsrmodels/cdsrmodels_0.1.0.tar.gz", repos = NULL, type = "source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/limma/limma_3.42.2.tar.gz", repos = NULL, type = "source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/effsize/effsize_0.8.1.tar.gz", repos = NULL, type = "source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/magrittr/magrittr_2.0.1.tar.gz", repos = NULL, type = "source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/tidyverse/tidyverse_1.3.1.tar.gz", repos = NULL, type = "source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/fgsea/fgsea_1.12.0.tar.gz", repos = NULL, type = "source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/ggplots/ggplots_2_3.3.5.tar.gz", repos = NULL, type = "source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/ggrepel/ggrepel_0.9.1.tar.gz", repos = NULL, type = "source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/org.Hs.eg.db/org.Hs.eg.db_3.10.0.tar.gz", repos = NULL, type = "source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/VennDiagram/VennDiagram_1.6.20.tar.gz", repos = NULL, type = "source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/survival/survival_3.2-11.tar.gz", repos = NULL, type = "source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/GSVA/GSVA_1.34.0.tar.gz", repos = NULL, type = "source")'
