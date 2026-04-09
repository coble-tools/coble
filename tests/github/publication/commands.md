

# Generate word code snippets

pandoc tests/github/publication/commands.md -o tests/github/publication/commands.docx --highlight-style=tango


```bash

coble build -–recipe codex.cbl -–env codex \
  --containers conda,docker,singularity

coble build –-recipe codex.cbl -–env codex
```

```yaml
# COBLE:export
# Capture date: 2026-02-04
# Capture time: 17:41:27 GMT
# Captured by: ralcraft
coble:
  - environment: codex
channels:  
  - bioconda
  - conda-forge
languages:
  - r-base=4.4.2@conda-forge
  - python=3.12.12@conda-forge
flags:
  - compile-tools: true
  - dependencies: false   
conda:    
  - cairo=1.18.4@conda-forge    
  - pango=1.56.3@conda-forge  
r-conda:  
  - data.table=1.17.8@conda-forge
  - tidyr=1.3.2@conda-forge    
pip:
  - requests==2.32.5
```

```bash

coble build –-recipe codex_export.cbl –-env codex-mirror

conda activate codex-mirror

coble build \
  --recipe codex.cbl \
  --env codex \
  --rebuild \
  --validate validate.sh \
  --val-folder validate \
  --skip-errors \
  --debug

coble template \
  --recipe codex.cbl \
  --flavour basic

coble export \
  --export codex-export.cbl \
  --env codex \
  --debug

coble network \
  --recipe codex-export.cbl \
  --env codex

```

```yaml
channels:
  - bioconda
  - conda-forge
languages:
  - r-base=4.5.2
  - python=3.14
flags:
  - dependencies: NA 
  - system-tools: false
  - compile-tools: false
  - compile-paths: true
  - export: VAR1=VALUE1
  - ncpus: 4 
  - priority: strict 
conda:
  - package
r-conda:    
  - package
bioc-package:
  - package
bioc-conda:
  - package
r-package:
  - package
pip:
  - package
  - https://package.url
r-url:  
  - https://package.url
r-github:
  - group/package
bash:
# can put anything



coble:
  - environment: find
channels:
  - bioconda
  - conda-forge
find:
 - SummarizedExperiment
 - DESeq2
 - Seurat
 - requests
```


```bash
$ coble build --recipe find.cbl --env find
[coble] Finds were resolved, please check the yml input before resuming.
```

```yaml
find:
#  - SummarizedExperiment
found|conda:
  - bioconductor-SummarizedExperiment=1.0.0@bioconda
found|conda:
  - bioconductor-SummarizedExperiment=1.8.0@bioconda
found|conda:
  - SummarizedExperiment=1.40.0@r
found|bioc-package:
  - SummarizedExperiment=1.40.0@packages
found|bioc-package:
  - SummarizedExperiment=1.24.0@Archive=3.14
found|pip:
  - SummarizedExperiment


coble:
  - environment: found
channels:
  - bioconda
  - conda-forge
languages:
  - r-base=4.4.2
  - python=3.12
bioc-conda:
  - SummarizedExperiment
  - DESeq2
r-conda:
  - Seurat
pip:
  - requests


coble:
  - environment: stjc
channels:
  - bioconda
  - conda-forge
languages:
  - r-base=4.5.2
  - python=3.14
bioc-package:
  - stJoincount
```

```bash
coble build --recipe stjc.cbl --env stjc


In install.packages(...) : installation of 20 packages failed:
  ‘png’, ‘terra’, ‘units’, ‘s2’, ‘magick’, ‘reticulate’, ‘raster’, ‘httpuv’, ‘XVector’, ‘sf’, ‘shiny’, ‘SparseArray’, ‘miniUI’, ‘spdep’, ‘DelayedArray’, ‘SummarizedExperiment’, ‘SingleCellExperiment’, ‘Seurat’, ‘SpatialExperiment’, ‘stJoincount’
[coble] Error in environment creation, please review logs before resuming.
[coble] Time taken Wed Feb 4 17:59:58 GMT 2026 (Duration: 0h 6m 11s)

```

```yaml
coble:
  - environment: stjc
channels:
  - bioconda
  - conda-forge
languages:
  - r-base=4.5.2
  - python=3.14
r-conda:
  - png
  - terra
  - units
  - s2
  - magick
  - reticulate
  - raster
  - sf
  - shiny
  - miniUI
  - spdep
bioc-package:
  - stJoincount



bioc-package:
  - BiocFileCache=3.0.0
  - BiocGenerics=0.56.0
  - BiocStyle=2.38.0
  - BiocVersion=3.22.0
  - DelayedArray=0.36.0
  - GenomicRanges=1.62.1
  - IRanges=2.44.0
  - MatrixGenerics=1.22.0
  - S4Arrays=1.10.1
  - S4Vectors=0.48.0
  - Seqinfo=1.0.0
  - SingleCellExperiment=1.32.0
  - SparseArray=1.10.8
  - SpatialExperiment=1.20.0
  - SummarizedExperiment=1.40.0
  - XVector=0.50.0
  - stJoincount=1.12.0
```

```bash
coble build \
--recipe codex.cbl \
--env codex \
--validate validate.sh \
--val-folder validate


$ docker load -i cbl-codex.tar
$ docker run --rm -it -v .:/app cbl-codex

$ singularity shell cbl- codex.sif


# Docker
docker pull ghcr.io/coble-tools/coble:papers-deseq2
docker run --rm -it -v .:/workspace ghcr.io/coble-tools/coble:papers-deseq2
# Singularity
singularity build coble-papers-deseq2.sif docker://ghcr.io/coble-tools/coble:papers-deseq2
singularity shell coble-papers-deseq2.sif


```
