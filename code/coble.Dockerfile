################### GENERIC COBLE DOCKERFILE ############################
# Build with local recipe:
#
#    docker build -f "$DOCKERFILE" \
#    --build-arg RECIPE_CBL="$INPUT_RECIPE" \
#    --build-arg BUILD_TAG="$ENV_NAME" \
#    --build-arg GITHUB_PAT="$GITHUB_PAT" \
#    --build-arg VAL_FILE="$VAL_FILE" \
#    --build-arg UBUNTU_VERSION="$UBUNTU_VERSION" \
#    --no-cache \
#    -t "$IMAGE_NAME" .
#########################################################################

# ---- Ubuntu base replacing continuumio/miniconda3:24.9.2-0 ----
# Swap ubuntu:22.04 → ubuntu:20.04 / ubuntu:24.04 to test different glibc versions
ARG UBUNTU_VERSION=22.04
FROM ubuntu:${UBUNTU_VERSION}
#FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ARG TARGETPLATFORM
RUN case "$TARGETPLATFORM" in \
        "linux/arm64") ARCH="Linux-aarch64" ;; \
        *)             ARCH="Linux-x86_64"  ;; \
    esac && \
    wget --quiet \
        https://repo.anaconda.com/miniconda/Miniconda3-py312_24.9.2-0-${ARCH}.sh \
        -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p $CONDA_DIR && \
    rm /tmp/miniconda.sh && \
    conda clean -afy

# Replicate what the continuumio image does: initialise conda in bash
# ← ADD THIS RIGHT HERE, before anything else runs
RUN conda init bash && \
    ln -sf /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh

ENV BASH_ENV=/opt/conda/etc/profile.d/conda.sh

SHELL ["/bin/bash", "--login", "-c"]
# ---------------------------------------------------------------

WORKDIR /app

# Build arguments for customization
ARG BUILD_TAG=custom
ARG RECIPE_CBL=""
ARG SKIP_ERRORS=false
ARG GITHUB_PAT=""
ARG VAL_FILE=""
ARG CODE_SOURCE="local"

ENV CONDA_VERBOSITY=2

# Set environment variables
ENV COBLE_VARIANT=${BUILD_TAG}
ENV GITHUB_PAT=${GITHUB_PAT}
ENV CODE_SOURCE=${CODE_SOURCE}
LABEL org.opencontainers.image.version="${BUILD_TAG}" \
    org.opencontainers.image.title="coble-${BUILD_TAG}" \
    org.opencontainers.image.description="COBLE reproducible bioinformatics environment" \
    org.opencontainers.image.source="https://github.com/coble-tools/coble" \
    org.opencontainers.image.licenses="MIT"

# Set timeouts
RUN conda config --set remote_read_timeout_secs 180 && \
    conda config --set remote_connect_timeout_secs 60 && \
    conda config --set remote_max_retries 10 && \
    conda config --set path_conflict clobber && \
    conda config --set changeps1 true

# Ensure all channels cleaned out we only want to add ones we want
RUN conda config --system --remove-key channels 2>/dev/null || true

# Update conda to latest version
RUN conda update -n base -c defaults conda -y && \
    conda clean -afy && \
    rm -rf /opt/conda/pkgs/* && \
    rm -rf ~/.cache/pip/*



# Configure timezone to prevent interactive prompts during apt-get
ENV TZ=Europe/London

RUN apt-get -o Acquire::Retries=3 update && \
    apt-get install -y --no-install-recommends \
        curl \
        git \
        wget \
        ca-certificates \
        build-essential \
        gfortran \
        default-jdk-headless \
        libc6-dev \
        libglpk-dev \
        libxml2-dev \
        libgmp-dev \
        graphviz \
        unzip \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/* \
    && apt-get clean


ENV MAMBA_NO_BANNER=1

# May need to set java home
#ENV JAVA_HOME=/usr/lib/jvm/default-java

# for v8 builds
ENV DOWNLOAD_STATIC_LIBV8=1

# Create directory structure
RUN mkdir -p code recipe validate workspace
# Install coble from GitHub or locally
RUN echo "Cloning COBLE from GitHub..." && \
    rm -rf /app/coble && \
    if [ -n "${GITHUB_PAT}" ]; then \
        git clone https://${GITHUB_PAT}@github.com/coble-tools/coble.git /app/coble; \
    else \
        git clone https://github.com/coble-tools/coble.git /app/coble; \
    fi && \
    cd /app/coble && \
    git checkout ${CODE_SOURCE} && \
    rm -rf .git && \
    echo "COBLE cloned successfully.";

# Recipe cbl is copied to standard location
COPY $RECIPE_CBL /app/recipe/$BUILD_TAG.cbl
COPY README.md /app/README.md


# === BEFORE CHECK ===
# List what's available in the build context at /app
RUN echo "=== BEFORE COPY CHECK ===" && \
    echo "Looking for VAL_FILE: ${VAL_FILE}" && \
    ls -la recipes/publications/DESeq2/validate/ 2>/dev/null || echo "Directory not found in context" && \
    echo "========================="

# Do the copy
COPY $VAL_FILE /app/validate.sh

# === AFTER CHECK ===
RUN echo "=== AFTER COPY CHECK ===" && \
    if [ -f /app/validate.sh ]; then \
        echo "✓ File copied successfully"; \
        ls -la /app/validate.sh; \
    else \
        echo "✗ File NOT copied"; \
    fi && \
    echo "========================"

# Create .condarc with channels
RUN echo "channels:" > /app/.condarc && \
    echo "  - conda-forge" >> /app/.condarc
#    echo "  - bioconda" >> /app/.condarc && \
#    echo "  - defaults" >> /app/.condarc && \
RUN echo "notify_outdated_conda: false" > /app/.condarc && \
    echo "channel_priority: flexible" >> /app/.condarc

ENV CONDARC=/app/.condarc

######################### COBLE ##########################################################
RUN MULTIARCH=$(dpkg-architecture -qDEB_HOST_MULTIARCH) && \
    ln -sf /usr/include/$MULTIARCH/bits /usr/include/bits && \
    ln -sf /usr/include/$MULTIARCH/gnu /usr/include/gnu && \
    ln -sf /usr/include/$MULTIARCH/sys /usr/include/sys && \
    echo "MULTIARCH=$MULTIARCH" && \
    ln -sf /usr/lib/$MULTIARCH /usr/lib/multiarch-lib


RUN bash /app/coble/code/coble \
    build \
    --recipe /app/recipe/$BUILD_TAG.cbl \
    --validate /app/validate.sh \
    --val-folder /app/validate \
    $(if [ "$SKIP_ERRORS" = "true" ]; then echo "--skip-errors"; fi) \
    --env "${BUILD_TAG}"
#########################################################################################
RUN echo 'R_LIBS_USER=""' >> /opt/conda/envs/${BUILD_TAG}/lib/R/etc/Renviron.site
ENV PYTHONNOUSERSITE=1
# Initialize conda and set up auto-activation for Docker
RUN conda init bash && \
    echo "conda activate ${BUILD_TAG}" >> /root/.bashrc

# For Singularity: override host conda and activate environment
RUN mkdir -p /.singularity.d/env && \
    echo '#!/bin/bash' > /.singularity.d/env/99-conda.sh && \
    echo 'unset -f conda 2>/dev/null || true' >> /.singularity.d/env/99-conda.sh && \
    echo 'unset CONDA_EXE CONDA_PYTHON_EXE CONDA_SHLVL 2>/dev/null || true' >> /.singularity.d/env/99-conda.sh && \
    echo 'export PATH="/opt/conda/bin:$PATH"' >> /.singularity.d/env/99-conda.sh && \
    echo '. /opt/conda/etc/profile.d/conda.sh' >> /.singularity.d/env/99-conda.sh && \
    #echo 'conda config --set changeps1 true' >> /.singularity.d/env/99-conda.sh && \
    echo "conda activate ${BUILD_TAG} 2>/dev/null || true" >> /.singularity.d/env/99-conda.sh && \
    echo 'if [ "$PS1" ] && [ -f /etc/motd ]; then cat /etc/motd; fi' >> /.singularity.d/env/99-conda.sh && \
    chmod +x /.singularity.d/env/99-conda.sh

RUN conda clean -afy && \
    rm -rf /opt/conda/pkgs/* && \
    rm -rf /root/.cache/pip/*

# Clear the PAT after build for security
ENV GITHUB_PAT=

# Add a Message of the Day (MOTD)
RUN echo '╔══════════════════════════════════════════════════════════════╗' > /etc/motd && \
    echo '║        COBLE Container                                       ║' >> /etc/motd && \
    echo '║        (c) ICR 2026 RSE and BCDS                             ║' >> /etc/motd && \
    echo '║        For help, see:                                        ║' >> /etc/motd && \
    echo '║        - https://coble-tools.github.io/coble/                ║' >> /etc/motd && \
    echo '║        - https://github.com/coble-tools/coble/issues         ║' >> /etc/motd && \
    echo '╚══════════════════════════════════════════════════════════════╝' >> /etc/motd
# Ensure the message is shown on shell startup
RUN echo "cat /etc/motd" >> /root/.bashrc && \
    echo "cat /etc/motd" >> /etc/skel/.bashrc

CMD ["/bin/bash"]
