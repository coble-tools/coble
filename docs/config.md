# Configuration Guide

Complete reference for COBLE configuration files.

## Overview

COBLE uses YAML configuration files to define package installations. These configs specify the exact packages, installation methods, and build order for creating reproducible bioinformatics environments.

**Location**: `config/coble-<variant>.yml`

**Available variants**:
- `coble-mini.yml` - Minimal test environment (~15 packages)
- `coble-452.yml` - Full production environment (452+ packages)
- `coble-tst.yml` - Experimental/testing packages

---

## Configuration Format

### Basic Structure

```yaml
#coble-yml
dependencies:
  - <install_method>:
    - <package1>
    - <package2>
  - <another_method>:
    - <package3>
```

### Header

All config files must start with:
```yaml
#coble-yml
```

This identifies the file as a COBLE configuration.

---

## Installation Methods

COBLE supports 8 installation methods for different package types:

### 1. conda

Install packages from conda channels (conda-forge, bioconda, etc.)

```yaml
- conda:
  - libxml2
  - pandoc
  - pypandoc
  - boost-cpp
  - hdf5
```

**Best for**: System libraries, Python packages, general tools

**Specify channel explicitly**:
```yaml
- conda:
  - conda-forge::r-v8
  - conda-forge::r-lme4
  - conda-forge::r-units
```

### 2. mamba

Install using mamba solver (faster than conda)

```yaml
- mamba:
  - numpy
  - scipy
```

**Best for**: Initial setup when building large environments

**Note**: Usually just one `mamba:` entry at the start to initialize mamba itself.

### 3. r_conda

Install R packages from conda channels

```yaml
- r_conda:
  - biocmanager
  - devtools
  - remotes
  - stringi
  - rcpp
  - reticulate
  - tidyverse
```

**Best for**: R packages available in conda-forge with consistent dependencies

**Advantages**:
- Pre-compiled binaries (faster)
- Automatic dependency resolution
- Better compatibility with system libraries

### 4. bio_conda

Install packages from Bioconductor via conda

```yaml
- bio_conda:
  - RBGL
  - DelayedArray
```

**Best for**: Bioconductor packages when conda version preferred

### 5. bio_package

Install from Bioconductor using BiocManager

```yaml
- bio_package:
  - fgsea
  - limma
  - vsn
  - edgeR
  - biomaRt
  - SingleR
  - scran
  - scater
```

**Best for**: Bioconductor-specific packages not in conda, latest Bioconductor releases

**Note**: Requires `biocmanager` R package installed first

### 6. r_package

Install R packages from CRAN

```yaml
- r_package:
  - devtools
  - FactoMineR
  - knitr
  - rmarkdown
  - tidyverse
  - clustree
```

**Best for**: CRAN packages not available in conda, latest CRAN releases

### 7. github

Install from GitHub repositories

```yaml
- github:
  - aroneklund/copynumber
  - Nik-Zainal-Group/signature.tools.lib
  - chris-mcginnis-ucsf/DoubletFinder
  - satijalab/seurat-wrappers
  - VanLoo-lab/ascat/ASCAT
```

**Best for**: Development versions, packages not on CRAN/Bioconductor

**Format**: `owner/repo` or `owner/repo/subdir` for subdirectory packages

**Branch/ref support**:
```yaml
- github:
  - GreenleafLab/ArchR@master
  - satijalab/sctransform@develop
```

### 8. wget

Download and install from URLs

```yaml
- wget:
  - https://cran.r-project.org/src/contrib/Archive/NanoStringNorm/NanoStringNorm_1.2.1.1.tar.gz
  - https://cran.r-project.org/src/contrib/Archive/sequenza/sequenza_3.0.0.tar.gz
  - https://github.com/carmonalab/STACAS/archive/refs/heads/master.zip
```

**Best for**: Archived packages, specific versions not on CRAN/Bioconductor

**Supported formats**: `.tar.gz`, `.zip`

### 9. pip

Install Python packages via pip

```yaml
- pip:
  - setuptools>=59.0
  - Cython>=3.0.11
  - pysam
  - git+https://github.com/rachelicr/pysamstats.git
  - scanoramaCT
  - spatialde
```

**Best for**: Python-only packages, packages requiring specific pip versions

**Supports**:
- Version constraints (`>=`, `==`, etc.)
- Git URLs (`git+https://...`)

### 10. bash

Execute arbitrary bash commands

```yaml
- bash:
  - echo "quick clean"
  - df -m
  - conda clean -afy
  - Rscript -e "install.packages('countreg', repos='http://R-Forge.R-project.org')"
  - git clone https://git.bioconductor.org/packages/DeconRNASeq
  - R CMD INSTALL DeconRNASeq
  - rm -rf DeconRNASeq
```

**Best for**: 
- Custom installation commands
- Cleanup operations
- R-Forge packages
- Git clones
- Complex multi-step installs

**Safety**: Commands run in build environment, use with caution

---

## Configuration Best Practices

### Order Matters

Install packages in logical dependency order:

```yaml
dependencies:
  # 1. System libraries first
  - conda:
    - libxml2
    - zlib
  
  # 2. Core R packages
  - r_conda:
    - biocmanager
    - devtools
    - remotes
  
  # 3. Bioconductor base
  - bio_package:
    - BiocGenerics
    - S4Vectors
  
  # 4. Dependent packages
  - r_package:
    - tidyverse
```

### Cleanup Between Stages

Free disk space during long builds:

```yaml
- bash:
  - echo "quick clean"
  - df -m
  - conda clean -afy
  - df -m
```

Place cleanup commands between major installation blocks.

### Version Pinning

Pin critical packages for reproducibility:

```yaml
- conda:
  - python=3.14.0  # Exact version
  - numpy>=1.20    # Minimum version
  - pandas~=2.0    # Compatible version

- r_conda:
  - r-base=4.5.2
```

### Channel Specification

Use explicit channels to avoid conflicts:

```yaml
- conda:
  - conda-forge::r-units
  - bioconda::samtools
```

### Archived Versions

Use `wget:` for specific archived versions:

```yaml
- wget:
  - https://cran.r-project.org/src/contrib/Archive/modes/modes_0.7.0.tar.gz
  - https://cran.r-project.org/src/contrib/Archive/CIDER/CIDER_0.99.4.tar.gz
```

### Complex GitHub Installs

Use `bash:` with Rscript for advanced GitHub installs:

```yaml
- bash:
  - Rscript -e "remotes::install_github('GreenleafLab/ArchR', ref='master', repos = BiocManager::repositories())"
  - Rscript -e "ArchR::installExtraPackages()"
```

---

## Real-World Examples

### Minimal Environment (coble-mini.yml)

```yaml
#coble-yml
dependencies:
  - mamba:
  - r_conda:
    - biocmanager    
    - devtools    
    - remotes    
    - data.table
  - bio_package:
    - fgsea
  - r_conda:
    - stringi
    - rcpp
    - plyr
    - reticulate
```

**Use case**: Quick testing, CI/CD, minimal R environment

### System Libraries Block

```yaml
- conda:
  - libxml2
  - pandoc
  - pypandoc
  - boost-cpp
  - zlib
  - hdf5
```

**Purpose**: Foundation for compiled R packages

### Seurat Single-Cell Block

```yaml
- r_conda:
  - reticulate
  - seurat
- bio_package:
  - SingleR
  - scran
  - scater
  - harmony
- r_package:
  - Signac
  - hdf5r
- github:
  - satijalab/seurat-wrappers
```

**Purpose**: Complete single-cell RNA-seq analysis stack

### Spatial Transcriptomics Block

```yaml
- conda:
  - conda-forge::r-sf
  - conda-forge::r-spdep
- bio_package:
  - stJoincount
- pip:
  - spatialde
- github:
  - xmc811/Scillus
```

**Purpose**: Spatial analysis tools

### Methylation Analysis Block

```yaml
- bio_package:
  - minfi
  - IlluminaHumanMethylationEPICanno.ilm10b4.hg19
  - IlluminaHumanMethylationEPICmanifest
  - missMethyl
  - minfiData
  - DMRcate
  - methylKit
```

**Purpose**: Illumina methylation array analysis

---

## Troubleshooting

### Package Not Found

**Problem**: `conda` can't find package

**Solutions**:
1. Check package name spelling
2. Try different channel:
   ```yaml
   - conda:
     - conda-forge::package-name
   ```
3. Use alternative method (`r_conda` → `r_package`)

### Version Conflicts

**Problem**: "Conflicts encountered" during solve

**Solutions**:
1. Relax version constraints
2. Change installation order
3. Split into smaller blocks
4. Use `mamba:` solver

### Build Failure

**Problem**: Package installation fails

**Debug steps**:
```bash
# Check error log
cat results/coble-variant/errors.log

# Check missing packages
cat results/coble-variant/missing.txt

# Review build output
less results/coble-variant/build.log
```

### GitHub Rate Limits

**Problem**: GitHub API rate limit exceeded

**Solutions**:
1. Use `wget:` for GitHub archives:
   ```yaml
   - wget:
     - https://github.com/owner/repo/archive/refs/heads/main.zip
   ```
2. Set GitHub token (for CI/CD):
   ```bash
   export GITHUB_PAT=<your_token>
   ```

### R Package Compilation Fails

**Problem**: R package build fails with compiler errors

**Solutions**:
1. Install system dependencies first:
   ```yaml
   - conda:
     - libxml2
     - zlib
     - boost-cpp
   ```
2. Try conda version instead:
   ```yaml
   # Instead of:
   - r_package:
     - xml2
   
   # Use:
   - r_conda:
     - xml2
   ```

### Disk Space Issues

**Problem**: Build runs out of disk space

**Solutions**:
1. Add cleanup steps:
   ```yaml
   - bash:
     - conda clean -afy
   ```
2. Use shared package cache:
   ```bash
   --pkg /shared/conda-cache
   ```
3. Remove temp files:
   ```yaml
   - bash:
     - rm -rf /tmp/*
   ```

---

## Advanced Patterns

### Conditional Installation

Use `bash:` for conditional logic:

```yaml
- bash:
  - |
    if [ -f /path/to/file ]; then
      Rscript -e "install.packages('special-package')"
    fi
```

### Parallel Installation

Some R packages support parallel builds:

```yaml
- bash:
  - export MAKEFLAGS="-j4"
  - Rscript -e "install.packages('large-package')"
```

### Custom Repositories

Install from custom CRAN mirrors or R-Forge:

```yaml
- bash:
  - Rscript -e "install.packages('countreg', repos='http://R-Forge.R-project.org')"
  - Rscript -e "install.packages('pracma', repos='http://R-Forge.R-project.org')"
```

### Git Clone and Install

For packages requiring manual build:

```yaml
- bash:
  - git clone https://git.bioconductor.org/packages/DeconRNASeq
  - R CMD INSTALL DeconRNASeq
  - rm -rf DeconRNASeq
```

### Force Reinstall

Reinstall with specific options:

```yaml
- bash:
  - Rscript -e "BiocManager::install('preprocessCore', configure.args='--disable-threading', force = TRUE)"
```

---

## Validation

### Check Configuration Syntax

```bash
# Validate YAML syntax
python -c "import yaml; yaml.safe_load(open('config/coble-custom.yml'))"
```

### Test Build Locally

```bash
# Test build with mini config first
bash bin/coble-bash.sh \
  --steps "create,export,errors" \
  --input "config/coble-custom.yml" \
  --results "results/test" \
  --env "./envs/test"
```

### Check for Missing Packages

```bash
# Review missing packages report
cat results/test/missing.txt
```

---

## Configuration Template

Starting template for new variants:

```yaml
#coble-yml
dependencies:
  # Initialize mamba for faster solving (optional)
  - mamba:
  
  # System libraries
  - conda:
    - libxml2
    - zlib
  
  # Core R packages
  - r_conda:
    - biocmanager
    - devtools
    - remotes
  
  # Bioconductor packages
  - bio_package:
    - BiocGenerics
  
  # CRAN packages
  - r_package:
    - tidyverse
  
  # GitHub packages
  - github:
    - owner/repo
  
  # Python packages
  - pip:
    - numpy
  
  # Custom commands
  - bash:
    - conda clean -afy
```

---

## Additional Resources

- [Develop: Conda](develop-conda.md) - Building environments
- [Develop: Docker](develop-docker.md) - Container builds
- [Develop: Singularity](develop-singularity.md) - HPC containers
- [CLI Reference](cli-reference.md) - Command options
- [Conda Documentation](https://docs.conda.io/)
- [Bioconductor](https://bioconductor.org/)
