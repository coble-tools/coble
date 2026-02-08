# Notes on the replication of the original environment for DESEq2.

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


```bash
code/coble template --recipe recipes/publications/DESeq2/DESeq2.cbl --flavour template
```

```yaml
coble:
  - environment: DESeq2
channels: # note the reverse order of priority  
  - defaults
  - R
  - bioconda
  - conda-forge  
languages:
  - python=3.13.1@conda-forge
  - r-base=4.3.1@conda-forge
flags:
  - dependencies: NA
  - system-tools: false
  - compile-tools: true
find:
  - r-base
  - DESeq
  - DESeq2
  - edgeR
  - DSS
  - voom
  - limma
  - SAMseq 
  - samr
  - EBSeq
  - Cuffdiff
  - GFOLD
  - PoiClaClu
```

```bash
code/coble build \
--recipe recipes/papers/DESeq2/DESeq2.cbl \
--env deseq2 \
--validate recipes/papers/DESeq2/validate/validate.sh \
--val-folder recipes/papers/DESeq2/validate/ \
--rebuild
```

This returns the best discovery it can do with no filtering leaving the researcher to make the choices.
Note if I want to include r-forge I have to ask for it explicitly because it is slow, I will try not to.
While this runs I consider - I am looking for the versions I want, but I will not over version as I will allow dependencies to be pulled in.


```yaml
coble:
  - environment: DESeq2
channels: # note the reverse order of priority  
  - defaults
  - R
  - bioconda
  - conda-forge  
languages:
  - python=3.13.1@conda-forge
  - r-base=4.3.1@conda-forge
flags:
  - dependencies: NA
  - system-tools: false
  - compile-tools: true
find:
#   - r-base
found|languages:
  - r-base=3.3.2@conda-forge
found|languages:
  - r-base=3.4.1@conda-forge
found|languages:
  - r-base=3.5.1@conda-forge
found|languages:
  - r-base=3.6.1@conda-forge
found|languages:
  - r-base=3.6.2@conda-forge
found|languages:
  - r-base=3.6.3@conda-forge
found|languages:
  - r-base=4.0.0@conda-forge
found|languages:
  - r-base=4.0.1@conda-forge
found|languages:
  - r-base=4.0.2@conda-forge
found|languages:
  - r-base=4.0.3@conda-forge
found|languages:
  - r-base=4.0.5@conda-forge
found|languages:
  - r-base=4.1.0@conda-forge
found|languages:
  - r-base=4.1.1@conda-forge
found|languages:
  - r-base=4.1.2@conda-forge
found|languages:
  - r-base=4.1.3@conda-forge
found|languages:
  - r-base=4.2.0@conda-forge
found|languages:
  - r-base=4.2.1@conda-forge
found|languages:
  - r-base=4.2.2@conda-forge
found|languages:
  - r-base=4.2.3@conda-forge
found|languages:
  - r-base=4.3.0@conda-forge
found|languages:
  - r-base=4.3.1@conda-forge
found|languages:
  - r-base=4.3.2@conda-forge
found|languages:
  - r-base=4.3.3@conda-forge
found|languages:
  - r-base=4.4.0@conda-forge
found|languages:
  - r-base=4.4.1@conda-forge
found|languages:
  - r-base=4.4.2@conda-forge
found|languages:
  - r-base=4.4.3@conda-forge
found|languages:
  - r-base=4.5.1@conda-forge
found|languages:
  - r-base=4.5.2@conda-forge
found|languages:
  - r-base=3.3.0@r
found|languages:
  - r-base=3.3.1@r
found|languages:
  - r-base=3.3.2@r
found|languages:
  - r-base=3.4.1@r
found|languages:
  - r-base=3.4.2@r
found|languages:
  - r-base=3.4.3@r
found|languages:
  - r-base=3.5.0@r
found|languages:
  - r-base=3.5.1@r
found|languages:
  - r-base=3.5.3@r
found|languages:
  - r-base=3.6.0@r
found|languages:
  - r-base=3.6.1@r
found|languages:
  - r-base=4.2.0@r
found|languages:
  - r-base=4.3.1@r

#   - DESeq
found|conda:
  - bioconductor-DESeq=1.22.1@bioconda
found|bioc-package:
  - DESeq=1.42.0@r
found|bioc-package:
  - DESeq=1.38.0@r

#   - DESeq2
found|conda:
  - bioconductor-DESeq2=1.8.2@bioconda
found|bioc-package:
  - DESeq2=1.50.2@r
found|bioc-package:
  - DESeq2=1.34.0@r
found|bioc-package:
  - DESeq2=1.30.1@r
found|bioc-package:
  - DESeq2=1.26.0@r
found|pip:
  - DESeq2@https://github.com/sebhan/DESeq2/archive/refs/heads/master.zip

#   - edgeR
found|conda:
  - bioconductor-edgeR=3.10.5@bioconda
found|bioc-package:
  - edgeR=4.8.2@r
found|bioc-package:
  - edgeR=3.36.0@r
found|bioc-package:
  - edgeR=3.32.1@r
found|bioc-package:
  - edgeR=3.28.1@r
found|pip:
  - edgeR

#   - DSS
found|conda:
  - bioconductor-DSS=2.26.0@bioconda
found|bioc-package:
  - DSS=2.58.0@r
found|bioc-package:
  - DSS=2.42.0@r
found|bioc-package:
  - DSS=2.38.0@r
found|bioc-package:
  - DSS=2.34.0@r
found|pip:
  - DSS

#   - voom
found|pip:
  - voom

#   - limma
found|conda:
  - bioconductor-limma=3.24.15@bioconda
found|r-package:
  - limma=1.7.6@CRAN
found|bioc-package:
  - limma=3.66.0@r
found|bioc-package:
  - limma=3.50.3@r
found|bioc-package:
  - limma=3.46.0@r
found|bioc-package:
  - limma=3.42.2@r
found|pip:
  - limma

#   - SAMseq 

#   - samr
found|conda:
  - r-samr=2.0@bioconda
found|r-package:
  - samr=1.0.0.0@CRAN
found|r-package:
  - samr=1.00@CRAN

#   - EBSeq
found|conda:
  - bioconductor-EBSeq=1.12.0@bioconda
found|bioc-package:
  - EBSeq=2.8.0@r
found|bioc-package:
  - EBSeq=1.34.0@r
found|bioc-package:
  - EBSeq=1.30.0@r
found|bioc-package:
  - EBSeq=1.26.0@r

#   - Cuffdiff

#   - GFOLD
found|conda:
  - GFOLD=1.1.4@bioconda
found|pip:
  - GFOLD
found|pip:
  - GFOLD@https://github.com/jianlin-cheng/GFOLD,https://github.com/AlexisFimeyer/GFOLD/archive/refs/heads/master.zip

#   - PoiClaClu
found|conda:
  - r-PoiClaClu=1.0.2.1@conda-forge
found|conda:
  - r-PoiClaClu=1.0.2.1@r
found|r-package:
  - PoiClaClu=1.6@CRAN
found|r-package:
  - PoiClaClu=1.0.1@CRAN
found|r-package:
  - PoiClaClu=1.0.1@CRAN
```

So we have an idea that most of the other packages are also DESeq2

Cufflinks coundlt be found, we will come back to it, some googling finds: https://github.com/cole-trapnell-lab/cufflinks

Let's start with DESeq2 as being the pivotal version. We can search in [bioconductor](https://bioconductor.org/)
https://bioconductor.org/packages/release/bioc/html/DESeq2.html

This is the most recent version. It says in bioconductor since BioC 2.12 (R-3.0) 13 years. This tallies with the publication date so let's begin the recipe with an R 3 version we have found, and the given DESeq2 package.
I have a supoerstitious preference for a *.*.2 version so lets take the latest 3.*.2. We will let conda find the rest of the packages as a starting point for any that have a conda version. Our first preference is for conda as the package resolution will be easier. 

```yaml
coble:
  - environment: DESeq2
channels: # note the reverse order of priority  
  - defaults
  - R
  - bioconda
  - conda-forge  
languages:  
  - r-base=3.6.2@conda-forge
flags:
  - dependencies: NA
  - system-tools: false
  - compile-tools: true
bioc-conda:
  - DESeq2
  - edgeR
  - DSS
  - limma  
  - EBSeq          
conda:
  - GFOLD
r-conda:
  - samr
  - PoiClaClu  
bioc-package:
  - BiocVersion=2.14
```

We repeat the same command after changing the coble recipe in place:
```bash
 code/coble build --recipe recipes/publications/DESeq2/DESeq2.cbl --env deseq2
```
There are a few outputs:
- the freeze file  `DESeq2_freeze.cbl`
- the summary log file including dependency history `DESeq2_summary.txt` which shows the time taken to build as 1m59s

The time taken to work on this up to this point is about half an hour.

We can check the output file for the BiocVersion:
```yaml
bioc-package:
  - BiocVersion=3.10.1
```
And from this we can navigate to that version in bioconductor:
https://bioconductor.org/packages/3.10/bioc/html/DESeq2.html

The html vignette maught be the best starting place to reproduce:
https://bioconductor.org/packages/3.10/bioc/vignettes/DESeq2/inst/doc/DESeq2.html

My goal is the first plor.


Immediately we see there are libraires we need to install in addition to anything we might alrady have. A parse of "library" and `find:` on them is the next step.

```yaml
find:
  - parathyroidSE
  - pasilla  
```

And after the results my new recipe:
```yaml
coble:
  - environment: DESeq2
channels: # note the reverse order of priority  
  - defaults
  - R
  - bioconda
  - conda-forge  
languages:  
  - r-base=3.6.2@conda-forge
flags:
  - dependencies: NA
  - system-tools: false
  - compile-tools: true  bioc-package was to
bash:
  - Rscript -e 'BiocManager::install(version="2.14")'
bioc-conda:
  - DESeq2
  - DESeq
  - edgeR
  - DSS
  - limma  
  - EBSeq
  - parathyroidSE    
  - pasilla
conda:
  - GFOLD
r-conda:
  - samr  
  - PoiClaClu
```

The R script now runs so I will add it to my recipe in the bon directory and add a validate script to my environment.
```yaml
...
conda:
  - GFOLD
r-conda:
  - samr
  - PoiClaClu
bash:
cp recipes/publications/DESeq2/DESeq2.R \
$CONDA_PREFIX/bin/DESeq2.R
```

```bash
code/coble build \
--recipe recipes/papers/DESeq2/DESeq2.cbl \
--env deseq2 \
--validate recipes/papers/DESeq2/validate/validate.sh \
--val-folder recipes/papers/DESeq2/validate \
--rebuild

code/coble build \
--recipe recipes/pubpaperslications/DESeq2/DESeq2.cbl \
--env deseq2 \
--validate recipes/papers/DESeq2/validate/validate.sh \
--val-folder recipes/papers/DESeq2/validate \
--containers docker,singularity
```

Now simply typing in `validate.sh` at the command line starts this script.
Or to retrieve from docker

docker run --rm -it icrsc/coble:papers-DESeq2


singularity shell /data/rds/DIT/SCICOM/SCRSE/shared/singularity/cbl-deseq2.sif