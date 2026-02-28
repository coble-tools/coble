# Prov-GigaPath

Code Repo: https://github.com/prov-gigapath/prov-gigapath
Nature paper: https://www.nature.com/articles/s41586-024-07441-w

Notes:
Fairly old, uses both a requirements.txt and an environment.yaml that are well formed.


srun --pty -t 1:00:00 -p gpudev --gres=gpu:1 bash

```
code/coble build \
--recipe recipes/papers/ProvGigaPath/ProvGigaPath.cbl \
--env ProvGigaPath \
--validate recipes/papers/ProvGigaPath/validate/validate.sh \
--val-folder recipes/papers/ProvGigaPath/validate \
--rebuild

code/coble build \
--recipe recipes/papers/ProvGigaPath/ProvGigaPath.cbl \
--env provpigapath \
--validate recipes/papers/ProvGigaPath/validate/validate.sh \
--val-folder recipes/papers/ProvGigaPath/validate \
--code-source local \
--containers docker,singularity
```

## Accessing hugging fact through time

### add to the .bashrc
export HF_TOKEN=hf_**********


## Access from packages
### Docker
docker pull \
ghcr.io/coble-tools/coble:papers-provgigapath

docker run --rm -it -v .:/workspace \
--gpus all -e HF_TOKEN \
ghcr.io/coble-tools/coble:papers-provgigapath

### Singularity
singularity build \
coble-papers-provgigapath.sif \
docker://ghcr.io/coble-tools/coble:papers-provgigapath

singularity shell --nv \
--bind .:/workspace \
--env HF_TOKEN=$HF_TOKEN \
coble-papers-provgigapath.sif

