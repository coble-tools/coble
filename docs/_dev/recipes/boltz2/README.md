# Boltz-2

**https://github.com/jwohlwend/boltz**  

```
code/coble build \
--recipe dev-recipes/boltz2/boltz2.cbl \
--validate dev-recipes/boltz2/validate/validate.sh \
--val-folder dev-recipes/boltz2/validate \
--env boltz2 \
--containers conda \
--rebuild

code/coble build \
--recipe dev-recipes/boltz2/boltz2.cbl \
--validate dev-recipes/boltz2/validate/validate.sh \
--val-folder dev-recipes/boltz2/validate \
--env boltz2 \
--containers docker,singularity \
--rebuild
```

# Singularity
singularity build \
coble-papers-provgigapath.sif \
docker://ghcr.io/coble-tools/coble:papers-boltz2

singularity shell --nv \
coble-papers-boltz2.sif

singularity shell --nv sifs/cbl-boltz2.sif

# RA on alma
/data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/coble-recipes/boltz2/prot-lig.yaml

srun --pty -t 1:00:00 -p gpu --gres=gpu:1 bash
cd /data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/coble-recipes/boltz2
singularity shell --nv /data/rds/DIT/SCICOM/SCRSE/shared/singularity/cbl-boltz2.sif

export XDG_CACHE_HOME=/data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/coble-recipes/boltz2/mycache
boltz predict --use_msa_server test/prot-lig.yaml --cache /data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/coble-recipes/boltz2/mycache




