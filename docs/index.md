<img src="coble.png" alt="COBLE logo" width="200" style="float: right; margin-right: 20px; margin-bottom: 10px;" />

# COBLE: COnda BuiLdEr

COBLE is a tool to build and manage mixed conda environments from multiple package managers, developed at the Institute of Cancer Research by the *Research Software Engineering* team for, and with, the *Breast Cancer Research Data Science* group.

### Overview

COBLE combines intent and outcome as the paradigm for reprodicible computational environments. There is an input recipe, and an output recipe, with the environment built in between. The input recipe is a simple `cbl` file that describes the desired environment in terms of mixed package managers and versions, channel priorites, bash installs, enviroment variables etc... The output recipe is a frozen version of the environment that can be used to recreate it exactly. The intent describes what is important and intentional about the environment and is the preferred method for recreation, but the frozen recipe ensures that the environment can be recreated exactly if needed.

The recipe definition of your environment can be composed of 4 main package managers:
- R package installation
- Bioconductor package installation
- Conda package installation
- Pip package installation
Archive installation and github instllation also possible, along with raw bash commands for anythong bespoke. There are flags to include the most common build tools and environment variables automatically to simplify the setup.

### The Four Functions
**Build**: Create or update an environment from a recipe file.
```bash
coble build --recipe my-recipe.cbl --env my-env
```
--- Optional arguments:
- `--alias` <exe>: Can pass in an alternative solver to conda eg mamba or a path.
- `--containers` <docker,singularity,apptainer,conda>: default is conda, comma delim list of containers.
- `--rebuild`: Clean and rebuild the environment from scratch.
- `--skip-errors`: continue building even if some packages fail to install. Default behaviour os to exit and promt you to fix.
- `--include-r-forge`: include R-Forge when looking for packages as URLs through `find:` - by default it is turned off as it is slow.
- `--debug`: keep all interim log files.

**Freeze**: Freeze an existing environment into a coble recipe file.
```bash
coble freeze --frozen my-frozen-env.cbl --env my-env
```
--- Optional arguments:
- `--env`: Active environment is frozen if not specified.
- `--debug`: keep temporary files for each package manager for debugging.

**Network**: Create a network dependency graph
```bash
coble betwork --frozen my-frozen-env.cbl --env my-env
```
--- Optional arguments:
- `--env`: Active environment is frozen if not specified.
The output is to the same folder as the input, frozen, called:  
- `<env>_network_interactive.html` : an interactive dependdency explorer
- `<env>_dependencies.txt` : the data for the dependency viewer
- `<env>_network_stats.txt` : some info on the network


**Template**: Generate a template recipe file to start from.
```bash
coble template --recipe template-recipe.cbl --flavour basic
```

### A coble recipe file
A simple recipe could look like this (`my-recipe.cbl`):
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
coble build --recipe my-recipe.cbl --env my-env
```

# Freeze an environment
Freeze an environment and it will store the versions and the channels used to create it. This is useful for reproducibility and for sharing environments. To freeze an environment use the `freeze` command:
```bash
coble freeze --frozen my-frozen-env.cbl --env my-env
```
# Get a template to start from
Start off from one of the pre-prepared templates to get going quickly. For example to get the basic template use:
```bash
coble template --recipe template-recipe.cbl --flavour basic
```
---  

## Additional Information

- The environment (`--env`) can be either a name or a folder path. COBLE will automatically use `--name` or `--prefix` as appropriate.
- If you specify more than one R or more than one Python version in the language block, COBLE will complain and refuse to continue. Otherwise, it will create a special language block in the cbl.
