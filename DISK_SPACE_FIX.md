# Fixing "No Space Left on Device" Error in GitHub Actions

## Problem
Docker builds on GitHub Actions runners can fail with "no space left on device" errors because:
- GitHub Actions runners have limited disk space (typically 14GB available)
- Large bioinformatics environments with many packages can exceed this limit
- Docker layer caching and build artifacts accumulate during the build

## Solutions Implemented

### 1. **Workflow Optimization** (`.github/workflows/docker-manual-dual.yml`)
Added the following steps:

#### Free Up Disk Space Before Build
```bash
- Removes unnecessary tools: /usr/local/lib/android, /usr/share/dotnet, /opt/ghc, etc.
- Cleans apt cache
- Prunes Docker system to remove unused images/volumes
```

#### Enable Docker BuildKit
```bash
DOCKER_BUILDKIT: 1
```
BuildKit provides better layer caching and can improve space efficiency.

#### Monitor Disk Space
Added steps to report disk usage before/after build for debugging.

#### Post-Build Cleanup
Removes Docker artifacts and tar files after the push.

### 2. **Dockerfile Optimization** (`code/coble.Dockerfile`)
Enhanced cleanup steps:

#### More Aggressive Cache Cleaning
```dockerfile
# After conda operations
conda clean -afy
rm -rf /opt/conda/pkgs/*
rm -rf /root/.cache/pip/*
```

#### apt Cache Cleanup
```dockerfile
rm -rf /var/lib/apt/lists/*
rm -rf /var/cache/apt/*
apt-get clean
```

## Additional Recommendations

### For Very Large Builds
Consider these additional strategies:

1. **Multi-stage Builds**
   - Split build environment from runtime
   - Only copy artifacts needed to final stage
   - Dramatically reduces final image size

2. **Build in Stages**
   - Don't build both amd64 and arm64 in parallel on the same runner
   - Current workflow builds them separately (which is good)

3. **Recipe Optimization**
   - Review `bcrds.cbl` recipe for unnecessary packages
   - Consider using `mamba` instead of `conda` (faster, uses less disk)
   - Consolidate RUN instructions to reduce layers

4. **Increase Runner Resources**
   ```yaml
   # In docker-manual-dual.yml, consider larger runners:
   runs-on: ubuntu-latest-8core  # More CPU and disk
   ```

5. **Use BuildKit Advanced Features**
   ```dockerfile
   # Set BuildKit cache mode
   RUN --mount=type=cache,target=/root/.cache/pip pip install ...
   RUN --mount=type=type=cache,target=/opt/conda/pkgs conda install ...
   ```

6. **Stream Logs Instead of Storing**
   ```bash
   # In coble script, avoid capturing large build outputs
   docker buildx build ... --progress=plain 2>&1 | tail -100
   ```

## Testing the Fix

After updating both files, trigger the workflow:

1. Go to GitHub Actions
2. Select "Dual Arch Docker Image (Manual)"
3. Click "Run workflow"
4. Check the logs for:
   - Disk space before/after cleanup
   - Build success
   - Docker system df output

## If Issues Persist

1. **Check what's using disk:**
   ```bash
   docker system df  # Shows Docker resource usage
   ```

2. **Review recipe for bloat:**
   - Look for large downloads/caches in bcrds.cbl
   - Check if all packages are necessary
   - Consider using conda-pack for minimal environments

3. **Enable verbose logging:**
   ```bash
   export BUILDKIT_PROGRESS=plain  # More detailed output
   export DOCKER_BUILDKIT=1
   ```

4. **Use a self-hosted runner** with larger disk if available

## References
- [GitHub Actions Runner Specs](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners)
- [Docker BuildKit Documentation](https://docs.docker.com/build/buildkit/)
- [Docker Build Best Practices](https://docs.docker.com/develop/dev-best-practices/#containerizing-an-application)
