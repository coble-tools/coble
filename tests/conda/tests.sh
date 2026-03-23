#!/usr/bin/env bash

set -e

echo "Running coble conda package tests..."

# Check main binary is on PATH
if command -v coble >/dev/null 2>&1; then
    echo "[PASS] coble is on PATH"
else
    echo "[FAIL] coble not found on PATH"; exit 1
fi

# Check there are multiple .sh scripts installed
SH_COUNT=$(ls "$PREFIX/bin/coble-"*.sh 2>/dev/null | wc -l)
if [ "$SH_COUNT" -gt 3 ]; then
    echo "[PASS] $SH_COUNT coble .sh scripts found"
else
    echo "[FAIL] Expected more than 3 .sh scripts, found $SH_COUNT"; exit 1
fi

# Check there are multiple .cbl templates installed
CBL_COUNT=$(ls "$PREFIX/bin/tml_"*.cbl 2>/dev/null | wc -l)
if [ "$CBL_COUNT" -gt 3 ]; then
    echo "[PASS] $CBL_COUNT .cbl templates found"
else
    echo "[FAIL] Expected more than 3 .cbl templates, found $CBL_COUNT"; exit 1
fi

echo "All tests passed."