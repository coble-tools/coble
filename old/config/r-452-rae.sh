# recipe for building Syed's 4.5.2
# sbatch --mail-user rachel.alcraft@icr.ac.uk code/coble-slurm.sh --results results/r-452-rae --input config/r-452-rae.sh --env ./envs/r-452-rae --skip-errors --override-envs

conda create -y -p ${CONDA_COBLE_ENV} r-base=4.5.2 python=3.14.0    
conda activate ${CONDA_COBLE_ENV}

conda install -y r-biocmanager --freeze-installed
conda install -y r-devtools --freeze-installed
conda install -y r-remotes --freeze-installed

conda install -y r-data.table --freeze-installed
Rscript -e "BiocManager::install('fgsea',force=TRUE)"

conda install -y -c conda-forge r-stringi r-rcpp r-plyr r-reticulate r-sitmo --freeze-installed

conda install -y conda-forge::r-seurat --freeze-installed

conda install -y conda-forge::r-units --freeze-installed

conda install -y r-raster --freeze-installed
conda install -y r-spdep --freeze-installed
conda install -y r-magick --freeze-installed
Rscript -e "BiocManager::install('stJoincount',force=TRUE)"

conda install -y -c conda-forge libxml2 --freeze-installed
conda install -y -c conda-forge pandoc pypandoc boost-cpp  r-xml r-xlconnect r-xml2 r-testthat r-systemfonts r-ragg --freeze-installed

# for fonts to work otherwise default unix ones are DejaVu
conda install -y -c conda-forge fonts-conda-ecosystem mscorefonts r-nloptr r-polyclip --freeze-installed

Rscript -e "install.packages('devtools', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

conda install -y -c conda-forge zlib --freeze-installed
conda install -y conda-forge::r-rsqlite --freeze-installed
Rscript -e "BiocManager::install(c('limma', 'vsn', 'edgeR', 'org.Hs.eg.db', 'org.Mm.eg.db'))"

conda install -y -c conda-forge r-tzdb r-vroom r-readr r-readxl r-rcppannoy r-glmnet --freeze-installed

Rscript -e "install.packages('gdata', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
#wget https://cran.r-project.org/src/contrib/Archive/NanoStringNorm/NanoStringNorm_1.2.1.1.tar.gz
#R CMD INSTALL NanoStringNorm_1.2.1.1.tar.gz 
Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/NanoStringNorm/NanoStringNorm_1.2.1.1.tar.gz')"

Rscript -e "install.packages(c('bedr', 'SIMMS', 'haven', 'foreign', 'spatstat'), repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

# required for sequenze to work with hg38. Default copy number package from BioConductor does not support beyond hg19
# Rscript -e "remotes::install_github('aroneklund/copynumber')" #RA
Rscript -e "devtools::install_url('https://github.com/aroneklund/copynumber/archive/refs/heads/master.zip')"

# these wont install happily from install.packages (needed for FactoMineR)
conda install -y -c conda-forge r-rcpparmadillo r-conquer r-minqa --freeze-installed

conda install -y conda-forge::r-lme4 --freeze-installed
Rscript -e "install.packages(c('FactoMineR', 'factoextra'), repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

Rscript -e "install.packages(c('knitr', 'rmarkdown', 'inline'), repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

conda install -y -c conda-forge r-rjson r-interp --freeze-installed
Rscript -e "BiocManager::install(c('biomaRt', 'rtracklayer',  'GenomicFeatures', 'BSgenome', 'VariantAnnotation', 'ensembldb', 'biovizBase', 'Gviz', 'GenomicInteractions'))"

Rscript -e "install.packages(c('distributions3', 'mboost', 'AER', 'brglm2', 'flexmix', 'modelsummary', 'nonnest2', 'tinytest', 'knitr', 'UpSetR', 'plotrix', 'gplots', 'drc'), repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

#Rscript -e "install.packages('countreg', repos='http://R-Forge.R-project.org', dependencies = TRUE)"  #RA failed on coble
Rscript -e "install.packages('chicane', dependencies=TRUE,,repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

conda install -y conda-forge::r-v8 --freeze-installed
#Rscript -e "BiocManager::install(c('multtest', 'GSEABase', 'cellHTS2', 'reshape', 'TeachingDemos', 'tidyverse', 'SingleR', 'scran', 'scater', 'celldex'))"  #RA failed on coble

#Rscript -e "BiocManager::install(c('MAST', 'impute', 'genefu', 'fastseg'))"   #RA failed on coble

Rscript -e "BiocManager::install('methylKit')"
Rscript -e "install.packages(c('tidyverse', 'argparser', 'stringdist'), repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
Rscript -e "BiocManager::install('BSgenome.Hsapiens.NCBI.GRCh38')"
# Rscript -e "remotes::install_github('Nik-Zainal-Group/signature.tools.lib')" #RA
Rscript -e "devtools::install_url('https://github.com/Nik-Zainal-Group/signature.tools.lib/archive/refs/heads/master.zip')"
Rscript -e "BiocManager::install('genomation')"

Rscript -e "BiocManager::install(c('ggbio', 'TxDb.Hsapiens.UCSC.hg38.knownGene'))"

Rscript -e "install.packages('Signac', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
Rscript -e "BiocManager::install(c('EnsDb.Hsapiens.v86', 'harmony'))"
conda install -y -c conda-forge hdf5 --freeze-installed
Rscript -e "install.packages('hdf5r', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

conda install -y -c conda-forge r-rjags --freeze-installed
Rscript -e "BiocManager::install('infercnv')"

# Rscript -e "remotes::install_github('hdng/clonevol')" #RA
Rscript -e "devtools::install_url('https://github.com/hdng/clonevol/archive/refs/heads/master.zip')"
Rscript -e "install.packages('packcircles', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

# needed for ArchR
conda install -y conda-forge::r-cairo --freeze-installed

# Rscript -e "remotes::install_github('GreenleafLab/ArchR', ref='master', repos = BiocManager::repositories())" #RA
Rscript -e "devtools::install_url('https://github.com/GreenleafLab/ArchR/archive/refs/heads/master.zip', repos = BiocManager::repositories())"

Rscript -e "ArchR::installExtraPackages()"

# Rscript -e "remotes::install_github('satijalab/seurat-wrappers')" #RA
Rscript -e "devtools::install_url('https://github.com/satijalab/seurat-wrappers/archive/refs/heads/master.zip')"

Rscript -e "BiocManager::install('ShortRead')"

conda install -y -c conda-forge r-eulerr --freeze-installed

# Rscript -e "remotes::install_github('xmc811/Scillus', ref = 'development')" #RA
Rscript -e "devtools::install_url('https://github.com/xmc811/Scillus/archive/refs/heads/development.zip')"
# Rscript -e "remotes::install_github('VanLoo-lab/ascat/ASCAT')" #RA
Rscript -e "devtools::install_url('https://github.com/VanLoo-lab/ascat/archive/refs/heads/master.zip', subdir='ASCAT')"

# Rscript -e "remotes::install_github('chris-mcginnis-ucsf/DoubletFinder')" #RA
Rscript -e "devtools::install_url('https://github.com/chris-mcginnis-ucsf/DoubletFinder/archive/refs/heads/master.zip')"
Rscript -e "install.packages('clustree', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

Rscript -e "BiocManager::install('Chicago')"

# Rscript -e "remotes::install_github('carmonalab/STACAS')" #RA
Rscript -e "devtools::install_url('https://github.com/carmonalab/STACAS/archive/refs/heads/master.zip')"

Rscript -e "BiocManager::install('batchelor')"

Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/CIDER/CIDER_0.99.4.tar.gz')"

conda install -y conda-forge::r-magick --freeze-installed
Rscript -e "BiocManager::install('GSVA')"

# Rscript -e "remotes::install_github('cansysbio/ConsensusTME')" #RA
Rscript -e "devtools::install_url('https://github.com/cansysbio/ConsensusTME/archive/refs/heads/master.zip')"

conda install -y conda-forge::r-gdtools --freeze-installed
Rscript -e "BiocManager::install('pcaMethods')"
rm -rf DeconRNASeq
git clone https://git.bioconductor.org/packages/DeconRNASeq
#R CMD INSTALL DeconRNASeq # RA it worked before
rm -rf DeconRNASeq
Rscript -e "BiocManager::install('fansi',force=TRUE)"
Rscript -e "BiocManager::install('gert',force=TRUE)"
Rscript -e "BiocManager::install('gower',force=TRUE)"
Rscript -e "BiocManager::install('Found',force=TRUE)"
Rscript -e "BiocManager::install('DeconRNASeq')"
#Rscript -e "remotes::install_github('EDePasquale/DoubletDecon',force=TRUE)" #RA failed on coble

Rscript -e "BiocManager::install('Rsubread')"

# conda install -c davidaknowles r-leafcutter # FAILED see below for an alternative route	
Rscript -e "install.packages('rstan', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Rscript -e "remotes::install_github('stan-dev/rstantools')" #RA
Rscript -e "devtools::install_url('https://github.com/stan-dev/rstantools/archive/refs/heads/master.zip')"
#Rscript -e "remotes::install_github('davidaknowles/leafcutter/leafcutter')"

Rscript -e "BiocManager::install('liftOver')"

conda install -y r-seqminer --freeze-installed
Rscript -e "install.packages(c('squash', 'iotools'), repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# wget https://cran.r-project.org/src/contrib/Archive/sequenza/sequenza_3.0.0.tar.gz
# R CMD INSTALL sequenza_3.0.0.tar.gz
Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/sequenza/sequenza_3.0.0.tar.gz')"

Rscript -e "BiocManager::install('glmGamPoi')"
# Rscript -e "remotes::install_github('satijalab/sctransform', ref = 'develop')" #RA
Rscript -e "devtools::install_url('https://github.com/satijalab/sctransform/archive/refs/heads/develop.zip')"

Rscript -e "install.packages('Ckmeans.1d.dp', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

# wget https://cran.r-project.org/src/contrib/Archive/modes/modes_0.7.0.tar.gz
# R CMD INSTALL modes_0.7.0.tar.gz
Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/modes/modes_0.7.0.tar.gz')"

Rscript -e "install.packages(c('dynamicTreeCut', 'roll'), repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

Rscript -e "install.packages('hdf5r', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

conda install -y conda-forge::r-units --freeze-installed
conda install -y conda-forge::r-sf --freeze-installed
conda install -y conda-forge::r-spdep --freeze-installed
# Rscript -e "remotes::install_github('cole-trapnell-lab/monocle3', ref='develop')" RA
Rscript -e "devtools::install_url('https://github.com/cole-trapnell-lab/monocle3/archive/refs/heads/develop.zip')"

# conda install -c bioconda pysamstats # FAILED  # RAE-FIX
python -m pip install "setuptools>=59.0"
python -m pip install --upgrade "Cython>=3.0.11"
python -m pip install pysam
python -m pip install --no-build-isolation git+https://github.com/rachelicr/pysamstats.git

Rscript -e "install.packages('LDlinkR', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

Rscript -e "install.packages('randomForest', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

Rscript -e "BiocManager::install('multiGSEA')"
#wget  http://research-pub.gene.com/REdiscoverTEpaper/data/REdiscoverTEdata_1.0.1.tar.gz
#R CMD INSTALL REdiscoverTEdata_1.0.1.tar.gz 
Rscript -e "devtools::install_url('http://research-pub.gene.com/REdiscoverTEpaper/data/REdiscoverTEdata_1.0.1.tar.gz')"

#wget https://cran.r-project.org/src/contrib/Archive/Matrix.utils/Matrix.utils_0.9.8.tar.gz
#R CMD INSTALL Matrix.utils_0.9.8.tar.gz 
Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/Matrix.utils/Matrix.utils_0.9.8.tar.gz')"

# Rscript -e "remotes::install_github('karakulahg/TEffectR')" #RA
Rscript -e "devtools::install_url('https://github.com/karakulahg/TEffectR/archive/refs/heads/master.zip')"

Rscript -e "BiocManager::install('minfi')"
Rscript -e "BiocManager::install(c('IlluminaHumanMethylationEPICanno.ilm10b4.hg19', 'IlluminaHumanMethylationEPICmanifest', 'missMethyl', 'minfiData', 'DMRcate'))"

Rscript -e "BiocManager::install('preprocessCore', configure.args='--disable-threading', force = TRUE)"

Rscript -e "install.packages(c('clusterSim', 'clv'), repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

# Rscript -e "remotes::install_github('saeyslab/nichenetr')" #RA
Rscript -e "devtools::install_url('https://github.com/saeyslab/nichenetr/archive/refs/heads/master.zip')"
Rscript -e "BiocManager::install('kstreet13/slingshot')"

conda install -y conda-forge::r-ncdf4 --freeze-installed
Rscript -e "install.packages(c('HiClimR', 'ccaPP', 'egg'), repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
Rscript -e "BiocManager::install('sva')"
# Rscript -e "remotes::install_github('digitalcytometry/cytotrace2', subdir = 'cytotrace2_r')" #RA
Rscript -e "devtools::install_url('https://github.com/digitalcytometry/cytotrace2/archive/refs/heads/main.zip', subdir = 'cytotrace2_r')"
python -m pip install scanoramaCT

conda install -y conda-forge::r-rpostgres --freeze-installed
# Rscript -e "remotes::install_github('PriceLab/ghdb')" #RA
Rscript -e "devtools::install_url('https://github.com/PriceLab/ghdb/archive/refs/heads/master.zip')"

Rscript -e "BiocManager::install('destiny')"

# Rscript -e "remotes::install_github('sqjin/CellChat')" #RA
Rscript -e "devtools::install_url('https://github.com/sqjin/CellChat/archive/refs/heads/master.zip')"
Rscript -e "install.packages('openssl', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

Rscript -e "install.packages('pracma', repos='http://R-Forge.R-project.org')"

# Rscript -e "remotes::install_github('trevorld/r-optparse')" #RA
Rscript -e "devtools::install_url('https://github.com/trevorld/r-optparse/archive/refs/heads/master.zip')"

conda install -y -c conda-forge r-mcmcpack --freeze-installed
Rscript -e "install.packages(c('mvtnorm','ellipse','coda','Matrix','Rtsne','gtools','foreach','doParallel','doSNOW','snow','lattice','MASS','bayesm','robustbase','chron','mnormt','schoolmath','RColorBrewer'), repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

Rscript -e "BiocManager::install('DEXSeq')"

# for R package SCENIC
conda install -y -c conda-forge r-arrow --freeze-installed
Rscript -e "BiocManager::install(c('AUCell', 'RcisTarget', 'GENIE3'))"
# Rscript -e "remotes::install_github('bokeh/rbokeh')" #RA
Rscript -e "devtools::install_url('https://github.com/bokeh/rbokeh/archive/refs/heads/main.zip')"
Rscript -e "BiocManager::install('R2HTML')"
# Rscript -e "remotes::install_github('aertslab/SCopeLoomR', build_vignettes = TRUE)" #RA
Rscript -e "devtools::install_url('https://github.com/aertslab/SCopeLoomR/archive/refs/heads/master.zip')"
# Rscript -e "remotes::install_github('aertslab/SCENIC')" #RA
Rscript -e "devtools::install_url('https://github.com/aertslab/SCENIC/archive/refs/heads/master.zip')"
Rscript -e "install.packages(c('ISOpureR', 'DiffCorr'), repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

# Rscript -e "remotes::install_github('broadinstitute/cdsr_models')" #RA
Rscript -e "devtools::install_url('https://github.com/broadinstitute/cdsr_models/archive/refs/heads/master.zip')"

# Rscript -e "remotes::install_github('PhanstielLab/Sushi')" #RA
Rscript -e "devtools::install_url('https://github.com/PhanstielLab/Sushi/archive/refs/heads/master.zip')"
Rscript -e "BiocManager::install('ChromSCape')"

#Rscript -e "remotes::install_github('sztup/scarHRD', build_vignettes = TRUE)" RA
Rscript -e "devtools::install_url('https://github.com/sztup/scarHRD/archive/refs/heads/master.zip')"

Rscript -e "remotes::install_github('guokai8/scGSVA')"

Rscript -e "BiocManager::install('reactome.db')"

python -m pip install spatialde

Rscript -e "install.packages(c('poolr', 'tsne', 'flexmix', 'fpc'), repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

# Rscript -e "remotes::install_github('cit-bioinfo/mMCP-counter')" #RA
Rscript -e "devtools::install_url('https://github.com/cit-bioinfo/mMCP-counter/archive/refs/heads/master.zip')"

# Rscript -e "remotes::install_github('mojaveazure/seurat-disk')" #RA
Rscript -e "devtools::install_url('https://github.com/mojaveazure/seurat-disk/archive/refs/heads/master.zip')"

#Rscript -e "install.packages('immunarch', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
Rscript -e "install.packages('strawr', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

# Rscript -e "remotes::install_github('kharchenkolab/numbat')" #RA
Rscript -e "devtools::install_url('https://github.com/kharchenkolab/numbat/archive/refs/heads/main.zip')"

Rscript -e "install.packages(c('keras', 'ijtiff'), repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

Rscript -e "install.packages('bbmle', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# Rscript -e "remotes::install_github('choisy/cutoff')" #RA
Rscript -e "devtools::install_url('https://github.com/choisy/cutoff/archive/refs/heads/master.zip')"

# wget https://bioconductor.org/packages/3.19/bioc/src/contrib/zlibbioc_1.50.0.tar.gz
# R CMD INSTALL zlibbioc_1.50.0.tar.gz
Rscript -e "devtools::install_url('https://bioconductor.org/packages/3.19/bioc/src/contrib/zlibbioc_1.50.0.tar.gz')"
Rscript -e "BiocManager::install('PoisonAlien/maftools')"

Rscript -e "BiocManager::install('illuminaHumanv4.db')"

Rscript -e "BiocManager::install('zellkonverter')"

Rscript -e "BiocManager::install('NanoStringNCTools')"
Rscript -e "BiocManager::install('GeomxTools')"
Rscript -e "BiocManager::install('GeoMxWorkflows')"

# conda install conda-forge::r-maptools
R -e "devtools::install_url('https://github.com/rachelicr/r-maptools/archive/refs/heads/main.zip')" # RAE-FIX
Rscript -e "install.packages('openxlsx', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
#conda install bioconda::bioconductor-cellhts2 # FAILED  # RA
#Rscript -e "BiocManager::install('cellhts2',force=TRUE)" #RA

# for custom gitlab.py script to work if this R is loaded
python -m pip install requests 

Rscript -e "BiocManager::install('Orthology.eg.db')"
Rscript -e "install.packages('effsize', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

Rscript -e "BiocManager::install(c('viper', 'dorothea'))"
Rscript -e "install.packages('enrichR', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

Rscript -e "BiocManager::install('aracne.networks')"

Rscript -e "BiocManager::install('scDblFinder')"

python -m pip install PyYAML

Rscript -e "install.packages(c('languageserver', 'unigd', 'AsioHeaders'), repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
# wget https://cran.r-project.org/src/contrib/Archive/httpgd/httpgd_2.0.4.tar.gz
# R CMD INSTALL httpgd_2.0.4.tar.gz
Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/httpgd/httpgd_2.0.4.tar.gz')"

python -m pip install radian

# Rscript -e "remotes::install_github('munoztd0/reprtree')" #RA
Rscript -e "devtools::install_url('https://github.com/munoztd0/reprtree/archive/refs/heads/master.zip')"

Rscript -e "install.packages('seqinr', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"

# Rscript -e "remotes::install_github('carmonalab/ProjecTILs')" #RA
Rscript -e "devtools::install_url('https://github.com/carmonalab/ProjecTILs/archive/refs/heads/master.zip')"

# Rscript -e "remotes::install_github('carmonalab/SignatuR')" #RA
Rscript -e "devtools::install_url('https://github.com/carmonalab/SignatuR/archive/refs/heads/master.zip')"
# Rscript -e "devtools::install_github('vladchimescu/lpsymphony')" #RA
# Rscript -e "devtools::install_url('https://github.com/vladchimescu/lpsymphony/archive/refs/heads/master.zip')" #RA
# Rscript -e "devtools::install_github('nignatiadis/IHW')" #RA
Rscript -e "devtools::install_url('https://github.com/nignatiadis/IHW/archive/refs/heads/master.zip')"
# Rscript -e "devtools::install_github('saeyslab/multinichenetr')" #RA
Rscript -e "devtools::install_url('https://github.com/saeyslab/multinichenetr/archive/refs/heads/main.zip')"