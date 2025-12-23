#!/usr/bin/env bash

# Find errors in a coble capture log and err file

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <capture_log_file> <capture_err_file> <output_file>"
    exit 1
fi
CAPTURE_LOG_FILE="$1"
CAPTURE_ERR_FILE="$2"
OUTPUT_FILE="$3"
DONE_FILE="$OUTPUT_FILE"
RECIPE_FILE="$OUTPUT_FILE"
EXIT_ON_ERROR="$4"

# convert to int if it is blank  
found_errors=false

#### ERRORS TO CHECK FOR #########
# Patterns for log matching
stdout_patterns=(
"is uninstallable because there are no viable options" 
"does not exist" 
"Encountered problems while solving" 
"nothing provides" 
"please re-install it" 
"Could not solve for environment specs"
)  
error_patterns=(
#"had non-zero exit status" 
"* removing" 
"fatal" 
"EnvironmentNotWritableError"     
"Rscript: command not found"     
"is not available for this version of R"
"EnvironmentLocationNotFound" 
"CondaValueError" 
"ERROR: failed to lock directory" 
"trying to use CRAN without setting a mirror"     
"API rate limit exceeded" 
"The channel is not accessible or is invalid" 
"PackagesNotFoundError" 
"Killed" 
"LibMambaUnsatisfiableError" 
"Error in loadNamespace(x)"
"there is no package"
)
done_patterns=(
"DONE ("   
"linux-64::" 
"noarch::"  
"Successfully installed" 
"** this is package"
)
# Ensure done messages are only reported once
mapfile -t done_lines < "$DONE_FILE"

if [ -f "$OUTPUT_FILE" ]; then
while IFS= read -r log_line; do
    for pattern in "${stdout_patterns[@]}"; do
    if echo "$log_line" | grep -qi "$pattern"; then
        echo "    # ERROR: Found '$pattern' in stdout: $log_line" >> "$RECIPE_FILE"
        found_errors=true          
    fi
    done
    for pattern in "${done_patterns[@]}"; do
    if echo "$log_line" | grep -qi "$pattern"; then          
        # change - always output as we have a clean set of logs with each install
        #if [[ ! " ${done_lines[*]} " =~ " $log_line " ]]; then            
        echo "    $log_line" >> "$DONE_FILE"                    
        #fi
    fi
    done
done < "$CAPTURE_LOG_FILE"
fi            
if [ -f "$CAPTURE_ERR_FILE" ]; then
while IFS= read -r err_line; do
    for pattern in "${error_patterns[@]}"; do
    if echo "$err_line" | grep -qi "$pattern"; then
        echo "    # ERROR: Found '$pattern' in stderr: $err_line" >> "$RECIPE_FILE"
        found_errors=true          
        # if it is a PackagesNotFoundError I want to report the next 2 lines as well
        if [[ "$pattern" == "PackagesNotFoundError"* ]]; then
        read -r next_line1
        echo "    # ERROR: $next_line1" >> "$RECIPE_FILE"
        read -r next_line2
        echo "    # ERROR: $next_line2" >> "$RECIPE_FILE"
        fi
    fi
    done
    for pattern in "${done_patterns[@]}"; do
    if echo "$err_line" | grep -qi "$pattern"; then          
        # change - always output as we have a clean set of logs with each install
        #if [[ ! " ${done_lines[*]} " =~ " $err_line " ]]; then            
        echo "    $err_line" >> "$DONE_FILE"                    
        #fi
    fi
    done
done < "$CAPTURE_ERR_FILE"
fi
    
if [[ "$found_errors" == true ]]; then
    echo "[coble-errors] Errors were found during recreation. Please review the recipe file: $RECIPE_FILE" >> "$DONE_FILE"                    
    if [[ "$EXIT_ON_ERROR" == "1" ]]; then
        echo "[coble-errors] Exiting due to --skip-errors flag. Forcing exit!!!!!" >> "$DONE_FILE"                        
        exit 1
    fi
fi




