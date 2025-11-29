# Running COBLE Environments as Containers

After building your COBLE environment with conda and Docker, you can run it as a container using Docker or convert it for use with Apptainer/Singularity on HPC systems.

## Workflow Overview
1. **Build with Conda:**
   - Create and test your environment using COBLE and conda locally.
2. **Build a Docker image:**
   - Use the Dockerfile to create a portable image of your environment.
3. **Run with Docker:**
   - Use `docker run` to launch the environment interactively or in batch mode.
4. **Convert to Apptainer/Singularity (for HPC):**
   - On the HPC, use Apptainer/Singularity to pull or build from your Docker image:
     ```bash
     apptainer build myenv.sif docker://icrsc/coble:mini
     # or
     singularity build myenv.sif docker://icrsc/coble:mini
     ```
   - You can now run your environment on the cluster with full reproducibility.

## Pulling Images on HPC

On most HPC systems, you do not build containers with Apptainer/Singularity directly. Instead, you pull the pre-built Docker image from a registry and convert it automatically:

```bash
singularity pull -F coble-mini.sif docker://icrsc/coble:mini
# or (with Apptainer)
apptainer pull -F coble-mini.sif docker://icrsc/coble:mini
```

This downloads and converts the Docker image to a `.sif` file for use on the cluster, without needing Docker on the HPC system.

You can then run your environment with:
```bash
singularity shell coble-mini.sif
# or
apptainer shell coble-mini.sif
```

This is the recommended workflow for running COBLE environments on HPC.

## Sharing a Singularity/Apptainer Image on HPC

A single `.sif` image file (e.g., `coble-mini.sif`) can be used by any number of users at the same time on an HPC system, provided:

- The file is stored on a shared filesystem accessible to all users (e.g., NFS, Lustre, GPFS).
- The file permissions allow read access for all intended users (e.g., `chmod 644 coble-mini.sif`).

Each user’s job or shell session mounts and runs the image independently, so there is no contention or locking issue. This is a standard and recommended way to share containerized environments for reproducible research on HPC clusters.

## Why this approach?
- **Conda** is the foundation for reproducible environments.
- **Docker** makes the environment portable and easy to share.
- **Apptainer/Singularity** enables running the same environment on HPC systems without Docker.

## Summary
- Always start with a conda recipe for maximum reproducibility.
- Use Docker to containerize and test locally or in the cloud.
- Use Apptainer/Singularity to run on HPC, converting from your Docker image as needed.
