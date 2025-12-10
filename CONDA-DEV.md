# How to Package and Upload a Bash Script to Conda

This guide explains how to create a conda package for your bash scripts and upload it to your own channel on Anaconda.org.

## 1. Prerequisites
- Install [conda](https://docs.conda.io/en/latest/miniconda.html) (Miniconda or Anaconda)
- Install `conda-build` and `anaconda-client`:
  ```bash
  conda install conda-build anaconda-client
  ```
- Create a free account at [Anaconda.org](https://anaconda.org)

## 2. Organize Your Files
Place your scripts in a directory, e.g.:
```
yourtool/
  coble.sh
  coble-slurm.sh
  meta.yaml
```

## 3. Create a Conda Recipe (`meta.yaml`)
Example `meta.yaml`:
```yaml
package:
  name: coble-recipe
  version: "0.1.0"

source:
  path: ../

build:
  number: 0
  script:
    - chmod +x coble.sh
    - chmod +x coble-slurm.sh

requirements:
  run:
    - bash

about:
  home: https://github.com/ICR-RSE-Group/coble
  license: MIT
  summary: "COBLE bash scripts for reproducible bioinformatics environments"

extra:
  recipe-maintainers:
    - rachel
```

## 4. Build the Package
From the parent directory:
```bash
conda build yourtool/
```
The built package will be in `~/conda-bld/<platform>/`.

## 5. Upload to Your Channel
Log in to Anaconda.org:
```bash
anaconda login
```
Upload the package:
```bash
anaconda upload ~/conda-bld/<platform>/coble-recipe-0.1.0-0.tar.bz2
```

## 6. Install from Your Channel
Other users can install with:
```bash
conda install -c <your_username> coble-recipe
```

## 7. Tips
- You can include multiple scripts and config files.
- Update the version in `meta.yaml` for new releases.
- For more info: [Conda Build Docs](https://docs.conda.io/projects/conda-build/en/latest/)

---
(c) 2025 Rachel Alcraft
