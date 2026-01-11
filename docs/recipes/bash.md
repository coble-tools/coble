# Bash COBLE Recipe

The bash template is to demonstrate that you can free form bash as you like in the recipe file. You are best to keep the initial headers for channel and perhaps build tools if you are using a conda environment. The advanrage of keeping to the coble recipe format is that you can use the `coble build` command to create the environment, and it will track what has been installed and only install changes when you run it again. This is especially useful for large environments where you may be adding or changing a few lines at a time.

This example exactly replicates the `basic` recipe in bash and produces the saame environment.

```bash
coble template --recipe bash.cbl --flavour bash
coble build --recipe bash.cbl --env coble-bash-env
```

### Input recipe yaml
Note this shows the `  - ` is removed so you can have it or not for the bash lines.
If you write the bash like this the "delta" bash script will work for updates, ensuring only different lines are run.

You can see that the `cbl` format is more compact!

<details>
<summary>bash.cbl version of basic.cbl</summary>

```yaml
#####################################################
# COBLE:Reproducible environment: BASIC, (c) ICR 2026
#####################################################
coble:
  - environment: bash
channels:
languages:
bash:
# Channels section
conda config --env --set channel_priority strict
conda config --env --add channels defaults
conda config --env --add channels r
conda config --env --add channels bioconda
conda config --env --add channels conda-forge
# languages:
conda install -y  'conda-forge::python=3.13.1'
conda install -y  -c conda-forge 'r-base=4.3.1'
# flags:
# Flag: Directive: dependencies, Value: na
# Flag: Directive: system-tools, Value: false
# Flag: Directive: compile-tools, Value: true

# Language compile tools
conda install -y --no-update-deps -c conda-forge 'gcc_linux-64=13.1' 'gxx_linux-64=13.1' 'gfortran_linux-64=13.1'
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
