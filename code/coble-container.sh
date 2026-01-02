#!/bin/bash

# Default values
ENV_NAME=""
INPUT_RECIPE=""
STEPS="1,2"

# Help function
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Build Docker and Singularity containers from COBLE recipes.

OPTIONS:
    --env NAME          Name for the container environment (required)
    --input PATH        Path to the .cbl recipe file (required)
    --steps STEPS       Comma-separated steps to run (default: 1,2)
                        1 = Docker build
                        2 = Singularity build
    -h, --help          Show this help message

EXAMPLES:
    # Build both Docker and Singularity containers
    $(basename "$0") --env basic --input config/basic.cbl

    # Only build Docker image
    $(basename "$0") --env basic --input config/basic.cbl --steps 1

    # Only build Singularity image (assumes Docker image exists)
    $(basename "$0") --env basic --input config/basic.cbl --steps 2

EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --env)
            ENV_NAME="$2"
            shift 2
            ;;
        --input)
            INPUT_RECIPE="$2"
            shift 2
            ;;
        --steps)
            STEPS="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Error: Unknown option $1"
            show_help
            exit 1
            ;;
    esac
done

# Validate required arguments
if [[ -z "$ENV_NAME" ]]; then
    echo "Error: --env is required"
    show_help
    exit 1
fi

if [[ -z "$INPUT_RECIPE" ]]; then
    echo "Error: --input is required"
    show_help
    exit 1
fi

if [[ ! -f "$INPUT_RECIPE" ]]; then
    echo "Error: Recipe file not found: $INPUT_RECIPE"
    exit 1
fi

# Format steps for matching
steps=",${STEPS},"

# make file names
DOCKER_TAR="cbl-${ENV_NAME}.tar"
SINGULARITY_SIF="cbl-${ENV_NAME}.sif"
# same directory as this script/code/Dockerfile
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKERFILE="${SCRIPT_DIR}/coble.Dockerfile"

### Docker #######################

if [[ $steps == *",1,"* ]]; then 
    
    echo "[coble-container] Building Docker image..."
    
    docker build -f "$DOCKERFILE" \
    --build-arg RECIPE_CBL="$INPUT_RECIPE" \
    --build-arg BUILD_TAG="$ENV_NAME" \
    -t "cbl-${ENV_NAME}" .
    
    echo "[coble-container] Docker build complete at image $DOCKER_TAR"

fi

### Singularity #######################
if [[ $steps == *",2,"* ]]; then 

    echo "[coble-container] Building Singularity image..."

    echo "[coble-container] ...removing old tar..."
    rm -rf "cbl-${ENV_NAME}.tar" || true

    echo "[coble-container] ...saving Docker image to tar..."
    docker save "cbl-${ENV_NAME}" -o "$DOCKER_TAR"

    echo "[coble-container] ...removing old sif..."
    rm -rf "$SINGULARITY_SIF" || true

    echo "[coble-container] ...building sif..."
    singularity build "$SINGULARITY_SIF" docker-archive://"$DOCKER_TAR"
    echo "[coble-container] Singularity build complete at $SINGULARITY_SIF"

fi


