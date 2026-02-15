#!/usr/bin/env bash

# Find errors in a coble capture log and err file

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <capture_log_file> <capture_err_file> <output_file>"
    exit 1
fi
CAPTURE_LOG_FILE="$1"
CAPTURE_ERR_FILE="$2"
OUTPUT_FILE="$3"
EXIT_ON_ERROR="$4"
DONE_FILE="$OUTPUT_FILE"
RECIPE_FILE="$OUTPUT_FILE"

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
    "Failed to build"     
    "ERROR: compilation failed" 
    "HTTP error 404"
    "ClobberError"
    "SafetyError"
    "LinkError: post-link script failed for package"
    "Error in rawToChar"
)
error_patterns=(
    "* removing"    
    #"fatal"
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
    "Failed to build" 
    "packages failed:"
    "ERROR: compilation failed" 
    "HTTP error 404"
    "ClobberError"
    "SafetyError"
    "LinkError: post-link script failed for package"
    "Error in rawToChar"
)
done_patterns=(    
    "Successfully installed"
    #"** this is package"
    "Requirement already satisfied"
    "All requested packages already installed"
)

dep_patterns=(
    "DONE ("
    "linux-64::"
    "linux-aarch64::"
    "noarch::"   
    "[GitHub]" 
    " ) [CRAN]" 
    #" +"
)

# Write patterns to temp files
stdout_pat_file=$(mktemp)
error_pat_file=$(mktemp)
done_pat_file=$(mktemp)
dep_pat_file=$(mktemp)
printf "%s\n" "${stdout_patterns[@]}" > "$stdout_pat_file"
printf "%s\n" "${error_patterns[@]}" > "$error_pat_file"
printf "%s\n" "${done_patterns[@]}" > "$done_pat_file"
printf "%s\n" "${dep_patterns[@]}" > "$dep_pat_file"

# Grep for stdout patterns in log file

if [ -f "$CAPTURE_LOG_FILE" ]; then
    while read -r match; do
        echo "    # ERROR: From stdout found: $match" >> "$RECIPE_FILE"
        found_errors=true
    done < <(grep -F -f "$stdout_pat_file" "$CAPTURE_LOG_FILE")
    while read -r match; do
        echo "    $match" >> "$DONE_FILE"
    done < <(grep -F -f "$done_pat_file" "$CAPTURE_LOG_FILE")
    while read -r match; do
        echo "dep: # $match" >> "$DONE_FILE"
    done < <(grep -F -f "$dep_pat_file" "$CAPTURE_LOG_FILE")
fi

# Grep for error patterns in error file

if [ -f "$CAPTURE_ERR_FILE" ]; then
    while read -r match; do
        echo "    # ERROR: from stderr found: $match" >> "$RECIPE_FILE"
        found_errors=true        
    done < <(grep -F -f "$error_pat_file" "$CAPTURE_ERR_FILE")
    while read -r match; do
        echo "    $match" >> "$DONE_FILE"
    done < <(grep -F -f "$done_pat_file" "$CAPTURE_ERR_FILE")
    while read -r match; do
        echo "dep: # $match" >> "$DONE_FILE"
    done < <(grep -F -f "$dep_pat_file" "$CAPTURE_ERR_FILE")
fi

# Clean up temp files
rm -f "$stdout_pat_file" "$error_pat_file" "$done_pat_file" "$dep_pat_file"
if [[ "$found_errors" == true ]]; then
    echo "[coble-errors] Errors were found during recreation. Please review the recipe file: $RECIPE_FILE" >> "$DONE_FILE"    
    exit 1    
else
    exit 0
fi

