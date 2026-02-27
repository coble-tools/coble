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

## Community Containers at the ICR
The containers are stored on the RSE section of RDS and can be accessed like below. Examples are given for DESeq2 and the foundation model ProvGigaPath. Note that for ProvGigaPath the container will pick the appropriate hardware depending on existing of, or suitability of, GPUs.
The containers open with the current working directory mapped as a read-write space to the containers `/workspace`.

### DESeq2
```bash
singularity shell \
--bind .:/workspace \
/data/rds/DIT/SCICOM/SCRSE/shared/singularity/coble-papers-deseq2.sif
```
In this container, running “validate.sh” will run the initially published vignette to the first plot which will be produced in your working directory.


### ProvGigaPath
```bash
singularity shell --nv \
--bind .:/workspace \
--env HF_TOKEN=$HF_TOKEN \
/data/rds/DIT/SCICOM/SCRSE/shared/singularity/coble-papers-provgigapath.sif
```
In this container, running “validate.sh” will run code taken from the demo notebook published in June 2025 (converted to a script): https://github.com/prov-gigapath/prov-gigapath/blob/main/demo/run_gigapath.ipynb. Some amendments were made to detect hardware and fallback to CPU where hardware is not compatible in order to make the environment truly usable. This required a minor amendment to the pipeline code of the repo to allow CPU as a fallback (https://github.com/rachelicr/prov-gigapath/tree/fix/respect-device-parameter).




