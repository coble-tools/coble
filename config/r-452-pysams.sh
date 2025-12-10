# Recipe for building fixed pysamsstat
# code/coble-slurm.sh --results results/r-452-pysams --input config/r-452-pysams.sh --env ./envs/r-452-pysams --skip-errors --override-envs

conda create -y -p ${CONDA_COBLE_ENV} r-base=4.5.2 python=3.14.0    
conda activate ${CONDA_COBLE_ENV}
python -m pip install "setuptools>=59.0"
python -m pip install --upgrade "Cython>=3.0.11"
python -m pip install pysam
python -m pip install --no-build-isolation git+https://github.com/rachelicr/pysamstats.git

