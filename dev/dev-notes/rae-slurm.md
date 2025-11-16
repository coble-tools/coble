# dry run


sbatch -o results/coble-452.out \
       -e results/coble-452.err \
       bin/coble-slurm.sh \
       --steps "create,export,errors,missing" \
       --input "config/coble-452.yml" \
       --results "results/coble-452" \
       --r-version "4.5.2" \
       --python-version "3.14.0" \
       --env "./envs/coble-452" \
       --pkg "./pkgs/coble-452" \
       --output results/coble-452.out \
       --error results/coble-452.err

