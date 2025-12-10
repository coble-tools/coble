# COBLE Usage Guide

COBLE can be used in three different ways:

## 1. Using the Base Docker Image (Recommended for Docker Users)

Build and push the base image once:
```bash
docker build -f containers/docker/Dockerfile.base -t icrsc/coble:base .
docker push icrsc/coble:base
```

Users can then extend it with their own recipes:

**User's Dockerfile:**
```dockerfile
FROM icrsc/coble:base

# Copy your recipe file
COPY my-recipe.sh /app/config/recipe.sh

# Build the environment
RUN coble.sh \
    --input /app/config/recipe.sh \
    --env /app/envs/myenv \
    --r-version 4.5.2 \
    --python-version 3.14.0 \
    --skip-errors

# Auto-activate on shell start
RUN conda init bash && \
    echo "conda activate /app/envs/myenv" >> /root/.bashrc

CMD ["/bin/bash"]
```

Build:
```bash
docker build -t myname/my-env:latest .
```

## 2. Using the Generic Dockerfile (For Quick Builds)

Build and run with a specific recipe:
```bash
docker build -f containers/docker/Dockerfile.generic \
  --build-arg RECIPE_FILE=config/my-recipe.sh \
  --build-arg BUILD_TAG=my-env \
  -t myname/my-env:latest .
```

## 3. Installing as a Python Package

Install from GitHub:
```bash
pip install git+https://github.com/ICR-RSE-Group/coble.git
```

Use the CLI:
```bash
# Check version
coble --version

# Build an environment
coble build \
  --input my-recipe.sh \
  --env ./myenv \
  --r-version 4.5.2 \
  --skip-errors

# Get help
coble --help
coble build --help
```

### Singularity Support

Convert Docker images to Singularity:
```bash
# Pull from Docker Hub
singularity pull coble.sif docker://icrsc/coble:base

# Shell into container
singularity shell coble.sif

# Execute with environment activated
singularity exec coble.sif bash -c "source /app/activate_conda.sh && python my_script.py"
```

## Publishing Your Own Images

1. Build your custom environment
2. Test it locally
3. Push to Docker Hub or your registry:

```bash
docker build -t myusername/my-bioinf-env:v1.0 .
docker push myusername/my-bioinf-env:v1.0
```

Share with colleagues:
```bash
docker pull myusername/my-bioinf-env:v1.0
docker run --rm -it myusername/my-bioinf-env:v1.0
```

## Troubleshooting

### Check build logs
Results are saved in `--results` directory:
- `coble-stdout.log` - Standard output
- `coble-stderr.log` - Error messages
- `recipe.sh` - Generated installation script
- `environment.yml` - Exported conda environment
- `r-packages.txt` - Installed R packages
- `python-packages.txt` - Installed Python packages

### View results in Docker
```bash
docker run --rm -it -v "$PWD/results:/app/results/coble" myimage:latest
```

Inside container:
```bash
cat /app/results/coble/coble-stderr.log
```
