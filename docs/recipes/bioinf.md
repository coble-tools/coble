# Complex Bioinformatics Lab Environment

In this very large bioinformatics recipe the only versions s[ecified are for R and python and the rest will be appropriately found. The same environment will be upgraded when appropriate and the new versions resolved. For that reason more packages are installed through bioconductor than through conda as they are not always up-todate when a new version of R comes out.

To replicate - but be warned it takes 8 hours to build.

```bash
coble template --input bioinf/bioinf.yml --flavour bioinf
coble build --input bioinf/bioinf.yml --env coble-bioinf-env
```
### Input recipe yaml
```yaml
languages:
  - python=3.13.1@conda-forge
  - r-base=4.3.1@conda-forge
conda:
  - pandas>=1.2.3@conda-forge
  - pysam>=0.16.0.1@bioconda  
r-conda:
  - ggplot2
pip:
  - NumPy>=1.19.5
  - sciPy>=1.6.3
```

### Output capture yaml

```yaml
languages:
  - r-base=4.3.1@conda-forge
  - python=3.13.1@conda-forge

conda:
  - pandas=2.3.3@conda-forge
  - pysam=0.23.3@bioconda
  - numpy=2.4.0@conda-forge

r-conda:
  - ggplot2=3.5.2@conda-forge

pip:
  - scipy=1.16.3
```

In the output you can see that numpy has been installed by conda rather than pip - it will have been installed by both but the environment putrs a priority on the conda version and avoids duplication for resukts.