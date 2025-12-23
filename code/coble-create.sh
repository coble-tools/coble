#!/usr/bin/env bash

# Execute a recipe script line by line to create an environment

##############
# success=$(coble-create.sh --recipe RECIPE_FILE --env ENV --outdir OUTDIR)
##############
# Inputs ----
# 1. --recipe recipe file
# 2. --env environment name or path
# 4. --outdir output log files directory
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
CAPTURE_FILE=""
RECIPE_FILE=""
NEW_ENV=""
LOG_FILE=""
TIME_FILE=""
KEEP_LOGS=0
OUTDIR="."
EXIT_ON_ERROR=1

show_help() {
    echo "Usage: $0  --env NEW_ENV [--recipe RECIPE_FILE] [--output CAPTURE_FILE] [--outdir OUTDIR]"    
    echo "  --env      NEW_ENV Overwrite to a new environment from the generated recipe script"
    echo "  --recipe    RECIPE    Specify input recipe shell script (required)"    
    echo "  --outdir   OUTDIR  Specify output directory for recipe file (optional)"
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
        --output)
            CAPTURE_FILE="$2"
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
        --outdir)
            OUTDIR="$2"
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


if [[ -z "$NEW_ENV" ]]; then
    echo "[coble-recreate] Error: --env NEW_ENV is required." >&2
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
    echo "[coble-recreate] Error: Input recipe file not found: $RECIPE_FILE" >&2
    exit 1
fi
mkdir -p "$OUTDIR"
base_name="${RECIPE_FILE##*/}"
base_name_noext="${base_name%.*}"

CAPTURE_FILE="coble-captured-${NEW_ENV_NAME}.yml"
CAPTURE_FILE="$OUTDIR/${CAPTURE_FILE}"

LOG_FILE="$OUTDIR/${base_name_noext}.log"
ERROR_FILE="$OUTDIR/${base_name_noext}.err"
TIME_FILE="$OUTDIR/${base_name_noext}-recreated-summary.txt"
# Clear previous log file and tike file
: > "$LOG_FILE"
: > "$TIME_FILE"
: > "$ERROR_FILE"
: > "$CAPTURE_FILE"
# Redirect stdout and stderr to log file
echo "[coble-create] REDIRECTED STDOUT to Log file: $LOG_FILE"
echo "[coble-create] REDIRECTED STDERR to Log file: $ERROR_FILE"

exec > >(tee -a "$LOG_FILE") 2> >(tee -a "$ERROR_FILE" >&2)
echo "[coble-recreate] Log file: $LOG_FILE"
echo "[coble-recreate] Log file: $ERROR_FILE"

# log time date user
echo "[coble-recreate] Started at $(date '+%Y-%m-%d %H:%M:%S')"
echo "[coble-recreate] User: $(whoami)"
echo ""
echo "[coble-recreate] Starting recreate process..."
echo "[coble-recreate] Input file: $INPUT_FILE"
if [[ -n "$NEW_ENV" ]]; then
    echo "[coble-recreate] New environment override: $NEW_ENV"
fi

# Start the summary log
echo "------------------------------------------------" >> "$TIME_FILE"
echo "[coble-recreate] Summary log started at $(date '+%Y-%m-%d %H:%M:%S')" >> "$TIME_FILE"
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

echo "[coble-recreate] Deactivating existing envs"
conda deactivate
# run each line of the recipe line by line
echo "[coble-recreate] Executing recipe script: $RECIPE_FILE"
total_lines=$(wc -l < "$RECIPE_FILE")
current_line=0
buffer=""
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

    echo "[coble-recreate] Running $current_line/$total_lines:"    
    echo "[coble-recreate] System info"
    echo "[coble-recreate] CPU cores: $(command -v nproc >/dev/null && nproc || sysctl -n hw.ncpu)"
    echo "[coble-recreate] Disk usage:"
    df -h .
    echo "[coble-recreate] Memory usage:"
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
    echo "[coble-recreate] Start time: $(date '+%Y-%m-%d %H:%M:%S') $current_line/$total_lines" >> "$TIME_FILE"
    echo $buffer >> "$TIME_FILE"    
    eval "$buffer"
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    # Now run the error checking on the log and err files
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    "$script_dir/coble-errors.sh" "$LOG_FILE" "$ERROR_FILE" "$TIME_FILE" "$EXIT_ON_ERROR"
    err_code=$?
    if [[ $err_code -eq 0 ]]; then
        echo "[coble-recreate] End time: $(date '+%Y-%m-%d %H:%M:%S')" >> "$TIME_FILE"    
        echo "[coble-recreate] Duration: ${DURATION}s" >> "$TIME_FILE"    
    else        
        echo "!!!!! Error detected Aborting due to exit setting !!!!!"
        echo "[coble-recreate] End time: $(date '+%Y-%m-%d %H:%M:%S')" >> "$TIME_FILE"    
        echo "[coble-recreate] Duration: ${DURATION}s" >> "$TIME_FILE"    
        exit 1
    fi

    echo "[coble-recreate] End time: $(date '+%Y-%m-%d %H:%M:%S')" >> "$TIME_FILE"    
    echo "[coble-recreate] Duration: ${DURATION}s" >> "$TIME_FILE"    
    echo "#####################################################"
    if [[ $? -ne 0 ]]; then
        echo "[coble-recreate] Error: Command failed: $buffer" >&2
        echo N
        exit 3
    fi
    # Reset buffer for the next command 
    buffer=""
done < "$RECIPE_FILE"

echo "[coble-recreate] Recreate process completed." >&2
# clear the log diversions and return stdout and stderr to normal
exec >&- 2>&-
echo Y







