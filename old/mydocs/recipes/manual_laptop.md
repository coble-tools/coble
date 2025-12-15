# Manual repeat
conda create -p ./envs/manual r-base=4.4.2
conda activate ./envs/manual
conda install conda-forge::r-stringi
conda install conda-forge::r-rcpp
conda install conda-forge::r-ggiraph
conda install conda-forge::r-plyr
conda install conda-forge::r-reticulate
conda install conda-forge::r-sitmo
conda install conda-forge::r-seurat
conda install bioconda::bioconductor-stjoincount

####### IT WORKS!!!!!

conda create -p ./envs/manual-4.5.2 r-base=4.5.2
conda activate ./envs/manual-4.5.2
conda install conda-forge::r-stringi
conda install conda-forge::r-rcpp
conda install conda-forge::r-ggiraph
conda install conda-forge::r-plyr
conda install conda-forge::r-reticulate
conda install conda-forge::r-sitmo
conda install conda-forge::r-seurat
conda install bioconda::bioconductor-stjoincount

# It doesn't!
conda create -p ./envs/stjoincount
conda activate ./envs/stjoincount
conda install conda-forge::r-base=4.5
conda install conda-forge::r-devtools
R -e "devtools::install_url('https://github.com/COHCCC/stJoincount/archive/refs/heads/master.zip')"





