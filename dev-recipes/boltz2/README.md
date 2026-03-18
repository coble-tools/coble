# Boltz-2


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