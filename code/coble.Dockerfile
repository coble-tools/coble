################### GENERIC COBLE DOCKERFILE ############################
# Build with custom recipe:
# docker build -f containers/docker/Dockerfile.generic \
#   --build-arg RECIPE_URL=https://mysite.com/my-recipe.sh \
#   --build-arg BUILD_TAG=my-env \
#   --build-arg R_VERSION=4.5.2 \
#   --build-arg PYTHON_VERSION=3.14.0 \
#   -t myname/my-env:latest .
#
# Or with local recipe:
# docker build -f containers/docker/Dockerfile.generic \
#   --build-arg RECIPE_FILE=my-local-recipe.sh \
#   --build-arg BUILD_TAG=my-env \
#   -t myname/my-env:latest .
#########################################################################

FROM continuumio/miniconda3
WORKDIR /app

# Build arguments for customization
ARG BUILD_TAG=custom
ARG RECIPE_CBL=""
ARG SKIP_ERRORS=false

# Set environment variables
ENV COBLE_VARIANT=${BUILD_TAG}

LABEL org.opencontainers.image.version="${BUILD_TAG}" \
    org.opencontainers.image.title="coble-${BUILD_TAG}" \
    org.opencontainers.image.description="COBLE reproducible bioinformatics environment" \
    org.opencontainers.image.source="https://github.com/ICR-RSE-Group/coble" \
    org.opencontainers.image.licenses="MIT"

# Update conda to latest version
RUN conda update -n base -c defaults conda -y && conda clean -afy

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        zlib1g-dev \
        libgomp1 \
        gettext \
        curl \
        git \
    && rm -rf /var/lib/apt/lists/*

ENV MAMBA_NO_BANNER=1

# Create directory structure
RUN mkdir -p code recipe
# Install coble from GitHub
COPY code ./code

# Recipe cbl is copied to standard location
COPY $RECIPE_CBL /app/recipe/$BUILD_TAG.cbl

# Create .condarc with channels
RUN echo "channels:" > /app/.condarc && \
    echo "  - conda-forge" >> /app/.condarc && \
    echo "  - bioconda" >> /app/.condarc && \    
    echo "  - R" >> /app/.condarc && \
    echo "  - defaults" >> /app/.condarc && \
    echo "notify_outdated_conda: false" >> /app/.condarc && \
    echo "channel_priority: strict" >> /app/.condarc

ENV CONDARC=/app/.condarc

######################### COBLE ##########################################################
RUN bash /app/code/coble \            
    build \    
    --input /app/recipe/$BUILD_TAG.cbl \
    $(if [ "$SKIP_ERRORS" = "true" ]; then echo "--skip-errors"; fi) \      
    --env "coble"
#########################################################################################

# Initialize conda and set up auto-activation for Docker
RUN conda init bash && \
    echo "conda activate coble" >> /root/.bashrc

# For Singularity: override host conda and activate environment
RUN mkdir -p /.singularity.d/env && \
    echo '#!/bin/bash' > /.singularity.d/env/99-conda.sh && \
    echo 'unset -f conda 2>/dev/null || true' >> /.singularity.d/env/99-conda.sh && \
    echo 'unset CONDA_EXE CONDA_PYTHON_EXE CONDA_SHLVL 2>/dev/null || true' >> /.singularity.d/env/99-conda.sh && \
    echo 'export PATH="/opt/conda/bin:$PATH"' >> /.singularity.d/env/99-conda.sh && \
    echo '. /opt/conda/etc/profile.d/conda.sh' >> /.singularity.d/env/99-conda.sh && \
    echo 'conda activate coble 2>/dev/null || true' >> /.singularity.d/env/99-conda.sh && \
    echo 'if [ "$PS1" ] && [ -f /etc/motd ]; then cat /etc/motd; fi' >> /.singularity.d/env/99-conda.sh && \
    chmod +x /.singularity.d/env/99-conda.sh

RUN conda clean -afy

# Add a Message of the Day (MOTD)
RUN echo '╔══════════════════════════════════════════════════════════════╗' > /etc/motd && \
    echo '║        COBLE Container v0.1                                  ║' >> /etc/motd && \
    echo '║        (c) ICR 2025 RSE and BCRDS                            ║' >> /etc/motd && \
    echo '║        For help, see:                                        ║' >> /etc/motd && \
    echo '║        - /app/README.md                                      ║' >> /etc/motd && \
    echo '║        - https://icr-rse-group.github.io/coble/              ║' >> /etc/motd && \
    echo '║        - https://github.com/ICR-RSE-Group/coble/issues       ║' >> /etc/motd && \
    echo '║        ~~~~~~~~~~~~~~~~~~~~~~~~~                             ║' >> /etc/motd && \
    echo '║        conda activate coble                                  ║' >> /etc/motd && \
    echo '╚══════════════════════════════════════════════════════════════╝' >> /etc/motd    
# Ensure the message is shown on shell startup
RUN echo "cat /etc/motd" >> /root/.bashrc && \
    echo "cat /etc/motd" >> /etc/skel/.bashrc

CMD ["/bin/bash"]
