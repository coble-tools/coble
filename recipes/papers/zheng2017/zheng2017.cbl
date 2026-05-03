#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
# code/coble build --recipe recipes/papers/zheng2017/zheng2017.cbl --env zheng2017 --rebuild
# code/coble build --recipe recipes/papers/zheng2017/zheng2017.cbl --env zheng2017 --containers docker,singularity --code-source local --validate recipes/papers/zheng2017/validate.sh
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
  - ncpus: 1
  - priority: flexible
  - export: CFLAGS="-fcommon -O2"
  - export: PKG_CFLAGS="-fcommon"
  - export: CXX="g++ -std=c++14"
  - export: CXX1X="g++ -std=c++14"
  - export: CXXFLAGS="-std=c++14"
  - export: FONTCONFIG_PATH=$CONDA_PREFIX/etc/fonts
  - compile-version: 7.5
conda:
  - r-base=3.3.1
  - ncurses=5.9
  - _libgcc_mutex=0.1=free
  - gxx_linux-64
  - libpng
  - libgfortran=3
flags:
  - priority: strict
bash:
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
r-package:
  - lattice
  - chron
#   - DBI
#   - BH
#   - assertthat
#   - MASS
#   - digest=0.6.9
#   - RColorBrewer
#   - dichromat
#   - munsell
#   - labeling
#   - stringr
#   - R6
#   - lazyeval
# r-conda:
#   - Rcpp=0.12.5
#   - plyr=1.8.4
# r-package:
#   - Matrix=1.2-6
#   - gtable=0.2.0
#   - scales=0.4.0
#   - reshape2=1.4.1
#   - data.table=1.9.6
# r-package:
#   - ggplot2=2.1.0
#   - dplyr=0.4.3
#   - Rtsne=0.11
# r-package:
#   - pheatmap=1.0.8

# bash:
# Patch svd 0.3.3 - PROPACK second.f uses ETIME with undersized TARRAY which crashes on modern gfortran
# wget https://cran.r-project.org/src/contrib/Archive/svd/svd_0.3.3.tar.gz
# tar xzf svd_0.3.3.tar.gz
# echo '      REAL FUNCTION SECOND()' > svd/src/propack/second.f
# echo '      REAL T' >> svd/src/propack/second.f
# echo '      CALL CPU_TIME(T)' >> svd/src/propack/second.f
# echo '      SECOND = T' >> svd/src/propack/second.f
# echo '      RETURN' >> svd/src/propack/second.f
# echo '      END' >> svd/src/propack/second.f
# tar czf svd_0.3.3_patched.tar.gz svd/
# Rscript -e 'install.packages("svd_0.3.3_patched.tar.gz", repos=NULL, type="source")'
# rm -rf svd/ svd_0.3.3.tar.gz svd_0.3.3_patched.tar.gz

# conda:
#   - cairo
#   - pango
#   - fonts-anaconda
#   - fontconfig
