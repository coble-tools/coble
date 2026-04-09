coble:
  - environment: codex
channels:
  - bioconda
  - conda-forge
compilers:
  - compile-tools: 11.2
languages:
  - r-base=4.4.2
  - python=3.12.12
conda:
  - cairo=1.18
  - pango=1.56
r-conda:
  - data.table
  - tidyr
r-package:
  - tidyverse
  - visNetwork
pip:
  - requests
