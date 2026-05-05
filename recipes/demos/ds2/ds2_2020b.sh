#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-04-23
# Capture time: 12:34:13 BST
# Captured by: ralcraft
#####################################################
# source bashrc for conda
if [ -f ~/.bash_profile ]; then source ~/.bash_profile; elif [ -f ~/.bashrc ]; then source ~/.bashrc; elif command -v conda > /dev/null 2>&1; then eval "$(conda shell.bash hook)"; fi
# Using conda executable conda: /home/ralcraft/miniforge3/condabin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/condabin/conda
#####################################################

conda env remove --name ds20b -y 2>/dev/null || true
conda create --no-default-packages --name ds20b -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate ds20b

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --show channels | grep -q 'channels:' && conda config --env --remove-key channels || true
conda config --env --set channel_priority strict
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
# code/coble build --recipe recipes/papers/DESeq2/DESeq2_2020.cbl --env deseq206 --rebuild
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
conda install -y --solver=libmamba --no-update-deps r-remotes r-biocmanager r-renv
# bioc-conda:
conda install -y --solver=libmamba --no-update-deps \
'bioconductor-DESeq2' 


# End of recipe
# Validation script setup
echo "#!/usr/bin/env bash" > ${CONDA_PREFIX}/bin/validate.sh
echo 'echo "COBLE validation: No script has been specified for ds20b environment."' >> ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
mkdir -p ${CONDA_PREFIX}/coble-recipe
cp recipes/demos/ds2/ds2_2020b.cbl ${CONDA_PREFIX}/coble-recipe
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble ${CONDA_PREFIX}/bin/
cp /home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble-* ${CONDA_PREFIX}/bin/

