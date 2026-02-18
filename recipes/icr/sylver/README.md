# Sylver builds


# Build for conda
code/coble build --recipe recipes/icr/sylver/sylver.cbl \
--env sylver \
--validate recipes/icr/sylver/validate/validate.sh \
--val-folder recipes/icr/sylver/validate/ \
--rebuild

# Build for docker and singularity
code/coble build --recipe recipes/icr/sylver/sylver.cbl \
--env sylver \
--validate recipes/icr/sylver/validate/validate.sh \
--val-folder recipes/icr/sylver/validate/ \
--containers docker,singularity
#--banner ICR
#--target linux/amd64,linux/arm64 \


# Build for docker and singularity
/home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble build \
--recipe /home/ralcraft/DEV/gh-rse/BCRDS/coble/recipes/icr/sylver/sylver.cbl \
--env sylver \
--validate recipes/icr/sylver/validate/validate.sh \
--val-folder recipes/icr/sylver/validate/ \
--containers docker,singularity

