# Chief
Code repo: https://github.com/hms-dbmi/CHIEF?tab=readme-ov-file
Nature paper: https://www.nature.com/articles/s41586-024-07894-z
Docker image: https://hub.docker.com/r/chiefcontainer/chief


## Using their docker image
```bash
docker pull chiefcontainer/chief:v1.11
docker run --rm -it --entrypoint /bin/bash chiefcontainer/chief:v1.11

```

```
code/coble build \
--recipe recipes/papers/CHIEF/chief.cbl \
--env chief \
--validate recipes/papers/CHIEF/validate/validate.sh \
--val-folder recipes/papers/CHIEF/validate \
--containers conda \
--rebuild
```