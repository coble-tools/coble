# COBLE Recipe with Versions

Sometimes versions are specified either explicitly or in ranges. An example of a package on github with an environment with specified versions is [Monopogen](https://github.com/KChen-lab/Monopogen).

`Dou J, Tan Y, Kock KH, Wang J, Cheng X, Tan LM, Han KY, Hon CC, Park WY, Shin JW, Jin H, H Chen, L Ding, S Prabhakar, N Navin. K Chen. Single-nucleotide variant calling in single-cell sequencing data with Monopogen. Nature Biotechnology. 2023 Aug 17:1-0`

To replicate some of the environment with given versions:

```bash
coble recipe --recipe versions/versions.cbl --flavour versions
coble build --recipe versions/versions.cbl --env coble-versions-env
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

In the output you can see that numpy has been installed by conda rather than pip - it will have been installed by both but the environment puts a priority on the conda version and avoids duplication in resuts.