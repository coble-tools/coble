# R Functions used by COBLE

The COBLE directives translate into r functions that can be controlled by flags. These are the functions used, how they are called and how they can be controlled.

## Flag control
```yaml
flags:
  dependencies: NA   # NA / TRUE / FALSE
  ncpus: 4           # number of parallel cpus in solvers
  updates: never     # never / always / default
```
The flags default as shown here, or can be set - usually they are set at the beginning globally for all installs. If you want to change them for any given commands set them and then set them back, so have a flags section before and after the package section.  

It is of course always possible to use a direct bash command if finer control is needed.
```yaml
bash:
CXX14FLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive"  \
CXX17FLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive"  \
CXXFLAGS="-O0 -D_REENTRANT -Wno-ignored-attributes -fpermissive -I$CONDA_PREFIX/include"  \
MAKEFLAGS="-j1"  \
Rscript -e 'remotes::install_github("davidaknowles/leafcutter/leafcutter", upgrade="never", Ncpus=8)'
```



## install.packages
[CRAN: install.packages doc](https://stat.ethz.ch/R-manual/R-devel/library/utils/html/install.packages.html)
<details>
<summary>install-url</summary>

```bash
install.packages(pkgs, lib, repos = getOption("repos"),
                 contriburl = contrib.url(repos, type),
                 method, available = NULL, destdir = NULL,
                 dependencies = NA, type = getOption("pkgType"),
                 configure.args = getOption("configure.args"),
                 configure.vars = getOption("configure.vars"),
                 clean = FALSE, Ncpus = getOption("Ncpus", 1L),
                 verbose = getOption("verbose"),
                 libs_only = FALSE, INSTALL_opts, quiet = FALSE,
                 keep_outputs = FALSE, ...)
```
</details>
```bash
Rscript -e 'install.packages("gdata", repos="https://cloud.r-project.org", dependencies=NA, Ncpus=8)'
```


## remotes::install_version
[CRAN: install_version doc](https://remotes.r-lib.org/reference/install_version.html)
<details>
<summary>install_version</summary>

```bash
install_version(
  package,
  version = NULL,
  dependencies = NA,
  upgrade = c("default", "ask", "always", "never"),
  force = FALSE,
  quiet = FALSE,
  build = FALSE,
  build_opts = c("--no-resave-data", "--no-manual", "--no-build-vignettes"),
  build_manual = FALSE,
  build_vignettes = FALSE,
  repos = getOption("repos"),
  type = "source",
  ...
)
```
</details>

## remotes::install_url
[CRAN: install_url doc](https://remotes.r-lib.org/reference/install_url.html)
<details>
<summary>install_url</summary>

```bash
install_url(
  url,
  subdir = NULL,
  dependencies = NA,
  upgrade = c("default", "ask", "always", "never"),
  force = FALSE,
  quiet = FALSE,
  build = TRUE,
  build_opts = c("--no-resave-data", "--no-manual", "--no-build-vignettes"),
  build_manual = FALSE,
  build_vignettes = FALSE,
  repos = getOption("repos"),
  type = getOption("pkgType"),
  ...
)
```
</details>
Note that @ activates the subdir param if it is needed.
r-url:
  - https://github.com/xmc811/Scillus/archive/refs/heads/development.zip
  - https://github.com/VanLoo-lab/ascat/archive/refs/heads/master.zip@ASCAT
```

```bash
install: Rscript -e 'remotes::install_url("https://github.com/xmc811/Scillus/archive/refs/heads/development.zip", dependencies=NA, Ncpus=8)'

install: Rscript -e 'remotes::install_url("https://github.com/VanLoo-lab/ascat/archive/refs/heads/master.zip", dependencies=NA, subdir="ASCAT", Ncpus=8)'
```


## remotes::install_github
[CRAN: install_github doc](https://remotes.r-lib.org/reference/install_github.html)
<details>
<summary>install_github</summary>

```bash
install_github(
  repo,
  ref = "HEAD",
  subdir = NULL,
  auth_token = github_pat(quiet),
  host = "api.github.com",
  dependencies = NA,
  upgrade = c("default", "ask", "always", "never"),
  force = FALSE,
  quiet = FALSE,
  build = TRUE,
  build_opts = c("--no-resave-data", "--no-manual", "--no-build-vignettes"),
  build_manual = FALSE,
  build_vignettes = FALSE,
  repos = getOption("repos"),
  type = getOption("pkgType"),
  ...
)
```
</details>

## BiocManager::install
[BiocManager::install doc](https://bioconductor.github.io/BiocManager/reference/install.html)
<details>
<summary>BiocManager::install</summary>

```bash
install(
  pkgs = character(),
  ...,
  site_repository = character(),
  update = TRUE,
  ask = TRUE,
  checkBuilt = FALSE,
  force = FALSE,
  version = BiocManager::version()
)
```
</details>


