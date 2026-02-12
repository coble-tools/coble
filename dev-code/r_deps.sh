#!/usr/bin/env bash
#
# install_r_deps.sh — Install system build dependencies needed to compile R from source
#
# Run this ONCE before using install_r_source.sh.
# Requires sudo on Linux, Homebrew on macOS.
#
# Usage:
#   bash install_r_deps.sh

set -euo pipefail

OS="$(uname -s)"

echo "==> Installing R build dependencies"
echo "    OS: ${OS}"
echo ""

case "${OS}" in
    Linux)
        if command -v apt-get &>/dev/null; then
            echo "==> Detected apt (Debian/Ubuntu)..."
            sudo apt-get update -qq
            sudo apt-get install -y \
                build-essential \
                gfortran \
                libreadline-dev \
                libx11-dev \
                libxt-dev \
                libpng-dev \
                libjpeg-dev \
                libcairo2-dev \
                libbz2-dev \
                liblzma-dev \
                libcurl4-openssl-dev \
                libssl-dev \
                libxml2-dev \
                zlib1g-dev \
                libpcre2-dev \
                libpcre3-dev \
                libtiff5-dev \
                texinfo \
                wget \
                xorg-dev

        elif command -v dnf &>/dev/null; then
            echo "==> Detected dnf (Fedora/RHEL 8+)..."
            sudo dnf groupinstall -y "Development Tools"
            sudo dnf install -y \
                gcc-gfortran \
                readline-devel \
                libX11-devel \
                libXt-devel \
                libpng-devel \
                libjpeg-turbo-devel \
                cairo-devel \
                bzip2-devel \
                xz-devel \
                libcurl-devel \
                openssl-devel \
                libxml2-devel \
                zlib-devel \
                pcre-devel \
                pcre2-devel \
                libtiff-devel \
                texinfo \
                wget

        elif command -v yum &>/dev/null; then
            echo "==> Detected yum (CentOS/RHEL 7)..."
            sudo yum groupinstall -y "Development Tools"
            sudo yum install -y \
                gcc-gfortran \
                readline-devel \
                libX11-devel \
                libXt-devel \
                libpng-devel \
                libjpeg-turbo-devel \
                cairo-devel \
                bzip2-devel \
                xz-devel \
                libcurl-devel \
                openssl-devel \
                libxml2-devel \
                zlib-devel \
                pcre-devel \
                pcre2-devel \
                libtiff-devel \
                texinfo \
                wget
        else
            echo "ERROR: Unsupported Linux package manager."
            echo "       Please install R build dependencies manually."
            exit 1
        fi
        ;;

    Darwin)
        if ! command -v brew &>/dev/null; then
            echo "ERROR: Homebrew not found. Install it from https://brew.sh"
            exit 1
        fi
        echo "==> Detected macOS with Homebrew..."
        brew install \
            gcc \
            readline \
            xz \
            bzip2 \
            zlib \
            libpng \
            jpeg \
            libtiff \
            cairo \
            pango \
            curl \
            openssl \
            libxml2 \
            pcre2 \
            icu4c \
            texinfo \
            wget
        ;;

    *)
        echo "ERROR: Unsupported OS '${OS}'."
        exit 1
        ;;
esac

echo ""
echo "Done! System dependencies are installed."
echo "You can now run: bash install_r_source.sh <version>"