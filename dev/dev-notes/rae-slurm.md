
cd /data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/coble


sbatch bin/coble-slurm.sh \
  --steps "create,export,errors" \
  --input "config/coble-stjoincount.yml" \
  --results "results/coble-stjoincount" \
  --r-version "4.5.2" \
  --python-version "3.14.0" \
  --env "./envs/coble-stjoincount" \
  --pkg "./pkgs/coble-stjoincount"

sbatch bin/coble-slurm-sing.sh stjoincount

sbatch bin/coble-slurm.sh \
  --steps "create,export,errors" \
  --input "config/coble-452.yml" \
  --results "results/coble-452" \
  --r-version "4.5.2" \
  --python-version "3.14.0" \
  --env "./envs/coble-452" \
  --pkg "./pkgs/coble-452"

sbatch bin/coble-slurm-sing.sh 452
