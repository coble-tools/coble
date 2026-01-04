# Basic COBLE Recipe

The basic template for a coble environment has the major package managers that you are likely to need in a simple environment. To get the template, and then to create the environment, simply:

```bash
coble recipe --recipe basic/basic.cbl --flavour basic
coble build --recipe basic/basic.cbl --env coble-basic-env
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
r-package:
  - ggplot2
pip:
  - requests
```
Outputs are:

## log and output files

**Interim**  
- **myinput.cbl.recipe.sh** - the cbl transformed into a pure bash script that could be run instead  
- **myinput.cbl.recipe.sh.delta.sh** - the change in bash that will be run (for updates and resume)  
- **myinput.cbl.recipe.sh.done.sh** - each bash line that has  succesfull completed in the environment  
- **myinput.cbl.recipe.sh.old.sh** - backed up when new recipe created  
**Logs and tracking**  
- **myinput.cbl.recipe.sh.log** - each bash line cleans the log file so you can track the current stdout  
- **myinput.cbl.recipe.sh.err** - each bash line cleans the err file so you can track the current stderr  
- **myinput.cbl.recipe.sh.summary.txt** - after each install the logs are parsed for important info eg errors or dependencies. This is output along with the timings  
**Catured environment**  
- **myinput.cbl.recipe.sh.capture.cbl** - The environment is captured, all packages and libs and versions, for reproducibility this could be used to recreate the environment  
