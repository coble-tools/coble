################### GENERIC COBLE DOCKERFILE ############################
# Build with local recipe:
#
#    docker build -f "$DOCKERFILE" \
#    --build-arg RECIPE_CBL="$INPUT_RECIPE" \
#    --build-arg BUILD_TAG="$ENV_NAME" \
#    --build-arg GITHUB_PAT="$GITHUB_PAT" \
#    --build-arg VAL_FILE="$VAL_FILE" \
#    --build-arg VAL_FOLDER="$VAL_FOLDER" \
#    --build-arg UBUNTU_VERSION="$UBUNTU_VERSION" \
#    --no-cache \
#    -t "$IMAGE_NAME" .
#########################################################################

ARG UBUNTU_VERSION=22.04
ARG BUILD_TAG=custom
FROM coble-${BUILD_TAG}:latest

ARG VAL_FOLDER
COPY ${VAL_FOLDER}/ /app/validate/