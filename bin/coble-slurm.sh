#!/usr/bin/env bash
#SBATCH -J "CobleBuild"
#SBATCH --output=logs/coble-%j.out
#SBATCH --error=logs/coble-%j.err
#SBATCH -n 4
#SBATCH -t 100:00:00


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
echo "############################################"

bash bin/coble-bash.sh \
  --output "logs/coble-${SLURM_JOB_ID}.out" \
  --error "logs/coble-${SLURM_JOB_ID}.err" \
  "$@"

