#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-05-02
# Capture time: 08:16:34 BST
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
# code/coble build --recipe recipes/papers/Zheng2017/Zheng2017.cbl --env Zheng2017 -- rebuild
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

# grep a fix in makevar
sed -i 's/^CFLAGS = /CFLAGS = -fcommon /' $CONDA_PREFIX/lib/R/etc/Makeconf

# r-package:
Rscript -e 'install.packages("lattice", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/Matrix/Matrix_1.2-6.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("ggplot2", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("Rtsne", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("svd", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("dplyr", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("plyr", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("chron", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=8)'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/data.table/data.table_1.9.6.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("pheatmap", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=8)'


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

