# Build the basic template recipe in docker

## Build: basic

**Recipe:** `config/basic.cbl`

**Build Command:**
```bash
docker build -f code/Dockerfile.cbl \
  --build-arg RECIPE_CBL=config/basic.cbl \
  --build-arg BUILD_TAG=basic \
  -t basic-cbl .
```

**Run the container:**
```bash
docker run --rm -it basic-cbl
```

**Singularity (optional):**
```bash
docker save basic-cbl -o basic-cbl.tar
singularity build cbl-basic.sif docker-archive://basic-cbl.tar

# To use the conda environment interactively in Singularity:
singularity shell cbl-basic.sif
# Then inside the container shell, activate the environment:
source /app/activate_conda.sh

# To execute a command or script (with environment activated)
singularity exec coble-452syed.sif /app/activate_and_run.sh /path/to/yourscript.sh
```