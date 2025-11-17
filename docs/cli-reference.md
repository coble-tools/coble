# Command Line Reference

Complete reference for COBLE command-line tools.

## coble-bash.sh

Main script for building and managing conda environments.

### Synopsis

```bash
bin/coble-bash.sh [OPTIONS]
```

### Options

#### General Options

| Option | Description | Required |
|--------|-------------|----------|
| `--steps STEPS` | Colon-separated steps to execute | Yes |
| `--input FILE` | Input YAML/recipe file | Yes (for most steps) |
| `--results DIR` | Directory to store results | Yes |
| `--output FILE` | Output log file | No |
| `--error FILE` | Error log file | No |
| `--quiet y\|n` | Suppress informational messages (default: n) | No |

#### Environment Options

| Option | Description | Example |
|--------|-------------|---------|
| `--r-version VERSION` | R version to install | `4.5.2` |
| `--python-version VERSION` | Python version | `3.14.0` |
| `--env DIR` | Environment folder path | `./envs/myenv` |
| `--pkg DIR` | Package cache folder | `./pkgs/myenv` |
| `--extra VALUE` | Extra parameter for steps | varies |

#### Comparison Options

| Option | Description |
|--------|-------------|
| `--lhs-env PATH` | Left-hand environment path |
| `--rhs-env PATH` | Right-hand environment path |
| `--lhs-coble FILE` | Left-hand coble.yml file |
| `--rhs-coble FILE` | Right-hand coble.yml file |
| `--lhs-conda FILE` | Left-hand conda YAML |
| `--rhs-conda FILE` | Right-hand conda YAML |
| `--lhs-r FILE` | Left-hand R packages file |
| `--rhs-r FILE` | Right-hand R packages file |
| `--lhs-pip FILE` | Left-hand pip packages file |
| `--rhs-pip FILE` | Right-hand pip packages file |

### Available Steps

| Step | Description |
|------|-------------|
| `conda` | Use conda executable |
| `mamba` | Use mamba executable |
| `anaconda` | Use Anaconda installation |
| `create` | Create new conda environment |
| `install` | Install packages from YAML |
| `recipe` | Execute bash recipe file |
| `update` | Add packages to existing environment |
| `export` | Export environment specifications |
| `errors` | Generate error report |
| `missing` | Report missing packages |
| `convert` | Convert recipe to YAML |
| `diff` | Compare conda package versions |
| `diff-r` | Compare R package versions |
| `compare` | Compare two environments |
| `dry` | Dry run (log without executing) |

### Examples

#### Create and Export Environment

```bash
bin/coble-bash.sh \
  --steps conda:create:export \
  --input ./config/coble-mini.yml \
  --results ./results/mini \
  --r-version 4.5.2 \
  --python-version 3.14.0 \
  --env ./envs/mini \
  --pkg ./pkgs/mini
```

#### Run Recipe File

```bash
bin/coble-bash.sh \
  --steps conda:recipe:export \
  --input ./config/recipe.txt \
  --results ./results/recipe-run \
  --env ./envs/myenv \
  --pkg ./pkgs/myenv
```

#### Update Existing Environment

```bash
bin/coble-bash.sh \
  --steps update:export \
  --input ./config/additional-packages.yml \
  --results ./results/updated \
  --env ./envs/existing-env
```

#### Compare Two Environments

```bash
bin/coble-bash.sh \
  --steps compare \
  --lhs-env ./envs/old \
  --rhs-env ./envs/new \
  --results ./results/comparison
```

#### Compare YAML Files

```bash
bin/coble-bash.sh \
  --steps compare \
  --lhs-coble ./v1/coble.yml \
  --rhs-coble ./v2/coble.yml \
  --results ./results/diff
```

#### Check for Installation Errors

```bash
bin/coble-bash.sh \
  --steps errors \
  --results ./results/myenv \
  --output ./logs/output.log \
  --error ./logs/error.log
```

#### Dry Run

```bash
bin/coble-bash.sh \
  --steps dry:create:export \
  --input ./config/test.yml \
  --results ./results/test \
  --r-version 4.5.2 \
  --python-version 3.14.0
```

## coble-slurm.sh

Submit COBLE jobs to SLURM workload manager.

### Synopsis

```bash
sbatch [SBATCH_OPTIONS] bin/coble-slurm.sh [COBLE_OPTIONS]
```

### SLURM Options

```bash
sbatch \
  --job-name=coble-build \
  --output=logs/build_%j.out \
  --error=logs/build_%j.err \
  --ntasks=1 \
  --cpus-per-task=8 \
  --mem=32G \
  --time=04:00:00 \
  bin/coble-slurm.sh \
  --steps conda:create:export \
  --input ./config/coble-452.yml \
  --results ./results/452 \
  --r-version 4.5.2 \
  --python-version 3.14.0 \
  --env ./envs/452 \
  --pkg ./pkgs/452
```

## Individual Step Scripts

Located in `bin/conda-step-*.sh` - these can be called independently:

### conda-step-create.sh

Create a new conda environment.

### conda-step-install.sh

Install packages from YAML file.

### conda-step-export.sh

Export environment to YAML and package lists.

### conda-step-errors.sh

Analyze logs for installation errors.

### conda-step-missing.sh

Check for packages that failed to install.

### conda-step-compare.sh

Compare two environments or package files.  
bash bin/coble-bash.sh --steps compare --lhs-env ./envs/old --rhs-env ./envs/new --results ./results/compare


### conda-step-diff.sh

Compare conda package versions.

### conda-step-recipe.sh

Execute a bash recipe file line by line.

## Output Files

After running COBLE, check the results directory:

| File | Description |
|------|-------------|
| `coble.yml` | Combined environment with all package types |
| `built-conda.yml` | Standard conda environment export |
| `r_packages.txt` | R package list with versions |
| `pip_packages.txt` | Python pip package list |
| `recipe.sh` | Reproducible installation script |
| `error-report.txt` | Error analysis report |
| `installed-report.txt` | Package installation status |

## Configuration Files

### YAML Format

```yaml
name: my-environment
channels:
  - conda-forge
  - bioconda
  - defaults
dependencies:
  - python=3.14.0
  - r-base=4.5.2
  - numpy
  - pandas
  - r-ggplot2
  - bioconductor-deseq2
  - pip:
    - requests
    - beautifulsoup4
```

### Recipe Format (Bash)

```bash
# Install conda packages
conda install -y numpy pandas scipy

# Install R packages
R -e "install.packages('ggplot2')"

# Install from BioConductor
R -e "BiocManager::install('DESeq2')"

# Install pip packages
pip install requests beautifulsoup4
```

## Tips and Best Practices

### Step Chaining

Chain multiple steps efficiently:

```bash
--steps conda:create:install:export:errors:missing
```

### Package Cache

Reuse package cache across environments:

```bash
--pkg /shared/conda-cache
```

### Error Recovery

If a build fails:

1. Check error logs
2. Fix configuration
3. Continue from where it failed:

```bash
--steps install:export:errors
```

### Version Pinning

Pin critical package versions in YAML:

```yaml
dependencies:
  - python=3.14.0  # Exact version
  - numpy>=1.24    # Minimum version
  - pandas=2.*     # Major version
```
