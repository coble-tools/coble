#!/usr/bin/env bash

#
# install_r_build_deps_apt.sh — Install system dependencies for building R from source
#
# For Debian/Ubuntu systems (Docker images, CI runners, WSL)
# Requires sudo (or run as root in Docker)
#
# Usage:
#   bash install_r_build_deps_apt.sh

set -euo pipefail

echo "==> Installing R build dependencies (apt)..."

apt-get update -qq

apt-get install -y --no-install-recommends \
    build-essential \
    gfortran \
    wget \
    pkg-config \
    libreadline-dev \
    libx11-dev \
    libxt-dev \
    libpng-dev \
    libjpeg-dev \
    libcairo2-dev \
    libbz2-dev \
    bzip2 \
    liblzma-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    libpcre2-dev \
    libpcre3-dev \
    libtiff-dev \
    libicu-dev \
    texinfo \
    xorg-dev

    

rm -rf /var/lib/apt/lists/*

echo "==> Done."