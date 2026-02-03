# Testing in a docker arm64 image

## Create docker image to persist
```bash
# Create a named ARM64 container
docker run --platform linux/arm64 -it \
  --name arm64-test \
  -v /home/ralcraft/DEV/gh-rse/BCRDS/coble:/workspace \
  -w /workspace \
  -e BASH_ENV=/opt/conda/etc/profile.d/conda.sh \
  condaforge/mambaforge:latest \
  bash --noprofile
```

## Running it again
```bash
docker start -ai arm64-test
docker update --cpus="4.0"
```

# OR AMD testing locally
```bash
docker run --platform linux/amd64 -it \
  --name amd64-test \
  -v /home/ralcraft/DEV/gh-rse/BCRDS/coble:/workspace \
  -w /workspace \
  -e BASH_ENV=/opt/conda/etc/profile.d/conda.sh \
  condaforge/mambaforge:latest \
  bash --noprofile
```

```bash
docker start -ai amd64-test
docker update --cpus="4.0"
```