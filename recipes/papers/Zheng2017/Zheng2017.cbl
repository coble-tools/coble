#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
# code/coble build --recipe recipes/papers/Zheng2017/Zheng2017.cbl --env Zheng2017 -- rebuild
#######################################
coble:
  - environment: zheng2017
channels:
  - intel
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

r-package:
  - Matrix
  - ggplot2
  - Rtsne
  - svd
  - dplyr
  - plyr
  - data.table
  - pheatmap

