# Get conda environment path
conda_prefix <- Sys.getenv("CONDA_PREFIX")

# Only look at packages in the conda environment
if (conda_prefix != "") {
    conda_lib_path <- file.path(conda_prefix, "lib", "R", "library")
    .libPaths(conda_lib_path)
}

ip <- as.data.frame(installed.packages()[, c("Package", "Version", "LibPath")])
fields <- c("Source", "RemoteType", "RemoteRepo", "RemoteUsername", "RemoteRef", "RemoteSha")

get_info <- function(pkg, lib) {
    desc_file <- file.path(lib, pkg, "DESCRIPTION")
    info <- setNames(rep(NA_character_, length(fields)), fields)
    if (file.exists(desc_file)) {
        desc <- tryCatch(read.dcf(desc_file), error=function(e) NULL)
        if (!is.null(desc)) {
            info["Source"] <- if ("Repository" %in% colnames(desc)) desc[1, "Repository"] else "System/Manual"
            for (f in fields[-1]) if (f %in% colnames(desc)) info[f] <- desc[1, f]
        }
    } else {
        info["Source"] <- "System/Manual"
    }
    info
}

# Get output filename from environment variable
# make a temp file for the r packages
output_file <- "r-packages-for-coble.txt"

if (nrow(ip) > 0) {
    infos <- t(mapply(get_info, ip$Package, ip$LibPath, SIMPLIFY=TRUE))
    ip <- cbind(ip, as.data.frame(infos, stringsAsFactors=FALSE))
    write.table(ip[, c("Package", "Version", fields)], 
                file=output_file, 
                row.names=FALSE, sep="\t", quote=FALSE)
} else {
    write.table(data.frame(Package=character(), Version=character(), Source=character(),
                         RemoteType=character(), RemoteRepo=character(), RemoteUsername=character(),
                         RemoteRef=character(), RemoteSha=character()),
                file=output_file, 
                row.names=FALSE, sep="\t", quote=FALSE)
}