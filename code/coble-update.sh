#!/bin/bash

echo "[coble-update]" >&2

# Default values
old_recipe=""
new_recipe=""
env_name=""
tmp_recipe=""

show_help() {
    echo "----- coble rationalise help ----------"    
    echo "Usage: $0 --old-recipe OLD_RECIPE --new-recipe NEW_RECIPE"    
    echo "  --old-recipe  FILE                    Specify old recipe file"
    echo "  --new-recipe  FILE                    Specify new recipe file"
    echo "  --env         ENV                     Specify environment name"
    echo "  -h, --help  Show this help message and exit"
    echo "------------------------------------"    
}

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --old-recipe) old_recipe="$2"; shift 2 ;;
    --new-recipe) new_recipe="$2"; shift 2 ;;    
    --env) env_name="$2"; shift 2 ;;
    -h|--help) show_help; exit 0 ;;    
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

echo "[coble-update] ~~~ Old recipe: $old_recipe ~~~ New recipe: $new_recipe ~~~" >&2

# I want to go through the new-recipe and for every row, if it is not in the old recipe I want to execute it and add it to the end of the old recipe

# Append with time date user ############################################
{	
    CAPTURE_DATE=$(date '+%Y-%m-%d')
	CAPTURE_TIME=$(date '+%H:%M:%S %Z')
	CAPTURE_USER=$(whoami)	    
    echo -e "Updated receipe on: $CAPTURE_DATE at $CAPTURE_TIME by $CAPTURE_USER"            
} >> "$old_recipe"

tmp_recipe=$new_recipe.update.sh
: > "$tmp_recipe"


print_array() {
    local arr=("$@")
    local recipe_file="${arr[-1]}"
    unset 'arr[-1]'  # Remove filename from array

    for element in "${arr[@]}"; do
        echo "$element" >> "$recipe_file"
    done
}

line_over=()
new=false
while IFS= read -r line; do
    # Skip empty lines and comments
    if [[ -z "$line" || "$line" =~ ^# ]]; then
        continue
    fi
    # Check if the line exists in the old recipe    
    line_over+=("${line}")                
    if [[ ${#line_over[@]} -gt 1 ]]; then
        echo "[coble-update] Combining lines: ${line_over[@]}" >&2        
        #print_array "${line_over[@]}" $tmp_recipe  # Note the [@]
    fi

    if [[ "$line" == "conda activate"* ]]; then        
        echo "$line" >> "$tmp_recipe"                
    elif ! grep -Fxq "$line" "$old_recipe"; then        
        new=true        
    fi
    
    if [[ "$line" != *\\ ]]; then
        if [[ $new == true ]]; then
            print_array "${line_over[@]}" "$tmp_recipe"
            echo "" >> "$tmp_recipe"
        fi
        line_over=()
        new=false      
    fi
done < "$new_recipe"
