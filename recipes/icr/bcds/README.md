# Build for conda
```bash
code/coble build --recipe recipes/icr/bcrds/bcrds.cbl \
--env $recipe \
--validate recipes/utils/bcrds/validate/validate.sh \
--val-folder recipes/utils/bcrds/validate/ \
--rebuild
```