# Anatomy of a the outputs of a coble build

This page describes the files that are output as part of a coble build. Imagine we are running `COBLE` for a recipe file called `example.cbl`.

## 0) example.cbl

<details>
<summary>example.cbl</summary>
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
flags:
  - dependencies: NA
  - system-tools: False
  - compile-tools: True  
conda:
  - pandas
r-conda:  
  - ggplot2
bioc-conda:
  - fgsea
r-package:
  - dplyr
```
</details>

When a coble build is run, coble creates a number of files and directories to manage the environment being built. For a recipe file called `my-recipe.cbl`. Some of them you can consider crucial outputs for the reprodicible environment, and some are interim files that help coble manage the build process. In order, these are:

## 1) example.cbl
Yep this is the same file. It will be written back to a number if times as you build if it has find directives in it, so this file is itself the first output. When there are issues with this file that mean that the process cannot proceed you will get 2 possible messages:

**find: directive**  
`[coble] Finds were resolved, please check the yml input before resuming.`  
A find directive is a powerful way of quickl;y editing a `cbl` recipe to search for a package locatrion and have the optons a variety of package managers written back in place (see the [find documentation](finding.md) for more details or the [sylver tutorial](../tutorials/sylver.md)). When finds are resolved the `cbl` is updated in place with `found|` annotation and you are prompted to check the file before resuming the build. The build cannot resume until resolved. It is important to note that the decision was made not to guess where the packages you want are, but to present you with all found options to make the edit yourself.  

**valid `COBLE`**  
`[coble] CBL rationalisation failed, please check the yml input before resuming.`  
A certain amount of formatting is required, specifically the presence of the blocks, in order: `coble:`, `channels:`, `languages:`. You will be promted to fix the recipe before it can resume.  

## 2) example.sh
This is the bash script that is generated from the `cbl` file. It contains all the commands that will be run to create the environment. You can run this script directly if you want, but it is recommended to use `coble build` to ensure that the environment is created correctly with all the tracking files described here for reproduction and depency tracking. The .sh file gives you full confidence on what is taking place in the creation of yuor environment. It includes a number of additions simpified in the `cbl` file such as error checking, build tools, environment variables, channel cleaning, logging, and tracking of completed steps.

<details>
<summary>example.sh</summary>
```bash
#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2025
# Capture date: 2026-01-10
# Capture time: 16:20:08 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source "$(conda info --base)/etc/profile.d/conda.sh"
source ~/.bashrc
#####################################################


conda create --no-default-packages --name basic -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
conda activate basic

# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels defaults
conda config --env --add channels r
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
#####################################################
# COBLE:Reproducible environment: BASIC, (c) ICR 2025
#####################################################
# note the reverse order of priority
# languages:
conda install -y  'conda-forge::python=3.13.1'
conda install -y  -c conda-forge 'r-base=4.3.1'
# flags:
# Flag: Directive: dependencies, Value: na
# Flag: Directive: system-tools, Value: false
# Flag: Directive: compile-tools, Value: true

# Language compile tools
conda install -y --no-update-deps -c conda-forge gcc_linux-64 gxx_linux-64 gfortran_linux-64
conda install -y --no-update-deps -c conda-forge sysroot_linux-64 c-compiler cxx-compiler
# Set up compiler symlinks for R package compilation - COS6 compatibility
umask 0022
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-gfortran
# Set up compiler symlinks for R package compilation - standard aliases
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/gcc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/c++
# Set compiler flags for R package compilation
export CFLAGS="-I$CONDA_PREFIX/include"
export CXXFLAGS="-I$CONDA_PREFIX/include"
export CPPFLAGS="-I$CONDA_PREFIX/include"
export LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib"
conda env config vars set CFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set CXXFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set CPPFLAGS="-I$CONDA_PREFIX/include"
conda env config vars set LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib"

# conda:
conda install -y  --no-update-deps \
'pandas' 
# r-conda:
conda install -y  --no-update-deps \
'r-ggplot2' 
# bioc-conda:
conda install -y  --no-update-deps \
'bioconductor-fgsea' 
# r-package:
Rscript -e 'install.packages("dplyr", repos="https://cloud.r-project.org", dependencies=NA, Ncpus=4)'
```
</details>

## 3) and 4) example.delta and example.done
These files are used to track the progress of the build. The `example.delta` file contains the commands that are yet to be executed, while the `example.done` file contains the commands that have been successfully executed. This allows coble to resume the build process from where it left off in case of an interruption or error. If the first time there will be no delta file, and the done file will be populated with the entire contents of the bash recipe. Subsequent amendmetns will be checked against this file and only *different* commands will be included in the `.delta` file. It is the `.delta` file that is really executed. The done file is added to as the build progresses and commands complete successfully.  
*You do not really need  to look at these files unless you are debugging a build issue.*

## 5) and 6) stdout and stderr logs: example.log and example.err
These files capture the standard output and standard error streams of the build process. The `example.log` file contains the standard output, while the `example.err` file contains the standard error messages. These logs are useful for debugging and tracking the progress of the build. When each command starts the logs are wiped clean and recreated, so you can use these to watch the live ongoing status of the build. Additional to the messages from the package managers themselves, `COBLE` reports on memory, swapping and time, so that you are able to track any hardware and performance probelms. Conda environments can be very memory intense so it can be fristrating to find you are chasing down the wrong kind of error!

<details>
<summary>example.sh</summary>
```text
[coble-create] Running 139/571:
[coble-create] System info
[coble-create] CPU cores: 8
[coble-create] Disk usage:
Filesystem      Size  Used Avail Use% Mounted on
dssfs01          70T  6.6T   64T  10% /data
[coble-create] Memory usage:
              total        used        free      shared  buff/cache   available
Mem:          377Gi       111Gi       253Gi        14Mi        12Gi       263Gi
Swap:         8.0Gi          0B       8.0Gi
#####################################################
Rscript -e 'install.packages("spatstat", repos="https://cloud.r-project.org", dependencies=NA, Ncpus=8)'
begin installing package spatstat.model
* installing *source* package 'spatstat.model' ...
** this is package 'spatstat.model' version '3.5-0'
** package 'spatstat.model' successfully unpacked and MD5 sums checked
** using staged installation
** libs
using C compiler: 'x86_64-conda-linux-gnu-cc (conda-forge gcc 15.2.0-16) 15.2.0'
make[1]: Entering directory '/tmp/Rtmp6S8Qns/R.INSTALL3d899d5802c3c3/spatstat.model/src'
x86_64-conda-linux-gnu-cc -I"/data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/CBL/env-syed/lib/R/include" -DNDEBUG   -DNDEBUG -D_FORTIFY_SOURCE=2 -O2 -isystem /data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/CBL/env-syed/include -I/data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/CBL/env-syed/include -Wl,-rpath-link,/data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/CBL/env-syed/lib    -fpic  -march=nocona -mtune=haswell -ftree-vectorize -fPIC -fstack-protector-strong -fno-plt -O2 -ffunction-sections -pipe -isystem /data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/CBL/env-syed/include -fdebug-prefix-map=/home/conda/feedstock_root/build_artifacts/r-base-split_1766426576771/work=/usr/local/src/conda/r-base-4.5.2 -fdebug-prefix-map=/data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/CBL/env-syed=/usr/local/src/conda-prefix  -c Ediggatsti.c -o Ediggatsti.o
make[1]: Leaving directory '/tmp/Rtmp6S8Qns/R.INSTALL3d899d5802c3c3/spatstat.model/src'
installing to /data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/CBL/env-syed/lib/R/library/00LOCK-spatstat.model/00new/spatstat.model/libs
** R
** inst
** byte-compile and prepare package for lazy loading
** help
*** installing help indices
...
```
</details>

## 7) example_summary.txt
**This is a file you will want to look at and keep**. This file provides a summary of the build process, including any errors or important information extracted from the logs. It is useful for quickly assessing the success of the build and identifying any issues that may have occurred. It tracks each line of the commands run, gives the timing for how long it took, and annotates the file with ALL the dependencies installed as a result. It is designed to parse through the log files after each package installation and extract any warnings or errors that may have occurred and summarizes them. In normal mode, any errors will cause the build process to stop with a warning to fix the poroblem, and this will be recorded here.

<details>
<summary>example_summary.txt</summary>
```text
...
[coble-create] Start time: 2026-01-10 22:54:54 115/571
install: Rscript -e 'BiocManager::install("org.Hs.eg.db", dependencies=NA, Ncpus=8)'
dep: # * DONE (Biostrings)
dep: # * DONE (KEGGREST)
dep: # * DONE (AnnotationDbi)
dep: # * DONE (org.Hs.eg.db)
[coble-create] End time: 2026-01-10 22:56:15
[coble-create] Duration: 81s

[coble-create] Start time: 2026-01-10 22:56:15 117/571
install: Rscript -e 'BiocManager::install("org.Mm.eg.db", dependencies=NA, Ncpus=8)'
dep: # * DONE (org.Mm.eg.db)
[coble-create] End time: 2026-01-10 22:56:43
[coble-create] Duration: 28s

[coble-create] Start time: 2026-01-10 22:56:43 125/571
install: conda install -y  --no-update-deps  'r-tzdb'  'r-vroom'  'r-readr'  'r-readxl'  'r-rcppannoy'  'r-glmnet' 
    # All requested packages already installed.
[coble-create] End time: 2026-01-10 22:57:14
[coble-create] Duration: 30s
...
```
</details>

## 8) example.sh.bak example.cbl.bak
Due to the copying over of files in place, .bak files are created as backups of the previous version of the `cbl` and `sh` files before they are overwritten. This allows you to revert to the previous version if needed. You only get one chance at this so if you repeat the command quickly you will overwrite the backup! This is unlikely to be needed except in debugging scenarios.
