#!/usr/bin/env bash

echo "Testing svd package installation and fortran compatibility..."

Rscript - << 'EOF'
library(svd)
set.seed(42)
m <- matrix(rnorm(1000), nrow=50, ncol=20)
ppk <- propack.svd(m, neig=5)
pca <- t(ppk$d * t(ppk$u))
cat("SVD dims:", dim(pca), "\n")
cat("First singular value:", ppk$d[1], "\n")
cat("propack.svd OK\n")
EOF


echo "Testing all libraries load correctly together..."

Rscript - << 'EOF'
library(lattice)
library(chron)
library(DBI)
library(BH)
library(assertthat)
library(MASS)
library(digest)
library(RColorBrewer)
library(dichromat)
library(munsell)
library(labeling)
library(stringr)
library(R6)
library(lazyeval)
library(codetools)
library(Rcpp)
library(plyr)
library(Matrix)
library(gtable)
library(scales)
library(reshape2)
library(svd)
library(data.table)
library(ggplot2)
library(dplyr)
library(Rtsne)
library(pheatmap)
set.seed(42)
m <- matrix(rnorm(1000), nrow=50, ncol=20)
ppk <- propack.svd(m, neig=5)
pca <- t(ppk$d * t(ppk$u))
cat("SVD dims:", dim(pca), "\n")
cat("First singular value:", ppk$d[1], "\n")
cat("All libraries loaded and propack.svd OK\n")
EOF