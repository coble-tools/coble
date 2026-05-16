# ============================================
# Reproduce Bach & Pensa et al. 2021
# ============================================

# singularity shell Tumorigenesis.sif
# cd /home/ralcraft/DEV/gh-rse/BCRDS/coble/recipes/papers/tumorigenesis/validate/
# Rscript /home/ralcraft/DEV/gh-rse/BCRDS/coble/recipes/papers/tumorigenesis/validate/pipeline.R
# Rscript pipeline.R <GOAL> <STEP>
# e.g. Rscript pipeline.R B 1

library(SingleCellExperiment)
library(scater)
library(scran)
library(batchelor)
cat("[", format(Sys.time()), "] Libraries loaded\n")
# ============================================
# Reproduce Bach & Pensa et al. 2021
# ============================================
# Rscript pipeline.R <GOAL> <STEP>
# e.g. Rscript pipeline.R 1 1
args <- commandArgs(trailingOnly = TRUE)
GOAL <- if (length(args) >= 1) as.character(args[1]) else "A" # A=their data/their plots, B=rerun 2018 tools, C=modern tools
STEP <- if (length(args) >= 2) as.integer(args[2]) else 6 # 1=start, 2=post-norm, 3=post-hvg, 4=post-mnn, 5=post-umap, 6=plots

cat("[", format(Sys.time()), "] Starting - GOAL:", GOAL, "STEP:", STEP, "\n")

PATH <- "/home/ralcraft/DEV/gh-rse/BCRDS/coble/recipes/papers/tumorigenesis/data/"
GITHUB <- "/home/ralcraft/DEV/gh-rse/BCRDS/coble/githubs/Tumorigenesis2018/src/Tumorigenesis/"

# ============================================
# STEP 0 - Load DATA or CHECKPOINT LOADER
# ============================================
if (GOAL == "A" || STEP == 1) {
  message("[", format(Sys.time()), "] Loadeding - ", paste0(PATH, "BRCA1_SCE.rds"))
  sce_tumour <- readRDS(paste0(PATH, "BRCA1_SCE.rds"))
  sce_tumour <- sce_tumour[, sce_tumour$Experiment == "Tumorigenesis"]
  message("[", format(Sys.time()), "] RDS loaded - ", ncol(sce_tumour), " cells, ", nrow(sce_tumour), " genes")
  if (GOAL == "A") {
    STEP <- "F"
  }
} else if (GOAL == "B" && STEP > 1) {
  if (STEP == 2) file_name <- paste0(PATH, "sce_tumour_G", GOAL, "_01_norm.rds")
  if (STEP == 3) file_name <- paste0(PATH, "sce_tumour_G", GOAL, "_02_hvg.rds")
  if (STEP == 4) file_name <- paste0(PATH, "sce_tumour_G", GOAL, "_03_mnn.rds")
  if (STEP == 5) file_name <- paste0(PATH, "sce_tumour_G", GOAL, "_04_umap.rds")
  message("[", format(Sys.time()), "] Loading - ", file_name)
  sce_tumour <- readRDS(file_name)
  message("[", format(Sys.time()), "] RDS loaded - ", ncol(sce_tumour), " cells, ", nrow(sce_tumour), " genes")

} else {

  message("[", format(Sys.time()), "] Error: GOAL must be A, B, C, D or E")
  exit(1)

}

# Restore KeepForHvg regardless of goal or step
# (not stored in RDS - recreated from gene names)
mito <- grepl("^mt-", rownames(sce_tumour))
ribo <- grepl("^Rp[sl]", rownames(sce_tumour))
rowData(sce_tumour)$KeepForHvg <- !mito & !ribo
cat("[", format(Sys.time()), "] KeepForHvg restored -",
    sum(rowData(sce_tumour)$KeepForHvg), "genes kept\n")

# ============================================
# STEP 1 - Normalisation
# ============================================
#computeSumFactors per batch (clusters = Batch)
#min.mean = 0.1
#multiBatchNorm to scale across batches — we used logNormCounts instead!
# ============================================
oldwd <- getwd()
setwd(GITHUB)
# ============================================
# STEP 1 - Normalisation
# ============================================
if (STEP <= 1) {
  cat("[", format(Sys.time()), "] Starting normalisation\n")
  source("04_Normalization.R")
  cat("[", format(Sys.time()), "] Saved:", f, "-", file.size(f)/1e6, "MB\n")
}

# ============================================
# STEP 2 - HVG detection
# ============================================
#HVG — Highly Variable Genes
#Genes that vary more across cells than you'd expect from technical noise alone.
#The assumption is that if a gene varies a lot, that variation is likely biological —
#cell types expressing it differently — rather than just random measurement error.
#Only these genes for downstream analysis - the other genes are mostly noise.
#------------------------------
#block = Batch: Per-batch variance decomposition
#combineVar: across batches
#var.threshold = 0: All genes with positive residual variance kept
#(Ribosomal and mitochondrial genes excluded before this step — we haven't done this!)
# ============================================

# ============================================
# STEP 2 - HVG detection
# ============================================
if (GOAL != "A" & STEP <= 2) {
  cat("[", format(Sys.time()), "] Starting HVG detection\n")
  source("04_Normalization.R")
  cat("[", format(Sys.time()), "] Saved:", f, "-", file.size(f)/1e6, "MB\n")
}

# ============================================
# STEP 3 - Batch correction (fastMNN)
# ===========================================
#MNN — Mutual Nearest Neighbours
#for each cell in batch 1, find its nearest neighbours in batch 2, and vice versa.
#Pairs that are mutual nearest neighbours in both directions
#are assumed to be the same cell type across batches,
#and are used as anchors to correct the batch effect.
#fast MNN is an optimised implementation of this.
#------------------------------
#k = 20
#d = 50
#cos.norm.out = FALSE
#Run on HVGs only
#BSPARAM = RandomParam() — for approximate SVD (speed)
# ===========================================

# ============================================
# STEP 3 - Batch correction (fastMNN)
# ============================================
if (STEP <= 3 && GOAL == "B") {
  cat("[", format(Sys.time()), "] Starting fastMNN batch correction\n")
  source("08_BatchCorrection.R")
  cat("[", format(Sys.time()), "] Saved:", f, "-", file.size(f)/1e6, "MB\n")
}

# ============================================
# STEP 4 - UMAP
# ============================================
#UMAP — Uniform Manifold Approximation and Projection
#Dimensionality reduction technique — 50 dimensions coming out of fastMNN,
#UMAP squashes that down to 2 dimensions so you can plot it.
#UMAP tries to preserve the structure of the data —
#cells that are similar in 50 dimensions should end up close together in 2 dimensions,
#and cells that are different should end up far apart.
#For single cell, you can visually see:
#- Clusters of similar cells (cell types)
#- How close or far cell types are from each other biologically
#- Whether batch correction worked (batches should be mixed, not separated)
#---------------------------------------------------
#random_state = 42
#Default settings otherwise
#Computed on batch-corrected PCs
# ============================================

# ============================================
# STEP 4 - UMAP
# ============================================
if (STEP <= 4 && GOAL == "B") {
  cat("[", format(Sys.time()), "] Starting UMAP\n")
  source("09_computeUMAP.R")
  cat("[", format(Sys.time()), "] Saved:", f, "-", file.size(f)/1e6, "MB\n")

}
# ============================================
# STEP 5 - Clustering
# ============================================
if (STEP <= 5 && GOAL == "B") {
  cat("[", format(Sys.time()), "] Starting clustering\n")
  source("10_Clustering.R")
  cat("[", format(Sys.time()), "] Clustering complete\n")
}
# ============================================
# STEP 6 - Plots
# ============================================
if (STEP <= 6) {
  cat("[", format(Sys.time()), "] Generating UMAP plots\n")

  library(schex)

  sce_tumour <- make_hexbin(sce_tumour,
      nbins = 40,
      dimension_reduction = "UMAP")

  # Plot 1 - colour by their cell type labels
  f1 <- paste0(PATH, "G", GOAL, "_umap_celltypes.png")
  png(f1, width=3000, height=2700, res=300)
  print(plot_hexbin_meta(sce_tumour,
      col = "CellTypesFinal",
      action = "majority"))
  dev.off()
  cat("[", format(Sys.time()), "] Saved:", f1, "\n")

  # Plot 2 - colour by your clusters
  f2 <- paste0(PATH, "G", GOAL, "_umap_clusters.png")
  png(f2, width=3000, height=2700, res=300)
  print(plot_hexbin_meta(sce_tumour,
      col = "Cluster",
      action = "majority"))
  dev.off()
  cat("[", format(Sys.time()), "] Saved:", f2, "\n")

  cat("[", format(Sys.time()), "] All plots done\n")
}

message("[", Sys.time(), "] Done!")
# ============================================
# SESSION INFO
# ============================================
cat("[", format(Sys.time()), "] Writing session info\n")

f <- paste0(PATH, "G", GOAL, "_session_info.txt")
sink(f)
print(sessionInfo())
sink()


setwd(oldwd)
cat("[", format(Sys.time()), "] Session info saved:", f, "\n")