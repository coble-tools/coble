#!/usr/bin/env Rscript

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Parse arguments
args <- commandArgs(trailingOnly = TRUE)

# Default values
output_file <- "packages.tsv"
packages <- c()

# Parse arguments
i <- 1
while (i <= length(args)) {
  arg <- args[i]
  
  if (arg == "--help" || arg == "-h") {
    cat("Usage: Rscript check_package.R [OPTIONS] <package_name> [package_name2 ...]\n\n")
    cat("Options:\n")
    cat("  --output, -o FILE    Output file (default: packages.tsv)\n")
    cat("  --help, -h           Show this help message\n\n")
    cat("Output format (tab-delimited):\n")
    cat("  package_name  version  date  location  dependencies\n\n")
    cat("Examples:\n")
    cat("  Rscript check_package.R arrow\n")
    cat("  Rscript check_package.R -o my_packages.tsv arrow dplyr ggplot2\n")
    cat("  Rscript check_package.R --output packages.tsv arrow\n")
    quit(status = 0)
  } else if (arg == "--output" || arg == "-o") {
    i <- i + 1
    if (i <= length(args)) {
      output_file <- args[i]
    } else {
      cat("Error: --output requires a filename\n")
      quit(status = 1)
    }
  } else {
    packages <- c(packages, arg)
  }
  
  i <- i + 1
}

# Check if package names provided
if (length(packages) == 0) {
  cat("Error: No package name provided\n")
  cat("Use --help for usage information\n")
  quit(status = 1)
}

# Function to determine package location
get_package_location <- function(pkg) {
  # Check CRAN
  avail <- available.packages()
  if (pkg %in% rownames(avail)) {
    return("CRAN")
  }
  
  # Check if archived
  archive_url <- paste0("https://cran.r-project.org/src/contrib/Archive/", pkg, "/")
  archived <- tryCatch({
    readLines(archive_url, n = 1, warn = FALSE)
    TRUE
  }, error = function(e) FALSE)
  
  if (archived) {
    return("CRAN-ARCHIVED")
  }
  
  # Check Bioconductor
  bioc_url <- paste0("https://bioconductor.org/packages/release/bioc/html/", pkg, ".html")
  on_bioc <- tryCatch({
    readLines(bioc_url, n = 1, warn = FALSE)
    TRUE
  }, error = function(e) FALSE)
  
  if (on_bioc) {
    return("Bioconductor")
  }
  
  # Check if installed locally (might be GitHub)
  if (requireNamespace(pkg, quietly = TRUE)) {
    desc <- packageDescription(pkg)
    if (!is.null(desc$RemoteType)) {
      return(paste0("LOCAL-", toupper(desc$RemoteType)))
    }
    return("LOCAL")
  }
  
  return("NOT-FOUND")
}

# Function to get package info
get_package_info <- function(pkg) {
  location <- get_package_location(pkg)
  version <- NA
  date <- NA
  dependencies <- NA
  
  # Get version and date based on location
  if (location == "CRAN") {
    avail <- available.packages()
    version <- avail[pkg, "Version"]
    date <- NA  # CRAN available.packages() doesn't provide date
    
    # Get dependencies
    deps <- tools::package_dependencies(pkg, 
                                       which = c("Depends", "Imports", "LinkingTo"),
                                       recursive = FALSE)
    if (length(deps[[1]]) > 0) {
      dependencies <- paste(deps[[1]], collapse = ",")
    } else {
      dependencies <- ""
    }
    
  } else if (location == "CRAN-ARCHIVED") {
    # For archived, get from installed if available
    if (requireNamespace(pkg, quietly = TRUE)) {
      desc <- packageDescription(pkg)
      version <- desc$Version
      date <- desc$`Date/Publication`
      
      # Get dependencies from description
      deps_list <- c()
      for (dep_type in c("Depends", "Imports", "LinkingTo")) {
        if (!is.null(desc[[dep_type]])) {
          deps_list <- c(deps_list, desc[[dep_type]])
        }
      }
      dependencies <- paste(deps_list, collapse = ",")
    } else {
      version <- "ARCHIVED"
      date <- NA
      dependencies <- NA
    }
    
  } else if (location == "Bioconductor") {
    # Try to get from BiocManager if available
    if (requireNamespace("BiocManager", quietly = TRUE)) {
      # This is tricky - Bioconductor packages need BiocManager
      version <- "BIOC"
      date <- NA
      dependencies <- NA
    }
    
  } else if (grepl("^LOCAL", location)) {
    # Get from installed package
    desc <- packageDescription(pkg)
    version <- desc$Version
    date <- desc$`Date/Publication`
    
    # Get dependencies
    deps_list <- c()
    for (dep_type in c("Depends", "Imports", "LinkingTo")) {
      if (!is.null(desc[[dep_type]])) {
        # Clean up the dependency string
        dep_string <- desc[[dep_type]]
        # Remove version requirements and whitespace
        dep_string <- gsub("\\(.*?\\)", "", dep_string)
        dep_string <- gsub("\\s+", "", dep_string)
        deps_list <- c(deps_list, dep_string)
      }
    }
    dependencies <- paste(deps_list, collapse = ",")
    
  } else {
    # NOT-FOUND
    version <- NA
    date <- NA
    dependencies <- NA
  }
  
  return(data.frame(
    package = pkg,
    version = version,
    date = ifelse(is.na(date), "", as.character(date)),
    location = location,
    dependencies = ifelse(is.na(dependencies), "", as.character(dependencies)),
    stringsAsFactors = FALSE
  ))
}

# Create output file with headers if it doesn't exist
if (!file.exists(output_file)) {
  cat("Creating new file:", output_file, "\n")
  cat("package\tversion\tdate\tlocation\tdependencies\n", file = output_file)
} else {
  # Check if file has header
  first_line <- tryCatch(
    readLines(output_file, n = 1, warn = FALSE),
    error = function(e) ""
  )
  
  if (length(first_line) == 0 || !grepl("^package\t", first_line)) {
    cat("File exists but missing header. Adding header...\n")
    existing <- readLines(output_file, warn = FALSE)
    cat("package\tversion\tdate\tlocation\tdependencies\n", file = output_file)
    writeLines(existing, output_file, sep = "\n")
  } else {
    cat("Appending to existing file:", output_file, "\n")
  }
}

# Process each package and append to file
for (pkg in packages) {
  cat("Processing:", pkg, "... ")
  
  tryCatch({
    info <- get_package_info(pkg)
    
    # Format as tab-delimited
    line <- paste(info$package, info$version, info$date, info$location, 
                  info$dependencies, sep = "\t")
    
    # Append to file
    write(line, file = output_file, append = TRUE)
    
    cat("✓\n")
  }, error = function(e) {
    cat("ERROR:", e$message, "\n")
  })
}

cat("\nDone! Output written to:", output_file, "\n")
cat("Total packages processed:", length(packages), "\n")