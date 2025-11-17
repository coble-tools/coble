# dry run


sbatch -o results/coble-452-2.out \
       -e results/coble-452-2.err \
       bin/coble-slurm.sh \
       --steps "create,export,errors,missing" \
       --input "config/coble-452.yml" \
       --results "results/coble-452-2" \
       --r-version "4.5.2" \
       --python-version "3.14.0" \
       --env "./envs/coble-452-2" \
       --pkg "./pkgs/coble-452-2" \
       --output results/coble-452-2.out \
       --error results/coble-452-2.err \
       --quiet "y" \
       --divert "n"

