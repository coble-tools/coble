#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-17
# Capture time: 08:09:42 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi
# Using conda executable conda: /home/ralcraft/miniforge3/condabin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/condabin/conda
#####################################################

conda env remove --name DESeq2 -y 2>/dev/null || true
conda create --no-default-packages --name DESeq2 -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate DESeq2

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
# compilers:
# Flag: Directive: cran-repo, Value: 
# flags:
# Compile version 7.5 on linux for architecture x86_64
conda install -y --solver=libmamba --no-update-deps -c conda-forge sysroot_linux-64 c-compiler cxx-compiler
# Detected Linux x86_64 - using linux-64 compilers
conda install -y --solver=libmamba --no-update-deps -c conda-forge 'gcc_linux-64=7.5' 'gxx_linux-64=7.5' 'gfortran_linux-64=7.5'
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/gcc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran $CONDA_PREFIX/bin/gfortran
ln -sf /usr/bin/ld ${CONDA_PREFIX}/x86_64-conda-linux-gnu/bin/ld
# languages:
CONDA_BASE=$(conda info --base)
ARCH=$(uname -m)

# deps: --no-update-deps
conda install -y --solver=libmamba --no-update-deps 'r-base=3.6.2'
conda install -y --solver=libmamba --no-update-deps r-remotes r-biocmanager
#conda:
#  - binutils>=2.38
#  - binutils_impl_linux-64>=2.38

# bioc-conda:
conda install -y --solver=libmamba --no-update-deps \
'bioconductor-DESeq2' \
'bioconductor-DESeq' \
'bioconductor-edgeR' \
'bioconductor-DSS' \
'bioconductor-limma' \
'bioconductor-EBSeq' \
'bioconductor-parathyroidSE' \
'bioconductor-pasilla' 
# conda:
conda install -y --solver=libmamba --no-update-deps \
'GFOLD' 
# r-conda:
conda install -y --solver=libmamba --no-update-deps \
'r-samr' \
'r-PoiClaClu' 

cat > ${CONDA_PREFIX}/bin/validate.sh << 'VALIDATE_EOF'
#!/usr/bin/env bash
echo "COBLE validation: No script has been specified for DESeq2 environment."
VALIDATE_EOF
chmod +x ${CONDA_PREFIX}/bin/validate.sh

