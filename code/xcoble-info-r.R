#!/usr/bin/env Rscript

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Parse arguments
args <- commandArgs(trailingOnly = TRUE)

# Default options
show_suggests <- FALSE
verbose <- FALSE
check_location <- FALSE
packages <- c()

# Parse flags and packages
i <- 1
while (i <= length(args)) {
  arg <- args[i]
  
  if (arg == "--help" || arg == "-h") {
    cat("Usage: Rscript check_package.R [OPTIONS] <package_name> [package_name2 ...]\n\n")
    cat("Options:\n")
    cat("  --suggests    Include Suggests dependencies\n")
    cat("  --verbose     Show detailed output\n")
    cat("  --location    Check if package is archived or on Bioconductor\n")
    cat("  --help, -h    Show this help message\n\n")
    cat("Examples:\n")
    cat("  Rscript check_package.R arrow\n")
    cat("  Rscript check_package.R --suggests arrow dplyr\n")
    cat("  Rscript check_package.R --location --verbose arrow\n")
    quit(status = 0)
  } else if (arg == "--suggests") {
    show_suggests <- TRUE
  } else if (arg == "--verbose") {
    verbose <- TRUE
  } else if (arg == "--location") {
    check_location <- TRUE
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

# Function to check if package is archived
check_if_archived <- function(pkg) {
  archive_url <- paste0("https://cran.r-project.org/src/contrib/Archive/", pkg, "/")
  archived <- tryCatch({
    readLines(archive_url, n = 1, warn = FALSE)
    TRUE
  }, error = function(e) FALSE)
  return(archived)
}

# Function to check if on Bioconductor
check_bioconductor <- function(pkg) {
  bioc_url <- paste0("https://bioconductor.org/packages/release/bioc/html/", pkg, ".html")
  on_bioc <- tryCatch({
    readLines(bioc_url, n = 1, warn = FALSE)
    TRUE
  }, error = function(e) FALSE)
  return(on_bioc)
}

# Main function to check package info
check_package_info <- function(pkg, show_suggests = FALSE, verbose = FALSE, check_location = FALSE) {
  cat("\n╔════════════════════════════════════════════╗\n")
  cat(sprintf("║  PACKAGE: %-32s ║\n", pkg))
  cat("╚════════════════════════════════════════════╝\n\n")
  
  # Check if installed
  installed <- requireNamespace(pkg, quietly = TRUE)
  
  if (installed) {
    desc <- packageDescription(pkg)
    cat("📦 INSTALLED VERSION\n")
    cat("   Version:", desc$Version, "\n")
    cat("   Date:", desc$`Date/Publication`, "\n")
    if (verbose && !is.null(desc$Built)) {
      cat("   Built:", desc$Built, "\n")
    }
    if (verbose && !is.null(desc$RemoteType)) {
      cat("   Source:", desc$RemoteType, "\n")
      if (!is.null(desc$GithubRepo)) {
        cat("   GitHub:", paste0(desc$GithubUsername, "/", desc$GithubRepo), "\n")
      }
    }
    cat("\n")
  } else {
    cat("📦 NOT INSTALLED\n\n")
  }
  
  # Check current available
  avail <- available.packages()
  if (pkg %in% rownames(avail)) {
    cat("🌐 CURRENT AVAILABLE\n")
    cat("   Version:", avail[pkg, "Version"], "\n")
    cat("   Repository:", avail[pkg, "Repository"], "\n")
    
    # Check if update needed
    if (installed) {
      inst_ver <- desc$Version
      avail_ver <- avail[pkg, "Version"]
      if (package_version(avail_ver) > package_version(inst_ver)) {
        cat("   ⚠️  UPDATE AVAILABLE:", inst_ver, "→", avail_ver, "\n")
      } else if (package_version(avail_ver) == package_version(inst_ver)) {
        cat("   ✓ Up to date\n")
      } else {
        cat("   ℹ️  Installed version is newer than available\n")
      }
    }
    cat("\n")
    
    # Dependencies
    which_deps <- c("Depends", "Imports", "LinkingTo")
    if (show_suggests) {
      which_deps <- c(which_deps, "Suggests")
    }
    
    cat("📚 DEPENDENCIES\n")
    deps <- tools::package_dependencies(pkg, which = which_deps, recursive = FALSE)
    
    if (length(deps[[1]]) > 0) {
      for (d in deps[[1]]) {
        cat("   -", d, "\n")
      }
      if (verbose) {
        cat("\n   Total:", length(deps[[1]]), "dependencies\n")
      }
    } else {
      cat("   - None\n")
    }
    
  } else {
    # Not in current CRAN - check other locations
    cat("🌐 NOT IN CURRENT REPOSITORIES\n\n")
    
    if (check_location) {
      cat("🔍 CHECKING OTHER LOCATIONS\n")
      
      # Check if archived
      if (check_if_archived(pkg)) {
        archive_url <- paste0("https://cran.r-project.org/src/contrib/Archive/", pkg, "/")
        cat("   ✓ Found in CRAN Archive\n")
        cat("   URL:", archive_url, "\n")
        cat("   Note: Package removed from CRAN but available in archive\n")
      } else {
        cat("   ✗ Not in CRAN Archive\n")
      }
      
      # Check Bioconductor
      if (check_bioconductor(pkg)) {
        bioc_url <- paste0("https://bioconductor.org/packages/release/bioc/html/", pkg, ".html")
        cat("   ✓ Found on Bioconductor\n")
        cat("   URL:", bioc_url, "\n")
        cat("   Install with: BiocManager::install('", pkg, "')\n", sep = "")
      } else {
        cat("   ✗ Not on Bioconductor\n")
      }
      
      # If not found anywhere
      if (!check_if_archived(pkg) && !check_bioconductor(pkg) && !installed) {
        cat("\n   ❌ Package not found in any known location\n")
        cat("   Possible reasons:\n")
        cat("     • Typo in package name (case-sensitive)\n")
        cat("     • GitHub-only package\n")
        cat("     • Package never existed\n")
      }
    } else {
      cat("   Use --location flag to check if archived or on Bioconductor\n")
    }
  }
  
  cat("\n")
}

# Process each package
for (pkg in packages) {
  check_package_info(pkg, 
                    show_suggests = show_suggests, 
                    verbose = verbose,
                    check_location = check_location)
}