# code/coble build --recipe recipes/papers/DESeq2/DESeq2_2026.cbl --env deseq206 --rebuild

# code/coble-disentangle.py recipes/papers/DESeq2/DESeq2_2026_export.cbl recipes/papers/DESeq2/DESeq2_2026_network.txt
# python code/coble-plot-network.py recipes/papers/DESeq2/DESeq2_2026_network.txt --hue date --out recipes/papers/DESeq2/DESeq2_2026_networkd.html
# python code/coble-plot-network.py recipes/papers/DESeq2/DESeq2_2026_network.txt --hue manager --out recipes/papers/DESeq2/DESeq2_2026_networkm.html

coble:
  - environment: DESeq2
channels:
  - bioconda
  - conda-forge
languages:
  - r-base=4.5.2
compilers:
  - compile-tools: true
  - cran-repo: https://packagemanager.posit.co/cran/2026-04-01
flags:
  - system-tools: true
bioc-conda:
  - DESeq2





