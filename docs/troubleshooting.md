# Conda Error Troubleshooting

Errors plague the building of conda environments. The default behaviour of `COBLE` is to exit immediately on an error and give the opportunity to fix it. Additionally `COBLE` has built in by default build tools that are commonly the cause of compilter errors.

Generally it is best to install with conda if possible, and then install.packages/BiocManager/pip if not. However note that when moving up to a new version of R the packages may not have been created for conda so you then need to fall back to the native R. This may mnean that to keep a recipe consistent you may want to make it native R instread of conda.

Here follows some common errors, why and how to fix them.  

# Initial errors
Sometimes initial errors indicate you are trying to create a conda environment on top of an old one. Do some aggressive cleaning, e.g.
```bash
# First, make sure you're NOT in the environment
conda deactivate
# Delete the environment
conda env remove -n my-env
# Or use the full path:
conda env remove -p /path/to/my-env
# And/Or use the file path
rm -rf /path/to/my-env
# Verify it's gone
conda env list
``` 

# Conda dependencies





# New R version - bioconductor not built


# BiocManager needs underlying conda libs


# Missing compiler tools

# Error message about package correcption
```
SafetyError: The package for r-base located at /home/ralcraft/miniconda/pkgs/r-base-4.4.2-hc737e89_2
appears to be corrupted. The path 'lib/R/doc/html/packages.html'
```
Delete the corrupted package it will be recreated:
```
rm -rf /home/ralcraft/miniconda/pkgs/r-base-4.4.2-hc737e89_2
```


# API limit
github python search result: {"message":"API rate limit exceeded for ...}
Set a github PAT access token in your bashrc. Append to the end:

```bash
export GITHUB_PAT="ghp_your-bash-token"
```


# GLIBC compatibility issues (HPC)
```bash
Error: package or namespace load failed for 'arrow' in dyn.load(file, DLLpath = DLLpath, ...):
 unable to load shared object '/data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/CBL/env-cbl/lib/R/library/00LOCK-arrow/00new/arrow/libs/arrow.so':
  /data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/CBL/env-cbl/lib/R/library/00LOCK-arrow/00new/arrow/libs/arrow.so: 
  undefined symbol: __libc_single_threaded
Error: loading failed
Execution halted
ERROR: loading failed
* removing '/data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/CBL/env-cbl/lib/R/library/arrow'
```
To skip an unneeded dependency load the package manually, or use conda:
```yaml
bash:
  - Rscipe -e 'install.packages("tidyverse", dependencies = c("Depends", "Imports"))'
r-conda:
  - arrow
```

# Missing header files (archived versions)
Trying to install an archived version for backwards compatibility can be hard. e.g. maptools is retired along with its dependecies. Modern installations of sp do not have header files so to get the installation you need to install version 1.6.0

```bash
using C compiler: ‘x86_64-conda-linux-gnu-cc (conda-forge gcc 15.2.0-16) 15.2.0’
using C++ compiler: ‘x86_64-conda-linux-gnu-c++ (conda-forge gcc 15.2.0-16) 15.2.0’
In file included from init.c:3:
rgeos.h:59:10: fatal error: sp.h: No such file or directory
   59 | #include "sp.h"
      |          ^~~~~~
compilation terminated.
make: *** [/home/ralcraft/miniconda/envs/452/lib/R/etc/Makeconf:204: init.o] Error 1
ERROR: compilation failed for package ‘rgeos’
```
I had to keep tryuing version sof sp until I found one that had header files and installed with `R4.5.2` 2.1.2 at `https://cran.r-project.org/src/contrib/Archive/sp/sp_2.1-3.tar.gz`.

