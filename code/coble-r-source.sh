#!/usr/bin/env bash
#
# install_r_source.sh — Build R from source and install into a conda environment
#
# Prerequisites:
#   - System build dependencies installed (see install_r_deps.sh)
#   - An active conda environment (not base)
#
# Usage:
#   conda activate myenv
#   bash install_r_source.sh <version>
#
# Examples:
#   bash install_r_source.sh 3.6.0
#   bash install_r_source.sh 4.3.2
#   bash install_r_source.sh devel

set -euo pipefail

# ---- 0. Parse arguments ----
if [[ $# -lt 1 ]]; then
    echo "Usage: bash install_r_source.sh <R_VERSION>"
    echo "  e.g. bash install_r_source.sh 3.6.0"
    echo "       bash install_r_source.sh devel"
    exit 1
fi

R_VERSION="$1"
BUILD_DIR="/tmp/r-build-$$"

if [[ "${R_VERSION}" == "devel" ]]; then
    R_TARBALL="R-devel.tar.gz"
    R_URL="https://stat.ethz.ch/R/daily/R-devel.tar.gz"
    R_SRCDIR="R-devel"
else
    R_MAJOR="${R_VERSION%%.*}"
    R_TARBALL="R-${R_VERSION}.tar.gz"
    R_URL="https://cran.r-project.org/src/base/R-${R_MAJOR}/${R_TARBALL}"
    R_SRCDIR="R-${R_VERSION}"
fi

# ---- 1. Verify conda environment is active (and not base) ----
if [[ -z "${CONDA_PREFIX:-}" ]]; then
    echo "ERROR: No conda environment is active."
    echo "       Please run: conda activate <your-env>"
    exit 1
fi

if [[ -z "${CONDA_DEFAULT_ENV:-}" || "${CONDA_DEFAULT_ENV}" == "base" ]]; then
    echo "ERROR: You are in the 'base' conda environment."
    echo "       Please create and activate a dedicated environment:"
    echo "         conda create -n r-env"
    echo "         conda activate r-env"
    exit 1
fi

INSTALL_PREFIX="${CONDA_PREFIX}"

echo "==> Installing R ${R_VERSION} from source into conda env '${CONDA_DEFAULT_ENV}'"
echo "    CONDA_PREFIX: ${INSTALL_PREFIX}"
echo "    Download URL: ${R_URL}"
echo ""

# ---- 2. Strip conda directories from PATH ----
#
# Conda adds its own bin/ to PATH which contains tools like curl-config and
# pkg-config. These can conflict with system versions that R's configure
# expects. We strip conda paths so the build uses only system tools.
#
echo "==> Adjusting PATH to use system libraries for build..."
CLEAN_PATH=""
IFS=':' read -ra PATH_PARTS <<< "${PATH}"
for p in "${PATH_PARTS[@]}"; do
    if [[ "${p}" =~ (conda|miniforge|miniconda|anaconda) ]]; then
        echo "    Removing from PATH: ${p}"
        continue
    fi
    CLEAN_PATH="${CLEAN_PATH:+${CLEAN_PATH}:}${p}"
done
export PATH="${CLEAN_PATH}"
echo "    Build PATH: ${PATH}"
echo ""

# Clear conda-set library paths
unset PKG_CONFIG_PATH 2>/dev/null || true
unset LD_LIBRARY_PATH 2>/dev/null || true
unset DYLD_LIBRARY_PATH 2>/dev/null || true

# ---- 3. Determine number of CPU cores ----
if command -v nproc &>/dev/null; then
    NUM_CORES="$(nproc)"
elif command -v sysctl &>/dev/null; then
    NUM_CORES="$(sysctl -n hw.ncpu)"
else
    NUM_CORES=2
fi

# ---- 4. Download R source ----
echo "==> Downloading R ${R_VERSION}..."
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

if [[ ! -f "${R_TARBALL}" ]] || [[ "${R_VERSION}" == "devel" ]]; then
    wget -q "${R_URL}" -O "${R_TARBALL}" || {
        echo "ERROR: Failed to download R ${R_VERSION}."
        echo "       Check that version '${R_VERSION}' exists at:"
        echo "       ${R_URL}"
        rm -f "${R_TARBALL}"
        exit 1
    }
fi

# ---- 5. Extract ----
echo "==> Extracting..."
tar -xzf "${R_TARBALL}"
cd "${R_SRCDIR}"

# ---- 6. Patch configure for modern systems ----
#
# R versions before ~4.1 hardcode a check for libcurl version 7.x and reject
# curl 8.x, which is standard on modern Linux and macOS. Curl 8.x is fully
# backwards-compatible, so we patch the configure script to skip the check.
#
if grep -q "libcurl >= 7.22.0" configure; then
    echo "==> Patching configure to accept libcurl 8.x..."

    # Replace the fatal error line with a no-op so configure continues
    sed -i.bak '/libcurl >= 7.22.0 library and headers are required/c\    true  # patched: curl 8.x accepted' configure

    # Verify the patch applied
    if grep -q "curl 8.x accepted" configure; then
        echo "    Patch applied successfully."
    else
        echo "    WARNING: Patch may not have applied."
        grep -n "7.22.0" configure
    fi
    echo ""
fi

# ---- 7. Configure ----
#
# GCC 10+ defaults to -fno-common, which causes "multiple definition" linker
# errors in R versions before ~4.0. Adding -fcommon restores the old behavior.
#
# gfortran 10+ is stricter about argument type/rank mismatches in Fortran code.
# Adding -fallow-argument-mismatch restores the old permissive behavior.
#
echo "==> Configuring..."
export CFLAGS="${CFLAGS:-} -fcommon"
export FFLAGS="${FFLAGS:-} -fallow-argument-mismatch"
export FCFLAGS="${FCFLAGS:-} -fallow-argument-mismatch"
./configure \
    --prefix="${INSTALL_PREFIX}" \
    --enable-R-shlib \
    --enable-memory-profiling \
    --with-blas \
    --with-lapack \
    --with-readline \
    --with-x=no \
    --with-recommended-packages=yes

# ---- 8. Build ----
echo "==> Building (using ${NUM_CORES} cores)..."
make -j"${NUM_CORES}"

# ---- 9. Install ----
echo "==> Installing into ${INSTALL_PREFIX}..."
make install

# ---- 10. Verify ----
echo ""
echo "==> Installation complete!"
"${INSTALL_PREFIX}/bin/R" --version | head -1

# ---- 11. Clean up ----
echo "==> Cleaning up build directory..."
rm -rf "${BUILD_DIR}"
# Clean up stray files that break sub-architecture detection
find "$CONDA_PREFIX/lib/R/bin/exec" -name '*~' -delete 2>/dev/null || true

echo ""
echo "Done! R ${R_VERSION} is installed at: ${INSTALL_PREFIX}/bin/R"
echo "It will be available whenever the '${CONDA_DEFAULT_ENV}' conda environment is active."