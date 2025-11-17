# Singularity Usage

Singularity is ideal for HPC environments and secure systems without internet access. COBLE images can be easily converted from Docker and run with Singularity.

## Why Singularity?

- ✅ **No root privileges required** - Run anywhere users have access
- ✅ **Perfect for HPC** - Designed for shared computing environments
- ✅ **Air-gapped systems** - Works offline once images are downloaded
- ✅ **Seamless file access** - Host filesystem automatically mounted
- ✅ **Docker compatible** - Pull directly from DockerHub

## Quick Start

### Pull an Image from DockerHub

Convert a Docker image to Singularity format:

```bash
singularity pull -F coble-452.sif docker://icrsc/coble:452
```

The `-F` flag forces overwrite if the file exists.

### Available Images

Pull any of these images:

```bash
# Classic 452 environment
singularity pull -F coble-452.sif docker://icrsc/coble:452

# Mini 452 environment
singularity pull -F coble-mini.sif docker://icrsc/coble:mini

```

### Check Which COBLE Tag You Have

Inside a shell (or via `singularity exec`) you can verify the loaded image tag:

```bash
echo $COBLE_VARIANT          # Prints the environment flavor (e.g. 452, mini, xyz)
env | grep COBLE_VARIANT     # Alternate inspection
```

If you need metadata without starting a shell:

```bash
singularity exec coble-452.sif bash -c 'echo $COBLE_VARIANT'
```

This environment variable is embedded at Docker build time and carried into the `.sif` image.

## Running Containers

### Interactive Shell

Open a shell with the environment activated:

```bash
singularity shell coble-452.sif
```

!!! success "Auto-Activation"
    The conda environment activates automatically when you enter the shell!

Inside the container:

```bash
# Check Python
python --version

# Check R
R --version

# List packages
conda list

# Specific packages
Rscript -e "packageVersion('fgsea')"
python -m pip show numpy | awk '/^Version:/{print $2}'
```



### Execute Commands

Run a single command without entering the shell:

```bash
# Python script
singularity exec coble-452.sif bash -c "source /app/activate_conda.sh && python script.py"

# R script
singularity exec coble-452.sif bash -c "source /app/activate_conda.sh && Rscript analysis.R"

# Check versions
singularity exec coble-452.sif bash -c "source /app/activate_conda.sh && python --version && R --version"
```

## Working with Files

### File Access

Singularity automatically mounts your home directory and current working directory:

```bash
# Your files are accessible
cd /path/to/your/project
singularity shell coble-452.sif
# Inside container - work with your files normally
ls
python analysis.py
```

### Bind Additional Paths

Use bind only when you need remapping, clarity, or isolation. 
Chck first, eg can you do this:  
`singularity exec coble-452.sif ls /data/scratch`

To mount specific directories:
```bash
singularity shell --bind /data:/mnt/data coble-452.sif
```

Multiple bind mounts:

```bash
singularity shell \
  --bind /data:/mnt/data \
  --bind /data/scratch:/data/scratch \
  coble-452.sif
```

## Air-Gapped / Secure Environments

### Transfer to Offline Systems

1. **Download on internet-connected system:**

```bash
singularity pull -F coble-452.sif docker://icrsc/coble:452
```

2. **Transfer the `.sif` file** to your secure system (USB, secure file transfer, etc.)

3. **Use on offline system:**

```bash
# No internet required!
singularity shell coble-452.sif
```

!!! tip "Fully Self-Contained"
    Singularity `.sif` files contain everything needed to run - no downloads, no dependencies, no internet required.

## HPC Integration

### SLURM Job Example

```bash
#!/bin/bash
#SBATCH --job-name=coble-analysis
#SBATCH --output=analysis_%j.log
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=02:00:00

# Load Singularity module if needed
module load singularity

# Run analysis
singularity exec coble-452.sif python analysis.py
```

### With Bind Mounts on HPC

```bash
#!/bin/bash
#SBATCH --job-name=coble-analysis

# Bind scratch and data directories
singularity exec \
  --bind /scratch/$USER:/scratch \
  --bind /data/project:/data \
  coble-452.sif \
  Rscript analysis.R
```

## Advanced Usage

### Environment Variables

Pass environment variables:

```bash
singularity exec --env MY_VAR=value coble-452.sif python script.py
```

### GPU Access

If you have GPU-enabled code:

```bash
singularity exec --nv coble-452.sif python gpu_script.py
```

### Writable Overlay

Create a writable layer (for temporary package installations):

```bash
# Create overlay
singularity overlay create --size 1024 overlay.img

# Use with container
singularity shell --overlay overlay.img coble-452.sif
```

!!! warning "Writable Overlays"
    Changes in overlays are not part of the original image. For persistent changes, rebuild the Docker image.

## Building from Definition Files

For custom builds, create a Singularity definition file:

```singularity
Bootstrap: docker
From: icrsc/coble:452

%post
    # Additional customizations
    conda install -y additional-package

%environment
    export MY_VARIABLE=value

%runscript
    exec python "$@"
```

Build:

```bash
singularity build custom-coble.sif coble.def
```

## Troubleshooting

### Permission Errors

Singularity runs as your user - no permission issues with home directory files.

### "Command not found"

Ensure the command is in the container:

```bash
singularity exec coble-452.sif which python
singularity exec coble-452.sif conda list
```

### Bind Mount Issues

Check the path exists on host:

```bash
ls -la /path/to/bind
singularity shell --bind /path/to/bind:/mnt coble-452.sif
```

## Comparison: Docker vs Singularity

| Feature | Docker | Singularity |
|---------|--------|-------------|
| Root privileges | Required | Not required |
| HPC friendly | ❌ | ✅ |
| File access | Explicit mounts | Automatic |
| Air-gapped use | Complex | Simple |
| User permissions | Container user | Your user |

## Next Steps

- [Command Reference](cli-reference.md) - Build custom environments
- [Docker Usage](docker.md) - Learn about source Docker images
