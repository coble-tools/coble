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
# 2. yamlfile.bak2.yml
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
    #*) echo "Unknown option: $1" >&2; exit 1 ;;
    *) shift ;;
  esac
done

# Exit if not input file specified
if [[ -z "$YAML_FILE" ]]; then
    echo "Error: --input YAML_FILE is required." >&2
    echo "N"
    exit 1
fi

# Now check the second line, if the 'yml' is already coble rationalised, exit
second_line=$(sed -n '2p' "$YAML_FILE")
if [[ "$second_line" == "## COBLE:"* && "$second_line" == *Ordered* ]]; then
    echo "[coble-rationalise] YAML already coble ordered, exiting: $YAML_FILE" >&2
    echo Y
    exit 0
fi

# Copy to backup
BACKUP_FILE="${YAML_FILE}.bak2.yml"
cp "$YAML_FILE" "$BACKUP_FILE"

# init with basic time date ############################################
second_line=$(sed -n '2p' "$YAML_FILE")
# Clear the aggregate file at the start
{	
    CAPTURE_DATE=$(date '+%Y-%m-%d')
	CAPTURE_TIME=$(date '+%H:%M:%S %Z')
	CAPTURE_USER=$(whoami)	
    echo "#######################################"            
    echo -e "$second_line + Ordered"
    echo -e "##    Ordered - On: $CAPTURE_DATE" at $CAPTURE_TIME" by $CAPTURE_USER"        
} > "$YAML_FILE"


# loop through backup and write to original with no change to begin with
tail -n +3 "$BACKUP_FILE" | while IFS= read -r line || [[ -n "$line" ]]; do
    echo "$line" >> "$YAML_FILE"
done

echo "[coble-reordered] Rationalisation complete: $YAML_FILE" >&2

echo "Y"