# Running on an HPC Cluster

The COBLE recipes are siple bash scripts, and the COBLE utility can be activated in conda or used directly from git.

If using directly from git you will have a path to the coble script, if in conda the path will be in your env-path. Assume for this that the path is in the env-path and subsitute a full path if necessary.

## SLURM

Assuming you have a recipe file at `myrecipe.yml` and want to create a conda environemtn in the prefix locaiton `./myenv` then:
```bash
sbatch -o my.log -e my.err --time 12:00:00 --wrap \
"coble build --recipe myrecipe.cbl --env ./myenv"
```

# Running on an HPC Cluster

There is an installation in the RSE area of alma that can be accessed as follows:

Assuming you want to create your cbl input file at `mycoble.cbl` and want to create a conda environemtn in the prefix location `./env-cbl` then:

```bash
/data/rds/DIT/SCICOM/SCRSE/shared/apps/coble/code/coble \
template --recipe mycoble.cbl --flavour basic
```

## BASH
```bash
/data/rds/DIT/SCICOM/SCRSE/shared/apps/coble/code/coble \
build --recipe mycoble.cbl --env ./env-cbl
```

## SLURM
```bash
sbatch -o my.log -e my.err --time 12:00:00 -c 4 --wrap \
"/data/rds/DIT/SCICOM/SCRSE/shared/apps/coble/code/coble \
build --recipe mycoble.cbl --env ./env-cbl"
```



