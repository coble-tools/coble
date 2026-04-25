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

# ============================================
# STEP 0 - Load DATA or CHECKPOINT LOADER
# ============================================
if (GOAL == "A" || STEP == 1) {
  message("[", Sys.time(), "] Loadeding - ", paste0(PATH, "BRCA1_SCE.rds"))
  sce_tumour <- readRDS(paste0(PATH, "BRCA1_SCE.rds"))
  sce_tumour <- sce_tumour[, sce_tumour$Experiment == "Tumorigenesis"]
  message("[", Sys.time(), "] RDS loaded - ", ncol(sce_tumour), " cells, ", nrow(sce_tumour), " genes")
  if (GOAL == "A") {
    STEP <- "F"
  }
} else if (GOAL == "B" && STEP > 1) {
  if (STEP == 2) file_name <- paste0(PATH, "sce_tumour_G", GOAL, "_01_norm.rds")
  if (STEP == 3) file_name <- paste0(PATH, "sce_tumour_G", GOAL, "_02_hvg.rds")
  if (STEP == 4) file_name <- paste0(PATH, "sce_tumour_G", GOAL, "_03_mnn.rds")
  if (STEP == 5) file_name <- paste0(PATH, "sce_tumour_G", GOAL, "_04_umap.rds")
  message("[", Sys.time(), "] Loading - ", file_name)
  sce_tumour <- readRDS(file_name)
  message("[", Sys.time(), "] RDS loaded - ", ncol(sce_tumour), " cells, ", nrow(sce_tumour), " genes")

} else {

  message("[", Sys.time(), "] Error: GOAL must be A, B, C, D or E")
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

# ============================================
# STEP 1 - Normalisation
# ============================================
if (STEP <= 1) {
  cat("[", format(Sys.time()), "] Starting normalisation\n")

  library(scran)
  library(BiocSingular)
  library(BiocParallel)

  # Split by batch
  sce1 <- sce_tumour[, sce_tumour$Batch == 1]
  sce2 <- sce_tumour[, sce_tumour$Batch == 2]
  sce3 <- sce_tumour[, sce_tumour$Batch == 3]

  cat("[", format(Sys.time()), "] Cells per batch:",
      ncol(sce1), ncol(sce2), ncol(sce3), "\n")

  # Batch 1
  cat("[", format(Sys.time()), "] QuickCluster batch 1\n")
  set.seed(42)
  clusters <- quickCluster(sce1, method="igraph", use.ranks=TRUE,
      d=50, BSPARAM=IrlbaParam(), BPPARAM=MulticoreParam(4), min.mean=0.01)
  sce1 <- computeSumFactors(sce1, clusters=clusters)

  # Batch 2
  cat("[", format(Sys.time()), "] QuickCluster batch 2\n")
  set.seed(42)
  clusters <- quickCluster(sce2, method="igraph", use.ranks=TRUE,
      d=50, BSPARAM=IrlbaParam(), BPPARAM=MulticoreParam(4), min.mean=0.01)
  sce2 <- computeSumFactors(sce2, clusters=clusters)

  # Batch 3
  cat("[", format(Sys.time()), "] QuickCluster batch 3\n")
  set.seed(42)
  clusters <- quickCluster(sce3, method="igraph", use.ranks=TRUE,
      d=50, BSPARAM=IrlbaParam(), BPPARAM=MulticoreParam(4), min.mean=0.01)
  sce3 <- computeSumFactors(sce3, clusters=clusters)

  # multiBatchNorm
  cat("[", format(Sys.time()), "] Running multiBatchNorm\n")
  scemnorm <- batchelor::multiBatchNorm(sce1, sce2, sce3)
  sce_tumour <- cbind(scemnorm[[1]], scemnorm[[2]], scemnorm[[3]])

  f <- paste0(PATH, "sce_tumour_G", GOAL, "_01_norm.rds")
  saveRDS(sce_tumour, f)
  cat("[", format(Sys.time()), "] Saved:", f, "-", file.size(f)/1e6, "MB\n")
  STEP <- 1
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

  # Split by batch
  sce1 <- sce_tumour[, sce_tumour$Batch == 1]
  sce2 <- sce_tumour[, sce_tumour$Batch == 2]
  sce3 <- sce_tumour[, sce_tumour$Batch == 3]

  # Model variance per batch separately
  dec.var1 <- modelGeneVar(sce1)
  dec.var2 <- modelGeneVar(sce2)
  dec.var3 <- modelGeneVar(sce3)

  # Combine variance
  combVar <- combineVar(dec.var1, dec.var2, dec.var3)

  # Apply KeepForHvg filter then select HVGs
  combVar <- combVar[rowData(sce_tumour)$KeepForHvg, ]
  hvgs <- getTopHVGs(combVar)

  cat("[", format(Sys.time()), "] HVGs selected:", length(hvgs), "\n")

  metadata(sce_tumour)$hvgs <- hvgs

  f <- paste0(PATH, "sce_tumour_G", GOAL, "_02_hvg.rds")
  saveRDS(sce_tumour, f)
  cat("[", format(Sys.time()), "] Saved:", f, "-", file.size(f)/1e6, "MB\n")
}

exit(0)

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

  # Split by batch - matching their exact approach
  sce1 <- sce_tumour[, sce_tumour$Batch == 1]
  sce2 <- sce_tumour[, sce_tumour$Batch == 2]
  sce3 <- sce_tumour[, sce_tumour$Batch == 3]

  cat("[", format(Sys.time()), "] Cells per batch:",
      ncol(sce1), ncol(sce2), ncol(sce3), "\n")

  # Their exact parameters - note AnnoyParam commented out in their code
  set.seed(300)
  mnncor <- batchelor::fastMNN(sce1, sce2, sce3,
      BPPARAM = MulticoreParam(workers=4),
      k = 20,
      d = 50,
      BSPARAM = IrlbaParam(deferred=TRUE),
      cos.norm = FALSE,
      subset.row = metadata(sce_tumour)$hvgs)

  cat("[", format(Sys.time()), "] fastMNN complete - corrected dims:",
      dim(reducedDim(mnncor, "corrected")), "\n")
  cat("[", format(Sys.time()), "] Lost variance per batch:",
      metadata(mnncor)$merge.info$lost.var, "\n")

  # Store corrected PCs back
  reducedDim(sce_tumour, "corrected") <- reducedDim(mnncor, "corrected")

  f <- paste0(PATH, "sce_tumour_G", GOAL, "_03_mnn.rds")
  saveRDS(sce_tumour, f)
  cat("[", format(Sys.time()), "] Saved:", f, "-", file.size(f)/1e6, "MB\n")
  STEP <- 3
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

  library(umap)

  m.cor <- reducedDim(sce_tumour, "corrected")
  ump.cor <- umap(m.cor, random_state=42)

  reducedDim(sce_tumour, "UMAP") <- ump.cor$layout

  # Store the umap object for graph extraction in clustering
  metadata(sce_tumour)$umap <- ump.cor

  f <- paste0(PATH, "sce_tumour_G", GOAL, "_04_umap.rds")
  saveRDS(sce_tumour, f)
  cat("[", format(Sys.time()), "] Saved:", f, "-", file.size(f)/1e6, "MB\n")

}
# ============================================
# STEP 5 - Clustering
# ============================================
if (STEP <= 5 && GOAL == "B") {
  cat("[", format(Sys.time()), "] Starting clustering\n")

  library(igraph)
  library(scran)
  library(Matrix)
  source("functions.R")

  # Ensure cell order matches UMAP graph
  sce_tumour <- sce_tumour[, rownames(metadata(sce_tumour)$umap$knn$indexes)]

  # Extract UMAP graph
  cat("[", format(Sys.time()), "] Building graph from UMAP\n")
  igr.cor <- get_umap_graph(metadata(sce_tumour)$umap)

  # Walktrap clustering - steps=6 as per their code
  cat("[", format(Sys.time()), "] Running walktrap\n")
  set.seed(42)
  ump.wktrp <- cluster_walktrap(igr.cor, steps=6)
  sce_tumour$Cluster <- paste0("C", ump.wktrp$membership)

  cat("[", format(Sys.time()), "] Clusters before merging:",
      length(unique(sce_tumour$Cluster)), "\n")

  # Merge clusters
  cat("[", format(Sys.time()), "] Running mergeCluster\n")
  rmgenes <- rownames(sce_tumour)[!rowData(sce_tumour)$KeepForHvg]
  m <- logcounts(sce_tumour)
  merged <- mergeCluster(m, factor(sce_tumour$Cluster),
      removeGenes=rmgenes, block=sce_tumour$Batch)
  sce_tumour$Cluster <- merged$NewCluster
  sce_tumour$Cluster <- paste0("C", as.numeric(sce_tumour$Cluster))

  cat("[", format(Sys.time()), "] Clusters after merging:",
      length(unique(sce_tumour$Cluster)), "\n")

  f <- paste0(PATH, "sce_tumour_G", GOAL, "_05_clusters.rds")
  saveRDS(sce_tumour, f)
  cat("[", format(Sys.time()), "] Saved:", f, "-", file.size(f)/1e6, "MB\n")
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

cat("[", format(Sys.time()), "] Session info saved:", f, "\n")