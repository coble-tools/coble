
```bash
code/coble build \
--recipe recipes/utils/empty/empty.cbl \
--env empty \
--validate recipes/utils/empty/validate/validate.sh \
--rebuild

code/coble build \
--recipe recipes/utils/empty/empty.cbl \
--env empty \
--validate recipes/utils/empty/validate/validate.sh \
--containers docker,singularity
```