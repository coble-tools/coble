#!/usr/bin/env bash

##############
# success=$(coble-template.sh my.yml)
##############
# Inputs ----
# 1. --input yamlfile
# 2. --flavour find/python/r/mixed
# Outputs ----
# --stdout --
# 1. success=Y/N
# --filesystem --
# 1. yamlfile
###############

YAML_FILE=""
FLAVOUR="mixed"

# Parse arguments ########################################################
show_help() {
    echo "----- coble template help ----------"    
    echo "Usage: $0 --input YAML_FILE"    
    echo "  --input     YAML                    Specify input YAML file - it will be populated with this versions example template"    
    echo "  --flavour   find/python/r/mixed     Type of environment to create (default: mixed)"
    echo "  -h, --help  Show this help message and exit"
    echo "------------------------------------"    
}
while [[ $# -gt 0 ]]; do
  case $1 in
    --input) YAML_FILE="$2"; shift 2 ;;
    --flavour) FLAVOUR="$2"; shift 2 ;;
    -h|--help) show_help; exit 0 ;;    
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

# Convert FLAVOUR to lower case for consistency
FLAVOUR="${FLAVOUR,,}"

# init with basic time date ############################################
# Clear the aggregate file at the start
{	
    echo "#######################################"
    echo -e "# COBLE:Reproducible environment yaml, (c) ICR 2025"    
    CAPTURE_DATE=$(date '+%Y-%m-%d')
	CAPTURE_TIME=$(date '+%H:%M:%S %Z')
	CAPTURE_USER=$(whoami)	
	echo -e "# Created date: $CAPTURE_DATE"
	echo -e "# Created time: $CAPTURE_TIME"
	echo -e "# Created by: $CAPTURE_USER"
    echo "#######################################"            
    echo ""
} > "$YAML_FILE"

#echo headers and version
echo "coble:" >> "$YAML_FILE"                                                                                                                                                                                                  
echo "" >> "$YAML_FILE"
echo "  - environment: coble-env" >> "$YAML_FILE"
echo "" >> "$YAML_FILE"

#echo channels
if [[ "$FLAVOUR" =~ ^(find|r|python|mixed)$ ]]; then
    echo "channels:" >> "$YAML_FILE"
    echo "# note the reverse order of priority" >> "$YAML_FILE"
    echo "  - defaults" >> "$YAML_FILE"
    echo "  - r" >> "$YAML_FILE"
    echo "  - bioconda" >> "$YAML_FILE"
    echo "  - conda-forge" >> "$YAML_FILE"            
    echo "" >> "$YAML_FILE"
fi

# echo languages 
echo "languages:" >> "$YAML_FILE"
if [[ "$FLAVOUR" =~ ^(r|mixed)$ ]]; then
    echo "  - r-base=4.4.2@conda-forge" >> "$YAML_FILE"
fi
if [[ "$FLAVOUR" =~ ^(python|mixed)$ ]]; then
    echo "  - python=3.13.1@conda-forge" >> "$YAML_FILE"
fi
echo "" >> "$YAML_FILE"

# echo flags
echo "flags:" >> "$YAML_FILE"
echo "  - dependencies: True" >> "$YAML_FILE"
echo "  - build-tools: True" >> "$YAML_FILE"
echo "" >> "$YAML_FILE"

# echo environments plus help
# CONDA
if [[ "$FLAVOUR" =~ ^(python|mixed)$ ]]; then
    echo "conda:" >> "$YAML_FILE"
    echo "  - pandas" >> "$YAML_FILE"
    echo "" >> "$YAML_FILE"
fi

if [[ "$FLAVOUR" =~ ^(r|mixed)$ ]]; then
    # R-CONDA
    echo "r-conda:" >> "$YAML_FILE"
    echo "  - tidyverse" >> "$YAML_FILE"
    echo "  - devtools" >> "$YAML_FILE"
    echo "  - remotes" >> "$YAML_FILE"
    echo "" >> "$YAML_FILE"

    # BIOC-CONDA
    echo "bioc-conda:" >> "$YAML_FILE"
    echo "  - affy@bioconda" >> "$YAML_FILE"
    echo "" >> "$YAML_FILE"    

    # R-PACKAGE
    echo "r-package:" >> "$YAML_FILE"
    echo "  - survival" >> "$YAML_FILE"
    echo "  - countreg@r-forge" >> "$YAML_FILE"
    echo "" >> "$YAML_FILE"

    # BIOC-PACKAGE
    echo "bioc-package:" >> "$YAML_FILE"
    echo "  - limma" >> "$YAML_FILE"
    echo "" >> "$YAML_FILE"
  
    # R-GITHUB
    echo "r-github:" >> "$YAML_FILE"
    echo "  - seedgeorge/SQUEAK" >> "$YAML_FILE"
    echo "" >> "$YAML_FILE"

    # R-URL
    echo "r-url:" >> "$YAML_FILE"
    echo "  - https://github.com/choisy/cutoff/archive/refs/heads/master.zip" >> "$YAML_FILE"
    echo "" >> "$YAML_FILE"
fi

if [[ "$FLAVOUR" =~ ^(python|mixed)$ ]]; then
    # PIP PACKAGE
    echo "pip:" >> "$YAML_FILE"
    echo "  - numpy" >> "$YAML_FILE"
    echo "  - https://github.com/ICR-RSE-Group/gitalma.git" >> "$YAML_FILE"
    echo "" >> "$YAML_FILE"
fi

if [[ "$FLAVOUR" =~ ^(find)$ ]]; then
    # FIND PACKAGE
    echo "find:" >> "$YAML_FILE"
    echo "  - r-base=3.6.0" >> "$YAML_FILE"
    echo "  - r-base=4.1.0" >> "$YAML_FILE"
    echo "  - BiocManager" >> "$YAML_FILE"
    echo "  - tidyverse=1.3.1" >> "$YAML_FILE"
    echo "  - effsize=0.8.1" >> "$YAML_FILE" 
    echo "  - magrittr=2.0.1" >> "$YAML_FILE" 
    echo "  - tidyverse=1.3.1" >> "$YAML_FILE"
    echo "  - ggplot2" >> "$YAML_FILE"
    echo "  - ggrepel=0.9.1" >> "$YAML_FILE"
    echo "  - VennDiagram=1.6.20" >> "$YAML_FILE"
    echo "  - affy=1.64.0" >> "$YAML_FILE" 
    echo "  - fgsea=1.12.0" >> "$YAML_FILE"
    echo "  - GSVA=1.34.0" >> "$YAML_FILE"
    echo "  - org.Hs.eg.db=3.10.0" >> "$YAML_FILE"  
    echo "  - survival=3.2-11" >> "$YAML_FILE"  
    echo "  - limma=3.42.2" >> "$YAML_FILE"  
    echo "  - cdsr_models" >> "$YAML_FILE"     
    echo "" >> "$YAML_FILE"
fi

if [[ "$FLAVOUR" =~ ^(452)$ ]]; then
    # copy file in same dir as this script to YAML_FILE
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cp "$script_dir/452.yml" "$YAML_FILE"    
fi

echo "Y"