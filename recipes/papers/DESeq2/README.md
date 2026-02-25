# DESEq2 Environment for Publication Reproducibility

The docker impage on GitHub has an amd64 version.

To download the docker image and use it locally do (mounting your current working directory to the workspace inside the container and starting in workspace):
```bash
# Docker
docker pull ghcr.io/coble-tools/coble:papers-deseq2
docker run --rm -it -v .:/workspace ghcr.io/coble-tools/coble:papers-deseq2
validate.sh
```

To download as singularity to use eg on HPC (you retain access to the host inside a singularity image).

```bash
# Docker
docker pull ghcr.io/coble-tools/coble:papers-deseq2
docker run --rm -it -v .:/workspace ghcr.io/coble-tools/coble:papers-deseq2
# Singularity
singularity build coble-papers-deseq2.sif docker://ghcr.io/coble-tools/coble:papers-deseq2
singularity shell coble-papers-deseq2.sif
```

```bash
code/coble build \
--recipe recipes/papers/DESeq2/DESeq2.cbl \
--env deseq2 \
--validate recipes/papers/DESeq2/validate/validate.sh \
--val-folder recipes/papers/DESeq2/validate \
--containers conda \
--rebuild

code/coble build \
--recipe recipes/papers/DESeq2/DESeq2.cbl \
--env deseq2 \
--validate recipes/papers/DESeq2/validate/validate.sh \
--val-folder recipes/papers/DESeq2/validate \
--containers docker,singularity
--rebuild
```



Now simply typing in `validate.sh` at the command line starts this script.
Or to retrieve from docker

# Docker
docker pull ghcr.io/coble-tools/coble:papers-deseq2
docker run --rm -it -v .:/workspace ghcr.io/coble-tools/coble:papers-deseq2
# Singularity
singularity build coble-papers-deseq2.sif docker://ghcr.io/coble-tools/coble:papers-deseq2
singularity shell coble-papers-deseq2.sif
Bioinformatics




## Notes on the replication of the original environment for DESEq2.

Original DESeq2 paper (Genome Biology, 2014): https://genomebiology.biomedcentral.com/articles/10.1186/s13059-014-0550-8

Provides link the the package: https://www.bioconductor.org/packages/release/bioc/html/DESeq2.html


And the lab page: https://github.com/thelovelab/DESeq2

The Supplementary methods privides the original versions: [Additional file 1: Supplementary methods, tables and figures.](https://static-content.springer.com/esm/art%3A10.1186%2Fs13059-014-0550-8/MediaObjects/13059_2014_550_MOESM1_ESM.pdf)

The BiocConductor releases will help me choose the best version:
https://bioconductor.org/about/release-announcements/

It could be 2.14 or 3.0, 2.14 gives me DESeq2 1.4.5 which is probably my best version.
So I want to replicate the pdf code: https://bioconductor.org/packages/2.14/bioc/vignettes/DESeq2/inst/doc/DESeq2.pdf up to the first MA plots on page 8.



The package versions are given:
function/package version additional information
DESeq (old)   1.16.0 using the GLM test
DESeq2        1.4.0
edgeR         3.6.0 using GLM and trended dispersion estimation
DSS           2.2.0
voom: limma   3.20.1
SAMseq: samr  2.0 using samr.pvalues.from.perms for p-values
EBSeq         1.4.0 (1 − PPDE) used for FDR cutoff, following user guide
Cuffdiff      2 2.1.1
GFOLD         1.1.2
PoiClaClu     1.0.2
Additional file 1: Table S3: Versions of software used in manuscript

This is all we have, no R version, so we are going to base it around the requirements given in DESeq2. I am going to use COBLE find for this. I will start with a template for the whole thing and then put in these packages with find.

Crucially the link given in the paper to the code availibility is missing: https://www.huber.embl.de/DESeq2paper


