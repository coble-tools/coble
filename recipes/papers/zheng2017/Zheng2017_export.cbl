# COBLE:export, (c) ICR 2026
# Capture date: 2026-05-02
# Capture time: 20:35:37 BST
# Captured by: ralcraft

coble:

  - environment: Zheng2017

channels:
  - conda-forge
  - defaults
  - bioconda
  - intel
  - https://repo.anaconda.com/pkgs/r
  - https://repo.anaconda.com/pkgs/free
  - https://repo.anaconda.com/pkgs/main

languages:
  - r-base=3.3.1@defaults
flags:
  - compile-tools: true
  - dependencies: false
  - priority: flexible
