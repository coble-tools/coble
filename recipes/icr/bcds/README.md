# Build for conda
```bash
code/coble build --recipe recipes/icr/bcds/bcds.cbl \
--env bcds \
--validate recipes/icr/bcds/validate/validate.sh \
--val-folder recipes/icr/bcds/validate/ \
--rebuild
```

# On Alma

## updating build
cd /data/rds/DIT/SCICOM/SCRSE/shared/apps/coble
git pull

## To run

cd /data/scratch/DBC/UBCN/BCRBIOIN/shaider/temp
or
cd /data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/CBL/bcds

# Get the template recipe
bash /data/rds/DIT/SCICOM/SCRSE/shared/apps/coble/code/coble \
template --recipe bcds.cbl --flavour bioinf

# kick it off on slurm
sbatch -o slurm.log -e slurm.err --time 12:00:00 -c 8 --wrap \
"/data/rds/DIT/SCICOM/SCRSE/shared/apps/coble/code/coble \
build --recipe bcds.cbl --env ./cbl-env-452 --rebuild"






cd /data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/CBL
git clone git@github.com:ICR-RSE-Group/coble.git
cd coble
git checkout fix-issue-94

## REBUILD
sbatch -o bcds-a.log -e bcds-a.err --time 12:00:00 -c 8 --wrap "\
/data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/CBL/coble/code/coble build \
--recipe recipes/icr/bcds/bcds.cbl \
--env bcds \
--validate recipes/icr/bcds/validate/validate.sh \
--val-folder recipes/icr/bcds/validate/ --rebuild"

## RESUME
sbatch -o bcds-a.log -e bcds-a.err --time 12:00:00 -c 8 --wrap "\
/data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/CBL/coble/code/coble build \
--recipe recipes/icr/bcds/bcds.cbl \
--env bcds \
--validate recipes/icr/bcds/validate/validate.sh \
--val-folder recipes/icr/bcds/validate/"

