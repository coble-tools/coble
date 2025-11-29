##############################################################################
# Test script to show correcting and re-running
# sbatch code/coble-recipe-slurm.sh --results results/tst --input config/tst.sh --env ./envs/tst
##############################################################################
echo "# CONDA_COBLE_ENV=${CONDA_COBLE_ENV}"
echo "# CONDA_PKGS_DIRS=${CONDA_PKGS_DIRS}"
echo "# R_LIBS_USER=${R_LIBS_USER}"
##############################################################################
conda create -p ${CONDA_COBLE_ENV} -y r-base=4.5.2 python=3.14.0
conda activate ${CONDA_COBLE_ENV}
coble@r@essentials devtools biocmanager