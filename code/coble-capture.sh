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
AGGREGATE_TXT="$RESULTS_DIR/coble-capture.txt"

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
		manager="r-conda"
		pkg_no_r=${pkg#r-}
		pkgver="$pkg_no_r=$ver"
		echo -e "$manager\t$pkgver\t$src\t" >> "$AGGREGATE_TMP"
	else
		pkgver="$pkg=$ver"
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
		else
			# R columns: Package\tVersion\tSource\tRemoteType\tRemoteRepo\tRemoteUsername\tRemoteRef\tRemoteSha
			pkg=$(echo -e "$line" | cut -f1)
			ver=$(echo -e "$line" | cut -f2)
			src=$(echo -e "$line" | cut -f3)
			path=$(echo -e "$line" | cut -f8)
			pkgver="$pkg=$ver"
			echo -e "r-package\t$pkgver\t$src\t$path" >> "$AGGREGATE_TMP"
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
			# If git, set version to 0 if not present, source to github
			ver="0"
			pkgver="$pkg=$ver"
			echo -e "pip\t$pkgver\tgithub\t$path" >> "$AGGREGATE_TMP"
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
sort -k1,1 -k2,2 "$AGGREGATE_TMP" > "$AGGREGATE_TXT"

# Move the first occurrence of r-conda base and conda python to the top as 'language' entries, but only if not already present
TMP_LANGS="$RESULTS_DIR/coble-capture-langs.txt"
TMP_OTHER="$RESULTS_DIR/coble-capture-other.txt"
found_r=0
found_py=0
has_r=0
has_py=0
# Check if language lines already exist
if grep -q -P '^language\tr-base=' "$AGGREGATE_TXT"; then has_r=1; fi
if grep -q -P '^language\tpython=' "$AGGREGATE_TXT"; then has_py=1; fi
head -n1 "$AGGREGATE_TXT" > "$TMP_LANGS"  # Copy header
tail -n +2 "$AGGREGATE_TXT" | while IFS=$'\t' read -r manager pkg src path; do
	if [[ "$manager" == "r-conda" && "$pkg" == base=* && $found_r -eq 0 && $has_r -eq 0 ]]; then
		echo -e "language\tr-base=${pkg#base=}\t\t" >> "$TMP_LANGS"
		found_r=1
		continue
	fi
	if [[ "$manager" == "conda" && "$pkg" == python=* && $found_py -eq 0 && $has_py -eq 0 ]]; then
		echo -e "language\tpython=${pkg#python=}\t\t" >> "$TMP_LANGS"
		found_py=1
		continue
	fi
	# Skip any subsequent r-conda base or conda python
	if [[ ("$manager" == "r-conda" && "$pkg" == base=*) || ("$manager" == "conda" && "$pkg" == python=*) ]]; then
		continue
	fi
	echo -e "$manager\t$pkg\t$src\t$path" >> "$TMP_OTHER"
done
tail -n +2 "$TMP_LANGS" > "$TMP_LANGS.body"
cat "$TMP_LANGS" "$TMP_LANGS.body" "$TMP_OTHER" > "$AGGREGATE_TXT.new"
mv "$AGGREGATE_TXT.new" "$AGGREGATE_TXT"
rm -f "$TMP_LANGS" "$TMP_LANGS.body" "$TMP_OTHER"



