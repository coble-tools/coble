# r-360 example

Run script in docker
```bash
mkdir -p recipes_docker/utils/r-360

docker run --rm -it -v .:/workspace -w /workspace cbl-empty

cp recipes/utils/r-360/r-360.cbl recipes_docker/utils/r-360/r-360.cbl

code/coble build \
--recipe recipes_docker/utils/r-360/r-360.cbl \
--env r-360 \
--validate recipes/utils/r-360/validate/validate.sh \
--rebuild
```


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