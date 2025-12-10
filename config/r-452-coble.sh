# recipe for building Syed's 4.5.2 using coble directoves
# sbatch --mail-user rachel.alcraft@icr.ac.uk code/coble-slurm.sh --results results/r-452-coble --input config/r-452-coble.sh --env ./envs/r-452-coble

conda create -y -p ${CONDA_COBLE_ENV} r-base=4.5.2 python=3.14.0    
conda activate ${CONDA_COBLE_ENV}

coble@r@biocmanager
coble@r@devtools
coble@r@remotes

coble@r@data.table
coble@bioc@fgsea

coble@r@stringi rcpp plyr reticulate sitmo

coble@r@seurat

coble@r@units

coble@r@raster
coble@r@spdep
coble@r@magick
coble@bioc@stJoincount

conda install -y -c conda-forge libxml2
conda install -y -c conda-forge pandoc pypandoc boost-cpp  
coble@r@xml xlconnect xml2 testthat systemfonts ragg

# for fonts to work otherwise default unix ones are DejaVu
conda install -y -c conda-forge fonts-conda-ecosystem mscorefonts 
coble@r@nloptr polyclip

conda install -y -c conda-forge zlib
coble@r@rsqlite
coble@bioc@limma vsn edgeR org.Hs.eg.db org.Mm.eg.db

coble@r@tzdb vroom readr readxl rcppannoy glmnet

coble@r@gdata
Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/NanoStringNorm/NanoStringNorm_1.2.1.1.tar.gz')"

coble@r@bedr SIMMS haven foreign spatstat

# required for sequenze to work with hg38. Default copy number package from BioConductor does not support beyond hg19
# Rscript -e "remotes::install_github('aroneklund/copynumber')" #RA
Rscript -e "devtools::install_url('https://github.com/aroneklund/copynumber/archive/refs/heads/master.zip')"

# these wont install happily from install.packages (needed for FactoMineR)
coble@r@rcpparmadillo conquer minqa

coble@r@lme4
coble@r@FactoMineR factoextra

coble@r@knitr rmarkdown inline

coble@r@rjson interp
coble@bioc@biomaRt rtracklayer GenomicFeatures BSgenome VariantAnnotation ensembldb biovizBase Gviz GenomicInteractions

coble@r@distributions3 mboost AER brglm2 flexmix modelsummary nonnest2 tinytest knitr UpSetR plotrix gplots drc

#Rscript -e "install.packages('countreg', repos='http://R-Forge.R-project.org', dependencies = TRUE)"  #RA failed on coble
coble@r@chicane

conda install -y conda-forge::r-v8
#Rscript -e "BiocManager::install(c('multtest', 'GSEABase', 'cellHTS2', 'reshape', 'TeachingDemos', 'tidyverse', 'SingleR', 'scran', 'scater', 'celldex'))"  #RA failed on coble

#Rscript -e "BiocManager::install(c('MAST', 'impute', 'genefu', 'fastseg'))"   #RA failed on coble

coble@bioc@methylKit
coble@r@tidyverse argparser stringdist
coble@bioc@BSgenome.Hsapiens.NCBI.GRCh38
# Rscript -e "remotes::install_github('Nik-Zainal-Group/signature.tools.lib')" #RA
Rscript -e "devtools::install_url('https://github.com/Nik-Zainal-Group/signature.tools.lib/archive/refs/heads/master.zip')"
coble@bioc@genomation

coble@bioc@ggbio TxDb.Hsapiens.UCSC.hg38.knownGene

coble@r@Signac
coble@bioc@EnsDb.Hsapiens.v86 harmony
conda install -y -c conda-forge hdf5
coble@r@hdf5r

coble@r@rjags
coble@bioc@infercnv

# Rscript -e "remotes::install_github('hdng/clonevol')" #RA
Rscript -e "devtools::install_url('https://github.com/hdng/clonevol/archive/refs/heads/master.zip')"
coble@r@packcircles

# needed for ArchR
coble@r@cairo

# Rscript -e "remotes::install_github('GreenleafLab/ArchR', ref='master', repos = BiocManager::repositories())" #RA
Rscript -e "devtools::install_url('https://github.com/GreenleafLab/ArchR/archive/refs/heads/master.zip', repos = BiocManager::repositories())"

Rscript -e "ArchR::installExtraPackages()"

# Rscript -e "remotes::install_github('satijalab/seurat-wrappers')" #RA
Rscript -e "devtools::install_url('https://github.com/satijalab/seurat-wrappers/archive/refs/heads/master.zip')"

coble@bioc@ShortRead

coble@r@eulerr

# Rscript -e "remotes::install_github('xmc811/Scillus', ref = 'development')" #RA
Rscript -e "devtools::install_url('https://github.com/xmc811/Scillus/archive/refs/heads/development.zip')"
# Rscript -e "remotes::install_github('VanLoo-lab/ascat/ASCAT')" #RA
Rscript -e "devtools::install_url('https://github.com/VanLoo-lab/ascat/archive/refs/heads/master.zip', subdir='ASCAT')"

# Rscript -e "remotes::install_github('chris-mcginnis-ucsf/DoubletFinder')" #RA
Rscript -e "devtools::install_url('https://github.com/chris-mcginnis-ucsf/DoubletFinder/archive/refs/heads/master.zip')"
coble@r@clustree

coble@bioc@Chicago

# Rscript -e "remotes::install_github('carmonalab/STACAS')" #RA
Rscript -e "devtools::install_url('https://github.com/carmonalab/STACAS/archive/refs/heads/master.zip')"

coble@bioc@batchelor

Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/CIDER/CIDER_0.99.4.tar.gz')"

coble@r@magick
coble@bioc@GSVA

# Rscript -e "remotes::install_github('cansysbio/ConsensusTME')" #RA
Rscript -e "devtools::install_url('https://github.com/cansysbio/ConsensusTME/archive/refs/heads/master.zip')"

coble@r@gdtools
coble@bioc@pcaMethods
rm -rf DeconRNASeq
git clone https://git.bioconductor.org/packages/DeconRNASeq
#R CMD INSTALL DeconRNASeq # RA it worked before
rm -rf DeconRNASeq
coble@bioc@fansi
coble@bioc@gert
coble@bioc@gower
coble@bioc@Found
coble@bioc@DeconRNASeq
#Rscript -e "remotes::install_github('EDePasquale/DoubletDecon',force=TRUE)" #RA failed on coble

coble@bioc@Rsubread

# conda install -c davidaknowles r-leafcutter # FAILED see below for an alternative route	
coble@r@rstan
# Rscript -e "remotes::install_github('stan-dev/rstantools')" #RA
Rscript -e "devtools::install_url('https://github.com/stan-dev/rstantools/archive/refs/heads/master.zip')"
#Rscript -e "remotes::install_github('davidaknowles/leafcutter/leafcutter')"

coble@bioc@liftOver

coble@r@seqminer
coble@r@squash iotools
# wget https://cran.r-project.org/src/contrib/Archive/sequenza/sequenza_3.0.0.tar.gz
# R CMD INSTALL sequenza_3.0.0.tar.gz
Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/sequenza/sequenza_3.0.0.tar.gz')"

coble@bioc@glmGamPoi
# Rscript -e "remotes::install_github('satijalab/sctransform', ref = 'develop')" #RA
Rscript -e "devtools::install_url('https://github.com/satijalab/sctransform/archive/refs/heads/develop.zip')"

coble@r@Ckmeans.1d.dp

# wget https://cran.r-project.org/src/contrib/Archive/modes/modes_0.7.0.tar.gz
# R CMD INSTALL modes_0.7.0.tar.gz
Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/modes/modes_0.7.0.tar.gz')"

coble@r@dynamicTreeCut roll

coble@r@hdf5r

coble@r@units
coble@r@sf
coble@r@spdep
# Rscript -e "remotes::install_github('cole-trapnell-lab/monocle3', ref='develop')" RA
Rscript -e "devtools::install_url('https://github.com/cole-trapnell-lab/monocle3/archive/refs/heads/develop.zip')"

# conda install -c bioconda pysamstats # FAILED  # RAE-FIX
python -m pip install "setuptools>=59.0"
python -m pip install --upgrade "Cython>=3.0.11"
python -m pip install pysam
python -m pip install --no-build-isolation git+https://github.com/rachelicr/pysamstats.git

coble@r@LDlinkR

coble@r@randomForest

coble@bioc@multiGSEA
#wget  http://research-pub.gene.com/REdiscoverTEpaper/data/REdiscoverTEdata_1.0.1.tar.gz
#R CMD INSTALL REdiscoverTEdata_1.0.1.tar.gz 
Rscript -e "devtools::install_url('http://research-pub.gene.com/REdiscoverTEpaper/data/REdiscoverTEdata_1.0.1.tar.gz')"

#wget https://cran.r-project.org/src/contrib/Archive/Matrix.utils/Matrix.utils_0.9.8.tar.gz
#R CMD INSTALL Matrix.utils_0.9.8.tar.gz 
Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/Matrix.utils/Matrix.utils_0.9.8.tar.gz')"

# Rscript -e "remotes::install_github('karakulahg/TEffectR')" #RA
Rscript -e "devtools::install_url('https://github.com/karakulahg/TEffectR/archive/refs/heads/master.zip')"

coble@bioc@minfi
coble@bioc@IlluminaHumanMethylationEPICanno.ilm10b4.hg19 IlluminaHumanMethylationEPICmanifest missMethyl minfiData DMRcate

Rscript -e "BiocManager::install('preprocessCore', configure.args='--disable-threading', force = TRUE)"

coble@r@clusterSim clv

# Rscript -e "remotes::install_github('saeyslab/nichenetr')" #RA
Rscript -e "devtools::install_url('https://github.com/saeyslab/nichenetr/archive/refs/heads/master.zip')"
coble@bioc@kstreet13/slingshot

coble@r@ncdf4
coble@r@HiClimR ccaPP egg
coble@bioc@sva
# Rscript -e "remotes::install_github('digitalcytometry/cytotrace2', subdir = 'cytotrace2_r')" #RA
Rscript -e "devtools::install_url('https://github.com/digitalcytometry/cytotrace2/archive/refs/heads/main.zip', subdir = 'cytotrace2_r')"
python -m pip install scanoramaCT

coble@r@rpostgres
# Rscript -e "remotes::install_github('PriceLab/ghdb')" #RA
Rscript -e "devtools::install_url('https://github.com/PriceLab/ghdb/archive/refs/heads/master.zip')"

coble@bioc@destiny

# Rscript -e "remotes::install_github('sqjin/CellChat')" #RA
Rscript -e "devtools::install_url('https://github.com/sqjin/CellChat/archive/refs/heads/master.zip')"
coble@r@openssl

coble@r@pracma

# Rscript -e "remotes::install_github('trevorld/r-optparse')" #RA
Rscript -e "devtools::install_url('https://github.com/trevorld/r-optparse/archive/refs/heads/master.zip')"

coble@r@mcmcpack
coble@r@mvtnorm ellipse coda Matrix Rtsne gtools foreach doParallel doSNOW snow lattice MASS bayesm robustbase chron mnormt schoolmath RColorBrewer

coble@bioc@DEXSeq

# for R package SCENIC
coble@r@arrow
coble@bioc@AUCell RcisTarget GENIE3
# Rscript -e "remotes::install_github('bokeh/rbokeh')" #RA
Rscript -e "devtools::install_url('https://github.com/bokeh/rbokeh/archive/refs/heads/main.zip')"
coble@bioc@R2HTML
# Rscript -e "remotes::install_github('aertslab/SCopeLoomR', build_vignettes = TRUE)" #RA
Rscript -e "devtools::install_url('https://github.com/aertslab/SCopeLoomR/archive/refs/heads/master.zip')"
# Rscript -e "remotes::install_github('aertslab/SCENIC')" #RA
Rscript -e "devtools::install_url('https://github.com/aertslab/SCENIC/archive/refs/heads/master.zip')"
coble@r@ISOpureR DiffCorr

# Rscript -e "remotes::install_github('broadinstitute/cdsr_models')" #RA
Rscript -e "devtools::install_url('https://github.com/broadinstitute/cdsr_models/archive/refs/heads/master.zip')"

# Rscript -e "remotes::install_github('PhanstielLab/Sushi')" #RA
Rscript -e "devtools::install_url('https://github.com/PhanstielLab/Sushi/archive/refs/heads/master.zip')"
coble@bioc@ChromSCape

#Rscript -e "remotes::install_github('sztup/scarHRD', build_vignettes = TRUE)" RA
Rscript -e "devtools::install_url('https://github.com/sztup/scarHRD/archive/refs/heads/master.zip')"

Rscript -e "remotes::install_github('guokai8/scGSVA')"

coble@bioc@reactome.db

python -m pip install spatialde

coble@r@poolr tsne flexmix fpc

# Rscript -e "remotes::install_github('cit-bioinfo/mMCP-counter')" #RA
Rscript -e "devtools::install_url('https://github.com/cit-bioinfo/mMCP-counter/archive/refs/heads/master.zip')"

# Rscript -e "remotes::install_github('mojaveazure/seurat-disk')" #RA
Rscript -e "devtools::install_url('https://github.com/mojaveazure/seurat-disk/archive/refs/heads/master.zip')"

#Rscript -e "install.packages('immunarch', repo='https://cloud.r-project.org',force=TRUE,quiet=FALSE)"
coble@r@strawr

# Rscript -e "remotes::install_github('kharchenkolab/numbat')" #RA
Rscript -e "devtools::install_url('https://github.com/kharchenkolab/numbat/archive/refs/heads/main.zip')"

coble@r@keras ijtiff

coble@r@bbmle
# Rscript -e "remotes::install_github('choisy/cutoff')" #RA
Rscript -e "devtools::install_url('https://github.com/choisy/cutoff/archive/refs/heads/master.zip')"

# wget https://bioconductor.org/packages/3.19/bioc/src/contrib/zlibbioc_1.50.0.tar.gz
# R CMD INSTALL zlibbioc_1.50.0.tar.gz
Rscript -e "devtools::install_url('https://bioconductor.org/packages/3.19/bioc/src/contrib/zlibbioc_1.50.0.tar.gz')"
coble@bioc@PoisonAlien/maftools

coble@bioc@illuminaHumanv4.db

coble@bioc@zellkonverter

coble@bioc@NanoStringNCTools
coble@bioc@GeomxTools
coble@bioc@GeoMxWorkflows

# conda install conda-forge::r-maptools
R -e "devtools::install_url('https://github.com/rachelicr/r-maptools/archive/refs/heads/main.zip')" # RAE-FIX
coble@r@openxlsx
#conda install bioconda::bioconductor-cellhts2 # FAILED  # RA
#Rscript -e "BiocManager::install('cellhts2',force=TRUE)" #RA

# for custom gitlab.py script to work if this R is loaded
python -m pip install requests 

coble@bioc@Orthology.eg.db
coble@r@effsize

coble@bioc@viper dorothea
coble@r@enrichR

coble@bioc@aracne.networks

coble@bioc@scDblFinder

python -m pip install PyYAML

coble@r@languageserver unigd AsioHeaders
# wget https://cran.r-project.org/src/contrib/Archive/httpgd/httpgd_2.0.4.tar.gz
# R CMD INSTALL httpgd_2.0.4.tar.gz
Rscript -e "devtools::install_url('https://cran.r-project.org/src/contrib/Archive/httpgd/httpgd_2.0.4.tar.gz')"

python -m pip install radian

# Rscript -e "remotes::install_github('munoztd0/reprtree')" #RA
Rscript -e "devtools::install_url('https://github.com/munoztd0/reprtree/archive/refs/heads/master.zip')"

coble@r@seqinr

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