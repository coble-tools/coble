# Build for conda
```bash
code/coble build --recipe recipes/icr/bcds/bcds.cbl \
--env bcds \
--validate recipes/icr/bcds/validate/validate.sh \
--val-folder recipes/icr/bcds/validate/ \
--rebuild
```

# On Alma
cd /data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/CBL
git clone git@github.com:ICR-RSE-Group/coble.git
cd coble
git checkout fix-issue-94

sbatch -o bcds.log -e bcds.err --time 12:00:00 -c 8 --wrap "\
/data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/CBL/coble/code/coble build \
--recipe recipes/icr/bcds/bcds.cbl \
--env bcds \
--validate recipes/icr/bcds/validate/validate.sh \
--val-folder recipes/icr/bcds/validate/ --rebuild"