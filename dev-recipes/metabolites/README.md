# Sylver builds


# Build for conda
code/coble build --recipe recipes/icr/metabolites/metabolites.cbl \
--env metabolites \
--validate recipes/icr/metabolites/validate/validate.sh \
--val-folder recipes/icr/metabolites/validate/ \
--rebuild

