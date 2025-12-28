# Running on an HPC Cluster

The COBLE recipes are siple bash scripts, and the COBLE utility can be activated in conda or used directly from git.

If using directly from git you will have a path to the coble script, if in conda the path will be in your env-path. Assume for this that the path is in the env-path and subsitute a full path if necessary.

## SLURM

Assuming you have a recipe file at `myrecipe.yml` and want to create a conda environemtn in the prefix locaiton `./myenv` then:
```bash
sbatch -o my.log -e my.err --time 12:00:00 --wrap \
"coble build --input myrecipe.yml --env ./myenv"
```




