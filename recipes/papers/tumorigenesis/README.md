https://www.nature.com/articles/s41467-021-21783-3
https://github.com/MarioniLab/Tumorigenesis2018

Time-resolved single-cell analysis of Brca1 associated mammary tumourigenesis reveals aberrant differentiation of luminal progenitors

They provide a def file which shows the build at that time with no versions. The analysis was done in 2018 and published in 2021.

The image can be downloaded here

https://content.cruk.cam.ac.uk/jmlab/BRCA1Tumourigenesis/


## Data Availibility statement
The authors declare that all data supporting the findings of this study and unprocessed images are available within the article and its supplementary information files or from the corresponding author upon reasonable request. The raw sequencing data are available on ArrayExpress with the following accession numbers: E-MTAB-10043 (scRNA-Seq), E-MTAB-10046 (RNA-Seq) and E-MTAB-10054 (ATAC-Seq). Processed data can also be explored and downloaded at http://marionilab.cruk.cam.ac.uk/BRCA1Tumourigenesis. All computational analyses were performed in R (Version 3.4.1) using standard functions unless otherwise indicated. All code is available online at https://github.com/MarioniLab/Tumorigenesis2018. Source data are provided with this paper.

This is perfect, we can easily udpate coble.

wget https://content.cruk.cam.ac.uk/jmlab/BRCA1Tumourigenesis/Tumorigenesis.sif
wget https://content.cruk.cam.ac.uk/jmlab/BRCA1Tumourigenesis/BRCA1_SCE.rds
wget https://www.ebi.ac.uk/biostudies/arrayexpress/studies/E-MTAB-10043#





Using their sif
cd githubs/Tumorigenesis2018
singularity shell Tumorigenesis.sif

# I need a data folder at the same level at src
project/
├── src/
│   └── Tumorigenesis/
│       └── 01_MakeCountMatrix.Rmd
└── data/
    └── Tumorigenesis/
        └── CellRangerOutput/
            └── raw/
                └── features.tsv.gz

