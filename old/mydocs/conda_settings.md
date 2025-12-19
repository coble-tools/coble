The settings for conda will impact how it builds. These are the recommendations:

Comment from Syed:Set channel priority to strict (recommended for reproducibility)
BUT having to test flexible. There is reproducible and recreatible, testing a recreatible script. The env will always be REPRODICIBLE by using it :-) OR this setting perhaps can be changed for a pinned version build. but the nightly build needs some flexibility.
To decide.

My ~/.condarc:
```
# Conda configuration for remote server
# Specify environment directories (in priority order)
envs_dirs:
  - /data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/.conda_simlink/envs
# Specify package cache directories
pkgs_dirs:
  - /data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/.conda_simlink/pkgs
# Channel priority
channels:
  - conda-forge
  - bioconda
  - https://conda.anaconda.org/dranew
  - defaults
# Don't auto-activate base environment
auto_activate_base: false
# Set channel priority to strict (recommended for reproducibility)
channel_priority: flexible
env_prompt: '({name}) '
ssl_verify: false
```