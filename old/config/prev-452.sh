#!/bin/sh

#################################################
# Auto-generated script to recreate conda env
# Generated at Mon Nov 17 17:57:43 GMT 2025
#################################################

source ~/.bashrc
export CONDA_PKGS_DIRS=./pkgs/coble-452
rm -rf ./envs/coble-452
rm -rf ./pkgs/coble-452
conda clean --packages --tarballs -y
conda create -y -q -p ./envs/coble-452 r-base=4.5.2 python=3.14.0
# Time taken: 55 seconds.
# Starting in conda-step-install.sh at Mon Nov 17 17:59:17 GMT 2025
conda activate ./envs/coble-452
# === === >>> Switching to package mode.
# === === >>> Switching to R conda mode.
conda install -y  r-biocmanager --freeze-installed
# Time taken: 9 seconds.
conda install -y  r-devtools --freeze-installed
# Time taken: 29 seconds.
conda install -y  r-remotes --freeze-installed
# Time taken: 17 seconds.
conda install -y  r-data.table --freeze-installed
# Time taken: 18 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('fgsea',force=TRUE,quiet=FALSE)"
# Time taken: 409 seconds.
# === === >>> Switching to R conda mode.
conda install -y  r-raster --freeze-installed
# Time taken: 26 seconds.
conda install -y  r-spdep --freeze-installed
# Time taken: 142 seconds.
conda install -y  r-magick --freeze-installed
# Time taken: 38 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('stJoincount',force=TRUE,quiet=FALSE)"
# Time taken: 1648 seconds.
# === === >>> Switching to R conda mode.
conda install -y  r-stringi --freeze-installed
# Time taken: 52 seconds.
conda install -y  r-rcpp --freeze-installed
# Time taken: 19 seconds.
conda install -y  r-plyr --freeze-installed
# Time taken: 23 seconds.
conda install -y  r-reticulate --freeze-installed
# Time taken: 24 seconds.
conda install -y  r-sitmo --freeze-installed
# Time taken: 23 seconds.
conda install -y  r-seurat --freeze-installed
# Time taken: 127 seconds.
conda install -y  r-units --freeze-installed
# Time taken: 21 seconds.
# === === >>> Switching to package mode. conda
conda install -y  libxml2 --freeze-installed
# Time taken: 22 seconds.
conda install -y  pandoc --freeze-installed
# Time taken: 22 seconds.
conda install -y  pypandoc --freeze-installed
# Time taken: 30 seconds.
conda install -y  boost-cpp --freeze-installed
# Time taken: 66 seconds.
# === === >>> Switching to R conda mode.
conda install -y  r-xml --freeze-installed
# Time taken: 30 seconds.
conda install -y  r-xlconnect --freeze-installed
# Time taken: 32 seconds.
conda install -y  r-xml2 --freeze-installed
# Time taken: 24 seconds.
conda install -y  r-testthat --freeze-installed
# Time taken: 23 seconds.
conda install -y  r-systemfonts --freeze-installed
# Time taken: 23 seconds.
conda install -y  r-ragg --freeze-installed
# Time taken: 23 seconds.
# === === >>> Switching to package mode. conda
conda install -y  fonts-conda-ecosystem --freeze-installed
# Time taken: 23 seconds.
conda install -y  mscorefonts --freeze-installed
# Time taken: 30 seconds.
# === === >>> Switching to R conda mode.
conda install -y  r-nloptr --freeze-installed
# Time taken: 27 seconds.
conda install -y  r-polyclip --freeze-installed
# Time taken: 23 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('devtools', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 9 seconds.
# === === >>> Switching to package mode. conda
conda install -y  zlib --freeze-installed
# Time taken: 23 seconds.
# === === >>> Switching to R conda mode.
conda install -y  r-rsqlite --freeze-installed
# Time taken: 29 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('limma',force=TRUE,quiet=FALSE)"
# Time taken: 21 seconds.
Rscript -e "BiocManager::install('vsn',force=TRUE,quiet=FALSE)"
# Time taken: 39 seconds.
Rscript -e "BiocManager::install('edgeR',force=TRUE,quiet=FALSE)"
# Time taken: 29 seconds.
Rscript -e "BiocManager::install('org.Hs.eg.db',force=TRUE,quiet=FALSE)"
# Time taken: 78 seconds.
Rscript -e "BiocManager::install('org.Mm.eg.db',force=TRUE,quiet=FALSE)"
# Time taken: 25 seconds.
# === === >>> Switching to package mode. conda
# === === >>> Switching to R conda mode.
conda install -y  r-tzdb --freeze-installed
# Time taken: 32 seconds.
conda install -y  r-vroom --freeze-installed
# Time taken: 25 seconds.
conda install -y  r-readr --freeze-installed
# Time taken: 27 seconds.
conda install -y  r-readxl --freeze-installed
# Time taken: 26 seconds.
conda install -y  r-rcppannoy --freeze-installed
# Time taken: 23 seconds.
conda install -y  r-glmnet --freeze-installed
# Time taken: 24 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('gdata', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 5 seconds.
# === === >>> Switching to wget mode.
Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/NanoStringNorm/NanoStringNorm_1.2.1.1.tar.gz')"
# Time taken: 12 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('bedr', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 24 seconds.
Rscript -e "install.packages('SIMMS', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 60 seconds.
Rscript -e "install.packages('haven', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 25 seconds.
Rscript -e "install.packages('foreign', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 7 seconds.
Rscript -e "install.packages('spatstat', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 113 seconds.
# === === >>> Switching to GitHub mode.
Rscript -e "devtools::install_github('aroneklund/copynumber',quiet=FALSE)"
# Time taken: 16 seconds.
# === === >>> Switching to R conda mode.
conda install -y  r-rcpparmadillo --freeze-installed
# Time taken: 35 seconds.
conda install -y  r-conquer --freeze-installed
# Time taken: 33 seconds.
conda install -y  r-minqa --freeze-installed
# Time taken: 27 seconds.
# === === >>> Switching to package mode. conda
conda install -y  conda-forge::r-lme4 --freeze-installed
# Time taken: 25 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('FactoMineR', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 140 seconds.
Rscript -e "install.packages('factoextra', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 47 seconds.
Rscript -e "install.packages('knitr', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 7 seconds.
Rscript -e "install.packages('rmarkdown', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 8 seconds.
Rscript -e "install.packages('inline', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 3 seconds.
# === === >>> Switching to R conda mode.
conda install -y  r-rjson --freeze-installed
# Time taken: 33 seconds.
conda install -y  r-interp --freeze-installed
# Time taken: 26 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('biomaRt',force=TRUE,quiet=FALSE)"
# Time taken: 21 seconds.
Rscript -e "BiocManager::install('rtracklayer',force=TRUE,quiet=FALSE)"
# Time taken: 229 seconds.
Rscript -e "BiocManager::install('GenomicFeatures',force=TRUE,quiet=FALSE)"
# Time taken: 34 seconds.
Rscript -e "BiocManager::install('BSgenome',force=TRUE,quiet=FALSE)"
# Time taken: 37 seconds.
Rscript -e "BiocManager::install('VariantAnnotation',force=TRUE,quiet=FALSE)"
# Time taken: 64 seconds.
Rscript -e "BiocManager::install('ensembldb',force=TRUE,quiet=FALSE)"
# Time taken: 64 seconds.
Rscript -e "BiocManager::install('biovizBase',force=TRUE,quiet=FALSE)"
# Time taken: 88 seconds.
Rscript -e "BiocManager::install('Gviz',force=TRUE,quiet=FALSE)"
# Time taken: 71 seconds.
Rscript -e "BiocManager::install('GenomicInteractions',force=TRUE,quiet=FALSE)"
# Time taken: 126 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('distributions3', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 8 seconds.
Rscript -e "install.packages('mboost', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 32 seconds.
Rscript -e "install.packages('AER', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 10 seconds.
Rscript -e "install.packages('brglm2', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 16 seconds.
Rscript -e "install.packages('flexmix', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 12 seconds.
Rscript -e "install.packages('modelsummary', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 81 seconds.
Rscript -e "install.packages('nonnest2', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 54 seconds.
Rscript -e "install.packages('tinytest', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 3 seconds.
Rscript -e "install.packages('knitr', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 7 seconds.
Rscript -e "install.packages('UpSetR', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 8 seconds.
Rscript -e "install.packages('plotrix', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 8 seconds.
Rscript -e "install.packages('gplots', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 5 seconds.
Rscript -e "install.packages('drc', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 23 seconds.
Rscript -e "install.packages('chicane', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 57 seconds.
# === === >>> Switching to bash mode.
Rscript -e install.packages('countreg', repos='http://R-Forge.R-project.org', dependencies = TRUE)
# Time taken: 0 seconds.
# === === >>> Switching to package mode. conda
conda install -y  conda-forge::r-v8 --freeze-installed
# Time taken: 46 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('multtest',force=TRUE,quiet=FALSE)"
# Time taken: 16 seconds.
Rscript -e "BiocManager::install('GSEABase',force=TRUE,quiet=FALSE)"
# Time taken: 47 seconds.
Rscript -e "BiocManager::install('cellHTS2',force=TRUE,quiet=FALSE)"
# Time taken: 4 seconds.
Rscript -e "BiocManager::install('reshape',force=TRUE,quiet=FALSE)"
# Time taken: 6 seconds.
Rscript -e "BiocManager::install('TeachingDemos',force=TRUE,quiet=FALSE)"
# Time taken: 12 seconds.
Rscript -e "BiocManager::install('tidyverse',force=TRUE,quiet=FALSE)"
# Time taken: 54 seconds.
Rscript -e "BiocManager::install('SingleR',force=TRUE,quiet=FALSE)"
# Time taken: 226 seconds.
Rscript -e "BiocManager::install('scran',force=TRUE,quiet=FALSE)"
# Time taken: 229 seconds.
Rscript -e "BiocManager::install('scater',force=TRUE,quiet=FALSE)"
# Time taken: 41 seconds.
Rscript -e "BiocManager::install('celldex',force=TRUE,quiet=FALSE)"
# Time taken: 508 seconds.
Rscript -e "BiocManager::install('MAST',force=TRUE,quiet=FALSE)"
# Time taken: 38 seconds.
Rscript -e "BiocManager::install('impute',force=TRUE,quiet=FALSE)"
# Time taken: 6 seconds.
Rscript -e "BiocManager::install('genefu',force=TRUE,quiet=FALSE)"
# Time taken: 88 seconds.
Rscript -e "BiocManager::install('fastseg',force=TRUE,quiet=FALSE)"
# Time taken: 13 seconds.
Rscript -e "BiocManager::install('methylKit',force=TRUE,quiet=FALSE)"
# Time taken: 86 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('tidyverse', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 6 seconds.
Rscript -e "install.packages('argparser', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 2 seconds.
Rscript -e "install.packages('stringdist', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 5 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('BSgenome.Hsapiens.NCBI.GRCh38',force=TRUE,quiet=FALSE)"
# Time taken: 60 seconds.
# === === >>> Switching to GitHub mode.
Rscript -e "devtools::install_github('Nik-Zainal-Group/signature.tools.lib',quiet=FALSE)"
# Time taken: 421 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('genomation',force=TRUE,quiet=FALSE)"
# Time taken: 61 seconds.
# === === >>> Switching to Bioconda mode.
conda install -y  bioconda::bioconductor-RBGL --freeze-installed
# Time taken: 139 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('OrganismDbi',force=TRUE,quiet=FALSE)"
# Time taken: 145 seconds.
Rscript -e "BiocManager::install('ggbio',force=TRUE,quiet=FALSE)"
# Time taken: 56 seconds.
Rscript -e "BiocManager::install('TxDb.Hsapiens.UCSC.hg38.knownGene',force=TRUE,quiet=FALSE)"
# Time taken: 37 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('Signac', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 54 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('EnsDb.Hsapiens.v86',force=TRUE,quiet=FALSE)"
# Time taken: 48 seconds.
Rscript -e "BiocManager::install('harmony',force=TRUE,quiet=FALSE)"
# Time taken: 45 seconds.
# === === >>> Switching to package mode. conda
conda install -y  hdf5 --freeze-installed
# Time taken: 30 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('hdf5r', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 28 seconds.
# === === >>> Switching to R conda mode.
conda install -y  r-rjags --freeze-installed
# Time taken: 30 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('infercnv',force=TRUE,quiet=FALSE)"
# Time taken: 199 seconds.
# === === >>> Switching to GitHub mode.
Rscript -e "devtools::install_github('hdng/clonevol',quiet=FALSE)"
# Time taken: 11 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('packcircles', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 19 seconds.
# === === >>> Switching to R conda mode.
conda install -y  r-s2 --freeze-installed
# Time taken: 26 seconds.
conda install -y  r-Cairo --freeze-installed
# Time taken: 30 seconds.
conda install -y  r-ggrastr --freeze-installed
# Time taken: 26 seconds.
# === === >>> Switching to bash mode.
Rscript -e remotes::install_github('GreenleafLab/ArchR', ref='master', repos = BiocManager::repositories())
# Time taken: 0 seconds.
Rscript -e ArchR::installExtraPackages()
# Time taken: 0 seconds.
# === === >>> Switching to GitHub mode.
Rscript -e "devtools::install_github('satijalab/seurat-wrappers',quiet=FALSE)"
# Time taken: 12 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('ShortRead',force=TRUE,quiet=FALSE)"
# Time taken: 65 seconds.
# === === >>> Switching to R conda mode.
conda install -y  r-eulerr --freeze-installed
# Time taken: 28 seconds.
# === === >>> Switching to bash mode.
Rscript -e remotes::install_github('xmc811/Scillus', ref = 'development')
# Time taken: 0 seconds.
# === === >>> Switching to GitHub mode.
Rscript -e "devtools::install_github('VanLoo-lab/ascat/ASCAT',quiet=FALSE)"
# Time taken: 1 seconds.
Rscript -e "devtools::install_github('chris-mcginnis-ucsf/DoubletFinder',quiet=FALSE)"
# Time taken: 1 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('clustree', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 139 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('Chicago',force=TRUE,quiet=FALSE)"
# Time taken: 16 seconds.
# === === >>> Switching to wget mode.
Rscript -e "devtools::install_url('https://github.com/carmonalab/STACAS/archive/refs/heads/master.zip')"
# Time taken: 211 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('batchelor',force=TRUE,quiet=FALSE)"
# Time taken: 60 seconds.
# === === >>> Switching to wget mode.
Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/CIDER/CIDER_0.99.4.tar.gz')"
# Time taken: 122 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('GSVA',force=TRUE,quiet=FALSE)"
# Time taken: 46 seconds.
# === === >>> Switching to GitHub mode.
Rscript -e "devtools::install_github('cansysbio/ConsensusTME',quiet=FALSE)"
# Time taken: 1 seconds.
# === === >>> Switching to package mode. conda
conda install -y  conda-forge::r-gdtools --freeze-installed
# Time taken: 42 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('pcaMethods',force=TRUE,quiet=FALSE)"
# Time taken: 22 seconds.
# === === >>> Switching to bash mode.
git clone https://git.bioconductor.org/packages/DeconRNASeq
# Time taken: 2 seconds.
R CMD INSTALL DeconRNASeq
# Time taken: 6 seconds.
rm -rf DeconRNASeq
# Time taken: 0 seconds.
# === === >>> Switching to GitHub mode.
Rscript -e "devtools::install_github('EDePasquale/DoubletDecon',quiet=FALSE)"
# Time taken: 1 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('Rsubread',force=TRUE,quiet=FALSE)"
# Time taken: 50 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('rstan', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 209 seconds.
# === === >>> Switching to GitHub mode.
Rscript -e "devtools::install_github('stan-dev/rstantools',quiet=FALSE)"
# Time taken: 1 seconds.
Rscript -e "devtools::install_github('davidaknowles/leafcutter/leafcutter',quiet=FALSE)"
# Time taken: 1 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('liftOver',force=TRUE,quiet=FALSE)"
# Time taken: 168 seconds.
# === === >>> Switching to package mode. conda
# === === >>> Switching to R conda mode.
conda install -y  r-seqminer --freeze-installed
# Time taken: 31 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('squash', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 5 seconds.
Rscript -e "install.packages('iotools', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 5 seconds.
# === === >>> Switching to wget mode.
Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/sequenza/sequenza_3.0.0.tar.gz')"
# Time taken: 2 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('glmGamPoi',force=TRUE,quiet=FALSE)"
# Time taken: 55 seconds.
# === === >>> Switching to bash mode.
Rscript -e remotes::install_github('satijalab/sctransform', ref = 'develop')
# Time taken: 0 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('Ckmeans.1d.dp', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 26 seconds.
# === === >>> Switching to wget mode.
Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/modes/modes_0.7.0.tar.gz')"
# Time taken: 4 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('dynamicTreeCut', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 3 seconds.
Rscript -e "install.packages('roll', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 33 seconds.
Rscript -e "install.packages('hdf5r', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 27 seconds.
# === === >>> Switching to package mode. conda
conda install -y  conda-forge::r-units --freeze-installed
# Time taken: 25 seconds.
conda install -y  conda-forge::r-sf --freeze-installed
# Time taken: 24 seconds.
# === === >>> Switching to bash mode.
Rscript -e remotes::install_github('cole-trapnell-lab/monocle3', ref='develop')
# Time taken: 0 seconds.
# === === >>> Switching to pip mode.
python -m pip install "setuptools>=59.0"
# Time taken: 5 seconds.
python -m pip install "Cython>=3.0.11"
# Time taken: 2 seconds.
python -m pip install pysam
# Time taken: 2 seconds.
python -m pip install git+https://github.com/rachelicr/pysamstats.git
# Time taken: 3 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('LDlinkR', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 10 seconds.
Rscript -e "install.packages('randomForest', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 7 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('multiGSEA',force=TRUE,quiet=FALSE)"
# Time taken: 181 seconds.
# === === >>> Switching to wget mode.
Rscript -e "devtools::install_url('http://research-pub.gene.com/REdiscoverTEpaper/data/REdiscoverTEdata_1.0.1.tar.gz')"
# Time taken: 61 seconds.
Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/Matrix.utils/Matrix.utils_0.9.8.tar.gz')"
# Time taken: 15 seconds.
# === === >>> Switching to GitHub mode.
Rscript -e "devtools::install_github('karakulahg/TEffectR',quiet=FALSE)"
# Time taken: 1 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('minfi',force=TRUE,quiet=FALSE)"
# Time taken: 146 seconds.
Rscript -e "BiocManager::install('IlluminaHumanMethylationEPICanno.ilm10b4.hg19',force=TRUE,quiet=FALSE)"
# Time taken: 151 seconds.
Rscript -e "BiocManager::install('IlluminaHumanMethylationEPICmanifest',force=TRUE,quiet=FALSE)"
# Time taken: 43 seconds.
Rscript -e "BiocManager::install('missMethyl',force=TRUE,quiet=FALSE)"
# Time taken: 1273 seconds.
Rscript -e "BiocManager::install('minfiData',force=TRUE,quiet=FALSE)"
# Time taken: 49 seconds.
Rscript -e "BiocManager::install('DMRcate',force=TRUE,quiet=FALSE)"
# Time taken: 119 seconds.
# === === >>> Switching to bash mode.
Rscript -e BiocManager::install('preprocessCore', configure.args='--disable-threading', force = TRUE)
# Time taken: 0 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('clusterSim', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 58 seconds.
Rscript -e "install.packages('clv', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 7 seconds.
# === === >>> Switching to GitHub mode.
Rscript -e "devtools::install_github('saeyslab/nichenetr',quiet=FALSE)"
# Time taken: 297 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('kstreet13/slingshot',force=TRUE,quiet=FALSE)"
# Time taken: 65 seconds.
# === === >>> Switching to package mode. conda
conda install -y  conda-forge::r-ncdf4 --freeze-installed
# Time taken: 45 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('HiClimR', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 9 seconds.
Rscript -e "install.packages('ccaPP', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 51 seconds.
Rscript -e "install.packages('egg', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 9 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('sva',force=TRUE,quiet=FALSE)"
# Time taken: 25 seconds.
# === === >>> Switching to bash mode.
Rscript -e remotes::install_github('digitalcytometry/cytotrace2', subdir = 'cytotrace2_r')
# Time taken: 0 seconds.
# === === >>> Switching to pip mode.
python -m pip install scanoramaCT
# Time taken: 20 seconds.
# === === >>> Switching to package mode. conda
conda install -y  conda-forge::r-rpostgres --freeze-installed
# Time taken: 39 seconds.
# === === >>> Switching to GitHub mode.
Rscript -e "devtools::install_github('PriceLab/ghdb',quiet=FALSE)"
# Time taken: 47 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('destiny',force=TRUE,quiet=FALSE)"
# Time taken: 544 seconds.
# === === >>> Switching to GitHub mode.
Rscript -e "devtools::install_github('jinworks/CellChat',quiet=FALSE)"
# Time taken: 99 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('openssl', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 11 seconds.
# === === >>> Switching to bash mode.
Rscript -e install.packages('pracma', repos='http://R-Forge.R-project.org')
# Time taken: 0 seconds.
# === === >>> Switching to GitHub mode.
Rscript -e "devtools::install_github('trevorld/r-optparse',quiet=FALSE)"
# Time taken: 5 seconds.
# === === >>> Switching to package mode. conda
# === === >>> Switching to R conda mode.
conda install -y  r-mcmcpack --freeze-installed
# Time taken: 41 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('mvtnorm', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 8 seconds.
Rscript -e "install.packages('ellipse', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 3 seconds.
Rscript -e "install.packages('coda', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 4 seconds.
Rscript -e "install.packages('Matrix', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 217 seconds.
Rscript -e "install.packages('Rtsne', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 20 seconds.
Rscript -e "install.packages('gtools', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 5 seconds.
Rscript -e "install.packages('foreach', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 3 seconds.
Rscript -e "install.packages('doParallel', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 3 seconds.
Rscript -e "install.packages('doSNOW', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 2 seconds.
Rscript -e "install.packages('snow', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 3 seconds.
Rscript -e "install.packages('lattice', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 17 seconds.
Rscript -e "install.packages('MASS', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 10 seconds.
Rscript -e "install.packages('bayesm', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 252 seconds.
Rscript -e "install.packages('robustbase', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 18 seconds.
Rscript -e "install.packages('chron', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 8 seconds.
Rscript -e "install.packages('mnormt', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 8 seconds.
Rscript -e "install.packages('schoolmath', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 5 seconds.
Rscript -e "install.packages('RColorBrewer', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 4 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('DEXSeq',force=TRUE,quiet=FALSE)"
# Time taken: 102 seconds.
# === === >>> Switching to R conda mode.
conda install -y  r-arrow --freeze-installed
# Time taken: 59 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('AUCell',force=TRUE,quiet=FALSE)"
# Time taken: 74 seconds.
Rscript -e "BiocManager::install('RcisTarget',force=TRUE,quiet=FALSE)"
# Time taken: 37 seconds.
Rscript -e "BiocManager::install('GENIE3',force=TRUE,quiet=FALSE)"
# Time taken: 7 seconds.
# === === >>> Switching to GitHub mode.
Rscript -e "devtools::install_github('bokeh/rbokeh',quiet=FALSE)"
# Time taken: 51 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('R2HTML',force=TRUE,quiet=FALSE)"
# Time taken: 8 seconds.
# === === >>> Switching to bash mode.
Rscript -e remotes::install_github('aertslab/SCopeLoomR', build_vignettes = TRUE)
# Time taken: 0 seconds.
# === === >>> Switching to GitHub mode.
Rscript -e "devtools::install_github('aertslab/SCENIC',quiet=FALSE)"
# Time taken: 39 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('ISOpureR', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 16 seconds.
Rscript -e "install.packages('DiffCorr', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 10 seconds.
# === === >>> Switching to GitHub mode.
Rscript -e "devtools::install_github('broadinstitute/cdsr_models',quiet=FALSE)"
# Time taken: 122 seconds.
Rscript -e "devtools::install_github('PhanstielLab/Sushi',quiet=FALSE)"
# Time taken: 19 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('ChromSCape',force=TRUE,quiet=FALSE)"
# Time taken: 256 seconds.
# === === >>> Switching to bash mode.
Rscript -e remotes::install_github('sztup/scarHRD', build_vignettes = TRUE)
# Time taken: 0 seconds.
# === === >>> Switching to GitHub mode.
Rscript -e "devtools::install_github('guokai8/scGSVA',quiet=FALSE)"
# Time taken: 123 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('reactome.db',force=TRUE,quiet=FALSE)"
# Time taken: 60 seconds.
# === === >>> Switching to pip mode.
python -m pip install spatialde
# Time taken: 8 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('poolr', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 4 seconds.
Rscript -e "install.packages('tsne', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 2 seconds.
Rscript -e "install.packages('flexmix', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 11 seconds.
Rscript -e "install.packages('fpc', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 16 seconds.
# === === >>> Switching to GitHub mode.
Rscript -e "devtools::install_github('cit-bioinfo/mMCP-counter',quiet=FALSE)"
# Time taken: 6 seconds.
Rscript -e "devtools::install_github('mojaveazure/seurat-disk',quiet=FALSE)"
# Time taken: 24 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('immunarch', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 2431 seconds.
Rscript -e "install.packages('strawr', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 14 seconds.
# === === >>> Switching to GitHub mode.
Rscript -e "devtools::install_github('kharchenkolab/numbat',quiet=FALSE)"
# Time taken: 275 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('keras', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 34 seconds.
Rscript -e "install.packages('ijtiff', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 10 seconds.
Rscript -e "install.packages('bbmle', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 10 seconds.
# === === >>> Switching to GitHub mode.
Rscript -e "devtools::install_github('choisy/cutoff',quiet=FALSE)"
# Time taken: 18 seconds.
# === === >>> Switching to wget mode.
Rscript -e "devtools::install_url('https://bioconductor.org/packages/3.19/bioc/src/contrib/zlibbioc_1.50.0.tar.gz')"
# Time taken: 7 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('PoisonAlien/maftools',force=TRUE,quiet=FALSE)"
# Time taken: 33 seconds.
Rscript -e "BiocManager::install('illuminaHumanv4.db',force=TRUE,quiet=FALSE)"
# Time taken: 18 seconds.
Rscript -e "BiocManager::install('zellkonverter',force=TRUE,quiet=FALSE)"
# Time taken: 25 seconds.
Rscript -e "BiocManager::install('NanoStringNCTools',force=TRUE,quiet=FALSE)"
# Time taken: 22 seconds.
Rscript -e "BiocManager::install('GeomxTools',force=TRUE,quiet=FALSE)"
# Time taken: 91 seconds.
Rscript -e "BiocManager::install('GeoMxWorkflows',force=TRUE,quiet=FALSE)"
# Time taken: 34 seconds.
# === === >>> Switching to wget mode.
Rscript -e "devtools::install_url('https://github.com/rachelicr/r-maptools/archive/refs/heads/main.zip')"
# Time taken: 16 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('openxlsx', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 56 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('terra', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 336 seconds.
# === === >>> Switching to Bioconda mode.
conda install -y  bioconda::bioconductor-DelayedArray --freeze-installed
# Time taken: 156 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('IHW',force=TRUE,quiet=FALSE)"
# Time taken: 509 seconds.
Rscript -e "BiocManager::install('lpsymphony',force=TRUE,quiet=FALSE)"
# Time taken: 497 seconds.
Rscript -e "BiocManager::install('maftools',force=TRUE,quiet=FALSE)"
# Time taken: 22 seconds.
Rscript -e "BiocManager::install('SparseArray',force=TRUE,quiet=FALSE)"
# Time taken: 38 seconds.
Rscript -e "BiocManager::install('cellHTS2',force=TRUE,quiet=FALSE)"
# Time taken: 5 seconds.
# === === >>> Switching to pip mode.
python -m pip install requests
# Time taken: 2 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('Orthology.eg.db',force=TRUE,quiet=FALSE)"
# Time taken: 81 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('effsize', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 3 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('viper',force=TRUE,quiet=FALSE)"
# Time taken: 19 seconds.
Rscript -e "BiocManager::install('dorothea',force=TRUE,quiet=FALSE)"
# Time taken: 53 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('enrichR', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 10 seconds.
# === === >>> Switching to BiocManager mode.
Rscript -e "BiocManager::install('aracne.networks',force=TRUE,quiet=FALSE)"
# Time taken: 51 seconds.
Rscript -e "BiocManager::install('scDblFinder',force=TRUE,quiet=FALSE)"
# Time taken: 49 seconds.
# === === >>> Switching to pip mode.
python -m pip install PyYAML
# Time taken: 2 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('languageserver', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 34 seconds.
Rscript -e "install.packages('unigd', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 53 seconds.
Rscript -e "install.packages('AsioHeaders', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 4 seconds.
# === === >>> Switching to wget mode.
Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/httpgd/httpgd_2.0.4.tar.gz')"
# Time taken: 36 seconds.
# === === >>> Switching to pip mode.
python -m pip install radian
# Time taken: 4 seconds.
# === === >>> Switching to GitHub mode.
Rscript -e "devtools::install_github('munoztd0/reprtree',quiet=FALSE)"
# Time taken: 7 seconds.
# === === >>> Switching to R package mode.
Rscript -e "install.packages('seqinr', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Time taken: 11 seconds.
# === === >>> Switching to wget mode.
Rscript -e "devtools::install_url('https://github.com/carmonalab/ProjecTILs/archive/refs/heads/master.zip')"
# Time taken: 151 seconds.
# === === >>> Switching to GitHub mode.
Rscript -e "devtools::install_github('carmonalab/SignatuR',quiet=FALSE)"
# Time taken: 7 seconds.
Rscript -e "devtools::install_github('vladchimescu/lpsymphony',quiet=FALSE)"
# Time taken: 501 seconds.
Rscript -e "devtools::install_github('nignatiadis/IHW',quiet=FALSE)"
# Time taken: 9 seconds.
Rscript -e "devtools::install_github('saeyslab/multinichenetr',quiet=FALSE)"
# Time taken: 446 seconds.
# === >>> Finished processing conda environment file at Mon Nov 17 23:45:17 GMT 2025.
