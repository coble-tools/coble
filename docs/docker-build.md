# Build the basic template recipe in docker

## Build: basic

The coble utility can be called with `contain` instead of build and this builds both a docker and a singularity image.

**Recipe:** `config/basic.cbl`
**env** `my-env`
```bash
coble contain --input config/basic.cbl --env my-env
```
This outputs:
- `cbl-my-env.tar` a docker file
- `cbl-my-env.sif` a singularity file

To run them as a command line terminal with the environments activated:
```bash
# Docker: 
# Optionally load the tar
docker load -i cbl-my-env.tar
# Then run it
docker run --rm -it cbl-my-env

# Singularity: run directly
singularity shell cbl-my-env.sif
```

To check the active conda environment and versions inside:
```bash
# Check conda environment
conda info --envs

# Check active environment
conda env list

# List packages in the active environment
conda list

# Check specific package version
conda list | grep <package-name>
```


---  

Alternatively the steps can be done manually:

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