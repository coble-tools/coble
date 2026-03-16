##########################################################
# COBLE: for django dev
##########################################################
coble:
  - environment: alt-analyze
channels:
  - bioconda
  - conda-forge
languages:
  - python=2.7
conda:
  - numpy
  - scipy
  - matplotlib
  - scikit-learn=0.20.4
  - networkx
  - lxml
  - pandas
  - patsy
  - pillow
  - llvmlite
  - numba
  - umap-learn
  - pysam
  - fastcluster
pip:
  - nimfa
  - requests
  - community
bash:
python -m pip install altanalyze --no-deps
(cd $CONDA_PREFIX/lib/python2.7/site-packages/altanalyze && unzip -o Config.zip && unzip -o AltDatabase.zip)
sed -i 's/subprocess.Popen(out)$/subprocess.Popen(out, stdout=sys.stdout, stderr=sys.stderr); pipe.wait()/' $CONDA_PREFIX/lib/python2.7/site-packages/altanalyze/__init__.py
altanalyze --update Official --species Hs --platform RNASeq --version EnsMart72