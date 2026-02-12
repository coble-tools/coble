#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-07
# Capture time: 21:22:05 GMT
# Captured by: ralcraft
# Platform: 
#####################################################
# source bashrc for conda
source /home/ralcraft/.bashrc
# Using conda executable conda: /home/ralcraft/miniforge3/condabin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/condabin/conda
#####################################################

# Detected platform: OS=linux, ARCH=x86_64, PLATFORM=linux-64
# Compiler packages: c-compiler cxx-compiler fortran-compiler
# Compiler packages: sysroot_linux-64
# Compiler packages: gcc_linux-64 gxx_linux-64 gfortran_linux-64
conda env remove --name pytest -y 2>/dev/null || true
conda create --no-default-packages --name pytest -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# activate environment
conda activate pytest

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
#####################################################
# COBLE:Reproducible environment: DEV for pytest, (c) ICR 2026
#####################################################
# languages:
conda install -y  'conda-forge::python=3.13.1'
python -m site
conda env config vars set PYTHONNOUSERSITE=1
conda deactivate
conda activate pytest
# conda:
conda install -y  --no-update-deps \
'requests' \
'conda-build' \
'anaconda-client' \
'conda-index' 
# pip:
python -m pip install 'pytest' 
python -m pip install "git+https://github.com/ICR-RSE-Group/gitalma.git" 
echo "#!/usr/bin/env bash" > ${CONDA_PREFIX}/bin/validate.sh
echo "echo \"COBLE validation: No script has been specified for pytest environment.\"" >> ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh

