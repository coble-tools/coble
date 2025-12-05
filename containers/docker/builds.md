# COBLE Build Specifications

This document specifies the inputs and configurations for all COBLE Docker builds.

## Build: 452clean

**Purpose**: Minimal R 4.5.2 environment with basic development tools

**Use Cases**:
- Minimal reproducible R environment
- Base for custom R package installations
- Testing basic R functionality
- Quick environment setup
- 
**Recipe**: `config/r-452-clean.sh`

**Build Command**:
```bash
docker build -f containers/docker/Dockerfile.generic \
  --build-arg RECIPE_FILE=config/r-452-clean.sh \
  --build-arg BUILD_TAG=r-452-clean \
  --build-arg R_VERSION=4.5.2 \
  --build-arg PYTHON_VERSION=3.14.0 \
  --build-arg SKIP_ERRORS=true \
  --build-arg OVERRIDE_R=false \
  --build-arg OVERRIDE_PKGS=false \
  -t icrsc/coble:452clean .

docker push icrsc/coble:452clean
```

**Singularity**:
```bash
singularity pull -F coble-452clean.sif docker://icrsc/coble:452clean
singularity shell coble-452clean.sif
```

---

## Build: 452syed

**Purpose**: Comprehensive bioinformatics environment with extensive single-cell, spatial, and genomics packages from R, python and bioconductor.

**Use Cases**:
- Comprehensive single-cell analysis workflows
- Spatial transcriptomics and genomics
- Multi-omics integration
- Production bioinformatics pipelines
- Collaborative research projects requiring reproducibility

**Recipe**: `config/r-452-syed.sh`

**Build Command**:
```bash
docker build -f containers/docker/Dockerfile.generic \
  --build-arg RECIPE_FILE=config/r-452-syed.sh \
  --build-arg BUILD_TAG=r-452-syed \
  --build-arg R_VERSION=4.5.2 \
  --build-arg PYTHON_VERSION=3.14.0 \
  --build-arg SKIP_ERRORS=true \
  --build-arg OVERRIDE_R=true \
  --build-arg OVERRIDE_PKGS=true \
  -t icrsc/coble:452syed .

docker push icrsc/coble:452syed
```

**Singularity**:
```bash
singularity pull -F coble-452syed.sif docker://icrsc/coble:452syed
singularity shell coble-452syed.sif
```

**Analysis Capabilities**:
- ✅ Single-cell RNA-seq (Seurat, Monocle3, ArchR, SCENIC)
- ✅ Spatial transcriptomics (Seurat, ArchR, stJoincount, numbat)
- ✅ Single-cell ATAC-seq (ArchR, Signac, ChromSCape)
- ✅ Methylation arrays (minfi, methylKit, DMRcate)
- ✅ Copy number analysis (copynumber, sequenza, ascat, infercnv)
- ✅ Mutational signatures (signature.tools.lib, maftools)
- ✅ Deconvolution (DeconRNASeq, ConsensusTME, mMCP-counter, CytoTRACE2)
- ✅ Cell-cell communication (CellChat, nichenetr, multinichenetr)
- ✅ Trajectory inference (slingshot, monocle3, destiny)
- ✅ Doublet detection (DoubletFinder, DoubletDecon, scDblFinder)
- ✅ Batch correction (harmony, STACAS, batchelor, sva)
- ✅ Gene set enrichment (fgsea, GSVA, multiGSEA, enrichR)
- ✅ Splicing analysis (leafcutter, DEXSeq)
- ✅ Hi-C/ChIP interactions (Chicago, GenomicInteractions, Sushi)
- ✅ NanoString analysis (NanoStringNorm, GeomxTools)
- ✅ TCR/BCR analysis (immunarch, ProjecTILs)

**Special Notes**:
- Installs custom pysamstats fork from rachelicr
- Uses archived NanoStringNorm 1.2.1.1 for compatibility
- Custom copynumber package supports hg38 (beyond hg19)
- Includes radian for interactive R terminal
- Configured for font support (non-DejaVu fonts via mscorefonts)
- Some packages may show errors but install successfully (Scillus, immunarch)
- preprocessCore built without threading for stability
- sctransform from develop branch for latest features

---

## General Build Information

**Base Image**: `continuumio/miniconda3`

**Conda Channels** (in priority order):
1. conda-forge
2. bioconda
3. https://conda.anaconda.org/dranew
4. defaults

**Channel Priority**: strict

**System Dependencies**:
- build-essential
- zlib1g-dev
- libgomp1
- gettext

**Directory Structure**:
```
/app/
├── code/              # COBLE scripts
├── config/            # Recipe files
├── results/coble/     # Build results and logs
├── envs/coble/        # Conda environment
├── logs/              # Additional logs
└── .condarc          # Conda configuration
```

**Activation**:
- **Docker**: Auto-activates on `docker run`
- **Singularity shell**: Use `/app/activate_env.sh`
- **Singularity exec**: Source `/app/activate_conda.sh` first

**Results Outputs**:
- `coble-stdout.log` - Standard output
- `coble-stderr.log` - Error messages  
- `recipe.sh` - Generated installation script
- `environment.yml` - Conda environment export
- `r-packages.txt` - Installed R packages with library paths
- `python-packages.txt` - Installed Python packages
