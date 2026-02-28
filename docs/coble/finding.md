# Using the `find:` directive

With an example from the ICR of SYLVER: a publication from the ICR with a coherent description of the code in the [Code availability section](
https://www.nature.com/articles/s41588-025-02108-2#code-availability).

The demonstrates where those packages are and building the recipe (the goal is to build an enviroment as specified rather than run all the given code).

## Code availablility
As given in the publication [code section](https://www.nature.com/articles/s41588-025-02108-2#code-availability):
```text
SYLVER and analysis code was implemented with basic R (v.3.6.0) functionality
using R packages affy (v.1.64.0), hsentrezgcdf (v.18),
cdsrmodels (v.0.1.0; R v.4.1.0), limma (v.3.42.2), effsize (v.0.8.1),
magrittr (v.2.0.1), tidyverse (v.1.3.1), fgsea (v.1.12.0),
ggplots (v.2_3.3.5), ggrepel (v.0.9.1), org.Hs.eg.db (v.3.10.0),
VennDiagram (v.1.6.20), survival (v.3.2-11) and GSVA (v.1.34.0).
SYLVER’s customized code is freely available via Zenodo at
https://doi.org/10.5281/zenodo.14685952 (ref. 46).
For details, see relevant sections in Methods.
```

## Methods info
Further info in [methods](https://www.nature.com/articles/s41588-025-02108-2#Sec2):
```text
DNA methylation data (level 3 β values)—were downloaded from
http://gdac.broadinstitute.org (release 28 January 2016).

Statistics and reproducibility
All analyses were performed in R statistical programming environment
(v.3.6.0, except where stated as v.4.1.0). No data were excluded
from the analyses unless stated otherwise.

For each TSG, two-class comparison of the genome-wide CRISPR–Cas9
screen data was performed between these two groups
(defective and proficient) using linear regression
(function: cdsrmodels::run_lm_stats_limma) as implemented by the
Broad Institute’s Cancer Data Science team for these datasets
(R package: cdsrmodels, v.0.1.0; R v.4.1.0)
```

---

## Replication steps

### 1. Generate the initial recipe
Create a sylver.cbl recipe file:

<details>
<summary>sylver.cbl</summary>
```yaml
#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
coble:
  - environment: coble-env
channels:
# note the reverse order of priority
  - r
  - bioconda
  - conda-forge
  - defaults
languages:
  - r-base=3.6.0@r
flags:
  - dependencies: NA
  - compile-tools: 13.1
  - build-tools: false
  - priority: strict
  - channel: bioconda
  - channel: conda-forge
find:
  - r-base=3.6.0
  - r-base=4.1.0
  - BiocManager
  - tidyverse=1.3.1
  - effsize=0.8.1
  - magrittr=2.0.1
  - tidyverse=1.3.1
  - ggplot2
  - ggrepel=0.9.1
  - VennDiagram=1.6.20
  - affy=1.64.0
  - fgsea=1.12.0
  - GSVA=1.34.0
  - org.Hs.eg.db=3.10.0
  - survival=3.2-11
  - limma=3.42.2
  - cdsr_models
```
</details>

Note I have already solved some aspects of this environment as the intention is to show the `find:` directive.

To resolve these finds simply start to try to build the environment (choose an environment as a name or path, if a path `prefix` will be used automatically):
```bash
coble build --recipe sylver.cbl --env my-env
```
This may take some time as the find directive looks for all possible places where the libraries may reside. It will give all the options, so we will need to decide where to take them from.

The coble utility will exit with the message:
```bash
[coble-resolve] Finds were resolved, please check the yml output: tutorials/sylver/sylver.cbl
[*coble] Finds were resolved, please check the yml input before resuming.
```

It will return **IN PLACE** an updated cbl file with the best efforts it could make at finding the libraries. NOTE the importance of this as sometimes packages are archived and moved so what is correct at the time of publication may no longer hold at the time of replcaition. Specifically for example in this case R 3.6.0 was current at the time but now no longer on conda-forge.

### 2. Perfecting the recipe input
This is what we now have:
<details>
<summary>sylver.cbl</summary>
```yaml
#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
coble:
  - environment: coble-env
channels:
# note the reverse order of priority
  - r
  - bioconda
  - conda-forge
  - defaults

languages:

flags:
  - dependencies: NA
  - compile-tools: 13.1
  - build-tools: false
  - priority: strict
  - channel: bioconda
  - channel: conda-forge

find:
#   - r-base=3.6.0
found|languages:
  - r-base=3.6.0@r
#   - r-base=4.1.0
found|languages:
  - r-base=4.1.0@conda-forge
#   - BiocManager
found|conda:
  - r-BiocManager@conda-forge
found|conda:
  - r-BiocManager@r
found|r-package:
  - BiocManager@CRAN
found|r-package:
  - BiocManager@CRAN
found|r-package:
  - BiocManager@CRAN

#   - tidyverse=1.3.1
found|conda:
  - r-tidyverse=1.3.1@conda-forge
found|conda:
  - r-tidyverse=1.3.1@r
found|r-package:
  - tidyverse=1.3.1@CRAN
found|pip:
  - tidyverse

#   - effsize=0.8.1
found|conda:
  - r-effsize=0.8.1@conda-forge
found|conda:
  - r-effsize=0.8.1@r
found|r-package:
  - effsize=0.8.1@CRAN

#   - magrittr=2.0.1
found|conda:
  - r-magrittr=2.0.1@conda-forge
found|r-package:
  - magrittr=2.0.1@CRAN

#   - tidyverse=1.3.1
found|conda:
  - r-tidyverse=1.3.1@conda-forge
found|conda:
  - r-tidyverse=1.3.1@r
found|r-package:
  - tidyverse=1.3.1@CRAN
found|pip:
  - tidyverse

#   - ggplot2
found|conda:
  - r-ggplot2@bioconda
found|conda:
  - r-ggplot2@conda-forge
found|conda:
  - r-ggplot2@r
found|r-package:
  - ggplot2@CRAN
found|r-package:
  - ggplot2@CRAN
found|pip:
  - ggplot2@https://github.com/Alicimo/ggplot2,https://github.com/KayRoctaidabee/ggplot2/archive/refs/heads/master.zip

#   - ggrepel=0.9.1
found|conda:
  - r-ggrepel=0.9.1@conda-forge
found|conda:
  - r-ggrepel=0.9.1@r
found|r-package:
  - ggrepel=0.9.1@CRAN

#   - VennDiagram=1.6.20
found|conda:
  - r-VennDiagram=1.6.20@conda-forge
found|r-package:
  - VennDiagram=1.6.20@CRAN
found|r-package:
  - VennDiagram=1.6.20@CRAN
found|pip:
  - VennDiagram@https://github.com/leviperes/VennDiagram,https://github.com/mrForce/VennDiagram,https://github.com/Wayne-Ayers-Creech/VennDiagram/archive/refs/heads/master.zip

#   - affy=1.64.0
found|conda:
  - bioconductor-affy=1.64.0@bioconda
found|bioconductor:
  - affy=1.64.0@r

#   - fgsea=1.12.0
found|conda:
  - bioconductor-fgsea=1.12.0@bioconda
found|bioconductor:
  - fgsea=1.12.0@r

#   - GSVA=1.34.0
found|conda:
  - bioconductor-GSVA=1.34.0@bioconda
found|bioconductor:
  - GSVA=1.34.0@r
found|pip:
  - GSVA

#   - org.Hs.eg.db=3.10.0
found|conda:
  - bioconductor-org.Hs.eg.db=3.10.0@bioconda

#   - survival=3.2-11
found|r-package:
  - survival=3.2-11@CRAN
found|r-package:
  - survival@r-forge
found|pip:
  - survival
found|pip:
  - survival@https://github.com/ryu577/survival/archive/refs/heads/master.zip

#   - limma=3.42.2
found|bioc-package:
  - limma=3.42.2@r
found|pip:
  - limma
found|pip:
  - limma@https://github.com/firoziya/limma/archive/refs/heads/master.zip

```

Note it is up to you what you want and we might make some changes, so from the above find choose what you want, as per the example below, and being aware that we can't have 2 r versions for example so need to chose, and based on the paper 3.6.0 was the main version.

<details>
<summary>Final version: tutorials/sylver/sylver.cbl</summary>yaml
```yaml
#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
coble:
  - environment: coble-env
channels:
# note the reverse order of priority
  - r
  - bioconda
  - conda-forge
  - defaults
languages:
  - r-base=3.6.0@r
flags:
  - dependencies: NA
  - compile-tools: 13.1
  - build-tools: false
  - priority: strict
  - channel: bioconda
  - channel: conda-forge
r-conda:
  - BiocManager
  - remotes
  - tidyverse=1.3.1
  - effsize=0.8.1
  - magrittr=2.0.1
  - tidyverse=1.3.1
  - ggplot2
  - ggrepel=0.9.1
  - VennDiagram=1.6.20
bioc-conda:
  - affy=1.64.0
  - fgsea=1.12.0
  - GSVA=1.34.0
  - org.Hs.eg.db=3.10.0
r-package:
  - survival=3.2-11
bioc-package:
  - limma=3.42.2
```
</details>

### 4. Tracking the output logs
Now we are running we can track the logs.
- **sylver.sh** - the cbl transformed into a pure bash script that could be run instead
- **sylver.log** - each bash install cleans and runs here so you can track the stdout
- **sylver.err** - each bash line cleans the err file so you can track the current stderr
- **sylver_summary.txt** - after each install the logs are parsed for important info eg errors or dependencies. This is output along with the timings so you can keep an eye on the entire install here.

