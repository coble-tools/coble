#####################################################
# COBLE:Reproducible environment: BASIC, (c) ICR 2026
#####################################################
# This template demomnstaes all thepossible features along with the defaults
# Note that the recipe can be called with --alias mamba to use mamba instead of conda
# but that there is also an alias directive to set the alias within the recipe itself
#####################################################
coble:
  - environment: This is just a descriptive field but `capture` saves the end name
channels: # note the reverse order of priority  
  - bioconda
  - conda-forge
languages:
  - python=3.13.1@conda-forge # you need 1 or both or neither
  - r-base=4.3.1@conda-forge #  you must choose a version for them
flags:
  - dependencies: NA # NA / true / false - NA+true - required dependencies only, false - all dependencies, true means also suggested
  - system-tools: false # some common system tools e.g. devtools BiocManager, remotes
  - compile-tools: false # false / 13.1 / true  - installs defaults or specified versions of common libs
  - compile-paths: true # true / false - adds compile tool paths only to conda env (not needed if you have the above)
  - export: VAR1=VALUE1 # sets environment variables within the conda env
  - updates: false # false / true - whether to update all packages to latest versions automatically DON'T DO THIS!
  - alias: conda # sets the conda alias to use - conda / mamba / micromamba a user path etc, only fir the solver eg mamba install
conda:
  - pandas
r-conda:    
  - data.table  
bioc-package:
  - snow
bioc-conda:
  - biobase
r-package:
  - generics
pip:
  - scanoramaCT
  - https://github.com/ICR-RSE-Group/gitalma.git
r-url:  
  - https://github.com/saeyslab/nichenetr/archive/refs/heads/master.zip
bash:
  - mkdir -p "HelloWorld"
r-github:
  - deepayan/lattice