# Develop: SLURM Batch Jobs

Guide for submitting COBLE builds as SLURM batch jobs on HPC clusters.

## Overview

COBLE provides two SLURM wrapper scripts for automated batch job submission:

| Script | Purpose | Build Method | Typical Runtime |
|--------|---------|--------------|-----------------|
| `coble-slurm.sh` | Conda environments | Direct conda install | 1-4 hours |
| `coble-slurm-sing.sh` | Singularity images | Container build | 2-6 hours |

**Best for:** Long-running builds, HPC batch systems, reproducible builds without active monitoring

---

## 1. Conda Environment Builds

### coble-slurm.sh

Builds conda environments directly on the cluster using `coble-bash.sh`.

#### Basic Usage

```bash
# Submit conda build job
sbatch bin/coble-slurm.sh \
  --steps "create,export,errors,missing" \
  --input "config/coble-452.yml" \
  --results "results/coble-452" \
  --env "./envs/coble-452" \
  --r-version "4.5.2" \
  --python-version "3.14.0"
```

#### Script Features

- Exports SLURM diagnostics (job ID, nodes, resources)
- Passes all arguments to `coble-bash.sh`
- Creates timestamped log files: `logs/coble-<jobid>.out/err`
- Default resources:
  - Tasks: 4 (`#SBATCH -n 4`)
  - Time: 10 hours (`#SBATCH -t 10:00:00`)
  - Job name: "CobleBuild"

#### Monitor Progress

```bash
# Watch output log
tail -f logs/coble-<jobid>.out

# Check errors
tail -f logs/coble-<jobid>.err

# View SLURM diagnostics
head -20 logs/coble-<jobid>.out  # Shows job info
```

#### Customize Resources

Edit `bin/coble-slurm.sh` SBATCH directives:

```bash
#!/usr/bin/env bash
#SBATCH -J "CobleBuild"
#SBATCH --output=logs/coble-%j.out
#SBATCH --error=logs/coble-%j.err
#SBATCH -n 8                    # Increase tasks
#SBATCH -t 20:00:00            # Longer timeout
#SBATCH --mem=32G              # Add memory limit
#SBATCH --partition=compute    # Specify partition
```

---

## 2. Singularity Image Builds

### coble-slurm-sing.sh

Builds Singularity images on HPC using fakeroot.

#### Basic Usage

```bash
# Build 452 variant
sbatch bin/coble-slurm-sing.sh 452

# Build mini variant
sbatch bin/coble-slurm-sing.sh mini

# Build tst variant
sbatch bin/coble-slurm-sing.sh tst

# Default to mini if no argument
sbatch bin/coble-slurm-sing.sh
```

#### Script Features

- Validates definition and config files exist
- Loads singularity module (adjusts for your HPC)
- Attempts fakeroot build (no sudo needed)
- Creates output: `singularity/coble-<variant>.sif`
- Shows image info and size on completion
- Provides troubleshooting tips on failure
- Default resources:
  - CPUs: 4 (`#SBATCH -n 4`)
  - Memory: 16GB (`#SBATCH --mem=16G`)
  - Time: 4 hours (`#SBATCH -t 04:00:00`)
  - Job name: "CobleSingularityBuild"

#### Monitor Progress

```bash
# Watch build output
tail -f logs/coble-sing-build-<jobid>.out

# Check for errors
tail -f logs/coble-sing-build-<jobid>.err

# Check job status
squeue -u $USER
scontrol show job <jobid>
```

#### Verify Build Success

```bash
# Check if SIF file exists
ls -lh singularity/coble-452.sif

# View build summary (at end of log)
tail -30 logs/coble-sing-build-<jobid>.out
```

#### Customize Resources

Edit `bin/coble-slurm-sing.sh` SBATCH directives:

```bash
#!/usr/bin/env bash
#SBATCH -J "CobleSingularityBuild"
#SBATCH --output=logs/coble-sing-build-%j.out
#SBATCH --error=logs/coble-sing-build-%j.err
#SBATCH -n 8                    # More CPUs
#SBATCH -t 08:00:00            # Longer timeout for large builds
#SBATCH --mem=32G              # More memory
#SBATCH --partition=build      # Dedicated build partition
```

---

## Job Submission Examples

### Conda: Mini Environment (Quick Test)

```bash
sbatch bin/coble-slurm.sh \
  --steps "create,export" \
  --input "config/coble-mini.yml" \
  --results "results/coble-mini-test" \
  --env "./envs/coble-mini-test"
```

### Conda: Full 452 Environment

```bash
sbatch bin/coble-slurm.sh \
  --steps "mamba:create,export,errors,missing" \
  --input "config/coble-452.yml" \
  --results "results/coble-452-$(date +%Y%m%d)" \
  --env "./envs/coble-452" \
  --pkg "./pkgs/shared-cache"
```

### Singularity: All Variants

```bash
# Submit multiple jobs
for variant in mini 452 tst; do
    sbatch bin/coble-slurm-sing.sh $variant
done

# Check all jobs
squeue -u $USER --name=CobleSingularityBuild
```

### Array Job for Multiple Configs

Create array job script `build-array.sh`:

```bash
#!/bin/bash
#SBATCH -J "CobleArray"
#SBATCH --array=0-2
#SBATCH --output=logs/coble-array-%A-%a.out
#SBATCH -t 05:00:00

# Define variants
VARIANTS=(mini 452 tst)
VARIANT=${VARIANTS[$SLURM_ARRAY_TASK_ID]}

# Build Singularity image
module load singularity
singularity build --fakeroot \
    singularity/coble-$VARIANT.sif \
    singularity/coble-$VARIANT.def
```

Submit:
```bash
sbatch build-array.sh
```

---

## Troubleshooting

### Job Pending Too Long

**Symptom**: Job stuck in queue

**Check:**
```bash
squeue -u $USER
squeue -j <jobid> --start  # Estimated start time
```

**Solutions**:
- Reduce resource requests (CPUs, memory, time)
- Use different partition with shorter wait
- Submit during off-peak hours
- Check cluster status: `sinfo`

### Job Failed Immediately

**Symptom**: Job exits quickly with error

**Check logs:**
```bash
cat logs/coble-<jobid>.err
tail -50 logs/coble-<jobid>.out
```

**Common causes:**
- Config file missing
- Definition file missing  
- Module load failed
- Insufficient permissions

### Out of Memory

**Symptom**: Job killed with OOM error

**Solution:**
```bash
# Increase memory in script
#SBATCH --mem=32G  # or higher

# Or specify per-CPU memory
#SBATCH --mem-per-cpu=8G
```

### Timeout

**Symptom**: Job killed after time limit

**Solution:**
```bash
# Increase time limit
#SBATCH -t 12:00:00  # 12 hours

# For large builds
#SBATCH -t 24:00:00  # 24 hours
```

### Singularity Module Not Found

**Symptom**: "singularity: command not found"

**Solution:**
```bash
# Check available modules
module avail singularity
module avail apptainer

# Load appropriate module
module load singularity/3.10.0
# or
module load apptainer/1.2.0
```

Edit `bin/coble-slurm-sing.sh` to load correct module:
```bash
module load singularity/3.10.0 2>/dev/null || echo "Note: singularity module not found"
```

### Fakeroot Not Available

**Symptom**: "fakeroot is not installed" or namespace errors

**Solutions:**
1. Check if fakeroot enabled:
   ```bash
   singularity version
   ```
   
2. Request admin to enable fakeroot

3. Use sudo if available (requires permissions):
   ```bash
   # Edit coble-slurm-sing.sh
   sudo singularity build ...
   ```

### Build Fails at Conda Solve

**Symptom**: Hangs or fails during dependency resolution

**Solutions:**
- Use mamba instead of conda (faster)
- Simplify config (remove conflicting packages)
- Check config for typos
- Try building interactively first to debug

---

## Advanced Usage

### Email Notifications

Get notified when jobs complete:

```bash
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=your.email@domain.com
```

### Job Dependencies

Chain builds together:

```bash
# Submit conda build
JOB1=$(sbatch --parsable bin/coble-slurm.sh --input config/coble-452.yml ...)

# Submit Singularity build after conda completes
sbatch --dependency=afterok:$JOB1 bin/coble-slurm-sing.sh 452
```

### Custom Log Locations

Override default log paths:

```bash
#SBATCH --output=/scratch/$USER/logs/coble-%j.out
#SBATCH --error=/scratch/$USER/logs/coble-%j.err
```

### Shared Package Cache

Use shared cache across builds:

```bash
# Set cache location
export CONDA_PKGS_DIRS=/shared/conda-cache/$USER

# Submit with shared cache
sbatch bin/coble-slurm.sh \
  --pkg "/shared/conda-cache/$USER" \
  --input config/coble-452.yml \
  ...
```

### Partition Selection

Target specific compute resources:

```bash
#SBATCH --partition=highmem     # High memory nodes
#SBATCH --partition=longrun     # Extended time limit
#SBATCH --partition=gpu         # GPU nodes (if needed)
```

---

## Best Practices

### Resource Requests

- **Conda builds**: 4-8 CPUs, 16-32GB RAM, 2-10 hours
- **Singularity builds**: 4-8 CPUs, 16-32GB RAM, 4-12 hours
- Start conservative, increase if jobs fail

### Log Management

```bash
# Create logs directory
mkdir -p logs

# Clean old logs periodically
find logs/ -name "*.out" -mtime +30 -delete
find logs/ -name "*.err" -mtime +30 -delete

# Archive important logs
tar -czf logs-archive-$(date +%Y%m%d).tar.gz logs/
```

### Job Naming

Use descriptive names for easy tracking:

```bash
#SBATCH -J "coble-452-prod-build"
#SBATCH -J "coble-mini-test-$(date +%Y%m%d)"
```

### Testing Strategy

1. Test with mini variant first (fast)
2. Run small test job before large production build
3. Monitor resource usage with `sstat`
4. Adjust resources based on actual usage

### Documentation

Keep build notes:

```bash
# Create build log
cat > build-notes-$(date +%Y%m%d).txt <<EOF
Build: coble-452
Date: $(date)
Job ID: <jobid>
Config: config/coble-452.yml
Purpose: Production environment for project X
Notes: Added package Y for new analysis
EOF
```

---

## Monitoring and Debugging

### Check Job Status

```bash
# Your jobs
squeue -u $USER

# Specific job details
scontrol show job <jobid>

# Job efficiency
seff <jobid>

# Real-time resource usage
sstat -j <jobid> --format=JobID,MaxRSS,AveCPU
```

### Cancel Jobs

```bash
# Cancel specific job
scancel <jobid>

# Cancel all your jobs
scancel -u $USER

# Cancel by name
scancel --name=CobleBuild
```

### Review Completed Jobs

```bash
# Job accounting info
sacct -j <jobid> --format=JobID,JobName,State,ExitCode,Elapsed,MaxRSS

# Recent jobs
sacct -u $USER --starttime=today
```

---

## Additional Resources

- [Develop: Conda](develop-conda.md) - Conda environment building
- [Develop: Singularity](develop-singularity.md) - Singularity image building  
- [SLURM Usage](slurm.md) - Using COBLE in SLURM jobs
- [SLURM Documentation](https://slurm.schedmd.com/)
- Your HPC cluster documentation (partition names, policies, etc.)
