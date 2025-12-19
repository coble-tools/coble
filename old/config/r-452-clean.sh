# Recipe for building clean 4.5.2
# code/coble-slurm.sh --results results/r-452-clean --input config/r-452-clean.sh --env ./envs/r-452-clean --skip-errors --override-envs

conda create -y -p ${CONDA_COBLE_ENV} r-base=4.5.2 python=3.14.0    
conda activate ${CONDA_COBLE_ENV}
conda install -y -c conda-forge r-biocmanager r-devtools --no-update-deps
conda install -y -c conda-forge r-devtools gcc_linux-64 gxx_linux-64 --no-update-deps
conda install -y -c conda-forge boost-cpp zlib numpy fonts-conda-ecosystem libxml2 --no-update-deps

