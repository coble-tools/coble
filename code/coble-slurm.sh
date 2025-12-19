#!/usr/bin/env bash
#SBATCH -J "CblRecipe"
#SBATCH --output=logs/coble-%j.out
#SBATCH --error=logs/coble-%j.err
#SBATCH -n 2
#SBATCH -t 20:00:00
#SBATCH --mail-type=END,FAIL

# Export some environment variables from slurm eg machine and node
echo "### SLURM ###################################"
echo "SLURM_JOB_ID=$SLURM_JOB_ID"
echo "SLURM_JOB_NODELIST=$SLURM_JOB_NODELIST"
echo "SLURM_NNODES=$SLURM_NNODES"
echo "SLURM_NTASKS=$SLURM_NTASKS"
echo "SLURM_CPUS_ON_NODE=$SLURM_CPUS_ON_NODE"
echo "SLURM_MEM_PER_CPU=$SLURM_MEM_PER_CPU"
echo "SLURM_MEM_PER_NODE=$SLURM_MEM_PER_NODE"
echo "SLURM_TIME_LIMIT=$SLURM_TIME_LIMIT"
echo "SLURM_MAIL_TYPE=$SLURM_MAIL_TYPE"
echo "SLURM_MAIL_USER=$SLURM_MAIL_USER"
# echo out user details and pwd
echo "USER=$USER"
echo "HOME=$HOME"
echo "PWD=$PWD"
# echo out coble script call
echo "COBLE RECIPE CALL: sbatch $0 $*"
echo "############################################"

source ~/.bashrc

bash code/coble.sh "$@"
exit $?
