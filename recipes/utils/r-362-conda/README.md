recipe=r-362-conda

# Build for conda
```bash
code/coble build --recipe recipes/utils/$recipe/$recipe.cbl \
--env $recipe \
--validate recipes/utils/$recipe/validate/validate.sh \
--val-folder recipes/utils/$recipe/validate/ \
--rebuild
```

# Build for docker and singularity
```bash
code/coble build --recipe recipes/utils/$recipe/$recipe.cbl \
--env $recipe \
--validate recipes/utils/$recipe/validate/validate.sh \
--val-folder recipes/utils/$recipe/validate/ \
--containers docker,singularity
#--banner ICR
#--target linux/amd64,linux/arm64 \
```
