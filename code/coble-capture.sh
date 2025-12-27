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

source "$(conda info --base)/etc/profile.d/conda.sh"

# Usage: ./coble-capture.sh [--env ENV] [--outdir DIR]

# Default values
ENV_INPUT=""
RESULTS_DIR="."
KEEP_LOGS=0
AGGREGATE_TXT=""

show_help() {
	echo "Usage: $0 [--env ENV] [--outdir DIR]"
	echo "  --env     ENV      Specify conda environment name or prefix (optional, default is current activated environment)"
	echo "  --outdir  DIR   Specify output directory (optional, default: .)"    	
    echo "  --debug   Keep interim logs for debugging (optional)"
    echo "  --output  RECIPE  Specify output recipe file (optional, default: ./coble-reciped-reproduce.sh)"
    echo "  -h,--help Show this help message and exit"
}

while [[ $# -gt 0 ]]; do
	key="$1"
	case $key in
		--env)
			ENV_INPUT="$2"
			shift; shift
			;;
		--outdir)
			RESULTS_DIR="$2"            
			shift; shift
			;;
		--output)
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

echo "[coble-capture] Capturing conda environment to $RESULTS_DIR"

# Parse named arguments
# Set ENV_FORMATTED: blank if ENV_INPUT is empty, otherwise --name ENV_INPUT
if [[ -z "$ENV_INPUT" ]]; then
	ACTIVE_ENV_NAME=$(echo "$CONDA_DEFAULT_ENV")
	ACTIVE_PREFIX=$(echo "$CONDA_PREFIX")
	if [[ -z "$ACTIVE_ENV_NAME" ]]; then
		echo "[coble-capture] Error: No conda environment is currently activated and none was specified." >&2
		echo "[coble-capture] Please activate a conda environment or use --env to specify one." >&2
		exit 2
	fi
	echo "[coble-capture] No environment specified, using currently activated environment: $ACTIVE_ENV_NAME at $ACTIVE_PREFIX"    
	ENV_FORMATTED="--name $ACTIVE_ENV_NAME"
	ENV_NAME="$ACTIVE_ENV_NAME"
elif [[ "$ENV_INPUT" == */* ]]; then
	ENV_FORMATTED="--prefix $ENV_INPUT"
    # take of the last / for the name
    ENV_NAME="${ENV_INPUT##*/}"    
	# Check if the prefix directory exists and contains conda-meta
	if [[ ! -d "$ENV_INPUT" || ! -d "$ENV_INPUT/conda-meta" ]]; then
		echo "[coble-capture] Error: The specified environment prefix does not exist or is not a valid conda environment: $ENV_INPUT" >&2
		exit 2
	fi
    echo "Activating environment: $ENV_INPUT"
    conda activate $ENV_INPUT
else
	ENV_FORMATTED="--name $ENV_INPUT"
    ENV_NAME="$ENV_INPUT"   
	# Check if the environment name exists in conda env list
	if ! conda env list | awk '{print $1}' | grep -qx "$ENV_INPUT"; then
		echo "[coble-capture] Error: The specified environment name does not exist: $ENV_INPUT" >&2
		exit 2
	fi
    echo "Activating environment: $ENV_INPUT"
    conda activate $ENV_INPUT
fi

echo "[coble-capture] Using conda environment argument: $ENV_FORMATTED"

# Define output filenames
mkdir -p "$RESULTS_DIR"
TMP_CONDA_LIST_TXT="$RESULTS_DIR/coble_tmp_conda-packages-$ENV_NAME.txt"
TMP_PIP_FREEZE_TXT="$RESULTS_DIR/coble_tmp_pip-freeze-$ENV_NAME.txt"
TMP_R_PACKAGES_TXT="$RESULTS_DIR/coble_tmp_r-packages-$ENV_NAME.txt"
TMP_AGGREGATE="$RESULTS_DIR/coble_tmp_coble-captured-$ENV_NAME.tmp"
TMP_SORTED="$RESULTS_DIR/coble_tmp_coble-captured-sorted-$ENV_NAME.tmp"
if [[ -z "$AGGREGATE_TXT" ]]; then
    AGGREGATE_TXT="$RESULTS_DIR/coble-captured-$ENV_NAME.yml"
fi


echo "[coble-capture] Running: conda list $ENV_FORMATTED > $TMP_CONDA_LIST_TXT"
conda list $ENV_FORMATTED --show-channel-urls> "$TMP_CONDA_LIST_TXT"

# Capture pip freeze output for provenance (e.g., GitHub installs)

echo "[coble-capture] Running: conda run $ENV_FORMATTED python -m pip freeze > $TMP_PIP_FREEZE_TXT"
if conda run $ENV_FORMATTED python --version &> /dev/null 2>&1; then
    conda run $ENV_FORMATTED python -m pip freeze > "$TMP_PIP_FREEZE_TXT"
else
    echo "Python not available in conda environment"
fi

# List all R packages with version and source
echo "[coble-capture] Running: conda run $ENV_FORMATTED Rscript ... > $TMP_R_PACKAGES_TXT"
# if Rscript is in the environment, run the Rscript to get package info
if ! conda run $ENV_FORMATTED Rscript --version &> /dev/null 2>&1; then
	echo "    R is not available in conda environment"
else    
	script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	RSCRIPT="$script_dir/coble-capture-r.R"
	if conda run $ENV_FORMATTED Rscript "$RSCRIPT"; then
        echo "R script completed successfully"
    else
        echo "Rscript not found in environment" > "$TMP_R_PACKAGES_TXT"
    fi
fi

# Clear the aggregate file at the start
> "$TMP_AGGREGATE"
> "$AGGREGATE_TXT"

# Write header (combine package and version)
echo -e "Manager\tPackage\tSource\tPath" > "$TMP_AGGREGATE"

# Process conda packages (skip lines containing 'pypi' and comments/headers)
while IFS= read -r line; do
	# Skip header, comments, and pypi lines
	[[ "$line" =~ ^#.*$ ]] && continue
	[[ "$line" == "" ]] && continue
	[[ "$line" == *pypi* ]] && continue
	# Parse: Name Version Build Channel
	pkg=$(echo "$line" | awk '{print $1}')
	ver=$(echo "$line" | awk '{print $2}')
	src=$(echo "$line" | awk '{print $4}')
	if [[ "$pkg" == r-* ]]; then
		manager="r-conda"
		pkg_no_r=${pkg#r-}
		pkgver="$pkg_no_r=$ver"
		echo -e "$manager\t$pkgver\t$src\t" >> "$TMP_AGGREGATE"
	elif [[ "$pkg" == bioconductor-* ]]; then
		manager="bioc-conda"
		pkg_no_r=${pkg#bioconductor-}
		pkgver="$pkg_no_r=$ver"
		echo -e "$manager\t$pkgver\t$src\t" >> "$TMP_AGGREGATE"
	else
			# Only add =version if version is not blank or 0
			if [[ -z "$ver" || "$ver" == "0" ]]; then
				pkgver="$pkg"
			else
				pkgver="$pkg=$ver"
			fi
		echo -e "conda\t$pkgver\t$src\t" >> "$TMP_AGGREGATE"
	fi
done < "$TMP_CONDA_LIST_TXT"

# Process R packages (skip header)
if [ -f "$TMP_R_PACKAGES_TXT" ]; then
	header_skipped=false
	while IFS= read -r line; do
		if ! $header_skipped; then
			header_skipped=true
			continue
		fi
		if [[ "$line" == *github* ]]; then
			# Extract fields for install_github reproducibility
			pkg=$(echo -e "$line" | cut -f1)
			ver=$(echo -e "$line" | cut -f2)
			user=$(echo -e "$line" | cut -f6)
			repo=$(echo -e "$line" | cut -f5)
			sha=$(echo -e "$line" | cut -f8)
			# Compose path as username/repo/sha
			path="$user/$repo/$sha"
			pkgver="$pkg=$ver"
			echo -e "r-github\t$pkgver\tgithub\t$path" >> "$TMP_AGGREGATE"
		elif [[ "$line" == *Bioconductor* ]]; then
            # Bioconductor packages
            pkg=$(echo -e "$line" | cut -f1)
            ver=$(echo -e "$line" | cut -f2)
            src="Bioconductor"
            path=""
            pkgver="$pkg=$ver"
            echo -e "package-bioc\t$pkgver\t$src\t$path" >> "$TMP_AGGREGATE"
        else
			# R columns: Package\tVersion\tSource\tRemoteType\tRemoteRepo\tRemoteUsername\tRemoteRef\tRemoteSha
			pkg=$(echo -e "$line" | cut -f1)
			ver=$(echo -e "$line" | cut -f2)
			src=$(echo -e "$line" | cut -f3)
			path=$(echo -e "$line" | cut -f8)
			# Set to blank if NA
			[[ "$ver" == "NA" ]] && ver=""
			[[ "$src" == "NA" ]] && src=""
			[[ "$path" == "NA" ]] && path=""
			pkgver="$pkg=$ver"
			echo -e "package-r\t$pkgver\t$src\t$path" >> "$TMP_AGGREGATE"
		fi
	done < "$TMP_R_PACKAGES_TXT"
fi

# Process pip freeze (skip lines containing 'file://')
while IFS= read -r line; do
	[[ "$line" == *file://* ]] && continue
	# pip freeze: pkg==ver or pkg @ git+url or pkg @ ...
    # clean line and conrinue of blanks
    line=$(echo "$line" | xargs)
    if [[ -z "$line" ]]; then
        continue
    fi

	if [[ "$line" == *" @ "* ]]; then
		pkg=$(echo "$line" | cut -d' ' -f1)
		src=$(echo "$line" | cut -d'@' -f2- | xargs)
		path="$src"
		if [[ "$src" == *git* ]]; then
			# If git, set version to 0 if not present, detect VCS host
			ver="0"
			# Detect host from URL
			vcs_host="github"
			if [[ "$src" == *gitlab* ]]; then
				vcs_host="gitlab"
			elif [[ "$src" == *bitbucket* ]]; then
				vcs_host="bitbucket"
			elif [[ "$src" == *sourcehut* ]]; then
				vcs_host="sourcehut"
			elif [[ "$src" == *azure* ]]; then
				vcs_host="azure"
			fi
			if [[ -z "$ver" || "$ver" == "0" ]]; then
				pkgver="$pkg"
			else
				pkgver="$pkg=$ver"
			fi
			echo -e "pip\t$pkgver\t$vcs_host\t$path" >> "$TMP_AGGREGATE"
		else
			ver=""
			pkgver="$pkg=$ver"
			echo -e "pip\t$pkgver\t$src\t$path" >> "$TMP_AGGREGATE"
		fi
	else
		pkg=$(echo "$line" | cut -d'=' -f1)
		ver=$(echo "$line" | cut -d'=' -f3)
		src="pypi"
		path=""
		pkgver="$pkg=$ver"
		echo -e "pip\t$pkgver\t$src\t$path" >> "$TMP_AGGREGATE"
	fi
done < "$TMP_PIP_FREEZE_TXT"

echo "[coble-capture] Interim aggregated package list at $TMP_AGGREGATE"

# Now take the file created and reorrange it nicely

# Sort to a new tmp file, do not overwrite input
sort -k1,1 -k2,2 "$TMP_AGGREGATE" > "$TMP_SORTED"

# Loop through the TMP file and build a list variable with r-conda base and python and then echo the list out after
R_BASE_VERSION=""
PYTHON_VERSION=""
while IFS=$'\t' read -r manager pkg src path; do
    if [[ "$manager" == "r-conda" && "$pkg" == base=* ]]; then
        R_BASE_VERSION="r-base=${pkg#base=}@$src"
    elif [[ "$manager" == "conda" && "$pkg" == python=* ]]; then
        PYTHON_VERSION="python=${pkg#python=}@$src"    
	fi
done < "$TMP_AGGREGATE"
echo "[coble-capture] Detected r-conda base version: $R_BASE_VERSION"
echo "[coble-capture] Detected conda python version: $PYTHON_VERSION"

# in the AGGREGATE_TXT file add the langaues to the top
{
	CAPTURE_DATE=$(date '+%Y-%m-%d')
	CAPTURE_TIME=$(date '+%H:%M:%S %Z')
	CAPTURE_USER=$(whoami)
	echo -e "# COBLE:capture, (c) ICR 2025"
	echo -e "# Capture date: $CAPTURE_DATE"
	echo -e "# Capture time: $CAPTURE_TIME"
	echo -e "# Captured by: $CAPTURE_USER"
	echo -e ""
	echo -e "coble:"
	echo -e ""
	echo -e "  - environment: $ENV_NAME"
	echo -e ""
	echo -e "channels:"
	echo -e "  - conda-forge"
	echo -e "  - bioconda"
	echo -e ""
	echo -e "languages:"
	if [[ -n "$R_BASE_VERSION" ]]; then
		echo -e "  - $R_BASE_VERSION"
	fi
	if [[ -n "$PYTHON_VERSION" ]]; then
		echo -e "  - $PYTHON_VERSION"
	fi
	echo -e ""
	echo -e "flags:"
	echo -e "  - dependencies: False"	
} > "$AGGREGATE_TXT"

# Now lloop through the sorted file and keep as a variable the current mananager
current_manager=""
header_skipped=false
declare -A seen_pkgver
my_find_list=()
while IFS=$'\t' read -r manager pkg src path; do
	if ! $header_skipped; then
		header_skipped=true
		continue
	fi
	# Deduplicate by pkgver (case-insensitive)
	pkgver_key="$(echo "$pkg" | tr '[:upper:]' '[:lower:]')"
	if [[ -n "${seen_pkgver[$pkgver_key]}" ]]; then
		continue
	fi
	seen_pkgver[$pkgver_key]=1
	if [[ "$manager" != "$current_manager" ]]; then
		# New manager section
		echo -e "" >> "$AGGREGATE_TXT"
		echo -e "$manager:" >> "$AGGREGATE_TXT"
		current_manager="$manager"
	fi
	# Skip packages that are system-related, start with an underscore, are System/Manual, or start with python=
	if [[ "$pkg" == _* ]] || \
	[[ "$pkg" =~ (linux|windows|osx|darwin|unix|system) ]] || \
	#[[ "$src" == *System/Manual* ]] || \
	[[ "$pkg" == *base=* ]] || \
	[[ "$pkg" == python=* ]]; then
		continue
	fi
	outline=""
	if [[ "$src" == "pypi" || "$src" == "CRAN" || "$src" == "Bioconductor" ]]; then
		echo -e "  - $pkg" >> "$AGGREGATE_TXT"
	elif [[ -n "$path" ]]; then
		echo -e "  - $pkg@$src@$path" >> "$AGGREGATE_TXT"
	elif [[ "$src" == "System/Manual" ]]; then        
        my_find_list+=("$pkg")
    else
		echo -e "  - $pkg@$src" >> "$AGGREGATE_TXT"
	fi
done < "$TMP_SORTED"

# Check if list has items and write out
if [[ ${#my_find_list[@]} -gt 0 ]]; then
    echo "" >> "$AGGREGATE_TXT"
    echo "find:" >> "$AGGREGATE_TXT"
    for pkg in "${my_find_list[@]}"; do
        echo "  - $pkg" >> "$AGGREGATE_TXT"
    done
fi



# Clean up temporary files
if [[ $KEEP_LOGS -eq 0 ]]; then
    echo "[coble-capture] Cleaning up temporary files..."
    rm -f "$TMP_CONDA_LIST_TXT" "$TMP_PIP_FREEZE_TXT" "$TMP_R_PACKAGES_TXT" "$TMP_AGGREGATE" "$TMP_SORTED"    
elif [[ $KEEP_LOGS -eq 1 ]]; then
    echo "[coble-capture] Temporary files retained for inspection:"
    echo "  $TMP_CONDA_LIST_TXT"
    echo "  $TMP_PIP_FREEZE_TXT"
    echo "  $TMP_R_PACKAGES_TXT"
    echo "  $TMP_SORTED"
    echo "  $TMP_AGGREGATE"    
fi

echo "[coble-capture] Capture complete. Output written to $AGGREGATE_TXT"


