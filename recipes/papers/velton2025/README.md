# Clonal tracing with somatic epimutations reveals dynamics of blood ageing

Scherer, M., Singh, I., Braun, M.M. et al. Clonal tracing with somatic epimutations reveals dynamics of blood ageing. Nature 643, 478–487 (2025). https://doi.org/10.1038/s41586-025-09041-8


Repo: https://github.com/veltenlab/EPI-clone  
Paper: https://www.nature.com/articles/s41586-025-09041-8#citeas  

Seurat object on FigShare: https://figshare.com/articles/dataset/EPI-Clone_dataset_Single_cell_targeted_DNA_methylation_profiling_of_hematopoietic_stem_and_progenitor_cells/24204750/1?file=42479346  


This coble recipe replicates the reported environment for the piblication and `coble validate` runs through the Figure1 code given: 
https://github.com/veltenlab/EPI-clone/tree/main/figures/Figure1  

The installation automatically downloads the github repo and the rds data object into the conda environment.
$CONDA_PREFIX/GitHub/EPI-clone  
$CONDA_PREFIX/GitHub/EPI-clone/data/larry_seurat.rds  

When running `coble validate` the png files are created in the current working directory.  

To run the docker image:  
```bash
docker pull ghcr.io/coble-tools/coble:papers-velton2025  
docker run --rm -it -v .:/workspace -w /workspace ghcr.io/coble-tools/coble:papers-velton2025  
```

To run the singularity image: 
```bash
singularity build coble-papers-velton2025.sif docker://ghcr.io/coble-tools/coble:papers-velton2025  
singularity shell --no-home coble-papers-velton2025.sif  
```


