#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
#######################################
coble:
  - environment: monopogen
channels:
  - bioconda
  - conda-forge
languages:
  - r-base=4.2
  - python=3.8
conda:
  - pandas
  - pysam
  - NumPy
  - sciPy
  - pillow
  - zlib
r-conda:
  - data.table
  - e1071
  - ggplot2

# High throughput sequencing tools
conda:
  - htslib
  - samtools
  - bcftools
  - vcftools

# Monopogen repo
pip:
  - https://github.com/KChen-lab/Monopogen.git
bash:
  - rm -rf $CONDA_PREFIX/Monopogen
  - git clone https://github.com/KChen-lab/Monopogen.git $CONDA_PREFIX/Monopogen
  - ln -sf "$CONDA_PREFIX/bin/samtools" "$CONDA_PREFIX/Monopogen/apps/samtools"




