##########################################################
# COBLE: for django dev
##########################################################
coble:
  - environment: coble-django
channels:
# note the reverse order of priority  
  - bioconda
  - conda-forge
languages:
  - r-base=4.5.2@conda-forge
  - python=3.14.0@conda-forge
flags:
  - dependencies: NA
  - system-tools: True
  - compile-tools: 11
  - ncpus: 8    
conda:
  - whitenoise
  - gunicorn  
  - django
  - plotly
  - numpy
  - pandas
  