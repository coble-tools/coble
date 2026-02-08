

```bash
# Build for conda
code/coble build --recipe recipes/icr/sylver/sylver.cbl \
--env sylver \
--validate recipes/icr/sylver/validate/validate.sh \
--rebuild
```

```bash
# Build for conda
code/coble build --recipe recipes/icr/sylver/sylver.cbl \
--env sylver \
--validate recipes/icr/sylver/validate/validate.sh \
--containers docker,singularity
```