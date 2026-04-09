#!/usr/bin/env bash

# Call from code folder: tests/github/publication/commands.sh

this_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"



codex_recipe="${this_dir}/codex.cbl"
echo "Using recipe: $codex_recipe"
code/coble build --recipe /home/ralcraft/DEV/gh-rse/BCRDS/coble/tests/github/publication/codex.cbl --env codex


# coble build -–recipe codex.cbl -–env codex \
# --containers conda,docker,singularity

# coble build –-recipe codex.cbl -–env codex

# coble build -–recipe codex_export.cbl -–env codex-mirror

# conda activate codex-mirror

# coble build \
# --recipe codex.cbl \
# --env codex \
# --rebuild \
# --validate validate.sh \
# --val-folder validate \
# --skip-errors \
# --debug \
# --alias mamba

# coble template \
# --recipe codex.cbl \
# --flavour basic

# coble export \
# --export codex-export.cbl \
# --env codex \
# --debug

# coble network \
# --recipe codex-export.cbl \
# --env codex


# channels:
#   - bioconda
#   - conda-forge
# languages:
#   - r-base=4.5.2
#   - python=3.14
# flags:
#   - dependencies: NA
#   - system-tools: false
#   - compile-tools: false
#   - compile-paths: true
#   - export: VAR1=VALUE1
#   - ncpus: 4
#   - priority: strict
# conda:
#   - package
# r-conda:
#   - package
# bioc-package:
#   - package
# bioc-conda:
#   - package
# r-package:
#   - package
# pip:
#   - package
#   - https://package.url
# r-url:
#   - https://package.url
# r-github:
#   - group/package
# bash:
# # can put
# # anything

# coble:
#   - environment: find
# channels:
#   - bioconda
#   - conda-forge
# find:
#  - SummarizedExperiment
#  - DESeq2
#  - Seurat
#  - requests

#  coble build --recipe find.cbl --env find

#  coble:
#   - environment: stjc
# channels:
#   - bioconda
#   - conda-forge
# languages:
#   - r-base=4.5.2
#   - python=3.14
# bioc-package:
#   - stJoincount

# coble build --recipe stjc.cbl --env stjc

# coble:
#   - environment: stjc
# channels:
#   - bioconda
#   - conda-forge
# languages:
#   - r-base=4.5.2
#   - python=3.14
# r-conda:
#   - png
#   - terra
#   - units
#   - s2
#   - magick
#   - reticulate
#   - raster
#   - sf
#   - shiny
#   - miniUI
#   - spdep
# bioc-package:
#   - stJoincount


# coble build \
# --recipe codex.cbl \
# --env codex \
# --validate validate.sh \
# --val-folder validate

# $ docker load -i cbl-codex.tar
# $ docker run --rm -it -v .:/app cbl-codex

# $ singularity shell cbl- codex.sif

# # Docker
# docker pull ghcr.io/coble-tools/coble:papers-deseq2
# docker run --rm -it -v .:/workspace ghcr.io/coble-tools/coble:papers-deseq2
# # Singularity
# singularity build coble-papers-deseq2.sif docker://ghcr.io/coble-tools/coble:papers-deseq2
# singularity shell coble-papers-deseq2.sif
