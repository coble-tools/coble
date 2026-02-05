#####################################################
# COBLE:Reproducible environment: BASIC, (c) ICR 2026
#####################################################
coble:
  - environment: jupyter
channels:
# note the reverse order of priority  
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
  - streamlit>=1.30
  - plotly  
bash:
  - python -m ipykernel install --user --name JupyterICR --display-name "Jupyter ICR 2026"


