#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-01-25
# Capture time: 16:04:09 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
# Using conda executable conda: /home/ralcraft/miniforge3/bin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/bin/conda
#####################################################

conda env remove --name metabolites -y 2>/dev/null || true
conda create --no-default-packages --name metabolites -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# activate environment
conda activate metabolites

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
conda install -y  'conda-forge::python=3.12'
python -m site
conda env config vars set PYTHONNOUSERSITE=1
conda deactivate
conda activate metabolites
# flags:
# Flag: Directive: dependencies, Value: na
# conda:
conda install -y  --no-update-deps \
'pandas' \
'numpy' \
'matplotlib' \
'scikit-learn=1.6.1' \
'joblib' \
'tensorflow-cpu=2.18' \
'tensorflow-estimator=2.18' \
'tf-keras' \
'jupyterlab' \
'ipykernel' \
'ipywidgets' \
'streamlit>=1.30' \
'plotly' 
# bash:
python -m ipykernel install --user --name JupyterICR --display-name "Jupyter ICR 2026"



