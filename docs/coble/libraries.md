# Underlying libraries

`COBLE` is a high-level tool that calls third party tools to manage multiple package managers.

The real work is done behind the scenes in conda, R and python, and the functions called can be controlled through `COBLE` - with simplicity and defaults being the first intention.

The `COBLE` directives translate into package bash cmmands and all the details for the different languaes and how the inputs can be controlled are in the langauage specific documents.

## Controlling through conda
Packages can be called through conda or their native package managers. Available package managers are:
- conda
- pip
- cran (install.packages)
- bioconductor (BiocManage::install)

## Controlling through bash
There is free-hand to use the `bash:` directve for any commands that are not yet convered or require greater control.

## Finding and dating r versions

The list of R versions can be found here:
[https://cran.rstudio.com/bin/windows/base/old/](https://cran.rstudio.com/bin/windows/base/old/)


When installing an old version of R, the recommendation is to use a cran snapshot from about a year after the release date. This is done in the compiler seciton of coble - here for 1st April 2020 should be good for R 3.6.

```yaml
compilers:
  - cran-repo: https://packagemanager.posit.co/cran/2020-04-01
  ```

---