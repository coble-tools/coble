#!/usr/bin/env bash

# Execute a recipe script line by line to create an environment

##############
# success=$(coble-create.sh --recipe RECIPE_FILE --env ENV)
##############
# Inputs ----
# 1. --recipe recipe file
# 2. --env environment name or path
# Outputs ----
# --stdout --
# 1. success=Y/N
# --filesystem --
# 1. Conda environment
# 2. capture file
# 3. log files in outdir
###############

source "$(conda info --base)/etc/profile.d/conda.sh"

ENV_OUTPUT=""
RECIPE_FILE=""
NEW_ENV=""
LOG_FILE=""
TIME_FILE=""
KEEP_LOGS=0
OUTDIR="."
EXIT_ON_ERROR=1

show_help() {
    echo "Usage: $0  --env NEW_ENV --recipe RECIPE_FILE"    
    echo "  --env      NEW_ENV Overwrite to a new environment from the generated recipe script"
    echo "  --recipe    RECIPE    Specify input recipe shell script (required)"        
    echo "  --debug    Keep interim logs for debugging (optional)"
    echo "  --skip-errors  Exit on first error (not default behavior)"
    echo "  -h,--help  Show this help message and exit"
}

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in        
        --recipe)
            RECIPE_FILE="$2"
            shift; shift
            ;;        
        --env)
            NEW_ENV="$2"
            shift; shift
            ;;
        --debug)
            KEEP_LOGS=1
            shift; 
            ;;
        --skip-errors)
            EXIT_ON_ERROR=0
            shift; 
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


if [[ -z "$NEW_ENV" ]]; then
    echo "[coble-create] Error: --env NEW_ENV is required." >&2
    show_help
    exit 1
fi

NEW_ENV_NAME=""
NEW_ENV_ARG=""
if [[ "$NEW_ENV" == */* ]]; then
    NEW_ENV_NAME="${NEW_ENV##*/}"
    NEW_ENV_ARG="--prefix $NEW_ENV"
else
    NEW_ENV_NAME="$NEW_ENV"
    NEW_ENV_ARG="--name $NEW_ENV"
fi

if [[ ! -f "$RECIPE_FILE" ]]; then
    echo "[coble-create] Error: Input recipe file not found: $RECIPE_FILE" >&2
    exit 1
fi
mkdir -p "$OUTDIR"
base_name="${RECIPE_FILE##*/}"
base_name_noext="${base_name%.*}"

#LOG_FILE="$OUTDIR/${base_name_noext}.log"
#ERROR_FILE="$OUTDIR/${base_name_noext}.err"
#TIME_FILE="$OUTDIR/${base_name_noext}-recreated-summary.txt"

LOG_FILE="${RECIPE_FILE}.log"
ERROR_FILE="${RECIPE_FILE}.err"
TIME_FILE="${RECIPE_FILE}.summary.txt"

# Clear previous log file and tike file
: > "$LOG_FILE"
: > "$TIME_FILE"
: > "$ERROR_FILE"
# Redirect stdout and stderr to log file
echo "[coble-create] Redirected STDOUT to file: $LOG_FILE" >&2
echo "[coble-create] Redirected STDERR to file: $ERROR_FILE" >&2
echo "[coble-create] Summary recording at $TIME_FILE" >&2

exec > >(tee -a "$LOG_FILE") 2> >(tee -a "$ERROR_FILE" >&2)
echo "[coble-create] Log file: $LOG_FILE"
echo "[coble-create] Log file: $ERROR_FILE"

# log time date user
echo "[coble-create] Started at $(date '+%Y-%m-%d %H:%M:%S')"
echo "[coble-create] User: $(whoami)"
echo ""
echo "[coble-create] Starting create process..."
echo "[coble-create] Input file: $INPUT_FILE"
if [[ -n "$NEW_ENV" ]]; then
    echo "[coble-create] New environment override: $NEW_ENV"
fi

# Start the summary log
echo "------------------------------------------------" >> "$TIME_FILE"
echo "[coble-create] Summary log started at $(date '+%Y-%m-%d %H:%M:%S')" >> "$TIME_FILE"
echo "------------------------------------------------" >> "$TIME_FILE"

# Detect file type
case "$RECIPE_FILE" in    
    *.sh)
        # Shell script input: would run directly (not yet implemented)        
        RECIPE_FILE="$RECIPE_FILE"
        ;;
    *)
        echo "[coble-create] Error: Unknown input file type: $RECIPE_FILE" >&2
        echo N
        exit 2
        ;;
esac

echo "[coble-create] Deactivating existing envs"
conda deactivate
# run each line of the recipe line by line
echo "[coble-create] Executing recipe script: $RECIPE_FILE"
total_lines=$(wc -l < "$RECIPE_FILE")
current_line=0
buffer=""
BEGIN_TIME=$(date +%s)

# function to run error checking after each command#
# Usage: run_line "some command or line"
run_line() {
    local line="$1"
    # TODO: implement logic to process $line
    echo "[coble-create] Running $current_line/$total_lines:"    
    echo "[coble-create] System info"
    echo "[coble-create] CPU cores: $(command -v nproc >/dev/null && nproc || sysctl -n hw.ncpu)"
    echo "[coble-create] Disk usage:"
    df -h .
    echo "[coble-create] Memory usage:"
    if command -v free >/dev/null; then
        free -h
    elif command -v vm_stat >/dev/null; then
        vm_stat
    else
        echo "No memory info command found"
    fi
    echo "#####################################################"
    echo "$buffer"    
    # export to the TIME_FILE the start time
    START_TIME=$(date +%s)
    echo "" >> "$TIME_FILE"
    echo "[coble-create] Start time: $(date '+%Y-%m-%d %H:%M:%S') $current_line/$total_lines" >> "$TIME_FILE"
    echo $buffer >> "$TIME_FILE"    
    eval "$buffer"
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    # Now run the error checking on the log and err files
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    "$script_dir/coble-errors.sh" "$LOG_FILE" "$ERROR_FILE" "$TIME_FILE"
    err_code=$?    
    if [[ $err_code -eq 0 ]]; then
        echo "[coble-create] End time: $(date '+%Y-%m-%d %H:%M:%S')" >> "$TIME_FILE"    
        echo "[coble-create] Duration: ${DURATION}s" >> "$TIME_FILE"    
    elif [[ "$EXIT_ON_ERROR" == "1" ]]; then
        echo "[coble-errors] Errors found, exiting due to --skip-errors flag" >> "$DONE_FILE"
        exit 1
    else 
        echo "[coble-errors] Errors found, NOT exiting due to --skip-errors flag" >> "$DONE_FILE"
        echo "[coble-create] End time: $(date '+%Y-%m-%d %H:%M:%S')" >> "$TIME_FILE"    
        echo "[coble-create] Duration: ${DURATION}s" >> "$TIME_FILE"            
    fi    
    echo "#####################################################"
    if [[ $? -ne 0 ]]; then
        echo "[coble-create] Error: Command failed: $buffer" >&2
        echo N
        exit 3
    fi
}




while IFS= read -r line || [[ -n "$line" ]]; do    
    # Copy the last log file to LOG_FILE_date and start a new one
    # but only if it has more than 10 lines    
    line_count=$(wc -l < "$LOG_FILE")    
    if [[ $line_count -gt 3 ]]; then
        if [[ $KEEP_LOGS -eq 1 ]]; then
            cp "$LOG_FILE" "${LOG_FILE%.log}.log_${current_line}_${total_lines}.log"            
        fi        
        : > "$LOG_FILE"
    fi
    line_count=$(wc -l < "$ERROR_FILE")
    if [[ $line_count -gt 3 ]]; then
        if [[ $KEEP_LOGS -eq 1 ]]; then
            cp "$ERROR_FILE" "${ERROR_FILE%.err}.err_${current_line}_${total_lines}.err"            
        fi        
        : > "$ERROR_FILE"
    fi
    current_line=$((current_line + 1))
    # Skip empty lines and comments
    if [[ -z "$line" || "$line" == \#* ]]; then
        continue
    fi

    # If line ends with backslash, strip it and keep accumulating 
    if [[ $line == *\\ ]]; then 
      buffer+="${line%\\} " 
      continue 
    else 
      buffer+="$line" 
    fi
    # Run the accumulated command
    run_line "$buffer"    
    # Reset buffer for the next command 
    buffer=""
done < "$RECIPE_FILE"
# It needs to recognise if it has a final command to run without a newline
if [[ -n "$buffer" ]]; then
    run_line "$buffer"
    buffer=""
fi

END_TIME=$(date +%s)
DURATION=$((END_TIME - BEGIN_TIME))
hours=$((DURATION / 3600))
minutes=$(((DURATION % 3600) / 60))
seconds=$((DURATION % 60))


echo "--------------------------------------" >> "$TIME_FILE"    
echo "[coble-create] Recipe created at: $(date '+%Y-%m-%d %H:%M:%S')" >> "$TIME_FILE"    
echo "[coble-create] Recipe took: ${hours}h ${minutes}m ${seconds}s" >> "$TIME_FILE"
echo "--------------------------------------" >> "$TIME_FILE"        

echo "[coble-create] Recreate process completed." >&2
# clear the log diversions and return stdout and stderr to normal
exec >&- 2>&-
echo Y
exit 0







