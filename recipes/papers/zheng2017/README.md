


```bash
code/coble build --recipe recipes/demos/zheng2017/zheng2017.cbl --env zheng2017 -- rebuild

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

code/coble-disentangle.py recipes/demos/zheng2017/zheng2017_export.cbl recipes/demos/zheng2017/zheng2017_network.txt
python code/coble-plot-network.py recipes/demos/zheng2017/zheng2017_network.txt --hue date --out recipes/demos/zheng2017/zheng2017_network.html