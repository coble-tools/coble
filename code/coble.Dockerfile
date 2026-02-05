################### GENERIC COBLE DOCKERFILE ############################
# Build with local recipe:
#
# docker build -f code/coble.Dockerfile \
#   --build-arg RECIPE_CBL=my-recipe.cbl \
#   --build-arg BUILD_TAG=my-env \
#   --build-arg GITHUB_PAT=mytoken \
#   --build-arg VAL_FILE=validate.sh \
#   --build-arg VAL_FOLDER=folder to copy \
#   --build-arg BANNER=optional branding change to ICR \
#   -t cbl-my-env .
#########################################################################

ARG TARGETPLATFORM
#FROM --platform=$TARGETPLATFORM continuumio/miniconda3:latest
FROM continuumio/miniconda3:latest
WORKDIR /app

# Build arguments for customization
ARG BUILD_TAG=custom
ARG RECIPE_CBL=""
ARG SKIP_ERRORS=false
ARG GITHUB_PAT=""
ARG VAL_FILE=""
ARG VAL_FOLDER=""
ARG BANNER=""

ENV CONDA_VERBOSITY=2

# Set environment variables
ENV COBLE_VARIANT=${BUILD_TAG}
ENV GITHUB_PAT=${GITHUB_PAT}
LABEL org.opencontainers.image.version="${BUILD_TAG}" \
    org.opencontainers.image.title="coble-${BUILD_TAG}" \
    org.opencontainers.image.description="COBLE reproducible bioinformatics environment" \
    org.opencontainers.image.source="https://github.com/ICR-RSE-Group/coble" \
    org.opencontainers.image.licenses="MIT"

# Set timeouts
RUN conda config --set remote_read_timeout_secs 180 && \
    conda config --set remote_connect_timeout_secs 60 && \
    conda config --set remote_max_retries 10

# Ensure all channels cleaned out we only want to add ones we want
RUN conda config --system --remove-key channels 2>/dev/null || true

# Update conda to latest version
RUN conda update -n base -c defaults conda -y && conda clean -afy

RUN echo "=== BUILD ARGUMENTS ===" && \
    echo "GITHUB_PAT: ${GITHUB_PAT}" && \
    echo "BUILD_TAG: ${BUILD_TAG}" && \
    echo "RECIPE_CBL: ${RECIPE_CBL}" && \
    echo "SKIP_ERRORS: ${SKIP_ERRORS}" && \
    echo "VAL_FILE: ${VAL_FILE}" && \
    echo "VAL_FOLDER: ${VAL_FOLDER}" && \
    echo "BANNER: ${BANNER}" && \
    echo "======================"

# Configure timezone to prevent interactive prompts during apt-get
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/London

# Install system dependencies
RUN apt-get -o Acquire::Retries=3 -o Acquire::AllowReleaseInfoChange=true update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        gfortran \
        binutils-gold \
        zlib1g-dev \
        libgomp1 \
        gettext \
        curl \
        git \
        wget \
        default-jdk-headless \
        libmagick++-dev \
        libx11-dev \
        libxt-dev \
        ca-certificates \
        libcurl4-openssl-dev \
        libssl-dev \
        libxml2-dev \
        libfontconfig1-dev \
        libharfbuzz-dev \
        libfribidi-dev \
        libfreetype6-dev \
        libpng-dev \
        libtiff5-dev \
        libjpeg-dev \
        libicu-dev \
        libbz2-dev \
        liblzma-dev \
        libpcre2-dev \
    && rm -rf /var/lib/apt/lists/*

ENV MAMBA_NO_BANNER=1

# May need to set java home
#ENV JAVA_HOME=/usr/lib/jvm/default-java

# for v8 builds
ENV DOWNLOAD_STATIC_LIBV8=1

# Create directory structure
RUN mkdir -p code recipe validate
# Install coble from GitHub
COPY code ./code

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


# Extra validation files (only if folder specified)
COPY ${VAL_FOLDER:-code/validate}/ /app/validate/

# Create .condarc with channels
RUN echo "channels:" > /app/.condarc && \
    echo "  - conda-forge" >> /app/.condarc && \
    echo "  - bioconda" >> /app/.condarc && \        
    echo "  - defaults" >> /app/.condarc && \
    echo "notify_outdated_conda: false" >> /app/.condarc && \
    echo "channel_priority: strict" >> /app/.condarc

ENV CONDARC=/app/.condarc

######################### COBLE ##########################################################
RUN bash /app/code/coble \            
    build \    
    --recipe /app/recipe/$BUILD_TAG.cbl \
    --validate /app/validate.sh \
    --val-folder /app/validate \
    $(if [ "$SKIP_ERRORS" = "true" ]; then echo "--skip-errors"; fi) \      
    --env "${BUILD_TAG}"
#########################################################################################

# Initialize conda and set up auto-activation for Docker
RUN conda init bash && \
    echo "conda activate ${BUILD_TAG}" >> /root/.bashrc

# For Singularity: override host conda and activate environment
RUN mkdir -p /.singularity.d/env && \
    echo '#!/usr/bin/env bash' > /.singularity.d/env/99-conda.sh && \
    echo 'unset -f conda 2>/dev/null || true' >> /.singularity.d/env/99-conda.sh && \
    echo 'unset CONDA_EXE CONDA_PYTHON_EXE CONDA_SHLVL 2>/dev/null || true' >> /.singularity.d/env/99-conda.sh && \
    echo 'export PATH="/opt/conda/bin:$PATH"' >> /.singularity.d/env/99-conda.sh && \
    echo '. /opt/conda/etc/profile.d/conda.sh' >> /.singularity.d/env/99-conda.sh && \
    echo 'conda config --set changeps1 true' >> /.singularity.d/env/99-conda.sh && \
    echo "conda activate ${BUILD_TAG} 2>/dev/null || true" >> /.singularity.d/env/99-conda.sh && \
    echo 'if [ "$PS1" ] && [ -f /etc/motd ]; then cat /etc/motd; fi' >> /.singularity.d/env/99-conda.sh && \
    chmod +x /.singularity.d/env/99-conda.sh

RUN conda clean -afy

# Clear the PAT after build for security
ENV GITHUB_PAT=


# Conditional message of the day (motd) based on BANNER
RUN if [ "$BANNER" == "ICR" ]; then \
      echo '╔════════════════════════════════════════════════════════╗' > /etc/motd && \
      echo '║        (c) ICR 2026 Scientific Computing               ║' >> /etc/motd && \  
      echo '╚════════════════════════════════════════════════════════╝' >> /etc/motd; \     
    else \
      echo '╔══════════════════════════════════════════════════════════════╗' > /etc/motd && \
      echo '║        COBLE Container v0.2                                  ║' >> /etc/motd && \
      echo '║        (c) ICR 2026 RSE and BCR-DS                           ║' >> /etc/motd && \
      echo '║        For help, see:                                        ║' >> /etc/motd && \    
      echo '║        - https://icr-rse-group.github.io/coble/              ║' >> /etc/motd && \
      echo '║        - https://github.com/ICR-RSE-Group/coble/issues       ║' >> /etc/motd && \    
      echo '╚══════════════════════════════════════════════════════════════╝' >> /etc/motd; \     
    fi
    

# Add a Message of the Day (MOTD)
RUN echo '╔══════════════════════════════════════════════════════════════╗' > /etc/motd && \
    echo '║        COBLE Container v0.2                                  ║' >> /etc/motd && \
    echo '║        (c) ICR 2026 RSE and BCR-DS                           ║' >> /etc/motd && \
    echo '║        For help, see:                                        ║' >> /etc/motd && \    
    echo '║        - https://icr-rse-group.github.io/coble/              ║' >> /etc/motd && \
    echo '║        - https://github.com/ICR-RSE-Group/coble/issues       ║' >> /etc/motd && \    
    echo '╚══════════════════════════════════════════════════════════════╝' >> /etc/motd    
# Ensure the message is shown on shell startup
RUN echo "cat /etc/motd" >> /root/.bashrc && \
    echo "cat /etc/motd" >> /etc/skel/.bashrc

CMD ["/bin/bash"]
