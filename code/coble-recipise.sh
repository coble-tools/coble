#!/usr/bin/env bash

# Turn a captured yaml file into a coble recipe script

##############
#mapfile -t result < <("$script_dir/coble-recipise.sh --input YAML_FILE --output RECIPE --env ENV")
#success="${result[0]}"
#recipe_file="${result[1]}"            
##############
# Inputs ----
# 1. --input yamlfile
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

echo "[coble-recipise] Starting recipise process..." >&2

# Parse named arguments
show_help() {
    echo "----- coble recipise help ----------"
    echo "Usage: $0 [--env ENV] [--input YAML_FILE] [--output RECIPE] [--outdir OUTDIR]"
    echo "  --env ENV        Specify conda environment name or prefix (optional)"
    echo "  --input YAML     Specify input YAML file (optional, default: ./coble-capture.yml)"
    echo "  --output RECIPE  Specify output recipe file (optional, default: ./coble-reciped-reproduce.sh)"
    echo "  --outdir OUTDIR  Specify output directory for recipe file (optional, default: .)"
    echo "  -h, --help       Show this help message and exit"
}

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --env)
            ENV_INPUT="$2"
            shift; shift
            ;;
        --input)
            YAML_FILE="$2"
            shift; shift
            ;;
        --output)
            RECIPE_FILE="$2"
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
    echo "Error: YAML file not found: $YAML_FILE" >&2
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
    RECIPE_FILE="$YAML_FILE".recipe.sh
fi
: > "$RECIPE_FILE"

# Now show all the inputs
echo "[coble-recipise] Using inputs:" >&2
echo "  ENV_INPUT: $ENV_INPUT" >&2
echo "  YAML_FILE: $YAML_FILE" >&2
echo "  RECIPE_FILE: $RECIPE_FILE" >&2

UPDATE_CONDA="--no-update-deps"
NCPUS="4"
DEPS_CONDA=""
DEPS_PYTHON=""
DEPS_R="TRUE"


# output is a recipe file for conda env create (always in current directory)
echo "[coble-recipise] Recipising conda environment from coble yaml file $YAML_FILE" >&2
echo "[coble-recipise] Recipising conda environment to recipe file $RECIPE_FILE" >&2

# Clear the aggregate file at the start
{
	echo "#!/usr/bin/env bash"
    echo ""
    echo "#####################################################"
    echo -e "# COBLE:recipe, (c) ICR 2025"    
    CAPTURE_DATE=$(date '+%Y-%m-%d')
	CAPTURE_TIME=$(date '+%H:%M:%S %Z')
	CAPTURE_USER=$(whoami)	
	echo -e "# Capture date: $CAPTURE_DATE"
	echo -e "# Capture time: $CAPTURE_TIME"
	echo -e "# Captured by: $CAPTURE_USER"
    echo "#####################################################"
    echo -e "# source bashrc for conda"
    echo -e "source \"\$(conda info --base)/etc/profile.d/conda.sh\""
    echo -e "source ~/.bashrc"
    echo "#####################################################"
    echo ""
    #echo "CONDA_ENV='$CONDA_ENV' # Change this value to your desired conda environment name or prefix"
    echo ""
} > "$RECIPE_FILE"

################# WE PASS THROUGH A FEW TIMES FOR DIFFERENT REASONS #################

### 01 Language checking checking ########################################
languages_line="conda create ${CONDA_ENV} -y"
CURRENT_SECTION="bash"
r_count=0
python_count=0
while IFS= read -r line; do
    # Trim leading/trailing whitespace
    line="$(echo -e "${line}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    if [[ "$line" == "languages:" ]]; then
        CURRENT_SECTION="languages"
    elif [[ "$line" == "channels:" ]]; then
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
echo "$languages_line" >> "$RECIPE_FILE"
echo "conda activate ${ENV_INPUT}" >> "$RECIPE_FILE"
echo "" >> "$RECIPE_FILE"

echo "[coble-recipise] Clearing default channels." >&2      
echo "# Channels section" >> "$RECIPE_FILE"
echo "conda config --env --remove-key channels" >> "$RECIPE_FILE"
echo "conda config --env --set channel_priority strict" >> "$RECIPE_FILE"

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

### 02 CHANNEL CHecking ########################################
CURRENT_SECTION=""
while IFS= read -r line; do
    # Trim leading/trailing whitespace
    line="$(echo -e "${line}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    if [[ "$line" == "channels:" ]]; then
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
        echo "conda config --env --add channels $channel_name" >> "$RECIPE_FILE"
    fi
done < "$YAML_FILE"

### 02 MAIN TRANSLATION ###
echo "" >> "$RECIPE_FILE"
echo "# INSTALL SECTION FOR CONDA" >> "$RECIPE_FILE"
CURRENT_SECTION=""
while IFS= read -r line || [[ -n "$line" ]]; do
    # Trim leading/trailing whitespace
    line="$(echo -e "${line}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"    
    if [[ "$line" == "flags:" \
        || "$line" == "channels:" \
        || "$line" == "languages:" \
        || "$line" == "conda-r:" \
        || "$line" == "r-conda:" \
        || "$line" == "conda-bioc:" \
        || "$line" == "bioc-conda:" \
        || "$line" == "conda:" \
        || "$line" == "r-package:" \
        || "$line" == "package-r:" \
        || "$line" == "r-github:" \
        || "$line" == "r-url:" \
        || "$line" == "pip:" \
        || "$line" == "bash:" \
        || "$line" == "find:" \
        || "$line" == "bioc-package:" \
        || "$line" == "package-bioc:" ]]; then
        CURRENT_SECTION="$line"
        echo "[conda-recipise] Package manager changing to: $CURRENT_SECTION" >&2  
        # remove a trailing \ if needed
        sed -i '${s/\\$//}' "$RECIPE_FILE"

        if [[ "$line" != "channels:" ]]; then
          #echo "" >> "$RECIPE_FILE"
          echo "# $line" >> "$RECIPE_FILE"
        fi
        if [[ "$line" == *conda* ]]; then
          echo "conda install -y $DEPS_CONDA $UPDATE_CONDA \\" >> "$RECIPE_FILE"
        fi      
        #if [[ "$line" == *languages* ]]; then
        #  echo "> \$CONDA_PREFIX/conda-meta/pinned" >> "$RECIPE_FILE"
        #fi      
    elif [[ -n "$CURRENT_SECTION" && "$line" == "-"* ]]; then
        pkg_entry="${line#- }"
        #echo "[conda-recipise] Processing entry: $pkg_entry" >&2
        IFS='@' read -r pkg src path <<< "$pkg_entry"
        IFS='=' read -r pkg_only ver <<< "$pkg"
        # For flags, parse directive and value from 'directive = value' format        
        if [[ "$CURRENT_SECTION" == "channels:"  ]]; then            
            continue
        elif [[ "$CURRENT_SECTION" == "flags:" ]]; then
            echo "[conda-recipise] Processing flag: $pkg_entry" >&2
            directive="$(echo "$pkg_entry" | cut -d':' -f1 | xargs)"
            value="$(echo "$pkg_entry" | cut -d':' -f2- | xargs)"            
            value=$(echo "$value" | tr '[:upper:]' '[:lower:]')
            echo "[conda-recipise] Directive: $directive, Value: $value" >&2    
            echo "# Flag: Directive: $directive, Value: $value" >> "$RECIPE_FILE"             
            if [[ "$directive,," == "dependencies" && "$value,," == "true" ]]; then                
                echo "[conda-recipise] (default) Will install dependencies" >&2
                DEPS_CONDA=""
                DEPS_PYTHON=""
                DEPS_R="TRUE"
            elif [[ "${directive,,}" == "dependencies" && "$value,," == "false" ]]; then                
                echo "[conda-recipise] (!not default) Will NOT install dependencies" >&2
                DEPS_CONDA="--no-deps"
                DEPS_PYTHON="--no-deps"
                DEPS_R="FALSE"            
            elif [[ "${directive,,}" == "updates" && "$value,," == "true" ]]; then
                echo "[conda-recipise] (! NOT default) Will update dependencies (not base languages)" >&2
                UPDATE_CONDA=""                
            elif [[ "${directive,,}" == "ncpus" ]]; then
                echo "[conda-recipise] Ncpus specified as $value" >&2
                NCPUS="$value"
                echo "[conda-recipise] = $NCPUS" >&2
            elif [[ "${directive,,}" == "updates" && "$value,," == "false" ]]; then                
                echo "[conda-recipise] (default) Will not update dependencies" >&2
                UPDATE_CONDA="--no-update-deps"                
            elif [[ "${directive,,}" == "build-tools" && "${value,,}" == "true" ]]; then
                echo "[conda-recipise] Build-tools will be included" >&2
                echo "" >> "$RECIPE_FILE"
                echo "# Including build tools for source installations" >> "$RECIPE_FILE"
                if [[ $r_count -gt 0 ]]; then                
                    echo "# Essential r packages" >> "$RECIPE_FILE"
                    echo "conda install -y --no-update-deps -c conda-forge r-cpp11 r-openssl r-rsqlite r-remotes r-biocmanager r-essentials" >>  "$RECIPE_FILE"                                        
                    echo "# Essential r geo-spatial libraries" >> "$RECIPE_FILE"
                    echo "conda install -y --no-update-deps -c conda-forge gdal proj geos" >>  "$RECIPE_FILE"                                        
                    echo "# Essential r mathematical libraries" >> "$RECIPE_FILE"
                    echo "conda install -y --no-update-deps -c conda-forge gsl nlopt udunits2 hdf5" >>  "$RECIPE_FILE"                                        
                    echo "# Essential r image libraries" >> "$RECIPE_FILE"
                    echo "conda install -y --no-update-deps -c conda-forge libpng libtiff libjpeg-turbo librsvg r-rsvg imagemagick cairo freetype expat fontconfig harfbuzz fribidi" >>  "$RECIPE_FILE"                    
                fi
                if [[ $python_count -gt 0 ]]; then
                    echo "# Essential python packages" >> "$RECIPE_FILE"                
                    echo "conda install -y --no-update-deps -c conda-forge cython" >> "$RECIPE_FILE"
                fi
                echo "# Language compile tools" >> "$RECIPE_FILE"
                echo "conda install -y --no-update-deps -c conda-forge sysroot_linux-64 gcc_linux-64 gxx_linux-64 gfortran_linux-64 c-compiler cxx-compiler" >>  "$RECIPE_FILE"                    
                echo "# Language build tools" >> "$RECIPE_FILE"
                echo "conda install -y --no-update-deps -c conda-forge cmake pkg-config" >>  "$RECIPE_FILE"                    
                echo "# Language core system libraries" >> "$RECIPE_FILE"
                echo "conda install -y --no-update-deps -c conda-forge zlib bzip2 xz libxcrypt openssl sqlite" >> "$RECIPE_FILE"
                echo "# Language XML/data libraries" >> "$RECIPE_FILE"
                echo "conda install -y --no-update-deps -c conda-forge 'libxml2>=2.12,<2.15' libcurl protobuf libprotobuf" >>  "$RECIPE_FILE"
                
                echo "# Set up compiler symlinks for R package compilation - COS6 compatibility" >> "$RECIPE_FILE"
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
                #echo "export CFLAGS=\"-I\$CONDA_PREFIX/include -Wno-error=incompatible-pointer-types\"" >> "$RECIPE_FILE"
                echo "export CFLAGS=\"-I\$CONDA_PREFIX/include\"" >> "$RECIPE_FILE"
                echo "export CXXFLAGS=\"-I\$CONDA_PREFIX/include\"" >> "$RECIPE_FILE"
                echo "export CPPFLAGS=\"-I\$CONDA_PREFIX/include\"" >> "$RECIPE_FILE"
                echo "export LDFLAGS=\"-L\$CONDA_PREFIX/lib -Wl,-rpath,\$CONDA_PREFIX/lib\"" >> "$RECIPE_FILE"                
                #echo "export XML_CONFIG=\"pkg-config libxml-2.0\"" >> "$RECIPE_FILE"
                echo "" >> "$RECIPE_FILE"
            fi        
        elif [[ "$CURRENT_SECTION" == "languages:"  ]]; then                                                
            if [[ "$pkg_only" == "r-base" ]]; then                    
                if [[ "$src" == "" ]]; then
                    echo "conda install -y '$pkg'" >> "$RECIPE_FILE"
                else                    
                    echo "conda install -y -c $src '$pkg'" >> "$RECIPE_FILE"
                fi
                #echo "echo 'r-base ==$ver.*' >> \$CONDA_PREFIX/conda-meta/pinned" >> "$RECIPE_FILE"
            elif [[ "$pkg_only" == "python" ]]; then                    
                if [[ "$src" == "" ]]; then
                    echo "conda install -y '$pkg'" >> "$RECIPE_FILE"                
                else                    
                    echo "conda install -y '$src::$pkg'" >> "$RECIPE_FILE"
                fi
                #echo "echo 'python ==$ver.*' >> \$CONDA_PREFIX/conda-meta/pinned" >> "$RECIPE_FILE"
            fi            
        elif [[ "$CURRENT_SECTION" == "conda-r:" || "$CURRENT_SECTION" == "r-conda:"  ]]; then            
            if [[ "$src" != "" ]]; then
                echo "'$src::r-$pkg' \\" >> "$RECIPE_FILE"
            else
                echo "'r-$pkg' \\" >> "$RECIPE_FILE"
            fi                        
        elif [[ "$CURRENT_SECTION" == "conda-bioc:" || "$CURRENT_SECTION" == "bioc-conda:"  ]]; then                        
            #echo "conda install -y -c conda-forge -c bioconda 'bioconductor-$pkg' $DEPS_CONDA $UPDATE_CONDA" >> "$RECIPE_FILE"
            if [[ "$src" != "" ]]; then
                echo "'$src::bioconductor-$pkg' \\" >> "$RECIPE_FILE"
            else
                echo "'bioconductor-$pkg' \\" >> "$RECIPE_FILE"
            fi                                    
        elif [[  "$CURRENT_SECTION" == "conda:" ]]; then            
            if [[ "$src" != "" ]]; then
                echo "'$src::$pkg' \\" >> "$RECIPE_FILE"
            else
                echo "'$pkg' \\" >> "$RECIPE_FILE"
            fi                                                            
        elif [[ "$CURRENT_SECTION" == "package-r:" || "$CURRENT_SECTION" == "r-package:" ]]; then            
            echo "[conda-recipise] Processing R package: $pkg_only, version: $ver, source: $src ncpus:$NCPUS" >&2
            if [[ -n "$ver" && ( -z "$src" || "$src" == "CRAN"* ) ]]; then
                echo "Rscript -e 'remotes::install_version(\"$pkg_only\", version=\"$ver\", repos=\"https://cloud.r-project.org\", dependencies=$DEPS_R, Ncpus=$NCPUS)'" >> "$RECIPE_FILE"            
            elif [[ "$src" == "r-forge"* ]]; then
                echo "Rscript -e 'install.packages(\"${pkg_only}\", repos=\"https://R-Forge.R-project.org\", dependencies=$DEPS_R, Ncpus=$NCPUS)'" >> "$RECIPE_FILE"
            else
                echo "Rscript -e 'install.packages(\"${pkg_only}\", repos=\"https://cloud.r-project.org\", dependencies=$DEPS_R, Ncpus=$NCPUS)'" >> "$RECIPE_FILE"
            fi
        elif [[ "$CURRENT_SECTION" == "r-github:" || "$CURRENT_SECTION" == "github-r:" ]]; then            
            echo "Rscript -e 'devtools::install_github(\"$pkg_entry\", dependencies=$DEPS_R, Ncpus=$NCPUS)'" >> "$RECIPE_FILE"
        elif [[ "$CURRENT_SECTION" == "r-url:" ]]; then            
            if [[ -n "$src" ]]; then
                echo "Rscript -e 'remotes::install_url(\"$pkg_entry\", dependencies=$DEPS_R, subdir=$src, Ncpus=$NCPUS)'" >> "$RECIPE_FILE"
            else
                echo "Rscript -e 'remotes::install_url(\"$pkg_entry\", dependencies=$DEPS_R, Ncpus=$NCPUS)'" >> "$RECIPE_FILE"
            fi
            
        elif [[ "$CURRENT_SECTION" == "package-bioc:" || "$CURRENT_SECTION" == "bioc-package:" ]]; then            
            echo "Rscript -e 'BiocManager::install(\"${pkg_only}\", dependencies=$DEPS_R, Ncpus=$NCPUS)'" >> "$RECIPE_FILE"
        elif [[ "$CURRENT_SECTION" == "pip:" ]]; then                                       
            echo "[conda-recipise] Processing pip package: $pkg_only, version: $ver" >&2
            pip_pkg="$pkg"
            # If the package name contains 'https' and does not start with 'git', prepend 'git+'
            if [[ "$pip_pkg" == https* && "$pip_pkg" != git+* ]]; then
                pip_pkg="git+$pip_pkg"
            fi            
            echo "python -m pip install '${pip_pkg}' $DEPS_PYTHON" >> "$RECIPE_FILE"                        
        elif [[ "$CURRENT_SECTION" == "bash:" ]]; then
            echo "[conda-recipise] Adding bash command: $pkg_entry" >&2
            echo "$pkg_entry" >> "$RECIPE_FILE"        
        elif [[ "$CURRENT_SECTION" == "find:" ]]; then
            echo "[conda-recipise] Finding: $pkg_only, version: $ver, source: $src" >&2
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
                echo "[coble-resolve] Manager: $pkg_manager" >&2
                echo "[coble-resolve] Recipe: $recipe_line" >&2
                echo "[coble-resolve] Yaml: $yaml_line" >&2                                
                echo "${recipe_line}" >> "$RECIPE_FILE"                              
            fi
        fi
    else                                
        # remove a trailing \ if needed
        sed -i '${s/\\$//}' "$RECIPE_FILE"
        # if it is a comment
        if [[ "$line" == \#* ]]; then
            #echo "[conda-recipise] Transferring comment: $line" >&2
            echo "$line" >> "$RECIPE_FILE"
        # if line is a space we preserve it
        elif [[ -z "$line" ]]; then
            echo "" >> "$RECIPE_FILE"        
        fi
    fi
done < "$YAML_FILE"
# remove a trailing \ if needed
sed -i '${s/\\$//}' "$RECIPE_FILE"

echo "[conda-recipise] Recipe generation complete: $RECIPE_FILE" >&2
echo "" >> "$RECIPE_FILE"
echo "Y"
echo "$RECIPE_FILE"





