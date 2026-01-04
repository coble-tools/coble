#####################################################
# COBLE:Reproducible environment: BASIC, (c) ICR 2025
#####################################################
coble:
  - environment: coble-env-bash
channels:
# note the reverse order of priority
  - defaults
  - r
  - bioconda
  - conda-forge
languages:
  - python=3.13.1@conda-forge
  - r-base=4.3.1@conda-forge
bash:
python -m pip install pandas
  - Rscript -e "install.packages('ggplot2', repos='https://cloud.r-project.org/')"
pwd