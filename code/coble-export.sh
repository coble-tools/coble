#!/usr/bin/env bash
# Capture the currently activated conda environment


############## All the possible captures of the environment go here #############
#   conda list --explicit
#   conda history
#   conda list --explicit --md5
#   conda list --explicit --md5
#   conda env export --from-history
#
#################################################################################

# Initialize conda - try .bashrc first, fall back to conda init
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
else
    # If .bashrc doesn't exist (e.g., in CI), initialize conda directly
    if command -v conda &> /dev/null; then
        eval "$(conda shell.bash hook)"
    fi
fi

# Usage: ./coble-capture.sh --frozen <recipe_file> [--env ENV]

# Default values
ENV_INPUT=""
RESULTS_DIR=""
KEEP_LOGS=0
AGGREGATE_TXT=""
HAS_R=0

show_help() {
	echo "Usage: $0 --frozen <recipe_file> [--env ENV]"
	echo "  --xrecipe RECIPE  Specify output recipe file (optional, default: ./coble-reciped-reproduce.sh)"
	echo "  --env     ENV      Specify conda environment name or prefix (optional, default is current activated environment)"	
    echo "  --debug   Keep interim logs for debugging (optional)"    
    echo "  -h,--help Show this help message and exit"
}

echo "[coble-export] Start processing arguments..." >&2

while [[ $# -gt 0 ]]; do
	key="$1"
	case $key in
		--env)
			ENV_INPUT="$2"
			shift; shift
			;;		
		--xrecipe)
			AGGREGATE_TXT="$2"			
			shift; shift
			;;
        --debug)
            KEEP_LOGS=1
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
# if there is no results file we have to exit
if [[ -z "$AGGREGATE_TXT" ]]; then
	echo "[coble-freeze] Error: --frozen output file must be specified." >&2
	show_help
	exit 1
fi
# Default results dur is the directory of the output file
if [[ $RESULTS_DIR == "" ]]; then		
	RESULTS_DIR="$(dirname "$AGGREGATE_TXT")"	
fi
echo "[coble-freeze] Capturing conda environment to $RESULTS_DIR" >&2

# Parse named arguments
# Set ENV_FORMATTED: blank if ENV_INPUT is empty, otherwise --name ENV_INPUT
if [[ -z "$ENV_INPUT" ]]; then
	ACTIVE_ENV_NAME=$(echo "$CONDA_DEFAULT_ENV")
	ACTIVE_PREFIX=$(echo "$CONDA_PREFIX")
	if [[ -z "$ACTIVE_ENV_NAME" ]]; then
		echo "[coble-freeze] Error: No conda environment is currently activated and none was specified." >&2
		echo "[coble-freeze] Please activate a conda environment or use --env to specify one." >&2
		exit 2
	fi
	echo "[coble-freeze] No environment specified, using currently activated environment: $ACTIVE_ENV_NAME at $ACTIVE_PREFIX"    
	ENV_FORMATTED="--name $ACTIVE_ENV_NAME"
	ENV_NAME="$ACTIVE_ENV_NAME"
elif [[ "$ENV_INPUT" == */* ]]; then
	ENV_FORMATTED="--prefix $ENV_INPUT"
    # take of the last / for the name
    ENV_NAME="${ENV_INPUT##*/}"    
	# Check if the prefix directory exists and contains conda-meta
	if [[ ! -d "$ENV_INPUT" || ! -d "$ENV_INPUT/conda-meta" ]]; then
		echo "[coble-freeze] Error: The specified environment prefix does not exist or is not a valid conda environment: $ENV_INPUT" >&2
		exit 2
	fi
    echo "[coble-freeze] Activating environment: $ENV_INPUT" >&2
    conda activate $ENV_INPUT
else
	ENV_FORMATTED="--name $ENV_INPUT"
    ENV_NAME="$ENV_INPUT"   
	# Check if the environment name exists in conda env list
	if ! conda env list | awk '{print $1}' | grep -qx "$ENV_INPUT"; then
		echo "[coble-freeze] Error: The specified environment name does not exist: $ENV_INPUT" >&2
		exit 2
	fi
    echo "[coble-freeze] Activating environment: $ENV_INPUT" >&2
    conda activate $ENV_INPUT
fi

echo "[coble-freeze] Using conda environment argument: $ENV_FORMATTED"

# Define output filenames
mkdir -p "$RESULTS_DIR"
TMP_CONDA_LIST_TXT="$RESULTS_DIR/coble_tmp_conda-packages-$ENV_NAME.txt"
TMP_PIP_FREEZE_TXT="$RESULTS_DIR/coble_tmp_pip-freeze-$ENV_NAME.txt"
TMP_R_PACKAGES_TXT="$RESULTS_DIR/coble_tmp_r-packages-$ENV_NAME.txt"
TMP_AGGREGATE="$RESULTS_DIR/coble_tmp_coble-captured-$ENV_NAME.tmp"
TMP_SORTED1="$RESULTS_DIR/coble_tmp_coble-captured-sorted1-$ENV_NAME.tmp"
TMP_SORTED="$RESULTS_DIR/coble_tmp_coble-captured-sorted2-$ENV_NAME.tmp"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

