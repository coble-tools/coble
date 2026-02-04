#!/usr/bin/env bash

# Default values
done_recipe=""
new_recipe=""
env_name=""
tmp_recipe=""

show_help() {
    echo "----- coble rationalise help ----------"    
    echo "Usage: $0 --done-recipe DONE_RECIPE --all-recipe ALL_RECIPE"    
    echo "  --done-recipe  FILE                    Specify old recipe file"
    echo "  --all-recipe  FILE                    Specify all recipe file"
    echo "  --env         ENV                     Specify environment name"
    echo "  -h, --help  Show this help message and exit"
    echo "------------------------------------"    
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --done-recipe) done_recipe="$2"; shift 2 ;;
    --all-recipe) all_recipe="$2"; shift 2 ;;    
    --env) env_name="$2"; shift 2 ;;
    -h|--help) show_help; exit 0 ;;    
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

echo "[coble-update] ~~~ Already done recipe: $done_recipe ~~~ New recipe: $all_recipe ~~~" >&2

# I want to go through the new-recipe and for every row, if it is not in the old recipe I want to execute it and add it to the end of the old recipe
base_name="${all_recipe##*/}"
base_name_noext="${base_name%.*}"
RESULTS_DIR="$(dirname "$all_recipe")"	
update_recipe="$RESULTS_DIR/${base_name_noext}.delta"    
: > "$update_recipe"


# Bash 3.2 compatible print_array
# Pass recipe file as first argument, then array elements
print_array() {
    local recipe_file="$1"
    shift  # Remove first argument (filename)
    
    # Now "$@" contains only the array elements
    for element in "$@"; do
        echo "$element" >> "$recipe_file"
    done
}

if [[ ! -f "$done_recipe" ]]; then  
    : > "$done_recipe"
fi

line_over=()
new=false
while IFS= read -r line; do
    # Skip empty lines and comments (bash 3.2 compatible pattern matching)
    if [[ -z "$line" || "$line" == "#"* ]]; then
        continue
    fi
    # Check if the line exists in the old recipe    
    line_over+=("${line}")                    
    if [[ "$line" == "conda activate"* ]]; then        
        echo "$line" >> "$update_recipe"                
    elif [[ "$line" == "conda deactivate"* ]]; then        
        echo "$line" >> "$update_recipe"                
    elif [[ "$line" == "conda env config"* ]]; then        
        echo "$line" >> "$update_recipe"                
    elif [[ "$line" == "export "* ]]; then        
        echo "$line" >> "$update_recipe"                
    elif [[ "$line" == "unset "* ]]; then        
        echo "$line" >> "$update_recipe"                
    elif [[ "$line" == "umask "* ]]; then        
        echo "$line" >> "$update_recipe"                
    elif [[ "$line" == "ln -sf"* ]]; then        
        echo "$line" >> "$update_recipe"                
    elif [[ "$line" == "conda config --env --set"* ]]; then        
        echo "$line" >> "$update_recipe"                        
    elif ! grep -Fxq "$line" "$done_recipe"; then        
        new=true        
    fi
    
    if [[ "$line" != *\\ ]]; then
        if [[ $new == true ]]; then
            # Bash 3.2 compatible: pass filename first, then array elements
            print_array "$update_recipe" "${line_over[@]}"
            echo "" >> "$update_recipe"
        fi
        line_over=()
        new=false      
    fi
done < "$all_recipe"

# if update recipe only contains an activate line then empty it
if [[ $(wc -l < "$update_recipe") -le 1 ]]; then
    : > "$update_recipe"
fi
