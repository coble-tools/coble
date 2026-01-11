#!/usr/bin/env bash

##############
# success=$(coble-rationalise.sh my.yml)
##############
# Inputs ----
# 1. --recipe yamlfile
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
    echo "Usage: $0 --recipe CBL_FILE"    
    echo "  --recipe     CBL  Specify input CBL file - it will be rationalised - sections moved about"
    echo "  -h, --help  Show this help message and exit"
    echo "------------------------------------"    
}
while [[ $# -gt 0 ]]; do
  case $1 in
    --recipe) YAML_FILE="$2"; shift 2 ;;    
    -h|--help) show_help; exit 0 ;;    
    #*) echo "Unknown option: $1" >&2; exit 1 ;;
    *) shift ;;
  esac
done

# Exit if not input file specified
if [[ -z "$YAML_FILE" ]]; then
    echo "Error: --recipe YAML_FILE is required." >&2
    echo "N"
    exit 1
fi

count=0
coble_count=0
channels_count=0
languages_count=0
flags_count=0
ok=true
while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" =~ ^([a-zA-Z0-9_-]+):$ ]]; then
        section_name="${BASH_REMATCH[1]}"
        if [[ "$section_name" == *"coble"* ]]; then
            count=$((count + 1))
            coble_count=$count
        elif [[ "$section_name" == *"channels"* ]]; then
            count=$((count + 1))
            channels_count=$count
        elif [[ "$section_name" == *"languages"* ]]; then
            count=$((count + 1))
            languages_count=$count
        elif [[ "$section_name" == *"flags"* ]]; then
            count=$((count + 1))
            flags_count=$count            
        fi
    fi
done < "$YAML_FILE"
ok=false
if [[ $coble_count -eq 1  && $channels_count -eq 2 && $languages_count -eq 3 ]]; then
    ok=true # can be coble, channels, languages
elif [[ $coble_count -eq 1 && $channels_count -eq 2 && $flags_count -eq 3 && $languages_count -eq 4 ]]; then
    ok=true # can be coble, channels, flags, languages
fi

if [[ "$ok" == true ]]; then
    echo "[coble-rationalise] CBL already coble ordered, exiting: $YAML_FILE" >&2
    echo Y
    exit 0
else
    echo "[coble-rationalise] CBL not ordered, please fix before proceeding to rationalise: $YAML_FILE" >&2
    echo "  directive order should begin:" >&2
    echo "    coble:" >&2
    echo "    channels:" >&2
    echo "    [flags:]" >&2
    echo "    languages:" >&2
    #echo "    flags:" >&2
    echo "The current order is:" >&2    
    echo "  coble: $coble_count" >&2
    echo "  channels: $channels_count" >&2
    echo "  languages: $languages_count" >&2    
    echo N
    exit 1
fi
  
# # Copy to backup
# BACKUP_FILE="${YAML_FILE}.bak2.yml"
# cp "$YAML_FILE" "$BACKUP_FILE"

# # init with basic time date ############################################
# first_line=$(sed -n '1p' "$YAML_FILE")
# # Clear the aggregate file at the start
# {	
#     CAPTURE_DATE=$(date '+%Y-%m-%d')
# 	CAPTURE_TIME=$(date '+%H:%M:%S %Z')
# 	CAPTURE_USER=$(whoami)	    
#     #echo -e "$first_line"            
#     echo "##!COBLE: Ordered on ${CAPTURE_DATE} at ${CAPTURE_TIME} by ${CAPTURE_USER}"
# } > "$YAML_FILE"


# # I want to build a map of flags and instructions ##########################
# # The flags are the secitons in the yml file like flag:
# # the instructions are everything that follows until the next flag:
# # The flags may not be unique so they are a list that has a list of instructions
# declare -A SECTION_MAP
# CURRENT_FLAG=""
# while IFS= read -r line || [[ -n "$line" ]]; do
# # if line is empty skip
#     if [[ -z "$line" ]]; then
#         continue
#     fi 
#     # Check if the line is a flag (ends with ':')
#     if [[ "$line" =~ ^[a-zA-Z0-9_-]+:$ ]]; then
#         CURRENT_FLAG="${line%:}"  # Remove the colon
#         # Initialize the flag in the map if not already present
#         if [[ -z "${SECTION_MAP[$CURRENT_FLAG]}" ]]; then
#             SECTION_MAP["$CURRENT_FLAG"]=""
#         fi
#     else
#         # Append the line to the current flag's instructions
#         if [[ -n "$CURRENT_FLAG" ]]; then
#             SECTION_MAP["$CURRENT_FLAG"]+="$line"$'\n'
#         fi
#     fi
# done < "$BACKUP_FILE"

# # can you echo out the sections for debugging?
# for key in "${!SECTION_MAP[@]}"; do
#     echo "Section: $key"
#     echo "Instructions:"
#     echo "${SECTION_MAP[$key]}"
#     echo "---------------------"
# done

# # now go through it and write out the sections in the desired order #
# # only some sections need to be in the desired order the rest as they came
# # Rationalise YAML: extract only the first occurrence of each DESIRED_START section, error on duplicates, write rest as-is
# DESIRED_START=(
#     "coble"
#     "channels"
#     "languages"    
# )

# declare -A FOUND_SECTIONS
# declare -A SECTION_CONTENT

# CURRENT_SECTION=""
# CURRENT_CONTENT=""

# # Read the file and extract first occurrence of each DESIRED_START section
# while IFS= read -r line || [[ -n "$line" ]]; do
#     if [[ "$line" =~ ^([a-zA-Z0-9_-]+):$ ]]; then
#         section_name="${BASH_REMATCH[1]}"
#         # If we were collecting a section, store it
#         if [[ -n "$CURRENT_SECTION" && -n "$CURRENT_CONTENT" ]]; then
#             if [[ -z "${SECTION_CONTENT[$CURRENT_SECTION]}" ]]; then
#                 SECTION_CONTENT[$CURRENT_SECTION]="$CURRENT_CONTENT"
#             fi
#         fi
#         CURRENT_CONTENT=""
#         CURRENT_SECTION="$section_name"
#         # If this is a DESIRED_START section
#         for desired in "${DESIRED_START[@]}"; do
#             if [[ "$section_name" == "$desired" ]]; then
#                 if [[ -n "${FOUND_SECTIONS[$section_name]}" ]]; then
#                     echo "[coble-rationalise] ERROR: Duplicate section '$section_name' found in $YAML_FILE" >&2
#                     echo "N"
#                     exit 1
#                 fi
#                 FOUND_SECTIONS[$section_name]=1
#             fi
#         done
#         CURRENT_CONTENT="$line"$'\n'
#     else
#         CURRENT_CONTENT+="$line"$'\n'
#     fi
# done < "$BACKUP_FILE"
# # Store last section
# if [[ -n "$CURRENT_SECTION" && -n "$CURRENT_CONTENT" ]]; then
#     if [[ -z "${SECTION_CONTENT[$CURRENT_SECTION]}" ]]; then
#         SECTION_CONTENT[$CURRENT_SECTION]="$CURRENT_CONTENT"
#     fi
# fi

# # Write DESIRED_START sections in order
# for section in "${DESIRED_START[@]}"; do
#     if [[ -n "${SECTION_CONTENT[$section]}" ]]; then
#         printf "%s" "${SECTION_CONTENT[$section]}" >> "$YAML_FILE"
#     fi
# done

# # Write the rest of the file, skipping DESIRED_START sections
# SKIP_SECTION=0
# while IFS= read -r line || [[ -n "$line" ]]; do
#     if [[ "$line" =~ ^([a-zA-Z0-9_-]+):$ ]]; then
#         section_name="${BASH_REMATCH[1]}"
#         SKIP_SECTION=0
#         for desired in "${DESIRED_START[@]}"; do
#             if [[ "$section_name" == "$desired" ]]; then
#                 SKIP_SECTION=1
#                 break
#             fi
#         done
#     fi
#     if [[ $SKIP_SECTION -eq 0 ]]; then
#         # if the line starts ##!COBLE skip it
#         if [[ "$line" == "##!COBLE"* ]]; then
#             continue
#         fi
#         printf "%s\n" "$line" >> "$YAML_FILE"
#     fi
# done < "$BACKUP_FILE"


# echo "[coble-reordered] Rationalisation complete: $YAML_FILE" >&2

# echo "Y"