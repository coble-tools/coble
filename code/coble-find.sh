#!/bin/bash

echo "[coble-find] ***********************************" >&2

# Default values
pkg=""
ver=""
all=false
skip_variants=false
YAML_FILE=""
INCLUDE_R_FORGE=false # by default no as it is usually down

# Build variants and map
get_variant_manager() {
    case "$1" in
        "$pkg") echo "Conda (conda-forge)" ;;
        "r-$pkg") echo "Conda (r)" ;;
        "r-r$pkg") echo "Conda (r)" ;;
        "bioconductor-$pkg") echo "Conda (bioconda)" ;;
        *) echo "" ;;
    esac
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --pkg) pkg="$2"; shift 2 ;;
    --version) ver="$2"; shift 2 ;;
    --all) all=true; shift ;;
    --skip-variants) skip_variants=true; shift ;;
    --include-r-forge) INCLUDE_R_FORGE=true; shift ;;
    --recipe) YAML_FILE="$2"; shift 2 ;;     
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

if [[ -z "$pkg" ]]; then
  echo "Usage: $0 --pkg <name> [--version <ver>] [--all]" >&2
  exit 1
fi

echo "[coble-find] ~~~ Searching for package: $pkg (version: ${ver:-any}) ~~~" >&2
#echo "[coble-find] ~~~ $all ~~~ $skip_variants ~~~ $YAML_FILE ~~~" >&2

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
    
    if [[ -n "$pkg_ver" ]]; then
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
        "Bioconductor")
            if [[ -n "$pkg_ver" ]]; then
                #recipe_line="Rscript -e 'BiocManager::install(\"$pkg_name\", version=\"$pkg_ver\", dependencies=TRUE)'"
                recipe_line="Rscript -e 'remotes::install_version(\"$pkg_name\", version=\"$pkg_ver\", dependencies=TRUE, repos=BiocManager::repositories())'"
            else
                recipe_line="Rscript -e 'BiocManager::install(\"$pkg_name\", dependencies=TRUE)'"
            fi
            manager="bioc-package:"
            ;;
        "r-forge")
            recipe_line="Rscript -e 'install.packages(\"$pkg_name\", repos=c(\"http://R-Forge.R-project.org\"), dependencies=TRUE)'"
            manager="r-package:"
            channel="r-forge"
            ;;
        "r-github")
            recipe_line="Rscript -e 'remotes::install_github(\"$channel\", dependencies=TRUE)'"
            manager="r-github:"
            yaml_line="  - $pkg_name"
            ;;        
        "c++-github")
            recipe_line="Rscript -e 'remotes::install_github(\"$channel\", dependencies=TRUE)'"
            manager="?r?c++-github:"
            yaml_line="  - $pkg_name"
            ;;        
        "???-github")
            recipe_line="Rscript -e 'remotes::install_github(\"$channel\", dependencies=TRUE)'"
            manager="???-github:"
            yaml_line="  - $pkg_name"
            ;;        
        "python-url")
            recipe_line="python -m pip install $channel"
            manager="pip:"
            yaml_line="  - $pkg_name"
            ;;
    esac

        
    [[ -n "$channel" ]] && yaml_line+="@$channel"

    if [[ $all == false ]]; then
        #echo "$manager"
        #echo "$recipe_line"
        #echo "$yaml_line"
        echo "found|$manager" >> "$YAML_FILE"        
        echo "$yaml_line" >> "$YAML_FILE"
        #exit 0
    fi        
}
###################################################################
### SEARCHING conda ######################
###################################################################
variants=("$pkg")

if [[ "$skip_variants" != true ]]; then
    variants+=("r-$pkg")
    variants+=("r-r$pkg")
    variants+=("bioconductor-$pkg")
fi

# Track what we've already found to avoid duplicates
found_combinations=""

# Loop through each possible variant of the package
for variant in "${variants[@]}"; do

    # Determine which manager label this variant belongs to
    manager="$(get_variant_manager "$variant")"

    # Safety check – skip empty variants (shouldn't happen, but defensive)
    if [[ -n "$variant" ]]; then

        # Check across all relevant Anaconda channels
        for channel in bioconda conda-forge r; do

            # Query Anaconda API for all versions of this variant in the channel
            # Extract version fields from JSON
            # Remove duplicates using sort -u
            versions=$(curl -s "https://api.anaconda.org/package/$channel/$variant" | \
                      grep -o '"version": *"[^"]*"' | cut -d'"' -f4 | \
                      sort -u)

            # Continue only if versions were returned
            if [[ -n "$versions" ]]; then

                # If a specific version was requested, filter to that version only
                if [[ -n "$ver" ]]; then
                    versions=$(echo "$versions" | grep -x "$ver")
                fi

                # Iterate through all matching versions
                while IFS= read -r version; do
                    if [[ -n "$version" ]]; then

                        # Create unique key (variant|version|channel)
                        # Used to prevent duplicates across channels
                        combo_key="$variant|$version|$channel"

                        # Deduplicate using colon-delimited pseudo-set
                        case ":$found_combinations:" in
                            *":$combo_key:"*) continue ;;  # Skip if already processed
                        esac

                        # Mark this combination as seen
                        found_combinations="$found_combinations:$combo_key"

                        # Log discovery
                        echo "[coble-find] Found $variant version $version in channel $channel" >&2

                        # Pass result to printer function
                        check_and_print "$manager" "$variant" "$version" "$pkg" "$ver" "$channel"
                    fi
                done <<< "$versions"
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
  #echo "[coble-find] Checking CRAN archive candidate $candidate" >&2
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

bioc_categories=("main" "experiment" "annotation" "workflows")
bioc_urls=(
  "https://bioconductor.org/packages/release/bioc/VIEWS"
  "https://bioconductor.org/packages/release/data/experiment/VIEWS"
  "https://bioconductor.org/packages/release/data/annotation/VIEWS"
  "https://bioconductor.org/packages/release/workflows/VIEWS"
)

for i in "${!bioc_categories[@]}"; do
  category="${bioc_categories[$i]}"
  url="${bioc_urls[$i]}"

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
  #echo "[coble-find] Checking archive $rel" >&2
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
### SEARCHING pypi ######################
###################################################################
pypi-check() {
    local pkg=$1
    local code=$(curl -sL -o /dev/null -w "%{http_code}" "https://pypi.org/pypi/$pkg/json")
    if [ "$code" = "200" ]; then
        echo "✓ Found: https://r-forge.r-project.org/projects/${pkg}/"
    else
        echo ""
    fi
}

echo "[coble-find] Checking pypi" >&2
#pypi=$(curl -s "https://pypi.org/pypi/$pkg/json")
pypi=$(pypi-check "$pkg")
#echo "[coble-find][debug] pypi='$pypi'" >&2
if [[ -n "$pypi" ]]; then
    check_and_print "PyPI" "$pkg" "" "$pkg" "$ver" ""
fi
###################################################################
### SEARCHING github R ######################
###################################################################
#echo "[coble-find] Checking github R" >&2
search_github_repo() {
  local q="$1"
  local url="https://api.github.com/search/repositories?q=${q}+language:R"
  echo "[coble-find] Searching url $url" >&2

  # Collect all repo URLs that match
  local results
  results=$(curl -s "$url" \
    | grep -o '"full_name": *"https://github.com/[^"]\+/[^"]\+"' \
    | cut -d'"' -f4 \
    | grep -E "/${q}$|/${q}/" \
    | paste -sd "," -)

  # Return concatenated string or empty
  if [[ -n "$results" ]]; then
     check_and_print "r-github" "$pkg" "" "$pkg" "" "${results}"  
  fi
}
search_github_repo $pkg
###################################################################
### SEARCHING github C++ ######################
###################################################################
#echo "[coble-find] Checking github C++" >&2
search_github_cpp() {
  local q="$1"
  local url="https://api.github.com/search/repositories?q=${q}+language:C%2B%2B"
  echo "[coble-find] Searching url $url" >&2

  # Collect all repo URLs that match
  local results
results=$(curl -s "$url" \
  | grep -o '"full_name": *"[^"]\+"' \
  | cut -d'"' -f4 \
  | grep -E "/${q}$|/${q}/" \
  | paste -sd "," -)

  # Return concatenated string or empty
  if [[ -n "$results" ]]; then
     check_and_print "c++-github" "$pkg" "" "$pkg" "" "${results}"  
  fi
}
search_github_cpp $pkg
###################################################################
### SEARCHING github python ######################
###################################################################
#echo "[coble-find] Checking github python" >&2
search_github_python() {
  local q="$1"
  local url="https://api.github.com/search/repositories?q=${q}+language:python"
  echo "[coble-find] Searching url $url" >&2
  curled=$(curl -s "$url")
  #echo "[coble-find][debug] github python search result: $curled" >&2

  # Collect all repo URLs that match
  local results
  results=$(echo "$curled" \
    | grep -o '"html_url": *"https://github.com/[^"]\+/[^"]\+"' \
    | cut -d'"' -f4 \
    | grep -E "/${q}$|/${q}/" \
    | paste -sd "," -)

  # Return concatenated string or empty
  if [[ -n "$results" ]]; then
     check_and_print "python-url" "$pkg" "" "$pkg" "" "${results}/archive/refs/heads/master.zip"  
  #else
  #    echo "[coble-find] No github python repo found for $q gives $result" >&2
  fi
}
search_github_python $pkg
###################################################################
### SEARCHING github ??? ######################
###################################################################
#echo "[coble-find] Checking github any" >&2
search_github_any() {
  local q="$1"
  local url="https://api.github.com/search/repositories?q=${q}"
  echo "[coble-find] Searching url $url" >&2

  # Collect all repo URLs that match
  local results
  results=$(curl -s "$url" \
  | grep -o '"full_name": *"[^"]\+"' \
  | cut -d'"' -f4 \
  | paste -sd "," -)

  # Return concatenated string or empty
  if [[ -n "$results" ]]; then
     check_and_print "???-github" "$pkg" "" "$pkg" "" "${results}"  
  fi
}
#search_github_any $pkg
###############################################################

###################################################################
### SEARCHING r-forge ######################
###################################################################
rforge-check() {
    local pkg=$1
    local code=$(curl -sL -o /dev/null -w "%{http_code}" "https://r-forge.r-project.org/projects/${pkg}/")
    if [ "$code" = "200" ]; then
        echo "✓ Found: https://r-forge.r-project.org/projects/${pkg}/"
    else
        echo ""
    fi
}

if [[ "$INCLUDE_R_FORGE" != true ]]; then
  echo "[coble-find] Skipping r-forge check as per settings" >&2
  exit 0
fi
echo "[coble-find] Checking r-forge" >&2
# Improved R-Forge package detection: look for tarballs in the contrib directory
#echo "[coble-find][debug] curl -s \"https://r-forge.r-project.org/src/contrib/\" | grep -oiE 'href=\"${pkg}_[^\"]+\\.tar\\.gz\"' | sed -E 's/^href=\"//;s/\"$//' | head -n1" >&2
rforge_pkg=$(rforge-check "$pkg")
#echo "[coble-find][debug] rforge_pkg='$rforge_pkg'" >&2
if [[ -n "$rforge_pkg" ]]; then
  check_and_print "r-forge" "$pkg" "" "$pkg" "$ver" "r-forge"
fi

