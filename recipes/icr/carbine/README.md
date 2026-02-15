# Carbine Environment for Publication Reproducibility

The docker impage on GitHub has both an amd64 and arm64 version. 

To download the docker image and use it locally do (mounting your current working directory to the workspace inside the container and starting in workspace):
```bash
docker pull icrsc/coble:icr-carbine
docker run --rm -it -v .:/workspace -w /workspace icrsc/coble:icr-carbine
validate.sh
```

To download as singularity to use eg on HPC (you retain access to the host inside a singularity image).

```bash
singularity pull cbl-icr-carbine.sif docker://icrsc/coble:icr-carbine
singularity shell cbl-icr-carbine.sif
```


# Build for conda
code/coble build --recipe recipes/icr/carbine/carbine.cbl \
--env carbine \
--validate recipes/icr/carbine/validate/validate.sh \
--val-folder recipes/icr/carbine/validate/ \
--rebuild

# Build for docker and singularity
code/coble build --recipe recipes/icr/carbine/carbine.cbl \
--env carbine \
--validate recipes/icr/carbine/validate/validate.sh \
--val-folder recipes/icr/carbine/validate/ \
--containers docker,singularity \
--dual mac
#--banner ICR
#--target linux/amd64,linux/arm64 \

 docker manifest create icrsc/coble:icr-carbine \
 icrsc/coble:icr-carbine-amd64 \
 icrsc/coble:icr-carbine-arm64
