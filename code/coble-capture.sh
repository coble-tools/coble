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
DRY_RUN=false

show_help() {
	echo "Usage: $0 --frozen <recipe_file> [--env ENV]"
	echo "  --frozen  RECIPE  Specify output recipe file (optional, default: ./coble-reciped-reproduce.sh)"
	echo "  --env     ENV      Specify conda environment name or prefix (optional, default is current activated environment)"
    echo "  --debug   Keep interim logs for debugging (optional)"
	echo "  --dry-run Show the commands that would be run without executing them"
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
		--frozen)
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

echo "[coble-freeze] Running: conda list $ENV_FORMATTED" >&2
conda list $ENV_FORMATTED --show-channel-urls> "$TMP_CONDA_LIST_TXT"

# Capture pip freeze output for provenance (e.g., GitHub installs)

#echo "[coble-capture] Running: conda run $ENV_FORMATTED python -m pip freeze > $TMP_PIP_FREEZE_TXT"
echo "[coble-freeze] Running: conda run $ENV_FORMATTED python -m pip freeze | grep -v '@ file:///home/conda/feedstock_root/build_artifacts/' > $TMP_PIP_FREEZE_TXT"

if conda run $ENV_FORMATTED python --version &> /dev/null 2>&1; then
    #conda run $ENV_FORMATTED python -m pip freeze > "$TMP_PIP_FREEZE_TXT"
    conda run $ENV_FORMATTED conda run $ENV_FORMATTED python -m pip freeze | grep -v '@ file:///home/conda/feedstock_root/build_artifacts/' > "$TMP_PIP_FREEZE_TXT"
else
    echo "Python not available in conda environment"
fi

# List all R packages with version and source
echo "[coble-freeze] Running: conda run $ENV_FORMATTED Rscript ... > $TMP_R_PACKAGES_TXT"
# if Rscript is in the environment, run the Rscript to get package info
if ! conda run $ENV_FORMATTED Rscript --version &> /dev/null 2>&1; then
	echo "    R is not available in conda environment" >&2
else
	RSCRIPT="$script_dir/coble-capture-r.R"
	if conda run $ENV_FORMATTED Rscript "$RSCRIPT" "$TMP_R_PACKAGES_TXT"; then
        echo "R script completed successfully"
    else
        echo "Rscript not found in environment" > "$TMP_R_PACKAGES_TXT"
    fi
fi

# Clear the aggregate file at the start
echo "[coble-freeze] Aggregating package lists into $AGGREGATE_TXT" >&2
:> "$TMP_AGGREGATE"
:> "$AGGREGATE_TXT"

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
if [ -f "$TMP_R_PACKAGES_TXT" ]; then # && [ $HAS_R -eq 1 ]; then
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
            echo -e "bioc-package\t$pkgver\t$src\t$path" >> "$TMP_AGGREGATE"
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
			echo -e "r-package\t$pkgver\t$src\t$path" >> "$TMP_AGGREGATE"
		fi
	done < "$TMP_R_PACKAGES_TXT"
fi

# Process pip freeze (skip lines containing 'file://')
# if the file exsits
if [ -f "$TMP_PIP_FREEZE_TXT" ]; then
	while IFS= read -r line; do
		[[ "$line" == *file://* ]] && continue
		[[ "$line" == *feedstock_root* ]] && continue
		[[ "$line" == *build_artifacts* ]] && continue
		# pip freeze: pkg==ver or pkg @ git+url or pkg @ ...
		line=$(echo "$line" | xargs)
		if [[ -z "$line" ]]; then
			continue
		fi

		if [[ "$line" == *" @ "* ]]; then
			pkg=$(echo "$line" | cut -d' ' -f1)
			src=$(echo "$line" | cut -d'@' -f2- | xargs)
			path="$src"
			if [[ "$src" == *git* ]]; then
				ver="0"
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
				path_branch_or_commit="$src"
				echo -e "pip\t$path\t$path_branch_or_commit\t" >> "$TMP_AGGREGATE"
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
			pkgver="$pkg==$ver"
			echo -e "pip\t$pkgver\t$src\t$path" >> "$TMP_AGGREGATE"
		fi
	done < "$TMP_PIP_FREEZE_TXT"
fi

echo "[coble-freeze] Interim aggregated package list at $TMP_AGGREGATE"

# Now take the file created and rearrange it nicely

# Sort to a new tmp file, do not overwrite input
# I want to sort with a specific order to the managers: conda, r-conda, bioc-conda, r-github, r-package, bioc-package, pip
# To do this, I will add a prefix number to each manager for sorting, then remove it after sorting
awk 'BEGIN {OFS="\t"}
    {
        prefix = "";
        if ($1 == "Manager") prefix = "1_";
        if ($1 == "conda") prefix = "2_";
        else if ($1 == "r-conda") prefix = "3_";
        else if ($1 == "bioc-conda") prefix = "4_";
        else if ($1 == "r-package") prefix = "5_";
        else if ($1 == "bioc-package") prefix = "6_";
        else if ($1 == "r-github") prefix = "7_";
        else if ($1 == "pip") prefix = "8_";
        print prefix $0;
    }' "$TMP_AGGREGATE" | sort -k1,1 -k2,2 | sed 's/^[0-9]_//' > "$TMP_SORTED1"

#(head -1 "$TMP_SORTED1"; tail -n +2 "$TMP_SORTED1" | grep "^conda\s" | grep -E "(icu|zlib|gcc|gxx|binutils|libc|libgcc|libstdcxx)"; tail -n +2 "$TMP_SORTED1" | grep -v -E "^conda\s.*(icu|zlib|gcc|gxx|binutils|libc|libgcc|libstdcxx)") > "$TMP_SORTED"

# Deduplicate assuming priority order top to bottom, and bring critical system libs to the top
(
  head -1 "$TMP_SORTED1"
  # Critical system libs first
  tail -n +2 "$TMP_SORTED1" | grep "^conda\s" | grep -E "(icu|zlib|gcc|gxx|binutils|libc|libgcc|libstdcxx)"
  # All other conda packages
  tail -n +2 "$TMP_SORTED1" | grep -E "^(conda|r-conda|bioc-conda)"
  # everything else
  tail -n +2 "$TMP_SORTED1" | grep -v -E "^(conda|r-conda|bioc-conda)"
) | awk -F'\t' 'NR==1 {print; next} {split($2, p, "="); pkg=tolower(p[1]); if (!seen[pkg]++) print}' > "$TMP_SORTED"

# Loop through the TMP file and build a list variable with r-conda base and python and then echo the list out after
R_BASE_VERSION=""
PYTHON_VERSION=""
COMPILE_VERSION=""
echo "[coble-freeze] Detecting R and Python base versions from $TMP_AGGREGATE ..." >&2
while IFS=$'\t' read -r manager pkg src path; do
    #echo "[coble-freeze] Checking package: $manager | $pkg | $src"
    if [[ "$manager" == "r-conda" && "$pkg" == base=* ]]; then
        R_BASE_VERSION="r-base=${pkg#base=}@$src"
        HAS_R=1
        echo "[coble-freeze] R detected in environment."
    elif [[ "$manager" == "conda" && "$pkg" == python=* ]]; then
        PYTHON_VERSION="python=${pkg#python=}@$src"
        echo "[coble-freeze] Python detected in environment."
	elif [[ "$manager" == "conda" && ( "$pkg" == "gcc="* || "$pkg" == "gxx="* ) ]]; then
        COMPILE_VERSION="${pkg#*=}"
        echo "[coble-freeze] Compile tools detected in environment."
    fi
done < "$TMP_AGGREGATE"
echo "[coble-freeze] Detected r-conda base version: $R_BASE_VERSION" >&2
echo "[coble-freeze] Detected conda python version: $PYTHON_VERSION" >&2
# in the AGGREGATE_TXT file add the languages to the top
{
	CAPTURE_DATE=$(date '+%Y-%m-%d')
	CAPTURE_TIME=$(date '+%H:%M:%S %Z')
	CAPTURE_USER=$(whoami)
	echo -e "# COBLE:capture, (c) ICR 2026"
	echo -e "# Capture date: $CAPTURE_DATE"
	echo -e "# Capture time: $CAPTURE_TIME"
	echo -e "# Captured by: $CAPTURE_USER"
	echo -e ""
	echo -e "coble:"
	echo -e ""
	echo -e "  - environment: $ENV_NAME"
	echo -e ""
	echo -e "channels:"
    conda config --show channels $ENV_FORMATTED | grep -E '^\s*-\s' | sed 's/^\s*-\s*//' | tac | while read -r channel; do
        echo "  - $channel"
    done
	#echo -e "  - defaults"
	#echo -e "  - r"
	#echo -e "  - bioconda"
	#echo -e "  - conda-forge"
	echo -e ""
	#echo -e "flags:"
	#echo -e "  - compile-tools: true"
	#echo -e "  - dependencies: false"
    #echo -e "  - priority: flexible"
    #echo -e ""
	echo -e "languages:"
    #echo -e "  - no-deps"
	if [[ -n "$R_BASE_VERSION" ]]; then
		echo -e "  - $R_BASE_VERSION"
	fi
	if [[ -n "$PYTHON_VERSION" ]]; then
		echo -e "  - $PYTHON_VERSION"
	fi
    # Get env vars and format for YAML
	echo -e "flags:"
	echo -e "  - compile-tools: true"
	echo -e "  - dependencies: false"
    echo -e "  - priority: flexible"
	conda env config vars list | grep -E '^\w+\s*=' | sed 's/\s*=\s*/=/' | sort | while IFS='=' read -r key value; do
    	# don't want to repat any of the settings that are the compiler tools we set elsewhere
		not_key=("CC" "CXX" "LD" "FC" "F77" "CFLAGS" "CXXFLAGS" "CPPFLAGS" "LDFLAGS")
		if [[ ! " ${not_key[@]} " =~ " ${key} " ]]; then
			echo "  - export: $key=\"$value\""
		fi
	done
    #if [[ -n "$COMPILE_VERSION" ]]; then
    #    echo -e "  - compile-tools: $COMPILE_VERSION"
    #fi
} > "$AGGREGATE_TXT"

# Now loop through the sorted file and keep as a variable the current mananager
current_manager=""
current_channel=""
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
	# Skip packages that are system-related, start with an underscore, are System/Manual, or start with python=
    if [[ "$pkg" == _* ]] || \
	[[ "$pkg" =~ (windows|osx|darwin|unix|system) ]] || \
	#[[ "$src" == *System/Manual* ]] || \
	[[ "$pkg" == *base=* ]] || \
	[[ "$pkg" == python=* ]]; then
		continue
	fi
    if [[  "$src" != "$current_channel"  && "$src" != *"unknown"*  ]]; then
        current_channel="$src"
    #	# New manager/channel section
		echo -e "" >> "$AGGREGATE_TXT"
		#echo -e "flags:" >> "$AGGREGATE_TXT"
        #echo -e "  - channel: $src" >> "$AGGREGATE_TXT"
		echo -e "$manager:" >> "$AGGREGATE_TXT"
		current_manager="$manager"
    elif [[ "$manager" != "$current_manager" ]]; then
		# New manager section
        echo "new manager: $manager"
		echo -e "" >> "$AGGREGATE_TXT"
        echo -e "$manager:" >> "$AGGREGATE_TXT"
		current_manager="$manager"
	fi
	if [[ "$manager" == "r-conda" || "$manager" == "bioc-conda" || "$manager" == "r-package" || "$manager" == "bioc-package" ]]; then
        if [[ HAS_R -eq 0 ]]; then
		    continue
		fi
    fi
	outline=""
    if [[ "$src" == "pypi" || "$src" == "CRAN" || "$src" == "Bioconductor" || "$src" == "pip" ]]; then
		echo -e "  - $pkg" >> "$AGGREGATE_TXT"
	elif [[ -n "$path" ]]; then
		echo -e "  - $pkg@$src@$path" >> "$AGGREGATE_TXT"
	elif [[ "$src" == *"System/Manual"* ]]; then
        my_find_list+=("$pkg")
    else
		echo -e "  - $pkg@$src" >> "$AGGREGATE_TXT"
	fi
done < "$TMP_SORTED"

# Check if list has items and write out
if [[ ${#my_find_list[@]} -gt 0 ]]; then
    echo "" >> "$AGGREGATE_TXT"
    echo "# r-package(unknown source):" >> "$AGGREGATE_TXT"
    for pkg in "${my_find_list[@]}"; do
        echo "#  - $pkg" >> "$AGGREGATE_TXT"
    done
fi

echo "[coble-freeze] Final aggregated package list at $AGGREGATE_TXT" >&2


# Clean up temporary files
if [[ $KEEP_LOGS -eq 0 ]]; then
    echo "[coble-freeze] Cleaning up temporary files..."
    rm -f "$TMP_CONDA_LIST_TXT" "$TMP_PIP_FREEZE_TXT" "$TMP_R_PACKAGES_TXT" "$TMP_AGGREGATE" "$TMP_SORTED1" "$TMP_SORTED"
elif [[ $KEEP_LOGS -eq 1 ]]; then
    echo "[coble-freeze] Temporary files retained for inspection:" >&2
    echo "  $TMP_CONDA_LIST_TXT" >&2
    echo "  $TMP_PIP_FREEZE_TXT" >&2
    echo "  $TMP_R_PACKAGES_TXT" >&2
    echo "  $TMP_SORTED1" >&2
    echo "  $TMP_SORTED" >&2
    echo "  $TMP_AGGREGATE" >&2
fi

echo "[coble-freeze] Freeze complete. Output written to $AGGREGATE_TXT" >&2
echo "[coble] To activate environment call:" >&2
echo "        conda activate $ENV_INPUT" >&2


