# Writing Recipes for COBLE

COBLE recipes are simple bash scripts that define the steps to build your environment. You can use any valid bash command in a recipe, giving you full flexibility to customize your build process.

## General Guidelines

- **Environment Variables:**  

COBLE automatically creates and exports several environment variables for use in your recipes and scripts:

- `COBLE_R_VERSION`: The version of R being used in the environment.
- `COBLE_PYTHON_VERSION`: The version of Python being used in the environment.
- `CONDA_COBLE_ENV`: The full path to the conda environment prefix (used for activation and as a base for R library paths).

These variables are available in your recipe scripts, so you can reference them directly for flexible and reproducible builds. For example:

```bash
conda create -y -p ${CONDA_COBLE_ENV} r-base=${COBLE_R_VERSION} python=${COBLE_PYTHON_VERSION}
conda activate ${CONDA_COBLE_ENV}
```

This ensures your scripts are portable and can be reused for different environment versions or locations simply by changing the input parameters.

- **No prompts:** Ensure your commands do not require user interaction. For example:
  - Use `-y` with `conda install` to auto-confirm installations.
  - For R packages, always specify the `repos` argument to avoid prompts:
    ```bash
    Rscript -e "install.packages('mypackage', repos='https://cloud.r-project.org')"
    ```
- You can mix and match conda, R, Python, and shell commands as needed.

## Special Directives
COBLE supports two special directives to simplify and robustly handle R and Bioconductor package installation:

- **`coble@r@`**
  - Example: `coble@r@ dplyr ggplot2`
  - Tries to install the listed R packages via conda first. If that fails, it falls back to installing them with R's `install.packages()`.

- **`coble@bioc@`**
  - Example: `coble@bioc@ edgeR limma`
  - Tries to install the listed Bioconductor packages via conda first. If that fails, it falls back to installing them with `BiocManager::install()` in R.

This approach lets you test the availability of packages and their dependencies in conda, and automatically fall back to R/Bioconductor if needed.

## Error Handling: Fail Mode and --skip-errors

By default, COBLE will stop execution and exit immediately if any command in your recipe fails. This strict fail mode ensures you are alerted to problems as soon as they occur, making it easier to debug and fix issues early.

If you want the script to continue running even when some commands fail, you can use the `--skip-errors` flag when launching COBLE. With this flag enabled:

- Errors are logged, but the script continues to execute the remaining lines in your recipe.
- This is useful for testing large builds, or when you want to see which steps succeed or fail in a single run.
- Skipped errors are clearly marked in the output logs for later review.

**Example usage:**

```bash
sbatch code/coble-slurm.sh --results results/myrun --input config/myrecipe.sh --env ./envs/myenv --skip-errors
```

Choose the mode that best fits your workflow: strict fail-fast for reproducibility and debugging, or skip-errors for exploratory or batch builds.

Where the error mode is used the error is reported at the end of the recipe.sh file, the problem can be corrected and the build can be re-run, it will pick up from the last successful step.

## Using Local Packages: --override-envs Flag

COBLE supports a flag to use local package directories for both R and Conda: `--override-envs`. By default, this is set to `false`, meaning that the locations that are set through the .condarc and r installation are used. 

When you pass `--override-envs`, COBLE will use local a package dir for r and conda local to the installation inline with the environment prefix, eg if the environment prefix is `/folder/my_env` then the rlib will be `/folder/my_env_rlibs` and the conda lib will be `/folder/my_env_pkgs`. This option ensures compelte isolation for the whole environment but is not storage friendly. It is particularly good for container builds. 

**Example usage:**

```bash
sbatch code/coble-slurm.sh --results results/myrun --input config/myrecipe.sh --env ./envs/myenv --override-envs
```

If you do not specify this flag, COBLE will use the defaults. The .condarc settings are saved in the results folder.

## Example Recipe
```bash
# Create environment
conda create -y -p ${CONDA_COBLE_ENV} r-base=4.5.2 python=3.14.0
conda activate ${CONDA_COBLE_ENV}

# Install conda packages
conda install -y r-data.table --no-update-deps

# Install R packages (with repos flag)
Rscript -e "install.packages('gdata', repos='https://cloud.r-project.org')"

# Use special directive for robust install
coble@r@ dplyr ggplot2
coble@bioc@ edgeR limma
```


