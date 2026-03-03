# Community Containers on GitHub

As part of the drive to make published publication environments more accessible, we includein our GitHuib repo the facility to submit your own coble recipe and request a docker build to be publicly hosted on our GitHub community so it can be shared. We welcome pre-publication submissions, post-publication and common environment submissions.

The procedure for submitting a request for a docker build is here: [Submit your recipe](https://github.com/coble-tools/coble/tree/main/recipes).

The packages for the community containers can be found here [COBLE Community Cotainers](https://github.com/coble-tools/coble/pkgs/container/coble).

Three examples of published environments are given here. They can be run with either docker or singularity, both examples given.


## Bioinformatics
**Deseq2 paper**: https://link.springer.com/article/10.1186/s13059-014-0550-8
**Image name**: coble:papers-deseq2
```bash
# Docker
docker pull \
ghcr.io/coble-tools/coble:papers-deseq2

docker run --rm -it -v .:/workspace -w /workspace \
ghcr.io/coble-tools/coble:papers-deseq2

# Singularity
singularity build \
coble-papers-deseq2.sif \
docker://ghcr.io/coble-tools/coble:papers-deseq2

singularity shell \
coble-papers-deseq2.sif
```

In this container, running “validate.sh” will run the initially published vignette to the first plot which will be produced in your working directory.

## Foundation-Model AI
**ProvGigaPath paper**: https://www.nature.com/articles/s41586-024-07441-w
**Image name**: coble:papers-ProvGidaPath

This environment reproduces the dependencies specified in the original paper. This limits the container to amd64 (Linux/WSL) as PyTorch 2.0.0 has no linux-aarch64 conda builds and flash-attn 2.5.8 does not support CUDA architectures above sm119. Additional parameters are needed:
- `HF_TOKEN`: HugggingFace token is needed to access the model
- `HF_HOME`: A home directory needs to be specified for the model download
- A GPU flag needs to passed in
Instructions for getting the HuggingFace token are described on the author’s repo: https://github.com/prov-gigapath/prov-gigapath?tab=readme-ov-file#model-download.

```bash
# Docker
# Docker
docker pull \
ghcr.io/coble-tools/coble:papers-provgigapath

docker run --rm -it -v .:/workspace -w /workspace \
--gpus all -e HF_TOKEN -e HF_HOME \
ghcr.io/coble-tools/coble:papers-provgigapath

# Singularity
singularity build \
coble-papers-provgigapath.sif \
docker://ghcr.io/coble-tools/coble:papers-provgigapath

singularity shell --nv \
--env HF_TOKEN=$HF_TOKEN \
--env HF_HOME=$HF_HOME \
coble-papers-provgigapath.sif
```

In this container, running “validate.sh” will run code taken from the demo notebook published in June 2025 (converted to a script): https://github.com/prov-gigapath/prov-gigapath/blob/main/demo/run_gigapath.ipynb. Some amendments were made to detect hardware and fallback to CPU where hardware is not compatible in order to make the environment truly usable. This required a minor amendment to the pipeline code of the repo to allow CPU as a fallback (https://github.com/rachelicr/prov-gigapath/tree/fix/respect-device-parameter).

## An Economics/Politics example

Parliamentary voting dynamics, using data mining techniques on political data.
Publication: https://link.springer.com/article/10.1140/epjds/s13688-025-00609-y
Image name: coble:papers-basometro
```bash
# Docker
docker pull \
ghcr.io/coble-tools/coble:papers-basometro

docker run --rm -it -v .:/workspace -w /workspace \
ghcr.io/coble-tools/coble:papers-basometro

# Singularity
singularity build \
coble-papers-basometro.sif \
docker://ghcr.io/coble-tools/coble:papers-basometro

singularity shell \
coble-papers-basometro.sif
```
The code repo has minor modifications (such as creating the required folders) - https://github.com/Yuri-Nassar/mat-basometro/compare/master...rachelicr:mat-basometro:master): the `validate.sh` gives instructions on how to run their example notebook in the Conda environment and runs a copy of the Jupyter notebook converted to a script.
