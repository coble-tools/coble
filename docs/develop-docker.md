# Develop: Docker Images

Guide for building COBLE Docker images via CI/CD and locally.

## Overview

Docker images are built automatically via GitHub Actions when you push tags. They can also be built locally for testing.

**Best for:** Production deployments, cloud environments, CI/CD pipelines, reproducible container distribution

---

## CI/CD Build Process

### Tag-Triggered Builds

Push a tag to trigger automatic Docker build:

```bash
# Set variant name
tag=mini

# Create and push tag
git tag docker-$tag
git push origin docker-$tag
```

This triggers GitHub Actions to:
1. Validate `config/coble-$tag.yml` exists
2. Build image using `docker/Dockerfile.452` with `BUILD_TAG=$tag`
3. Push to `icrsc/coble:$tag`
4. Also tag with commit SHA: `icrsc/coble:$tag-<sha>`

### Build All Variants

Build all standard variants at once:

```bash
git tag docker-all
git push origin docker-all
```

Currently builds: `452,mini`

To add variants to `docker-all`, edit `.github/workflows/docker-dynamic.yml`:

```yaml
env:
  IMAGE_REPO: icrsc/coble
  ALL_VARIANTS: 452,mini,tst,custom  # Add here
```

### Manual Dispatch

Trigger builds via GitHub UI:

1. Go to **Actions** → **Docker Build Dynamic**
2. Click **Run workflow**
3. Enter variant name (e.g., `tst`)
4. Click **Run workflow**

---

## Tag Management

### Delete and Recreate Tags

Rebuild by recreating tags:

```bash
tag=452

# Delete locally and remotely
git tag -d docker-$tag
git push origin :refs/tags/docker-$tag

# Recreate and push
git tag docker-$tag
git push origin docker-$tag
```

### List Docker Tags

```bash
git tag | grep docker-
```

---

## Local Docker Builds

### Test Before CI

Build locally before pushing tags:

```bash
# Set variant
tag=tst

# Build
docker build -f docker/Dockerfile.452 --build-arg BUILD_TAG=$tag -t icrsc/coble:$tag .

# Test interactively
docker run --rm -it icrsc/coble:$tag

# Verify inside container
echo $COBLE_VARIANT
conda env list
```

### Build Arguments

- `BUILD_TAG` - Variant name (mini, 452, tst, custom)
- `SOLVER` - Conda solver (conda or mamba)

```bash
# Use mamba for faster solve
docker build -f docker/Dockerfile.452 \
  --build-arg BUILD_TAG=452 \
  --build-arg SOLVER=mamba \
  -t icrsc/coble:452 .
```

---

## Adding New Docker Variants

### Prerequisites

1. Create config file: `config/coble-<variant>.yml`
2. Test locally with conda: `bash bin/coble-bash.sh --input config/coble-<variant>.yml ...`

### Deploy to CI/CD

```bash
# 1. Create and test config
cat > config/coble-custom.yml <<EOF
name: custom
channels:
  - conda-forge
  - bioconda
dependencies:
  - python=3.14.0
  - r-base=4.5.2
  - numpy
EOF

# 2. Test local Docker build
docker build -f docker/Dockerfile.452 --build-arg BUILD_TAG=custom -t icrsc/coble:custom .

# 3. Commit config
git add config/coble-custom.yml
git commit -m "Add custom variant config"
git push

# 4. Trigger CI build
git tag docker-custom
git push origin docker-custom
```

### Monitor Build

1. Go to **Actions** tab in GitHub
2. Click on the workflow run
3. Watch build logs in real-time
4. Download artifacts on failure

---

## CI/CD Configuration

### Required Secrets

Set in GitHub repository settings → Secrets:

- `DOCKER_HUB_USERNAME` - Your Docker Hub username
- `DOCKER_HUB_TOKEN` - Access token from https://hub.docker.com/settings/security

### Workflow Files

- `.github/workflows/docker-dynamic.yml` - Active tag-triggered builds
- `.github/workflows/docker.yml` - Legacy manual dispatch (452/mini only)

### Workflow Behavior

**On tag push `docker-<variant>`**:
- Checks out code
- Validates config file exists
- Builds with BuildKit cache
- Pushes to Docker Hub with two tags:
  - `icrsc/coble:<variant>` (latest for variant)
  - `icrsc/coble:<variant>-<sha>` (immutable snapshot)

---

## Troubleshooting

### Build Fails: Config Not Found

**Error**: `ERROR: config/coble-<variant>.yml not found`

**Solution**: Commit and push config file before creating docker tag

```bash
git add config/coble-custom.yml
git commit -m "Add custom config"
git push
# Now push tag
git tag docker-custom
git push origin docker-custom
```

### Build Hangs at Conda Solve

**Error**: Build times out or hangs at "Solving environment"

**Solutions**:
- Use `SOLVER=mamba` in Dockerfile
- Simplify package list in config
- Pin more specific versions
- Check for circular dependencies

### Push Permission Denied

**Error**: `denied: requested access to the resource is denied`

**Solutions**:
- Verify `DOCKER_HUB_TOKEN` is valid
- Check token has push permissions
- Confirm repository exists: `icrsc/coble`
- Regenerate token if expired

### Tag Already Exists

**Error**: Tag creation fails

**Solution**: Delete existing tag first:

```bash
git tag -d docker-mini
git push origin :refs/tags/docker-mini
git tag docker-mini
git push origin docker-mini
```

### Check Build Logs

Download artifacts from failed builds:

1. Go to **Actions** tab
2. Click failed workflow
3. Scroll to **Artifacts** section
4. Download `build-logs-<variant>`

---

## Image Tagging Strategy

Every successful build creates two tags:

### Latest Tag
`icrsc/coble:<variant>` - Moves to latest build of this variant

**Use for:** Development, testing, pulling latest features

```bash
docker pull icrsc/coble:452
```

### SHA Tag
`icrsc/coble:<variant>-<sha>` - Immutable, tied to commit

**Use for:** Production, reproducibility, rollback capability

```bash
docker pull icrsc/coble:452-a1b2c3d
```

---

## Best Practices

### Tag Naming

- Use lowercase: `docker-mini` not `docker-Mini`
- Be descriptive: `docker-analysis-core` not `docker-test1`
- Reserved: `docker-all` builds multiple variants

### Build Testing

1. Test conda build first: `coble-bash.sh`
2. Test Docker build locally
3. Push config and verify in repo
4. Push docker tag for CI build
5. Verify pushed image: `docker pull icrsc/coble:<variant>`

### Config Organization

- Keep variants focused (single purpose)
- Pin critical package versions
- Document package rationale in comments
- Test before pushing tags

### Version Control

- Always commit config before docker tag
- Use meaningful commit messages
- Tag Docker builds after successful local tests
- Consider creating GitHub releases for major versions

---

## Dockerfile Reference

### Build Stages

The `docker/Dockerfile.452` performs:

1. **Base setup** - FROM continuumio/miniconda3
2. **Conda update** - Update to latest conda
3. **System packages** - Install gcc, zlib, etc.
4. **Solver install** - Install mamba if SOLVER=mamba
5. **File copy** - Copy bin/ and config/
6. **Channel config** - Create .condarc with nodefaults
7. **Environment build** - Run coble-bash.sh
8. **Activation scripts** - For Docker and Singularity usage
9. **Cleanup** - Remove caches

### Environment Variables

Set in image:
- `COBLE_VARIANT` - Variant name (e.g., "452")
- `CONFIG_FILE` - Path to config in image
- `RESULTS_DIR` - Build results location
- `ENVS_DIR` - Conda environment path
- `PKGS_DIR` - Package cache path
- `CONDARC` - Conda config file

---

## Additional Resources

- [Develop: Conda](develop-conda.md) - Base environment building
- [Develop: Singularity](develop-singularity.md) - HPC container builds
- [Docker Usage](docker.md) - Using pre-built images
- [GitHub Actions Docs](https://docs.github.com/en/actions)
