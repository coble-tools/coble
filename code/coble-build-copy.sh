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

show_help() {
	echo "  --env     ENV      Specify conda environment name or prefix (optional, default is current activated environment)"
    echo "  -h,--help Show this help message and exit"
}

echo "[coble-capture] Start processing arguments..." >&2

while [[ $# -gt 0 ]]; do
	key="$1"
	case $key in
		--env)
			ENV_INPUT="$2"
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
# If dry run we simply exit
if [[ "$DRY_RUN" == true ]]; then
	echo "[coble-capture] DRY RUN: Not executing capture stage" >&2
	exit 0
fi

# Parse named arguments
# Set ENV_FORMATTED: blank if ENV_INPUT is empty, otherwise --name ENV_INPUT
if [[ -z "$ENV_INPUT" ]]; then

	echo "[coble-capture] Please activate a conda environment or use --env to specify one." >&2
	exit 2
fi

if [[ "$ENV_INPUT" == */* ]]; then
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

mkdir -p "$CONDA_PREFIX/coble-build"
echo "[coble] Copying recipe file $RECIPE_FILE to $CONDA_PREFIX/coble-build/${base_name_noext}.cbl" >&2
cp "$RECIPE_FILE" "$CONDA_PREFIX/coble-build/${base_name_noext}.cbl"
echo "[coble] Copying capture file to $CONDA_PREFIX/coble-build/${base_name_noext}_freeze.cbl" >&2
cp "$capture_file" "$CONDA_PREFIX/coble-build/${base_name_noext}_freeze.cbl"
echo "[coble] Copying summary file to $CONDA_PREFIX/coble-build/${base_name_noext}_summary.txt" >&2
cp "$summary_file" "$CONDA_PREFIX/coble-build/${base_name_noext}_summary.txt"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
COBLE_BUILD_SOURCE="$SCRIPT_DIR/coble-build"
echo "[coble] Copying coble-build commands file $COBLE_BUILD_SOURCE to $CONDA_PREFIX/bin/coble-build" >&2
cp "$COBLE_BUILD_SOURCE" "$CONDA_PREFIX/bin/coble-build"
chmod +x "$CONDA_PREFIX/bin/coble-build"



echo "[coble-build-copy] Environment setup complete" >&2
echo "[coble] To activate environment call:" >&2
echo "    conda activate $ENV_INPUT" >&2
echo "  then validate the environment with:" >&2
echo "    validate.sh" >&2
echo "  or if you want to stream the output to a log file:" >&2
echo "    validate.sh | tee validate.log" >&2
echo "  to check the coble build in the conda environment call:" >&2
echo "    coble-build --help" >&2
echo "    coble-build version #etc" >&2

