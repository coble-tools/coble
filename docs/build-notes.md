# Build Notes

This section contains detailed notes about building specific COBLE environments.

## R Version Builds

### R 4.5.2

Detailed build information for R 4.5.2 environments is available in the repository under `docs/build-notes/R_4.5.2/`.

Key files:
- Manual build process
- Recipe and configuration
- Proof of concept

### R 4.4.2

Detailed build information for R 4.4.2 environments is available in the repository under `docs/build-notes/R_4.4.2/`.

Key files:
- Build history
- Commands history
- Recipe details

## Common Build Issues

### Package Conflicts

When building environments with many R and Python packages, conflicts can arise:

**Solution**: Use strict channel priority:

```yaml
channels:
  - conda-forge
  - bioconda
  - defaults
channel_priority: strict
```

### Bioconductor Packages

Some Bioconductor packages require specific R versions:

```bash
# In your recipe
R -e "BiocManager::install('DESeq2', version='3.18')"
```

### Long Build Times

Large environments can take hours to solve and install:

- Use `mamba` instead of `conda` for faster solving
- Split large environments into base + extension layers
- Use the `mini` variants for testing

### Memory Issues

Large conda solves can consume significant memory:

```bash
# Request more memory in SLURM
#SBATCH --mem=64G
```

## Docker Build Tips

### Multi-stage Builds

Reduce final image size by using multi-stage builds (future enhancement).

### Cache Package Downloads

Reuse the conda package cache:

```dockerfile
ENV CONDA_PKGS_DIRS=/app/pkgs/coble-452
```

### Build Arguments

Use build arguments for flexibility:

```dockerfile
ARG BUILD_TAG=mini
ENV CONDA_PKGS_DIRS=/app/pkgs/coble-${BUILD_TAG}
```

## Debugging Failed Builds

### Check Logs

```bash
# Review error logs
cat logs/error.log | grep -i error

# Generate error report
bin/coble-bash.sh --steps errors --results ./results --error ./logs/error.log
```

### Check Missing Packages

```bash
bin/coble-bash.sh --steps missing --results ./results
```

### Isolate Problematic Packages

Comment out packages in YAML and test incrementally:

```yaml
dependencies:
  - numpy
  - pandas
  # - problematic-package  # Test without this
```

## Performance Optimization

### Use Mamba

Mamba is a faster reimplementation of conda:

```bash
bin/coble-bash.sh --steps mamba:create:export ...
```

### Parallel Installation

Some installations can be parallelized (use with caution):

```bash
conda install --parallel 4 package1 package2 package3
```

### Pre-download Packages

Download packages before building:

```bash
conda create --download-only -p ./download_cache -c conda-forge numpy pandas
```
