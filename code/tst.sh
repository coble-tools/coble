#!/bin/bash

# Default values
pkg=""
ver=""
all=false
skip_variants=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --pkg) pkg="$2"; shift 2 ;;
    --version) ver="$2"; shift 2 ;;
    --all) all=true; shift ;;
    --skip-variants) skip_variants=true; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

if [[ -z "$pkg" ]]; then
  echo "Usage: $0 --pkg <name> [--version <ver>] [--all]"
  exit 1
fi

echo "Searching for package: $pkg (version: ${ver:-any})"

# Helper: print results and install command
check_and_print() {
    local source=$1
    local pkg_name=$2
    local pkg_ver=$3

    if [[ -z "$pkg_name" ]]; then return; fi

    echo "$source:"
    if [[ -n "$pkg_ver" ]]; then
        echo "  $pkg_name $pkg_ver"
    else
        echo "  $pkg_name"
    fi

    case $source in
        "Conda (bioconda)")
            [[ -n "$pkg_ver" ]] && echo "  Install: conda install -c bioconda $pkg_name=$pkg_ver" || echo "  Install: conda install -c bioconda $pkg_name"
            ;;
        "Conda (conda-forge)")
            [[ -n "$pkg_ver" ]] && echo "  Install: conda install -c conda-forge $pkg_name=$pkg_ver" || echo "  Install: conda install -c conda-forge $pkg_name"
            ;;
        "Conda (r)")
            [[ -n "$pkg_ver" ]] && echo "  Install: conda install -c r $pkg_name=$pkg_ver" || echo "  Install: conda install -c r $pkg_name"
            ;;
        "CRAN")
            echo "  Install: Rscript -e 'install.packages(\"$pkg_name\", repos=\"https://cran.r-project.org\")'"
            ;;
        "CRAN (archive)")
            echo "  Install: Rscript -e 'devtools::install_version(\"$pkg_name\", version=\"$pkg_ver\", repos=\"http://cran.us.r-project.org\")'"
            ;;
        Bioconductor*)
            echo "  Install: Rscript -e 'BiocManager::install(\"$pkg_name\")'"
            ;;
    esac

    if [[ $all == false ]]; then exit 0; fi
}

# Variants
variants=("$pkg")
if [[ "$skip_variants" != true ]]; then
    variants+=("r-$pkg" "bioconductor-$pkg")
fi

for variant in "${variants[@]}"; do
    echo "[coble-find] Checking variant: $variant"

    for channel in bioconda conda-forge r; do
        version=$(curl -s "https://api.anaconda.org/package/$channel/$variant" | \
                  grep -o '"version": *"[^"]*"' | cut -d'"' -f4 | head -n1)
        if [[ -n "$version" ]]; then
            check_and_print "Conda ($channel)" "$variant" "$version"
        fi
    done
done

# CRAN current
echo "[coble-find] Checking CRAN"
cran_line=$(curl -s https://cran.r-project.org/src/contrib/PACKAGES | \
awk -v p="$pkg" -v v="$ver" '
  /^Package:/ {pkgname=$2}
  /^Version:/ {pkgver=$2}
  tolower(pkgname)==tolower(p) {
    if (v=="" || tolower(pkgver)==tolower(v)) {print pkgname " " pkgver}
  }
')
if [[ -n "$cran_line" ]]; then
    IFS=' ' read -r pkg_name pkg_ver <<< "$cran_line"
    check_and_print "CRAN" "$pkg_name" "$pkg_ver"
fi

# CRAN archive
for candidate in "$pkg" "$(echo $pkg | tr '[:lower:]' '[:upper:]')" "$(echo ${pkg:0:1} | tr '[:lower:]' '[:upper:]')${pkg:1}"; do
  echo "[coble-find] Checking candidate $candidate"
  url="https://cran.r-project.org/src/contrib/Archive/$candidate/"
  pkg_entry=$(curl -s "$url" | grep -Eo '[A-Za-z0-9]+_[0-9][^"]*\.tar\.gz' | head -n1)
  if [[ -n "$pkg_entry" ]]; then
    IFS='_' read -r pkg_name verpart <<< "$pkg_entry"
    pkg_ver=${verpart%.tar.gz}
    check_and_print "CRAN (archive)" "$pkg_name" "$pkg_ver"
  fi
done

# Bioconductor current
declare -A bioc_variants=(
  ["main"]="https://bioconductor.org/packages/release/bioc/VIEWS"
  ["experiment"]="https://bioconductor.org/packages/release/data/experiment/VIEWS"
  ["annotation"]="https://bioconductor.org/packages/release/data/annotation/VIEWS"
  ["workflows"]="https://bioconductor.org/packages/release/workflows/VIEWS"
)

for category in "${!bioc_variants[@]}"; do
  url="${bioc_variants[$category]}"
  bio_line=$(curl -s "$url" | \
  awk -v p="$pkg" -v v="$ver" '
    /^Package:/ {pkgname=$2}
    /^Version:/ {
      if (tolower(pkgname)==tolower(p)) {
        pkgver=$2
        if (v=="" || tolower(pkgver)==tolower(v)) {
          print pkgname " " pkgver
          exit
        }
      }
    }
  ')
  if [[ -n "$bio_line" ]]; then
    IFS=' ' read -r pkg_name pkg_ver <<< "$bio_line"
    check_and_print "Bioconductor ($category)" "$pkg_name" "$pkg_ver"
  fi
done

# Bioconductor archives
archive_releases=("3.14" "3.12" "3.10")
for rel in "${archive_releases[@]}"; do
  url="https://bioconductor.org/packages/${rel}/bioc/VIEWS"
  bio_line=$(curl -s "$url" | \
  awk -v p="$pkg" -v v="$ver" -v r="$rel" '
    /^Package:/ {pkg=$2}
    /^Version:/ {
      if (tolower(pkg)==tolower(p)) {
        ver=$2
        if (v=="" || tolower(ver)==tolower(v)) {
          print pkg " " ver
          exit
        }
      }
    }
  ')
  if [[ -n "$bio_line" ]]; then
    IFS=' ' read -r pkg_name pkg_ver <<< "$bio_line"
    check_and_print "Bioconductor archive ($rel)" "$pkg_name" "$pkg_ver"
  fi
done

# R-Forge
rforge=$(curl -s "https://r-forge.r-project.org/R/?group_id=0" | grep -i "$pkg")
check_and_print "R-Forge" "$pkg" ""

echo "[coble-find] completed"
