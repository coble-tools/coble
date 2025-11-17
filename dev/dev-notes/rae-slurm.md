
cd /data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/coble

tag=452-4
sbatch -o results/coble-$tag.out \
       -e results/coble-$tag.err \
       bin/coble-slurm.sh \
       --steps "create,export,errors,missing" \
       --input "config/coble-452.yml" \
       --results "results/coble-$tag" \
       --r-version "4.5.2" \
       --python-version "3.14.0" \
       --env "./envs/coble-$tag" \
       --pkg "./pkgs/coble-$tag" \
       --output results/coble-$tag.out \
       --error results/coble-$tag.err \
       --quiet "y" \
       --divert "n"

