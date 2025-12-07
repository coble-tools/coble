# COBLE Build Specifications

This document specifies the inputs and configurations for all COBLE Docker builds.

## Build: 452clean (using generic)

**Recipe:** `config/r-452-clean.sh`

**Build Command:**
```bash
docker build -f containers/docker/Dockerfile.generic \
  --build-arg RECIPE_FILE=config/r-452-clean.sh \
  --build-arg BUILD_TAG=r-452-clean \
  -t icrsc/coble:452clean .
```

**Push to registry:**
```bash
docker push icrsc/coble:452clean
```

**Run the container:**
```bash
docker run --rm -it icrsc/coble:452clean
```

**Singularity (optional):**
```bash
docker save icrsc/coble:452clean -o coble-452clean.tar
singularity build coble-452clean.sif docker-archive://coble-452clean.tar
singularity shell coble-452clean.sif
source /app/activate_conda.sh
```
---

## Build: 452syed (using generic)

**Recipe:** `config/r-452-syed.sh`

**Build Command:**
```bash
docker build -f containers/docker/Dockerfile.generic \
  --build-arg RECIPE_FILE=config/r-452-syed.sh \
  --build-arg BUILD_TAG=r-452-syed \
  -t icrsc/coble:452syed .
```

**Push to registry:**
```bash
docker push icrsc/coble:452syed
```

**Run the container:**
```bash
docker run --rm -it icrsc/coble:452syed
```

**Singularity (optional):**
```bash
docker save icrsc/coble:452syed -o coble-452syed.tar
singularity build coble-452syed.sif docker-archive://coble-452syed.tar

# To use the conda environment interactively in Singularity:
singularity shell coble-452syed.sif
# Then inside the container shell, activate the environment:
source /app/activate_conda.sh
```