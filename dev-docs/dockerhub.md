COBLE is a set of scripts to help build and manage conda environments, particularly for R and Bioconductor packages, along with Python packages. It allows you to define environments using YAML files or bash recipes, automates the installation process, captures logs for error analysis, and generates reproducible outputs including combined environment files and installation scripts.

COBLE packages are built on Docker and made available via DockerHub for easy use with Singularity. This enables the same conda environments to be used on secure systems without internet access.

## Docker - download and run

To open up a docker coble container as a bash utility from the command line:  
`docker run --rm -it icrsc/coble:<tag>`

## Docker volume mapping
Unlike singularity, with docker you do not have access to the local machine and need to explictly pass in a mapping from the outer world to the inner world of the container.  The containers have a fixed directory structure so you need to map to an existent place. The recommended mapping to COBLE is from wherever you want, perhaps your code folder, to the /app folder which is the root of the container. e,  
`docker run --rm -it -v /my/code/path:/app icrsc/coble:<tag>`

---  
## Singularity

It can be loaded as a singularity image by:  
`singularity build coble-<tag>.sif docker://icrsc/coble:<tag>`

Then run as a bash shell by:  
`singularity shell coble-<tag>.sif`

Where singularity and apptainer can be used interchangeably.