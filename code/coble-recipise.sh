#!/usr/bin/env bash
# Turn a captured yaml file into a coble recipe script


# Usage: ./coble-recipise.sh [--env ENV] [--input YAML_FILE] [--output RECIPE]

# Default values

ENV_INPUT="coble"
YAML_FILE=""
RECIPE_FILE=""
ENV_NAME=""
OUTDIR="."

# Parse named arguments
show_help() {
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
echo "[coble-recipise] Using inputs:"
echo "  ENV_INPUT: $ENV_INPUT"
echo "  YAML_FILE: $YAML_FILE"
echo "  RECIPE_FILE: $RECIPE_FILE"


if [[ -z "$YAML_FILE" || ! -f "$YAML_FILE" ]]; then
    echo "Error: YAML file not found: $YAML_FILE"
    exit 1
fi

UPDATE_CONDA="--no-update-deps"
DEPS_CONDA=""
DEPS_PYTHON=""
DEPS_R="TRUE"


# output is a recipe file for conda env create (always in current directory)
echo "[coble-recipise] Recipising conda environment from coble yaml file $YAML_FILE"
echo "[coble-recipise] Recipising conda environment to recipe file $RECIPE_FILE"

# Clear the aggregate file at the start
{
	echo "#!/usr/bin/env bash"
    echo ""
    echo "#######################################"
    echo -e "# COBLE:Reproducible environment recipe, (c) ICR 2025"    
    CAPTURE_DATE=$(date '+%Y-%m-%d')
	CAPTURE_TIME=$(date '+%H:%M:%S %Z')
	CAPTURE_USER=$(whoami)	
	echo -e "# Capture date: $CAPTURE_DATE"
	echo -e "# Capture time: $CAPTURE_TIME"
	echo -e "# Captured by: $CAPTURE_USER"
    echo "#######################################"
    echo -e "# source bashrc for conda"
    echo -e "source \"\$(conda info --base)/etc/profile.d/conda.sh\""
    echo -e "source ~/.bashrc"
    echo "#######################################"
    echo ""
    #echo "CONDA_ENV='$CONDA_ENV' # Change this value to your desired conda environment name or prefix"
    echo ""
} > "$RECIPE_FILE"
# We first want to go through and find the "languages"
# the languages: section, we just want to pull out the conda and r packages
# then we can build a conda create command
languages_line="conda create ${CONDA_ENV} -y"
CURRENT_SECTION="bash"
#while IFS= read -r line; do
#    # Trim leading/trailing whitespace
#    line="$(echo -e "${line}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
#    if [[ "$line" == "languages:" ]]; then
#        CURRENT_SECTION="languages"
#    elif [[ "$line" == "channels:" ]]; then
#        CURRENT_SECTION="channels"          
#    elif [[ -z "$line" ]]; then
#        CURRENT_SECTION=""
#    elif [[ "$CURRENT_SECTION" == "languages" && "$line" == "-"* ]]; then
#        languages_line+=" '${line#- }'"        
#    fi
#done < "$YAML_FILE"
echo "$languages_line" >> "$RECIPE_FILE"
echo "conda activate ${ENV_INPUT}" >> "$RECIPE_FILE"
echo "" >> "$RECIPE_FILE"

echo "[coble-recipise] Clearing default channels."      
echo "# Channels section" >> "$RECIPE_FILE"
echo "conda config --remove-key channels" >> "$RECIPE_FILE"

################# WE PASS THROUGH A FEW TIMES FOR DIFFERENT REASONS #################
### 01 CHANNEL CHecking ###
CURRENT_SECTION=""
while IFS= read -r line; do
    # Trim leading/trailing whitespace
    line="$(echo -e "${line}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    if [[ "$line" == "channels:" ]]; then
        CURRENT_SECTION="channels"
    elif [[ -z "$line" ]]; then
        CURRENT_SECTION=""
    elif [[ "$CURRENT_SECTION" == "channels" && "$line" == "-"* ]]; then
        # remove trailing and leading white space
        channel_name="$(echo -e "${line#- }" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
        echo "[coble-recipise] Adding channel: $channel_name"
        echo "conda config --add channels $channel_name" >> "$RECIPE_FILE"
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
        || "$line" == "conda-bioc:" \
        || "$line" == "conda:" \
        || "$line" == "r-package:" \
        || "$line" == "r-github:" \
        || "$line" == "r-url:" \
        || "$line" == "package-r:" \
        || "$line" == "pip:" \
        || "$line" == "bash:" \
        || "$line" == "find:" \
        || "$line" == "package-bioc:" ]]; then
        CURRENT_SECTION="$line"
        echo "[conda-recipise] Package manager changing to: $CURRENT_SECTION"  
        # remove a trailing \ if needed
        sed -i '${s/\\$//}' "$RECIPE_FILE"

        if [[ "$line" != "channels:" ]]; then
          echo "" >> "$RECIPE_FILE"
          echo "# $line" >> "$RECIPE_FILE"
        fi
        if [[ "$line" == conda* ]]; then
          echo "conda install -y -c conda-forge -c bioconda $DEPS_CONDA $UPDATE_CONDA \\" >> "$RECIPE_FILE"
        fi      
    elif [[ -n "$CURRENT_SECTION" && "$line" == "-"* ]]; then
        pkg_entry="${line#- }"
        echo "[conda-recipise] Processing entry: $pkg_entry"
        IFS='@' read -r pkg src path <<< "$pkg_entry"
        IFS='=' read -r pkg_name ver <<< "$pkg"
        # For flags, parse directive and value from 'directive = value' format        
        if [[ "$CURRENT_SECTION" == "channels:"  ]]; then            
            continue
        elif [[ "$CURRENT_SECTION" == "languages:"  ]]; then                        
            if [[ "$pkg_name" == "r-base" ]]; then                    
                if [[ "$src" == "" ]]; then
                    echo "conda install -y '$pkg_name=$ver'" >> "$RECIPE_FILE"
                else                    
                    echo "conda install -y -c $src '$pkg_name=$ver'" >> "$RECIPE_FILE"
                fi                
            elif [[ "$pkg_name" == "python" ]]; then                    
                if [[ "$src" == "" ]]; then
                    echo "conda install -y '$pkg_name=$ver'" >> "$RECIPE_FILE"                
                else                    
                    echo "conda install -y -c $src '$pkg_name=$ver'" >> "$RECIPE_FILE"
                fi                
            fi            
        elif [[ "$CURRENT_SECTION" == "conda-r:"  ]]; then            
            if [[ "$src" == "" ]]; then
                src="conda-forge"
            elif [[ "$src" != "conda-forge" ]]; then
                src="conda-forge -c $src"
            fi
            #echo "conda install -y -c $src 'r-$pkg' $DEPS_CONDA $UPDATE_CONDA" >> "$RECIPE_FILE"
            echo "'r-$pkg' \\" >> "$RECIPE_FILE"
        elif [[ "$CURRENT_SECTION" == "conda-bioc:"  ]]; then                        
            #echo "conda install -y -c conda-forge -c bioconda 'bioconductor-$pkg' $DEPS_CONDA $UPDATE_CONDA" >> "$RECIPE_FILE"
            echo "'bioconductor-$pkg' \\" >> "$RECIPE_FILE"
        elif [[  "$CURRENT_SECTION" == "conda:" ]]; then            
            if [[ "$src" == "" ]]; then
                src="conda-forge"
            elif [[ "$src" != "conda-forge" ]]; then
                src="conda-forge -c $src"
            fi
            #echo "conda install -y -c $src '$pkg' $DEPS_CONDA $UPDATE_CONDA" >> "$RECIPE_FILE"        
             echo "'$pkg' \\" >> "$RECIPE_FILE"
        elif [[ "$CURRENT_SECTION" == "package-r:" ]]; then            
            echo "[conda-recipise] Processing R package: $pkg_name, version: $ver, source: $src"
            if [[ -n "$ver" && ( -z "$src" || "$src" == "CRAN"* ) ]]; then                
                echo "Rscript -e 'remotes::install_version(\"$pkg_name\", version=\"$ver\", repos=\"https://cloud.r-project.org\", dependencies=$DEPS_R)'"                
            elif [[ "$src" == "R-FORGE"* ]]; then
                echo "Rscript -e 'install.packages(\"${pkg_name}\", repos=\"https://R-Forge.R-project.org\", dependencies=$DEPS_R)'" >> "$RECIPE_FILE"
            else
                echo "Rscript -e 'install.packages(\"${pkg_name}\", repos=\"https://cloud.r-project.org\", dependencies=$DEPS_R)'" >> "$RECIPE_FILE"
            fi
        elif [[ "$CURRENT_SECTION" == "r-github:" ]]; then            
            echo "Rscript -e 'devtools::install_github(\"$path\", dependencies=$DEPS_R)'" >> "$RECIPE_FILE"
        elif [[ "$CURRENT_SECTION" == "r-url:" ]]; then            
            echo "Rscript -e 'remotes::install_url(\"$pkg_entry\", dependencies=$DEPS_R)'" >> "$RECIPE_FILE"
        elif [[ "$CURRENT_SECTION" == "package-bioc:" ]]; then            
            echo "Rscript -e 'BiocManager::install(\"${pkg%%=*}\", dependencies=$DEPS_R)'" >> "$RECIPE_FILE"
        elif [[ "$CURRENT_SECTION" == "pip:" ]]; then                                       
            echo "[conda-recipise] Processing pip package: $pkg_name, version: $ver"
            if [[ -n "$ver" ]]; then
                echo "python -m pip install '${pkg_name}==${ver}' $DEPS_PYTHON" >> "$RECIPE_FILE"
            else
                echo "python -m pip install ${pkg_name} $DEPS_PYTHON" >> "$RECIPE_FILE"
            fi        
        elif [[ "$CURRENT_SECTION" == "bash:" ]]; then
            echo "[conda-recipise] Adding bash command: $pkg_entry"
            echo "$pkg_entry" >> "$RECIPE_FILE"
        elif [[ "$CURRENT_SECTION" == "flags:" ]]; then
            echo "[conda-recipise] Processing flag: $pkg_entry"
            directive="$(echo "$pkg_entry" | cut -d':' -f1 | xargs)"
            value="$(echo "$pkg_entry" | cut -d':' -f2- | xargs)"            
            value=$(echo "$value" | tr '[:upper:]' '[:lower:]')
            echo "[conda-recipise] Directive: $directive, Value: $value"    
            echo "# Flag: Directive: $directive, Value: $value" >> "$RECIPE_FILE" 
            if [[ "$directive,," == "dependencies" && "$value,," == "true" ]]; then                
                echo "[conda-recipise] (default) Will install dependencies"
                DEPS_CONDA=""
                DEPS_PYTHON=""
                DEPS_R="TRUE"
            elif [[ "$directive,," == "dependencies" && "$value,," == "false" ]]; then                
                echo "[conda-recipise] (!not default) Will NOT install dependencies"
                DEPS_CONDA="--no-deps"
                DEPS_PYTHON="--no-deps"
                DEPS_R="FALSE"            
            elif [[ "${directive,,}" == "build-tools" && "${value,,}" == "true" ]]; then
                echo "[conda-recipise] Build-tools will be included"
                echo "" >> "$RECIPE_FILE"
                echo "# Including build tools for source installations" >> "$RECIPE_FILE"
                # Install compiler toolchain for R                                
                echo "conda install -y -c conda-forge gcc_linux-64 gxx_linux-64 gfortran_linux-64 make r-remotes" >>  "$RECIPE_FILE"
                echo "conda install -y -c conda-forge -c bioconda r-cpp11 r-openssl r-rsqlite" >> "$RECIPE_FILE"
                echo "conda install -y -c conda-forge -c bioconda r-preprocesscore bioconductor-vsn"
                # Common tool chain for compilation            
                echo "conda install -y -c conda-forge make pkg-config" >> "$RECIPE_FILE"
                echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc \$CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc" >> "$RECIPE_FILE"
                echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ \$CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++" >> "$RECIPE_FILE"
                echo "ln -sf \$CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran \$CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-gfortran" >> "$RECIPE_FILE"
                echo "" >> "$RECIPE_FILE"
            fi        
        elif [[ "$CURRENT_SECTION" == "find:" ]]; then
            echo "[conda-recipise] Finding: $pkg_name, version: $ver, source: $src"
            script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
            # Build arguments array
            find_args=(--pkg "$pkg_name" --version "$ver")
            # Call and capture return value
            mapfile -t result < <("$script_dir/coble-find.sh" "${find_args[@]}")
            pkg_manager="${result[0]}"
            recipe_line="${result[1]}"
            yaml_line="${result[2]}"
            if [[ $pkg_manager == "unknown" ]]; then
                echo "[coble-resolve] Unknown: $line"
                echo "# Unknown package: $line" >> "$RECIPE_FILE"
            else            
                # Use the return value
                echo "[coble-resolve] Manager: $pkg_manager"
                echo "[coble-resolve] Recipe: $recipe_line"
                echo "[coble-resolve] Yaml: $yaml_line"                                
                echo "${recipe_line}" >> "$RECIPE_FILE"                              
            fi
        fi
    else                
        if [[ -n "$line" ]]; then
            echo "[conda-recipise] Ignoring line: $line"
        fi
    fi
done < "$YAML_FILE"
echo "[conda-recipise] Recipe generation complete: $RECIPE_FILE"





