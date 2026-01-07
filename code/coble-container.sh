#!/bin/bash

# Default values
ENV_NAME=""
INPUT_RECIPE=""
containers="docker,singularity"

# Help function
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Build Docker and Singularity containers from COBLE recipes.

OPTIONS:
    --env NAME          Name for the container environment (required)
    --recipe PATH        Path to the .cbl recipe file (required)        
    --containers TYPE    Comma-separated list of containers to build: conda,docker,singularity (default: conda)
    -h, --help          Show this help message

EXAMPLES:
    # Build both Docker and Singularity containers
    $(basename "$0") --env basic --recipe config/basic.cbl

    # Only build Docker image
    $(basename "$0") --env basic --recipe config/basic.cbl --steps 1

    # Only build Singularity image (assumes Docker image exists)
    $(basename "$0") --env basic --recipe config/basic.cbl --steps 2

EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --env)
            ENV_NAME="$2"
            shift 2
            ;;
        --recipe)
            INPUT_RECIPE="$2"
            shift 2
            ;;        
        --containers)
            containers="$2"
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
    echo "Error: --recipe is required"
    show_help
    exit 1
fi

if [[ ! -f "$INPUT_RECIPE" ]]; then
    echo "Error: Recipe file not found: $INPUT_RECIPE"
    exit 1
fi

# make file names
DOCKER_TAR="cbl-${ENV_NAME}.tar"
SINGULARITY_SIF="cbl-${ENV_NAME}.sif"
# same directory as this script/code/Dockerfile
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKERFILE="${SCRIPT_DIR}/coble.Dockerfile"

### Docker #######################

if [[ $containers == *"docker"* || $containers == *"singularity"* ]]; then 
    
    echo "[coble-docker] Building Docker image..."
    
    docker build -f "$DOCKERFILE" \
    --build-arg RECIPE_CBL="$INPUT_RECIPE" \
    --build-arg BUILD_TAG="$ENV_NAME" \
    --build-arg GITHUB_PAT="$GITHUB_PAT" \
    -t "cbl-${ENV_NAME}" .
    
    echo "[coble-docker] Docker build complete at image $DOCKER_TAR"
    echo "[coble-docker] To run use:"
    echo ""
    echo "docker run --rm -it cbl-${ENV_NAME}"
    echo ""

fi

### Singularity #######################
if [[ $containers == *"singularity"* || $containers == *"apptainer"* ]]; then

    echo "[coble-singularity] Building Singularity image..."

    echo "[coble-singularity] ...removing old tar..."
    rm -rf "cbl-${ENV_NAME}.tar" || true

    echo "[coble-singularity] ...saving Docker image to tar..."
    docker save "cbl-${ENV_NAME}" -o "$DOCKER_TAR"

    echo "[coble-singularity] ...removing old sif..."
    rm -rf "$SINGULARITY_SIF" || true

    echo "[coble-singularity] ...building sif..."
    singularity build "$SINGULARITY_SIF" docker-archive://"$DOCKER_TAR"
    echo "[coble-singularity] Singularity build complete at $SINGULARITY_SIF"
    echo "[coble-singularity] To run use:"
    echo ""
    echo "singularity shell $SINGULARITY_SIF"
    echo ""
    echo "[coble-singularity] completed successfully."

fi


