# COBLE: COnda BuiLdEr
`COBLE - COnda BuiLdEr: Build and manage conda environments`
Created by the RSE team at the ICR for and with the Breast Cancer Research Data Science Group.
*Contacts: Rachel Alcraft, Syed Haider*

---

Documentation:
- GitHub Docs Site: [coble-tools.github.io/coble/](https://coble-tools.github.io/coble/)
- GitHub repo: [github.com/coble-tools/coble](https://github.com/coble-tools/coble)
- GitHub Issues: [github.com/coble-tools/coble/issues](https://github.com/coble-tools/coble/issues)
---

## Using the docker images
The community docker images can be run in either docker or singualrity. Fiurst pull the image (you only need to do this once), and then you can run the image as a bash terminal with the environment ready activated.
An example is given here for papers-DESEq2:
```bash
# Docker
docker pull \
ghcr.io/coble-tools/coble:papers-deseq2

docker run --rm -it -v .:/workspace \
ghcr.io/coble-tools/coble:papers-deseq2

# Singularity
singularity build \
coble-papers-deseq2.sif \
docker://ghcr.io/coble-tools/coble:papers-deseq2

singularity shell \
coble-papers-deseq2.sif
```

Further information is here: [Coble Community Containers](https://coble-tools.github.io/coble/containers/community/)

## Installation

Installation can be done through conda or github.

### Conda Installation
```bash
# In your chosen conda environment, or in base:
conda install rachelsa::coble
# Test it
coble -h
```
When installed through conda the utility and all the scripts are in the path so you can refer to it as `coble` wherever you are.


### Github installation
```bash
git clone git@github.com:coble-tools/coble.git
coble/code/coble -h
```
You need to add the folder `coble/code` to the path or refer to the coble utility script by full or relative path.
