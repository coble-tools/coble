


```bash
code/coble build --recipe recipes/papers/Zheng2017/Zheng2017.cbl --env Zheng2017 -- rebuild

code/coble build \
--recipe recipes/papers/zheng2017/zheng2017.cbl \
--env zheng2017 \
--containers docker,singularity \
--code-source local \
--ubuntu 16.04 \
--validate recipes/papers/zheng2017/validate.sh

Rscript -e 'install.packages("stringr", repos="https://packagemanager.posit.co/cran/2017-10-10", dependencies=NA, Ncpus=8)'
```
singularity shell /home/ralcraft/DEV/gh-rse/BCRDS/coble/cbl-zheng20172.sif

docker run --rm -it \
-v .:/workspace -w /workspace \
cbl-zheng20172