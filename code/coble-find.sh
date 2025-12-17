#!/usr/bin/env bash

# Find where a package is from conda, bioc pip

pkg_name="$1"
version="$2"
src="$3"
manager="$4"


#!/usr/bin/env bash

# Function to get package info (call once)
get_package_info() {
    local package=$1
    echo "[conda-find] Searching conda for $package (this may take a minute)..." >&2
    conda search "$package" 2>/dev/null | grep "^$package "
}

# Function to extract channel from cached info
get_channel_from_info() {
    local pkg_info="$1"
    echo "$pkg_info" | awk '{print $NF}' | sort -u | head -1
}

# Function to extract all versions from cached info
get_versions_from_info() {
    local pkg_info="$1"
    echo "$pkg_info" | awk '{print $2}' | sort -V | uniq
}

# Function to check if specific version exists
check_version_in_info() {
    local pkg_info="$1"
    local version="$2"
    echo "$pkg_info" | awk -v ver="$version" '$2 == ver {print "Y"; exit} END {if (NR==0) print "N"}'
}

# Function to get channel for specific version
get_channel_for_version() {
    local pkg_info="$1"
    local version="$2"
    echo "$pkg_info" | awk -v ver="$version" '$2 == ver {print $NF; exit}'
}

####################################################
# CALL ONCE - expensive operation
if [[ $version != ""]]; then
    pkg_info=$(get_package_info "$pkg_name=$version")
else
    pkg_info=$(get_package_info "$pkg_name")
fi

if [[ -z "$pkg_info" ]]; then
    echo "Package not found"
    manager=unknown
else
    # Now parse the cached info (fast operations)
    echo "Available versions:"
    get_versions_from_info "$pkg_info"

    echo ""
    echo "Default channel:"
    get_channel_from_info "$pkg_info"

    echo ""
    echo "Check if version 3.42.2 exists:"
    check_version_in_info "$pkg_info" "3.42.2"

    echo ""
    echo "Channel for version 3.42.2:"
    get_channel_for_version "$pkg_info" "3.42.2"
fi






###################################################################
echo "[coble-find] pkg=$pkg_name version=$version channel=$src" >&2
echo "[coble-find] seeking $pkg_name in $src from $manager" >&2
conda_pkg=$pkg_name

if [[ $manager == "" ]]; then
    manager="conda"
    echo "[coble-find] Trying conda..." >&2
    exists=$(package_exists_conda $pkg_name)    
    if [[ $exists == "N" ]]; then
        manager="conda-r"
        echo "[coble-find] Trying r-conda..." >&2
        exists=$(package_exists_conda r-$pkg_name)        
        if [[ $exists == "N" ]]; then      
            manager="conda-bioc"
            echo "[coble-find] Trying conda-bioc..." >&2
            exists=$(package_exists_conda bioconductor-$pkg_name)            
            if [[ $exists == "N" ]]; then
                manager="unknown"
            else
                conda_pkg=bioconductor-$pkg_name
            fi
        else
            conda_pkg=r-$pkg_name
        fi    
    fi    
fi

if [[ $manager == "unknown" ]]; then
    echo "unknown"    # This goes to stdout (return value)
else
    echo "[coble-find] Manager for $pkg_name is $manager" >&2
    if [[ $src == "" ]]; then
       src=$(find_conda_channel $pkg_name)       
    fi
    echo "[coble-find] Manager for $pkg_name is $manager src=$src" >&2
    if [[ $version != "" ]]; then
        conda_pkg="'${conda_pkg}=${version}'"
        pkg_name="${pkg_name}=${version}"
    fi
    recipe_line="conda install -c $src $conda_pkg"
    yaml_line="  - $pkg_name@$src"
    
    # ONLY THIS goes to stdout (return value)
    echo "$manager"
    echo "$recipe_line"
    echo "$yaml_line"
fi