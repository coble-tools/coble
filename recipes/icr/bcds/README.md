# Build for conda
```bash
code/coble build --recipe recipes/icr/bcds/bcds.cbl \
--env bcds \
--validate recipes/utils/bcds/validate/validate.sh \
--val-folder recipes/utils/bcds/validate/ \
--rebuild
```