##########################################################
# COBLE: Complex Bioinformatics Example, (c) ICR 2026
##########################################################
coble:
  - environment: coble-env-bioinf
channels:
# note the reverse order of priority  
  - bioconda
  - conda-forge
languages:
  - r-base=4.5.2@conda-forge
  - python=3.14.0@conda-forge
flags:
  - dependencies: NA
  - system-tools: True
  - compile-tools: 11
  - ncpus: 8    
  
conda:
  - tbb<2021
  - tbb-devel<2021    

r-package:
  - RcppEigen
  - RcppParallel  
  - inline
  - gridExtra
  - loo
  - pkgbuild
  - V8
  - BH
  
bash:
# StanHeaders with flags
CXX14FLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive" \
CXX17FLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive" \
CXXFLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive -I$CONDA_PREFIX/include" \
MAKEFLAGS="-j1" \
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/StanHeaders/StanHeaders_2.21.0-7.tar.gz", repos=NULL, type="source")'

# rstan with flags
CXX14FLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive" \
CXX17FLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive" \
CXXFLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive -I$CONDA_PREFIX/include" \
MAKEFLAGS="-j1" \
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/rstan/rstan_2.21.2.tar.gz", repos=NULL, type="source")'

bioc-package:
  - DirichletMultinomial
  - TailRank  
  - Biobase  

bash:
# leafcutter with flags
CXX14FLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive" \
CXX17FLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive" \
CXXFLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive -I$CONDA_PREFIX/include" \
MAKEFLAGS="-j1" \
Rscript -e 'remotes::install_github("davidaknowles/leafcutter/leafcutter", upgrade="never", Ncpus=8)'
