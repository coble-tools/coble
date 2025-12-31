##########################################################
# COBLE: Complex Bioinformatics Example, (c) ICR 2025
##########################################################
coble:
  - environment: coble-env-bioinf
channels:
# note the reverse order of priority
  - defaults
  - r
  - bioconda
  - conda-forge

languages:
  - r-base=4.5.2@conda-forge
  - python=3.14.0@conda-forge

flags:
  - dependencies: True
  - build-tools: True
  - ncpus: 8

bash:
  - # Special installs outside of conda for awkward pysamstats package  
  - python -m pip install "setuptools>=59.0"
  - python -m pip install --upgrade "Cython>=3.0.11"
  - python -m pip install pysam
  - CFLAGS="-Wno-error=incompatible-pointer-types" CPPFLAGS="-Wno-error=incompatible-pointer-types" python -m pip install --no-build-isolation git+https://github.com/rachelicr/pysamstats.git

r-conda:
  - biocmanager
  - devtools
  - data.table  
bioc-package:  
  - fgsea

r-conda:
  - stringi 
  - rcpp 
  - plyr 
  - reticulate 
  - sitmo
  - seurat
  - units

r-conda:
  - raster
  - spdep
  - magick
bioc-package:
  - stJoincount

conda:
  - pandoc
  - pypandoc
  - boost-cpp
r-conda:
  - xml
  - xlconnect
  - xml2
  - testthat
  - systemfonts
  - ragg

# for fonts to work otherwise default unix ones are DejaVu
conda:
  - fonts-conda-ecosystem 
  - mscorefonts 
r-conda:
  - nloptr 
  - polyclip
bioc-package:  
  - limma
  - vsn
  - edgeR
  - org.Hs.eg.db
  - org.Mm.eg.db

r-conda:
   - tzdb
  - vroom
  - readr
  - readxl
  - rcppannoy
  - glmnet

r-package:
  - gdata

r-url:
  - https://cran.r-project.org/src/contrib/Archive/NanoStringNorm/NanoStringNorm_1.2.1.1.tar.gz

r-package:
  - bedr
  - SIMMS
  - haven
  - foreign
  - spatstat

# required for sequenze to work with hg38. Default copy number package from BioConductor does not support beyond hg19
r-url:
  - https://github.com/aroneklund/copynumber/archive/refs/heads/master.zip

# these wont install happily from install.packages (needed for FactoMineR)
r-conda:
  - rcpparmadillo
  - conquer
  - minqa
  - lme4
r-package:
  - FactoMineR
  - factoextra

conda:
  - patch
r-conda:
  - gifski  
r-package:
  #- TFMPvalue
  - otelsdk
  - knitr
  - rmarkdown
  - inline

r-conda:
  - rjson
  - interp
bioc-package:
  - biomaRt
  - rtracklayer
  - GenomicFeatures
  - BSgenome
  - VariantAnnotation
  - ensembldb
  - biovizBase
  - Gviz
  - GenomicInteractions

r-package:
  - distributions3
  - mboost
  - AER
  - brglm2
  - flexmix
  - modelsummary
  - nonnest2
  - tinytest  
  - UpSetR
  - plotrix
  - gplots
  - drc

r-package:
  - countreg@r-forge
  - chicane

r-conda:
  - v8  
  - arrow
bioc-package:  
  - multtest
  - GSEABase
  - reshape
  - TeachingDemos
  - tidyverse
  - SingleR
  - scran
  - celldex

# # needed for ArchR and scater
r-conda:
  - cairo
bioc-package:
  - scater
  - cellHTS2

bioc-package:  
  - MAST
  - impute
  - genefu
  - fastseg
  - methylKit

r-package:
  - tidyverse
  - argparser
  - stringdist

bioc-package:
  - BSgenome.Hsapiens.NCBI.GRCh38
  - genomation
  - ggbio
  - TxDb.Hsapiens.UCSC.hg38.knownGene

r-url:
  - https://github.com/Nik-Zainal-Group/signature.tools.lib/archive/refs/heads/master.zip

r-package:
  - Signac
bioc-package:  
  - EnsDb.Hsapiens.v86
  - harmony
conda:
  - hdf5
r-package:  
  - hdf5r

r-conda:
  - rjags
bioc-package:  
  - infercnv

r-url:
  - https://github.com/hdng/clonevol/archive/refs/heads/master.zip
r-package:
  - packcircles

#r-conda:
#  - pdftools  
#  - s2  
#  - sf  
#bioc-conda:
#  - tfbstools
#bioc-package:
#  - chromVAR
#  - ComplexHeatmap
#  - motifmatchr
#  - slingshot
#  - grr
# r-conda:
#  - TFMPvalue
#r-url:
#  - https://github.com/GreenleafLab/ArchR/archive/refs/heads/master.zip

#bash:
#  - Rscript -e "ArchR::installExtraPackages()"

r-conda:
  - grr
r-url:
  - https://github.com/satijalab/seurat-wrappers/archive/refs/heads/master.zip

bioc-package:
  - ShortRead

r-conda:
  - eulerr

r-url:
  - https://github.com/xmc811/Scillus/archive/refs/heads/development.zip
  - https://github.com/VanLoo-lab/ascat/archive/refs/heads/master.zip@ASCAT
  - https://github.com/chris-mcginnis-ucsf/DoubletFinder/archive/refs/heads/master.zip
r-package:
  - clustree

bioc-package:
  - Chicago

r-url:
  - https://github.com/carmonalab/STACAS/archive/refs/heads/master.zip

bioc-package:  
  - batchelor

r-url:
  - https://cran.r-project.org/src/contrib/Archive/CIDER/CIDER_0.99.4.tar.gz
  - https://github.com/zhiyuan-hu-lab/CIDER/archive/refs/heads/main.zip

bioc-package:
  - GSVA
r-url:
  - https://github.com/cansysbio/ConsensusTME/archive/refs/heads/master.zip

r-conda:
  - gdtools
bioc-package:
  - pcaMethods
r-url:
  - https://github.com/Shicheng-Guo/DeconRNASeq/archive/refs/heads/master.zip
  - https://github.com/EDePasquale/DoubletDecon/archive/refs/heads/master.zip

bioc-package:
  - Rsubread

# # conda install -c davidaknowles r-leafcutter # FAILED see below for an alternative route 
# Rscript -e "install.packages('rstan', repos='https://cloud.r-project.org')"
# Rscript -e "devtools::install_url('https://github.com/stan-dev/rstantools/archive/refs/heads/master.zip', dependencies = FALSE)"
# Rscript -e "devtools::install_url('https://github.com/davidaknowles/leafcutter/archive/refs/heads/master.zip', subdir='leafcutter', dependencies = TRUE)"
# conda install -y davidaknowles::r-leafcutter --freeze-installed

bioc-package:
  - liftOver

r-conda:
  - seqminer
r-package:
  - squash
  - iotools
r-url:
  - https://cran.r-project.org/src/contrib/Archive/sequenza/sequenza_3.0.0.tar.gz

bioc-package:
  - glmGamPoi
r-url:
  - https://github.com/satijalab/sctransform/archive/refs/heads/develop.zip

r-package:
  - Ckmeans.1d.dp

r-url:
  - https://cran.r-project.org/src/contrib/Archive/modes/modes_0.7.0.tar.gz

r-package:
  - dynamicTreeCut
  - roll  
r-url:
  - https://github.com/cole-trapnell-lab/monocle3/archive/refs/heads/develop.zip

r-package:
  - LDlinkR
  - randomForest

bioc-package:
  - multiGSEA

r-url:
  - http://research-pub.gene.com/REdiscoverTEpaper/data/REdiscoverTEdata_1.0.1.tar.gz
  - https://cran.r-project.org/src/contrib/Archive/Matrix.utils/Matrix.utils_0.9.8.tar.gz
  - https://github.com/karakulahg/TEffectR/archive/refs/heads/master.zip

bioc-package:  
  - minfi
  - IlluminaHumanMethylationEPICanno.ilm10b4.hg19
  - IlluminaHumanMethylationEPICmanifest
  - missMethyl
  - minfiData
  - DMRcate

bash:
  - Rscript -e "BiocManager::install('preprocessCore', configure.args='--disable-threading', force = TRUE)"

r-package:
  - clusterSim
  - clv
r-url:
  - https://github.com/saeyslab/nichenetr/archive/refs/heads/master.zip

bioc-package:
  - kstreet13/slingshot

r-conda:
  - ncdf4
r-package:
  - HiClimR
  - ccaPP
  - egg
bioc-package:
  - sva
r-url:
  - https://github.com/digitalcytometry/cytotrace2/archive/refs/heads/main.zip@cytotrace2_r
pip:
  - scanoramaCT

r-conda:
  - rpostgres
r-url:
  - https://github.com/PriceLab/ghdb/archive/refs/heads/master.zip

bioc-package:
  - destiny

r-package:
  - openssl
  - pracma@r-forge

r-url:
  - https://github.com/trevorld/r-optparse/archive/refs/heads/master.zip

r-conda:
  - mcmcpack
r-package:
  - mvtnorm
  - ellipse
  - coda
  - Matrix
  - Rtsne
  - gtools
  - foreach
  - doParallel
  - doSNOW
  - snow
  - lattice
  - MASS
  - bayesm
  - robustbase
  - chron
  - mnormt
  - schoolmath
  - RColorBrewer

bioc-package:
- DEXSeq

# # for R package SCENIC
bioc-package:
  - AUCell
  - RcisTarget
  - GENIE3
  - R2HTML
r-url:
  - https://github.com/bokeh/rbokeh/archive/refs/heads/main.zip
  - https://github.com/aertslab/SCopeLoomR/archive/refs/heads/master.zip
  - https://github.com/aertslab/SCENIC/archive/refs/heads/master.zip
r-package:
  - ISOpureR
  - DiffCorr

r-url:
  - https://github.com/broadinstitute/cdsr_models/archive/refs/heads/master.zip
  - https://github.com/PhanstielLab/Sushi/archive/refs/heads/master.zip
bioc-package:
  - ChromSCape

r-url:
  - https://github.com/sztup/scarHRD/archive/refs/heads/master.zip
  - https://github.com/guokai8/scGSVA/archive/refs/heads/main.zip

bioc-package:
  - reactome.db
pip:
  - spatialde

r-package:
  - poolr
  - tsne  
  - fpc

r-url:
  - https://github.com/cit-bioinfo/mMCP-counter/archive/refs/heads/master.zip
  - https://github.com/mojaveazure/seurat-disk/archive/refs/heads/master.zip

r-package:
  - immunarch
  - strawr
r-url:
  - https://github.com/kharchenkolab/numbat/archive/refs/heads/main.zip

r-package:
  - keras
  - ijtiff
  - bbmle

r-url:
  - https://github.com/choisy/cutoff/archive/refs/heads/master.zip
  - https://bioconductor.org/packages/3.19/bioc/src/contrib/zlibbioc_1.50.0.tar.gz

bioc-package:
  - PoisonAlien/maftools
  - illuminaHumanv4.db
  - zellkonverter
  - NanoStringNCTools
  - GeomxTools
  - GeoMxWorkflows

r-package:
  - openxlsx

# conda install -y bioconda::bioconductor-cellhts2 --freeze-installed # FAILED

# # for custom gitlab.py script to work if this R is loaded
pip:
  - requests

bioc-package:
  - Orthology.eg.db
  - viper
  - dorothea
  - aracne.networks
  - scDblFinder

r-package:
  - effsize
  - enrichR

pip:
  - PyYAML
  - radian

r-package:
  - languageserver
  - unigd
  - AsioHeaders
  - seqinr

r-url:
  - https://cran.r-project.org/src/contrib/Archive/httpgd/httpgd_2.0.4.tar.gz
  - https://github.com/munoztd0/reprtree/archive/refs/heads/master.zip
  - https://github.com/carmonalab/ProjecTILs/archive/refs/heads/master.zip
  - https://github.com/carmonalab/SignatuR/archive/refs/heads/master.zip
bioc-package:
  - lpsymphony
r-url:  
  - https://github.com/nignatiadis/IHW/archive/refs/heads/master.zip
  - https://github.com/saeyslab/multinichenetr/archive/refs/heads/main.zip
  - https://github.com/jinworks/CellChat/archive/refs/heads/main.zip

# Maptools is deprecated and I did a fix to memory allocation
conda:
  - geos
r-url:
  - https://cran.r-project.org/src/contrib/Archive/sp/sp_2.1-3.tar.gz  
  - https://cran.r-project.org/src/contrib/Archive/rgeos/rgeos_0.6-4.tar.gz
  - https://github.com/rachelicr/r-maptools/archive/refs/heads/main.zip
  