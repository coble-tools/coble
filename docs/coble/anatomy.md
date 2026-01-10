# Anatomy of a coble recipe file

This page describes the required and optional sections and layours of a coble `.cbl` file.

The format looks like yaml, but due to most of the file being sequential and optionally repeatable, it is not valid yaml. The file uses yaml like headers to indicate sections and directives for familiarity.

## Beginning sections
Although free bash can be used for much of the file, it is worth noting the required sections at the start of the file that are set up for the use case of creating a python and R versioned environment. To this end the required starting sections are the `coble:` directove so it knows to process the file, the `channels:` section so it knows where to find packages, and the `languages:` section so it knows which language versions to set up first. Optionally before `languages:` there can be a `flags:` section for environment variables and conda dependency inputs.

```yaml
coble:
  - environment: coble-env-anatomy
channels:
  - bioconda
  - conda-forge
flags:
  - dependencies: NA
  - priority: strict  
languages:
  - python=3.13.1@conda-forge
  - r-base=4.3.1@conda-forge
```
Note that the order of channels is important - the last channel has the highest priority. `strict` priority is the best practice for building reproducible conda environments, however it can lead to conflicts with some installs as versions become archived so some movement of the channels may be needed as per flags section below. 
There is a maximum of 1 version of R and 1 version of python allowed in the languages section. Other languages may be specified later.

## Sequential sections
After the initial sections, the rest of the file is made up of sequential sections that are processed in order. There are flags and package managers available.

### flags
Flags set environment variables or conda install options for the following sections. They remain in effect until changed by another flags section.
```yaml
flags:  
  - system-tools: true
  - compile-tools: 13.1
  - compile-paths: true
```
This first set you would only need once at the start to ensure that build tools are available for any subsequent package installs that need compiling.
The following flags can be set:
- `system-tools:` if set to true it installs common system tools such as wget, curl, build-essential, make, gcc, g++, cmake, git, unzip, tar, vim, nano.
- `compile-tools:` if set to a version number it installs conda build tools for that version, e.g., `13.1` for conda-build 13.1. If `true` it allows conda to install the best choice. It also sets environment variables to ensure the compilers point to the conda installed tools.
- `compile-paths:` if set to true it sets up environment variables such as `C_INCLUDE_PATH`, `CPLUS_INCLUDE_PATH`, `LIBRARY_PATH`, and `LD_LIBRARY_PATH` to the conda paths - but nothing is installed. This is a lesser version of `compile-tools` which installs and sets the paths so you would not also need this.

```yaml
flags:
  - dependencies: NA
  - priority: strict
  - channel: conda-forge
  - export: VAR_NAME=VALUE
  - updates: false         
```
This second set you may lay sequentially as necessary throughout the file to modify the behavior of the package managers.
- `dependencies:` are for conda and r packagae managers. They can be set to `NA` which for R means only required dependcies not suggested, and conda means required dependencies, `true` no difference for conda, and also r suggestions,or `false` no dependencies - this is used in the frozen file for maximum reproducibility.  
- `priority:` can be set to `flexible` (default conda priority), `strict` (strict conda priority), or `highest` (highest conda priority).
- `channel`: sets the specifed conda channel to the top priority for the following sections.  
- `export`: sets environment variables inside conda using `conda env config vars set VAR_NAME=VALUE`. These will automatically be activated when activating the environment.  
- `updates`: not a recommended option, if set to it allows updates of packages. The default is false --no-update-deps' for conda installs to avoid changing the R or python versions. Note that as an automated tool choices are not given interactively.  

### Package manager sections
Each section starts with a header indicating the package manager or type of install to be done. The section header is followed by a list of packages to be installed using that package manager or method. The supported section headers are:
- `conda:` - for conda packages  
- `r-conda:` - for R packages installed via conda  
- `r-package:` - for R packages installed via R's install.packages(). Note if a version is specified it automatically uses `remotes::install_version` rather than `install.packages`  
- `bioc-conda:` - for Bioconductor packages installed via conda  
- `bioc-package:` - for Bioconductor packages installed via BiocManager  
- `pip:` - for python packages installed via pip  
- `r-github:` - for r packages installed from GitHub repositories  
- `r-url:` - for packages installed from any archive url (e.g., tar.gz, zip)  

Note that for r-conda and bioc-conda are just a way of prepending the name with "r-" or "bioconductor-". This however is useful if trying out different package managers, it means not having to edit the package names.  
Examples for these inputs:
```yaml
conda:
  - pandas
  - cairo=1.14.12@defaults
r-conda:
  - cairo
bioc-conda:
  - celldex
  - affy=1.64.0@bioconda
r-package:
  - packcircles
  - Matrix=1.3-3
bioc-package:  
  - infercnv
  - BiocVersion=3.10.1
r-github:
  - r-forge/countreg@pkg
r-url:
  - https://github.com/Nik-Zainal-Group/signature.tools.lib/archive/refs/heads/master.zip
pip:
  - requests
```

### Bash
- `bash:` - for raw bash commands to be executed. This can be after a `  -` tag or just straight after the `bash:` header as normal text. The entire block is treated as bash commands to be executed in sequence. Note that although it is raw bash `COBLE` is intended for a specified p[urpose ofcreating environments so using `ls` and `echo` could be relatively meaningless. The output files specifically parse the logs for errors and package installs so using bash for other purposes may confuse the outputs. However, it is useful for bespoke commands such as downloading files or running scripts that are not available via the other package managers.]
```yaml
bash:  
  - wget https://example.com/somefile.tar.gz -O /path/to/destination
# Or just write at the start of the line
export VAR_NAME=VALUE
```

## Bash recipe file
The coble recipe file is turned into a bash recipe file, so there is no doubt for you at all what is being executed. This recipe file is executed line by line. When you make changes to the environment a delta file is created, so olnly different lines are executed. This is for the use case of creating and adapting an environment over time and ensuring it remains tracked. This is similar to `from-history` in conda, but more explicit and transparent as it is literal bash comamands, and it is handling bash and miced packages.

For a coble recipe file like this:
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

The bash recipe file would look like this:
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