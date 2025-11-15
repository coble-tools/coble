# COBLE - COnda BuiLdEr
ssh ralcraft@alma.icr.ac.uk
srun --pty --mem=8GB -c 2 -t 30:00:00 -p interactive bash
cd /data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/coble

## Initial

sbatch -o logs/syed-recipe-yaml-01.out \
       -e logs/syed-recipe-yaml-01.err \
       bin/coble-slurm.sh \
       --steps "create,export,errors,missing" \
       --input "config/syed-recipe.yml" \
       --results "results/syed-recipe-yaml-01" \
       --r-version "4.5.2" \
       --python-version "3.14.0" \
       --env "envs/syed-yaml-4.5.2" \
       --pkg "pkgs/syed-yaml-4.5.2" \
       --output logs/syed-recipe-yaml-01.out \
       --error logs/syed-recipe-yaml-01.err

## errors
  MSG:configure: error: gdal-config not found or not executable. 
  WARNING:ERROR: dependency 'terra' is not available for package 'raster'
  MSG:io_utils.c:16:10: fatal error: zlib.h: No such file or directory
  WARNING:ERROR: dependency 's2' is not available for package 'sf'
  WARNING:ERROR: dependency 'XVector' is not available for package 'SparseArray'
  WARNING:ERROR: dependency 'SparseArray' is not available for package 'DelayedArray'
  WARNING:ERROR: dependency 'DelayedArray' is not available for package 'SummarizedExperiment'
  WARNING:package 'cellHTS2' is not available for Bioconductor version '3.22'
  MSG:configure: error: Cannot find cairo.h! Please install cairo (http://www.cairographics.org/) and/or set CAIRO_CFLAGS/LIBS correspondingly.
  WARNING:ERROR: dependency 'Cairo' is not available for package 'ggrastr'
  WARNING:ERROR: dependency 'ggrastr' is not available for package 'scater'
  WARNING:package 'cellhts2' is not available for Bioconductor version '3.22'
  WARNING:ERROR: dependency 'STACAS' is not available for package 'ProjecTILs'
  ERROR:  installation of package '/tmp/RtmpWlybru/file368eb5344e9bd4/ProjecTILs_3.6.0.tar.gz' had non-zero exit status
```
  - r_conda:
    - s2
    - Cairo
    - ggrastr
  - r_package:  
    - terra
    - raster
  - bio_conda:
    - DelayedArray
  - bio_package:
    - SparseArray
    - cellHTS2
  - wget:
    - https://github.com/carmonalab/STACAS/archive/refs/heads/master.zip
    - https://github.com/carmonalab/ProjecTILs/archive/refs/heads/master.zip
    
```
## Update 01
sbatch -o logs/syed-recipe-yaml-02.out \
       -e logs/syed-recipe-yaml-02.err \
       bin/coble-slurm.sh \
       --steps "update,export,errors,missing" \
       --input "config/update_01_452.yml" \
       --results "results/syed-recipe-yaml-02" \
       --r-version "4.5.2" \
       --python-version "3.14.0" \
       --env "envs/syed-yaml-4.5.2" \
       --pkg "pkgs/syed-yaml-4.5.2" \
       --output logs/syed-recipe-yaml-02.out \
       --error logs/syed-recipe-yaml-02.err

## errors:
WARNING:package 'cellHTS2' is not available for Bioconductor version '3.22'
Old packages: 'IHW', 'cutoff', 'lpsymphony', 'maftools', 'seqminer',

- bio_conda:
    - IHW
    - cutoff
    - lpsymphony
    - maftools
    - seqminer
  - bio_package:    
    - cellHTS2

## Update 02
sbatch -o results/syed-recipe-yaml-03.out \
       -e results/syed-recipe-yaml-03.err \
       bin/coble-slurm.sh \
       --steps "update,export,errors,missing" \
       --input "config/update_02_452.yml" \
       --results "results/syed-recipe-yaml-03" \
       --r-version "4.5.2" \
       --python-version "3.14.0" \
       --env "envs/syed-yaml-4.5.2" \
       --pkg "pkgs/syed-yaml-4.5.2" \
       --output results/syed-recipe-yaml-03.out \
       --error results/syed-recipe-yaml-03.err

still no:
  WARNING:package 'IHW' is not available for this version of R
  WARNING:package 'lpsymphony' is not available for this version of R
  WARNING:package 'maftools' is not available for this version of R
  WARNING:package 'cellHTS2' is not available for Bioconductor version '3.22'

#coble-yml
dependencies:  
  - bio_package:
    - IHW    
    - lpsymphony
    - maftools    
  - bio_conda:    
    - cellHTS2
    - 
## Update 03
sbatch -o results/syed-recipe-yaml-04.out \
       -e results/syed-recipe-yaml-04.err \
       bin/coble-slurm.sh \
       --steps "update,export,errors,missing" \
       --input "config/update_03_452.yml" \
       --results "results/syed-recipe-yaml-04" \
       --r-version "4.5.2" \
       --python-version "3.14.0" \
       --env "envs/syed-yaml-4.5.2" \
       --pkg "pkgs/syed-yaml-4.5.2" \
       --output results/syed-recipe-yaml-04.out \
       --error results/syed-recipe-yaml-04.err

## New run
sbatch -o logs/syed-recipe-yaml-v2-01.out \
       -e logs/syed-recipe-yaml-v2-01.err \
       bin/coble-slurm.sh \
       --steps "create,export,errors,missing" \
       --input "config/syed-recipe.yml" \
       --results "results/syed-recipe-yaml-v2-01" \
       --r-version "4.5.2" \
       --python-version "3.14.0" \
       --env "envs/syed-yaml-4.5.2" \
       --pkg "pkgs/syed-yaml-4.5.2" \
       --output logs/syed-recipe-yaml-v2-01.out \
       --error logs/syed-recipe-yaml-v2-01.err