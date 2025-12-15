##########################################################################################
##### R 4.5.2 installations (RA updated with install_url, rScript and repos)
##########################################################################################

conda create -p /data/scratch/DBC/UBCN/BCRBIOIN/SHARED/software/conda_envs/R-4.5.2 r-base=4.5.2 python=3.14.0
conda activate /data/scratch/DBC/UBCN/BCRBIOIN/SHARED/software/conda_envs/R-4.5.2

conda install -y r-biocmanager --no-update-deps

conda install -y r-data.table --no-update-deps
Rscript -e "BiocManager::install('fgsea',force=TRUE)"

conda install -c conda-forge r-stringi r-rcpp r-plyr r-reticulate r-sitmo --no-update-deps

conda install conda-forge::r-seurat

conda install conda-forge::r-units

Rscript -e "BiocManager::install('stJoincount')"

conda install -c conda-forge libxml2
conda install -c conda-forge pandoc pypandoc boost-cpp  r-xml r-xlconnect r-xml2 r-testthat r-systemfonts r-ragg


# for fonts to work otherwise default unix ones are DejaVu
conda install -c conda-forge fonts-conda-ecosystem mscorefonts r-nloptr r-polyclip

conda install -c conda-forge zlib
conda install conda-forge::r-rsqlite
Rscript -e "BiocManager::install(c('limma', 'vsn', 'edgeR', 'org.Hs.eg.db', 'org.Mm.eg.db'))"

conda install -c conda-forge r-tzdb r-vroom r-readr r-readxl r-rcppannoy r-glmnet

Rscript -e "install.packages('gdata', repos='https://cloud.r-project.org')"
Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/NanoStringNorm/NanoStringNorm_1.2.1.1.tar.gz')"

Rscript -e "install.packages(c('bedr', 'SIMMS', 'haven', 'foreign', 'spatstat'), repos='https://cloud.r-project.org')"

# required for sequenze to work with hg38. Default copy number package from BioConductor does not support beyond hg19
Rscript -e "devtools::install_url('https://github.com/aroneklund/copynumber/archive/refs/heads/master.zip')"

# these wont install happily from install.packages (needed for FactoMineR)
conda install -c conda-forge r-rcpparmadillo r-conquer r-minqa

conda install conda-forge::r-lme4
Rscript -e "install.packages(c('FactoMineR', 'factoextra'), repos='https://cloud.r-project.org')"

Rscript -e "install.packages(c('knitr', 'rmarkdown', 'inline'), repos='https://cloud.r-project.org')"

conda install -c conda-forge r-rjson r-interp
Rscript -e "BiocManager::install(c('biomaRt', 'rtracklayer',  'GenomicFeatures', 'BSgenome', 'VariantAnnotation', 'ensembldb', 'biovizBase', 'Gviz', 'GenomicInteractions'))"

Rscript -e "install.packages(c('distributions3', 'mboost', 'AER', 'brglm2', 'flexmix', 'modelsummary', 'nonnest2', 'tinytest', 'knitr', 'UpSetR', 'plotrix', 'gplots', 'drc'), repos='https://cloud.r-project.org')"

Rscript -e "install.packages('countreg', repos='http://R-Forge.R-project.org', dependencies = TRUE)"
Rscript -e "install.packages('chicane', dependencies = TRUE, repos='https://cloud.r-project.org')"

conda install conda-forge::r-v8
Rscript -e "BiocManager::install(c('multtest', 'GSEABase', 'cellHTS2', 'reshape', 'TeachingDemos', 'tidyverse', 'SingleR', 'scran', 'scater', 'celldex'))"

Rscript -e "BiocManager::install(c('MAST', 'impute', 'genefu', 'fastseg'))"

Rscript -e "BiocManager::install('methylKit')"

Rscript -e "install.packages(c('tidyverse', 'argparser', 'stringdist'), repos='https://cloud.r-project.org')"

Rscript -e "BiocManager::install('BSgenome.Hsapiens.NCBI.GRCh38')"
Rscript -e "devtools::install_url('https://github.com/Nik-Zainal-Group/signature.tools.lib/archive/refs/heads/master.zip')"

Rscript -e "BiocManager::install('genomation')"

Rscript -e "BiocManager::install(c('ggbio', 'TxDb.Hsapiens.UCSC.hg38.knownGene'))"

Rscript -e "install.packages('Signac', repos='https://cloud.r-project.org')"
Rscript -e "BiocManager::install(c('EnsDb.Hsapiens.v86', 'harmony'))"
conda install -c conda-forge hdf5
Rscript -e "install.packages('hdf5r', repos='https://cloud.r-project.org')"

conda install -c conda-forge r-rjags
Rscript -e "BiocManager::install('infercnv')"

Rscript -e "devtools::install_url('https://github.com/hdng/clonevol/archive/refs/heads/master.zip')"
Rscript -e "install.packages('packcircles', repos='https://cloud.r-project.org')"

# needed for ArchR
conda install conda-forge::r-cairo

Rscript -e "devtools::install_url('https://github.com/GreenleafLab/ArchR/archive/refs/heads/master.zip', repos = BiocManager::repositories())"

Rscript -e "ArchR::installExtraPackages()"

Rscript -e "devtools::install_url('https://github.com/satijalab/seurat-wrappers/archive/refs/heads/master.zip')"

Rscript -e "BiocManager::install('ShortRead')"

conda install -c conda-forge r-eulerr

Rscript -e "devtools::install_url('https://github.com/xmc811/Scillus/archive/refs/heads/development.zip')"

Rscript -e "devtools::install_url('https://github.com/VanLoo-lab/ascat/archive/refs/heads/master.zip', subdir='ASCAT')"

Rscript -e "devtools::install_url('https://github.com/chris-mcginnis-ucsf/DoubletFinder/archive/refs/heads/master.zip')"
Rscript -e "install.packages('clustree', repos='https://cloud.r-project.org')"

Rscript -e "BiocManager::install('Chicago')"

Rscript -e "devtools::install_url('https://github.com/carmonalab/STACAS/archive/refs/heads/master.zip')"

Rscript -e "BiocManager::install('batchelor')"

# Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/CIDER/CIDER_0.99.4.tar.gz')"
Rscript -e "devtools::install_url('https://github.com/zhiyuan-hu-lab/CIDER/archive/refs/heads/main.zip')"

conda install conda-forge::r-magick
Rscript -e "BiocManager::install('GSVA')"
Rscript -e "devtools::install_url('https://github.com/cansysbio/ConsensusTME/archive/refs/heads/master.zip')"

conda install conda-forge::r-gdtools
Rscript -e "BiocManager::install('pcaMethods')"
rm -rf DeconRNASeq
git clone https://git.bioconductor.org/packages/DeconRNASeq
R CMD INSTALL DeconRNASeq
rm -rf DeconRNASeq
Rscript -e "devtools::install_url('https://github.com/EDePasquale/DoubletDecon/archive/refs/heads/master.zip')"

Rscript -e "BiocManager::install('Rsubread')"

# conda install -c davidaknowles r-leafcutter # FAILED see below for an alternative route 
Rscript -e "install.packages('rstan', repos='https://cloud.r-project.org')"
Rscript -e "devtools::install_url('https://github.com/stan-dev/rstantools/archive/refs/heads/master.zip')"
Rscript -e "devtools::install_url('https://github.com/davidaknowles/leafcutter/archive/refs/heads/master.zip', subdir='leafcutter')"

Rscript -e "BiocManager::install('liftOver')"

conda install r-seqminer
Rscript -e "install.packages(c('squash', 'iotools'), repos='https://cloud.r-project.org')"
Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/sequenza/sequenza_3.0.0.tar.gz')"

Rscript -e "BiocManager::install('glmGamPoi')"
Rscript -e "devtools::install_url('https://github.com/satijalab/sctransform/archive/refs/heads/develop.zip')"

Rscript -e "install.packages('Ckmeans.1d.dp', repos='https://cloud.r-project.org')"

Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/modes/modes_0.7.0.tar.gz')"

Rscript -e "install.packages(c('dynamicTreeCut', 'roll'), repos='https://cloud.r-project.org')"
Rscript -e "install.packages('hdf5r', repos='https://cloud.r-project.org')"
conda install conda-forge::r-units
conda install conda-forge::r-sf
conda install conda-forge::r-spdep
Rscript -e "devtools::install_url('https://github.com/cole-trapnell-lab/monocle3/archive/refs/heads/develop.zip')"


conda install -c bioconda pysamstats # FAILED

Rscript -e "install.packages('LDlinkR', repos='https://cloud.r-project.org')"

Rscript -e "install.packages('randomForest', repos='https://cloud.r-project.org')"


Rscript -e "BiocManager::install('multiGSEA')"
Rscript -e "devtools::install_url('http://research-pub.gene.com/REdiscoverTEpaper/data/REdiscoverTEdata_1.0.1.tar.gz')"

Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/Matrix.utils/Matrix.utils_0.9.8.tar.gz')"

Rscript -e "devtools::install_url('https://github.com/karakulahg/TEffectR/archive/refs/heads/master.zip')"

Rscript -e "BiocManager::install('minfi')"
Rscript -e "BiocManager::install(c('IlluminaHumanMethylationEPICanno.ilm10b4.hg19', 'IlluminaHumanMethylationEPICmanifest', 'missMethyl', 'minfiData', 'DMRcate'))"

Rscript -e "BiocManager::install('preprocessCore', configure.args='--disable-threading', force = TRUE)"

Rscript -e "install.packages(c('clusterSim', 'clv'), repos='https://cloud.r-project.org')"
Rscript -e "devtools::install_url('https://github.com/saeyslab/nichenetr/archive/refs/heads/master.zip')"

Rscript -e "BiocManager::install('kstreet13/slingshot')"


conda install conda-forge::r-ncdf4
Rscript -e "install.packages(c('HiClimR', 'ccaPP', 'egg'), repos='https://cloud.r-project.org')"
Rscript -e "BiocManager::install('sva')"
Rscript -e "devtools::install_url('https://github.com/digitalcytometry/cytotrace2/archive/refs/heads/main.zip', subdir = 'cytotrace2_r')"
python -m pip install scanoramaCT

conda install conda-forge::r-rpostgres
Rscript -e "devtools::install_url('https://github.com/PriceLab/ghdb/archive/refs/heads/master.zip')"

Rscript -e "BiocManager::install('destiny')"

Rscript -e "install.packages('openssl', repos='https://cloud.r-project.org')"
Rscript -e "install.packages('pracma', repos='http://R-Forge.R-project.org')"

Rscript -e "devtools::install_url('https://github.com/trevorld/r-optparse/archive/refs/heads/master.zip')"

conda install -c conda-forge r-mcmcpack
Rscript -e "install.packages(c('mvtnorm','ellipse','coda','Matrix','Rtsne','gtools','foreach','doParallel','doSNOW','snow','lattice','MASS','bayesm','robustbase','chron','mnormt','schoolmath','RColorBrewer'), repos='https://cloud.r-project.org')"

Rscript -e "BiocManager::install('DEXSeq')"

# for R package SCENIC
conda install -c conda-forge r-arrow
Rscript -e "BiocManager::install(c('AUCell', 'RcisTarget', 'GENIE3'))"
Rscript -e "devtools::install_url('https://github.com/bokeh/rbokeh/archive/refs/heads/main.zip')"
Rscript -e "BiocManager::install('R2HTML')"
Rscript -e "devtools::install_url('https://github.com/aertslab/SCopeLoomR/archive/refs/heads/master.zip', build_vignettes = TRUE)"
Rscript -e "devtools::install_url('https://github.com/aertslab/SCENIC/archive/refs/heads/master.zip')"
Rscript -e "install.packages(c('ISOpureR', 'DiffCorr'), repos='https://cloud.r-project.org')"

Rscript -e "devtools::install_url('https://github.com/broadinstitute/cdsr_models/archive/refs/heads/master.zip')"

Rscript -e "devtools::install_url('https://github.com/PhanstielLab/Sushi/archive/refs/heads/master.zip')"
Rscript -e "BiocManager::install('ChromSCape')"

Rscript -e "devtools::install_url('https://github.com/sztup/scarHRD/archive/refs/heads/master.zip', build_vignettes = TRUE)"

Rscript -e "devtools::install_url('https://github.com/guokai8/scGSVA/archive/refs/heads/main.zip')"

Rscript -e "BiocManager::install('reactome.db')"
python -m pip install spatialde

Rscript -e "install.packages(c('poolr', 'tsne', 'flexmix', 'fpc'), repos='https://cloud.r-project.org')"

Rscript -e "devtools::install_url('https://github.com/cit-bioinfo/mMCP-counter/archive/refs/heads/master.zip')"

Rscript -e "devtools::install_url('https://github.com/mojaveazure/seurat-disk/archive/refs/heads/master.zip')"

Rscript -e "install.packages('immunarch', repos='https://cloud.r-project.org')"

Rscript -e "install.packages('strawr', repos='https://cloud.r-project.org')"
Rscript -e "devtools::install_url('https://github.com/kharchenkolab/numbat/archive/refs/heads/main.zip')"

Rscript -e "install.packages(c('keras', 'ijtiff'), repos='https://cloud.r-project.org')"

Rscript -e "install.packages('bbmle', repos='https://cloud.r-project.org')"
Rscript -e "devtools::install_url('https://github.com/choisy/cutoff/archive/refs/heads/master.zip')"

Rscript -e "devtools::install_url('https://bioconductor.org/packages/3.19/bioc/src/contrib/zlibbioc_1.50.0.tar.gz')"
Rscript -e "BiocManager::install('PoisonAlien/maftools')"

Rscript -e "BiocManager::install('illuminaHumanv4.db')"

Rscript -e "BiocManager::install('zellkonverter')"

Rscript -e "BiocManager::install('NanoStringNCTools')"
Rscript -e "BiocManager::install('GeomxTools')"
Rscript -e "BiocManager::install('GeoMxWorkflows')"

conda install conda-forge::r-maptools
Rscript -e "install.packages('openxlsx', repos='https://cloud.r-project.org')"
conda install bioconda::bioconductor-cellhts2 # FAILED

# for custom gitlab.py script to work if this R is loaded
python -m pip install requests 

Rscript -e "BiocManager::install('Orthology.eg.db')"
Rscript -e "install.packages('effsize', repos='https://cloud.r-project.org')"

Rscript -e "BiocManager::install(c('viper', 'dorothea'))"
Rscript -e "install.packages('enrichR', repos='https://cloud.r-project.org')"
Rscript -e "BiocManager::install('aracne.networks')"

Rscript -e "BiocManager::install('scDblFinder')"
python -m pip install PyYAML

Rscript -e "install.packages(c('languageserver', 'unigd', 'AsioHeaders'), repos='https://cloud.r-project.org')"
Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/httpgd/httpgd_2.0.4.tar.gz')"

python -m pip install radian

Rscript -e "devtools::install_url('https://github.com/munoztd0/reprtree/archive/refs/heads/master.zip')"

Rscript -e "install.packages('seqinr', repos='https://cloud.r-project.org')"

Rscript -e "devtools::install_url('https://github.com/carmonalab/ProjecTILs/archive/refs/heads/master.zip')"

Rscript -e "devtools::install_url('https://github.com/carmonalab/SignatuR/archive/refs/heads/master.zip')"

Rscript -e "devtools::install_url('https://github.com/vladchimescu/lpsymphony/archive/refs/heads/master.zip')"
Rscript -e "devtools::install_url('https://github.com/nignatiadis/IHW/archive/refs/heads/master.zip')"
Rscript -e "devtools::install_url('https://github.com/saeyslab/multinichenetr/archive/refs/heads/main.zip')"

Rscript -e "devtools::install_url('https://github.com/jinworks/CellChat/archive/refs/heads/main.zip')"