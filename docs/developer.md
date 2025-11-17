# Developer Guide

This guide is for COBLE developers and maintainers who need to build environments and manage releases.

## Overview: Building COBLE Environments

COBLE environments can be built using three approaches:

1. **Conda (Local)** - Direct conda environment creation using `coble-bash.sh`
2. **Docker** - Containerized builds, automated via CI/CD
3. **Singularity** - HPC-optimized containers, can be built locally or via SLURM

| Method | Best For | Build Location | CI/CD Support | SLURM Support |
|--------|----------|----------------|---------------|---------------|
| **Conda** | Local development, testing | Local machine | ❌ | ✅ `coble-slurm.sh` |
| **Docker** | Production, cloud deployment | GitHub Actions + Local | ✅ Tag-triggered | ❌ |
| **Singularity** | HPC clusters, air-gapped systems | HPC or local | ❌ | ✅ `coble-slurm-sing.sh` |

---

## 1. Building with Conda (Local)

### Direct Environment Creation

Use `coble-bash.sh` to create conda environments directly on your local machine or HPC:

```bash
bash bin/coble-bash.sh \
  --steps "create,export,errors,missing" \
  --input "config/coble-mini.yml" \
  --results "results/coble-mini" \
  --r-version "4.5.2" \
  --python-version "3.14.0" \
  --env "./envs/coble-mini" \
  --pkg "./pkgs/coble-mini"
```

### SLURM Batch Job for Conda Builds

Use the provided SLURM wrapper to build environments on HPC clusters:

```bash
# Submit conda environment build job
sbatch bin/coble-slurm.sh \
  --steps "create,export,errors,missing" \
  --input "config/coble-452.yml" \
  --results "results/coble-452" \
  --env "./envs/coble-452"
```

The `coble-slurm.sh` script:
- Exports SLURM diagnostics (job ID, nodes, resources)
- Passes all arguments to `coble-bash.sh`
- Creates timestamped log files
- Default resources: 4 tasks, 10-hour timeout

---

## 2. Building with Docker

COBLE uses GitHub Actions to automatically build and push Docker images when specific tags are pushed to the repository.

### Dynamic Variant Builds

The workflow `.github/workflows/docker-dynamic.yml` builds Docker images for any environment variant based on tag naming conventions.

#### Building a Single Variant

To build a specific variant (e.g., `mini`, `452`, `tst`):

1. **Ensure config file exists**: `config/coble-<variant>.yml` must be present
2. **Tag and push**:

```bash
# Set the variant name
tag=mini

# Create and push the docker tag
git tag docker-$tag
git push origin docker-$tag
```

This triggers a build that:
- Builds the image using `docker/Dockerfile.452` with `BUILD_TAG=<variant>`
- Pushes to `icrsc/coble:<variant>`
- Also tags with commit SHA: `icrsc/coble:<variant>-<sha>`

#### Example: Building a New Test Variant

```bash
# 1. Create config file
cat > config/coble-tst.yml <<EOF
name: tst
channels:
  - conda-forge
  - bioconda
dependencies:
  - python=3.14.0
  - r-base=4.5.2
  - numpy
  - pandas
EOF

# 2. Commit the config
git add config/coble-tst.yml
git commit -m "Add test variant config"
git push

# 3. Trigger Docker build
git tag docker-tst
git push origin docker-tst
```

The CI will automatically:
1. Check that `config/coble-tst.yml` exists
2. Build the image with `BUILD_TAG=tst`
3. Push `icrsc/coble:tst` and `icrsc/coble:tst-<sha>` to Docker Hub

#### Building All Standard Variants

To build all predefined variants at once:

```bash
git tag docker-all
git push origin docker-all
```

This builds all variants listed in the workflow's `ALL_VARIANTS` environment variable (currently: `452,mini`).

To add more variants to `docker-all`, edit `.github/workflows/docker-dynamic.yml`:

```yaml
env:
  IMAGE_REPO: icrsc/coble
  ALL_VARIANTS: 452,mini,tst,custom  # Add your variant here
```

### Manual Dispatch

You can also trigger builds manually from the GitHub Actions UI:

1. Go to **Actions** → **Docker Build Dynamic**
2. Click **Run workflow**
3. Enter the variant name (e.g., `tst`)
4. Click **Run workflow**

### Tag Management

#### Deleting and Recreating Tags

If you need to rebuild:

```bash
# Set variant
tag=452

# Delete tag locally and remotely
git tag -d docker-$tag
git push origin :refs/tags/docker-$tag

# Create and push new tag
git tag docker-$tag
git push origin docker-$tag
```

#### List All Docker Tags

```bash
git tag | grep docker-
```

### Local Docker Build Testing

Before pushing tags, test builds locally:

```bash
# Set your variant
tag=tst

# Build locally
docker build -f docker/Dockerfile.452 --build-arg BUILD_TAG=$tag -t icrsc/coble:$tag .

# Test the image
docker run --rm -it icrsc/coble:$tag

# Inside container, verify
echo $COBLE_VARIANT
```

### Docker Troubleshooting

#### Build Fails with "Config Not Found"

Error: `ERROR: config/coble-<variant>.yml not found`

**Solution**: Ensure the config file is committed and pushed before creating the docker tag.

#### Build Hangs During Conda Solve

**Solution**: Consider using `SOLVER=mamba` build arg or simplifying the package list.

#### Push Permission Denied

**Solution**: Verify `DOCKER_HUB_TOKEN` secret is valid and has push permissions.

#### Check Build Logs

1. Go to **Actions** tab in GitHub
2. Click on the failed workflow run
3. Download debug artifacts (automatically uploaded on all builds)

---

## 3. Building with Singularity

COBLE can be built as Singularity/Apptainer images for HPC environments. Each variant has its own dedicated definition file.

### Available Definition Files

Three variant-specific definition files in `singularity/`:

- **`coble-mini.def`** - Minimal environment (conda solver)
- **`coble-452.def`** - Full 452+ packages (mamba solver)
- **`coble-tst.def`** - Experimental/test (conda solver)

Each file is self-contained with hardcoded:
- Config file path (`/app/config/coble-<variant>.yml`)
- Variant name (`COBLE_VARIANT=<variant>`)
- Solver choice (conda or mamba)
- Channel configuration (conda-forge, bioconda, dranew - no anaconda defaults)
- User R library path (`R_LIBS_USER=~/R/coble-<variant>-library`)

### Local Singularity Build

Build directly on your workstation or HPC:

```bash
# Build mini variant (conda solver)
sudo singularity build singularity/coble-mini.sif singularity/coble-mini.def

# Build 452 variant (mamba solver, faster)
sudo singularity build singularity/coble-452.sif singularity/coble-452.def

# Or use fakeroot (no sudo required if supported)
singularity build --fakeroot singularity/coble-452.sif singularity/coble-452.def
```

### SLURM Batch Job for Singularity Builds

Use the provided SLURM script for long-running builds:

```bash
# Build 452 variant on SLURM cluster
sbatch bin/coble-slurm-sing.sh 452

# Build mini variant
sbatch bin/coble-slurm-sing.sh mini

# Build tst variant
sbatch bin/coble-slurm-sing.sh tst
```

The `coble-slurm-sing.sh` script:
- Validates definition and config files
- Exports SLURM diagnostics
- Attempts fakeroot build (no sudo needed)
- Creates output in `singularity/coble-<variant>.sif`
- Shows image info and size on completion
- Default resources: 4 CPUs, 16GB RAM, 4-hour timeout

Monitor build progress:
```bash
tail -f logs/coble-sing-build-<jobid>.out
```

### Pull Pre-built from Docker Hub

Alternative to building - convert existing Docker images:

```bash
singularity pull coble-452.sif docker://icrsc/coble:452
singularity shell coble-452.sif
```

### Offline/Air-gapped Environments

Build on internet-connected machine, then transfer:

```bash
# On workstation with internet
sudo singularity build coble-452.sif singularity/coble-452.def

# Transfer to HPC
scp coble-452.sif user@hpc:/path/to/destination/

# Use on HPC (no rebuild needed)
singularity shell coble-452.sif
```

### Singularity Troubleshooting

#### Error: "could not create user namespace"

**Solution**: Use `--fakeroot` flag or request admin to enable user namespaces.

#### Error: "failed to pull docker image"

**Solution**: Check internet connectivity:
```bash
curl -I https://hub.docker.com/
```

#### Build Hangs at Conda Solve

**Solution**: Use 452/tst variants (mamba) or reduce package list complexity.

#### Permission Denied Writing to /app

**Solution**: Expected during `%post`; ensure using `sudo` or `--fakeroot`.

#### R Library Not Writable

**Solution**: R packages install to `~/R/coble-<variant>-library` (set via `R_LIBS_USER` environment variable). Directory created automatically on first use.

---

## Adding New Variants

### Step-by-Step Process

1. **Create configuration file** (`config/coble-<variant>.yml`)
2. **Test locally** using `coble-bash.sh` (conda method)
3. **Build containers** (optional):
   - Docker: Push tag to trigger CI
   - Singularity: Create `.def` file and build
4. **Commit all files** (config, definition files if applicable)
5. **Update documentation**

### Configuration File Template

```yaml
name: <variant>
channels:
  - conda-forge
  - bioconda
  - defaults
dependencies:
  - python=3.14.0
  - r-base=4.5.2
  # Add conda packages here
  - pip:
    # Add pip packages here
```

### For Singularity: Adding a New Variant

To add a new Singularity variant (e.g., `custom`):

1. **Create config file**: `config/coble-custom.yml`
2. **Copy and modify definition file**:
   ```bash
   cp singularity/coble-mini.def singularity/coble-custom.def
   ```
3. **Update hardcoded values** in the new `.def` file:
   - Labels: `org.opencontainers.image.version custom`
   - Environment: `COBLE_VARIANT=custom`, `CONFIG_FILE=/app/config/coble-custom.yml`, `R_LIBS_USER=~/R/coble-custom-library`
   - Post section: Update echo messages and `coble-bash.sh` parameters
   - Help section: Update variant name and examples
4. **Choose solver**: Keep `conda` for small envs, use `mamba` for large ones
5. **Build and test**:
   ```bash
   sudo singularity build singularity/coble-custom.sif singularity/coble-custom.def
   ```

---

## Script Versioning

The `coble-bash.sh` script has a hardcoded version string:

```bash
COBLE_SCRIPT_VERSION="0.1.0"
```

When making significant changes to the script:

1. Update the version in `bin/coble-bash.sh`
2. Document changes in commit message
3. Consider creating a GitHub release

Check the script version:

```bash
bash bin/coble-bash.sh --version
```

## Workflow Files

### Active Workflows

- `.github/workflows/docker-dynamic.yml` - Dynamic Docker variant builds (tag-triggered)
- `.github/workflows/docs.yml` - Documentation deployment

### Legacy Workflows

- `.github/workflows/docker.yml` - Original 452/mini Docker jobs (manual dispatch only)

### SLURM Scripts

- `bin/coble-slurm.sh` - Conda environment builds on SLURM
- `bin/coble-slurm-sing.sh` - Singularity image builds on SLURM

## CI/CD Secrets

Required secrets in GitHub repository settings (Docker builds only):

- `DOCKER_HUB_USERNAME` - Docker Hub username
- `DOCKER_HUB_TOKEN` - Docker Hub access token

Generate token at: https://hub.docker.com/settings/security

## Best Practices

### Commit Messages

Use clear commit messages for config/variant additions:

```bash
git commit -m "Add tst variant with minimal bioinformatics packages"
```

### Tag Naming

- Use lowercase for consistency: `docker-mini`, not `docker-Mini`
- Use descriptive names: `docker-bioinfo-core`, `docker-analysis`
- Reserved tag: `docker-all` builds multiple variants

### Config File Organization

- Keep variants focused (don't mix unrelated packages)
- Pin critical package versions
- Document purpose in config comments
- Test locally before pushing

### Image Tagging Strategy

Every build creates two tags:
- `icrsc/coble:<variant>` - Latest for this variant
- `icrsc/coble:<variant>-<sha>` - Immutable snapshot

Use SHA tags for reproducibility in production.

### Singularity Definition File Structure

The `.def` file structure:

- `%labels` - Image metadata (version, title, description, source, license)
- `%files` - Copy local files into container (bin/, config/)
- `%environment` - Runtime environment variables:
  - `COBLE_VARIANT`, `CONFIG_FILE`, result/env/pkg paths
  - `R_LIBS_USER` for writable R package installation
- `%post` - Build steps (runs as root):
  - Conda full update (`conda update --all`)
  - System packages (gcc, zlib, etc.)
  - Channel configuration (`nodefaults` to exclude anaconda.com)
  - Environment creation via `coble-bash.sh`
  - Activation scripts for shell/exec usage
- `%runscript` - Default behavior when running image
- `%startscript` - Behavior for `singularity instance start`
- `%help` - Documentation displayed with `singularity run-help`

**Key differences from Docker**:
- No build arguments (each variant is a separate file)
- `nodefaults` in channels to exclude Anaconda default repos
- Full conda update to prevent upgrade prompts
- `R_LIBS_USER` for writable user package installation

---

## Release Workflow

For formal releases:

1. Update `COBLE_SCRIPT_VERSION` if scripts changed
2. Update documentation
3. Create GitHub Release with tag like `v1.0.0`
4. Optionally tag Docker images with release version

## Additional Resources

- [Build Notes](build-notes.md) - Detailed build process
- [Developer Notes](dev-notes.md) - Development environment setup
- [Docker Usage](docker.md) - Using pre-built images
- [Singularity Usage](singularity.md) - HPC usage guide
- [CLI Reference](cli-reference.md) - Command-line options

## Questions?

See the GitHub repository issues or contact the RSE team at ICR.
