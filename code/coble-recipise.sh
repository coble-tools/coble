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
    echo "  --output RECIPE  Specify output recipe file (optional, default: ./coble-capture-reproduce.sh)"
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
    YAML_FILE="./coble-capture-$ENV_NAME.yml"
fi


# Set RECIPE_FILE if not provided, and prepend OUTDIR
mkdir -p "$OUTDIR"
if [[ -z "$RECIPE_FILE" ]]; then
    base_name="${YAML_FILE##*/}"
    base_name_noext="${base_name%.*}"
    RECIPE_FILE="${base_name_noext}-recipe.sh"
    RECIPE_FILE="$OUTDIR/${RECIPE_FILE}"
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
DEPS_CONDA="--no-deps"
DEPS_PYTHON="--no-deps"
DEPS_R="FALSE"


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
languages_line="conda create ${CONDA_ENV} -y -c conda-forge -c defaults -c r"
CURRENT_SECTION="COBLE"
while IFS= read -r line; do
    # Trim leading/trailing whitespace
    line="$(echo -e "${line}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    if [[ "$line" == "languages:" ]]; then
        CURRENT_SECTION="languages"
    elif [[ "$line" == "channels:" ]]; then
        CURRENT_SECTION="channels"          
    elif [[ -z "$line" ]]; then
        CURRENT_SECTION=""
    elif [[ "$CURRENT_SECTION" == "languages" && "$line" == "-"* ]]; then
        languages_line+=" '${line#- }'"        
    fi
done < "$YAML_FILE"
echo "$languages_line" >> "$RECIPE_FILE"
echo "conda activate ${ENV_INPUT}" >> "$RECIPE_FILE"
echo "" >> "$RECIPE_FILE"

echo "[coble-recipise] Clearing default channels."      
echo "# Channels section" >> "$RECIPE_FILE"
echo "conda config --remove-key channels" >> "$RECIPE_FILE"

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
echo "" >> "$RECIPE_FILE"
echo "# INSTALL SECTION FOR CONDA" >> "$RECIPE_FILE"
CURRENT_SECTION=""
while IFS= read -r line || [[ -n "$line" ]]; do
    # Trim leading/trailing whitespace
    line="$(echo -e "${line}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"    
    if [[ "$line" == "flags:" \
        || "$line" == "conda-r:" \
        || "$line" == "conda:" \
        || "$line" == "r-package:" \
        || "$line" == "r-github:" \
        || "$line" == "package-r:" \
        || "$line" == "pip:" \
        || "$line" == "bash:" \
        || "$line" == "package-bioc:" ]]; then
        CURRENT_SECTION="$line"
        echo "[conda-recipise] Package manager changing to: $CURRENT_SECTION"    
    elif [[ -n "$CURRENT_SECTION" && "$line" == "-"* ]]; then
        pkg_entry="${line#- }"
        echo "[conda-recipise] Processing entry: $pkg_entry"
        IFS='@' read -r pkg src path <<< "$pkg_entry"
        IFS='=' read -r pkg_name ver <<< "$pkg"
        # For flags, parse directive and value from 'directive = value' format        
        if [[ "$CURRENT_SECTION" == "conda-r:"  ]]; then            
            if [[ "$src" == "" ]]; then
                src="conda-forge"
            fi
            echo "conda install --solver=classic -y 'r-$pkg' -c $src $DEPS_CONDA $UPDATE_CONDA" >> "$RECIPE_FILE"
        elif [[  "$CURRENT_SECTION" == "conda:" ]]; then            
            if [[ "$src" == "" ]]; then
                src="conda-forge"
            fi
            echo "conda install --solver=classic -y '$pkg' -c $src $DEPS_CONDA $UPDATE_CONDA" >> "$RECIPE_FILE"        
        elif [[ "$CURRENT_SECTION" == "package-r:" ]]; then            
            echo "[conda-recipise] Processing R package: $pkg_name, version: $ver, source: $src"
            if [[ -n "$ver" && ( -z "$src" || "$src" == "CRAN"* ) ]]; then
                # Use CRAN archive tarball URL for versioned CRAN packages
                if [[ "$pkg_name" == "base" ]]; then
                    #https://cran.r-project.org/src/base/R-3/R-3.6.0.tar.gz                
                    int_v=3
                    echo "Rscript -e 'install.packages(\"https://cran.r-project.org/src/base/R-${int_v}/R-${ver}.tar.gz\", repos = NULL, type = \"source\")'" >> "$RECIPE_FILE"
                else
                    echo "Rscript -e 'install.packages(\"https://cran.r-project.org/src/contrib/Archive/${pkg_name}/${pkg_name}_${ver}.tar.gz\", repos = NULL, type = \"source\")'" >> "$RECIPE_FILE"
                fi
            elif [[ "$src" == "R-FORGE"* ]]; then
                echo "Rscript -e 'install.packages(\"${pkg_name}\", repos=\"https://R-Forge.R-project.org\", dependencies=$DEPS_R)'" >> "$RECIPE_FILE"
            else
                echo "Rscript -e 'install.packages(\"${pkg_name}\", repos=\"https://cloud.r-project.org\", dependencies=$DEPS_R)'" >> "$RECIPE_FILE"
            fi
        elif [[ "$CURRENT_SECTION" == "r-github:" ]]; then            
            echo "Rscript -e 'devtools::install_github(\"$path\", dependencies=$DEPS_R)'" >> "$RECIPE_FILE"
        elif [[ "$CURRENT_SECTION" == "package-bioc:" ]]; then            
            echo "Rscript -e 'BiocManager::install(\"${pkg%%=*}\", dependencies=$DEPS_R)'" >> "$RECIPE_FILE"
        elif [[ "$CURRENT_SECTION" == "pip:" ]]; then                                       
            echo "[conda-recipise] Processing pip package: $pkg_name, version: $ver"
            if [[ -n "$ver" ]]; then
                echo "python -m pip install ${pkg_name}==${ver} $DEPS_PYTHON" >> "$RECIPE_FILE"
            else
                echo "python -m pip install ${pkg_name} $DEPS_PYTHON" >> "$RECIPE_FILE"
            fi        
        elif [[ "$CURRENT_SECTION" == "bash:" ]]; then
            echo "Running bash command: $pkg"
            echo "$pkg" >> "$RECIPE_FILE"
        elif [[ "$CURRENT_SECTION" == "flags:" ]]; then
            echo "[conda-recipise] Processing flag: $pkg_entry"
            directive="$(echo "$pkg_entry" | cut -d':' -f1 | xargs)"
            value="$(echo "$pkg_entry" | cut -d':' -f2- | xargs)"            
            value=$(echo "$value" | tr '[:upper:]' '[:lower:]')
            echo "[conda-recipise] Directive: $directive, Value: $value"
            if [[ "$directive" == "dependencies" && "$value" == "true" ]]; then                
                echo "[conda-recipise] (default) Will install dependencies"
                DEPS_CONDA=""
                DEPS_PYTHON=""
                DEPS_R="TRUE"
            elif [[ "$directive" == "dependencies" && "$value" == "false" ]]; then                
                echo "[conda-recipise] (!not default) Will NOT install dependencies"
                DEPS_CONDA="--no-deps"
                DEPS_PYTHON="--no-deps"
                DEPS_R="FALSE"            
            fi        
        fi
    else                
        if [[ -n "$line" ]]; then
            echo "[conda-recipise] Ignoring line: $line"
        fi
    fi
done < "$YAML_FILE"
echo "[conda-recipise] Recipe generation complete: $RECIPE_FILE"





