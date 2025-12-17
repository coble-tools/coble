#!/bin/bash

echo "[coble-find]" >&2

# Default values
pkg=""
ver=""
all=false
skip_variants=false

# declare associative array once at the top of your script 
declare -A VARIANT_MANAGERS

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --pkg) pkg="$2"; shift 2 ;;
    --version) ver="$2"; shift 2 ;;
    --all) all=true; shift ;;
    --skip-variants) skip_variants=true; shift ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "$pkg" ]]; then
  echo "Usage: $0 --pkg <name> [--version <ver>] [--all]" >&2
  exit 1
fi

echo "[coble-find] ~~~ Searching for package: $pkg (version: ${ver:-any}) ~~~" >&2

# Helper: print results and install command
check_and_print() {
    local source=$1
    local pkg_name=$2
    local pkg_ver=$3
    local pkg_orig=$4
    local channel=$5

    if [[ -z "$pkg_name" ]]; then return; fi

    name_ver="$pkg_name"

    echo "$source" >&2
    if [[ -n "$pkg_ver" ]]; then
        echo "  $pkg_name $pkg_ver" >&2
        name_ver="$pkg_name=$pkg_ver"
    else
        echo "  $pkg_orig" >&2
    fi

    case $source in
        "Conda (bioconda)")
            recipe_line="conda install -y -c $channel '$name_ver'"
            manager="conda-bioc:"
            ;;
        "Conda (conda-forge)")
            recipe_line = "conda install -y -c $channel '$name_ver'"
            manager="conda:"
            ;;
        "Conda (r)")
            recipe_line="conda install -y -c $channel '$name_ver'"
            manager="conda-r:"
            ;;
        "CRAN")
            recipe_line="Rscript -e 'install.packages(\"$pkg_name\", repos=\"https://cran.r-project.org\")'"
            manager="cran:"
            ;;
        "CRAN (archive)")
            recipe_line="Rscript -e 'devtools::install_version(\"$pkg_name\", version=\"$pkg_ver\", repos=\"http://cran.us.r-project.org\")'"
            manager="cran:"
            ;;
        Bioconductor*)
            if [[ -n "$pkg_ver" ]]; then
                recipe_line="Rscript -e 'BiocManager::install(\"$pkg_name\", version=\"$pkg_ver\")'"
            else
                recipe_line="Rscript -e 'BiocManager::install(\"$pkg_name\")'"
            fi
            manager="bioconductor:"
            ;;
        "R-Forge")
            recipe_line="Rscript -e 'install.packages(\"$pkg_name\", repos=c(\"http://R-Forge.R-project.org\",\"http://cran.r-project.org\"), dependencies=TRUE)'"
            manager="rforge:"
            ;;
    esac

    yaml_line="  - $pkg_name"
    [[ -n "$pkg_ver" ]] && yaml_line+="=$pkg_ver"

    if [[ $all == false ]]; then
        echo "$manager"
        echo "$recipe_line"
        echo "$yaml_line"
        exit 0
    fi
}


# Build variants and map
variants=("$pkg")
VARIANT_MANAGERS["$pkg"]="Conda (conda-forge)"

if [[ "$skip_variants" != true ]]; then
    variants+=("r-$pkg")
    VARIANT_MANAGERS["r-$pkg"]="Conda (r)"
    
    variants+=("bioconductor-$pkg")
    VARIANT_MANAGERS["bioconductor-$pkg"]="Conda (bioconda)"
fi

for variant in "${variants[@]}"; do
    echo "[coble-find] Checking variant: $variant" >&2
    manager="${VARIANT_MANAGERS[$variant]}"
    
    # Fixed: either remove this check or complete it
    if [[ -n "$variant" ]]; then  # Check if variant is not empty
        for channel in bioconda conda-forge r; do
            version=$(curl -s "https://api.anaconda.org/package/$channel/$variant" | \
                      grep -o '"version": *"[^"]*"' | cut -d'"' -f4 | head -n1)
            if [[ -n "$version" ]]; then
                check_and_print "$manager" "$variant" "$version" "$pkg" "$channel"
            fi
        done
    fi
done

echo "[coble-find] Checking CRAN" >&2
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
    check_and_print "CRAN" "$pkg_name" "$pkg_ver" "$pkg" "$channel"
fi

for candidate in "$pkg" "$(echo $pkg | tr '[:lower:]' '[:upper:]')" "$(echo ${pkg:0:1} | tr '[:lower:]' '[:upper:]')${pkg:1}"; do
  echo "[coble-find] Checking candidate $candidate" >&2
  url="https://cran.r-project.org/src/contrib/Archive/$candidate/"
  pkg_entry=$(curl -s "$url" | grep -Eo '[A-Za-z0-9]+_[0-9][^"]*\.tar\.gz' | head -n1)
  if [[ -n "$pkg_entry" ]]; then
    IFS='_' read -r pkg_name verpart <<< "$pkg_entry"
    pkg_ver=${verpart%.tar.gz}
    check_and_print "CRAN (archive)" "$pkg_name" "$pkg_ver" "$pkg" "$channel"
  fi
done

echo "[coble-find] Checking Bioconductor" >&2
declare -A bioc_variants=(
  ["main"]="https://bioconductor.org/packages/release/bioc/VIEWS"
  ["experiment"]="https://bioconductor.org/packages/release/data/experiment/VIEWS"
  ["annotation"]="https://bioconductor.org/packages/release/data/annotation/VIEWS"
  ["workflows"]="https://bioconductor.org/packages/release/workflows/VIEWS"
)

for category in "${!bioc_variants[@]}"; do
  echo "[coble-find] Checking category $category" >&2
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
    check_and_print "Bioconductor ($category)" "$pkg_name" "$pkg_ver" "$pkg" "$channel"
  fi
done

archive_releases=("3.14" "3.12" "3.10")
for rel in "${archive_releases[@]}"; do
  echo "[coble-find] Checking archive $rel" >&2
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
    check_and_print "Bioconductor archive ($rel)" "$pkg_name" "$pkg_ver" "$pkg" "$channel"
  fi
done

echo "[coble-find] Checking r-forge" >&2
rforge=$(curl -s "https://r-forge.r-project.org/R/?group_id=0" | grep -i "$pkg")
if [[ -n "$rforge" ]]; then
    check_and_print "R-Forge" "$pkg" "" "$pkg" "$channel"
fi

echo "not found" >&2

# If we reach here without exiting, still emit the three stdout lines (empty)
echo "unknown"
echo "$recipe_line"
echo "$yaml_line"
