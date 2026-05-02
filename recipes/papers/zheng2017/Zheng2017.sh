#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-05-02
# Capture time: 20:35:08 BST
# Captured by: ralcraft
#####################################################
# source bashrc for conda
if [ -f ~/.bash_profile ]; then source ~/.bash_profile; elif [ -f ~/.bashrc ]; then source ~/.bashrc; elif command -v conda > /dev/null 2>&1; then eval "$(conda shell.bash hook)"; fi
# Using conda executable conda: /home/ralcraft/miniforge3/condabin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/condabin/conda
#####################################################

conda env remove --name Zheng2017 -y 2>/dev/null || true
conda create --no-default-packages --name Zheng2017 -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate Zheng2017

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --show channels | grep -q 'channels:' && conda config --env --remove-key channels || true
conda config --env --set channel_priority strict
conda config --env --add channels intel
conda config --env --add channels https://repo.anaconda.com/pkgs/r
conda config --env --add channels https://repo.anaconda.com/pkgs/free
conda config --env --add channels https://repo.anaconda.com/pkgs/main

# INSTALL SECTION FOR CONDA
#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
# code/coble build --recipe recipes/papers/Zheng2017/Zheng2017.cbl --env Zheng2017 -- rebuild  --containers docker,singularity
#######################################
# compilers:
# Flag: Directive: cran-repo, Value: 
# flags:
# Flag: Directive: ncpus, Value: 8
conda config --env --set channel_priority flexible
conda env config vars set CFLAGS="-fcommon -O2"
export CFLAGS="-fcommon -O2"
conda env config vars set PKG_CFLAGS="-fcommon"
export PKG_CFLAGS="-fcommon"
conda env config vars set CXX="g++ -std=c++14"
export CXX="g++ -std=c++14"
conda env config vars set CXX1X="g++ -std=c++14"
export CXX1X="g++ -std=c++14"
conda env config vars set CXXFLAGS="-std=c++14"
export CXXFLAGS="-std=c++14"
conda env config vars set FONTCONFIG_PATH=$CONDA_PREFIX/etc/fonts
export FONTCONFIG_PATH=$CONDA_PREFIX/etc/fonts
# conda:
conda install -y --solver=libmamba --no-update-deps \
r-base=3.3.1 \
ncurses=5.9 \
_libgcc_mutex=0.1=free 
# flags:
conda config --env --set channel_priority strict
# conda:
conda install -y --solver=libmamba --no-update-deps \
libpng \
libgfortran 
# bash:

# For Ubuntu 22.04/20.04 - grab the old deb manually
rm -rf $CONDA_PREFIX/lib/libgfortran.so.3
wget http://archive.ubuntu.com/ubuntu/pool/universe/g/gcc-6/libgfortran3_6.4.0-17ubuntu1_amd64.deb
dpkg -x libgfortran3_6.4.0-17ubuntu1_amd64.deb /tmp/libgfortran3
# Copy the library into your conda env
cp /tmp/libgfortran3/usr/lib/x86_64-linux-gnu/libgfortran.so.3.0.0 $CONDA_PREFIX/lib/
ln -s $CONDA_PREFIX/lib/libgfortran.so.3.0.0 $CONDA_PREFIX/lib/libgfortran.so.3

# More simlinks
rm -rf $CONDA_PREFIX/lib/libreadline.so.6
rm -rf $CONDA_PREFIX/lib/libtinfow.so.6
rm -rf $CONDA_PREFIX/lib/libtinfo.so.6
ln -s $CONDA_PREFIX/lib/libreadline.so.7 $CONDA_PREFIX/lib/libreadline.so.6
ln -s $CONDA_PREFIX/lib/libncursesw.so.5.9 $CONDA_PREFIX/lib/libtinfow.so.6
ln -s $CONDA_PREFIX/lib/libncursesw.so.5.9 $CONDA_PREFIX/lib/libtinfo.so.6
ln -s $CONDA_PREFIX/lib/libffi.so.7 $CONDA_PREFIX/lib/libffi.so.6

# grep a fix in makevar
sed -i 's/^CFLAGS = /CFLAGS = -fcommon /' $CONDA_PREFIX/lib/R/etc/Makeconf
echo "CXX = g++ -std=c++14" >> $CONDA_PREFIX/lib/R/etc/Makeconf
echo "CXX1X = g++ -std=c++14" >> $CONDA_PREFIX/lib/R/etc/Makeconf
echo "CXXFLAGS = -std=c++14" >> $CONDA_PREFIX/lib/R/etc/Makeconf

# added in dependency layers for versioning
# r-package:
Rscript -e 'install.packages("lattice", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("chron", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("DBI", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("BH", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("assertthat", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("MASS", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/digest/digest_0.6.9.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("RColorBrewer", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("dichromat", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("munsell", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("labeling", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("stringr", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("R6", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("lazyeval", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=8)'
# r-conda:
conda install -y --solver=libmamba --no-update-deps \
'r-Rcpp=0.12.5' 
# r-package:
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/Matrix/Matrix_1.2-6.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/plyr/plyr_1.8.4.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/gtable/gtable_0.2.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/scales/scales_0.4.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/reshape2/reshape2_1.4.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/svd/svd_0.3.3.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/data.table/data.table_1.9.6.tar.gz", repos=NULL, type="source")'
# r-package:
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/ggplot2/ggplot2_2.1.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/dplyr/dplyr_0.4.3.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/Rtsne/Rtsne_0.11.tar.gz", repos=NULL, type="source")'
# r-package:
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/pheatmap/pheatmap_1.0.8.tar.gz", repos=NULL, type="source")'
# conda:
conda install -y --solver=libmamba --no-update-deps \
cairo \
pango \
fonts-anaconda \
fontconfig 

# End of recipe
# Validation script setup
echo "#!/usr/bin/env bash" > ${CONDA_PREFIX}/bin/validate.sh
echo 'echo "COBLE validation: No script has been specified for Zheng2017 environment."' >> ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
mkdir -p ${CONDA_PREFIX}/coble-recipe
cp recipes/papers/Zheng2017/Zheng2017.cbl ${CONDA_PREFIX}/coble-recipe
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble ${CONDA_PREFIX}/bin/
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble-* ${CONDA_PREFIX}/bin/

