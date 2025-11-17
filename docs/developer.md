# Developer Guide

This guide is for COBLE developers and maintainers who need to build Docker images, trigger CI/CD pipelines, and manage releases.

## CI/CD Docker Build Process

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

## Local Docker Build Testing

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

## Adding New Variants

### Step-by-Step Process

1. **Create configuration file** (`config/coble-<variant>.yml`)
2. **Test locally** using `coble-bash.sh`
3. **Build Docker image locally** to verify
4. **Commit config file**
5. **Push docker tag** to trigger CI build
6. **Update documentation** (add to available images list)

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

### Testing the Variant Locally

```bash
tag=<variant>

bash bin/coble-bash.sh \
  --steps "create,export,errors,missing" \
  --input "config/coble-$tag.yml" \
  --results "results/coble-$tag" \
  --r-version "4.5.2" \
  --python-version "3.14.0" \
  --env "./envs/coble-$tag" \
  --pkg "./pkgs/coble-$tag" \
  --output "results/coble-$tag.out" \
  --error "logs/coble-$tag.err"
```

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

- `.github/workflows/docker-dynamic.yml` - Dynamic variant builds (active)
- `.github/workflows/docs.yml` - Documentation deployment

### Legacy Workflows

- `.github/workflows/docker.yml` - Original 452/mini specific jobs (manual dispatch only)

## CI/CD Secrets

Required secrets in GitHub repository settings:

- `DOCKER_HUB_USERNAME` - Docker Hub username
- `DOCKER_HUB_TOKEN` - Docker Hub access token

Generate token at: https://hub.docker.com/settings/security

## Troubleshooting CI Builds

### Build Fails with "Config Not Found"

Error: `ERROR: config/coble-<variant>.yml not found`

**Solution**: Ensure the config file is committed and pushed before creating the docker tag.

### Build Hangs During Conda Solve

**Solution**: Consider using `SOLVER=mamba` build arg or simplifying the package list.

### Push Permission Denied

**Solution**: Verify `DOCKER_HUB_TOKEN` secret is valid and has push permissions.

### Check Build Logs

1. Go to **Actions** tab in GitHub
2. Click on the failed workflow run
3. Download debug artifacts (automatically uploaded on all builds)

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

## Release Workflow

For formal releases:

1. Update `COBLE_SCRIPT_VERSION` if scripts changed
2. Update documentation
3. Create GitHub Release with tag like `v1.0.0`
4. Optionally tag Docker images with release version

## Singularity Build Process

COBLE can also be built as Singularity/Apptainer images for HPC environments. Each variant has its own dedicated definition file with hardcoded settings.

### Available Definition Files

Three variant-specific definition files in `singularity/`:

- **`coble-mini.def`** - Minimal environment (conda solver)
- **`coble-452.def`** - Full 452+ packages (mamba solver)
- **`coble-tst.def`** - Experimental/test (conda solver)

Each file is self-contained with hardcoded:
- Config file path (`/app/config/coble-<variant>.yml`)
- Variant name (`COBLE_VARIANT=<variant>`)
- Solver choice (conda or mamba)
- Channel configuration (conda-forge, bioconda, dranew - no defaults)

### Building from Definition Files on HPC

#### Requirements

- Singularity/Apptainer installed (typically available as a module)
- Internet access to Docker Hub (for base image)
- Either:
  - Root/sudo access, OR
  - Fakeroot feature enabled (`singularity build --fakeroot`)
- Access to conda package channels during build

#### Build Commands

No build arguments needed - each variant is a separate file:

```bash
# Build mini variant (conda solver)
sudo singularity build singularity/coble-mini.sif singularity/coble-mini.def

# Build 452 variant (mamba solver, faster)
sudo singularity build singularity/coble-452.sif singularity/coble-452.def

# Build tst variant (conda solver)
sudo singularity build singularity/coble-tst.sif singularity/coble-tst.def
```

#### Using Fakeroot (no sudo required)

```bash
singularity build --fakeroot singularity/coble-452.sif singularity/coble-452.def
```

#### What Happens During Build

1. **Bootstrap**: Pulls `continuumio/miniconda3` from Docker Hub (no Docker daemon needed)
2. **Files copied**: `bin/` and `config/` directories copied into image at `/app/`
3. **Environment setup**: Conda updated fully, channels configured, base packages refreshed
4. **System packages**: Build tools (gcc, zlib, etc.) installed via apt
5. **Solver install**: Mamba installed for 452/tst variants (faster dependency resolution)
6. **Conda environment**: Created using `coble-bash.sh` with variant-specific config
7. **Activation scripts**: Created for both interactive and exec usage

### Using Pre-built Docker Images

If you have network access but cannot build on HPC, pull from Docker Hub:

```bash
# Pull and convert Docker image to Singularity
tag=452
singularity pull coble-$tag.sif docker://icrsc/coble:$tag

# Test it
singularity shell coble-$tag.sif
```

This is simpler but requires the Docker image to exist on Docker Hub (built via CI/CD).

### Testing the Built Image

```bash
# Interactive shell (environment auto-activates)
singularity shell coble-452.sif

# Inside container
Singularity> echo $COBLE_VARIANT
452
Singularity> conda env list
Singularity> exit

# Execute command with environment
singularity exec coble-452.sif bash -c "source /app/activate_conda.sh && python --version"

# Check for specific packages
singularity exec coble-452.sif bash -c "source /app/activate_conda.sh && conda list | grep numpy"
```

### Offline/Air-gapped HPC Environments

If your HPC has no internet access:

1. **Build on a machine with internet** (your workstation):
   ```bash
   sudo singularity build coble-452.sif singularity/coble-452.def
   ```

2. **Transfer to HPC**:
   ```bash
   scp coble-452.sif user@hpc:/path/to/destination/
   ```

3. **Use on HPC** (no build required):
   ```bash
   singularity shell coble-452.sif
   ```

### Build on SLURM Cluster

For long builds, submit as a batch job:

```bash
#!/bin/bash
#SBATCH --job-name=coble-build-452
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --output=logs/coble-build-%j.out
#SBATCH --error=logs/coble-build-%j.err

module load singularity || true
mkdir -p logs singularity

# Choose the variant to build:
sudo singularity build singularity/coble-452.sif singularity/coble-452.def
# singularity build --fakeroot singularity/coble-452.sif singularity/coble-452.def

# Or build a different variant:
# sudo singularity build singularity/coble-mini.sif singularity/coble-mini.def
# sudo singularity build singularity/coble-tst.sif singularity/coble-tst.def
```

Submit with: `sbatch build_coble.sh`

### Adding a New Singularity Variant

To add a new variant (e.g., `custom`):

1. **Create config file**: `config/coble-custom.yml`
2. **Copy and modify definition file**:
   ```bash
   cp singularity/coble-mini.def singularity/coble-custom.def
   ```
3. **Update hardcoded values** in the new `.def` file:
   - Labels: `org.opencontainers.image.version custom`
   - Environment: `COBLE_VARIANT=custom`, `CONFIG_FILE=/app/config/coble-custom.yml`
   - Post section: Update echo messages and `coble-bash.sh` parameters
   - Help section: Update variant name and examples
4. **Choose solver**: Keep `conda` for small envs, use `mamba` for large ones
5. **Build and test**:
   ```bash
   sudo singularity build singularity/coble-custom.sif singularity/coble-custom.def
   ```

### Comparing Docker vs Singularity Workflow

| Approach | Where to Build | Requirements | Use Case |
|----------|---------------|--------------|----------|
| **Docker image** → pull to Singularity | Local + CI/CD | Docker Hub access on HPC | Standard workflow, reproducible |
| **Singularity .def** on HPC | HPC with internet | Fakeroot or sudo, internet | Custom builds, no Docker Hub |
| **Singularity .def** local → transfer | Local workstation | Singularity installed locally | Air-gapped HPC |

### Troubleshooting Singularity Builds

#### Error: "could not create user namespace"

**Solution**: Use `--fakeroot` flag or request admin to enable user namespaces.

#### Error: "failed to pull docker image"

**Solution**: Check internet connectivity and Docker Hub accessibility:
```bash
curl -I https://hub.docker.com/
```

#### Build Hangs at Conda Solve

**Solution**: Use `SOLVER=mamba` or reduce package list complexity in config.

#### Permission Denied Writing to /app

**Solution**: This is expected during `%post`; ensure you're using `sudo` or `--fakeroot`.

### Definition File Structure

The `.def` file mirrors the Dockerfile with these sections:

- `%labels` - Image metadata (version, title, description, source, license)
- `%files` - Copy local files into container (bin/, config/)
- `%environment` - Environment variables exported at runtime
- `%post` - Build steps (runs as root during build):
  - Conda update and solver installation
  - System package installation (gcc, zlib, etc.)
  - Channel configuration (nodefaults to exclude anaconda.com repos)
  - Environment creation via `coble-bash.sh`
  - Activation script creation
- `%runscript` - Default behavior when running image
- `%startscript` - Behavior for `singularity instance start`
- `%help` - Documentation displayed with `singularity run-help`

**Key differences from Docker**:
- No build arguments (each variant is a separate file)
- `nodefaults` in channels to exclude Anaconda default repos
- Full conda update (`conda update --all`) to prevent upgrade prompts

## Additional Resources

- [Build Notes](build-notes.md) - Detailed build process
- [Developer Notes](dev-notes.md) - Development environment setup
- [Docker Usage](docker.md) - Using pre-built images
- [Singularity Usage](singularity.md) - HPC usage guide
- [CLI Reference](cli-reference.md) - Command-line options

## Questions?

See the GitHub repository issues or contact the RSE team at ICR.
