# ============================================
# Reproduce Bach & Pensa et al. 2021
# ============================================

# Rscript pipeline.R <GOAL> <STEP>
# GOAL: A=their data/plots, B=rerun 2018 tools, C=modern tools
# STEP: 1=normalisation, 2=batch correction, 3=umap, 4=clustering, 5=plots

args <- commandArgs(trailingOnly = TRUE)
GOAL <- if (length(args) >= 1) args[1] else "A"
STEP <- if (length(args) >= 2) as.integer(args[2]) else 5

cat("============================================\n")
cat("Reproduce Bach & Pensa et al. 2021\n")
cat("GOAL:", GOAL, "| STEP:", STEP, "\n")
cat("============================================\n")

GITHUB <- "/home/ralcraft/DEV/gh-rse/BCRDS/coble/githubs/Tumorigenesis2018/src/Tumorigenesis/"
PATH <- paste0(GITHUB, "data/Tumorigenesis/")
oldwd <- getwd()
setwd(GITHUB)

# ============================================
# GOAL A - straight to plots
# ============================================
if (GOAL == "A") STEP <- 5

# ============================================
# FIX DEPOSITED RDS - set colnames from barcode
# (deposited object stores identity in barcode column not colnames)
# ============================================
if (GOAL == "B" && STEP == 1) {
  cat("[", format(Sys.time()), "] Preparing starting RDS\n")
  library(SingleCellExperiment)
  library(SummarizedExperiment)

  sce <- readRDS("../../data/Tumorigenesis/Robjects/BRCA1_SCE.rds")
  sce <- sce[, sce@colData$Experiment == "Tumorigenesis"]

  # Fix 1 - set colnames from barcode
  colnames(sce) <- sce@colData$barcode
  cat("[", format(Sys.time()), "] colnames set from barcode\n")

  # Fix 2 - add KeepForHvg
  mito <- grepl("^mt-", rownames(sce@assays@data[[1]]))
  ribo <- grepl("^Rp[sl]", rownames(sce@assays@data[[1]]))
  rowData(sce)$KeepForHvg <- !mito & !ribo
  cat("[", format(Sys.time()), "] KeepForHvg added -",
      sum(rowData(sce)$KeepForHvg), "genes kept\n")

  # Save as their expected input
  saveRDS(sce, "../../data/Tumorigenesis/Robjects/SCE_QC.rds")
  cat("[", format(Sys.time()), "] Starting RDS saved\n")
}
# ============================================
# GOAL B - run their scripts in order
# ============================================
if (GOAL == "B" && STEP <= 1) {
   cat("[", format(Sys.time()), "] Norming\n")
   source("04_Normalization.R")
}

if (GOAL == "B" && STEP <= 2) {

  if (!file.exists("../../data/Tumorigenesis/Robjects/QC_Part2.csv")) {
    tmp <- readRDS("../../data/Tumorigenesis/Robjects/SCE_QC_norm.rds")
    qcMets <- data.frame(
        barcode = tmp@colData$barcode,
        DbltScore = 0,
        isRbc = FALSE,
        isDoubletFinal = FALSE,
        isPotDamaged = FALSE
    )
    write.csv(qcMets, "../../data/Tumorigenesis/Robjects/QC_Part2.csv")
    cat("[", format(Sys.time()), "] Dummy QC_Part2.csv created -", nrow(qcMets), "cells\n")
    rm(tmp)
  }

  cat("[", format(Sys.time()), "] Batch correcting\n")
  source("08_BatchCorrection.R")
}

if (GOAL == "B" && STEP <= 3) {
  cat("[", format(Sys.time()), "] Starting UMAP\n")
  source("09_computeUMAP.R")
}
if (GOAL == "B" && STEP <= 4) {
  cat("[", format(Sys.time()), "] Clustering\n")
  source("10_Clustering.R")
}

# ============================================
# STEP 5 - Plots
# ============================================
if (STEP <= 5) {
  cat("[", format(Sys.time()), "] Generating sanity plots\n")
  source("13_sanity_plot.R")
}

# ============================================
# SESSION INFO
# ============================================
cat("[", format(Sys.time()), "] Writing session info\n")
f <- paste0("G", GOAL, "_session_info.txt")
sink(f)
print(sessionInfo())
sink()
cat("[", format(Sys.time()), "] Session info saved:", f, "\n")

setwd(oldwd)