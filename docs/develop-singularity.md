# Develop: Singularity Images

Guide for building COBLE Singularity/Apptainer images for HPC environments.

## Overview

Singularity images are built from variant-specific definition files. Each variant is a separate `.def` file with hardcoded settings.

**Best for:** HPC clusters, air-gapped systems, environments without Docker, root-less execution

---

## Available Definition Files

Three pre-configured variants in `singularity/`:

| File | Variant | Solver | Packages | Best For |
|------|---------|--------|----------|----------|
| `coble-mini.def` | mini | conda | ~50 | Testing, minimal workflows |
| `coble-452.def` | 452 | mamba | 452+ | Full bioinformatics suite |
| `coble-tst.def` | tst | conda | Custom | Experimental packages |

### Hardcoded Settings Per Variant

Each `.def` file contains:
- Config file path: `/app/config/coble-<variant>.yml`
- Variant name: `COBLE_VARIANT=<variant>`
- Solver choice: conda or mamba
- Channels: conda-forge, bioconda, dranew, nodefaults
- R library path: `R_LIBS_USER=~/R/coble-<variant>-library`

---

## Local Singularity Builds

### Build with sudo

```bash
# Build mini variant (conda solver)
sudo singularity build singularity/coble-mini.sif singularity/coble-mini.def

# Build 452 variant (mamba solver, faster)
sudo singularity build singularity/coble-452.sif singularity/coble-452.def

# Build tst variant
sudo singularity build singularity/coble-tst.sif singularity/coble-tst.def
```

### Build with fakeroot (no sudo)

If your system supports fakeroot:

```bash
singularity build --fakeroot singularity/coble-452.sif singularity/coble-452.def
```

### Requirements

- Singularity/Apptainer installed (3.0+ or 1.0+)
- Internet access for base image and conda channels
- Either sudo or fakeroot capability
- Disk space: 5-15GB depending on variant

---

## Using Pre-built Docker Images

Convert existing Docker images to Singularity:

```bash
# Pull and convert from Docker Hub
singularity pull coble-452.sif docker://icrsc/coble:452

# Test
singularity shell coble-452.sif
```

**Advantages:**
- No build time required
- Uses CI-tested images
- Consistent with Docker deployments

**Requirements:**
- Internet access to Docker Hub
- Docker image must exist (built via CI/CD)

---

## Offline/Air-gapped Builds

### Workflow

Build on internet-connected machine, transfer to HPC:

```bash
# 1. On workstation with internet
sudo singularity build coble-452.sif singularity/coble-452.def

# 2. Transfer to HPC
scp coble-452.sif user@hpc-login:/scratch/username/containers/

# 3. Use on HPC (no rebuild needed)
ssh hpc-login
cd /scratch/username/containers
singularity shell coble-452.sif
```

### Verifying Transfers

```bash
# Check file integrity
md5sum coble-452.sif  # On source
md5sum coble-452.sif  # On destination - should match

# Check image info
singularity inspect coble-452.sif
```

---

## Testing Built Images

### Interactive Shell

```bash
# Launch shell (auto-activates conda environment)
singularity shell coble-452.sif

# Inside container
Singularity> echo $COBLE_VARIANT
452
Singularity> conda env list
Singularity> python --version
Singularity> R --version
Singularity> exit
```

### Execute Commands

```bash
# Run command with environment activated
singularity exec coble-452.sif bash -c "source /app/activate_conda.sh && python --version"

# Check installed packages
singularity exec coble-452.sif bash -c "source /app/activate_conda.sh && conda list | grep numpy"

# Run analysis script
singularity exec coble-452.sif bash -c "source /app/activate_conda.sh && python my_analysis.py"
```

### Image Inspection

```bash
# View metadata
singularity inspect coble-452.sif

# View help
singularity run-help coble-452.sif

# Check size
ls -lh coble-452.sif
du -sh coble-452.sif
```

---

## Adding New Singularity Variants

### Step-by-Step

1. **Create config file**:
   ```bash
   cp config/coble-mini.yml config/coble-custom.yml
   # Edit as needed
   ```

2. **Copy definition file**:
   ```bash
   cp singularity/coble-mini.def singularity/coble-custom.def
   ```

3. **Update hardcoded values** in `coble-custom.def`:

   **Labels section:**
   ```singularity
   %labels
       org.opencontainers.image.version custom
       org.opencontainers.image.title coble-custom
       org.opencontainers.image.description COBLE custom variant
   ```

   **Environment section:**
   ```singularity
   %environment
       export COBLE_VARIANT=custom
       export CONFIG_FILE=/app/config/coble-custom.yml
       export RESULTS_DIR=/app/results/coble-custom
       export R_LIBS_USER=~/R/coble-custom-library
       # ... other vars
   ```

   **Post section** - Update echo messages:
   ```bash
   echo "Building COBLE variant: custom"
   echo "Config: /app/config/coble-custom.yml"
   ```

   **Post section** - Update coble-bash.sh parameters:
   ```bash
   bash /app/bin/coble-bash.sh \
       --steps "$STEPS" \
       --input "/app/config/coble-custom.yml" \
       --results "/app/results/coble-custom" \
       # ... other params
   ```

   **Help section:**
   ```singularity
   %help
       COBLE - custom variant
       
       Description of custom variant purpose.
       
       Build:
           sudo singularity build singularity/coble-custom.sif singularity/coble-custom.def
   ```

4. **Choose solver**:
   - Use `conda` for small environments (< 100 packages)
   - Use `mamba` for large environments (100+ packages, faster)

5. **Build and test**:
   ```bash
   sudo singularity build singularity/coble-custom.sif singularity/coble-custom.def
   singularity shell singularity/coble-custom.sif
   ```

6. **Commit files**:
   ```bash
   git add config/coble-custom.yml singularity/coble-custom.def
   git commit -m "Add custom Singularity variant"
   git push
   ```

---

## Troubleshooting

### Error: "could not create user namespace"

**Symptom**: Build fails with namespace creation error

**Solutions**:
1. Use `--fakeroot` flag:
   ```bash
   singularity build --fakeroot coble-452.sif singularity/coble-452.def
   ```
2. Request admin to enable unprivileged user namespaces
3. Use `sudo` if you have permissions

### Error: "failed to pull docker image"

**Symptom**: Cannot download base image from Docker Hub

**Solutions**:
- Check internet connectivity:
  ```bash
  curl -I https://hub.docker.com/
  ping registry-1.docker.io
  ```
- Check proxy settings if behind firewall
- Try alternative base mirror if available
- Build offline using pre-pulled base

### Build Hangs at Conda Solve

**Symptom**: Build stalls at "Solving environment"

**Solutions**:
- Use mamba solver (edit `.def` to install mamba)
- Reduce package count in config
- Pin specific versions to reduce search space
- Increase timeout/resources
- Check for circular dependencies

### Permission Denied Writing to /app

**Symptom**: Cannot write files during `%post` section

**Solutions**:
- This is expected - ensure using `sudo` or `--fakeroot`
- Don't try to modify `/app` at runtime (read-only)
- Use bind mounts for writable directories:
  ```bash
  singularity shell --bind /scratch:/scratch coble-452.sif
  ```

### R Library Not Writable

**Symptom**: Cannot install R packages, library is read-only

**Solution**: R automatically uses `R_LIBS_USER=~/R/coble-<variant>-library`

```bash
# Inside container
Singularity> echo $R_LIBS_USER
/home/username/R/coble-452-library

# Install packages (creates directory automatically)
Singularity> R
> install.packages("ggplot2")
```

### Out of Disk Space During Build

**Symptom**: Build fails with "no space left"

**Solutions**:
```bash
# Check available space
df -h /tmp
df -h $SINGULARITY_TMPDIR

# Set temp directory with more space
export SINGULARITY_TMPDIR=/scratch/$USER/tmp
mkdir -p $SINGULARITY_TMPDIR
singularity build --fakeroot coble-452.sif singularity/coble-452.def
```

---

## Definition File Structure

### Key Sections

**%labels** - Image metadata
```singularity
%labels
    org.opencontainers.image.version 452
    org.opencontainers.image.title coble-452
```

**%files** - Copy local files into image
```singularity
%files
    bin /app/bin
    config /app/config
```

**%environment** - Runtime environment variables
```singularity
%environment
    export COBLE_VARIANT=452
    export R_LIBS_USER=~/R/coble-452-library
```

**%post** - Build steps (runs as root)
- Conda full update
- System package installation
- Channel configuration (nodefaults)
- Environment creation
- Activation script setup

**%runscript** - Default `singularity run` behavior
```singularity
%runscript
    exec /bin/bash "$@"
```

**%help** - Documentation
```singularity
%help
    Usage and build instructions
```

### Key Differences from Docker

| Feature | Docker | Singularity |
|---------|--------|-------------|
| Build args | `--build-arg` supported | Hardcoded per file |
| Channels | Can use `defaults` | Must use `nodefaults` |
| Updates | Partial updates common | Full `update --all` |
| R packages | System library | User library via `R_LIBS_USER` |
| Root in container | Optional | No (runs as user) |

---

## Best Practices

### Build Strategy

1. Test config with conda first: `coble-bash.sh`
2. Build locally before deploying to HPC
3. Verify image works on test node
4. Document variant purpose and use cases
5. Keep separate `.def` files per variant

### Performance

- Use mamba solver for large environments (100+ packages)
- Build on node with good internet connection
- Use local package cache if building multiple variants
- Build during off-peak hours for shared systems

### Storage

- Store images in project/scratch space (not home)
- Use descriptive names: `coble-452-2024-11.sif`
- Keep build logs for debugging
- Document image locations in project README

### Version Control

- Commit `.def` files to git
- Tag releases that correspond to published analyses
- Keep config files synchronized with `.def` files
- Document changes in commit messages

---

## Additional Resources

- [Develop: Conda](develop-conda.md) - Base environment building
- [Develop: SLURM](develop-slurm.md) - Batch build jobs
- [Singularity Usage](singularity.md) - Using pre-built images
- [Singularity Documentation](https://sylabs.io/docs/)
- [Apptainer Documentation](https://apptainer.org/docs/)
