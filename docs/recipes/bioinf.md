# Complex Bioinformatics Lab Environment

In this very large bioinformatics recipe the only versions specified are for R and python and the rest will be appropriately found, apart from where some versions are needed specifically for headers. The same environment will be upgraded when appropriate and the new versions resolved. For that reason more packages are installed through bioconductor than through conda as they are not always up-to-date when a new version of R comes out.

To replicate - but be warned it takes 8 hours to build.

```bash
coble template --recipe bioinf.cbl --flavour bioinf
coble build --recipe bioinf.cbl --env coble-bioinf-env
```

### Recipe cbl
The recipe cbl file is 508 lines long so not included here but can be found on github:
[bioinf.cbl](https://github.com/coble-tools/coble/blob/main/code/tml_bioinf.cbl)