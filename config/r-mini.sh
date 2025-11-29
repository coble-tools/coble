# recipe for building Syed's 4.5.2

# sbatch code/coble-recipe-slurm.sh --results results/r-mini --input config/r-mini.sh --env ./envs/r-mini

rm -rf ./envs/r-mini
rm -rf ./pkgs/r-mini
conda create -p ${CONDA_COBLE_ENV} -y r-base=4.5.2 python=3.14.0

conda activate ${CONDA_COBLE_ENV}

conda install -y r-biocmanager --no-update-deps

