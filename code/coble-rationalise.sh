#!/usr/bin/env bash

##############
# success=$(coble-rationalise.sh my.yml)
##############
# Inputs ----
# 1. --input yamlfile
# Outputs ----
# --stdout --
# 1. success=Y/N
# --filesystem --
# 1. yamlfile
###############

YAML_FILE=""
BACKUP_FILE=""

# Parse arguments ########################################################
show_help() {
    echo "----- coble rationalise help ----------"    
    echo "Usage: $0 --input YAML_FILE"    
    echo "  --input     YAML                    Specify input YAML file - it will be rationalised - sections moved about"
    echo "  -h, --help  Show this help message and exit"
    echo "------------------------------------"    
}
while [[ $# -gt 0 ]]; do
  case $1 in
    --input) YAML_FILE="$2"; shift 2 ;;    
    -h|--help) show_help; exit 0 ;;    
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

# Exit if not input file specified
if [[ -z "$YAML_FILE" ]]; then
    echo "Error: --input YAML_FILE is required." >&2
    echo "N"
    exit 1
fi

# Copy to backup
BACKUP_FILE="${YAML_FILE}.bak"
cp "$YAML_FILE" "$BACKUP_FILE"

# init with basic time date ############################################
# Clear the aggregate file at the start
# {	
#     CAPTURE_DATE=$(date '+%Y-%m-%d')
# 	CAPTURE_TIME=$(date '+%H:%M:%S %Z')
# 	CAPTURE_USER=$(whoami)	
#     echo -e "# COBLE:Rationalised (c) ICR 2025 on ${CAPTURE_DATE} at ${CAPTURE_TIME} by ${CAPTURE_USER}"        	
#     echo "#######################################"            
#     echo ""
# } > "$YAML_FILE"


echo "Y"