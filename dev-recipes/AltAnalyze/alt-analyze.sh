#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-03-16
# Capture time: 09:32:47 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi
# Using conda executable conda: /home/ralcraft/miniforge3/condabin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/condabin/conda
#####################################################

conda env remove --name alt-analyze -y 2>/dev/null || true
conda create --no-default-packages --name alt-analyze -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate alt-analyze

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
##########################################################
# COBLE: for django dev
##########################################################
# languages:
conda install -y --solver=libmamba --no-update-deps 'python=2.7'
python -m site
conda env config vars set PYTHONNOUSERSITE=1
export PYTHONNOUSERSITE=1
# conda:
conda install -y --solver=libmamba --no-update-deps \
numpy \
scipy \
matplotlib \
scikit-learn=0.20.4 \
networkx \
lxml \
pandas \
patsy \
pillow \
llvmlite \
numba \
umap-learn \
pysam \
fastcluster 
# pip:
python -m pip install 'nimfa' 
python -m pip install 'requests' 
python -m pip install 'community' 
# bash:
python -m pip install altanalyze --no-deps
(cd $CONDA_PREFIX/lib/python2.7/site-packages/altanalyze && unzip -o Config.zip && unzip -o AltDatabase.zip)
sed -i 's/subprocess.Popen(out)$/subprocess.Popen(out, stdout=sys.stdout, stderr=sys.stderr); pipe.wait()/' $CONDA_PREFIX/lib/python2.7/site-packages/altanalyze/__init__.py
altanalyze --update Official --species Hs --platform RNASeq --version EnsMart72

# Validate script available in environment at CONDA PREFIX: validate.sh
cp dev-recipes/AltAnalyze/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh

