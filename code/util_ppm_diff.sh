#!/usr/bin/env bash
# Usage: bash code/util_ppm_diff.sh 2026-02-01 2026-02-15 output.txt
#   Use "latest" for either date

DATE1="${1:?Usage: $0 date1 date2 output.txt}"
DATE2="${2:?Provide end date or 'latest'}"
OUTFILE="${3:?Provide output file}"

Rscript - "$DATE1" "$DATE2" <<'EOF' | tee "$OUTFILE"
args <- commandArgs(trailingOnly = TRUE)
date1 <- args[1]
date2 <- args[2]

make_repo <- function(d) {
  if (d == "latest") "https://packagemanager.posit.co/cran/latest"
  else paste0("https://packagemanager.posit.co/cran/", d)
}

ap1 <- available.packages(repos = make_repo(date1))[, c("Package", "Version")]
ap2 <- available.packages(repos = make_repo(date2))[, c("Package", "Version")]

pkgs1 <- setNames(ap1[, "Version"], ap1[, "Package"])
pkgs2 <- setNames(ap2[, "Version"], ap2[, "Package"])

removed <- sort(setdiff(names(pkgs1), names(pkgs2)))
added   <- sort(setdiff(names(pkgs2), names(pkgs1)))

common <- intersect(names(pkgs1), names(pkgs2))
changed <- sort(common[pkgs1[common] != pkgs2[common]])

cat(sprintf("PPM Diff: %s -> %s\n\n", date1, date2))

cat(sprintf("Removed (%d):\n", length(removed)))
if (length(removed)) cat(paste(" -", removed, pkgs1[removed], collapse = "\n"), "\n")

cat(sprintf("\nAdded (%d):\n", length(added)))
if (length(added)) cat(paste(" +", added, pkgs2[added], collapse = "\n"), "\n")

cat(sprintf("\nChanged (%d):\n", length(changed)))
if (length(changed)) cat(paste(" ~", changed, pkgs1[changed], "->", pkgs2[changed], collapse = "\n"), "\n")
EOF