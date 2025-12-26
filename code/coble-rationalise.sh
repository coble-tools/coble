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
    echo "#######################################"            
} > "$YAML_FILE"


# I want to build a map of flags and instructions ##########################
# The flags are the secitons in the yml file like flag:
# the instructions are everything that follows until the next flag:
# The flags may not be unique so they are a list that has a list of instructions
declare -A SECTION_MAP
CURRENT_FLAG=""
while IFS= read -r line || [[ -n "$line" ]]; do
# if line is empty skip
    if [[ -z "$line" ]]; then
        continue
    fi 
    # Check if the line is a flag (ends with ':')
    if [[ "$line" =~ ^[a-zA-Z0-9_-]+:$ ]]; then
        CURRENT_FLAG="${line%:}"  # Remove the colon
        # Initialize the flag in the map if not already present
        if [[ -z "${SECTION_MAP[$CURRENT_FLAG]}" ]]; then
            SECTION_MAP["$CURRENT_FLAG"]=""
        fi
    else
        # Append the line to the current flag's instructions
        if [[ -n "$CURRENT_FLAG" ]]; then
            SECTION_MAP["$CURRENT_FLAG"]+="$line"$'\n'
        fi
    fi
done < "$BACKUP_FILE"

# can you echo out the sections for debugging?
for key in "${!SECTION_MAP[@]}"; do
    echo "Section: $key"
    echo "Instructions:"
    echo "${SECTION_MAP[$key]}"
    echo "---------------------"
done

# now go through it and write out the sections in the desired order #
# only some sections need to be in the desired order the rest as they came
DESIRED_START=(
    "coble"    
    "channels"
    "languages"
    "flags"
)

OTHER_SECTIONS=()

for section in "${DESIRED_START[@]}"; do
    if [[ -n "${SECTION_MAP[$section]}" ]]; then
        echo "$section:" >> "$YAML_FILE"
        echo "${SECTION_MAP[$section]}" >> "$YAML_FILE"
        unset SECTION_MAP["$section"]
    else    
        OTHER_SECTIONS+=("$section")
    fi
done
# Now append the remaining sections in their original order
for section in "${!SECTION_MAP[@]}"; do
    echo "$section:" >> "$YAML_FILE"
    echo "${SECTION_MAP[$section]}" >> "$YAML_FILE"
done






echo "[coble-reordered] Rationalisation complete: $YAML_FILE" >&2

echo "Y"