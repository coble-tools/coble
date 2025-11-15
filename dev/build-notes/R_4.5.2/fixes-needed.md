# Fixes and Order Hacks Needed for R 4.5.2


## Orders to be careful of installing packages for R 4.5.2

### StJoincount
```
export CONDA_PKGS_DIRS=./pkgs/4.5.2-tst2
mkdir -p ./pkgs/4.5.2-tst2
conda create -y -p ./envs/4.5.2-tst2 r-base=4.5.2 python=3.14.0
conda activate ./envs/4.5.2-tst2
conda install -y r-biocmanager --no-update-deps
conda install -y r-data.table --no-update-deps
Rscript -e "BiocManager::install('fgsea',force=TRUE)"
conda install -y r-raster --no-update-deps
conda install -y r-spdep --no-update-deps
conda install -y r-magick --no-update-deps
Rscript -e "BiocManager::install('stJoincount',force=TRUE)"
```

### Fgsea
```
export CONDA_PKGS_DIRS=./pkgs/4.5.2-tst
conda create -y -p ./envs/4.5.2-tst r-base=4.5.2 python=3.14.0
conda activate ./envs/4.5.2-tst
conda install -y r-biocmanager --no-update-deps
Rscript -e "BiocManager::install('fgsea',force=TRUE)" # FAILED
# load a dependency
conda install -y r-data.table --no-update-deps
Rscript -e "BiocManager::install('fgsea',force=TRUE)" # SUCCEEDED
```

## Dev changes needed

### maptools
C error needs a code change, I made a repo with the code from archive:
[https://github.com/rachelicr/r-maptools](https://github.com/rachelicr/r-maptools)
```
R -e "devtools::install_url('https://github.com/rachelicr/r-maptools/archive/refs/heads/main.zip')"
```

### pysamstats
A circular dependency on cython means changes needed to be made to setup.py for the dependency to pysam to force the right build order. I made a repo with the changed code: [https://github.com/rachelicr/pysamstats](https://github.com/rachelicr/pysamstats)
```
python -m pip install setuptools>=59.0
python -m pip install --upgrade "Cython>=3.0.11"
python -m pip install pysam #I didn't change this in the end
python -m pip install --no-build-isolation git+https://github.com/rachelicr/pysamstats.git
```

## Unresolved issues
cellHTS2