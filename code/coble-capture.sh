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


# Usage: ./coble-capture.sh [results_dir]

echo "Capturing conda environment to $RESULTS_DIR"

# Define output filenames
RESULTS_DIR="${1:-.}"
mkdir -p "$RESULTS_DIR"
CONDA_LIST_TXT="$RESULTS_DIR/cap-conda-packages.txt"
PIP_FREEZE_TXT="$RESULTS_DIR/cap-pip-freeze.txt"
R_PACKAGES_TXT="$RESULTS_DIR/cap-r-packages.txt"

AGGREGATE_TMP="$RESULTS_DIR/coble-capture.tmp"
AGGREGATE_TXT="$RESULTS_DIR/coble-capture.yml"

echo "Capturing conda environment to $RESULTS_DIR"

# List all conda packages
conda list > "$CONDA_LIST_TXT"

# Capture pip freeze output for provenance (e.g., GitHub installs)
python -m pip freeze > "$PIP_FREEZE_TXT"

# List all R packages with version and source
if command -v Rscript &>/dev/null; then
	Rscript -e '
		ip <- as.data.frame(installed.packages()[, c("Package", "Version", "LibPath")])
		fields <- c("Source", "RemoteType", "RemoteRepo", "RemoteUsername", "RemoteRef", "RemoteSha")
		get_info <- function(pkg, lib) {
		  desc_file <- file.path(lib, pkg, "DESCRIPTION")
		  info <- setNames(rep(NA_character_, length(fields)), fields)
		  if (file.exists(desc_file)) {
			desc <- tryCatch(read.dcf(desc_file), error=function(e) NULL)
			if (!is.null(desc)) {
			  info["Source"] <- if ("Repository" %in% colnames(desc)) desc[1, "Repository"] else "System/Manual"
			  for (f in fields[-1]) if (f %in% colnames(desc)) info[f] <- desc[1, f]
			}
		  } else {
			info["Source"] <- "System/Manual"
		  }
		  info
		}
		if (nrow(ip) > 0) {
		  infos <- t(mapply(get_info, ip$Package, ip$LibPath, SIMPLIFY=TRUE))
		  ip <- cbind(ip, as.data.frame(infos, stringsAsFactors=FALSE))
		  write.table(ip[, c("Package", "Version", fields)], file="'$R_PACKAGES_TXT'", row.names=FALSE, sep="\t", quote=FALSE)
		} else {
		  write.table(data.frame(Package=character(), Version=character(), Source=character(),
							 RemoteType=character(), RemoteRepo=character(), RemoteUsername=character(),
							 RemoteRef=character(), RemoteSha=character()),
					  file="'$R_PACKAGES_TXT'", row.names=FALSE, sep="\t", quote=FALSE)
		}
	'
else
	echo -e "Rscript not found in environment" > "$R_PACKAGES_TXT"
fi


# Clear the aggregate file at the start
> "$AGGREGATE_TMP"
> "$AGGREGATE_TXT"

# Write header (combine package and version)
echo -e "Manager\tPackage\tSource\tPath" > "$AGGREGATE_TMP"

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
		manager="conda-r"
		pkg_no_r=${pkg#r-}
		pkgver="$pkg_no_r=$ver"
		echo -e "$manager\t$pkgver\t$src\t" >> "$AGGREGATE_TMP"
	else
			# Only add =version if version is not blank or 0
			if [[ -z "$ver" || "$ver" == "0" ]]; then
				pkgver="$pkg"
			else
				pkgver="$pkg=$ver"
			fi
		echo -e "conda\t$pkgver\t$src\t" >> "$AGGREGATE_TMP"
	fi
done < "$CONDA_LIST_TXT"

# Process R packages (skip header)
if [ -f "$R_PACKAGES_TXT" ]; then
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
			echo -e "r-github\t$pkgver\tgithub\t$path" >> "$AGGREGATE_TMP"
		elif [[ "$line" == *Bioconductor* ]]; then
            # Bioconductor packages
            pkg=$(echo -e "$line" | cut -f1)
            ver=$(echo -e "$line" | cut -f2)
            src="Bioconductor"
            path=""
            pkgver="$pkg=$ver"
            echo -e "package-bioc\t$pkgver\t$src\t$path" >> "$AGGREGATE_TMP"
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
			echo -e "package-r\t$pkgver\t$src\t$path" >> "$AGGREGATE_TMP"
		fi
	done < "$R_PACKAGES_TXT"
fi

# Process pip freeze (skip lines containing 'file://')
while IFS= read -r line; do
	[[ "$line" == *file://* ]] && continue
	# pip freeze: pkg==ver or pkg @ git+url or pkg @ ...
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
			echo -e "pip\t$pkgver\t$vcs_host\t$path" >> "$AGGREGATE_TMP"
		else
			ver=""
			pkgver="$pkg=$ver"
			echo -e "pip\t$pkgver\t$src\t$path" >> "$AGGREGATE_TMP"
		fi
	else
		pkg=$(echo "$line" | cut -d'=' -f1)
		ver=$(echo "$line" | cut -d'=' -f3)
		src="pypi"
		path=""
		pkgver="$pkg=$ver"
		echo -e "pip\t$pkgver\t$src\t$path" >> "$AGGREGATE_TMP"
	fi
done < "$PIP_FREEZE_TXT"

echo "Interim aggregated package list at $AGGREGATE_TMP"

# Now take the file created and reorrange it nicely

# Sort to a new tmp file, do not overwrite input
TMP_SORTED="$RESULTS_DIR/coble-capture-sorted.tmp"
sort -k1,1 -k2,2 "$AGGREGATE_TMP" > "$TMP_SORTED"

# Loop through the TMP file and build a list variable with r-conda base and python and then echo the list out after
R_BASE_VERSION=""
PYTHON_VERSION=""
while IFS=$'\t' read -r manager pkg src path; do
    if [[ "$manager" == "conda-r" && "$pkg" == base=* ]]; then
        R_BASE_VERSION="r-base=${pkg#base=}"
    elif [[ "$manager" == "conda" && "$pkg" == python=* ]]; then
        PYTHON_VERSION="python=${pkg#python=}"
    fi
done < "$AGGREGATE_TMP"
echo "Detected r-conda base version: $R_BASE_VERSION"
echo "Detected conda python version: $PYTHON_VERSION"

# in the AGGREGATE_TXT file add the langaues to the top
{
    echo -e "#COBLE:Reproducible environment capture, (c) ICR 2025"
    echo -e ""
    echo -e "coble:"
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
} > "$AGGREGATE_TXT"

# Now lloop through the sorted file and keep as a variable the current mananager
current_manager=""
header_skipped=false
while IFS=$'\t' read -r manager pkg src path; do
	if ! $header_skipped; then
		header_skipped=true
		continue
	fi
	if [[ "$manager" != "$current_manager" ]]; then
		# New manager section
		echo -e "" >> "$AGGREGATE_TXT"
		echo -e "$manager:" >> "$AGGREGATE_TXT"
		current_manager="$manager"
	fi
	# Skip packages that are system-related, start with an underscore, are System/Manual, or start with python=
	if [[ "$pkg" == _* ]] || [[ "$pkg" =~ (linux|windows|osx|darwin|unix|system) ]] || [[ "$src" == *System/Manual* ]] || [[ "$pkg" == python=* ]]; then
		continue
	fi
	outline=""
	if [[ "$src" == "pypi" || "$src" == "CRAN" || "$src" == "Bioconductor" ]]; then
		echo -e "  - $pkg" >> "$AGGREGATE_TXT"
	elif [[ -n "$path" ]]; then
		echo -e "  - $pkg@$src@$path" >> "$AGGREGATE_TXT"
	else
		echo -e "  - $pkg@$src" >> "$AGGREGATE_TXT"
	fi
done < "$TMP_SORTED"



