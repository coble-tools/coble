#!/usr/bin/env bash

# At the start of the recipise function
# In your recipise function:

## Ensure all conda paths are set to base
# Find conda executable (works even before sourcing conda.sh)
CONDA_EXECUTABLE=$(which conda 2>/dev/null || command -v conda 2>/dev/null)
if [ -z "$CONDA_EXECUTABLE" ]; then
    echo "Error: conda not found in PATH"
    exit 1
fi
CONDA_BASE=$(dirname $(dirname $CONDA_EXECUTABLE))
# Source conda.sh to enable shell functions
source "${CONDA_BASE}/etc/profile.d/conda.sh"
# NOW deactivate
MAX_DEACTIVATIONS=5
count=0
while [ -n "$CONDA_DEFAULT_ENV" ] && [ "$CONDA_DEFAULT_ENV" != "base" ] && [ $count -lt $MAX_DEACTIVATIONS ]; do
    echo "Deactivating from: $CONDA_DEFAULT_ENV (attempt $((count+1)))" >&2
    conda deactivate 2>/dev/null || true
    ((count++))
done
# Capture conda paths ONCE here
CONDA_EXE=$(which conda)
CONDA_ALIAS="${CONDA_EXE}"

echo "#####################################################################" >&2
echo "[coble-recipise] CONDA executable: $CONDA_EXECUTABLE" >&2
echo "[coble-recipise] CONDA base: $CONDA_BASE" >&2
echo "[coble-recipise] CONDA exe: $CONDA_EXE" >&2
echo "[coble-recipise] CONDA alias: $CONDA_ALIAS" >&2
echo "#####################################################################" >&2

# Turn a captured yaml file into a coble recipe script
# CROSS-PLATFORM VERSION - supports Linux AMD64, Linux ARM64, macOS Intel, macOS ARM64
# BASH 3.2 COMPATIBLE - works on macOS default bash and modern Linux bash

##############
# Platform detection function
##############
detect_platform() {
    local os_type=""
    local arch=""
    local platform_string=""
    local compiler_prefix=""
    
    # Detect OS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        os_type="osx"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        os_type="linux"
    else
         # Fallback to uname if OSTYPE not set
        uname_s=$(uname -s)
        if [[ "$uname_s" == "Darwin" ]]; then
            os_type="osx"
        elif [[ "$uname_s" == "Linux" ]]; then
            os_type="linux"  # ✓ Works now!
        fi
    fi
    
    # Detect architecture
    arch=$(uname -m)
    if [[ "$arch" == "x86_64" || "$arch" == "amd64" ]]; then
        arch="x86_64"
        if [[ "$os_type" == "linux" ]]; then
            platform_string="linux-64"
            compiler_prefix="x86_64-conda-linux-gnu"
        elif [[ "$os_type" == "osx" ]]; then
            platform_string="osx-64"
            compiler_prefix="x86_64-apple-darwin"
        fi
    elif [[ "$arch" == "arm64" || "$arch" == "aarch64" ]]; then
        arch="arm64"
        if [[ "$os_type" == "linux" ]]; then
            platform_string="linux-aarch64"
            compiler_prefix="aarch64-conda-linux-gnu"
        elif [[ "$os_type" == "osx" ]]; then
            platform_string="osx-arm64"
            compiler_prefix="arm64-apple-darwin"
        fi
    fi
    
    echo "$os_type|$arch|$platform_string|$compiler_prefix"
}



##############
# Portable sed in-place editing (macOS/BSD vs GNU)
##############
sed_inplace() {
    local pattern="$1"
    local file="$2"
    if [[ "$OSTYPE" == "darwin"* ]] || [[ "$(uname)" == "Darwin" ]]; then
        sed -i '' "$pattern" "$file"
    else
        sed -i "$pattern" "$file"
    fi
}

##############
# Get compiler packages for platform
##############
get_compiler_packages() {
    local platform="$1"
    case "$platform" in
        "linux-64"|"linux/amd64")
            echo "gcc_linux-64 gxx_linux-64 gfortran_linux-64"            
            ;;
        "linux-aarch64"|"linux/arm64")
            echo "gcc_linux-aarch64 gxx_linux-aarch64 gfortran_linux-aarch64"            
            ;;
        "osx-64")
            echo "clang_osx-64 clangxx_osx-64 gfortran_osx-64"            
            ;;
        "osx-arm64"|"darwin/arm64")
            echo "clang_osx-arm64 clangxx_osx-arm64 gfortran_osx-arm64"            
            ;;
        *)
            echo ""
            ;;
    esac
}

##############
#mapfile -t result < <("$script_dir/coble-recipise.sh --recipe YAML_FILE --output RECIPE --env ENV")
#success="${result[0]}"
#recipe_file="${result[1]}"            
##############
# Inputs ----
# 1. --recipe yamlfile
# 2. --env environment name or path
# 3. --output recipe file
# 4. --outdir output log files directory
# Outputs ----
# --stdout --
# 1. success=Y/N
# 2. recipefile path
# --filesystem --
# 1. recipe file
# 2. log files in outdir
###############

# Default values
ENV_INPUT="coble"
YAML_FILE=""
RECIPE_FILE=""
ENV_NAME=""
OUTDIR="."
CONDA_ALIAS="conda"
CONDA_EXE=$CONDA_EXE
VAL_FILE=""
VAL_FOLDER=""
COMPILE_ORDER=never
ENV_SIMS=false
BASE_SIMS=false
COMPILE_VER=false

echo "[coble-recipise] Starting recipise process..." >&2

# Parse named arguments
show_help() {
    echo "----- coble recipise help ----------"
    echo "Usage: $0 [--env ENV] [--recipe CBL] [--output RECIPE] [--outdir OUTDIR]"
    echo "  --env      ENV     Specify conda environment name or prefix (optional)"
    echo "  --recipe   CBL     Specify input CBL file (optional, default: ./coble-capture.cbl)"
    echo "  --output   RECIPE  Specify output recipe file (optional, default: ./coble-reciped-reproduce.sh)"
    echo "  --alias    EXE     Specify optional alternative to conda eg mamba"
    echo "  --validate FILE    Specify optional validation file"
    echo "  --val-folder FILEs  Specify additionals validation files"
    echo "  -h, --help         Show this help message and exit"
}

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --env)
            ENV_INPUT="$2"
            shift; shift
            ;;
        --recipe)
            YAML_FILE="$2"
            shift; shift
            ;;
        --output)
            RECIPE_FILE="$2"
            shift; shift
            ;;
        --alias)
            CONDA_ALIAS="$2"
            shift; shift
            ;;
        --outdir)
            OUTDIR="$2"
            shift; shift
            ;;
        --validate)
            VAL_FILE="$2"
            shift; shift
            ;;
        --val-folder)
            VAL_FOLDER="$2"
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

# Set CONDA_ENV: blank if ENV_INPUT is empty, otherwise --name or --prefix
if [[ -z "$ENV_INPUT" ]]; then
    CONDA_ENV=""
elif [[ "$ENV_INPUT" == */* ]]; then
    CONDA_ENV="--prefix $ENV_INPUT"
    # take of the last / for the name
    ENV_NAME="${ENV_INPUT##*/}"
else
    CONDA_ENV="--name $ENV_INPUT"
    ENV_NAME="$ENV_INPUT"
fi

if [[ -z "$YAML_FILE" ]]; then
    # if an env-name was entered, use that for the recipe file name
    YAML_FILE="./coble-captured-$ENV_NAME.yml"
fi

if [[ -z "$YAML_FILE" || ! -f "$YAML_FILE" ]]; then
    echo "Error: CBL file not found: $YAML_FILE" >&2
    echo "N"
    exit 1
fi

# Set RECIPE_FILE if not provided, and prepend OUTDIR
mkdir -p "$OUTDIR"
if [[ -z "$RECIPE_FILE" ]]; then
    base_name="${YAML_FILE##*/}"
    base_name_noext="${base_name%.*}"
    RESULTS_DIR="$(dirname "$YAML_FILE")"	
    RECIPE_FILE="$RESULTS_DIR/${base_name_noext}.sh"    
fi
# if recipe file already exists copy it
if [[ -f "$RECIPE_FILE" ]]; then
    cp "$RECIPE_FILE" "$RECIPE_FILE".bak
    echo "[coble-recipise] Existing recipe file backed up to: $RECIPE_FILE.bak" >&2    
fi
: > "$RECIPE_FILE"

# Now show all the inputs
echo "[coble-recipise] Using inputs:" >&2
echo "  ENV_INPUT: $ENV_INPUT" >&2
echo "  CBL_FILE: $YAML_FILE" >&2
echo "  RECIPE_FILE: $RECIPE_FILE" >&2
echo "  PLATFORM: $PLATFORM_STRING" >&2
echo "  COMPILERS: $COMPILER_PACKAGES" >&2

UPDATE_CONDA="--no-update-deps"
UPDATE_R="default"
NCPUS="4"
DEPS_CONDA=""
DEPS_PYTHON=""
DEPS_R="TRUE"
PRIORITY="strict"

# output is a recipe file for conda env create (always in current directory)
echo "[coble-recipise] Recipising conda environment from coble yaml file $YAML_FILE" >&2
echo "[coble-recipise] Recipising conda environment to recipe file $RECIPE_FILE" >&2
echo "[coble-recipise] Using conda executable $CONDA_EXE: $(which $CONDA_EXE)" >&2
echo "[coble-recipise] Using conda alias $CONDA_ALIAS: $(which $CONDA_ALIAS)" >&2
echo "[coble-recipise] Using conda prefix $CONDA_PREFIX: $(which $CONDA_PREFIX)" >&2


# Or use this more reliable method:
#CONDA_EXE=$(which $CONDA_EXE)
#CONDA_ALIAS=$(which $CONDA_ALIAS)
#CONDA_BASE=$(dirname $(dirname $CONDA_EXE))
TARGET_ENV="${ENV_INPUT}"  
TARGET_ENV_PATH="${CONDA_BASE}/envs/${TARGET_ENV}"

# Clear the aggregate file at the start
{
	echo "#!/usr/bin/env bash"    
    echo ""
    echo "#####################################################"
    echo -e "# COBLE:recipe, (c) ICR 2026"    
    CAPTURE_DATE=$(date '+%Y-%m-%d')
	CAPTURE_TIME=$(date '+%H:%M:%S %Z')
	CAPTURE_USER=$(whoami)	
	echo -e "# Capture date: $CAPTURE_DATE"
	echo -e "# Capture time: $CAPTURE_TIME"
	echo -e "# Captured by: $CAPTURE_USER"
    echo -e "# Platform: $PLATFORM_STRING"
    echo "#####################################################"
    echo -e "# source bashrc for conda"    
    # Generator writes this to the recipe:
    echo "CONDA_BASE=\$(conda info --base 2>/dev/null)"
    echo "[ -z \"\$CONDA_BASE\" ] && CONDA_BASE=\"$HOME/miniforge3\""
    echo "source \"\${CONDA_BASE}/etc/profile.d/conda.sh\""
    echo "conda deactivate 2>/dev/null || true"
    echo "# Using conda executable $CONDA_EXE: $(which $CONDA_EXE)"
    echo "# Using conda alias $CONDA_ALIAS: $(which $CONDA_ALIAS)"        
    echo "# CONDA base $CONDA_BASE"    
    echo "# Target environment $ENV_INPUT"
    echo "# Target path $TARGET_ENV_PATH"
    echo "#####################################################"    
    echo ""    
} > "$RECIPE_FILE"

### 00 cross platform support
# Now do the cross platform support strings
# Get platform info
PLATFORM_INFO=$(detect_platform)
IFS='|' read -r DETECTED_OS DETECTED_ARCH PLATFORM_STRING COMPILER_PREFIX <<< "$PLATFORM_INFO"

echo "[coble-recipise] Detected platform: OS=$DETECTED_OS, ARCH=$DETECTED_ARCH, PLATFORM=$PLATFORM_STRING" >&2
echo "# Detected platform: OS=$DETECTED_OS, ARCH=$DETECTED_ARCH, PLATFORM=$PLATFORM_STRING" >> "$RECIPE_FILE"
COMPILER_PACKAGES=$(get_compiler_packages "$PLATFORM_STRING")
CONDA_COMPILE_PACKAGES_VER="$COMPILER_PACKAGES"
CONDA_COMPILE_PACKAGES_MULTI="c-compiler cxx-compiler fortran-compiler"
CONDA_COMPILE_PACKAGES_NON_VER=""

# Add system specific compiler tools                
if [[ "$DETECTED_OS" == "linux" && "$DETECTED_ARCH" == "x86_64" ]]; then
    CONDA_COMPILE_PACKAGES_NON_VER="sysroot_linux-64"
elif [[ "$DETECTED_OS" == "linux" && "$DETECTED_ARCH" == "aarch64" ]]; then
    CONDA_COMPILE_PACKAGES_NON_VER="sysroot_linux-aarch64"
elif [[ "$DETECTED_OS" == "osx" && "$DETECTED_ARCH" == "x86_64" ]]; then
    CONDA_COMPILE_PACKAGES_NON_VER="sysroot_osx-64"
elif [[ "$DETECTED_OS" == "osx" && "$DETECTED_ARCH" == "arm64" ]]; then
    CONDA_COMPILE_PACKAGES_NON_VER="sysroot_osx-arm64"
fi
echo "# Compiler packages: $CONDA_COMPILE_PACKAGES_MULTI" >> "$RECIPE_FILE"
echo "# Compiler packages: $CONDA_COMPILE_PACKAGES_NON_VER" >> "$RECIPE_FILE"
echo "# Compiler packages: $CONDA_COMPILE_PACKAGES_VER" >> "$RECIPE_FILE"


### 01 Language checking checking ########################################
languages_line="${CONDA_EXE} env remove ${CONDA_ENV} -y 2>/dev/null || true"
languages_line+="\n${CONDA_EXE} create --no-default-packages ${CONDA_ENV} -y"

CURRENT_SECTION="bash"
r_count=0
python_count=0
while IFS= read -r line; do
    # Trim leading/trailing whitespace    
    line="$(echo -e "${line}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    if [[ "$line" == "languages:"* ]]; then
        CURRENT_SECTION="languages"
    elif [[ "$line" == "channels:"* ]]; then
        CURRENT_SECTION="channels"          
    elif [[ -z "$line" ]]; then
        CURRENT_SECTION=""
    elif [[ "$line" =~ ^([a-zA-Z0-9_-]+):$ ]]; then
        CURRENT_SECTION=""
    elif [[ "$CURRENT_SECTION" == "languages" && "$line" == "-"* ]]; then    
        if [[ "$line" == *"r-"* ]]; then
            r_count=$((r_count + 1))            
        elif [[ "$line" == *"python"* ]]; then            
            python_count=$((python_count + 1))
        fi        
    fi
done < "$YAML_FILE"
echo -e "$languages_line" >> "$RECIPE_FILE"
echo "export PYTHONNOUSERSITE=1" >> "$RECIPE_FILE"
echo "unset PYTHONPATH" >> "$RECIPE_FILE"
echo "# activate environment" >> "$RECIPE_FILE"
echo "conda activate ${ENV_INPUT}" >> "$RECIPE_FILE"
echo "" >> "$RECIPE_FILE"
echo "export PYTHONNOUSERSITE=1" >> "$RECIPE_FILE"
echo "export | grep PYTHONNOUSERSITE" >> "$RECIPE_FILE"

echo "[coble-recipise] Clearing default channels." >&2      
echo "# Channels section" >> "$RECIPE_FILE"
echo "${CONDA_EXE} config --env --remove-key channels" >> "$RECIPE_FILE"
echo "${CONDA_EXE} config --env --set channel_priority $PRIORITY" >> "$RECIPE_FILE"

# Exit if there is more than 1 r or python version
if [[ $r_count -gt 1 ]]; then
    echo "Error: More than one R version specified in languages section." >&2
    echo "N"
    echo "$RECIPE_FILE"
    exit 1
fi
if [[ $python_count -gt 1 ]]; then
    echo "Error: More than one Python version specified in languages section." >&2
    echo "N"
    echo "$RECIPE_FILE"
    exit 1
fi

### 02 CHANNEL Checking ########################################
CURRENT_SECTION=""
while IFS= read -r line; do
    # Trim leading/trailing whitespace
    line="$(echo -e "${line}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    if [[ "$line" == "channels:"* ]]; then
        CURRENT_SECTION="channels"
    elif [[ -z "$line" ]]; then
        CURRENT_SECTION=""
    # any line with a : at start is a new section
    elif [[ "$line" =~ ^([a-zA-Z0-9_-]+):$ ]]; then
        CURRENT_SECTION=""    
    elif [[ "$CURRENT_SECTION" == "channels" && "$line" == "-"* ]]; then
        # remove trailing and leading white space
        channel_name="$(echo -e "${line#- }" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
        echo "[coble-recipise] Adding channel: $channel_name" >&2
        echo "${CONDA_EXE} config --env --add channels $channel_name" >> "$RECIPE_FILE"
    fi
done < "$YAML_FILE"

### 02 MAIN TRANSLATION ###
echo "" >> "$RECIPE_FILE"
echo "# INSTALL SECTION FOR CONDA" >> "$RECIPE_FILE"
CURRENT_SECTION=""
while IFS= read -r line || [[ -n "$line" ]]; do
    # Trim leading/trailing whitespace
    line="$(echo -e "${line}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"    
    if [[ "$line" == "flags:"* \
        || "$line" == "variables:"* \
        || "$line" == "channels:"* \
        || "$line" == "languages:"* \
        || "$line" == "conda-r:"* \
        || "$line" == "r-conda:"* \
        || "$line" == "conda-bioc:"* \
        || "$line" == "bioc-conda:"* \
        || "$line" == "conda:"* \
        || "$line" == "r-package:"* \
        || "$line" == "package-r:"* \
        || "$line" == "r-github:"* \
        || "$line" == "r-url:"* \
        || "$line" == "pip:"* \
        || "$line" == "bash:"* \
        || "$line" == "find:"* \
        || "$line" == "bioc-package:"* \
        || "$line" == "package-bioc:"* ]]; then
        CURRENT_SECTION="$line"        
        # remove a trailing \ if needed (portable for macOS/BSD)
        sed_inplace '$s/\\$//' "$RECIPE_FILE"

        if [[ "$line" != "channels:" ]]; then
          echo "# $line" >> "$RECIPE_FILE"
        fi
        if [[ "$line" == *conda* ]]; then
          echo "${CONDA_ALIAS} install -y ${DEPS_CONDA} ${UPDATE_CONDA} \\" >> "$RECIPE_FILE"          
        fi      
    elif [[ -n "$CURRENT_SECTION" && "$line" == "-"* ]] || [[ "$CURRENT_SECTION" == "bash:"* ]]; then
        line="${line#- }"
        pkg_entry="${line%%#*}"  # remove comments
        pkg_entry="${pkg_entry## }"  # remove leading whitespace
        pkg_entry="${pkg_entry%% }"  # remove trailing whitespace

        IFS='@' read -r pkg src path <<< "$pkg_entry"
        IFS='=' read -r pkg_only ver <<< "$pkg"
        
        # For flags, parse directive and value from 'directive = value' format        
        if [[ "$CURRENT_SECTION" == "channels:"* ]]; then            
            continue
        elif [[ "$CURRENT_SECTION" == "flags:"* ]]; then
            directive="$(echo "$pkg_entry" | cut -d':' -f1)"
            value="$(echo "$pkg_entry" | cut -d':' -f2-)"
            directive="${directive## }"
            directive="${directive%% }"
            directive_lower=$(echo "$directive" | tr '[:upper:]' '[:lower:]')
            value="${value## }" 
            value="${value%% }"                                        
            value_lower=$(echo "$value" | tr '[:upper:]' '[:lower:]')                                                
            
            if [[ "${directive_lower}" == "dependencies" && "$value_lower" == "true" ]]; then                                
                echo "# Flag: Directive: $directive, Value: $value_lower" >> "$RECIPE_FILE"             
                DEPS_CONDA=""
                DEPS_PYTHON=""
                DEPS_R="TRUE"
            elif [[ "${directive_lower}" == "dependencies" && "$value_lower" == "false" ]]; then                                
                echo "# Flag: Directive: $directive, Value: $value_lower" >> "$RECIPE_FILE"             
                DEPS_CONDA="--no-deps"
                DEPS_PYTHON="--no-deps"
                DEPS_R="FALSE"            
            elif [[ "${directive_lower}" == "dependencies" && "$value_lower" == "na" ]]; then                                
                echo "# Flag: Directive: $directive, Value: $value_lower" >> "$RECIPE_FILE"             
                DEPS_CONDA=""
                DEPS_PYTHON=""
                DEPS_R="NA"
            elif [[ "${directive_lower}" == "export" ]]; then                
                echo "${CONDA_EXE} env config vars set ${value}" >> "$RECIPE_FILE"
                echo "conda deactivate" >> "$RECIPE_FILE"
                echo "conda activate ${ENV_INPUT}" >> "$RECIPE_FILE"
            elif [[ "${directive_lower}" == "alias" ]]; then                
                echo "# Flag: Directive: $directive, Value: $value_lower" >> "$RECIPE_FILE"             
                CONDA_ALIAS="$value"            
            elif [[ "${directive_lower}" == "ncpus" ]]; then                
                echo "# Flag: Directive: $directive, Value: $value_lower" >> "$RECIPE_FILE"             
                NCPUS="$value"                
            elif [[ "${directive_lower}" == "priority" ]]; then                
                PRIORITY="$value"                
                echo "${CONDA_EXE} config --env --set channel_priority $PRIORITY" >> "$RECIPE_FILE"
            elif [[ "${directive_lower}" == "channel" ]]; then                                          
                echo "${CONDA_EXE} config --env --add channels $value" >> "$RECIPE_FILE"
            elif [[ "${directive_lower}" == "updates" && "$value_lower" == "false" ]]; then                                
                echo "# Flag: Directive: $directive, Value: $value_lower" >> "$RECIPE_FILE"             
                UPDATE_CONDA="--no-update-deps"    
                UPDATE_R="never"
            elif [[ "${directive_lower}" == "updates" && "$value_lower" == "true" ]]; then
                echo "# Flag: Directive: $directive, Value: $value_lower" >> "$RECIPE_FILE"             
                UPDATE_CONDA="--update-deps"
                UPDATE_R="always"
            elif [[ "${directive_lower}" == "updates" && "$value_lower" == "default" ]]; then
                echo "# R Flag: Directive: $directive, Value: $value_lower" >> "$RECIPE_FILE"             
                UPDATE_R="default"
                UPDATE_CONDA=""
            elif [[ "${directive_lower}" == "updates" ]]; then
                echo "# Conda Flag: Directive: $directive, Value: $value_lower" >> "$RECIPE_FILE"             
                UPDATE_CONDA="$value_lower"
            
            elif [[ "${directive_lower}" == "network-viz" && "${value_lower}" == "true" ]]; then                
                echo "# Tools for network graph of r-packages" >> "$RECIPE_FILE"
                echo "${CONDA_ALIAS} install -y --no-update-deps -c conda-forge r-tidyverse r-visnetwork r-igraph r-ggraph" >>  "$RECIPE_FILE"
                echo "" >> "$RECIPE_FILE"            
                                                
            elif [[ "${directive_lower}" == "system-tools" && "${value_lower}" == "true" ]]; then                
                echo "" >> "$RECIPE_FILE"
                echo "# Including system dependencies for source installations" >> "$RECIPE_FILE"
                echo "# Essential shared packages" >> "$RECIPE_FILE"
                echo "${CONDA_ALIAS} install -y --no-update-deps -c conda-forge libcurl libprotobuf libpng libtiff libjpeg-turbo gdal proj geos gsl nlopt hdf5 cairo freetype expat fontconfig harfbuzz fribidi imagemagick" >>  "$RECIPE_FILE"
                if [[ $r_count -gt 0 ]]; then                
                    echo "# System r packages" >> "$RECIPE_FILE"
                    #echo "${CONDA_ALIAS} install -y --no-update-deps -c conda-forge librsvg udunits2" >> "$RECIPE_FILE"
                    echo "# Essential r packages" >> "$RECIPE_FILE"
                    #echo "${CONDA_ALIAS} install -y --no-update-deps -c conda-forge r-cpp11 r-openssl r-rsqlite r-essentials r-rsvg" >>  "$RECIPE_FILE"                    
                    echo "" >> "$RECIPE_FILE"            
                fi
                if [[ $python_count -gt 0 ]]; then
                    echo "# Essential python packages" >> "$RECIPE_FILE"                
                    #echo "${CONDA_ALIAS} install -y --no-update-deps -c conda-forge cython protobuf" >> "$RECIPE_FILE"
                    echo "" >> "$RECIPE_FILE"            
                fi  
                # language build tools
                echo "# Language build tools" >> "$RECIPE_FILE"
                echo "${CONDA_ALIAS} install -y --no-update-deps -c conda-forge make cmake pkg-config" >>  "$RECIPE_FILE"                    
                echo "# Language core system libraries" >> "$RECIPE_FILE"
                echo "${CONDA_ALIAS} install -y --no-update-deps -c conda-forge zlib bzip2 xz libxcrypt openssl sqlite" >> "$RECIPE_FILE"                                              
            
            elif [[ "${directive_lower}" == "compile-tools" ]]; then
                # CROSS-PLATFORM COMPILER INSTALLATION
                version="${value_lower}"
                if [[ "$version" == "false" ]]; then
                    echo "[coble-recipise] Not adding compile tools to recipe." >&2
                    continue
                fi

                COMPILER_PACKAGES=$(get_compiler_packages "$PLATFORM_STRING")                
                echo "[coble-recipise] Adding compile tools version $version for $PLATFORM_STRING" >&2
                CONDA_COMPILE_PACKAGES_VER=""
                if [[ "$version" == "true" ]]; then                    
                    CONDA_COMPILE_PACKAGES_VER="$COMPILER_PACKAGES"                                        
                else                    
                    echo "# Language compile tools (version $version) for $PLATFORM_STRING" >> "$RECIPE_FILE"                                        
                    versioned_packages=""
                    for pkg in $COMPILER_PACKAGES; do
                        CONDA_COMPILE_PACKAGES_VER="$CONDA_COMPILE_PACKAGES_VER '${pkg}=${version}'"
                    done                    
                    CONDA_COMPILE_PACKAGES_VER="${CONDA_COMPILE_PACKAGES_VER## }"                    
                fi
                                                
                echo "###############################" >> "$RECIPE_FILE"
                echo "" >> "$RECIPE_FILE"                
                echo "${CONDA_ALIAS} install -y --no-update-deps -c conda-forge \\" >>  "$RECIPE_FILE"
                echo "$CONDA_COMPILE_PACKAGES_MULTI \\" >>  "$RECIPE_FILE"
                echo "$CONDA_COMPILE_PACKAGES_NON_VER \\" >>  "$RECIPE_FILE"
                echo "$CONDA_COMPILE_PACKAGES_NON" >>  "$RECIPE_FILE"                
                echo "" >> "$RECIPE_FILE"
                echo "###############################" >> "$RECIPE_FILE"
                                
                # Platform-specific symlink setup
                if [[ "$DETECTED_OS" == "linux" ]]; then
                    echo "" >> "$RECIPE_FILE"
                    echo "# Set up compiler symlinks for R package compilation - Linux $DETECTED_ARCH" >> "$RECIPE_FILE"
                    echo "umask 0022" >> "$RECIPE_FILE"
                    
                    # COS6 compatibility symlinks (Linux only)
                    if [[ "$DETECTED_ARCH" == "x86_64" ]]; then
                        echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc \$CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc" >> "$RECIPE_FILE"
                        echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ \$CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-g++" >> "$RECIPE_FILE"
                        echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ \$CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++" >> "$RECIPE_FILE"
                        #echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran \$CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-gfortran" >> "$RECIPE_FILE"
                    elif [[ "$DETECTED_ARCH" == "arm64" ]]; then
                        echo "ln -sf \$CONDA_PREFIX/bin/aarch64-conda-linux-gnu-gcc \$CONDA_PREFIX/bin/aarch64-conda_cos6-linux-gnu-cc" >> "$RECIPE_FILE"
                        echo "ln -sf \$CONDA_PREFIX/bin/aarch64-conda-linux-gnu-g++ \$CONDA_PREFIX/bin/aarch64-conda_cos6-linux-gnu-g++" >> "$RECIPE_FILE"
                        echo "ln -sf \$CONDA_PREFIX/bin/aarch64-conda-linux-gnu-g++ \$CONDA_PREFIX/bin/aarch64-conda_cos6-linux-gnu-c++" >> "$RECIPE_FILE"
                        #echo "ln -sf \$CONDA_PREFIX/bin/aarch64-conda-linux-gnu-gfortran \$CONDA_PREFIX/bin/aarch64-conda_cos6-linux-gnu-gfortran" >> "$RECIPE_FILE"
                    fi
                    
                    # Standard aliases
                    echo "# Standard compiler aliases" >> "$RECIPE_FILE"
                    echo "ln -sf \$CONDA_PREFIX/bin/${COMPILER_PREFIX}-gcc \$CONDA_PREFIX/bin/gcc" >> "$RECIPE_FILE"
                    echo "ln -sf \$CONDA_PREFIX/bin/${COMPILER_PREFIX}-gcc \$CONDA_PREFIX/bin/cc" >> "$RECIPE_FILE"
                    echo "ln -sf \$CONDA_PREFIX/bin/${COMPILER_PREFIX}-g++ \$CONDA_PREFIX/bin/g++" >> "$RECIPE_FILE"
                    echo "ln -sf \$CONDA_PREFIX/bin/${COMPILER_PREFIX}-g++ \$CONDA_PREFIX/bin/c++" >> "$RECIPE_FILE"
                    #echo "ln -sf \$CONDA_PREFIX/bin/${COMPILER_PREFIX}-gfortran \$CONDA_PREFIX/bin/gfortran" >> "$RECIPE_FILE"
                    
                elif [[ "$DETECTED_OS" == "osx" ]]; then
                    echo "" >> "$RECIPE_FILE"
                    echo "# Set up compiler symlinks for R package compilation - macOS $DETECTED_ARCH" >> "$RECIPE_FILE"
                    echo "umask 0022" >> "$RECIPE_FILE"
                    
                    # macOS uses clang, so symlink appropriately
                    echo "# Standard compiler aliases for macOS" >> "$RECIPE_FILE"
                    echo "ln -sf \$CONDA_PREFIX/bin/clang \$CONDA_PREFIX/bin/gcc" >> "$RECIPE_FILE"
                    echo "ln -sf \$CONDA_PREFIX/bin/clang \$CONDA_PREFIX/bin/cc" >> "$RECIPE_FILE"
                    echo "ln -sf \$CONDA_PREFIX/bin/clang++ \$CONDA_PREFIX/bin/g++" >> "$RECIPE_FILE"
                    echo "ln -sf \$CONDA_PREFIX/bin/clang++ \$CONDA_PREFIX/bin/c++" >> "$RECIPE_FILE"
                    
                    # gfortran symlink
                    if [[ "$DETECTED_ARCH" == "arm64" ]]; then
                        echo "ln -sf \$CONDA_PREFIX/bin/arm64-apple-darwin20.0.0-gfortran \$CONDA_PREFIX/bin/gfortran 2>/dev/null || true" >> "$RECIPE_FILE"
                    else
                        echo "ln -sf \$CONDA_PREFIX/bin/x86_64-apple-darwin13.4.0-gfortran \$CONDA_PREFIX/bin/gfortran 2>/dev/null || true" >> "$RECIPE_FILE"
                    fi
                fi
                
                # Set compiler environment variables
                echo "" >> "$RECIPE_FILE"
                echo "# Set compiler flags for R package compilation - $PLATFORM_STRING" >> "$RECIPE_FILE"
                
                if [[ "$DETECTED_OS" == "linux" ]]; then
                    echo "${CONDA_EXE} env config vars set CC=\"\$CONDA_PREFIX/bin/gcc\"" >> "$RECIPE_FILE"
                    echo "${CONDA_EXE} env config vars set CXX=\"\$CONDA_PREFIX/bin/g++\"" >> "$RECIPE_FILE"
                    echo "${CONDA_EXE} env config vars set FC=\"\$CONDA_PREFIX/bin/${COMPILER_PREFIX}-gfortran\"" >> "$RECIPE_FILE"
                    echo "${CONDA_EXE} env config vars set F77=\"\$CONDA_PREFIX/bin/${COMPILER_PREFIX}-gfortran\"" >> "$RECIPE_FILE"
                elif [[ "$DETECTED_OS" == "osx" ]]; then
                    echo "${CONDA_EXE} env config vars set CC=\"\$CONDA_PREFIX/bin/clang\"" >> "$RECIPE_FILE"
                    echo "${CONDA_EXE} env config vars set CXX=\"\$CONDA_PREFIX/bin/clang++\"" >> "$RECIPE_FILE"
                    echo "${CONDA_EXE} env config vars set FC=\"\$CONDA_PREFIX/bin/gfortran\"" >> "$RECIPE_FILE"
                    echo "${CONDA_EXE} env config vars set F77=\"\$CONDA_PREFIX/bin/gfortran\"" >> "$RECIPE_FILE"
                fi
                
                echo "${CONDA_EXE} env config vars set CFLAGS=\"-I\$CONDA_PREFIX/include\"" >> "$RECIPE_FILE"
                echo "${CONDA_EXE} env config vars set CXXFLAGS=\"-I\$CONDA_PREFIX/include\"" >> "$RECIPE_FILE"
                echo "${CONDA_EXE} env config vars set CPPFLAGS=\"-I\$CONDA_PREFIX/include\"" >> "$RECIPE_FILE"
                echo "${CONDA_EXE} env config vars set LDFLAGS=\"-L\$CONDA_PREFIX/lib -Wl,-rpath,\$CONDA_PREFIX/lib\"" >> "$RECIPE_FILE"                    
                echo "${CONDA_EXE} env config vars set LD_LIBRARY_PATH=\"\$CONDA_PREFIX/lib:\$LD_LIBRARY_PATH\"" >> "$RECIPE_FILE"

                echo "conda deactivate" >> "$RECIPE_FILE"
                echo "conda activate ${ENV_INPUT}" >> "$RECIPE_FILE"
                echo "" >> "$RECIPE_FILE"
                echo "# ================================================" >> "$RECIPE_FILE"
                echo "# END CROSS-PLATFORM COMPILER SETUP" >> "$RECIPE_FILE"
                echo "# ================================================" >> "$RECIPE_FILE"
                echo "" >> "$RECIPE_FILE"
                
            elif [[ "${directive_lower}" == "compile-paths" ]]; then                
                # Only setup paths, no compiler installation
                version="${value_lower}"
                if [[ "$version" == "false" ]]; then
                    echo "[coble-recipise] Not adding compile paths to recipe." >&2
                    continue
                fi
                
                echo "" >> "$RECIPE_FILE"
                echo "# ================================================" >> "$RECIPE_FILE"
                echo "# CROSS-PLATFORM COMPILER PATHS SETUP (no installation)" >> "$RECIPE_FILE"
                echo "# Platform: $PLATFORM_STRING" >> "$RECIPE_FILE"
                echo "# ================================================" >> "$RECIPE_FILE"
                
                if [[ "$version" == "true" ]]; then
                    echo "[coble-recipise] Adding compiler paths for $PLATFORM_STRING" >&2
                    
                    # Platform-specific symlink setup
                    if [[ "$DETECTED_OS" == "linux" ]]; then
                        echo "# Set up compiler symlinks for R package compilation - Linux $DETECTED_ARCH" >> "$RECIPE_FILE"
                        echo "umask 0022" >> "$RECIPE_FILE"
                        
                        if [[ "$DETECTED_ARCH" == "x86_64" ]]; then
                            echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc \$CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc" >> "$RECIPE_FILE"
                            echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ \$CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++" >> "$RECIPE_FILE"
                            echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran \$CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-gfortran" >> "$RECIPE_FILE"
                        elif [[ "$DETECTED_ARCH" == "arm64" ]]; then
                            echo "ln -sf \$CONDA_PREFIX/bin/aarch64-conda-linux-gnu-gcc \$CONDA_PREFIX/bin/aarch64-conda_cos6-linux-gnu-cc" >> "$RECIPE_FILE"
                            echo "ln -sf \$CONDA_PREFIX/bin/aarch64-conda-linux-gnu-g++ \$CONDA_PREFIX/bin/aarch64-conda_cos6-linux-gnu-c++" >> "$RECIPE_FILE"
                            echo "ln -sf \$CONDA_PREFIX/bin/aarch64-conda-linux-gnu-gfortran \$CONDA_PREFIX/bin/aarch64-conda_cos6-linux-gnu-gfortran" >> "$RECIPE_FILE"
                        fi
                        
                        echo "# Standard compiler aliases" >> "$RECIPE_FILE"
                        echo "ln -sf \$CONDA_PREFIX/bin/${COMPILER_PREFIX}-gcc \$CONDA_PREFIX/bin/gcc" >> "$RECIPE_FILE"
                        echo "ln -sf \$CONDA_PREFIX/bin/${COMPILER_PREFIX}-gcc \$CONDA_PREFIX/bin/cc" >> "$RECIPE_FILE"
                        echo "ln -sf \$CONDA_PREFIX/bin/${COMPILER_PREFIX}-g++ \$CONDA_PREFIX/bin/g++" >> "$RECIPE_FILE"
                        echo "ln -sf \$CONDA_PREFIX/bin/${COMPILER_PREFIX}-g++ \$CONDA_PREFIX/bin/c++" >> "$RECIPE_FILE"
                        
                    elif [[ "$DETECTED_OS" == "osx" ]]; then
                        echo "# Set up compiler symlinks for R package compilation - macOS $DETECTED_ARCH" >> "$RECIPE_FILE"
                        echo "umask 0022" >> "$RECIPE_FILE"
                        echo "ln -sf \$CONDA_PREFIX/bin/clang \$CONDA_PREFIX/bin/gcc" >> "$RECIPE_FILE"
                        echo "ln -sf \$CONDA_PREFIX/bin/clang \$CONDA_PREFIX/bin/cc" >> "$RECIPE_FILE"
                        echo "ln -sf \$CONDA_PREFIX/bin/clang++ \$CONDA_PREFIX/bin/g++" >> "$RECIPE_FILE"
                        echo "ln -sf \$CONDA_PREFIX/bin/clang++ \$CONDA_PREFIX/bin/c++" >> "$RECIPE_FILE"
                    fi
                    
                    # Set compiler environment variables
                    echo "# Set compiler flags for R package compilation" >> "$RECIPE_FILE"
                    if [[ "$DETECTED_OS" == "linux" ]]; then
                        echo "${CONDA_EXE} env config vars set CC=\"\$CONDA_PREFIX/bin/gcc\"" >> "$RECIPE_FILE"
                        echo "${CONDA_EXE} env config vars set CXX=\"\$CONDA_PREFIX/bin/g++\"" >> "$RECIPE_FILE"
                        echo "${CONDA_EXE} env config vars set FC=\"\$CONDA_PREFIX/bin/${COMPILER_PREFIX}-gfortran\"" >> "$RECIPE_FILE"
                        echo "${CONDA_EXE} env config vars set F77=\"\$CONDA_PREFIX/bin/${COMPILER_PREFIX}-gfortran\"" >> "$RECIPE_FILE"
                    elif [[ "$DETECTED_OS" == "osx" ]]; then
                        echo "${CONDA_EXE} env config vars set CC=\"\$CONDA_PREFIX/bin/clang\"" >> "$RECIPE_FILE"
                        echo "${CONDA_EXE} env config vars set CXX=\"\$CONDA_PREFIX/bin/clang++\"" >> "$RECIPE_FILE"
                        echo "${CONDA_EXE} env config vars set FC=\"\$CONDA_PREFIX/bin/gfortran\"" >> "$RECIPE_FILE"
                        echo "${CONDA_EXE} env config vars set F77=\"\$CONDA_PREFIX/bin/gfortran\"" >> "$RECIPE_FILE"
                    fi
                    
                    echo "${CONDA_EXE} env config vars set CFLAGS=\"-I\$CONDA_PREFIX/include\"" >> "$RECIPE_FILE"
                    echo "${CONDA_EXE} env config vars set CXXFLAGS=\"-I\$CONDA_PREFIX/include\"" >> "$RECIPE_FILE"
                    echo "${CONDA_EXE} env config vars set CPPFLAGS=\"-I\$CONDA_PREFIX/include\"" >> "$RECIPE_FILE"
                    echo "${CONDA_EXE} env config vars set LDFLAGS=\"-L\$CONDA_PREFIX/lib -Wl,-rpath,\$CONDA_PREFIX/lib\"" >> "$RECIPE_FILE"                                
                    echo "conda deactivate" >> "$RECIPE_FILE"
                    echo "conda activate ${ENV_INPUT}" >> "$RECIPE_FILE"
                    echo "" >> "$RECIPE_FILE"
                fi
                echo "# ================================================" >> "$RECIPE_FILE"
                echo "# END CROSS-PLATFORM COMPILER PATHS SETUP" >> "$RECIPE_FILE"
                echo "# ================================================" >> "$RECIPE_FILE"
                echo "" >> "$RECIPE_FILE"
            fi
            
        elif [[ "$CURRENT_SECTION" == "languages:"* ]]; then    
            # trim whitespace from src
            src="${src## }"    # remove leading spaces
            src="${src%% }"    # remove trailing spaces
            pkg_only="${pkg_only## }"
            pkg_only="${pkg_only%% }"                 
            if [[ "$pkg_only" == *"no-deps"* ]]; then
                DEPS_CONDA="--no-deps"
            elif [[ "$pkg" == "add:"* ]]; then                
                pkg="${pkg#add:}"                                                
                pkg="${pkg## }"
                pkg="${pkg%% }"
                echo "# $pkg adding to init installs" >> "$RECIPE_FILE"                
                CONDA_COMPILE_PACKAGES_MULTI="$CONDA_COMPILE_PACKAGES_MULTI '$pkg'"
            elif [[ "$pkg_only" == "compile-version"* ]]; then   
                echo "# Setting compile tools version to $ver" >> "$RECIPE_FILE"
                COMPILER_PACKAGES=$(get_compiler_packages "$PLATFORM_STRING")
                CONDA_COMPILE_PACKAGES_VER=""
                for pkg in $COMPILER_PACKAGES; do
                    CONDA_COMPILE_PACKAGES_VER="$CONDA_COMPILE_PACKAGES_VER '${pkg}=${ver}'"
                done
                CONDA_COMPILE_PACKAGES_VER="${CONDA_COMPILE_PACKAGES_VER## }"            
            
            elif [[ "$pkg_only" == "compile-order"* ]]; then   # first/last/with
                echo "# Setting compile order: $ver" >> "$RECIPE_FILE"
                COMPILE_ORDER="$ver"
            elif [[ "$pkg_only" == "env-sims"* ]]; then 
                echo "# Setting env sims: $ver" >> "$RECIPE_FILE"
                ENV_SIMS="$ver"
            elif [[ "$pkg_only" == "base-sims"* ]]; then 
                echo "# Setting base sims: $ver" >> "$RECIPE_FILE"                
                BASE_SIMS=$ver           
            elif [[ "$pkg_only" == "r-base" ]]; then        

#################################################################################################
#################################################################################################
#                        R Decision TREE on COMPILER INSTALLS
#################################################################################################
#################################################################################################                          

                if [[ "$src" != "" ]]; then       
                        pkg="$src::$pkg"                                            
                fi
                
                if [[ $BASE_SIMS == "true" ]]; then
                    
                    echo "# Base sims enabled - adding base simlinks prior toinstlalation" >> "$RECIPE_FILE"
                    # Workaround for R 3.6.0 post-link script bug: 
                    # R 3.6.0 looks for compilers in base conda /bin, not in the environment
                    # Create symlinks so R can find them (architecture-aware)
                    echo "# Creating compiler symlinks in base conda for R 3.6.0 compatibility..." >> "$RECIPE_FILE"                
                    echo "[coble-recipise] Using conda base = $CONDA_BASE" >&2
                    echo "[coble-recipise] Using conda target =  $TARGET_ENV_PATH" >&2
                    echo "[coble-recipise] Using conda prefix = $CONDA_PREFIX" >&2                
                    # Find the actual compiler prefix (could be x86_64, aarch64, etc.)
                    # Execute the checks NOW, only write ln commands if files exist
                    for compiler in gcc gfortran f95; do
                        VERSIONED_COMPILER=$(ls -1 $CONDA_PREFIX/bin/*-$compiler 2>/dev/null | head -1)
                        if [ -n "$VERSIONED_COMPILER" ]; then
                            COMPILER_NAME=$(basename $VERSIONED_COMPILER)
                            # Just write the ln command
                            echo "ln -sf \$CONDA_PREFIX/bin/$COMPILER_NAME $CONDA_BASE/bin/$COMPILER_NAME" >> "$RECIPE_FILE"
                        fi
                    done
                    # Execute the checks NOW, only write ln commands if files exist
                    for tool in gcc g++ gfortran f95 c++ cc; do
                        # Check if file exists NOW (during generation)
                        if [ -f "$CONDA_PREFIX/bin/$tool" ]; then
                            # Write just the ln command, not the if statement
                            echo "ln -sf \$CONDA_PREFIX/bin/$tool $CONDA_BASE/bin/$tool" >> "$RECIPE_FILE"
                        fi
                    done                    

                fi
                
                if [[ $COMPILE_ORDER == "never" || $COMPILE_ORDER == "last" ]]; then
                    
                    echo "# Installing R base version $ver separately" >> "$RECIPE_FILE"                                                                        
                    echo "${CONDA_ALIAS} install -y ${DEPS_CONDA} ${pkg} r-remotes r-biocmanager" >> "$RECIPE_FILE"
                                        
                fi
                
                if [[ $COMPILE_ORDER == "first" ]]; then
                    echo "# Installing R base version together with compilers" >> "$RECIPE_FILE"                                    
                    echo "${CONDA_ALIAS} install -y ${DEPS_CONDA} \\" >> "$RECIPE_FILE"                    
                    echo "  ${CONDA_COMPILE_PACKAGES_VER} \\" >> "$RECIPE_FILE"
                    echo "  ${CONDA_COMPILE_PACKAGES_MULTI} \\" >> "$RECIPE_FILE"                                                        
                    echo "  ${CONDA_COMPILE_PACKAGES_NON_VER}" >> "$RECIPE_FILE"                    
                fi
                
                if [[ $COMPILE_ORDER == "with" ]]; then
                    echo "${CONDA_ALIAS} install -y ${DEPS_CONDA} \\" >> "$RECIPE_FILE"                    
                    echo "  ${CONDA_COMPILE_PACKAGES_VER} \\" >> "$RECIPE_FILE"
                    echo "  ${CONDA_COMPILE_PACKAGES_MULTI} \\" >> "$RECIPE_FILE"                
                    echo "  ${CONDA_COMPILE_PACKAGES_NON_VER} \\" >> "$RECIPE_FILE"                    
                    echo "  '$pkg' r-remotes r-biocmanager" >> "$RECIPE_FILE" 
                fi

                if [[ $ENV_SIMS == "true" ]]; then

                    # Platform-specific symlink setup
                    if [[ "$DETECTED_OS" == "linux" ]]; then
                        echo "" >> "$RECIPE_FILE"
                        echo "# Set up compiler symlinks for R package compilation - Linux $DETECTED_ARCH" >> "$RECIPE_FILE"
                        echo "umask 0022" >> "$RECIPE_FILE"
                        
                        # COS6 compatibility symlinks (Linux only)
                        if [[ "$DETECTED_ARCH" == "x86_64" ]]; then
                            echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc \$CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc" >> "$RECIPE_FILE"
                            echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ \$CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-g++" >> "$RECIPE_FILE"
                            echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ \$CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++" >> "$RECIPE_FILE"
                            #echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran \$CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-gfortran" >> "$RECIPE_FILE"
                        elif [[ "$DETECTED_ARCH" == "arm64" ]]; then
                            echo "ln -sf \$CONDA_PREFIX/bin/aarch64-conda-linux-gnu-gcc \$CONDA_PREFIX/bin/aarch64-conda_cos6-linux-gnu-cc" >> "$RECIPE_FILE"
                            echo "ln -sf \$CONDA_PREFIX/bin/aarch64-conda-linux-gnu-g++ \$CONDA_PREFIX/bin/aarch64-conda_cos6-linux-gnu-g++" >> "$RECIPE_FILE"
                            echo "ln -sf \$CONDA_PREFIX/bin/aarch64-conda-linux-gnu-g++ \$CONDA_PREFIX/bin/aarch64-conda_cos6-linux-gnu-c++" >> "$RECIPE_FILE"
                            #echo "ln -sf \$CONDA_PREFIX/bin/aarch64-conda-linux-gnu-gfortran \$CONDA_PREFIX/bin/aarch64-conda_cos6-linux-gnu-gfortran" >> "$RECIPE_FILE"
                        fi
                        
                        # Standard aliases
                        echo "# Standard compiler aliases" >> "$RECIPE_FILE"
                        echo "ln -sf \$CONDA_PREFIX/bin/${COMPILER_PREFIX}-gcc \$CONDA_PREFIX/bin/gcc" >> "$RECIPE_FILE"
                        echo "ln -sf \$CONDA_PREFIX/bin/${COMPILER_PREFIX}-gcc \$CONDA_PREFIX/bin/cc" >> "$RECIPE_FILE"
                        echo "ln -sf \$CONDA_PREFIX/bin/${COMPILER_PREFIX}-g++ \$CONDA_PREFIX/bin/g++" >> "$RECIPE_FILE"
                        echo "ln -sf \$CONDA_PREFIX/bin/${COMPILER_PREFIX}-g++ \$CONDA_PREFIX/bin/c++" >> "$RECIPE_FILE"
                        #echo "ln -sf \$CONDA_PREFIX/bin/${COMPILER_PREFIX}-gfortran \$CONDA_PREFIX/bin/gfortran" >> "$RECIPE_FILE"
                        
                    elif [[ "$DETECTED_OS" == "osx" ]]; then
                        echo "" >> "$RECIPE_FILE"
                        echo "# Set up compiler symlinks for R package compilation - macOS $DETECTED_ARCH" >> "$RECIPE_FILE"
                        echo "umask 0022" >> "$RECIPE_FILE"
                        
                        # macOS uses clang, so symlink appropriately
                        echo "# Standard compiler aliases for macOS" >> "$RECIPE_FILE"
                        echo "ln -sf \$CONDA_PREFIX/bin/clang \$CONDA_PREFIX/bin/gcc" >> "$RECIPE_FILE"
                        echo "ln -sf \$CONDA_PREFIX/bin/clang \$CONDA_PREFIX/bin/cc" >> "$RECIPE_FILE"
                        echo "ln -sf \$CONDA_PREFIX/bin/clang++ \$CONDA_PREFIX/bin/g++" >> "$RECIPE_FILE"
                        echo "ln -sf \$CONDA_PREFIX/bin/clang++ \$CONDA_PREFIX/bin/c++" >> "$RECIPE_FILE"
                        
                        # gfortran symlink
                        if [[ "$DETECTED_ARCH" == "arm64" ]]; then
                            echo "ln -sf \$CONDA_PREFIX/bin/arm64-apple-darwin20.0.0-gfortran \$CONDA_PREFIX/bin/gfortran 2>/dev/null || true" >> "$RECIPE_FILE"
                        else
                            echo "ln -sf \$CONDA_PREFIX/bin/x86_64-apple-darwin13.4.0-gfortran \$CONDA_PREFIX/bin/gfortran 2>/dev/null || true" >> "$RECIPE_FILE"
                        fi
                    fi                    
                
                    # Now add the config envs for the packages
                    if [[ "$DETECTED_OS" == "linux" ]]; then
                        echo "${CONDA_EXE} env config vars set CC=\"\$CONDA_PREFIX/bin/gcc\"" >> "$RECIPE_FILE"
                        echo "${CONDA_EXE} env config vars set CXX=\"\$CONDA_PREFIX/bin/g++\"" >> "$RECIPE_FILE"
                        echo "${CONDA_EXE} env config vars set FC=\"\$CONDA_PREFIX/bin/${COMPILER_PREFIX}-gfortran\"" >> "$RECIPE_FILE"
                        echo "${CONDA_EXE} env config vars set F77=\"\$CONDA_PREFIX/bin/${COMPILER_PREFIX}-gfortran\"" >> "$RECIPE_FILE"
                    elif [[ "$DETECTED_OS" == "osx" ]]; then
                        echo "${CONDA_EXE} env config vars set CC=\"\$CONDA_PREFIX/bin/clang\"" >> "$RECIPE_FILE"
                        echo "${CONDA_EXE} env config vars set CXX=\"\$CONDA_PREFIX/bin/clang++\"" >> "$RECIPE_FILE"
                        echo "${CONDA_EXE} env config vars set FC=\"\$CONDA_PREFIX/bin/gfortran\"" >> "$RECIPE_FILE"
                        echo "${CONDA_EXE} env config vars set F77=\"\$CONDA_PREFIX/bin/gfortran\"" >> "$RECIPE_FILE"
                    fi
                    
                    echo "${CONDA_EXE} env config vars set CFLAGS=\"-I\$CONDA_PREFIX/include\"" >> "$RECIPE_FILE"
                    echo "${CONDA_EXE} env config vars set CXXFLAGS=\"-I\$CONDA_PREFIX/include\"" >> "$RECIPE_FILE"
                    echo "${CONDA_EXE} env config vars set CPPFLAGS=\"-I\$CONDA_PREFIX/include\"" >> "$RECIPE_FILE"
                    echo "${CONDA_EXE} env config vars set LDFLAGS=\"-L\$CONDA_PREFIX/lib -Wl,-rpath,\$CONDA_PREFIX/lib\"" >> "$RECIPE_FILE"                    
                    echo "${CONDA_EXE} env config vars set LD_LIBRARY_PATH=\"\$CONDA_PREFIX/lib:\$LD_LIBRARY_PATH\"" >> "$RECIPE_FILE"

                    echo "conda deactivate" >> "$RECIPE_FILE"
                    echo "conda activate ${ENV_INPUT}" >> "$RECIPE_FILE"
                    echo "" >> "$RECIPE_FILE"
                
                fi
                                                                
                if [[ $COMPILE_ORDER == "first" ]]; then
                    
                    echo "# Installing R base version $ver separately" >> "$RECIPE_FILE"                                                                        
                    echo "${CONDA_ALIAS} install -y ${DEPS_CONDA} ${pkg} r-remotes r-biocmanager" >> "$RECIPE_FILE"
                                        
                fi                

#################################################################################################
#################################################################################################
#                        R Decision TREE ENDED
#################################################################################################
#################################################################################################                          


            elif [[ "$pkg_only" == "python" ]]; then                                    
                if [[ "$src" == "" ]]; then
                    echo "${CONDA_ALIAS} install -y ${DEPS_CONDA} '$pkg'" >> "$RECIPE_FILE"
                else                    
                    echo "${CONDA_ALIAS} install -y ${DEPS_CONDA} '$src::$pkg'" >> "$RECIPE_FILE"
                fi
                echo "python -m site" >> "$RECIPE_FILE"
                echo "${CONDA_EXE} env config vars set PYTHONNOUSERSITE=1" >> "$RECIPE_FILE"
                echo "conda deactivate" >> "$RECIPE_FILE"
                echo "conda activate ${ENV_INPUT}" >> "$RECIPE_FILE"
            fi            
        elif [[ "$CURRENT_SECTION" == "conda-r:"* || "$CURRENT_SECTION" == "r-conda:"*  ]]; then            
            if [[ "$src" != "" ]]; then
                echo "'$src::r-$pkg' \\" >> "$RECIPE_FILE"
            else
                echo "'r-$pkg' \\" >> "$RECIPE_FILE"
            fi                        
        elif [[ "$CURRENT_SECTION" == "conda-bioc:"* || "$CURRENT_SECTION" == "bioc-conda:"*  ]]; then                        
            if [[ "$src" != "" ]]; then
                echo "'$src::bioconductor-$pkg' \\" >> "$RECIPE_FILE"
            else
                echo "'bioconductor-$pkg' \\" >> "$RECIPE_FILE"
            fi                                    
        elif [[  "$CURRENT_SECTION" == "conda:"* ]]; then            
            if [[ "$src" != "" ]]; then
                echo "'$src::$pkg' \\" >> "$RECIPE_FILE"
            else
                echo "'$pkg' \\" >> "$RECIPE_FILE"
            fi                                                            
        elif [[ "$CURRENT_SECTION" == "package-r:"* || "$CURRENT_SECTION" == "r-package:"* ]]; then                        
            if [[ -n "$ver" && ( -z "$src" || "$src" == "CRAN"* ) ]]; then
                echo "Rscript -e 'remotes::install_version(\"$pkg_only\", version=\"$ver\", repos=\"https://cloud.r-project.org\", dependencies=$DEPS_R, upgrade=\"$UPDATE_R\", Ncpus=$NCPUS)'" >> "$RECIPE_FILE"
            elif [[ "$src" == "r-forge"* ]]; then
                echo "Rscript -e 'install.packages(\"${pkg_only}\", repos=\"https://R-Forge.R-project.org\", dependencies=$DEPS_R, Ncpus=$NCPUS)'" >> "$RECIPE_FILE"
            else
                echo "Rscript -e 'install.packages(\"${pkg_only}\", repos=\"https://cloud.r-project.org\", dependencies=$DEPS_R, Ncpus=$NCPUS)'" >> "$RECIPE_FILE"
            fi
        elif [[ "$CURRENT_SECTION" == "r-github:"* || "$CURRENT_SECTION" == "github-r:"* ]]; then
            if [[ -n "$src" ]]; then
                echo "Rscript -e 'remotes::install_github(\"$pkg_only\", dependencies=$DEPS_R, upgrade=\"$UPDATE_R\", subdir=\"$src\", Ncpus=$NCPUS)'" >> "$RECIPE_FILE"
            else
                echo "Rscript -e 'remotes::install_github(\"$pkg_entry\", dependencies=$DEPS_R, upgrade=\"$UPDATE_R\", Ncpus=$NCPUS)'" >> "$RECIPE_FILE"
            fi
        elif [[ "$CURRENT_SECTION" == "r-url:"* ]]; then
            if [[ -n "$src" ]]; then
                echo "Rscript -e 'remotes::install_url(\"$pkg_only\", dependencies=$DEPS_R, upgrade=\"$UPDATE_R\", subdir=\"$src\", Ncpus=$NCPUS)'" >> "$RECIPE_FILE"
            else
                echo "Rscript -e 'remotes::install_url(\"$pkg_entry\", dependencies=$DEPS_R, upgrade=\"$UPDATE_R\", Ncpus=$NCPUS)'" >> "$RECIPE_FILE"
            fi
        elif [[ "$CURRENT_SECTION" == "package-bioc:"* || "$CURRENT_SECTION" == "bioc-package:"* ]]; then
            echo "Rscript -e 'BiocManager::install(\"${pkg_only}\", dependencies=$DEPS_R, Ncpus=$NCPUS)'" >> "$RECIPE_FILE"        
        elif [[ "$CURRENT_SECTION" == "pip:"* ]]; then
            pip_pkg="$pkg"
            if [[ "$pip_pkg" == https* && "$pip_pkg" != git+* ]]; then
                echo "python -m pip install \"git+${pkg_entry}\" $DEPS_PYTHON" >> "$RECIPE_FILE"
            elif [[ "$pip_pkg" == https* ]]; then
                echo "python -m pip install '${pkg_entry}' $DEPS_PYTHON" >> "$RECIPE_FILE"
            elif [[ -z "$ver" ]]; then
                echo "python -m pip install '${pkg_only}' $DEPS_PYTHON" >> "$RECIPE_FILE"
            else
                echo "python -m pip install '${pkg_only}==$ver' $DEPS_PYTHON" >> "$RECIPE_FILE"
            fi
        elif [[ "$CURRENT_SECTION" == "bash:"* ]]; then
            echo "[coble-recipise] Adding bash command: $pkg_entry" >&2
            echo "${line//\\n/\\\\n}" >> "$RECIPE_FILE"
        elif [[ "$CURRENT_SECTION" == "find:"* ]]; then
            echo "[coble-recipise] Finding: $pkg_only, version: $ver, source: $src" >&2
            script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
            find_args=(--pkg "$pkg_only" --version "$ver")
            # Bash 3.2 compatible (no mapfile)
            temp_output=$("$script_dir/coble-find.sh" "${find_args[@]}")
            pkg_manager=$(echo "$temp_output" | sed -n '1p')
            recipe_line=$(echo "$temp_output" | sed -n '2p')
            yaml_line=$(echo "$temp_output" | sed -n '3p')
            if [[ $pkg_manager == "unknown" ]]; then
                echo "[coble-resolve] Unknown: $line" >&2
                echo "# Unknown package: $line" >> "$RECIPE_FILE"
            else            
                echo "${recipe_line}" >> "$RECIPE_FILE"                              
            fi
        fi
    else                                
        sed_inplace '$s/\\$//' "$RECIPE_FILE"
        if [[ "$line" == \#* ]]; then            
            echo "$line" >> "$RECIPE_FILE"
        elif [[ -z "$line" ]]; then
            echo "" >> "$RECIPE_FILE"        
        fi
    fi
done < "$YAML_FILE"
sed_inplace '$s/\\$//' "$RECIPE_FILE"

# Validation script
if [[ -n "$VAL_FILE" ]]; then
    echo "" >> "$RECIPE_FILE"
    echo "# Validate script available in environment at CONDA PREFIX: validate.sh" >> "$RECIPE_FILE"
    echo "cp $VAL_FILE \${CONDA_PREFIX}/bin/validate.sh" >> "$RECIPE_FILE"
else
    {
        echo 'echo "#!/usr/bin/env bash" > ${CONDA_PREFIX}/bin/validate.sh'
        echo 'echo "echo \"COBLE validation: No script has been specified for '"$ENV_NAME"' environment.\"" >> ${CONDA_PREFIX}/bin/validate.sh'
        echo 'chmod +x ${CONDA_PREFIX}/bin/validate.sh'
    } >> "$RECIPE_FILE"
fi

echo "chmod +x \${CONDA_PREFIX}/bin/validate.sh" >> "$RECIPE_FILE"

if [[ -n "$VAL_FOLDER" && -d "$VAL_FOLDER" ]]; then    
    for vf in "$VAL_FOLDER"/*; do
        [[ -f "$vf" ]] || continue
        vf_base=$(basename "$vf")
        [[ "$vf_base" == "validate.sh" ]] && continue
        
        echo "# Extra validation file: $vf_base" >> "$RECIPE_FILE"
        echo "cp $vf \${CONDA_PREFIX}/bin/$vf_base" >> "$RECIPE_FILE"
        echo "chmod +x \${CONDA_PREFIX}/bin/$vf_base" >> "$RECIPE_FILE"
    done
fi

echo "[coble-recipise] Recipe generation complete: $RECIPE_FILE" >&2
echo "" >> "$RECIPE_FILE"
echo "Y"
echo "$RECIPE_FILE"
