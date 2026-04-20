#!/usr/bin/env bash

echo "Validating alt-analyze environment..."

echo "# 1. Confirm python version"
echo "Python version: $(python --version)"


echo "# 2. Check all the key imports work"
python -c "
import numpy
import scipy
import sklearn
import matplotlib
import networkx
import lxml
import pandas
import patsy
import PIL
import numba
import umap
import pysam
import fastcluster
import nimfa
import requests
import community
import altanalyze
print('All imports OK')
"

echo "# 3. Check versions of the trickiest ones"
python -c "
import sklearn; print('sklearn', sklearn.__version__)
import numba; print('numba', numba.__version__)
import umap; print('umap', umap.__version__)
import pandas; print('pandas', pandas.__version__)
"

echo "# 4. Check that the AltDatabase directory is present and has files in it"
if [ -d "$CONDA_PREFIX/lib/python2.7/site-packages/altanalyze/AltDatabase" ]; then
    echo "AltDatabase directory exists."
    if [ "$(ls -A $CONDA_PREFIX/lib/python2.7/site-packages/altanalyze/AltDatabase)" ]; then
        echo "AltDatabase directory is not empty."
    else
        echo "Error: AltDatabase directory is empty!"
    fi
else
    echo "Error: AltDatabase directory does not exist!"
fi

echo "# 5. Check that the altanalyze command works and can find its data files"
python $CONDA_PREFIX/lib/python2.7/site-packages/altanalyze/import_scripts/BAMtoJunctionBED.py --help

echo "Validation complete."