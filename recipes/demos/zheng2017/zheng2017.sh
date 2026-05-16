#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-05-13
# Capture time: 11:47:10 BST
# Captured by: ralcraft
#####################################################
# source bashrc for conda
if [ -f ~/.bash_profile ]; then source ~/.bash_profile; elif [ -f ~/.bashrc ]; then source ~/.bashrc; elif command -v conda > /dev/null 2>&1; then eval "$(conda shell.bash hook)"; fi
# Using conda executable conda: /home/ralcraft/miniforge3/condabin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/condabin/conda
#####################################################

conda env remove --name zheng2017 -y 2>/dev/null || true
conda create --no-default-packages --name zheng2017 -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate zheng2017

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --show channels | grep -q 'channels:' && conda config --env --remove-key channels || true
conda config --env --set channel_priority strict
conda config --env --add channels https://software.repos.intel.com/python/conda/
conda config --env --add channels https://repo.anaconda.com/pkgs/r
conda config --env --add channels https://repo.anaconda.com/pkgs/free
conda config --env --add channels https://repo.anaconda.com/pkgs/main

# INSTALL SECTION FOR CONDA
#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
# code/coble build --recipe recipes/papers/zheng2017/zheng2017.cbl --env zheng2017 --rebuild
# code/coble build --recipe recipes/papers/zheng2017/zheng2017.cbl --env zheng2017 --containers docker,singularity --code-source local --validate recipes/papers/zheng2017/validate.sh --ubuntu 16.04
#######################################
# comments:
# compilers:
# Flag: Directive: cran-repo, Value: 
# flags:
# Flag: Directive: ncpus, Value: 1
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
sysroot_linux-64=2.17 \
libgfortran=3 \
ncurses=5.9 \
libpng \
r-base=3.3.1 
# flags:
conda config --env --set channel_priority strict
# bash:
# Symlinks for older library versions expected by R 3.3.1
rm -rf $CONDA_PREFIX/lib/libreadline.so.6 && echo "rm libreadline.so.6 ok" || echo "rm libreadline.so.6 failed"
rm -rf $CONDA_PREFIX/lib/libtinfow.so.6 && echo "rm libtinfow.so.6 ok" || echo "rm libtinfow.so.6 failed"
rm -rf $CONDA_PREFIX/lib/libtinfo.so.6 && echo "rm libtinfo.so.6 ok" || echo "rm libtinfo.so.6 failed"
[ -f $CONDA_PREFIX/lib/libreadline.so.7 ] && ln -s $CONDA_PREFIX/lib/libreadline.so.7 $CONDA_PREFIX/lib/libreadline.so.6 && echo "ln libreadline.so.6->7 ok" || ln -s $CONDA_PREFIX/lib/libreadline.so.8 $CONDA_PREFIX/lib/libreadline.so.6 && echo "ln libreadline.so.6->8 ok"
ln -s $CONDA_PREFIX/lib/libncursesw.so.5.9 $CONDA_PREFIX/lib/libtinfow.so.6 && echo "ln libtinfow.so.6 ok" || echo "ln libtinfow.so.6 failed"
ln -s $CONDA_PREFIX/lib/libncursesw.so.5.9 $CONDA_PREFIX/lib/libtinfo.so.6 && echo "ln libtinfo.so.6 ok" || echo "ln libtinfo.so.6 failed"
ln -s $CONDA_PREFIX/lib/libffi.so.7 $CONDA_PREFIX/lib/libffi.so.6 && echo "ln libffi.so.6 ok" || echo "ln libffi.so.6 failed"
ls -la $CONDA_PREFIX/lib/libreadline.so* $CONDA_PREFIX/lib/libtinfo*.so* $CONDA_PREFIX/lib/libffi.so*
# Fix Makeconf for modern compiler compatibility
sed -i 's/^CFLAGS = /CFLAGS = -fcommon /' $CONDA_PREFIX/lib/R/etc/Makeconf && echo "CFLAGS patch ok" || echo "CFLAGS patch failed"
sed -i 's/^CXX = g++$/CXX = g++ -std=c++14/' $CONDA_PREFIX/lib/R/etc/Makeconf && echo "CXX patch ok" || echo "CXX patch failed"
sed -i 's/^CXX1X = g++$/CXX1X = g++ -std=c++14/' $CONDA_PREFIX/lib/R/etc/Makeconf && echo "CXX1X patch ok" || echo "CXX1X patch failed"
sed -i 's/^CXXFLAGS = /CXXFLAGS = -std=c++14 /' $CONDA_PREFIX/lib/R/etc/Makeconf && echo "CXXFLAGS patch ok" || echo "CXXFLAGS patch failed"
cat $CONDA_PREFIX/lib/R/etc/Makeconf | grep -E "^CXX|^CFLAGS"
# added in dependency layers for versioning
# r-package:
Rscript -e 'install.packages("lattice", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("chron", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("DBI", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("BH", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("assertthat", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("MASS", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/digest/digest_0.6.9.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("RColorBrewer", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("dichromat", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("munsell", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("labeling", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("stringi", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("stringr", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("R6", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("lazyeval", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=1)'
Rscript -e 'install.packages("codetools", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=1)'
# r-conda:
conda install -y --solver=libmamba --no-update-deps \
'r-Rcpp=0.12.5' \
'r-plyr=1.8.4' 
# r-package:
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/Matrix/Matrix_1.2-6.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/gtable/gtable_0.2.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/scales/scales_0.4.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/reshape2/reshape2_1.4.1.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/data.table/data.table_1.9.6.tar.gz", repos=NULL, type="source")'
# r-package:
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/ggplot2/ggplot2_2.1.0.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/dplyr/dplyr_0.4.3.tar.gz", repos=NULL, type="source")'
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/Rtsne/Rtsne_0.11.tar.gz", repos=NULL, type="source")'
# r-package:
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/pheatmap/pheatmap_1.0.8.tar.gz", repos=NULL, type="source")'

# bash:
#Patch svd 0.3.3 - PROPACK second.f uses ETIME with undersized TARRAY which crashes on modern gfortran
wget https://cran.r-project.org/src/contrib/Archive/svd/svd_0.3.3.tar.gz
tar xzf svd_0.3.3.tar.gz
echo '      REAL FUNCTION SECOND()' > svd/src/propack/second.f
echo '      REAL T' >> svd/src/propack/second.f
echo '      CALL CPU_TIME(T)' >> svd/src/propack/second.f
echo '      SECOND = T' >> svd/src/propack/second.f
echo '      RETURN' >> svd/src/propack/second.f
echo '      END' >> svd/src/propack/second.f
tar czf svd_0.3.3_patched.tar.gz svd/
Rscript -e 'install.packages("svd_0.3.3_patched.tar.gz", repos=NULL, type="source")'
rm -rf svd/ svd_0.3.3.tar.gz svd_0.3.3_patched.tar.gz

# conda:
conda install -y --solver=libmamba --no-update-deps \
cairo \
pango \
fonts-anaconda \
fontconfig 

# End of recipe
# Validation script setup
echo "#!/usr/bin/env bash" > ${CONDA_PREFIX}/bin/validate.sh
echo 'echo "COBLE validation: No script has been specified for zheng2017 environment."' >> ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
mkdir -p ${CONDA_PREFIX}/coble-recipe
cp recipes/demos/zheng2017/zheng2017.cbl ${CONDA_PREFIX}/coble-recipe
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble ${CONDA_PREFIX}/bin/
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble-* ${CONDA_PREFIX}/bin/

