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
  pkg_ver=$pkg
  if [[ $ver != "" ]]; then
      pkg_ver+="=$ver"
  fi
  if [[ -n "$output" ]]; then
    echo "$source:"
    echo "$output"
    case $source in
      "Conda (bioconda)")
        echo "  Install: conda install -c bioconda $pkg_ver"
        ;;
      "Conda (conda-forge)")
        echo "  Install: conda install -c conda-forge $pkg_ver"
        ;;
      "Conda (r)")
        echo "  Install: conda install -c r $pkg_ver"
        ;;
      "CRAN")
        echo "  Install: Rscript -e 'install.packages(\"$pkg\", repos=\"https://cran.r-project.org\")'"
        ;;
      "CRAN (archive)")
        echo "  Install: Rscript -e 'devtools::install_version(\"$pkg\", version=\"$ver\", repos=\"http://cran.us.r-project.org\")'"
        ;;
      Bioconductor*)
        echo "  Install: Rscript -e 'BiocManager::install(\"$pkg\")'"
        ;;
    esac
    if [[ $all == false ]]; then
      exit 0
    fi
  fi
}


# Priority order
variants=("$pkg")
if [[ "$skip_variants" != true ]]; then 
    variants+=("r-$pkg" "bioconductor-$pkg") 
fi

for variant in "${variants[@]}"; do 
    echo "Checking variant: $variant"

    # --- Conda (bioconda) ---
    bioconda=$(curl -s "https://api.anaconda.org/package/bioconda/$variant" | \
    grep -o '"version": *"[^"]*"' | cut -d'"' -f4 | \
    awk -v p="$variant" -v v="$ver" '{if (v=="" || tolower($1)==tolower(v)) print "  " tolower(p) " " $1}' | head -n1)
    check_and_print "Conda (bioconda)" "$bioconda"

    # --- Conda (conda-forge) ---
    condaforge=$(curl -s "https://api.anaconda.org/package/conda-forge/$variant" | \
    grep -o '"version": *"[^"]*"' | cut -d'"' -f4 | \
    awk -v p="$variant" -v v="$ver" '{if (v=="" || tolower($1)==tolower(v)) print "  " tolower(p) " " $1}' | head -n1)
    check_and_print "Conda (conda-forge)" "$condaforge"

    # --- Conda (r) ---
    condar=$(curl -s "https://api.anaconda.org/package/r/$variant" | \
    grep -o '"version": *"[^"]*"' | cut -d'"' -f4 | \
    awk -v p="$variant" -v v="$ver" '{if (v=="" || tolower($1)==tolower(v)) print "  " tolower(p) " " $1}' | head -n1)
    check_and_print "Conda (r)" "$condar"
done

# --- CRAN ---
cran=$(curl -s https://cran.r-project.org/src/contrib/PACKAGES | \
awk -v p="$pkg" -v v="$ver" '
  /^Package:/ {pkgname=$2}
  /^Version:/ {pkgver=$2}
  tolower(pkgname)==tolower(p) {
    if (v=="" || tolower(pkgver)==tolower(v)) {print "  " pkgname " " pkgver}
  }
')
check_and_print "CRAN" "$cran"

# --- CRAN archive ---
# --- CRAN archive (case-insensitive) ---
for candidate in "$pkg" "$(echo $pkg | tr '[:lower:]' '[:upper:]')" "$(echo ${pkg:0:1} | tr '[:lower:]' '[:upper:]')${pkg:1}"; do
  url="https://cran.r-project.org/src/contrib/Archive/$candidate/"
  cran_archive=$(curl -s "$url" | \
  grep -Eo "${candidate}_[0-9][^ ]*\.tar\.gz" | \
  sed -E "s/${candidate}_//; s/\.tar\.gz//" | \
  awk -v p="$pkg" -v v="$ver" '
    {if (v=="" || tolower($1)==tolower(v)) {print "  " p " " $1; exit}}
  ')
  check_and_print "CRAN (archive)" "$cran_archive"
done


# --- Bioconductor current categories ---
declare -A bioc_variants=(
  ["main"]="https://bioconductor.org/packages/release/bioc/VIEWS"
  ["experiment"]="https://bioconductor.org/packages/release/data/experiment/VIEWS"
  ["annotation"]="https://bioconductor.org/packages/release/data/annotation/VIEWS"
  ["workflows"]="https://bioconductor.org/packages/release/workflows/VIEWS"
)

for category in "${!bioc_variants[@]}"; do
  url="${bioc_variants[$category]}"
  bio=$(curl -s "$url" | \
  awk -v p="$pkg" -v v="$ver" '
    /^Package:/ {pkgname=$2}
    /^Version:/ {
      if (tolower(pkgname)==tolower(p)) {
        pkgver=$2
        if (v=="" || tolower(pkgver)==tolower(v)) {
          print "  " pkgname " " pkgver
          exit
        }
      }
    }
  ')
  check_and_print "Bioconductor ($category)" "$bio"
done

# --- Bioconductor archives ---
archive_releases=("3.14" "3.12" "3.10")

for rel in "${archive_releases[@]}"; do
  url="https://bioconductor.org/packages/${rel}/bioc/VIEWS"
  bio=$(curl -s "$url" | \
  awk -v p="$pkg" -v v="$ver" -v r="$rel" '
    /^Package:/ {pkg=$2}
    /^Version:/ {
      if (tolower(pkg)==tolower(p)) {
        ver=$2
        if (v=="" || tolower(ver)==tolower(v)) {
          print "  " pkg " " ver " (archived in " r ")"
          exit
        }
      }
    }
  ')
  check_and_print "Bioconductor archive" "$bio"
done

# --- R-Forge ---
rforge=$(curl -s "https://r-forge.r-project.org/R/?group_id=0" | grep -i "$pkg")
check_and_print "R-Forge" "$rforge"

echo "not found"
