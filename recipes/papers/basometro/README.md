# Analyzing parliamentary voting dynamics using multiple aspects trajectory clustering approach

Code Repo: https://github.com/Yuri-Nassar/mat-basometro
Publication: https://link.springer.com/article/10.1140/epjds/s13688-025-00609-y


```
code/coble build \
--recipe recipes/papers/basometro/basometro.cbl \
--env basometro \
--validate recipes/papers/basometro/validate/validate.sh \
--val-folder recipes/papers/basometro/validate \
--rebuild
```

```
docker run --rm -it -v .:/workspace \
ghcr.io/coble-tools/coble:papers-basometro
```

```
docker run -p 8888:8888 ghcr.io/coble-tools/coble:papers-basometro bash -c "
    /opt/conda/envs/basometro/bin/python -m ipykernel install \
        --name=mat-basometro \
        --display-name='Python (mat-basometro)' \
        --prefix=/opt/conda/envs/basometro && \
    /opt/conda/envs/basometro/bin/jupyter lab \
        --ip=0.0.0.0 \
        --port=8888 \
        --no-browser \
        --allow-root \
        --ServerApp.token='' \
        --ServerApp.password='' \
        --notebook-dir=/opt/conda/envs/basometro/GitHub/mat-basometro
"
```
