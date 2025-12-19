cd /data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/conda-builds
# Manual repeat
MY_ENV_NAME=manual-4.4.2
mkdir -p ./pkgs/$MY_ENV_NAME
export CONDA_PKGS_DIRS=./pkgs/$MY_ENV_NAME
rm -rf "./envs/${MY_ENV_NAME}"
rm -rf "./pkgs/${MY_ENV_NAME}/*"

conda config --set channel_priority strict
conda create -p ./envs/$MY_ENV_NAME conda-forge::r-base=4.4.2
conda activate ./envs/$MY_ENV_NAME
conda install -y bioconda::bioconductor-stjoincount



mamba create -p ./envs/$MY_ENV_NAME r-base=4.4.2
mamba activate ./envs/$MY_ENV_NAME
mamba install -y conda-forge::r-stringi --no-update-deps
mamba install -y conda-forge::r-rcpp --no-update-deps
mamba install -y conda-forge::r-ggiraph --no-update-deps
mamba install -y conda-forge::r-plyr --no-update-deps
mamba install -y conda-forge::r-reticulate --no-update-deps
mamba install -y conda-forge::r-sitmo --no-update-deps
mamba install -y conda-forge::r-seurat --no-update-deps
mamba install -y bioconda::bioconductor-stjoincount --no-update-deps





