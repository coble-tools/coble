#!/bin/bash

# Default values
ENV_NAME=""
INPUT_RECIPE=""
containers="docker,singularity"
IMAGE_NAME=""

# Help function
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Build Docker and Singularity containers from COBLE recipes.

OPTIONS:
    --env NAME          Name for the container environment (required)
    --recipe PATH        Path to the .cbl recipe file (required)        
    --containers TYPE    Comma-separated list of containers to build: conda,docker,singularity (default: conda)
    --image NAME         Name for the Docker image (default: cbl-ENV_NAME)
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
        --image)
            IMAGE_NAME="$2"
            shift 2
            ;;
        --rebuild)            
            shift
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

if [[ -z "$IMAGE_NAME" ]]; then
    IMAGE_NAME="cbl-${ENV_NAME}"
fi

# make file names
DOCKER_TAR="${IMAGE_NAME}.tar"
SINGULARITY_SIF="${IMAGE_NAME}.sif"
# same directory as this script/code/Dockerfile
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKERFILE="${SCRIPT_DIR}/coble.Dockerfile"


### Docker #######################

if [[ $containers == *"docker"* || $containers == *"singularity"* || $containers == *"apptainer"* ]]; then 
    
    echo "[coble-docker] Building Docker image..."
    
    # Fallback chain:
    # 1. CI environment: use buildx with --push for multi-platform
    # 2. Buildx available locally: use buildx with --load for single platform
    # 3. Fallback: regular docker build for single platform
    
    if [[ -n "$CI" ]] || [[ -n "$GITHUB_ACTIONS" ]]; then
        echo "[coble-docker] CI detected: using docker buildx for multi-platform build..."
        docker buildx build -f "$DOCKERFILE" \
        --platform linux/amd64,linux/arm64 \
        --build-arg RECIPE_CBL="$INPUT_RECIPE" \
        --build-arg BUILD_TAG="$ENV_NAME" \
        --build-arg GITHUB_PAT="$GITHUB_PAT" \
        -t "$IMAGE_NAME" \
        --push .
    elif command -v docker &> /dev/null && docker buildx version &> /dev/null; then
        echo "[coble-docker] Docker buildx available: using buildx with --load..."
        docker buildx build -f "$DOCKERFILE" \
        --build-arg RECIPE_CBL="$INPUT_RECIPE" \
        --build-arg BUILD_TAG="$ENV_NAME" \
        --build-arg GITHUB_PAT="$GITHUB_PAT" \
        -t "$IMAGE_NAME" \
        --load .
    else
        echo "[coble-docker] Using regular docker build (native platform)..."
        docker build -f "$DOCKERFILE" \
        --build-arg RECIPE_CBL="$INPUT_RECIPE" \
        --build-arg BUILD_TAG="$ENV_NAME" \
        --build-arg GITHUB_PAT="$GITHUB_PAT" \
        -t "$IMAGE_NAME" .
    fi
    
    echo "[coble-docker] Docker build complete at image $DOCKER_TAR"
    echo "[coble-docker] To run use:"
    echo ""
    echo "docker run --rm -it $IMAGE_NAME"
    echo ""

fi

### Singularity #######################
if [[ $containers == *"singularity"* || $containers == *"apptainer"* ]]; then    
    sing_app="singularity"
    if [[ $containers == *"apptainer"* ]]; then
        sing_app="apptainer"
    fi
    sing_app=$(echo "$sing_app" | tr '[:upper:]' '[:lower:]')
    sing_app=$(echo "$sing_app" | tr -d ' ')
    
    echo "[coble-$sing_app] Building $sing_app image..."

    echo "[coble-$sing_app] ...removing old tar..."
    rm -rf "$DOCKER_TAR" || true

    echo "[coble-$sing_app] ...saving Docker image to tar..."
    docker save "$IMAGE_NAME" -o "$DOCKER_TAR"

    echo "[coble-$sing_app] ...removing old sif..."
    rm -rf "$SINGULARITY_SIF" || true

    echo "[coble-$sing_app] ...building sif..."    
    $sing_app build "$SINGULARITY_SIF" docker-archive://"$DOCKER_TAR"
    echo "[coble-$sing_app] Singularity build complete at $SINGULARITY_SIF"
    echo "[coble-$sing_app] To run use:"
    echo ""
    echo "$sing_app shell $SINGULARITY_SIF"
    echo ""
    echo "[coble-$sing_app] completed successfully."

fi


