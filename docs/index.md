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
Archive installation and github installation can also be included, along with raw bash commands for anything bespoke. There are flags to include the most common build tools and environment variables automatically to simplify the setup.

