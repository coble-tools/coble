# Singularity Builds

Quick instructions to build COBLE Singularity images directly from the definition files in this folder.

## Requirements
- Singularity/Apptainer installed (module or system)
- Internet access for base image and conda channels
- Root (`sudo`) or fakeroot capability for building

## Build Commands (output SIFs into `singularity/`)

- Mini variant (conda solver):
```bash
sudo singularity build singularity/coble-mini.sif singularity/coble-mini.def
```

- 452 variant (mamba solver):
```bash
sudo singularity build singularity/coble-452.sif singularity/coble-452.def
```

- tst variant (mamba solver):
```bash
sudo singularity build singularity/coble-tst.sif singularity/coble-tst.def
```

### Without sudo (fakeroot)
If your cluster supports fakeroot:
```bash
singularity build --fakeroot singularity/coble-452.sif singularity/coble-452.def
```

## Verify and Use

Interactive shell (auto-activates conda env):
```bash
singularity shell singularity/coble-452.sif
```

Run a command with the environment:
```bash
singularity exec singularity/coble-452.sif bash -c "source /app/activate_conda.sh && python --version"
```

Check the selected variant:
```bash
singularity exec singularity/coble-452.sif bash -c 'echo $COBLE_VARIANT'
```

## Alternative: Pull prebuilt from Docker Hub
If CI has already published the image:
```bash
singularity pull singularity/coble-452.sif docker://icrsc/coble:452
```

## Build via SLURM (batch)

`singularity/build_coble.sh` example:
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

# Choose one:
sudo singularity build singularity/coble-452.sif singularity/coble-452.def
# singularity build --fakeroot singularity/coble-452.sif singularity/coble-452.def
```
Submit:
```bash
sbatch singularity/build_coble.sh
```

## Troubleshooting
- "could not create user namespace": use `--fakeroot` or contact admins to enable unprivileged user namespaces.
- "failed to pull docker image": check internet and registry access:
  ```bash
  curl -I https://hub.docker.com/
  ```
- Slow conda solve: use the 452/tst variants (mamba) or simplify the config.
- Permission errors writing to `/app` during `%post`: expected unless using `sudo` or `--fakeroot`.

## Files
- `coble-mini.def`  — minimal environment (conda)
- `coble-452.def`   — full environment (mamba)
- `coble-tst.def`   — experimental/test environment (mamba)
