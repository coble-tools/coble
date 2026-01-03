<img src="coble.png" alt="COBLE logo" width="200" style="float: right; margin-right: 20px; margin-bottom: 10px;" />

# COBLE: COnda BuiLdEr

COBLE is a tool to build and manage mixed conda environments from multiple package managers, developed at the Institute of Cancer Research by the *Research Software Engineering* team for, and with, the *Breast Cancer Research Data Science* group.

### Overview

The recipe definition of your environment can be composed of 4 main package managers:
- R package installation
- Bioconductor package installation
- Conda package installation
- Pip package installation
Archive installation and github instllation also possible, along with raw bash commands for anythong bespoke. There are flags to include the most common build tools and environment variables automatically to simplify the setup.

A simple recipe could look like this (file is `my-recipe.cbl`):
```yaml
coble:
  - environment: coble-env-versions
channels:
  - bioconda
  - conda-forge
languages:
  - python=3.13.1@conda-forge
  - r-base=4.3.1@conda-forge
conda:  
  - pysam
r-package:
  - ggplot2
pip:
  - NumPy  
```

To build this there is the command `build`. If you want to start or add to an existing environment use `build`, to completely clean and start again use `build` with the additional flag `--rebuild`. To be safe and as environments evolve using `build` ensures time saving - it create a "delta" file and only installs changes. Do ensure that `build` can be run with `--rebuild` in full so that the environment can be recreated if needed.

```bash
coble build --input my-recipe.cbl --env my-env
```

---  

## Additional Information

- The environment (`--env`) can be either a name or a folder path. COBLE will automatically use `--name` or `--prefix` as appropriate.
- If you specify more than one R or more than one Python version in the language block, COBLE will complain and refuse to continue. Otherwise, it will create a special language block in the cbl.
