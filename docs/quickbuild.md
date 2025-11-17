# Quick Build

Get started building COBLE environments in minutes. This guide shows you how to clone the repository and build a test environment using either Conda or Singularity.

## Prerequisites

Choose your build method:

=== "Conda"
    - Conda or Miniconda installed
    - 4GB disk space
    - 15-30 minutes build time

=== "SLURM Conda"
    - Access to HPC cluster with SLURM
    - Conda or Miniconda installed
    - 4GB disk space
    - 15-30 minutes build time (plus queue wait)

=== "Singularity"
    - Singularity/Apptainer 3.8+
    - 2GB disk space
    - 30-60 minutes build time
    - Fakeroot support or sudo access

=== "SLURM Singularity"
    - Access to HPC cluster with SLURM
    - Singularity/Apptainer 3.8+ module available
    - 2GB disk space
    - 30-60 minutes build time (plus queue wait)
    - Fakeroot support (no sudo needed)

---

## Step 1: Clone Repository

```bash
# Clone the repository
git clone https://github.com/ICR-RSE-Group/coble.git
cd coble

# Check available configs
ls config/
```

You'll see:
- `coble-mini.yml` - Minimal test environment (~15 packages)
- `coble-452.yml` - Full production environment (452+ packages)
- `coble-tst.yml` - Test environment for experiments

---

## Step 2: Build Test Environment

=== "Conda Build"

    Build directly with conda (fastest for testing):

    ```bash
    # Create test environment
    bash bin/coble-bash.sh \
      --steps "create,export,errors" \
      --input "config/coble-tst.yml" \
      --results "results/coble-tst" \
      --r-version "4.5.2" \
      --python-version "3.14.0" \
      --env "./envs/coble-tst" \
      --pkg "./pkgs/coble-tst"
    ```

    **What this does:**
    - `create` - Builds the conda environment
    - `export` - Exports package lists
    - `errors` - Checks for installation errors

    **Build time:** 15-30 minutes

=== "SLURM Conda"

    Submit conda build as SLURM batch job:

    ```bash
    # Create logs directory
    mkdir -p logs
    
    # Submit batch job
    sbatch bin/coble-slurm.sh \
      --steps "create,export,errors" \
      --input "config/coble-tst.yml" \
      --results "results/coble-tst" \
      --r-version "4.5.2" \
      --python-version "3.14.0" \
      --env "./envs/coble-tst" \
      --pkg "./pkgs/coble-tst"
    
    # Monitor progress
    tail -f logs/coble-<jobid>.out
    ```

    **What this does:**
    - Submits as SLURM batch job
    - Allocates 4 CPUs, 10-hour time limit
    - Logs to `logs/coble-<jobid>.out/err`

    **Build time:** 15-30 minutes (plus queue wait)

=== "Singularity Build"

    Build Singularity container (best for HPC):

    ```bash
    # Build with fakeroot (no sudo needed)
    singularity build --force --fakeroot \
      singularity/coble-tst.sif \
      singularity/coble-tst.def
        
    ```

    **What this does:**
    - Bootstraps from miniconda3 Docker image
    - Runs conda environment build inside container
    - Creates `.sif` image file

    **Build time:** 30-60 minutes

=== "SLURM Singularity"

    Submit Singularity build as SLURM batch job:

    ```bash
    # Create logs directory
    mkdir -p logs
    
    # Submit batch job
    sbatch bin/coble-slurm-sing.sh tst
    
    # Check job status
    squeue -u $USER
    
    # Monitor progress
    tail -f logs/coble-sing-build-<jobid>.out
    ```

    **What this does:**
    - Submits as SLURM batch job
    - Allocates 4 CPUs, 16GB RAM, 4-hour time limit
    - Logs to `logs/coble-sing-build-<jobid>.out/err`
    - Uses fakeroot (no sudo needed)

    **Build time:** 30-60 minutes (plus queue wait)

---

## Step 3: Verify Build

=== "Conda Environment"

    ```bash
    # Activate environment
    conda activate ./envs/coble-tst
    
    # Check Python
    python --version
    # Expected: Python 3.14.0
    
    # Check R
    R --version
    # Expected: R version 4.5.2
    
    # List installed packages
    conda list | head -20
    
    # Check R packages
    Rscript -e "installed.packages()[,c('Package', 'Version')]" | head -20
    
    # Review build outputs
    ls -lh results/coble-tst/
    ```

    **Expected outputs in `results/coble-tst/`:**
    - `coble.yml` - Combined environment spec
    - `built-conda.yml` - Conda package export
    - `r_packages.txt` - R package list
    - `pip_packages.txt` - Python package list
    - `errors.log` - Installation errors (should be empty)

=== "SLURM Conda"

    ```bash
    # Check job completion
    squeue -u $USER
    
    # Review job output
    cat logs/coble-<jobid>.out
    
    # Check for errors
    cat logs/coble-<jobid>.err
    
    # Once complete, activate and verify
    conda activate ./envs/coble-tst
    python --version  # Python 3.14.0
    R --version       # R 4.5.2
    
    # Review build outputs
    ls -lh results/coble-tst/
    ```

    **Expected outputs in `results/coble-tst/`:**
    - `coble.yml` - Combined environment spec
    - `built-conda.yml` - Conda package export
    - `r_packages.txt` - R package list
    - `pip_packages.txt` - Python package list
    - `errors.log` - Installation errors (should be empty)

=== "Singularity Image"

    ```bash
    # Check image exists
    ls -lh singularity/coble-tst.sif
    
    # View image info
    singularity inspect singularity/coble-tst.sif
    
    # Open interactive shell
    singularity shell singularity/coble-tst.sif
    
    # Inside container:
    python --version   # Python 3.14.0
    R --version        # R 4.5.2
    conda list | head
    
    # Exit container
    exit
    
    # Run single command
    singularity exec singularity/coble-tst.sif python -c "import sys; print(sys.version)"
    ```

    **Image size:** ~1-2GB (compressed)

=== "SLURM Singularity"

    ```bash
    # Check job completion
    squeue -u $USER
    
    # Review job output
    tail -50 logs/coble-sing-build-<jobid>.out
    
    # Check for errors
    cat logs/coble-sing-build-<jobid>.err
    
    # Once complete, check image
    ls -lh singularity/coble-tst.sif
    
    # View image info
    singularity inspect singularity/coble-tst.sif
    
    # Test in interactive shell
    singularity shell singularity/coble-tst.sif
    python --version   # Python 3.14.0
    R --version        # R 4.5.2
    exit
    ```

    **Image size:** ~1-2GB (compressed)

---

## Step 4: Test Your Build

=== "Conda Test"

    Run a simple analysis to verify everything works:

    ```bash
    # Activate environment
    conda activate ./envs/coble-tst
    
    # Test Python packages
    python -c "
    import numpy as np
    import pandas as pd
    print('NumPy version:', np.__version__)
    print('Pandas version:', pd.__version__)
    print('✓ Python packages working!')
    "
    
    # Test R packages
    Rscript -e "
    library(data.table)
    library(ggplot2)
    cat('✓ R packages working!\n')
    "
    
    # Deactivate
    conda deactivate
    ```

=== "SLURM Conda"

    Run a simple analysis to verify everything works:

    ```bash
    # Activate environment
    conda activate ./envs/coble-tst
    
    # Test Python packages
    python -c "
    import numpy as np
    import pandas as pd
    print('NumPy version:', np.__version__)
    print('Pandas version:', pd.__version__)
    print('✓ Python packages working!')
    "
    
    # Test R packages
    Rscript -e "
    library(data.table)
    library(ggplot2)
    cat('✓ R packages working!\n')
    "
    
    # Deactivate
    conda deactivate
    ```

=== "Singularity Test"

    ```bash
    # Test Python inside container
    singularity exec singularity/coble-tst.sif python -c "
    import numpy as np
    import pandas as pd
    print('NumPy version:', np.__version__)
    print('Pandas version:', pd.__version__)
    print('✓ Python packages working!')
    "
    
    # Test R inside container
    singularity exec singularity/coble-tst.sif Rscript -e "
    library(data.table)
    library(ggplot2)
    cat('✓ R packages working!\n')
    "
    
    # Test with bind mount (access local files)
    singularity exec -B $(pwd):/data singularity/coble-tst.sif \
      python /data/my_script.py
    ```

=== "SLURM Singularity"

    ```bash
    # Test Python inside container
    singularity exec singularity/coble-tst.sif python -c "
    import numpy as np
    import pandas as pd
    print('NumPy version:', np.__version__)
    print('Pandas version:', pd.__version__)
    print('✓ Python packages working!')
    "
    
    # Test R inside container
    singularity exec singularity/coble-tst.sif Rscript -e "
    library(data.table)
    library(ggplot2)
    cat('✓ R packages working!\n')
    "
    
    # Test with bind mount (access local files)
    singularity exec -B $(pwd):/data singularity/coble-tst.sif \
      python /data/my_script.py
    ```

---

## Common Issues

### Conda Build Issues

??? warning "Dependency conflicts"
    **Symptom:** "Conflicts encountered" during build
    
    **Solution:**
    ```bash
    # Use mamba solver (faster)
    bash bin/coble-bash.sh \
      --steps "mamba:create,export" \
      --input "config/coble-tst.yml" \
      ...
    ```

??? warning "Package not found"
    **Symptom:** "PackagesNotFoundError"
    
    **Solution:** Check config file for typos, verify package exists in channels

??? warning "Out of disk space"
    **Symptom:** "No space left on device"
    
    **Solution:**
    ```bash
    # Clean conda cache
    conda clean -afy
    
    # Use different package cache location
    bash bin/coble-bash.sh --pkg "/tmp/conda-cache" ...
    ```

### Singularity Build Issues

??? warning "Fakeroot not available"
    **Symptom:** "fakeroot is not installed"
    
    **Solution:**
    ```bash
    # Check Singularity version
    singularity version
    
    # Use sudo if available
    sudo singularity build singularity/coble-tst.sif singularity/coble-tst.def
    
    # Or request admin to enable fakeroot
    ```

??? warning "Cannot access network"
    **Symptom:** Build hangs or fails downloading packages
    
    **Solution:**
    - Check internet connectivity
    - Verify proxy settings if behind firewall
    - Use `--build-arg http_proxy=...` if needed

??? warning "Image already exists"
    **Symptom:** "output file already exists"
    
    **Solution:**
    ```bash
    # Force rebuild
    singularity build --force --fakeroot singularity/coble-tst.sif singularity/coble-tst.def
    
    # Or delete first
    rm singularity/coble-tst.sif
    singularity build --fakeroot singularity/coble-tst.sif singularity/coble-tst.def
    ```

---

## Next Steps

### Build Other Variants

Try the minimal or full environments:

=== "Minimal (Fast)"
    ```bash
    # Conda
    bash bin/coble-bash.sh \
      --steps "create,export" \
      --input "config/coble-mini.yml" \
      --results "results/coble-mini" \
      --env "./envs/coble-mini"
    
    # Singularity
    singularity build --fakeroot singularity/coble-mini.sif singularity/coble-mini.def
    ```

=== "Full Production (Slow)"
    ```bash
    # Conda (use mamba for speed)
    bash bin/coble-bash.sh \
      --steps "mamba:create,export,errors" \
      --input "config/coble-452.yml" \
      --results "results/coble-452" \
      --env "./envs/coble-452"
    
    # Singularity (4-8 hours)
    singularity build --fakeroot singularity/coble-452.sif singularity/coble-452.def
    ```

### Build on HPC with SLURM

Submit as batch job instead of interactive:

=== "Conda on SLURM"
    ```bash
    sbatch bin/coble-slurm.sh \
      --steps "mamba:create,export,errors" \
      --input "config/coble-tst.yml" \
      --results "results/coble-tst" \
      --env "./envs/coble-tst"
    ```

=== "Singularity on SLURM"
    ```bash
    sbatch bin/coble-slurm-sing.sh tst
    ```

See [Develop: SLURM](develop-slurm.md) for details.

### Create Custom Environment

1. **Copy a config template:**
   ```bash
   cp config/coble-mini.yml config/my-custom.yml
   ```

2. **Edit your config:**
   ```yaml
   #coble-yml
   dependencies:
     - conda:
       - python=3.14.0
       - r-base=4.5.2
     - r_conda:
       - tidyverse
       - devtools
     - bio_package:
       - DESeq2
   ```

3. **Build your environment:**
   ```bash
   bash bin/coble-bash.sh \
     --steps "create,export" \
     --input "config/my-custom.yml" \
     --results "results/my-custom" \
     --env "./envs/my-custom"
   ```

See [Configuration Guide](config.md) for config file documentation.

### Use Pre-built Images

Skip the build - use ready-made Docker images:

```bash
# Pull from Docker Hub
docker pull icrsc/coble:452
docker pull icrsc/coble:mini

# Or convert to Singularity
singularity pull coble-452.sif docker://icrsc/coble:452
```

See [Quick Start](quickstart.md) for usage.

---

## Learn More

- **[Configuration Guide](config.md)** - Config file format and options
- **[Develop: Conda](develop-conda.md)** - Detailed conda build guide
- **[Develop: Singularity](develop-singularity.md)** - Detailed Singularity guide
- **[Develop: SLURM](develop-slurm.md)** - HPC batch job submission
- **[CLI Reference](cli-reference.md)** - All command options

---

## Quick Reference

### Build Commands

```bash
# Conda: Test environment
bash bin/coble-bash.sh --steps "create,export" \
  --input "config/coble-tst.yml" \
  --results "results/coble-tst" \
  --env "./envs/coble-tst"

# Singularity: Test container
singularity build --fakeroot singularity/coble-tst.sif singularity/coble-tst.def

# SLURM: Conda batch job
sbatch bin/coble-slurm.sh --steps "create,export" --input "config/coble-tst.yml" ...

# SLURM: Singularity batch job
sbatch bin/coble-slurm-sing.sh tst
```

### Useful Checks

```bash
# Check conda environment
conda activate ./envs/coble-tst
conda list | wc -l          # Package count
python --version            # Python version
R --version                 # R version

# Check Singularity image
singularity inspect singularity/coble-tst.sif
singularity exec singularity/coble-tst.sif conda list | wc -l
ls -lh singularity/coble-tst.sif  # Image size

# Check build results
cat results/coble-tst/errors.log          # Errors
cat results/coble-tst/missing.txt         # Missing packages
wc -l results/coble-tst/r_packages.txt    # R package count
```
