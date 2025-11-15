# Quick Start

This guide will help you get started with COBLE in minutes.

## Using Pre-built Images

The fastest way to start using COBLE:

=== "Singularity"

    ```bash
    # Pull the image
    singularity pull -F coble-452.sif docker://icrsc/coble:452
    
    # Open an interactive shell
    singularity shell coble-452.sif
    
    # The conda environment is automatically activated!
    python --version
    R --version
    ```

=== "Docker"

    ```bash
    # Pull and run interactively
    docker run --rm -it icrsc/coble:452
    
    # The conda environment is automatically activated!
    python --version
    R --version
    ```

## Building Your Own Environment

### Step 1: Create a Configuration File

Create a YAML file (e.g., `my-env.yml`) with your packages:

```yaml
name: my-environment
channels:
  - conda-forge
  - bioconda
  - defaults
dependencies:
  - python=3.14.0
  - r-base=4.5.2
  - numpy
  - pandas
  - r-ggplot2
  - pip:
    - requests
```

### Step 2: Build the Environment

```bash
bin/coble-bash.sh \
  --steps conda:create:export \
  --input ./my-env.yml \
  --results ./results/my-env \
  --r-version 4.5.2 \
  --python-version 3.14.0 \
  --env ./envs/my-env \
  --pkg ./pkgs/my-env
```

### Step 3: Review Outputs

Check the results directory:

```bash
ls -la results/my-env/
```

You'll find:  
- `coble.yml` - Combined environment specification  
- `built-conda.yml` - Conda export  
- `r_packages.txt` - R package list  
- `pip_packages.txt` - Python package list  
- `recipe.sh` - Reproducible installation script  

## Common Workflows

### Create and Export

Build an environment and export all package lists:  

```bash
bin/coble-bash.sh \
  --steps conda:create:export \
  --input ./config/coble-mini.yml \
  --results ./results/test \
  --r-version 4.5.2 \
  --python-version 3.14.0 \
  --env ./envs/test \
  --pkg ./pkgs/test
```

### Check for Errors

Analyze installation logs for errors:  

```bash
bin/coble-bash.sh \
  --steps errors \
  --results ./results/test \
  --output ./logs/output.log \
  --error ./logs/error.log
```

### Compare Environments

Compare two environments or package files:

```bash
bin/coble-bash.sh \
  --steps compare \
  --lhs-env ./envs/old \
  --rhs-env ./envs/new \
  --results ./results/comparison
```

## Next Steps

- [Full Command Reference](cli-reference.md)
- [Docker Usage Guide](docker.md)
- [Singularity Usage Guide](singularity.md)
