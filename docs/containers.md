# Docker and Singularity

Docker and Singularity images build together simply using the command `contain` when calling coble with all other paramaters the same as `build`.

**Recipe:** `config/basic.cbl`
**env** `my-env`
```bash
coble contain --recipe config/basic.cbl --env my-env
```
Your GITHUB_PAT authentication token [from github](https://github.com/settings/tokens) is automatically passed though ion case of any API calls to githib. You set this in your .bashrc in the usual way after creating the PAT in github from settings/ (`export GITHUB_PAT="ghp_*******************************"`) 

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