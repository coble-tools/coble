#####################################################
# COBLE:Reproducible environment: BASIC, (c) ICR 2026
#####################################################
# Note this is an ICR in-house definition of the environment
# Not a standard environment file
######################################################
coble:
  - environment: metabolites
channels:
  - bioconda
  - conda-forge
languages:
  - python=3.12@conda-forge  
flags:
  - dependencies: NA  
conda:  
  - pandas
  - numpy
  - matplotlib
  - scikit-learn=1.6.1
  - joblib
  - tensorflow-cpu=2.18
  - tensorflow-estimator=2.18
  - tf-keras
  - jupyterlab
  - ipykernel
  - ipywidgets
  - streamlit
  - plotly
bash:
  - python -m ipykernel install --user --name JupyterICR --display-name "Jupyter ICR 2026"


