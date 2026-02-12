#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-04
# Capture time: 12:39:15 UTC
# Captured by: root
# Platform: linux-64
#####################################################
# source bashrc for conda
for rcfile in ~/.bashrc ~/.bash_profile ~/.profile ~/.zshrc; do [ -f "$rcfile" ] && source "$rcfile" && break; done
# Using conda executable conda: 
# Using conda alias conda: 
#####################################################

conda env remove --name small -y 2>/dev/null || true
conda create --no-default-packages --name small -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# activate environment
conda activate small

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
#####################################################
# COBLE:Reproducible environment: BASIC, (c) ICR 2026
#####################################################
# note the reverse order of priority
# languages:
conda install -y  'conda-forge::python=3.13.1'
python -m site
conda env config vars set PYTHONNOUSERSITE=1
conda deactivate
conda activate small
CONDA_BASE=$(conda info --base)
ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then \
    PREFIX="x86_64-conda-linux-gnu"; \
elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then \
    PREFIX="aarch64-conda-linux-gnu"; \
fi

# Symlink all compiler/binutils tools
for tool in \
    gcc g++ gfortran cpp cc c++ f77 f95 \
    ar nm ranlib ld ld.gold as \
    strip objdump objcopy addr2line \
    c++filt elfedit gprof readelf size strings \
    gcc-ar gcc-nm gcc-ranlib; do \
    if command -v $tool > /dev/null 2>&1; then \
        ln -sf $(which $tool) $CONDA_BASE/bin/${PREFIX}-$tool; \
    fi; \
done
conda install -y  -c conda-forge 'r-base=4.3.1' r-remotes r-biocmanager
# flags:
# Flag: Directive: dependencies, Value: na

# ================================================
# CROSS-PLATFORM COMPILER SETUP
# Platform: linux-64
# ================================================
# Language compile tools (version 13.1) for linux-64
conda install -y --no-update-deps -c conda-forge  'gcc_linux-64=13.1' 'gxx_linux-64=13.1' 'gfortran_linux-64=13.1'
conda install -y --no-update-deps -c conda-forge sysroot_linux-64 c-compiler cxx-compiler fortran-compiler

# Set up compiler symlinks for R package compilation - Linux x86_64
umask 0022
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-gfortran
# Standard compiler aliases
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/gcc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/c++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran $CONDA_PREFIX/bin/gfortran

# Set compiler flags for R package compilation - linux-64
conda env config vars set CC="$CONDA_PREFIX/bin/gcc"
conda env config vars set CXX="$CONDA_PREFIX/bin/g++"
conda env config vars set FC="$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran"
conda env config vars set F77="$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran"
conda env config vars set CFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set CXXFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set CPPFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib"
conda deactivate
conda activate small

# ================================================
# END CROSS-PLATFORM COMPILER SETUP
# ================================================

# conda:
conda install -y  --no-update-deps \
'pandas' 
# r-conda:
conda install -y  --no-update-deps \
'r-ggplot2' 
cat > ${CONDA_PREFIX}/bin/validate.sh << 'VALIDATE_EOF'
#!/usr/bin/env bash
echo "COBLE validation: No script has been specified for small environment."
VALIDATE_EOF
chmod +x ${CONDA_PREFIX}/bin/validate.sh

