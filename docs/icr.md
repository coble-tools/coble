# Running on an HPC Cluster

There is an installation in the RSE area of alma that can be accessed as follows:

Assuming you want to create your cbl input file at `mycoble.cbl` and want to create a conda environemtn in the prefix location `./env-cbl` then:

```bash
/data/rds/DIT/SCICOM/SCRSE/shared/apps/coble/code/coble \
template --input mycoble.cbl --flavour basic
```

## BASH
```bash
/data/rds/DIT/SCICOM/SCRSE/shared/apps/coble/code/coble \
update --input mycoble.cbl --env ./env-cbl
```

## SLURM
```bash
/data/rds/DIT/SCICOM/SCRSE/shared/apps/coble

sbatch -o my.log -e my.err --time 12:00:00 -c 4 --wrap \
"/data/rds/DIT/SCICOM/SCRSE/shared/apps/coble/code/coble update --input mycoble.cbl --env ./env-cbl"
```




