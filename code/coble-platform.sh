#!/usr/bin/env bash
##############
# Build a Docker container for one specific platform via buildx, e.g. for
# local cross-platform testing. Docker only - never Singularity: a buildx
# --platform build is routinely cross-arch (and, run from a Mac, cross-OS
# too), and there's no guarantee singularity/apptainer is even present or
# meaningful on the machine running this - see the "no macOS Singularity
# build" fact in CLAUDE.md.
# This is coble-container.sh's --platform sibling: coble-container.sh hands
# off here as soon as it sees --platform, so this script has to parse and
# validate its own arguments rather than relying on the caller.
##############

# Default values
ENV_NAME=""
INPUT_RECIPE=""
IMAGE_NAME=""
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
Usage: $(basename "$0") --platform PLATFORM [OPTIONS]

Build a Docker container (never Singularity - see note below) for one
specific platform via 'docker buildx build --platform ... --load', so the
image lands in your local Docker daemon ready to run - useful for testing a
non-native platform locally (e.g. building linux/arm64 on an amd64 machine,
or vice versa, via QEMU/Rosetta emulation).

Singularity is never built here, even if you were used to passing
--containers to coble-container.sh: a buildx --platform build is routinely
cross-arch (and cross-OS, from a Mac), and there's no guarantee
singularity/apptainer is even present or meaningful on the machine running
this script. Use coble-container.sh's native-runner-per-arch path (as
cont-conda.yml does) for Singularity images.

OPTIONS:
    --platform PLATFORM  Required. A single buildx platform, e.g. linux/amd64 or linux/arm64
                          (the same syntax docker/buildx itself takes). Multiple
                          comma-separated platforms are not supported here, since
                          --load cannot load a multi-platform manifest locally.
    --env NAME            Name for the container environment (required)
    --recipe PATH         Path to the .cbl recipe file (required)
    --validate PATH       Path to the validation script (required)
    --val-folder PATH     Additional validation files to layer in
    --image NAME          Name for the Docker image (default: cbl-ENV_NAME)
    --dry-run             Show the build commands without executing them
    --code-source SOURCE  Source for COBLE code: main (default) or local, or a specific SHA
    --ubuntu VERSION       Ubuntu base image version (default: 22.04)
    -h, --help             Show this help message

EXAMPLE:
    $(basename "$0") --env basic --recipe config/basic.cbl --validate config/validate.sh --platform linux/arm64
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
            if [[ "$2" == *"singularity"* || "$2" == *"apptainer"* ]]; then
                echo "[coble-platform] Note: --containers '$2' mentions singularity/apptainer, but this script only ever builds Docker - ignoring that part. Use coble-container.sh for Singularity images." >&2
            fi
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

# Validate required arguments
if [[ -z "$PLATFORM" ]]; then
    echo "Error: --platform is required"
    show_help
    exit 1
fi

if [[ "$PLATFORM" == *,* ]]; then
    echo "Error: --platform '$PLATFORM' names more than one platform - 'docker buildx --load' can only load a single-platform image into the local daemon. Build one platform at a time."
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

# If --env wasn't given explicitly, look for a "coble: - environment: NAME" entry
# in the recipe itself - same fallback coble-recipise.sh applies internally, but
# needed here too since ENV_NAME drives image/file naming before the recipe is
# ever parsed by coble-recipise.sh.
if [[ -z "$ENV_NAME" ]]; then
    scan_section=""
    while IFS= read -r scan_line; do
        scan_line="$(echo -e "${scan_line}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
        if [[ "$scan_line" == "coble:"* ]]; then
            scan_section="coble"
        elif [[ -z "$scan_line" || "$scan_line" =~ ^([a-zA-Z0-9_-]+):$ ]]; then
            scan_section=""
        elif [[ "$scan_section" == "coble" && "$scan_line" == "-"* ]]; then
            scan_entry="${scan_line#- }"
            if [[ "$scan_entry" == "environment:"* ]]; then
                coble_env_name="$(echo "${scan_entry#environment:}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
                if [[ -n "$coble_env_name" ]]; then
                    echo "[coble-platform] Using environment name '$coble_env_name' from recipe's coble: section"
                    ENV_NAME="$coble_env_name"
                fi
            fi
        fi
    done < "$INPUT_RECIPE"
fi

if [[ -z "$ENV_NAME" ]]; then
    echo "Error: --env is required"
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

if ! docker buildx version >/dev/null 2>&1; then
    echo "Error: docker buildx is not available - install/enable it before using --platform"
    exit 1
fi

if [[ -z "$IMAGE_NAME" ]]; then
    IMAGE_NAME="cbl-${ENV_NAME}"
fi

# same directory as this script/code/Dockerfile
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKERFILE="${SCRIPT_DIR}/coble.Dockerfile"
DOCKERFILE_VAL="${SCRIPT_DIR}/coble.val.Dockerfile"
echo "[coble-platform] Using Dockerfile: $DOCKERFILE"
echo "[coble-platform] Target platform: $PLATFORM"
RESULTS_DIR="$(dirname "$INPUT_RECIPE")"
LOCALDOCKERFILE="${RESULTS_DIR}/${ENV_NAME}.Dockerfile"
DOCKERLOGFILE="${RESULTS_DIR}/${ENV_NAME}_docker_build.log"
# CODE_SOURCE is passed straight through as-is: "main" stays "main" (resolved fresh
# by `git checkout main` at actual build time inside the Dockerfile, not pinned here -
# pinning is what passing a specific SHA is for), a SHA is used as-is, and "local" is
# handled by staging this checkout into the build context just before the build below.
STAGE_DIR=".coble-local-src-stage"

### Docker (buildx, single platform, loaded into the local daemon) #######################

echo "[coble-platform] Building Docker image for $PLATFORM..."

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
# PLATFORM=$PLATFORM
# ------------------------------
# Instructions to build the image:
# 1. Set the above environment variables in your terminal (or export them in your shell profile)
# 2. Run the below command ensuring to amend paths to your location correctly:
# ------------------------------
EOF

cat "$DOCKERFILE" >> "$LOCALDOCKERFILE"

    if [[ "$DRY_RUN" == true ]]; then
        echo "[coble-platform] DRY RUN: The Docker that would be run is copied as $LOCALDOCKERFILE"
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
        echo "[coble-platform] --code-source local (debug/dev only): staging this checkout's coble source from $COBLE_ROOT"
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

    echo "[coble-platform] Building Docker image $IMAGE_NAME for $PLATFORM with build args"
    echo "  RECIPE_CBL=$INPUT_RECIPE"
    echo "  BUILD_TAG=$ENV_NAME"
    echo "  GITHUB_PAT=***"
    echo "  VAL_FILE=$VAL_FILE"
    echo "  CODE_SOURCE=$CODE_SOURCE"
    echo "  SKIP_ERRORS=$SKIP_ERRORS"
    echo "  UBUNTU_VERSION=$UBUNTU"
    docker buildx build -f "$DOCKERFILE" \
    --platform "$PLATFORM" \
    --build-arg RECIPE_CBL="$INPUT_RECIPE" \
    --build-arg BUILD_TAG="$ENV_NAME" \
    --build-arg GITHUB_PAT="$GITHUB_PAT" \
    --build-arg VAL_FILE="$VAL_FILE" \
    --build-arg CODE_SOURCE="$CODE_SOURCE" \
    --build-arg SKIP_ERRORS="$SKIP_ERRORS" \
    --build-arg UBUNTU_VERSION="$UBUNTU" \
    --no-cache \
    --load \
    -t "coble-${ENV_NAME}:latest" . 2>&1 | tee $DOCKERLOGFILE
    BUILD_EXIT_CODE=${PIPESTATUS[0]}
    rm -rf "$STAGE_DIR" "$VAL_STAGE"
    if [[ $BUILD_EXIT_CODE -ne 0 ]]; then
        echo "[coble-platform] ERROR: Docker build failed with exit code $BUILD_EXIT_CODE"
        exit 1
    fi
    if [[ -n "$VAL_FOLDER"  ]]; then
        echo "[coble-platform] Adding val folder layer to $IMAGE_NAME..."
        echo "  BUILD_TAG=$ENV_NAME"
        echo "  VAL_FOLDER=$VAL_FOLDER"
        docker buildx build -f "$DOCKERFILE_VAL" \
        --platform "$PLATFORM" \
        --build-arg BUILD_TAG="$ENV_NAME" \
        --build-arg VAL_FOLDER="$VAL_FOLDER" \
        --no-cache \
        --load \
        -t "$IMAGE_NAME" . 2>&1 | tee $DOCKERLOGFILE
        BUILD_EXIT_CODE=${PIPESTATUS[0]}
        if [[ $BUILD_EXIT_CODE -ne 0 ]]; then
            echo "[coble-platform] ERROR: Docker build failed with exit code $BUILD_EXIT_CODE"
            exit 1
        fi
    else
        docker tag "coble-${ENV_NAME}:latest" "$IMAGE_NAME"
    fi

    # Verify image was created successfully
    if ! docker inspect "$IMAGE_NAME" &> /dev/null; then
        echo "[coble-platform] ERROR: Docker image $IMAGE_NAME was not created or cannot be inspected"
        exit 1
    fi

    # Display image creation time and size for verification
    IMAGE_INFO=$(docker inspect "$IMAGE_NAME" --format='Created: {{.Created}}, Size: {{.Size}} bytes')
    echo "[coble-platform] ✓ Docker image created successfully for $PLATFORM"
    echo "[coble-platform] $IMAGE_INFO"

    echo "[coble-platform] Docker build complete: $IMAGE_NAME ($PLATFORM)"

    echo "[coble-platform] To run use:"
    echo ""
    echo "docker run --rm -it -v .:/workspace -w /workspace $IMAGE_NAME"
    echo ""
