#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-04
# Capture time: 18:17:22 GMT
# Captured by: ralcraft
# Platform: linux-64
#####################################################
# source bashrc for conda
for rcfile in ~/.bashrc ~/.bash_profile ~/.profile ~/.zshrc; do [ -f "$rcfile" ] && source "$rcfile" && break; done
# Using conda executable conda: /home/ralcraft/miniforge3/envs/pytest/bin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/envs/pytest/bin/conda
#####################################################

conda env remove --name stj -y 2>/dev/null || true
conda create --no-default-packages --name stj -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# activate environment
conda activate stj

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################

# languages:
CONDA_BASE=$(conda info --base)
ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then \
    PREFIX="x86_64-conda-linux-gnu"; \
elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then \
    PREFIX="aarch64-conda-linux-gnu"; \
fi

# Symlink all compiler/binutils tools
for tool in \
    gcc g++ gfortran cpp cc c++ f77 f95 \
    ar nm ranlib ld ld.gold as \
    strip objdump objcopy addr2line \
    c++filt elfedit gprof readelf size strings \
    gcc-ar gcc-nm gcc-ranlib; do \
    if command -v $tool > /dev/null 2>&1; then \
        ln -sf $(which $tool) $CONDA_BASE/bin/${PREFIX}-$tool; \
    fi; \
done
conda install -y  'r-base=4.5.2' r-remotes r-biocmanager
conda install -y  'python=3.14'
python -m site
conda env config vars set PYTHONNOUSERSITE=1
conda deactivate
conda activate stj
# r-conda:
conda install -y  --no-update-deps \
'r-png' \
'r-terra' \
'r-units' \
'r-s2' \
'r-magick' \
'r-reticulate' \
'r-raster' \
'r-httpuv' \
'r-sf' \
'r-shiny' \
'r-miniUI' \
'r-spdep' 
# bioc-package:
Rscript -e 'BiocManager::install("stJoincount", dependencies=TRUE, Ncpus=4)'


cat > ${CONDA_PREFIX}/bin/validate.sh << 'VALIDATE_EOF'
#!/usr/bin/env bash
echo "COBLE validation: No script has been specified for stj environment."
VALIDATE_EOF
chmod +x ${CONDA_PREFIX}/bin/validate.sh

