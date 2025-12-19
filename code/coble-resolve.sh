#!/usr/bin/env bash
# Turn a captured yaml file into a coble recipe script


# Usage: ./coble-recipise.sh [--env ENV] [--input YAML_FILE] [--output RECIPE]

# Default values

YAML_FILE=""

# Parse named arguments
show_help() {
    echo "Usage: $0 [--env ENV] [--input YAML_FILE] [--output RECIPE] [--outdir OUTDIR]"    
    echo "  --input YAML     Specify input YAML file - it will be updated where there is a find"    
    echo "  -h, --help       Show this help message and exit"
}

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
    echo "[coble-refind] !!!error no yaml input please --input YAML"
    exit 1    
fi

YAML_RESOLVED="$YAML_FILE".resolved.yml

# Now show all the inputs
echo "[coble-refind] Using inputs:"
echo "  IN YAML: $YAML_FILE"
echo "  OUT YAML: $YAML_RESOLVED"

# output is a recipe file for conda env create (always in current directory)
echo "[coble-refind] Finding any required packages and in place replacing..."

# Clear the aggregate file at the start	
# Clear the aggregate file at the start
{	    
    echo "#######################################"    
    echo -e "# COBLE:Reproducible environment yaml, (c) ICR 2025"    
    CAPTURE_DATE=$(date '+%Y-%m-%d')
	CAPTURE_TIME=$(date '+%H:%M:%S %Z')
	CAPTURE_USER=$(whoami)	
	echo -e "# date: $CAPTURE_DATE"
	echo -e "# time: $CAPTURE_TIME"
	echo -e "# by: $CAPTURE_USER"    
    echo "#######################################"        
    echo ""
} > "$YAML_RESOLVED"

CURRENT_SECTION=""
LAST_SECTION=""
while IFS= read -r origline || [[ -n "$origline" ]]; do        
    # Trim leading/trailing whitespace
    line="$(echo -e "${origline}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"        
    if [[ "$line" == "find:"
        ]]; then
        CURRENT_SECTION="$line"
        echo "[coble-resolve] Package manager changing to: $CURRENT_SECTION"        
    elif [[ -n "$CURRENT_SECTION" && "$line" == *":"* ]]; then
        CURRENT_SECTION=""
        echo "$origline" >> "$YAML_RESOLVED"
    elif [[ -n "$CURRENT_SECTION" && "$line" == "-"* ]]; then
        pkg_entry="${line#- }"
        echo "[coble-resolve] Processing entry: $pkg_entry $CURRENT_SECTION"
        IFS='@' read -r pkg src path <<< "$pkg_entry"
        IFS='=' read -r pkg_name version <<< "$pkg"
        # For flags, parse directive and value from 'directive = value' format                
        if [[ "$CURRENT_SECTION" == "find:" ]]; then        
            script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
            # Build arguments array
            find_args=(--pkg "$pkg_name" --version "$version")
            # Call and capture return value
            mapfile -t result < <("$script_dir/coble-find.sh" "${find_args[@]}")
            pkg_manager="${result[0]}"
            recipe_line="${result[1]}"
            yaml_line="${result[2]}"
            if [[ $pkg_manager == "unknown" ]]; then
                echo "[coble-resolve] Unknown: $origline"
                echo "# Unknown package: $origline" >> "$YAML_RESOLVED"
            else            
                # Use the return value
                echo "[coble-resolve] Manager: $pkg_manager"
                echo "[coble-resolve] Recipe: $recipe_line"
                echo "[coble-resolve] Yaml: $yaml_line"                
                if [[ "$pkg_manager" != "$LAST_SECTION" ]]; then
                    echo "" >> "$YAML_RESOLVED"    
                    echo "$pkg_manager" >> "$YAML_RESOLVED"    
                    LAST_SECTION="$pkg_manager"
                fi
                if [[ $manager == "unknown" ]]; then
                    echo "# unknown: $origline" >> "$YAML_RESOLVED"
                else
                    echo "$yaml_line" >> "$YAML_RESOLVED"
                    #echo "$recipe_line" >> "$YAML_RESOLVED"
                fi
                
            fi
        else
            echo "$origline" >> "$YAML_RESOLVED"
        fi    
    else
        echo "$origline" >> "$YAML_RESOLVED"
    fi
done < "$YAML_FILE"
echo "[coble-resolve] Resolved generation complete: $YAML_RESOLVED"





