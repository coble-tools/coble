# Figure 1c: compare stored UMAP with staged recomputation
# Usage: Rscript ra.code/fig1c.R

suppressPackageStartupMessages({
  library(Seurat)
  library(ggplot2)
  library(gridExtra)
})

source("ra.code/source.R")

args <- commandArgs(trailingOnly = TRUE)
plot_folder <- if (length(args) >= 1 && nzchar(args[1])) args[1] else "plots/"
dir.create(plot_folder, recursive = TRUE, showWarnings = FALSE)

no_good <- c(42, 2025, 1953)
good <- c(123)
seeds <- c(123, 19, 43, 10000, 191)

seurat_obj <- readRDS('GitHub/EPI-clone/data/larry_seurat.rds')

for (seed in seeds) {
    set.seed(seed)
    cat("Set seed:", seed, "\n")

    prefix <- paste0(getRversion(), "_", seed, "_")
    out_plot <- paste0(plot_folder, prefix, "Fig.1c_plot.png")

    if (!("integrated" %in% Assays(seurat_obj))) {
    stop("No 'integrated' assay found in object")
    }
    if (!("pca" %in% Reductions(seurat_obj))) {
    stop("No stored 'pca' reduction found in object")
    }
    if (!("umap" %in% Reductions(seurat_obj))) {
    stop("No stored 'umap' reduction found in object")
    }
    if (!("CellType" %in% colnames(seurat_obj@meta.data))) {
    stop("No 'CellType' metadata column found in object")
    }

    # stage meanings:
    # 1 = ScaleData -> PCA -> UMAP -> plot
    # 2 = PCA -> UMAP -> plot
    # 3 = UMAP -> plot (from stored PCA)
    # 4 = plot only (stored UMAP)
    build_stage_plot <- function(obj, stage, seed_use = 42) {
    cat("\n=====================\n")
    cat("Building stage", stage, "\n")

    if (!(stage %in% 1:4)) {
        stop("stage must be one of 1, 2, 3, 4")
    }

    work <- obj
    DefaultAssay(work) <- "integrated"

    pca_reduction <- "pca"
    umap_reduction <- "umap"
    if (stage == 1) { title <- "ScaleData -> PCA -> UMAP" }
    else if (stage == 2) { title <- "PCA -> UMAP" }
    else if (stage == 3) { title <- "UMAP from stored PCA" }
    else if (stage == 4) { title <- "Stored UMAP"}


    if (stage <= 1) {
        cat("Running ScaleData...\n")
        work <- ScaleData(work, verbose = FALSE)
    }

    if (stage <= 2) {
        cat("Running PCA...\n")
        pca_reduction <- paste0("pca_stage", stage)
        work <- RunPCA(
        work,
        npcs = 30,
        verbose = FALSE,
        reduction.name = pca_reduction,
        reduction.key = "PCS_"
        )
    }

    if (stage <= 3) {
        cat("Running UMAP...\n")
        umap_reduction <- paste0("umap_stage", stage)
        work <- RunUMAP(
        work,
        reduction = pca_reduction,
        dims = 1:8,
        verbose = FALSE,
        seed.use = seed_use,
        reduction.name = umap_reduction,
        reduction.key = "UMAPS_"
        )
    }

    p <- DimPlot(
        work,
        group.by = "CellType",
        reduction = umap_reduction
    ) +
        ggtitle(title) +
        NoAxes() +
        NoLegend() +
        scale_color_manual(values = color_map)

    list(plot = p, reduction = umap_reduction, title = title)
    }

    # Build the four requested stage plots
    res_stage4 <- build_stage_plot(seurat_obj, stage = 4, seed_use = seed) # plot
    res_stage3 <- build_stage_plot(seurat_obj, stage = 3, seed_use = seed) # umap, plot
    res_stage2 <- build_stage_plot(seurat_obj, stage = 2, seed_use = seed) # pca, umap, plot
    res_stage1 <- build_stage_plot(seurat_obj, stage = 1, seed_use = seed) # scale, pca, umap, plot




    # Save single images (requested names)
    #ggsave(out_scaledata_umap_plot, plot = res_stage1$plot, width = 4, height = 4, dpi = 300)
    #ggsave(out_pca_umap_plot, plot = res_stage2$plot, width = 4, height = 4, dpi = 300)
    #ggsave(out_umap_plot, plot = res_stage4$plot, width = 4, height = 4, dpi = 300)

    # Save overview image as "plot" (2x2)
    plot_grid <- gridExtra::arrangeGrob(
    res_stage4$plot,
    res_stage3$plot,
    res_stage2$plot,
    res_stage1$plot,
    ncol = 2
    )
    ggsave(out_plot, plot = plot_grid, width = 8.5, height = 8.5, dpi = 300)

    cat("Saved:", out_plot, "\n")

}