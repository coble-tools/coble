# Installation

COBLE can be used in multiple ways depending on your needs:

## Option 1: Use Pre-built Docker/Singularity Images

The easiest way to use COBLE is with pre-built images from DockerHub.

### Using Singularity (Recommended for HPC/Secure Environments)

Pull an image and save it locally:

```bash
singularity pull -F coble-452.sif docker://icrsc/coble:452
```

Run the container:

```bash
singularity shell coble-452.sif
```

!!! tip "Fully Offline"
    Once downloaded, Singularity images are completely self-contained and can be copied to air-gapped systems.

### Using Docker

Pull and run:

```bash
docker pull icrsc/coble:452
docker run --rm -it icrsc/coble:452
```

See the [Docker Usage](docker.md) and [Singularity Usage](singularity.md) pages for more details.

## Option 2: Install from GitHub Source

To build environments locally or customize COBLE:

### Prerequisites

- Conda or Miniconda installed
- Bash shell
- Git

### Clone the Repository

```bash
git clone https://github.com/ICR-RSE-Group/coble.git
cd coble
```

### Available Scripts

- `bin/coble-bash.sh` - Run COBLE via bash
- `bin/coble-slurm.sh` - Submit COBLE jobs to SLURM
- `bin/conda-step-*.sh` - Individual step scripts

## Next Steps

- [Quick Start Guide](quickstart.md) - Create your first environment
- [Command Reference](cli-reference.md) - Learn all the options
