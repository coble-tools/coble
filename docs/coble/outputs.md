# Anatomy of a the outputs of a coble build

This page describes the files that are output as part of a coble build.

When a coble build is run, coble creates a number of files and directories to manage the environment being built. For a recipe file called `my-recipe.cbl`, these are:

- The environment directory itself, which contains the installed packages and dependencies. This is as per a standard conda environment creation, using --name to specify the environment name, or --prefix to specify a folder path automatically depending on whether --env is a path or a name.  When the environment is activated this can be found from the environment variable `CONDA_PREFIX`. e.g. `echo $CONDA_PREFIX`  
  
- A `coble-lock.yaml` file, which records the exact versions of all packages and dependencies installed in the environment. This file is crucial for reproducibility, as it allows users to recreate the same environment in the future.  

- A `coble-log.txt` file, which contains a detailed log of the build process, including any errors or warnings encountered during installation.

- Optionally, a `coble-delta.yaml` file, which records the differences between the current build and the previous build. This file is useful for tracking changes to the environment over time. 



