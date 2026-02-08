
```bash
code/coble build \
--recipe recipes/utils/r-362/r-362.cbl \
--env r-362 \
--validate recipes/utils/r-362/validate/validate.sh \
--rebuild

code/coble build \
--recipe recipes/utils/r-362/r-362.cbl \
--env r-452 \
--validate recipes/utils/r-362/validate/validate.sh \
--containers docker,singularity
```