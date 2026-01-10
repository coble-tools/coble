#!/usr/bin/env bash

##############
# success=$(coble-template.sh my.yml)
##############
# Inputs ----
# 1. --recipe yamlfile
# 2. --flavour find/python/r/mixed
# Outputs ----
# --stdout --
# 1. success=Y/N
# --filesystem --
# 1. yamlfile
###############

YAML_FILE=""
FLAVOUR="basic"

# Parse arguments ########################################################
show_help() {
    echo "----- coble recipe help ----------"    
    echo "Usage: $0 --recipe YAML_FILE"    
    echo "  --recipe     CBL                    Specify recipe CBL file - it will be populated with this version's example template"    
    echo "  --flavour   find/python/r/mixed     Type of environment to create (default: mixed)"
    echo "  -h, --help  Show this help message and exit"
    echo "------------------------------------"    
}
while [[ $# -gt 0 ]]; do
  case $1 in
    --recipe) YAML_FILE="$2"; shift 2 ;;
    --flavour) FLAVOUR="$2"; shift 2 ;;
    -h|--help) show_help; exit 0 ;;    
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

# Convert FLAVOUR to lower case for consistency
FLAVOUR="${FLAVOUR,,}"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$(dirname "$YAML_FILE")"

# copy file in same dir as this script to YAML_FILE
if [[ "$FLAVOUR" =~ ^(basic)$ ]]; then    
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cp "$script_dir/tml_basic.cbl" "$YAML_FILE"    
elif [[ "$FLAVOUR" =~ ^(versions)$ ]]; then    
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cp "$script_dir/tml_versions.cbl" "$YAML_FILE"    
elif [[ "$FLAVOUR" =~ ^(bioinf)$ ]]; then    
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cp "$script_dir/tml_bioinf.cbl" "$YAML_FILE"    
elif [[ "$FLAVOUR" =~ ^(bash)$ ]]; then    
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cp "$script_dir/tml_bash.cbl" "$YAML_FILE"
elif [[ "$FLAVOUR" =~ ^(find)$ ]]; then # SYLVER tutorial    
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cp "$script_dir/tml_find.cbl" "$YAML_FILE"
elif [[ "$FLAVOUR" =~ ^(sylver)$ ]]; then    
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cp "$script_dir/tml_sylver.cbl" "$YAML_FILE"
elif [[ "$FLAVOUR" =~ ^(fix)$ ]]; then # COUNTREG tutorial    
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cp "$script_dir/tml_fix.cbl" "$YAML_FILE"
elif [[ "$FLAVOUR" =~ ^(fixed)$ ]]; then    
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cp "$script_dir/tml_fixed.cbl" "$YAML_FILE"
else
    echo "[coble-template] Unknown flavour: $FLAVOUR" >&2
    exit 1
fi

echo "[coble-template] Created template YAML: $YAML_FILE" >&2