# Building with Docker

COBLE environments can be built and run inside Docker containers for portability and reproducibility. The recommended workflow is:

1. **Start with a Conda recipe:**
   - Define your environment and package requirements using COBLE and a conda-based recipe.
   - Test and validate the environment locally with conda first.

2. **Build a Docker image:**
   - Use the provided `Dockerfile` (e.g., `Dockerfile.mini`) to build a containerized version of your environment.
   - Example build command:
     ```bash
     docker build -f containers/docker/Dockerfile.mini -t icrsc/coble:mini .
     ```
   - You can pass build arguments or environment variables as needed.

3. **Run the Docker image:**
   - Launch an interactive shell:
     ```bash
     docker run --rm -it icrsc/coble:mini
     ```
   - The environment will be activated and ready for use inside the container.

4. **Push to a registry (optional):**
   - Share your image via Docker Hub or a private registry:
     ```bash
     docker push icrsc/coble:mini
     ```

## Why start with Conda?
- Conda ensures all dependencies are resolved and reproducible before containerization.
- The Docker build simply wraps the conda environment, making it portable and easy to deploy.

## Next steps
- Once you have a working Docker image, you can convert it to Apptainer/Singularity for HPC use (see `container-env.md`).
