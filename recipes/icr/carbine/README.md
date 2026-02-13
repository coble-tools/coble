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
