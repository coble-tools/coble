#!/usr/bin/env bash

###########################################
r_version="3.6.0"
packages=("remotes")
pack_ver=("tidyverse=1.3.1" "biocmanager=1.30.22")  
###########################################
echo "Checking R version is $r_version..."

Rscript -e "if(paste0(R.version\$major, '.', R.version\$minor) == '$r_version') cat('SUCCESS\n') else cat('FAIL:', R.version.string, '\n')"

echo "verifying some other packages..."

for pkg in "${packages[@]}"; do
    # echo "Checking if $pkg is installed..."
    Rscript -e "library($pkg)" 2>/dev/null && echo "SUCCESS: $pkg loaded" || echo "FAIL: $pkg not loaded"
done

for pv in "${pack_ver[@]}"; do
    pkg=$(echo "$pv" | cut -d'=' -f1)
    ver=$(echo "$pv" | cut -d'=' -f2)
    echo "Checking if $pkg version is $ver..."
    Rscript -e "if(packageVersion('$pkg') == '$ver') cat('SUCCESS: $pkg version is $ver\n') else cat('FAIL: $pkg version is', as.character(packageVersion('$pkg')), '\n')" 2>/dev/null || echo "FAIL: $pkg not installed"
done

