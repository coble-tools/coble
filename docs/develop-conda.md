# Develop: Conda Environments

Guide for building and managing COBLE conda environments directly.

## Overview

Build conda environments locally or on HPC using `coble-bash.sh`. This is the foundational method - Docker and Singularity builds use this same script internally.

**Best for:** Local development, testing new package combinations, understanding dependencies

---

## Direct Environment Creation

### Basic Build

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

### Script Parameters

- `--steps` - Comma-separated build stages:
  - `create` - Create conda environment
  - `export` - Export environment spec
  - `errors` - Check for dependency conflicts
  - `missing` - Report missing packages
  - `compare` - Compare to reference environment
- `--input` - Config file path (`config/coble-<variant>.yml`)
- `--results` - Output directory for build artifacts
- `--r-version` - R version to use (e.g., "4.5.2")
- `--python-version` - Python version (e.g., "3.14.0")
- `--env` - Environment installation directory
- `--pkg` - Package cache directory
- `--quiet` - Suppress conda output (y/n)
- `--divert` - Redirect output to files (y/n)

### Check Script Version

```bash
bash bin/coble-bash.sh --version
```

---

## Configuration Files

### File Location

Config files live in `config/coble-<variant>.yml`

Available variants:
- `coble-mini.yml` - Minimal environment
- `coble-452.yml` - Full 452+ package environment
- `coble-tst.yml` - Test/experimental packages

### Configuration Template

```yaml
name: <variant>
channels:
  - conda-forge
  - bioconda
  - https://conda.anaconda.org/dranew
  - nodefaults  # Exclude anaconda.com repos
dependencies:
  - python=3.14.0
  - r-base=4.5.2
  # Add conda packages here
  - numpy
  - pandas
  - pip:
    # Add pip packages here
    - scikit-learn
```

### Best Practices

- **Pin critical versions** - Specify exact versions for reproducibility
- **Use nodefaults** - Exclude Anaconda commercial repos
- **Group by purpose** - Organize packages with comments
- **Test incrementally** - Add packages in batches, test between additions
- **Document rationale** - Explain why packages are included

---

## Adding New Variants

### Step-by-Step

1. **Create config file**:
   ```bash
   cp config/coble-mini.yml config/coble-custom.yml
   ```

2. **Edit configuration**:
   - Update `name: custom`
   - Add/remove packages as needed
   - Pin versions for key dependencies

3. **Test build locally**:
   ```bash
   bash bin/coble-bash.sh \
     --steps "create,export,errors" \
     --input "config/coble-custom.yml" \
     --results "results/coble-custom" \
     --r-version "4.5.2" \
     --python-version "3.14.0" \
     --env "./envs/coble-custom" \
     --pkg "./pkgs/coble-custom"
   ```

4. **Check for issues**:
   ```bash
   # Review error log
   cat results/coble-custom/errors.log
   
   # Check missing packages
   cat results/coble-custom/missing.txt
   ```

5. **Commit and document**:
   ```bash
   git add config/coble-custom.yml
   git commit -m "Add custom variant for X analysis"
   ```

---

## Troubleshooting

### Dependency Conflicts

**Symptom**: Build fails with "conflicting requirements" or "unsatisfiable"

**Solutions**:
- Relax version constraints in config
- Remove conflicting packages
- Try different channel priority order
- Use `mamba` solver (faster, better conflict resolution)

### Missing Packages

**Symptom**: Packages not found during install

**Solutions**:
- Check package name spelling
- Verify package exists in specified channels
- Try alternative channels (conda-forge, bioconda)
- Check if package requires pip instead

### Build Too Slow

**Symptom**: Conda hangs at "Solving environment"

**Solutions**:
- Use `mamba` instead of `conda` (add to `--steps`: `mamba:create`)
- Reduce number of packages
- Pin more specific versions to constrain solver
- Split into smaller environments

### Environment Activation Issues

**Symptom**: "conda activate" fails

**Solutions**:
```bash
# Initialize conda for your shell
conda init bash
source ~/.bashrc

# Or manually activate
source /path/to/conda/bin/activate /path/to/envs/coble-mini
```

---

## Script Versioning

The `coble-bash.sh` script has a hardcoded version:

```bash
COBLE_SCRIPT_VERSION="0.1.0"
```

When making changes:
1. Update version in `bin/coble-bash.sh`
2. Document changes in commit message
3. Consider creating GitHub release for major changes

---

## Advanced Usage

### Using Mamba Solver

Mamba is much faster for large environments:

```bash
bash bin/coble-bash.sh \
  --steps "mamba:create,export,errors,missing" \
  --input "config/coble-452.yml" \
  ...
```

### Comparing Environments

Check differences between builds:

```bash
bash bin/coble-bash.sh \
  --steps "compare" \
  --input "config/coble-mini.yml" \
  --results "results/coble-mini-new" \
  --env "./envs/coble-mini-new"
```

### Custom Package Cache

Share package cache across builds:

```bash
export CONDA_PKGS_DIRS=/shared/conda-cache
bash bin/coble-bash.sh --pkg "/shared/conda-cache" ...
```

---

## Additional Resources

- [Configuration Guide](config.md) - Detailed config file documentation
- [Develop: Docker](develop-docker.md) - Build Docker containers
- [Develop: Singularity](develop-singularity.md) - Build Singularity images
- [Develop: SLURM](develop-slurm.md) - Batch job submission
- [CLI Reference](cli-reference.md) - All command options
