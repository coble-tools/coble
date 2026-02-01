# Testing in a docker arm64 image

## Create docker image to persist
```bash
# Create a named ARM64 container
docker run --platform linux/arm64 -it \
  --name arm64-test \
  -v /home/ralcraft/DEV/gh-rse/BCRDS/coble:/workspace \
  condaforge/mambaforge:latest \
  /bin/bash
```

## Running it again
```bash
docker start -ai arm64-test
```
