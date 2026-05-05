# DESeq2 Vignettes reproduced for COBLE environment testing
# Original source: https://bioconductor.org/packages/3.10/bioc/vignettes/DESeq2/inst/doc/DESeq2.html
# Recreator: Rachel Alcraft, Institute of Cancer Research


# 1.2.2 SummarisedExperiment input
library("parathyroidSE")
data("parathyroidGenesSE")
se <- parathyroidGenesSE
colnames(se) <- se$run

library("DESeq2")
ddsPara <- DESeqDataSet(se = se, design = ~ patient + treatment)
ddsPara$treatment <- factor(ddsPara$treatment,
levels=c("Control","DPN","OHT"))
ddsPara

# 1.2.3 Count matrix input
library("pasilla")
library("Biobase")
data("pasillaGenes")
countData <- counts(pasillaGenes)
colData <- pData(pasillaGenes)[,c("condition","type")]

dds <- DESeqDataSetFromMatrix(countData = countData,colData = colData,design = ~ condition)
dds$condition <- factor(dds$condition,levels=c("untreated","treated"))
dds

# 1.2.4, HTSeq input
directory <- system.file("extdata", package="pasilla", mustWork=TRUE)
sampleFiles <- grep("treated",list.files(directory),value=TRUE)
sampleCondition <- sub("(.*treated).*","\\1",sampleFiles)
sampleTable <- data.frame(sampleName = sampleFiles,fileName = sampleFiles,condition = sampleCondition)
ddsHTSeq <- DESeqDataSetFromHTSeqCount(sampleTable = sampleTable,directory = directory,design= ~ condition)
ddsHTSeq$condition <- factor(ddsHTSeq$condition,levels=c("untreated","treated"))
ddsHTSeq

# 1.2.5 Notes on factor leveels
dds$condition <- relevel(dds$condition, "untreated")
dds$condition <- droplevels(dds$condition)

# 1.3 Differential expression analysis
dds <- DESeq(dds)
res <- results(dds)
resOrdered <- res[order(res$padj),]
head(resOrdered)

# 1.4  Exploring results
# 1.4.1 MA-plot
png("DESeq2_MA_plot.png", width=800, height=600)
plotMA(res, main="DESeq2", ylim=c(-2,2))
dev.off()
