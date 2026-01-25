# DEV: Running on alma at the ICR

## Log on
```bash
ssh ralcraft@alma.icr.ac.uk
intr
```

## Update git installation
```bash
cd /data/rds/DIT/SCICOM/SCRSE/shared/apps/coble
git pull
```

## Run a new bionf from template
```bash
cd /data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/CBL

# get new template
tag=v3
/data/rds/DIT/SCICOM/SCRSE/shared/apps/coble/code/coble \
  template --recipe 452${tag}/bioinf.cbl --flavour bioinf

# kick off with rebuild on sbatch
sbatch -o 452/cbl.log -e 452/cbl.err --time 12:00:00 -c 8 --wrap \
"/data/rds/DIT/SCICOM/SCRSE/shared/apps/coble/code/coble \
build --recipe 452${tag}/bioinf.cbl --env ./env/env-452${tag} --rebuild"

# Just a netowrk graph
/data/rds/DIT/SCICOM/SCRSE/shared/apps/coble/code/coble \
network --frozen 452${tag}/bioinf.cbl --env ./env/env-452${tag}
```

monitor it, open in notepad:  
- /data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/CBL/452/bioinf.log
- /data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/CBL/452/bioinf_summary.txt

## Update bioinf
conda activate ./env-syed

# kick off without rebuild on sbatch
```bash
sbatch -o 452/cbl.log -e 452/cbl.err --time 12:00:00 -c 8 --wrap \
"/data/rds/DIT/SCICOM/SCRSE/shared/apps/coble/code/coble \
build --recipe 452/bioinf.cbl --env ./env-syed"
```


