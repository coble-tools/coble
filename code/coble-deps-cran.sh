#!/usr/bin/env bash
#
# Usage: code/coble-deps-cran.sh <package> <version> <logfile>
# Example: code/coble-deps-cran.sh testthat 2.3.2 deps.log
#
# Fetches the DESCRIPTION file from the CRAN archive for the given
# package and version, extracts dependencies, and writes them to the log file.

set -euo pipefail

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <package> <version> <logfile>"
    echo "Example: $0 testthat 2.3.2 deps.log"
    exit 1
fi

PKG="$1"
VER="$2"
LOGFILE="$3"

CRAN_BASE="https://cran.r-project.org/src/contrib"
CRAN_ARCHIVE="$CRAN_BASE/Archive"
TARBALL="${PKG}_${VER}.tar.gz"
TMPDIR=$(mktemp -d)

trap "rm -rf $TMPDIR" EXIT

# Try archive first, then current CRAN
URL="$CRAN_ARCHIVE/$PKG/$TARBALL"
HTTP_CODE=$(curl -sL -o /dev/null -w "%{http_code}" "$URL")

if [ "$HTTP_CODE" != "200" ]; then
    URL="$CRAN_BASE/$TARBALL"
    HTTP_CODE=$(curl -sL -o /dev/null -w "%{http_code}" "$URL")
fi

if [ "$HTTP_CODE" != "200" ]; then
    echo "ERROR: Could not find $PKG version $VER on CRAN"
    exit 1
fi

echo "Found: $URL"

# Download and extract just the DESCRIPTION file
curl -sL "$URL" -o "$TMPDIR/$TARBALL"
tar -xzf "$TMPDIR/$TARBALL" -C "$TMPDIR" "$PKG/DESCRIPTION"

DESC="$TMPDIR/$PKG/DESCRIPTION"

# Unfold continuation lines into single lines
UNFOLDED=$(awk '
    /^[^ \t]/ { if (buf != "") print buf; buf = $0; next }
    /^[ \t]/  { buf = buf $0; next }
    END       { if (buf != "") print buf }
' "$DESC")

# Write header
{
    echo "# Dependencies for $PKG $VER"
    echo "# Source: $URL"
    echo "# Date: $(date -u +%Y-%m-%d)"
    echo ""
} > "$LOGFILE"

# Extract and log both Depends and Imports
for field in Depends Imports; do
    VALS=$(echo "$UNFOLDED" | grep -P "^${field}:" | sed "s/^${field}:\s*//" || true)

    if [ -z "$VALS" ]; then
        continue
    fi

    echo "## $field" >> "$LOGFILE"
    echo "$VALS" | tr ',' '\n' | sed 's/^[ \t]*//;s/[ \t]*$//' | while IFS= read -r dep; do
        [ -z "$dep" ] && continue
        echo "  $dep" >> "$LOGFILE"
    done
    echo "" >> "$LOGFILE"
done

echo "Dependencies written to: $LOGFILE"
echo ""
cat "$LOGFILE"
set -euo pipefail

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <package> <version> <logfile>"
    echo "Example: $0 testthat 2.3.2 deps.log"
    exit 1
fi

PKG="$1"
VER="$2"
LOGFILE="$3"

CRAN_BASE="https://cran.r-project.org/src/contrib"
CRAN_ARCHIVE="$CRAN_BASE/Archive"
TARBALL="${PKG}_${VER}.tar.gz"
TMPDIR=$(mktemp -d)

trap "rm -rf $TMPDIR" EXIT

# Try archive first, then current CRAN
URL="$CRAN_ARCHIVE/$PKG/$TARBALL"
HTTP_CODE=$(curl -sL -o /dev/null -w "%{http_code}" "$URL")

if [ "$HTTP_CODE" != "200" ]; then
    URL="$CRAN_BASE/$TARBALL"
    HTTP_CODE=$(curl -sL -o /dev/null -w "%{http_code}" "$URL")
fi

if [ "$HTTP_CODE" != "200" ]; then
    echo "ERROR: Could not find $PKG version $VER on CRAN"
    exit 1
fi

echo "Found: $URL"

# Download and extract just the DESCRIPTION file
curl -sL "$URL" -o "$TMPDIR/$TARBALL"
tar -xzf "$TMPDIR/$TARBALL" -C "$TMPDIR" "$PKG/DESCRIPTION"

DESC="$TMPDIR/$PKG/DESCRIPTION"

# Write header to log
{
    echo "# Dependencies for $PKG $VER"
    echo "# Source: $URL"
    echo "# Date: $(date -u +%Y-%m-%d)"
    echo ""
} > "$LOGFILE"

# Extract Depends, Imports, LinkingTo fields (they can span multiple lines)
# We unfold continuation lines first, then extract the fields
awk '
    /^[^ \t]/ { if (buf != "") print buf; buf = $0; next }
    /^[ \t]/  { buf = buf $0; next }
    END       { if (buf != "") print buf }
' "$DESC" | while IFS= read -r line; do
    for field in Depends Imports LinkingTo Suggests; do
        if echo "$line" | grep -qP "^${field}:"; then
            echo "## $field" >> "$LOGFILE"
            # Extract the value, split on commas, trim, one per line
            echo "$line" \
                | sed "s/^${field}:\s*//" \
                | tr ',' '\n' \
                | sed 's/^[ \t]*//;s/[ \t]*$//' \
                | while IFS= read -r dep; do
                    [ -z "$dep" ] && continue
                    echo "  $dep" >> "$LOGFILE"
                done
            echo "" >> "$LOGFILE"
        fi
    done
done

echo "Dependencies written to: $LOGFILE"
echo ""
cat "$LOGFILE"