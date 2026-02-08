
```bash
code/coble build \
--recipe recipes/utils/r-452/r-452.cbl \
--env r-452 \
--validate recipes/utils/r-452/validate/validate.sh \
--rebuild

code/coble build \
--recipe recipes/utils/r-452/r-452.cbl \
--env r-452 \
--validate recipes/utils/r-452/validate/validate.sh \
--containers docker,singularity
```