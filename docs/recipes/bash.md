# Basic COBLE Recipe

The basic template for a coble environment has the major package managers that you are likely to need in a simple environment. To get the template, and then to create the environment, simply:

```bash
coble recipe --input basic/basic.cbl --flavour basic
coble build --input basic/basic.cbl --env coble-basic-env
```

The environment is set to the given R and python versions and allows the other versions to be found accordingly. By default the conda intsalls are done with `--no-update-deps` so there is no risk of the R or python version changing during set up.

For a simple environment you can modify this to suit your needs.  

Once created, there is a capture file with the specific versions of all the libraries loaded in the environment.

During creation there are some outputs, for the given input `myinput.cbl`:

### Input recipe yaml
```yaml
#####################################################
# COBLE:Reproducible environment: BASIC, (c) ICR 2025
#####################################################
coble:
  - environment: coble-env-basic
channels:
# note the reverse order of priority
  - defaults
  - r
  - bioconda
  - conda-forge
languages:
  - python=3.13.1@conda-forge
  - r-base=4.3.1@conda-forge
conda:
  - pandas
r-conda:
  - tidyverse
r-package:
  - ggplot2
pip:
  - requests
```
