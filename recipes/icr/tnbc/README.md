Repeatability - trying to repeat an internal script on the HPC


intr
cd /data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/Syed/SingleCell/coble
git checkout issue-140-example

code/coble build --recipe recipes/icr/tnbc/tnbc.cbl --env tnbc --rebuild

code/coble build --recipe recipes/icr/tnbc/tnbc-new.cbl --env tnbc-new --rebuild


conda activate /data/scratch/DBC/UBCN/BCRBIOIN/SHARED/software/conda_envs/R-4.1.0
code/coble export --frozen syed-410.cbl

Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/Seurat/Seurat_4.2.1.tar.gz", repos=NULL, type="source")'