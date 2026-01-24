# R Functions used by COBLE

The COBLE directives translate into r functions that can be controlled by flags. These are the funcitons used, how they are called and how they can be controlled.

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


