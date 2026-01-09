# Conda Error Troubleshooting

Errors plague the building of conda environments. The default behaviour of `COBLE` is to exit immediately on an error and give the opportunity to fix it. Additionally `COBLE` has built in by default build tools that are commonly the cause of compiler errors.

Generally it is best to install with conda if possible, and then install.packages/BiocManager/pip if not. However note that when moving up to a new version of R the packages may not have been created for conda so you then need to fall back to the native R. This may mean that to keep a recipe consistent fort some of the installs you may want to make it native R instead of conda. Or, change the blocks as needed, which is why `r-conda` and `bioc-conda` have been given as directives tio avoid name changes when maving package managers.

Here follows some common errors, why and how to fix them.  

## Initial errors
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

## New R version - bioconductor not built
You may need to change from `bioc-conda` to `bioc-package` when a new version of r comes out, and potentially solve some dependencies. Some of the packages will not pull in dependencies from others, so for example Biocmanager will need you to explicitly make some conda installs. R-Forge packages will not pull in cran. Look at the tutorial for [fixing countreg](countreg.md).

## Missing compiler tools
Most are installed if you set the compile-tools and system-tools flag to true. Different versions of operating systems and code may have dependencies on old or newer compilers, so instead of just true you can specify a version eg `13.3.0`. 

For more bespoke compiler issues, you can use an environment variable in the flags, or set through bash, or explicitly set a more permissive compiler warning like:
```bash
bash:
  - CFLAGS="-Wno-error=incompatible-pointer-types" python -m pip install --no-build-isolation git+https://github.com/rachelicr/pysamstats.git
```

## Error message about package corruption
```
SafetyError: The package for r-base located at /home/ralcraft/miniconda/pkgs/r-base-4.4.2-hc737e89_2
appears to be corrupted. The path 'lib/R/doc/html/packages.html'
```
Delete the corrupted package it will be recreated:
```
rm -rf /home/ralcraft/miniconda/pkgs/r-base-4.4.2-hc737e89_2
```

# API limit
This message will haunt younif you don;t fix it properly. It is possible to get around it by installing from url and setting depednecies to False and then manually installing all dependencies. Far better in the long run to get a GitHub PAT token. The error you will seee is `{"message":"API rate limit exceeded for ...}`.  
Best solution is to set a github PAT access token in your bashrc. Append to the end:

```bash
export GITHUB_PAT="ghp_your-bash-token"
```

## GLIBC compatibility issues (HPC)
It would be a last resoirt for me to skip a dependency I didn;t need rather than resolve it. COBLE is punitive and will fail until the error is ressolved by you one way or another (though you can choose to use the `--skip-errors` flag).  
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
To skip an unneeded dependency load the package manually without it, or use upi may be able to use conda:
```yaml
bash:
  - Rscipe -e 'install.packages("tidyverse", dependencies = c("Depends", "Imports"))'
r-conda:
  - arrow
```

## Missing header files (archived versions)
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
I had to keep ryuing versions of sp until I found one that had header files and installed with `R4.5.2` 2.1.2 at `https://cran.r-project.org/src/contrib/Archive/sp/sp_2.1-3.tar.gz`.

