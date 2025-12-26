#!/usr/bin/env bash

##############
# finds=$(coble-resolve.sh --input my.yml)
##############
# Inputs ----
# 1. --input yamlfile
# Outputs ----
# --stdout --
# 1. success=Y/N
# --filesystem --
# 1. yamlfile
# 2. yamlfile.bak1.yml
###############


# Usage: ./coble-resolve.sh --input YAML_FILE

# Default values

YAML_FILE=""

# Parse named arguments
show_help() {
    echo "----- coble resolve help ----------"    
    echo "Usage: $0 --input YAML_FILE"    
    echo "  --input YAML     Specify input YAML file - it will be updated where there is a find"
    echo "  -h, --help       Show this help message and exit"
    echo "------------------------------------"
    echo "OUTPUT- return value Y/N: Y if a find was changed to a package manager"    
    echo "------------------------------------"
}
finds=N
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in        
        --input)
            YAML_FILE="$2"
            shift; shift
            ;;        
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            shift
            ;;
    esac
done


if [[ -z "$YAML_FILE" || ! -f "$YAML_FILE" ]]; then
    # exit as the whole point is to change the yaml file
    echo "[coble-refind] !!!error no yaml input please --input YAML" >&2
    exit 1    
fi


# Now check the second line, if the 'yml' is already coble resolved, exit
second_line=$(sed -n '2p' "$YAML_FILE")
if [[ "$second_line" == "## COBLE:"* && "$second_line" == *Resolved* ]]; then
    echo "[coble-refind] YAML already coble resolved, exiting: $YAML_FILE" >&2
    echo N
    exit 0
fi

YAML_BACKUP="$YAML_FILE".bak1.yml
# copy to backup
cp "$YAML_FILE" "$YAML_BACKUP"

# Now show all the inputs
echo "[coble-refind] Using inputs:" >&2
echo "  IN YAML: $YAML_FILE" >&2
echo "  BACKUP YAML: $YAML_BACKUP" >&2

# output is a recipe file for conda env create (always in current directory)
echo "[coble-refind] Finding any required packages and in place replacing..." >&2
	
# Clear the aggregate file at the start
{	    
    echo "#######################################"    
    CAPTURE_DATE=$(date '+%Y-%m-%d')
	CAPTURE_TIME=$(date '+%H:%M:%S %Z')
	CAPTURE_USER=$(whoami)	
    echo -e "## COBLE:Reproducible environment (c) ICR 2025. Resolved"        	    
    echo -e "##    Resolved - On: $CAPTURE_DATE" at $CAPTURE_TIME" by $CAPTURE_USER"        	    
    echo "#######################################"    
    echo "" 
} > "$YAML_FILE"

CURRENT_SECTION=""
LAST_SECTION=""
while IFS= read -r origline || [[ -n "$origline" ]]; do        
    # Trim leading/trailing whitespace
    line="$(echo -e "${origline}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"        
    if [[ "$line" == "find:"
        ]]; then
        CURRENT_SECTION="$line"
        echo "[coble-resolve] Package manager changing to: $CURRENT_SECTION" >&2        
        echo "$origline" >> "$YAML_FILE"
    elif [[ -n "$CURRENT_SECTION" && "$line" == *":"* ]]; then
        CURRENT_SECTION=""
        echo "$origline" >> "$YAML_FILE"
    elif [[ -n "$CURRENT_SECTION" && "$line" == "-"* ]]; then
        pkg_entry="${line#- }"
        echo "[coble-resolve] Processing entry: $pkg_entry $CURRENT_SECTION" >&2
        IFS='@' read -r pkg src path <<< "$pkg_entry"
        IFS='=' read -r pkg_name version <<< "$pkg"
        # For flags, parse directive and value from 'directive = value' format                
        if [[ "$CURRENT_SECTION" == "find:" ]]; then
            finds=Y
            script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
            # Build arguments array
            find_args=(--pkg "$pkg_name" --version "$version" --input "$YAML_FILE")
            [[ -n "$src" ]] && find_args+=(--source "$src")
            [[ -n "$path" ]] && find_args+=(--path "$path")
            # output the request to the yaml
            echo "$origline" >> "$YAML_FILE"
            # Call and capture return value
            mapfile -t result < <("$script_dir/coble-find.sh" "${find_args[@]}")
            pkg_manager="${result[0]}"
            recipe_line="${result[1]}"
            yaml_line="${result[2]}"
            if [[ $pkg_manager == "unknown" ]]; then
                echo "[coble-resolve] Unknown: $origline" >&2
                echo "# Unknown package: $origline" >> "$YAML_FILE"
            else            
                # Use the return value
                echo "[coble-resolve] Manager: $pkg_manager" >&2
                echo "[coble-resolve] Recipe: $recipe_line" >&2
                echo "[coble-resolve] Yaml: $yaml_line" >&2                
                if [[ "$pkg_manager" != "$LAST_SECTION" ]]; then
                    #echo "" >> "$YAML_FILE"    
                    echo "$pkg_manager" >> "$YAML_FILE"    
                    LAST_SECTION="$pkg_manager"
                fi
                if [[ $pkg_manager == "unknown" ]]; then
                    echo "# unknown: $origline" >> "$YAML_FILE"
                else
                    echo "$yaml_line" >> "$YAML_FILE"                    
                fi
                
            fi
        else
            echo "$origline" >> "$YAML_FILE"
        fi    
    else
        echo "$origline" >> "$YAML_FILE"
    fi
done < "$YAML_BACKUP"
if [[ $finds == "Y" ]]; then
    echo "[coble-resolve] Finds were resolved, please check the yml output: $YAML_FILE" >&2
else
    echo "[coble-resolve] No finds were resolved, yaml unchanged: $YAML_FILE" >&2
fi
echo $finds #this is the output Y/N






