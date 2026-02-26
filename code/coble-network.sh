#!/usr/bin/env bash
# Turn the currently activated conda environment into a netwrok graph


# Initialize Conda for Bash by sourcing .bash_profile and .bashrc
if [ -f "$HOME/.bash_profile" ]; then
    source "$HOME/.bash_profile"
fi

if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
fi

# If 'conda' is still not available, initialize using the shell hook
if ! type conda >/dev/null 2>&1; then
    if command -v conda >/dev/null 2>&1; then
        eval "$(conda shell.bash hook)"
    fi
fi

# Usage: ./coble-network.sh --frozen <recipe_file> [--env ENV]

# Default values
ENV_INPUT=""
RESULTS_DIR=""
DEPS_TXT=""
AGGREGATE_TXT=""

show_help() {
	echo "Usage: $0 --frozen <recipe_file> [--env ENV]"
	echo "  --frozen  clb    Specify input frozen cble file"
	echo "  --env     ENV    Specify conda environment name or prefix (optional, default is current activated environment)"	    
    echo "  -h,--help        Show this help message and exit"
}

echo "[coble-network] Start processing arguments..." >&2

while [[ $# -gt 0 ]]; do
	key="$1"
	case $key in
		--env)
			ENV_INPUT="$2"
			shift; shift
			;;		
		--frozen)
			AGGREGATE_TXT="$2"			
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
# if there is no results file we have to exit
if [[ -z "$AGGREGATE_TXT" ]]; then
	echo "[coble-network] Error: --frozen input file must be specified." >&2
	show_help
	exit 1
fi
# Default results dur is the directory of the output file
if [[ $RESULTS_DIR == "" ]]; then		
	RESULTS_DIR="$(dirname "$AGGREGATE_TXT")"	
fi
echo "[coble-network] Capturing conda environment to $RESULTS_DIR" >&2

# Parse named arguments
# Set ENV_FORMATTED: blank if ENV_INPUT is empty, otherwise --name ENV_INPUT
if [[ -z "$ENV_INPUT" ]]; then
	ACTIVE_ENV_NAME=$(echo "$CONDA_DEFAULT_ENV")
	ACTIVE_PREFIX=$(echo "$CONDA_PREFIX")
	if [[ -z "$ACTIVE_ENV_NAME" ]]; then
		echo "[coble-network] Error: No conda environment is currently activated and none was specified." >&2
		echo "[coble-network] Please activate a conda environment or use --env to specify one." >&2
		exit 2
	fi
	echo "[coble-network] No environment specified, using currently activated environment: $ACTIVE_ENV_NAME at $ACTIVE_PREFIX"    
	ENV_FORMATTED="--name $ACTIVE_ENV_NAME"
	ENV_NAME="$ACTIVE_ENV_NAME"
elif [[ "$ENV_INPUT" == */* ]]; then
	ENV_FORMATTED="--prefix $ENV_INPUT"
    # take of the last / for the name
    ENV_NAME="${ENV_INPUT##*/}"    
	# Check if the prefix directory exists and contains conda-meta
	if [[ ! -d "$ENV_INPUT" || ! -d "$ENV_INPUT/conda-meta" ]]; then
		echo "[coble-network] Error: The specified environment prefix does not exist or is not a valid conda environment: $ENV_INPUT" >&2
		exit 2
	fi
    echo "Activating environment: $ENV_INPUT" >&2
    conda activate $ENV_INPUT
else
	ENV_FORMATTED="--name $ENV_INPUT"
    ENV_NAME="$ENV_INPUT"   
	# Check if the environment name exists in conda env list
	if ! conda env list | awk '{print $1}' | grep -qx "$ENV_INPUT"; then
		echo "[coble-network] Error: The specified environment name does not exist: $ENV_INPUT" >&2
		exit 2
	fi
    echo "Activating environment: $ENV_INPUT" >&2
    conda activate $ENV_INPUT
fi

DEPS_TXT="${RESULTS_DIR}/${ENV_NAME}_dependencies.txt"
# empty the deps txt file
rm -rf "$DEPS_TXT"

echo "[coble-network] Using conda environment argument: $ENV_FORMATTED"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

keep_list=()
# loop though the lines of the frozen file and capture the packages
while IFS= read -r line; do
	# trim leading spaces
	line="$(echo "$line" | sed 's/^[[:space:]]*//')"
	# trim leading # if present
	line="${line#\#}"
	# trim leading spaces again
	line="$(echo "$line" | sed 's/^[[:space:]]*//')"
	# skip empty lines and lines with colons
	[[ "$line" == "" ]] && continue		
	[[ "$line" == *":"* ]] && continue		
	# parse the line into package and version
	pkg=$(echo "$line" | cut -d'=' -f1)
	ver=$(echo "$line" | cut -d'=' -f2)
	# take of trailing and leading spaces
	pkg=$(echo "$pkg" | xargs)
	ver=$(echo "$ver" | xargs)
	# from pkg take of leading - if any
	pkg=${pkg#-}
	# take of trailing and leading spaces
	pkg=$(echo "$pkg" | xargs)
	ver=$(echo "$ver" | xargs)
	
	if [[ " ${keep_list[*]} " =~ " $pkg " ]]; then
		echo "[coble-network] Skipping package (in keep list): $pkg"
		continue
	else		
		keep_list+=("$pkg")
		echo "[coble-network] Capturing package: $pkg==$ver"
		"$script_dir/coble-deps-r.R" "$pkg" -o "$DEPS_TXT"										
	fi
done < "$AGGREGATE_TXT"

# Now create the network viz
"$script_dir/coble-viz.R" "$DEPS_TXT" \
--output-path "$(dirname "$AGGREGATE_TXT")" \
--output-prefix "${ENV_NAME}_network" \
--title "COBLE Network Dependencies (c) ICR 2026 - Conda Environment: $ENV_NAME"

echo "[coble-network] Network visualization complete. Output written to $DEPS_TXT" >&2


