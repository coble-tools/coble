#!/usr/bin/env bash

# Example conda test script for coble
set -e

echo "Running coble conda package tests..."

# Test if main script is on PATH and prints help
if command -v coble-recipise.sh >/dev/null 2>&1; then
    echo "[PASS] coble-recipise.sh is on PATH"
    coble-recipise.sh --help || { echo "[FAIL] coble-recipise.sh --help failed"; exit 1; }
else
    echo "[FAIL] coble-recipise.sh not found on PATH"; exit 1
fi

echo "All basic tests passed."
