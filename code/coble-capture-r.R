# Get conda environment path
conda_prefix <- Sys.getenv("CONDA_PREFIX")
# get the first input for a file name
output_file <- commandArgs(trailingOnly=TRUE)[1]

# Only look at packages in the conda environment
if (conda_prefix != "") {
    conda_lib_path <- file.path(conda_prefix, "lib", "R", "library")
    .libPaths(conda_lib_path)
}

ip <- as.data.frame(installed.packages()[, c("Package", "Version", "LibPath")])
fields.check <- c("Source", "biocViews", "RemoteType", "RemoteRepo", "RemoteUsername", "RemoteRef", "RemoteSha")
fields.out <- c("Source", "RemoteType", "RemoteRepo", "RemoteUsername", "RemoteRef", "RemoteSha")

get_info <- function(pkg, lib) {
    desc_file <- file.path(lib, pkg, "DESCRIPTION")
    info <- setNames(rep(NA_character_, length(fields.check)), fields.check)
    if (file.exists(desc_file)) {
        desc <- tryCatch(read.dcf(desc_file), error=function(e) NULL)
        if (!is.null(desc)) {
            # Set Source from Repository if present
            if ("Repository" %in% colnames(desc)) {
                info["Source"] <- desc[1, "Repository"]
            } else if ("biocViews" %in% colnames(desc)) {
                info["Source"] <- "Bioconductor"
            } else {
                info["Source"] <- "System/Manual  (unknown method)"
            }
            # Fill in other fields if present
            for (f in fields.out[-1]) if (f %in% colnames(desc)) info[f] <- desc[1, f]
        } else {
            info["Source"] <- "System/Manual  (unknown method)"
        }
    } else {
        info["Source"] <- "System/Manual (unknown method)"
    }
    info
}

if (nrow(ip) > 0) {
    infos <- t(mapply(get_info, ip$Package, ip$LibPath, SIMPLIFY=TRUE))
    ip <- cbind(ip, as.data.frame(infos, stringsAsFactors=FALSE))   
    write.table(ip[, c("Package", "Version", fields.out)], 
                file=output_file, 
                row.names=FALSE, sep="\t", quote=FALSE)
} else {
    write.table(data.frame(Package=character(), Version=character(), Source=character(),
                         RemoteType=character(), RemoteRepo=character(), RemoteUsername=character(),
                         RemoteRef=character(), RemoteSha=character()),
                file=output_file, 
                row.names=FALSE, sep="\t", quote=FALSE)
}