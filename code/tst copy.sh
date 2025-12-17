#!/bin/bash

# Default values
pkg=""
ver=""
all=false
skip_variants=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --pkg)
      pkg="$2"
      shift 2
      ;;
    --version)
      ver="$2"
      shift 2
      ;;
    --all)
      all=true
      shift
      ;;
    --skip-variants)
      skip_variants=true
      shift
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

if [[ -z "$pkg" ]]; then
  echo "Usage: $0 --pkg <name> [--version <ver>] [--all]"
  exit 1
fi

echo "Searching for package: $pkg (version: ${ver:-any})"

# Helper: check and optionally exit
check_and_print() {
  local source=$1
  local output=$2
  if [[ -n "$output" ]]; then
    echo "$source:"
    echo "$output"
    if [[ $all == false ]]; then
      exit 0
    fi
  fi
}

# Priority order
# Define the variants 
variants=("$pkg")
if [[ "$skip_variants" != true ]]; then 
    variants+=("r-$pkg" "bioconductor-$pkg") 
fi

for variant in "${variants[@]}"; do 
    echo "Checking variant: $variant"

    # --- Conda (bioconda) ---
    bioconda=$(curl -s "https://api.anaconda.org/package/bioconda/$pkg" | \
    grep -o '"version": *"[^"]*"' | cut -d'"' -f4 | \
    awk -v p="$variant" -v v="$ver" '{if (v=="" || $1==v) print "  " p " " $1}'| head -n1)
    check_and_print "Conda (bioconda)" "$bioconda"

    # --- Conda (conda-forge) ---
    condaforge=$(curl -s "https://api.anaconda.org/package/conda-forge/$pkg" | \
    grep -o '"version": *"[^"]*"' | cut -d'"' -f4 | \
    awk -v p="$variant" -v v="$ver" '{if (v=="" || $1==v) print "  " p " " $1}'| head -n1)
    check_and_print "Conda (conda-forge)" "$condaforge"

    # --- Conda (r) ---
    condar=$(curl -s "https://api.anaconda.org/package/r/$pkg" | \
    grep -o '"version": *"[^"]*"' | cut -d'"' -f4 | \
    awk -v p="$variant" -v v="$ver" '{if (v=="" || $1==v) print "  " p " " $1}'| head -n1)
    check_and_print "Conda (r)" "$condar"
done

# --- CRAN ---
cran=$(curl -s https://cran.r-project.org/src/contrib/PACKAGES | \
awk -v p="$pkg" -v v="$ver" '
  /^Package:/ {pkgname=$2}
  /^Version:/ {pkgver=$2}
  pkgname==p {
    if (v=="" || pkgver==v) {print "  " pkgname " " pkgver}
  }
')
check_and_print "CRAN" "$cran"

# --- Bioconductor ---
bio=$(curl -s https://bioconductor.org/packages/release/bioc/VIEWS | \
awk -v p="$pkg" -v v="$ver" '
  /^Package:/ {pkgname=$2}
  /^Version:/ {pkgver=$2}
  pkgname==p {
    if (v=="" || pkgver==v) {print "  " pkgname " " pkgver}
  }
'| head -n1)
check_and_print "Bioconductor" "$bio"

# --- R-Forge ---
rforge=$(curl -s "https://r-forge.r-project.org/R/?group_id=0" | grep -i "$pkg")
check_and_print "R-Forge" "$rforge"

echo "not found"
