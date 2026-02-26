# Prov-GigaPath

Code Repo: https://github.com/prov-gigapath/prov-gigapath
Nature paper: https://www.nature.com/articles/s41586-024-07441-w

Notes:
Fairly old, uses both a requirements.txt and an environment.yaml that are well formed.


srun --pty -t 1:00:00 -p gpudev --gres=gpu:1 bash

```
code/coble build \
--recipe recipes/papers/ProvGigaPath/ProvGigaPath.cbl \
--validate recipes/papers/ProvGigaPath/validate.sh \
--env ProvGigaPath \
--rebuild

code/coble build \
--recipe recipes/papers/ProvGigaPath/pgp.cbl \
--env pgp \
--validate recipes/papers/ProvGigaPath/validate.sh \
--rebuild
```

# Accessing hugging fact through time

# add to the .bashrc
export HF_TOKEN=hf_**********


hf auth login
import timm
model = timm.create_model("hf_hub:prov-gigapath/prov-gigapath", pretrained=True)

