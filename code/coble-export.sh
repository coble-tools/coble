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
if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
elif [ -f "$HOME/.bash_profile" ]; then
    source "$HOME/.bash_profile"
else
	echo "[coble] Conda is not initialized in this shell." >&2
    echo "[coble] Please run: 'conda init bash' and restart your shell." >&2
    exit 1  # Stop the script immediately
fi

# Usage: ./coble-capture.sh --frozen <recipe_file> [--env ENV]

# Default values
ENV_INPUT=""
RESULTS_DIR=""
KEEP_LOGS=0
AGGREGATE_TXT=""
HAS_R=0
DRY_RUN=false

show_help() {
	echo "Usage: $0 --frozen <recipe_file> [--env ENV]"
	echo "  --xrecipe RECIPE  Specify output recipe file (optional, default: ./coble-reciped-reproduce.sh)"
	echo "  --env     ENV      Specify conda environment name or prefix (optional, default is current activated environment)"
    echo "  --debug   Keep interim logs for debugging (optional)"
	echo "  --dry-run Show the commands that would be run without executing them"
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
		--dry-run)
			DRY_RUN=true
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
# If dry run we simply exit
if [[ "$DRY_RUN" == true ]]; then
	echo "[coble-capture] DRY RUN: Not executing capture stage" >&2
	exit 0
fi
# if there is no results file we have to exit
if [[ -z "$AGGREGATE_TXT" ]]; then
	echo "[coble-export] Error: --xrecipe output file must be specified." >&2
	show_help
	exit 1
fi
# Default results dur is the directory of the output file
if [[ $RESULTS_DIR == "" ]]; then
	RESULTS_DIR="$(dirname "$AGGREGATE_TXT")"
fi
#
echo "[coble-export] Capturing conda environment to $RESULTS_DIR" >&2

# Parse named arguments
# Set ENV_FORMATTED: blank if ENV_INPUT is empty, otherwise --name ENV_INPUT
if [[ -z "$ENV_INPUT" ]]; then
	ACTIVE_ENV_NAME=$(echo "$CONDA_DEFAULT_ENV")
	ACTIVE_PREFIX=$(echo "$CONDA_PREFIX")
	if [[ -z "$ACTIVE_ENV_NAME" ]]; then
		echo "[coble-export] Error: No conda environment is currently activated and none was specified." >&2
		echo "[coble-export] Please activate a conda environment or use --env to specify one." >&2
		exit 2
	fi
	echo "[coble-export] No environment specified, using currently activated environment: $ACTIVE_ENV_NAME at $ACTIVE_PREFIX"
	ENV_FORMATTED="--name $ACTIVE_ENV_NAME"
	ENV_NAME="$ACTIVE_ENV_NAME"
elif [[ "$ENV_INPUT" == */* ]]; then
	ENV_FORMATTED="--prefix $ENV_INPUT"
    # take of the last / for the name
    ENV_NAME="${ENV_INPUT##*/}"
	# Check if the prefix directory exists and contains conda-meta
	if [[ ! -d "$ENV_INPUT" || ! -d "$ENV_INPUT/conda-meta" ]]; then
		echo "[coble-export] Error: The specified environment prefix does not exist or is not a valid conda environment: $ENV_INPUT" >&2
		exit 2
	fi
    echo "[coble-export] Activating environment: $ENV_INPUT" >&2
    conda activate $ENV_INPUT
else
	ENV_FORMATTED="--name $ENV_INPUT"
    ENV_NAME="$ENV_INPUT"
	# Check if the environment name exists in conda env list
	if ! conda env list | awk '{print $1}' | grep -qx "$ENV_INPUT"; then
		echo "[coble-export] Error: The specified environment name does not exist: $ENV_INPUT" >&2
		exit 2
	fi
    echo "[coble-export] Activating environment: $ENV_INPUT" >&2
    conda activate $ENV_INPUT
fi

echo "[coble-export] Using conda environment argument: $ENV_FORMATTED"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define output filenames
mkdir -p "$RESULTS_DIR"
TMP_RENV_FILE="$RESULTS_DIR/cbl-export-${ENV_NAME}_renv.lock"
TMP_PIP_FREEZE_TXT="$RESULTS_DIR/cbl-export-${ENV_NAME}_pip_freeze.txt"

TMP_ENV_FILE="$RESULTS_DIR/cbl-export-${ENV_NAME}_env.yaml"
TMP_ENV_FROM_HISTORY_TXT="$RESULTS_DIR/cbl-export-${ENV_NAME}_env_from_history.yaml"
TMP_CONDA_LIST_TXT="$RESULTS_DIR/cbl-export-${ENV_NAME}_conda_list.txt"
TMP_CONDA_LIST_EXPLICIT_TXT="$RESULTS_DIR/cbl-export-${ENV_NAME}_conda_list_explicit.txt"
TMP_CONDA_LIST_EXPLICIT_MD5_TXT="$RESULTS_DIR/cbl-export-${ENV_NAME}_conda_list_explicit_md5.txt"
TMP_CONDA_HISTORY_TXT="$RESULTS_DIR/cbl-export-${ENV_NAME}_conda_history.txt"

# If R is available we renv the environment and capture the R packages as well
if command -v R &> /dev/null; then
	HAS_R=1
	echo "[coble-export] R detected, capturing R environment with renv..." >&2
	Rscript -e "if (!requireNamespace('renv', quietly = TRUE)) install.packages('renv'); renv::snapshot(lockfile = '$TMP_RENV_FILE', prompt = FALSE)"
else
	echo "[coble-export] R not detected, skipping R environment capture." >&2
fi

# if python is available we capture the pip freeze as well
if command -v python &> /dev/null; then
	echo "[coble-export] Python detected, capturing pip freeze..." >&2
	python -m pip freeze > "$TMP_PIP_FREEZE_TXT"
else
	echo "[coble-export] Python not detected, skipping pip freeze capture." >&2
fi

# conda is by necessity available so now we capture the conda environment in various ways
echo "[coble-export] Capturing conda environment with various methods..." >&2
conda env export $ENV_FORMATTED --no-builds > "$TMP_ENV_FILE"
conda env export $ENV_FORMATTED --from-history > "$TMP_ENV_FROM_HISTORY_TXT"
conda list $ENV_FORMATTED > "$TMP_CONDA_LIST_TXT"
conda list $ENV_FORMATTED --explicit > "$TMP_CONDA_LIST_EXPLICIT_TXT"
conda list $ENV_FORMATTED --explicit --md5 > "$TMP_CONDA_LIST_EXPLICIT_MD5_TXT"
conda list $ENV_FORMATTED --revisions > "$TMP_CONDA_HISTORY_TXT"







