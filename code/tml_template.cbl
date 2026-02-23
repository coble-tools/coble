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
  - network-viz: true # true / false - installs R packages for network visualisation of R package dependencies
  - export: VAR1=VALUE1 # sets environment variables within the conda env
  - updates: false # false / true = --no-update-deps / --update-deps or a specific flag string such as "--freeze-installed"
  - alias: conda # sets the conda alias to use - conda / mamba / micromamba a user path etc, only fir the solver eg mamba install
  - ncpus: 4 # number of cpus to use for r package installs
  - solver: libmamba # classic
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
  - https://github.com/coble-tools/gitalma.git
r-url:
  - https://github.com/tidyverse/magrittr/archive/refs/heads/main.zip
bash:
  - ls -la
r-github:
  - deepayan/lattice