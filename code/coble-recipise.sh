#!/usr/bin/env bash

# Turn a captured yaml file into a coble recipe script

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
CONDA_EXE="conda"

echo "[coble-recipise] Starting recipise process..." >&2

# Parse named arguments
show_help() {
    echo "----- coble recipise help ----------"
    echo "Usage: $0 [--env ENV] [--recipe CBL] [--output RECIPE] [--outdir OUTDIR]"
    echo "  --env ENV        Specify conda environment name or prefix (optional)"
    echo "  --recipe CBL     Specify input CBL file (optional, default: ./coble-capture.cbl)"
    echo "  --output RECIPE  Specify output recipe file (optional, default: ./coble-reciped-reproduce.sh)"
    echo "  --alias exe      Specify optional alternative to conda eg mamba"
    echo "  -h, --help       Show this help message and exit"
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
    #base_name="${YAML_FILE##*/}"
    #base_name_noext="${base_name%.*}"
    #RECIPE_FILE="${base_name_noext}-recipe.sh"
    #RECIPE_FILE="$OUTDIR/${RECIPE_FILE}"
    # replace dots with _
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

UPDATE_CONDA="--no-update-deps"
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
    echo "#####################################################"
    echo -e "# source bashrc for conda"
    #echo -e "source \"\$(conda info --base)/etc/profile.d/conda.sh\""
    #echo 'eval "$('"$CONDA_ALIAS"' shell hook --shell=bash)"'
    echo -e "source ~/.bashrc"
    echo "# Using conda executable $CONDA_EXE: $(which $CONDA_EXE)"
    echo "# Using conda alias $CONDA_ALIAS: $(which $CONDA_ALIAS)"
    echo "#####################################################"    
    echo ""    
} > "$RECIPE_FILE"

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
echo "${CONDA_EXE} activate ${ENV_INPUT}" >> "$RECIPE_FILE"
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
        # remove a trailing \ if needed
        sed -i '${s/\\$//}' "$RECIPE_FILE"

        if [[ "$line" != "channels:" ]]; then
          #echo "" >> "$RECIPE_FILE"
          echo "# $line" >> "$RECIPE_FILE"
        fi
        if [[ "$line" == *conda* ]]; then
          echo "${CONDA_ALIAS} install -y ${DEPS_CONDA} ${UPDATE_CONDA} \\" >> "$RECIPE_FILE"          
        fi      
        #if [[ "$line" == *languages* ]]; then
        #  echo "> \$CONDA_PREFIX/conda-meta/pinned" >> "$RECIPE_FILE"
        #fi      
    elif [[ -n "$CURRENT_SECTION" && "$line" == "-"* ]] || [[ "$CURRENT_SECTION" == "bash:"* ]]; then
        line="${line#- }"
        pkg_entry="${line%%#*}"  # remove comments
        pkg_entry="${pkg_entry## }"  # remove leading whitespace
        pkg_entry="${pkg_entry%% }"  # remove trailing whitespace
        # split the line to all the bits before the # and after

        IFS='@' read -r pkg src path <<< "$pkg_entry"
        IFS='=' read -r pkg_only ver <<< "$pkg"
        
        # For flags, parse directive and value from 'directive = value' format        
        if [[ "$CURRENT_SECTION" == "channels:"* ]]; then            
            continue
        elif [[ "$CURRENT_SECTION" == "flags:"* ]]; then
            #echo "[coble-recipise] Processing flag: $pkg_entry" >&2
            #directive="$(echo "$pkg_entry" | cut -d':' -f1 | xargs)"
            #value="$(echo "$pkg_entry" | cut -d':' -f2- | xargs)"
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
                #echo "export ${value}" >> "$RECIPE_FILE"
                echo "${CONDA_EXE} env config vars set ${value}" >> "$RECIPE_FILE"
                echo "${CONDA_EXE} deactivate" >> "$RECIPE_FILE"
                echo "${CONDA_EXE} activate ${ENV_INPUT}" >> "$RECIPE_FILE"
            elif [[ "${directive_lower}" == "alias" ]]; then                
                echo "# Flag: Directive: $directive, Value: $value_lower" >> "$RECIPE_FILE"             
                CONDA_ALIAS="$value"
            elif [[ "${directive_lower}" == "updates" && "$value_lower" == "true" ]]; then                
                echo "# Flag: Directive: $directive, Value: $value_lower" >> "$RECIPE_FILE"             
                UPDATE_CONDA=""                
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
            elif [[ "${directive_lower}" == "updates" && "$value_lower" == "true" ]]; then
                echo "# Flag: Directive: $directive, Value: $value_lower" >> "$RECIPE_FILE"             
                UPDATE_CONDA="--update-deps"
            elif [[ "${directive_lower}" == "updates" ]]; then
                echo "# Flag: Directive: $directive, Value: $value_lower" >> "$RECIPE_FILE"             
                UPDATE_CONDA="$value_lower"
            elif [[ "${directive_lower}" == "system-tools" && "${value_lower}" == "true" ]]; then                
                echo "" >> "$RECIPE_FILE"
                echo "# Including system dependencies for source installations" >> "$RECIPE_FILE"
                echo "# Essential shared packages" >> "$RECIPE_FILE"
                echo "${CONDA_ALIAS} install -y --no-update-deps -c conda-forge libcurl libprotobuf libpng libtiff libjpeg-turbo gdal proj geos gsl nlopt hdf5 cairo freetype expat fontconfig harfbuzz fribidi imagemagick" >>  "$RECIPE_FILE"
                if [[ $r_count -gt 0 ]]; then                
                    echo "# System r packages" >> "$RECIPE_FILE"
                    echo "${CONDA_ALIAS} install -y --no-update-deps -c conda-forge librsvg udunits2" >> "$RECIPE_FILE"
                    echo "# Essential r packages" >> "$RECIPE_FILE"
                    echo "${CONDA_ALIAS} install -y --no-update-deps -c conda-forge r-cpp11 r-openssl r-rsqlite r-essentials r-rsvg" >>  "$RECIPE_FILE"                    
                    echo "" >> "$RECIPE_FILE"            
                fi
                if [[ $python_count -gt 0 ]]; then
                    echo "# Essential python packages" >> "$RECIPE_FILE"                
                    echo "${CONDA_ALIAS} install -y --no-update-deps -c conda-forge cython protobuf" >> "$RECIPE_FILE"
                    echo "" >> "$RECIPE_FILE"            
                fi  
                # language build tools
                echo "# Language build tools" >> "$RECIPE_FILE"
                echo "${CONDA_ALIAS} install -y --no-update-deps -c conda-forge cmake pkg-config" >>  "$RECIPE_FILE"                    
                echo "# Language core system libraries" >> "$RECIPE_FILE"
                echo "${CONDA_ALIAS} install -y --no-update-deps -c conda-forge zlib bzip2 xz libxcrypt openssl sqlite" >> "$RECIPE_FILE"                                              
            elif [[ "${directive_lower}" == "compile-tools" ]]; then                
                # if compile-tools = true then add compiler installs
                # if a version is given use the specific version
                echo "" >> "$RECIPE_FILE"
                version="${value_lower}"
                if [[ "$version" == "false" ]]; then
                    echo "[coble-recipise] Not adding compile tools to recipe." >&2
                    continue
                fi
                if [[ "$version" == "true" ]]; then
                    echo "[coble-recipise] Adding default compile tools to recipe." >&2
                    echo "# Language compile tools" >> "$RECIPE_FILE"
                    echo "${CONDA_ALIAS} install -y --no-update-deps -c conda-forge gcc_linux-64 gxx_linux-64 gfortran_linux-64" >>  "$RECIPE_FILE"
                    echo "${CONDA_ALIAS} install -y --no-update-deps -c conda-forge sysroot_linux-64 c-compiler cxx-compiler" >>  "$RECIPE_FILE"
                elif [[ "$version" != "false" ]]; then
                    echo "[coble-recipise] Adding compile tools version $version to recipe." >&2
                    echo "# Language compile tools" >> "$RECIPE_FILE"
                    echo "${CONDA_ALIAS} install -y --no-update-deps -c conda-forge 'gcc_linux-64=$version' 'gxx_linux-64=$version' 'gfortran_linux-64=$version'" >>  "$RECIPE_FILE"                    
                    echo "${CONDA_ALIAS} install -y --no-update-deps -c conda-forge sysroot_linux-64 c-compiler cxx-compiler" >>  "$RECIPE_FILE"                    
                fi                                                
                # symlinks
                echo "# Set up compiler symlinks for R package compilation - COS6 compatibility" >> "$RECIPE_FILE"
                echo "umask 0022" >> "$RECIPE_FILE"
                echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc \$CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc" >> "$RECIPE_FILE"
                echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ \$CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++" >> "$RECIPE_FILE"
                echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran \$CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-gfortran" >> "$RECIPE_FILE"
                echo "# Set up compiler symlinks for R package compilation - standard aliases" >> "$RECIPE_FILE"
                echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc \$CONDA_PREFIX/bin/gcc" >> "$RECIPE_FILE"
                echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc \$CONDA_PREFIX/bin/cc" >> "$RECIPE_FILE"
                echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ \$CONDA_PREFIX/bin/g++" >> "$RECIPE_FILE"
                echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ \$CONDA_PREFIX/bin/c++" >> "$RECIPE_FILE"                                                
                # Add to your recipe file BEFORE running R installs
                echo "# Set compiler flags for R package compilation" >> "$RECIPE_FILE"                
                echo "${CONDA_EXE} env config vars set CC=\"$CONDA_PREFIX/bin/gcc\"" >> "$RECIPE_FILE"
                echo "${CONDA_EXE} env config vars set CXX=\"$CONDA_PREFIX/bin/g++\"" >> "$RECIPE_FILE"
                echo "${CONDA_EXE} env config vars set FC=\"$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran\"" >> "$RECIPE_FILE"
                echo "${CONDA_EXE} env config vars set F77=\"$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran\"" >> "$RECIPE_FILE"
                echo "${CONDA_EXE} env config vars set CFLAGS=\"-I\$CONDA_PREFIX/include\"" >> "$RECIPE_FILE"
                echo "${CONDA_EXE} env config vars set CXXFLAGS=\"-I\$CONDA_PREFIX/include\"" >> "$RECIPE_FILE"
                echo "${CONDA_EXE} env config vars set CPPFLAGS=\"-I\$CONDA_PREFIX/include\"" >> "$RECIPE_FILE"
                echo "${CONDA_EXE} env config vars set LDFLAGS=\"-L\$CONDA_PREFIX/lib -Wl,-rpath,\$CONDA_PREFIX/lib\"" >> "$RECIPE_FILE"    
                echo "${CONDA_EXE} deactivate" >> "$RECIPE_FILE"
                echo "${CONDA_EXE} activate ${ENV_INPUT}" >> "$RECIPE_FILE"
                
                
                echo "" >> "$RECIPE_FILE"              
            elif [[ "${directive_lower}" == "compile-paths" ]]; then                
                # only compile-paths no installs                
                echo "" >> "$RECIPE_FILE"
                version="${value_lower}"
                if [[ "$version" == "false" ]]; then
                    echo "[coble-recipise] Not adding compile paths to recipe." >&2
                    continue
                fi
                if [[ "$version" == "true" ]]; then
                    echo "[coble-recipise] Adding default compile paths to recipe." >&2                  
                    # symlinks
                    echo "# Set up compiler symlinks for R package compilation - COS6 compatibility" >> "$RECIPE_FILE"
                    echo "umask 0022" >> "$RECIPE_FILE"
                    echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc \$CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc" >> "$RECIPE_FILE"
                    echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ \$CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++" >> "$RECIPE_FILE"
                    echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran \$CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-gfortran" >> "$RECIPE_FILE"
                    echo "# Set up compiler symlinks for R package compilation - standard aliases" >> "$RECIPE_FILE"
                    echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc \$CONDA_PREFIX/bin/gcc" >> "$RECIPE_FILE"
                    echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc \$CONDA_PREFIX/bin/cc" >> "$RECIPE_FILE"
                    echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ \$CONDA_PREFIX/bin/g++" >> "$RECIPE_FILE"
                    echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ \$CONDA_PREFIX/bin/c++" >> "$RECIPE_FILE"                                                
                    # Add to your recipe file BEFORE running R installs
                    echo "# Set compiler flags for R package compilation" >> "$RECIPE_FILE"                

                    echo "${CONDA_EXE} env config vars set CC=\"$CONDA_PREFIX/bin/gcc\"" >> "$RECIPE_FILE"
                    echo "${CONDA_EXE} env config vars set CXX=\"$CONDA_PREFIX/bin/g++\"" >> "$RECIPE_FILE"
                    echo "${CONDA_EXE} env config vars set FC=\"$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran\"" >> "$RECIPE_FILE"
                    echo "${CONDA_EXE} env config vars set F77=\"$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran\"" >> "$RECIPE_FILE"                    
                    echo "${CONDA_EXE} env config vars set CFLAGS=\"-I\$CONDA_PREFIX/include\"" >> "$RECIPE_FILE"
                    echo "${CONDA_EXE} env config vars set CXXFLAGS=\"-I\$CONDA_PREFIX/include\"" >> "$RECIPE_FILE"
                    echo "${CONDA_EXE} env config vars set CPPFLAGS=\"-I\$CONDA_PREFIX/include\"" >> "$RECIPE_FILE"
                    echo "${CONDA_EXE} env config vars set LDFLAGS=\"-L\$CONDA_PREFIX/lib -Wl,-rpath,\$CONDA_PREFIX/lib\"" >> "$RECIPE_FILE"                                
                    echo "${CONDA_EXE} deactivate" >> "$RECIPE_FILE"
                    echo "${CONDA_EXE} activate ${ENV_INPUT}" >> "$RECIPE_FILE"
                    echo "" >> "$RECIPE_FILE"
                fi
            fi
        elif [[ "$CURRENT_SECTION" == "languages:"* ]]; then    
            # trim whitespace from src
            src="${src## }"    # remove leading spaces
            src="${src%% }"    # remove trailing spaces
            pkg_only="${pkg_only## }"
            pkg_only="${pkg_only%% }"            
            if [[ "$pkg_only" == *"no-deps"* ]]; then
                DEPS_CONDA="--no-deps"
            elif [[ "$pkg_only" == "r-base" ]]; then                    
                if [[ "$src" == "" ]]; then
                    echo "${CONDA_ALIAS} install -y ${DEPS_CONDA} '$pkg' r-remotes r-biocmanager" >> "$RECIPE_FILE"
                else                    
                    echo "${CONDA_ALIAS} install -y ${DEPS_CONDA} -c $src '$pkg' r-remotes r-biocmanager" >> "$RECIPE_FILE"
                fi
                #echo "echo 'r-base ==$ver.*' >> \$CONDA_PREFIX/conda-meta/pinned" >> "$RECIPE_FILE"
            elif [[ "$pkg_only" == "python" ]]; then                                    
                if [[ "$src" == "" ]]; then
                    echo "${CONDA_ALIAS} install -y ${DEPS_CONDA} '$pkg'" >> "$RECIPE_FILE"
                else                    
                    echo "${CONDA_ALIAS} install -y ${DEPS_CONDA} '$src::$pkg'" >> "$RECIPE_FILE"
                fi
                echo "python -m site" >> "$RECIPE_FILE"
                echo "${CONDA_EXE} env config vars set PYTHONNOUSERSITE=1" >> "$RECIPE_FILE"
                echo "${CONDA_EXE} deactivate" >> "$RECIPE_FILE"
                echo "${CONDA_EXE} activate ${ENV_INPUT}" >> "$RECIPE_FILE"
                #echo "echo 'python ==$ver.*' >> \$CONDA_PREFIX/conda-meta/pinned" >> "$RECIPE_FILE"
            fi            
        elif [[ "$CURRENT_SECTION" == "conda-r:"* || "$CURRENT_SECTION" == "r-conda:"*  ]]; then            
            if [[ "$src" != "" ]]; then
                echo "'$src::r-$pkg' \\" >> "$RECIPE_FILE"
            else
                echo "'r-$pkg' \\" >> "$RECIPE_FILE"
            fi                        
        elif [[ "$CURRENT_SECTION" == "conda-bioc:"* || "$CURRENT_SECTION" == "bioc-conda:"*  ]]; then                        
            #echo "conda install -y -c conda-forge -c bioconda 'bioconductor-$pkg' $DEPS_CONDA $UPDATE_CONDA" >> "$RECIPE_FILE"
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
                echo "Rscript -e 'remotes::install_version(\"$pkg_only\", version=\"$ver\", repos=\"https://cloud.r-project.org\", dependencies=$DEPS_R, Ncpus=$NCPUS, upgrade=\"never\")'" >> "$RECIPE_FILE"            
            elif [[ "$src" == "r-forge"* ]]; then
                echo "Rscript -e 'install.packages(\"${pkg_only}\", repos=\"https://R-Forge.R-project.org\", dependencies=$DEPS_R, Ncpus=$NCPUS)'" >> "$RECIPE_FILE"
            else
                echo "Rscript -e 'install.packages(\"${pkg_only}\", repos=\"https://cloud.r-project.org\", dependencies=$DEPS_R, Ncpus=$NCPUS)'" >> "$RECIPE_FILE"
            fi
        elif [[ "$CURRENT_SECTION" == "r-github:"* || "$CURRENT_SECTION" == "github-r:"* ]]; then
            if [[ -n "$src" ]]; then
                echo "Rscript -e 'remotes::install_github(\"$pkg_only\", dependencies=$DEPS_R, subdir=\"$src\", Ncpus=$NCPUS)'" >> "$RECIPE_FILE"
            else
                echo "Rscript -e 'remotes::install_github(\"$pkg_entry\", dependencies=$DEPS_R, Ncpus=$NCPUS)'" >> "$RECIPE_FILE"
            fi
        elif [[ "$CURRENT_SECTION" == "r-url:"* ]]; then
            if [[ -n "$src" ]]; then
                echo "Rscript -e 'remotes::install_url(\"$pkg_only\", dependencies=$DEPS_R, subdir=\"$src\", Ncpus=$NCPUS)'" >> "$RECIPE_FILE"
            else
                echo "Rscript -e 'remotes::install_url(\"$pkg_entry\", dependencies=$DEPS_R, Ncpus=$NCPUS)'" >> "$RECIPE_FILE"
            fi

        elif [[ "$CURRENT_SECTION" == "package-bioc:"* || "$CURRENT_SECTION" == "bioc-package:"* ]]; then
            echo "Rscript -e 'BiocManager::install(\"${pkg_only}\", dependencies=$DEPS_R, Ncpus=$NCPUS)'" >> "$RECIPE_FILE"
        elif [[ "$CURRENT_SECTION" == "pip:"* ]]; then
            pip_pkg="$pkg"
            # If the package name contains 'https' and does not start with 'git', prepend 'git+'
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
            # Preserve literal \n in bash commands
            echo "${line//\\n/\\\\n}" >> "$RECIPE_FILE"
        elif [[ "$CURRENT_SECTION" == "find:"* ]]; then
            echo "[coble-recipise] Finding: $pkg_only, version: $ver, source: $src" >&2
            script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
            # Build arguments array
            find_args=(--pkg "$pkg_only" --version "$ver")
            # Call and capture return value
            mapfile -t result < <("$script_dir/coble-find.sh" "${find_args[@]}")
            pkg_manager="${result[0]}"
            recipe_line="${result[1]}"
            yaml_line="${result[2]}"
            if [[ $pkg_manager == "unknown" ]]; then
                echo "[coble-resolve] Unknown: $line" >&2
                echo "# Unknown package: $line" >> "$RECIPE_FILE"
            else            
                # Use the return value
                #echo "[coble-resolve] Manager: $pkg_manager" >&2
                #echo "[coble-resolve] Recipe: $recipe_line" >&2
                #echo "[coble-resolve] Yaml: $yaml_line" >&2                                
                echo "${recipe_line}" >> "$RECIPE_FILE"                              
            fi
        fi
    else                                
        # remove a trailing \ if needed
        sed -i '${s/\\$//}' "$RECIPE_FILE"
        # if it is a comment
        if [[ "$line" == \#* ]]; then            
            echo "$line" >> "$RECIPE_FILE"
        # if line is a space we preserve it
        elif [[ -z "$line" ]]; then
            echo "" >> "$RECIPE_FILE"        
        fi
    fi
done < "$YAML_FILE"
# remove a trailing \ if needed
sed -i '${s/\\$//}' "$RECIPE_FILE"

echo "[coble-recipise] Recipe generation complete: $RECIPE_FILE" >&2
echo "" >> "$RECIPE_FILE"
echo "Y"
echo "$RECIPE_FILE"





