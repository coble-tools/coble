#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-15
# Capture time: 22:49:17 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi
# Using conda executable conda: /home/ralcraft/miniforge3/envs/pytest/bin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/envs/pytest/bin/conda
#####################################################

conda env remove --name sylver -y 2>/dev/null || true
conda create --no-default-packages --name sylver -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate sylver

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels r
conda config --env --add channels bioconda
conda config --env --add channels conda-forge
conda config --env --add channels defaults

# INSTALL SECTION FOR CONDA
#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
# note the reverse order of priority
# languages:
CONDA_BASE=$(conda info --base)
ARCH=$(uname -m)

# R source installation requested
bash "/home/ralcraft/DEV/gh-rse/BCRDS/coble/code/coble-r-source.sh" "3.6.0"
# flags:
# Flag: Directive: dependencies, Value: na
# Language compile tools
conda install -y --solver=libmamba --no-update-deps -c conda-forge compilers
conda config --env --set channel_priority strict
conda config --env --add channels bioconda
conda config --env --add channels conda-forge
# Flag: Directive: cran-repo, Value: https://packagemanager.posit.co/cran/2020-04-01
# r-conda:
conda install -y --solver=libmamba --no-update-deps \
'r-BiocManager' \
'r-remotes' \
'r-tidyverse=1.3.1' \
'r-effsize=0.8.1' \
'r-magrittr=2.0.1' \
'r-tidyverse=1.3.1' \
'r-ggplot2' \
'r-ggrepel=0.9.1' \
'r-VennDiagram=1.6.20' 
# bioc-conda:
conda install -y --solver=libmamba --no-update-deps \
'bioconductor-affy=1.64.0' \
'bioconductor-fgsea=1.12.0' \
'bioconductor-GSVA=1.34.0' \
'bioconductor-org.Hs.eg.db=3.10.0' 
# r-package:
Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/survival/survival_3.2-11.tar.gz", repos="https://packagemanager.posit.co/cran/2020-04-01", type="source", method="wget" )'
# bioc-package:
Rscript -e 'BiocManager::install("limma", dependencies=NA, Ncpus=1)'
cat > ${CONDA_PREFIX}/bin/validate.sh << 'VALIDATE_EOF'
#!/usr/bin/env bash
echo "COBLE validation: No script has been specified for sylver environment."
VALIDATE_EOF
chmod +x ${CONDA_PREFIX}/bin/validate.sh

