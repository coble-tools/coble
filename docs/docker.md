# Docker Usage

COBLE provides pre-built Docker images on [DockerHub](https://hub.docker.com/r/icrsc/coble) for immediate use.

## Available Images

All images are available under the `icrsc/coble` repository:

| Image Tag | Description | Config File |
|-----------|-------------|-------------|
| `icrsc/coble:452` | Classic R 4.5.2 environment | `config/coble-452.yml` |
| `icrsc/coble:mini` | Minimal R 4.5.2 environment | `config/coble-mini.yml` |
| `icrsc/coble:tst` | Test image | `config/coble-tst.yml` |

## Basic Usage

### Pull an Image

```bash
docker pull icrsc/coble:452
```

### Run Interactively

```bash
docker run --rm -it icrsc/coble:452
```

This will:
- Start a bash shell inside the container
- Automatically activate the conda environment
- Give you immediate access to all installed packages

### Verify the Environment

Inside the container:

```bash
# Check Python version
python --version

# Check R version
R --version

# List conda packages
conda list

# List R packages
R -e "installed.packages()[,c('Package','Version')]"
```

### Check Release and Variant

Images expose both a release (tool/image) and a variant (environment flavor):

```bash
echo $COBLE_RELEASE          # e.g. v1.0.0 or dev
echo $COBLE_VARIANT          # e.g. 452, mini, xyz
env | grep COBLE_RELEASE
env | grep COBLE_VARIANT
```

From outside (non-interactive run):

```bash
docker run --rm icrsc/coble:452 bash -c 'echo $COBLE_RELEASE'
docker run --rm icrsc/coble:452 bash -c 'echo $COBLE_VARIANT'
```

`COBLE_VARIANT` comes from `BUILD_TAG` (environment flavor). `COBLE_RELEASE` comes from the GitHub release tag or falls back to `git describe` / `dev`.

## Advanced Usage

### Mount Local Directories

Work with files on your host system:

```bash
docker run --rm -it -v $(pwd):/workspace -w /workspace icrsc/coble:452
```

### Run a Script

Execute a Python or R script directly:

```bash
# Python script
docker run --rm -v $(pwd):/workspace -w /workspace icrsc/coble:452 python script.py

# R script
docker run --rm -v $(pwd):/workspace -w /workspace icrsc/coble:452 Rscript analysis.R
```

### Use Specific Environment Variables

```bash
docker run --rm -it \
  -e MY_VAR=value \
  -v $(pwd):/workspace \
  icrsc/coble:452
```

## Building Your Own Images

If you need a custom environment, build from the provided Dockerfiles:

```bash
docker build -f docker/Dockerfile.452 --build-arg BUILD_TAG=452 -t my-custom-coble:452 .
```

Provide a config file for the build. The Dockerfile expects a YAML based on the BUILD_TAG. You can edit coble-452.yml, or you can create your own e.g. `config/custom-xyz.yml`

```bash
docker build -f docker/Dockerfile.452 --build-arg BUILD_TAG=xyz -t my-custom-coble:xyz .
```

## Pushing to Your Own Registry

Tag and push to your registry:

```bash
docker tag icrsc/coble:452 myregistry.com/coble:452
docker push myregistry.com/coble:452
```

## Troubleshooting

### Container Won't Start

Check Docker daemon is running:

```bash
docker info
```

### Permission Issues

If you encounter permission errors with mounted volumes, try:

```bash
docker run --rm -it --user $(id -u):$(id -g) -v $(pwd):/workspace icrsc/coble:452
```

### Out of Disk Space

Clean up unused images:

```bash
docker system prune -a
```

## Next Steps

- [Singularity Usage](singularity.md) - Convert to Singularity for HPC
- [Command Reference](cli-reference.md) - Build custom environments
