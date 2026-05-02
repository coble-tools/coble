#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
# code/coble build --recipe recipes/papers/zheng2017/zheng2017.cbl --env zheng2017 --containers docker,singularity --validate recipes/papers/zheng2017/validate.sh
#######################################
coble:
  - environment: zheng2017
channels:
  - https://software.repos.intel.com/python/conda/
  - https://repo.anaconda.com/pkgs/r
  - https://repo.anaconda.com/pkgs/free
  - https://repo.anaconda.com/pkgs/main
compilers:
  - cran-repo: https://packagemanager.posit.co/cran/2017-10-10
flags:
  - ncpus: 8
  - priority: flexible
  - export: CFLAGS="-fcommon -O2"
  - export: PKG_CFLAGS="-fcommon"
  - export: CXX="g++ -std=c++14"
  - export: CXX1X="g++ -std=c++14"
  - export: CXXFLAGS="-std=c++14"
  - export: FONTCONFIG_PATH=$CONDA_PREFIX/etc/fonts
conda:
  - r-base=3.3.1
  - ncurses=5.9
  - _libgcc_mutex=0.1=free
flags:
  - priority: strict
conda:
  - libpng
  - libgfortran
bash:

# For Ubuntu 22.04/20.04 - grab the old deb manually
rm -rf $CONDA_PREFIX/lib/libgfortran.so.3
wget http://archive.ubuntu.com/ubuntu/pool/universe/g/gcc-6/libgfortran3_6.4.0-17ubuntu1_amd64.deb
# Extract the .deb without dpkg
ar x libgfortran3_6.4.0-17ubuntu1_amd64.deb
mkdir -p /tmp/libgfortran3
tar -xf data.tar.xz -C /tmp/libgfortran3
# Copy the library into your conda env
cp /tmp/libgfortran3/usr/lib/x86_64-linux-gnu/libgfortran.so.3.0.0 $CONDA_PREFIX/lib/
ln -s $CONDA_PREFIX/lib/libgfortran.so.3.0.0 $CONDA_PREFIX/lib/libgfortran.so.3
rm -rf libgfortran3_6.4.0-17ubuntu1_amd64.deb

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
r-package:
  - lattice
  - chron
  - DBI
  - BH
  - assertthat
  - MASS
  - digest=0.6.9
  - RColorBrewer
  - dichromat
  - munsell
  - labeling
  - stringr
  - R6
  - lazyeval
r-conda:
  - Rcpp=0.12.5
r-package:
  - Matrix=1.2-6
  - plyr=1.8.4
  - gtable=0.2.0
  - scales=0.4.0
  - reshape2=1.4.1
  - svd=0.3.3
  - data.table=1.9.6
r-package:
  - ggplot2=2.1.0
  - dplyr=0.4.3
  - Rtsne=0.11
r-package:
  - pheatmap=1.0.8
conda:
  - cairo
  - pango
  - fonts-anaconda
  - fontconfig
