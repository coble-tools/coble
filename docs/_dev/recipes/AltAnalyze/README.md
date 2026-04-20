# AltAnalyze

In python 2.7: https://www.altanalyze.org/


```
code/coble build \
--recipe dev-recipes/AltAnalyze/alt-analyze.cbl \
--validate dev-recipes/AltAnalyze/validate.sh \
--env alt-analyze \
--containers conda \
--rebuild
```

# On Alma
```bash
RECIPE_DIR=Utils/builds/chief
COBLE_DIR=/data/rds/DIT/SCICOM/SCRSE/shared/apps/coble
CONDA_PATH=/data/scratch/DBC/UBCN/BCRBIOIN/SHARED/software/conda_envs
CONDA_NAME=CHIEF_DEV

cd $RECIPE_DIR

sbatch -o slurm.log -e slurm.err --time 12:00:00 -c 4 --wrap \
"$COBLE_DIR/code/coble build \
--recipe chief_dev.cbl \
--env $CONDA_PATH/$CONDA_NAME \
--validate validate.sh \
--containers conda \
--rebuild"
```

RECIPE_FOLDER=/data/scratch/DBC/UBCN/BCRBIOIN/shaider/temp/cbl-alt-analyze
CONDA_FOLDER=/data/scratch/DBC/UBCN/BCRBIOIN/SHARED/software/conda_envs

RECIPE_FOLDER=/data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/coble-recipes/alt-analyze
CONDA_FOLDER=/data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/coble-envs

/data/rds/DIT/SCICOM/SCRSE/shared/apps/coble/code/coble build \
--recipe $RECIPE_FOLDER/alt-analyze.cbl \
--validate $RECIPE_FOLDER/validate.sh \
--env $CONDA_FOLDER/alt-analyze \
--rebuild

# syed
RECIPE_DIR=/data/scratch/DBC/UBCN/BCRBIOIN/shaider/temp/cbl-alt-analyze
CONDA_PATH=/data/scratch/DBC/UBCN/BCRBIOIN/SHARED/software/conda_envs
CONDA_NAME=alt_analyze
# rachel
RECIPE_DIR=/data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/coble-recipes/alt-analyze
CONDA_PATH=/data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/coble-envs
CONDA_NAME=alt_analyze


cd $RECIPE_DIR
COBLE_DIR=/data/rds/DIT/SCICOM/SCRSE/shared/apps/coble

sbatch -o slurm.log -e slurm.err --time 12:00:00 -c 4 --wrap \
"$COBLE_DIR/code/coble build \
--recipe alt-analyze.cbl \
--env $CONDA_PATH/$CONDA_NAME \
--validate validate.sh \
--containers conda \
--rebuild"
