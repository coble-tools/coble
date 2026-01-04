# Bash COBLE Recipe

The bash template os just to deoonstarte that you can free form bash as you like in the recipe file. You are best to keep the initial headers for channel and perhaps build tools if you are using a conda environment.


```bash
coble recipe --recipe bash.cbl --flavour bash
coble build --recipe bash.cbl --env coble-bash-env
```

### Input recipe yaml
Note this shows the `  - ` is removed so you can have it or not for the bash lines.
If you write the bash like this the "delta" bash script will work for updates, ensuring only different lines are run.

```yaml
coble:
  - environment: coble-env-bash
channels:
# note the reverse order of priority
  - defaults
  - r
  - bioconda
  - conda-forge
languages:
  - python=3.13.1@conda-forge
  - r-base=4.3.1@conda-forge
bash:
python -m pip install pandas
  - Rscript -e "install.packages('ggplot2', repos='https://cloud.r-project.org/')"
```
