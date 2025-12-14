#!/usr/bin/env bash
# Reproduce a conda environment from a captured coble-capture.yml file



# Usage: ./coble-recreate.sh [--env ENV] [--input YAML_FILE]

# Default values

ENV_INPUT=""
YAML_FILE="./coble-capture.yml"

# Parse named arguments
    echo "Usage: $0 [--env ENV] [--input YAML_FILE]"
    echo "  --env ENV        Specify conda environment name or prefix (optional)"
    echo "  --input YAML     Specify input YAML file (optional, default: ./coble-capture.yml)"
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
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            shift
            ;;
    esac
done



# Set ENV_FORMATTED: blank if ENV_INPUT is empty, otherwise --name or --prefix
if [[ -z "$ENV_INPUT" ]]; then
    ENV_FORMATTED=""
elif [[ "$ENV_INPUT" == */* ]]; then
    ENV_FORMATTED="--prefix $ENV_INPUT"
else
    ENV_FORMATTED="--name $ENV_INPUT"
fi

if [[ -z "$YAML_FILE" || ! -f "$YAML_FILE" ]]; then
    echo "Error: YAML file not found: $YAML_FILE"
    exit 1
fi


# output is a recipe file for conda env create (always in current directory)
RECIPE_FILE="${YAML_FILE##*/}"
RECIPE_FILE="${RECIPE_FILE%.yml}-reproduce.sh"

echo "Reproducing conda environment from $YAML_FILE"

# We first want to go through and find the "languages"
# the languages: section, we just want to pull out the conda and r packages
# then we can build a conda create command

recipe_line="conda create $CONDA_ENV_ARG -y"

CURRENT_SECTION=""
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
        recipe_line+=" ${line#- }"        
    fi
done < "$YAML_FILE"


# Clear the aggregate file at the start
> "$RECIPE_FILE"
# shebang
echo "#!/usr/bin/env bash" >> "$RECIPE_FILE"
echo "" >> "$RECIPE_FILE"
echo "$recipe_line" >> "$RECIPE_FILE"

CURRENT_SECTION=""
while IFS= read -r line; do
    # Trim leading/trailing whitespace
    line="$(echo -e "${line}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    if [[ "$line" == "channels:" ]]; then
        CURRENT_SECTION="channels"
    elif [[ -z "$line" ]]; then
        CURRENT_SECTION=""
    elif [[ "$CURRENT_SECTION" == "channels" && "$line" == "-"* ]]; then
        echo "Adding channel: ${line#- }"
        echo "conda config $CONDA_ENV_ARG --add channels ${line#- }" >> "$RECIPE_FILE"
    fi
done < "$YAML_FILE"

CURRENT_SECTION=""
while IFS= read -r line; do
    # Trim leading/trailing whitespace
    line="$(echo -e "${line}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
    if [[ "$line" == "conda-r:" || "$line" == "conda:" || "$line" == "r-package:" || "$line" == "r-github:" || "$line" == "package-r:" || "$line" == "package-bioc:" ]]; then
        CURRENT_SECTION="$line"
    elif [[ -z "$line" ]]; then
        CURRENT_SECTION=""
    elif [[ -n "$CURRENT_SECTION" && "$line" == "-"* ]]; then
        pkg_entry="${line#- }"
        IFS='@' read -r pkg src path <<< "$pkg_entry"
        IFS='=' read -r pkg_name ver <<< "$pkg"
        if [[ "$CURRENT_SECTION" == "conda-r:"  ]]; then
            echo "Installing R package: $pkg_name $ver from $src"
            echo "conda install $CONDA_ENV_ARG -y r-$pkg -c $src" >> "$RECIPE_FILE"
        elif [[  "$CURRENT_SECTION" == "conda:" ]]; then
            echo "Installing R package: $pkg_name $ver from $src"
            echo "conda install $CONDA_ENV_ARG -y $pkg -c $src" >> "$RECIPE_FILE"
        elif [[ "$CURRENT_SECTION" == "package-r:" ]]; then
            echo "Installing R package: $pkg_name $ver from $src"            
            if [[ -n "$ver" && "$src" == "CRAN"* ]]; then
                # Use CRAN archive tarball URL for versioned CRAN packages
                echo "Rscript -e 'install.packages(\"https://cran.r-project.org/src/contrib/Archive/${pkg_name}/${pkg_name}_${ver}.tar.gz\", repos = NULL, type = \"source\")'" >> "$RECIPE_FILE"
            elif [[ "$src" == "R-FORGE"* ]]; then
                echo "Rscript -e 'install.packages(\"${pkg_name}\", repos=\"https://R-Forge.R-project.org\")'" >> "$RECIPE_FILE"
            else
                echo "Rscript -e 'install.packages(\"${pkg_name}\", repos=\"https://cloud.r-project.org\")'" >> "$RECIPE_FILE"
            fi
        elif [[ "$CURRENT_SECTION" == "r-github:" ]]; then
            echo "Installing R package from GitHub: $pkg from $path"
            echo "Rscript -e 'devtools::install_github(\"$path\")'" >> "$RECIPE_FILE"
        elif [[ "$CURRENT_SECTION" == "package-bioc:" ]]; then
            echo "Installing Bioconductor package: $pkg"
            echo "Rscript -e 'BiocManager::install(\"${pkg%%=*}\")'" >> "$RECIPE_FILE"
        elif [[ "$CURRENT_SECTION" == "pip:" ]]; then
            echo "Installing pip package: $pkg_name $ver from $src"
            if [[ -n "$ver" ]]; then
                echo "pip install ${pkg_name}==${ver}" >> "$RECIPE_FILE"
            else
                echo "pip install ${pkg_name}" >> "$RECIPE_FILE"
            fi
        fi
    fi
done < "$YAML_FILE"





