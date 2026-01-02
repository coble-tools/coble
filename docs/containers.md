# Docker and Singularity

Docker and Singularity images build together simply using the command `contain` when calling coble with all other paramaters the same as `build`.

**Recipe:** `config/basic.cbl`
**env** `my-env`
```bash
coble contain --input config/basic.cbl --env my-env
```
This outputs:
- `cbl-my-env.tar` a docker file
- `cbl-my-env.sif` a singularity file

To run them as a command line terminal with the environments activated:
```bash
# Docker: 
# Optionally load the tar
docker load -i cbl-my-env.tar
# Then run it
docker run --rm -it cbl-my-env

# Singularity: run directly
singularity shell cbl-my-env.sif
```

The conda environment is pre-activated and they look like this:

### Docker
![alt text](imgs/docker.png)

### Singularity
![alt text](imgs/singularity.png)