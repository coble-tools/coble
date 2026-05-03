


```
code/coble build --recipe recipes/papers/Zheng2017/Zheng2017.cbl --env Zheng2017 -- rebuild
```

singularity shell /home/ralcraft/DEV/gh-rse/BCRDS/coble/cbl-zheng20172.sif

docker run --rm -it \
-v .:/workspace -w /workspace \
cbl-zheng20172