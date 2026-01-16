FROM continuumio/miniconda3:latest

# Install dependencies for building bash
RUN apt-get update && apt-get install -y \
    wget \
    build-essential \
    bison \
    && rm -rf /var/lib/apt/lists/*

# Build and install bash 3.2 to /usr/local/bin/bash3
RUN cd /tmp && \
    wget https://ftp.gnu.org/gnu/bash/bash-3.2.57.tar.gz && \
    tar xzf bash-3.2.57.tar.gz && \
    cd bash-3.2.57 && \
    ./configure --prefix=/usr/local && \
    make && \
    make install && \
    rm -rf bash-3.2.57*

# Make bash 3.2 the default /bin/bash
RUN mv /bin/bash /bin/bash.orig && \
    ln -s /usr/local/bin/bash /bin/bash

# Create non-root user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/bash \
    && mkdir -p /etc/sudoers.d \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME