# COBLE - COnda BuiLdEr
ssh ralcraft@alma.icr.ac.uk
srun --pty --mem=8GB -c 2 -t 30:00:00 -p interactive bash

# FIRST TIME SETUP ONLY
mkdir -p /data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV
cd /data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV
git clone git@git.icr.ac.uk:sc-rse/group/collaborations/bcrbioin/conda-builds.git
#---------------------------------

# Navigate to folder
cd /data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/conda-builds

# Test the recipes in 3 modes: MINE, Syed's bash script, and the bash converted to yaml mode
sbatch -o logs/syed-recipe-01.out \
       -e logs/syed-recipe-01.err \
       bin/coble-slurm.sh \
       --steps "recipe,export,errors,missing" \
       --input "config/syed-recipe.txt" \
       --results "results/syed-recipe-01" \
       --r-version "4.5.2" \
       --python-version "3.14.0" \
       --env "./envs/syed-recipe-4.5.2" \
       --pkg "./pkgs/syed-recipe-4.5.2" \
       --output logs/syed-recipe-01.out \
       --error logs/syed-recipe-01.err

sbatch -o logs/syed-recipe-yaml-01.out \
       -e logs/syed-recipe-yaml-01.err \
       bin/coble-slurm.sh \
       --steps "create,export,errors,missing" \
       --input "config/syed-recipe.yml" \
       --results "results/syed-recipe-yaml-01" \
       --r-version "4.5.2" \
       --python-version "3.14.0" \
       --env "envs/syed-yaml-4.5.2" \
       --pkg "pkgs/syed-yaml-4.5.2" \
       --output logs/syed-recipe-yaml-01.out \
       --error logs/syed-recipe-yaml-01.err

sbatch -o logs/syed-ordered-01.out \
       -e logs/syed-ordered-01.err \
       bin/coble-slurm.sh \
       --steps "create,export,errors,missing" \
       --input "config/ordered.yml" \
       --results "results/syed-ordered-01" \
       --r-version "4.5.2" \
       --python-version "3.14.0" \
       --env "envs/syed-ordered-4.5.2" \
       --pkg "pkgs/syed-ordered-4.5.2" \
       --output logs/syed-ordered-01.out \
       --error logs/syed-ordered-01.err





# export
bash bin/coble-bash.sh \
       --steps "export" \
       --results "results/syed_exp" \
       --env "./envs/syed-recipe-4.5.2"
       

# compare
bash bin/coble-bash.sh \
       --steps compare \
       --lhs-env ./envs/syed-recipe-4.5.2 \
       --rhs-env ./envs/syed-ordered-4.5.2 \
       --results ./results/compare-syed-recipe-vs-ordered

# convert recpe to yaml
bash bin/coble-bash.sh \
       --steps convert \
       --input "config/syed-recipe.txt" \
       --results ./results/syed-converted
