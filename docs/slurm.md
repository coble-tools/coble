# Using SLURM

COBLE can be integrated into SLURM-based HPC workflows for batch job scheduling and resource management. This guide covers submitting COBLE environment builds as SLURM jobs.

## Why Use SLURM with COBLE?

- ⚖️ **Resource Management** - Allocate appropriate CPU, memory, and time for large builds
- 📊 **Job Tracking** - Monitor build progress and collect logs automatically
- 🔄 **Reproducible Workflows** - Script entire environment creation pipelines
- ⏰ **Scheduling** - Queue builds during off-peak hours

## Prerequisites

- Access to an HPC cluster with SLURM
- COBLE scripts available on shared storage
- Conda/Mamba installed on compute nodes
- Appropriate SLURM account permissions

## Quick Start

### Basic SLURM Job Submission

The error report is parsed from the stdout and stderr log files so these must be specified in the bash script if an error report is required.  

Create a minimal SLURM job script:

**Filename:** `job-coble-build.sh`  
```bash
#!/bin/bash
#SBATCH --job-name=coble-build
#SBATCH --output=logs/coble-%j.out
#SBATCH --error=logs/coble-%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=02:00:00

# Load conda module from bashrc (or module load)
source ~/.bashrc

# Run COBLE
bash bin/coble-bash.sh \
  --steps "create,export,errors,missing" \
  --input "config/coble-mini.yml" \
  --results "results/coble-mini" \
  --r-version "4.5.2" \
  --python-version "3.14.0" \
  --env "./envs/coble-mini" \
  --pkg "./pkgs/coble-mini" \
  --output logs/coble-${SLURM_JOB_ID}.out \
  --error logs/coble-${SLURM_JOB_ID}.err
```

Submit the job:

```bash
sbatch job-coble-build.sh
```

## Using the SLURM Wrapper Script

COBLE includes a dedicated SLURM wrapper script at `bin/coble-slurm.sh` that simplifies job submission.

### Wrapper Script Features

The `coble-slurm.sh` wrapper:
- Sets default SLURM parameters
- Exports SLURM environment variables for diagnostics
- Passes all arguments through to `coble-bash.sh`

### Default SLURM Parameters

```bash
#SBATCH -J "MmbaPlne"      # Job name
#SBATCH -n 4               # Number of tasks
#SBATCH -t 100:00:00       # Time limit (100 hours)
```

### Submitting with the Wrapper

```bash
sbatch bin/coble-slurm.sh \
  --steps "create,export,errors,missing" \
  --input "config/coble-452.yml" \
  --results "results/coble-452" \
  --r-version "4.5.2" \
  --python-version "3.14.0" \
  --env "./envs/coble-452" \
  --pkg "./pkgs/coble-452"
       --output results/coble-$tag.out \
       --error results/coble-$tag.err \
```

### Customizing SLURM Parameters

Override defaults inline:

```bash
sbatch \
  --job-name=coble-custom \
  --cpus-per-task=8 \
  --mem=32G \
  --time=04:00:00 \
  bin/coble-slurm.sh \
  --steps "create,export" \
  --input "config/coble-custom.yml" \
  --results "results/custom" \
  --r-version "4.5.2" \
  --python-version "3.14.0" \
  --env "./envs/custom" \
  --pkg "./pkgs/custom"
```

## Common SLURM Configurations

### Small Environment Build

```bash
#!/bin/bash
#SBATCH --job-name=coble-mini
#SBATCH --output=logs/coble-mini-%j.out
#SBATCH --error=logs/coble-mini-%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=01:00:00

bash bin/coble-bash.sh \
  --steps "create,export,errors,missing" \
  --input "config/coble-mini.yml" \
  --results "results/coble-mini" \
  --r-version "4.5.2" \
  --python-version "3.14.0" \
  --env "./envs/coble-mini" \
  --pkg "./pkgs/coble-mini"
```

### Large Environment Build

For complex environments with many packages:

```bash
#!/bin/bash
#SBATCH --job-name=coble-full
#SBATCH --output=logs/coble-full-%j.out
#SBATCH --error=logs/coble-full-%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --time=08:00:00
#SBATCH --partition=long

bash bin/coble-bash.sh \
  --steps "mamba:create,export,errors,missing" \
  --input "config/coble-452.yml" \
  --results "results/coble-452" \
  --r-version "4.5.2" \
  --python-version "3.14.0" \
  --env "./envs/coble-452" \
  --pkg "./pkgs/coble-452"
```

!!! tip "Use Mamba for Large Builds"
    Add `mamba:` prefix to `--steps` for faster dependency solving on complex environments.

### Array Jobs for Multiple Variants

Build multiple variants in parallel:

```bash
#!/bin/bash
#SBATCH --job-name=coble-array
#SBATCH --output=logs/coble-%A-%a.out
#SBATCH --error=logs/coble-%A-%a.err
#SBATCH --array=1-3
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=03:00:00

# Define variants array
variants=(mini 452 custom)
variant=${variants[$SLURM_ARRAY_TASK_ID-1]}

echo "Building variant: $variant"

bash bin/coble-bash.sh \
  --steps "create,export,errors,missing" \
  --input "config/coble-${variant}.yml" \
  --results "results/coble-${variant}" \
  --r-version "4.5.2" \
  --python-version "3.14.0" \
  --env "./envs/coble-${variant}" \
  --pkg "./pkgs/coble-${variant}"
```

## SLURM Directives Reference

### Essential Directives

| Directive | Description | Example |
|-----------|-------------|---------|
| `--job-name` | Job name displayed in queue | `--job-name=coble-build` |
| `--output` | Standard output file path | `--output=logs/out-%j.log` |
| `--error` | Standard error file path | `--error=logs/err-%j.log` |
| `--ntasks` | Number of tasks | `--ntasks=1` |
| `--cpus-per-task` | CPUs per task | `--cpus-per-task=4` |
| `--mem` | Memory per node | `--mem=16G` |
| `--time` | Time limit (HH:MM:SS) | `--time=02:00:00` |

### Advanced Directives

| Directive | Description | Example |
|-----------|-------------|---------|
| `--partition` | Queue/partition name | `--partition=long` |
| `--account` | Billing account | `--account=myproject` |
| `--qos` | Quality of service | `--qos=high` |
| `--constraint` | Node features required | `--constraint=avx2` |
| `--array` | Array job indices | `--array=1-10` |
| `--dependency` | Job dependencies | `--dependency=afterok:12345` |
| `--mail-type` | Email notifications | `--mail-type=END,FAIL` |
| `--mail-user` | Email address | `--mail-user=user@example.com` |

### Resource Guidelines

Choose resources based on environment complexity:

| Environment Type | CPUs | Memory | Time | Partition |
|-----------------|------|--------|------|-----------|
| Mini (<50 packages) | 2-4 | 8-16G | 1-2h | standard |
| Medium (50-200 packages) | 4-8 | 16-32G | 2-4h | standard |
| Large (200-500 packages) | 8-16 | 32-64G | 4-8h | long |
| Full (>500 packages) | 16+ | 64G+ | 8-24h | long |

## Job Management

### Submit Job

```bash
sbatch job-script.sh
```

### Check Job Status

```bash
squeue -u $USER
```

### Cancel Job

```bash
scancel <job_id>
```

### View Job Details

```bash
scontrol show job <job_id>
```

### Check Job Output

```bash
tail -f logs/coble-<job_id>.out
```

## Environment Variables

The wrapper script exports useful SLURM variables:

```bash
SLURM_JOB_ID          # Unique job identifier
SLURM_JOB_NODELIST    # Nodes allocated to job
SLURM_NNODES          # Number of nodes
SLURM_NTASKS          # Number of tasks
SLURM_CPUS_ON_NODE    # CPUs per node
SLURM_MEM_PER_CPU     # Memory per CPU
SLURM_MEM_PER_NODE    # Memory per node
SLURM_TIME_LIMIT      # Time limit in minutes
```

These are logged at job start for debugging.

## Tips and Best Practices

### Storage Locations

Use shared storage visible to all compute nodes:

```bash
# Recommended structure on HPC
/shared/project/coble/
  ├── bin/                # Scripts
  ├── config/             # Config files
  ├── envs/               # Built environments
  ├── pkgs/               # Package cache
  ├── results/            # Build outputs
  └── logs/               # SLURM logs
```

### Package Cache Strategy

Reuse package cache across jobs:

```bash
export CONDA_PKGS_DIRS=/shared/project/coble/pkgs
```

This is set automatically by `coble-bash.sh` when using `--pkg`.

### Log Organization

Use SLURM job ID in log names:

```bash
#SBATCH --output=logs/coble-%j.out
#SBATCH --error=logs/coble-%j.err
```

`%j` is replaced with the job ID automatically.

### Email Notifications

Get notified when jobs complete:

```bash
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=your.email@example.com
```

### Dependency Chains

Build environments sequentially:

```bash
# Submit base environment
job1=$(sbatch --parsable build-base.sh)

# Submit derived environment after base completes
sbatch --dependency=afterok:$job1 build-derived.sh
```

### Using Mamba for Speed

For faster solves, use mamba solver:

```bash
bash bin/coble-bash.sh \
  --steps "mamba:create,export,errors,missing" \
  ...
```

### Quiet Mode

Reduce log verbosity:

```bash
bash bin/coble-bash.sh \
  --steps "create,export" \
  --quiet "y" \
  ...
```

## Troubleshooting

### Job Fails Immediately

**Check**: SLURM script syntax and module availability

```bash
# Test script without submitting
bash job-script.sh
```

### Conda Not Found

**Solution**: Load conda module or set PATH

```bash
module load conda
# or
export PATH=/path/to/conda/bin:$PATH
```

### Out of Memory

**Solution**: Increase `--mem` or use mamba solver

```bash
#SBATCH --mem=32G
```

### Timeout

**Solution**: Increase time limit or simplify environment

```bash
#SBATCH --time=08:00:00
```

### Permission Denied

**Solution**: Ensure shared directories are writable

```bash
chmod -R 775 /shared/project/coble
```

## Example Workflow

Complete workflow for building and deploying an environment:

```bash
#!/bin/bash
#SBATCH --job-name=coble-workflow
#SBATCH --output=logs/workflow-%j.out
#SBATCH --error=logs/workflow-%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=04:00:00

# 1. Build environment
bash bin/coble-bash.sh \
  --steps "mamba:create,export,errors,missing" \
  --input "config/coble-analysis.yml" \
  --results "results/analysis" \
  --r-version "4.5.2" \
  --python-version "3.14.0" \
  --env "./envs/analysis" \
  --pkg "./pkgs/analysis"

# 2. Check for errors
if [ -s "results/analysis/error-report.txt" ]; then
  echo "Build had errors - see error-report.txt"
  exit 1
fi

# 3. Archive results
tar -czf analysis-$(date +%Y%m%d).tar.gz \
  results/analysis/ \
  envs/analysis/

echo "Build complete - archive created"
```

## Next Steps

- [Command Reference](cli-reference.md) - Full CLI options
- [Singularity Usage](singularity.md) - Use containers on HPC
- [Developer Guide](developer.md) - CI/CD and variant management

## Questions?

See the GitHub repository or contact your HPC support team for SLURM-specific configurations.
