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

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$(dirname "$YAML_FILE")"

# copy file in same dir as this script to YAML_FILE
if [[ "$FLAVOUR" =~ ^(452)$ ]]; then    
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cp "$script_dir/tml_452.yml" "$YAML_FILE"    
elif [[ "$FLAVOUR" =~ ^(r)$ ]]; then    
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cp "$script_dir/tml_r.yml" "$YAML_FILE"
elif [[ "$FLAVOUR" =~ ^(mixed)$ ]]; then    
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cp "$script_dir/tml_mixed.yml" "$YAML_FILE"
elif [[ "$FLAVOUR" =~ ^(python)$ ]]; then    
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cp "$script_dir/tml_python.yml" "$YAML_FILE"
elif [[ "$FLAVOUR" =~ ^(find)$ ]]; then    
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cp "$script_dir/tml_find.yml" "$YAML_FILE"
elif [[ "$FLAVOUR" =~ ^(pin)$ ]]; then    
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cp "$script_dir/tml_pin.yml" "$YAML_FILE"
elif [[ "$FLAVOUR" =~ ^(sylver)$ ]]; then    
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cp "$script_dir/tml_sylver.yml" "$YAML_FILE"
else
    echo "[coble-template] Unknown flavour: $FLAVOUR" >&2
    exit 1
fi

echo "[coble-template] Created template YAML: $YAML_FILE" >&2