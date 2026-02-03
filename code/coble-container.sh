#!/bin/bash

# Default values
ENV_NAME=""
INPUT_RECIPE=""
containers="docker,singularity"
IMAGE_NAME=""
DUAL_CI=false
DUAL=false
VAL_FILE=""
VAL_FOLDER=""

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
    
# Then test the image
docker run --rm -it cbl-carbine-arm64 /bin/bash

EXAMPLES:
    # Build both Docker and Singularity containers
    $(basename "$0") --env basic --recipe config/basic.cbl

    # Only build Docker image
    $(basename "$0") --env basic --recipe config/basic.cbl --steps 1

    # Only build Singularity image (assumes Docker image exists)
    $(basename "$0") --env basic --recipe config/basic.cbl --steps 2

    # Build mac and linuc
    $(basename "$0") --env basic --recipe config/basic.cbl --dual

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
        --dual-ci)            
            DUAL_CI=true
            shift
            ;;
        --dual)            
            DUAL=true
            shift
            ;;
        --validate)
            VAL_FILE="$2"
            shift 2
            ;;
        --val-folder)
            VAL_FOLDER="$2"
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

if [[ -z "$VAL_FILE" ]]; then
    echo "Error: --validate is required"
    show_help
    exit 1
fi

if [[ ! -f "$INPUT_RECIPE" ]]; then
    echo "Error: Recipe file not found: $INPUT_RECIPE"
    exit 1
fi

if [[ ! -f "$VAL_FILE" ]]; then
    echo "Error: Validate file not found: $VAL_FILE"
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
    echo "[coble-docker] CI=$CI, GITHUB_ACTIONS=$GITHUB_ACTIONS"
    
    # Fallback chain:
    # 1. CI environment: use buildx with --push for multi-platform
    # 2. Buildx available locally: use buildx with --load for single platform
    # 3. Fallback: regular docker build for single platform
    
    echo "[coble-docker] VAL_FILE='$VAL_FILE'"
    echo "[coble-docker] VAL_FOLDER='$VAL_FOLDER'"

    if [[ $DUAL_CI == true ]]; then
        echo "[coble-docker] Dual build for linux and mac requested: using docker buildx for multi-platform build with push..."
        # Ensure buildx builder exists and is using docker-container driver
        docker buildx create --use --name coble-builder --driver docker-container || docker buildx use coble-builder || true
        #--platform linux/amd64,linux/arm64 \
        docker buildx build -f "$DOCKERFILE" \
        --platform linux/amd64 \
        --build-arg RECIPE_CBL="$INPUT_RECIPE" \
        --build-arg BUILD_TAG="$ENV_NAME" \
        --build-arg GITHUB_PAT="$GITHUB_PAT" \
        --build-arg VAL_FILE="$VAL_FILE" \
        --build-arg VAL_FOLDER="$VAL_FOLDER" \
        -t "$IMAGE_NAME" \
        --push .
        BUILD_EXIT_CODE=$?
        if [[ $BUILD_EXIT_CODE -ne 0 ]]; then
            echo "[coble-docker] ERROR: Docker buildx build failed with exit code $BUILD_EXIT_CODE"
            exit 1
        fi
    elif [[ $DUAL == true ]]; then
        echo "[coble-docker] Docker buildx for dual mac and linux builds requested..."        
        #build_platform="linux/amd64,linux/arm64"
        build_platform="linux/arm64"
        docker buildx build -f "$DOCKERFILE" \
        --platform "$build_platform" \
        --pull \
        --build-arg RECIPE_CBL="$INPUT_RECIPE" \
        --build-arg BUILD_TAG="$ENV_NAME" \
        --build-arg GITHUB_PAT="$GITHUB_PAT" \
        --build-arg VAL_FILE="$VAL_FILE" \
        --build-arg VAL_FOLDER="$VAL_FOLDER" \
        -t "$IMAGE_NAME" \
        --load .
        BUILD_EXIT_CODE=$?
        if [[ $BUILD_EXIT_CODE -ne 0 ]]; then
            echo "[coble-docker] ERROR: Docker buildx build failed with exit code $BUILD_EXIT_CODE"
            exit 1
        fi
    else
        echo "[coble-docker] Using regular docker build (native platform)..."
        #docker build --progress=plain -f "$DOCKERFILE" \
        docker build -f "$DOCKERFILE" \
        --build-arg RECIPE_CBL="$INPUT_RECIPE" \
        --build-arg BUILD_TAG="$ENV_NAME" \
        --build-arg GITHUB_PAT="$GITHUB_PAT" \
        --build-arg VAL_FILE="$VAL_FILE" \
        --build-arg VAL_FOLDER="$VAL_FOLDER" \
        -t "$IMAGE_NAME" .
        BUILD_EXIT_CODE=$?
        if [[ $BUILD_EXIT_CODE -ne 0 ]]; then
            echo "[coble-docker] ERROR: Docker build failed with exit code $BUILD_EXIT_CODE"
            exit 1
        fi
    fi
    
    # Verify image was created successfully
    # Note: Skip verification when using --dual-ci since image is pushed directly to registry
    # and not loaded into local Docker daemon
    if [[ $DUAL_CI == true ]]; then
        echo "[coble-docker] ✓ Docker image built and pushed successfully to registry"
        echo "[coble-docker] Image: $IMAGE_NAME"
    else
        if ! docker inspect "$IMAGE_NAME" &> /dev/null; then
            echo "[coble-docker] ERROR: Docker image $IMAGE_NAME was not created or cannot be inspected"
            exit 1
        fi
        
        # Display image creation time and size for verification
        IMAGE_INFO=$(docker inspect "$IMAGE_NAME" --format='Created: {{.Created}}, Size: {{.VirtualSize}} bytes')
        echo "[coble-docker] ✓ Docker image created successfully"
        echo "[coble-docker] $IMAGE_INFO"
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