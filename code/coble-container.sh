#!/usr/bin/env bash

# Keep the original args around in case we need to hand off to coble-platform.sh below
ORIGINAL_ARGS=("$@")

# Default values
ENV_NAME=""
INPUT_RECIPE=""
containers="docker,singularity"
IMAGE_NAME=""
DUAL_CI=false
DUAL=""
VAL_FILE=""
VAL_FOLDER=""
DRY_RUN=false
CODE_SOURCE="main"
SKIP_ERRORS=false
UBUNTU="22.04"
PLATFORM=""

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
    --dry-run            Show the build commands without executing them
    --rebuild            Force rebuild of the Docker image without using cache
    --code-source SOURCE Source for COBLE code: main (default) or local, or a specific SHA
    --platform PLATFORM  Build for a specific platform via buildx (e.g. linux/arm64) - delegates to coble-platform.sh
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
    $(basename "$0") --env basic --recipe config/basic.cbl --dual mac

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
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --image)
            IMAGE_NAME="$2"
            shift 2
            ;;
        --code-source)
            CODE_SOURCE="$2"
            shift 2
            ;;
        --ubuntu)
            UBUNTU="$2"
            shift 2
            ;;
        --rebuild)
            shift
            ;;
        --skip-errors)
            SKIP_ERRORS=true
            shift
            ;;
        --dual-ci)
            DUAL_CI=true
            shift
            ;;
        --dual)
            DUAL="$2"
            shift 2
            ;;
        --validate)
            VAL_FILE="$2"
            shift 2
            ;;
        --val-folder)
            VAL_FOLDER="$2"
            shift 2
            ;;
        --platform)
            PLATFORM="$2"
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

# --platform uses the same syntax docker/buildx itself takes (e.g. linux/amd64,
# linux/arm64/v8). Building for a specific platform - as opposed to the
# native-runner-per-arch approach the GitHub workflow uses - needs buildx, so
# hand off entirely to the sibling script rather than growing this one.
if [[ -n "$PLATFORM" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    exec "$SCRIPT_DIR/coble-platform.sh" "${ORIGINAL_ARGS[@]}"
fi

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
    echo "No validate file entered, skipping validation step"
else
    if [[ ! -f "$VAL_FILE" ]]; then
        echo "Error: Validate file not found: $VAL_FILE"
        exit 1
    fi
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
DOCKERFILE_VAL="${SCRIPT_DIR}/coble.val.Dockerfile"
echo "[coble-docker] Using Dockerfile: $DOCKERFILE"
RESULTS_DIR="$(dirname "$INPUT_RECIPE")"
LOCALDOCKERFILE="${RESULTS_DIR}/${ENV_NAME}.Dockerfile"
DOCKERLOGFILE="${RESULTS_DIR}/${ENV_NAME}_docker_build.log"
# CODE_SOURCE is passed straight through as-is: "main" stays "main" (resolved fresh
# by `git checkout main` at actual build time inside the Dockerfile, not pinned here -
# pinning is what passing a specific SHA is for), a SHA is used as-is, and "local" is
# handled by staging this checkout into the build context just before the build below.
STAGE_DIR=".coble-local-src-stage"

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


    # We copy the dockerfile to our set for reproducibility
    # First we make explicit the build args so it can be directly reproduced
cat > "$LOCALDOCKERFILE" << EOF
# This Dockerfile was generated by coble with the following build args:
# Started at $(date '+%Y-%m-%d %H:%M:%S')"
# User: $(whoami)"
# ------------------------------
# RECIPE_CBL=$INPUT_RECIPE
# BUILD_TAG=$ENV_NAME
# GITHUB_PAT=\$GITHUB_PAT
# VAL_FILE=$VAL_FILE
# VAL_FOLDER=$VAL_FOLDER
# CODE_SOURCE=$CODE_SOURCE
# UBUNTU_VERSION=$UBUNTU
# ------------------------------
# Instructions to build the image:
# 1. Set the above environment variables in your terminal (or export them in your shell profile)
# 2. Run the below command ensuring to amend paths to your location correctly:
# ------------------------------
EOF

cat "$DOCKERFILE" >> "$LOCALDOCKERFILE"


    if [[ "$DRY_RUN" == true ]]; then
        echo "[coble-docker] DRY RUN: The Docker that would be run is copied as $LOCALDOCKERFILE"
        exit 0
    fi

    # Docker can only COPY files inside the build context, so a debug/dev "local"
    # source has to be staged into the context first - the Dockerfile always COPYs
    # this directory (empty unless we're in local mode) so the same Dockerfile
    # works for both cases.
    rm -rf "$STAGE_DIR"
    mkdir -p "$STAGE_DIR"
    if [[ "$CODE_SOURCE" == "local" ]]; then
        COBLE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
        echo "[coble-docker] --code-source local (debug/dev only): staging this checkout's coble source from $COBLE_ROOT"
        cp -r "$COBLE_ROOT"/. "$STAGE_DIR"/
    fi

    # Same reasoning for --validate: it's optional, but Docker's COPY needs a
    # real file either way - stage the given file, or an empty placeholder if
    # none was given, rather than letting COPY see an empty/missing source.
    VAL_STAGE=".coble-validate-stage"
    rm -rf "$VAL_STAGE"
    if [[ -n "$VAL_FILE" ]]; then
        cp "$VAL_FILE" "$VAL_STAGE"
    else
        : > "$VAL_STAGE"
    fi

    echo "[coble-docker] Using regular docker build (native platform)..."
    echo "[coble-docker] Building Docker image $IMAGE_NAME with build args"
    echo "  RECIPE_CBL=$INPUT_RECIPE"
    echo "  BUILD_TAG=$ENV_NAME"
    echo "  GITHUB_PAT=***"
    echo "  VAL_FILE=$VAL_FILE"
    echo "  CODE_SOURCE=$CODE_SOURCE"
    echo "  SKIP_ERRORS=$SKIP_ERRORS"
    echo "  UBUNTU_VERSION=$UBUNTU"
    docker build -f "$DOCKERFILE" \
    --build-arg RECIPE_CBL="$INPUT_RECIPE" \
    --build-arg BUILD_TAG="$ENV_NAME" \
    --build-arg GITHUB_PAT="$GITHUB_PAT" \
    --build-arg VAL_FILE="$VAL_FILE" \
    --build-arg CODE_SOURCE="$CODE_SOURCE" \
    --build-arg SKIP_ERRORS="$SKIP_ERRORS" \
    --build-arg UBUNTU_VERSION="$UBUNTU" \
    --no-cache \
    -t "coble-${ENV_NAME}:latest" . 2>&1 | tee $DOCKERLOGFILE
    BUILD_EXIT_CODE=${PIPESTATUS[0]}
    rm -rf "$STAGE_DIR" "$VAL_STAGE"
    if [[ $BUILD_EXIT_CODE -ne 0 ]]; then
        echo "[coble-docker] ERROR: Docker build failed with exit code $BUILD_EXIT_CODE"
        exit 1
    fi
    if [[ -n "$VAL_FOLDER"  ]]; then
        echo "[coble-docker] Adding val folder layer to $IMAGE_NAME..."
        echo "  BUILD_TAG=$ENV_NAME"
        echo "  VAL_FOLDER=$VAL_FOLDER"
        docker build -f "$DOCKERFILE_VAL" \
        --build-arg BUILD_TAG="$ENV_NAME" \
        --build-arg VAL_FOLDER="$VAL_FOLDER" \
        --no-cache \
        -t "$IMAGE_NAME" . 2>&1 | tee $DOCKERLOGFILE
        BUILD_EXIT_CODE=${PIPESTATUS[0]}
        if [[ $BUILD_EXIT_CODE -ne 0 ]]; then
            echo "[coble-docker] ERROR: Docker build failed with exit code $BUILD_EXIT_CODE"
            exit 1
        fi
    else
        docker tag "coble-${ENV_NAME}:latest" "$IMAGE_NAME"
    fi


    # Verify image was created successfully
    # Note: Skip verification when using --dual-ci since image is pushed directly to registry
    # and not loaded into local Docker daemon

    if ! docker inspect "$IMAGE_NAME" &> /dev/null; then
        echo "[coble-docker] ERROR: Docker image $IMAGE_NAME was not created or cannot be inspected"
        exit 1
    fi

    # Display image creation time and size for verification
    IMAGE_INFO=$(docker inspect "$IMAGE_NAME" --format='Created: {{.Created}}, Size: {{.Size}} bytes')
    echo "[coble-docker] ✓ Docker image created successfully"
    echo "[coble-docker] $IMAGE_INFO"

    echo "[coble-docker] Docker build complete at image $DOCKER_TAR"

    echo "[coble-docker] To run use:"
    echo ""
    echo "docker run --rm -it -v .:/workspace -w /workspace $IMAGE_NAME"
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
