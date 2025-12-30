# Complex Bioinformatics Lab Environment

In this very large bioinformatics recipe the only versions specified are for R and python and the rest will be appropriately found, apart from where some versions are needed specifically for headers. The same environment will be upgraded when appropriate and the new versions resolved. For that reason more packages are installed through bioconductor than through conda as they are not always up-to-date when a new version of R comes out.

To replicate - but be warned it takes 8 hours to build.

```bash
coble recipe --input bioinf.cbl --flavour bioinf
coble build --input bioinf.cbl --env coble-bioinf-env
```

### Input recipe yaml
The input cbl file is 508 lines long so not included here but can be found on github here:  
[bioinf.cbl](https://github.com/ICR-RSE-Group/coble/blob/main/code/tml_bioinf.cbl)  