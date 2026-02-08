
```bash
code/coble build \
--recipe recipes/utils/r-360/r-360.cbl \
--env r-360 \
--validate recipes/utils/r-360/validate/validate.sh \
--rebuild

code/coble build \
--recipe recipes/utils/r-360/r-360.cbl \
--env r-360 \
--validate recipes/utils/r-360/validate/validate.sh \
--containers docker,singularity
```