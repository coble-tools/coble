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
    local ver_orig=$5
    local channel=$6
    local bioc_ver=$7

    if [[ -z "$pkg_name" ]]; then return; fi

    name_ver="$pkg_name"

    echo "[coble-found] $source, $pkg_name, $pkg_ver, $pkg_orig, $ver_orig, $channel, $bioc_ver" >&2
    
    if [[ -n "$pkg_ver" && -n "$ver" ]]; then
        echo "  $pkg_name $pkg_ver" >&2
        name_ver="$pkg_name=$pkg_ver"
    else
        name_ver="$pkg_name"         
    fi    
    yaml_line="  - $name_ver"

    case $source in
        "Conda (bioconda)")
            recipe_line="conda install -y -c conda-forge -c $channel '$name_ver' --no-update-deps"
            #manager="conda-bioc:"
            manager="conda:"            
            ;;
        "Conda (conda-forge)")
            recipe_line="conda install -y -c $channel '$name_ver' --no-update-deps"
            manager="conda:"
            if [[ "$name_ver" == r-base* || "$name_ver" == python* ]]; then
              manager="languages:"            
            fi
            ;;
        "Conda (r)")
            recipe_line="conda install -y -c $channel '$name_ver' --no-update-deps"
            #manager="conda-r:"
            if [[ "$name_ver" == r-base* || "$name_ver" == python* ]]; then
              manager="languages:"            
            fi
            manager="conda:"
            ;;
        "CRAN")
            recipe_line="Rscript -e 'install.packages(\"$pkg_name\", repos=\"https://cran.r-project.org\", dependencies=TRUE)'"
            manager="r-package:"
            ;;
        "CRAN (archive)")
            recipe_line="Rscript -e 'remotes::install_version(\"$pkg_name\", version=\"$pkg_ver\", repos=\"http://cran.us.r-project.org\", dependencies=TRUE)'"
            manager="r-package:"
            ;;
        "PyPI")
            recipe_line="python -m pip install $name_ver"
            manager="pip:"
            ;;
        Bioconductor*)
            if [[ -n "$pkg_ver" ]]; then
                #recipe_line="Rscript -e 'BiocManager::install(\"$pkg_name\", version=\"$pkg_ver\", dependencies=TRUE)'"
                recipe_line="Rscript -e 'remotes::install_version(\"$pkg_name\", version=\"$pkg_ver\", dependencies=TRUE, repos=BiocManager::repositories())'"
            else
                recipe_line="Rscript -e 'BiocManager::install(\"$pkg_name\", dependencies=TRUE)'"
            fi
            manager="bioconductor:"
            ;;
        "R-Forge")
            recipe_line="Rscript -e 'install.packages(\"$pkg_name\", repos=c(\"http://R-Forge.R-project.org\",\"http://cran.r-project.org\"), dependencies=TRUE)'"
            manager="rforge:"
            channel="r-forge"
            ;;
        "r-url")
            recipe_line="Rscript -e 'remotes::install_url(\"$channel\", dependencies=TRUE)'"
            manager="r-url:"
            yaml_line="  - $channel"
            ;;
    esac

        
    [[ -n "$channel" ]] && yaml_line+="@$channel"

    if [[ $all == false ]]; then
        echo "$manager"
        echo "$recipe_line"
        echo "$yaml_line"
        exit 0
    fi
}
###################################################################
### SEARCHING conda ######################
###################################################################
# Build variants and map
variants=("$pkg")
VARIANT_MANAGERS["$pkg"]="Conda (conda-forge)"

if [[ "$skip_variants" != true ]]; then
    variants+=("r-$pkg")
    VARIANT_MANAGERS["r-$pkg"]="Conda (r)"
    
    variants+=("r-r$pkg")
    VARIANT_MANAGERS["r-r$pkg"]="Conda (r)"

    variants+=("bioconductor-$pkg")
    VARIANT_MANAGERS["bioconductor-$pkg"]="Conda (bioconda)"
fi

for variant in "${variants[@]}"; do
    echo "[coble-find] Checking variant: $variant" >&2
    manager="${VARIANT_MANAGERS[$variant]}"
    
    if [[ -n "$variant" ]]; then
        for channel in bioconda conda-forge r; do
            # Get all versions from API
            versions=$(curl -s "https://api.anaconda.org/package/$channel/$variant" | \
                      grep -o '"version": *"[^"]*"' | cut -d'"' -f4)
            
            if [[ -n "$ver" ]]; then
                # Look for specific version requested
                version=$(echo "$versions" | grep -x "$ver" | head -n1)
            else
                # Get latest/first version if no version specified
                version=$(echo "$versions" | head -n1)
            fi
            
            if [[ -n "$version" ]]; then
                echo "[coble-find] Found $variant version $version in channel $channel" >&2
                check_and_print "$manager" "$variant" "$version" "$pkg" "$ver" "$channel"
            fi
        done
    fi
done

###################################################################
### SEARCHING r cran ######################
###################################################################

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
    check_and_print "CRAN" "$pkg_name" "$pkg_ver" "$pkg" "$ver" "CRAN"
fi

for candidate in "$pkg" "$(echo $pkg | tr '[:lower:]' '[:upper:]')" "$(echo ${pkg:0:1} | tr '[:lower:]' '[:upper:]')${pkg:1}"; do
  echo "[coble-find] Checking CRAN archive candidate $candidate" >&2
  url="https://cran.r-project.org/src/contrib/Archive/$candidate/"
  
  if [[ -n "$ver" ]]; then
    # Look for specific version in archive
    pkg_entry=$(curl -s "$url" | grep -Eo "${candidate}_${ver}\.tar\.gz" | head -n1)
  else
    # Get first available version
    pkg_entry=$(curl -s "$url" | grep -Eo '[A-Za-z0-9]+_[0-9][^"]*\.tar\.gz' | head -n1)
  fi
  
  if [[ -n "$pkg_entry" ]]; then
    IFS='_' read -r pkg_name verpart <<< "$pkg_entry"
    pkg_ver=${verpart%.tar.gz}
    
    # Only proceed if version matches what was requested (or no version specified)
    if [[ -z "$ver" ]] || [[ "$pkg_ver" == "$ver" ]]; then
      check_and_print "CRAN (archive)" "$pkg_name" "$pkg_ver" "$pkg" "$ver" "CRAN"
    else
      echo "[coble-find] Skipping CRAN archive $pkg_ver (requested $ver)" >&2
    fi
  fi
done

###################################################################
### SEARCHING bioconductor ######################
###################################################################

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
    check_and_print "Bioconductor ($category)" "$pkg_name" "$pkg_ver" "$pkg" "$ver" "$channel"
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
    check_and_print "Bioconductor archive ($rel)" "$pkg_name" "$pkg_ver" "$pkg" "$ver" "$channel"
  fi
done

###################################################################
### SEARCHING r-forge ######################
###################################################################
echo "[coble-find] Checking r-forge" >&2
rforge=$(curl -s "https://r-forge.r-project.org/R/?group_id=0" | grep -i "$pkg")
if [[ -n "$rforge" ]]; then
    check_and_print "R-Forge" "$pkg" "" "$pkg" "$ver" "R-FORGE"
fi


###################################################################
### SEARCHING pypi ######################
###################################################################
echo "[coble-find] Checking pypi" >&2
pypi=$(curl -s "https://pypi.org/pypi/$pkg/json")
if [[ -n "$pypi" ]]; then
    check_and_print "PyPI" "$pkg" "" "$pkg" "$ver" ""
fi
###################################################################
### SEARCHING github ######################
###################################################################
echo "[coble-find] Checking github" >&2
search_github_repo() {
  local q="$1"
  local url="https://api.github.com/search/repositories?q=${q}"
  echo "[coble-find] Searching url $url" >&2

  # Collect all repo URLs that match
  local results
  results=$(curl -s "$url" \
    | grep -o '"html_url": *"https://github.com/[^"]\+/[^"]\+"' \
    | cut -d'"' -f4 \
    | grep -E "/${q}$|/${q}/" \
    | paste -sd "," -)

  # Return concatenated string or empty
  if [[ -n "$results" ]]; then
     check_and_print "r-url" "$pkg" "" "$pkg" "" "${results}/archive/refs/heads/master.zip"  
  fi
}
search_github_repo $pkg

###############################################################
echo "not found" >&2

# If we reach here without exiting, still emit the three stdout lines (empty)
echo "unknown"
echo "$recipe_line"
echo "$yaml_line"
