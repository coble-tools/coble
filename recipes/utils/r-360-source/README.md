# Build for conda
code/coble build --recipe recipes/utils/r-360/r-360.cbl \
--env r-360 \
--validate recipes/utils/r-360/validate/validate.sh \
--val-folder recipes/utils/r-360/validate/ \
--rebuild

# Build for docker and singularity
code/coble build --recipe recipes/utils/r-360/r-360.cbl \
--env r-360 \
--validate recipes/utils/r-360/validate/validate.sh \
--val-folder recipes/utils/r-360/validate/ \
--containers docker,singularity
#--banner ICR
#--target linux/amd64,linux/arm64 \
