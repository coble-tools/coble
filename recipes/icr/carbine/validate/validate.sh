#!/usr/bin/env bash
# Wrapper script for Stan CI testing

set -e

# Check required files exist
if [ ! -f "$CONDA_PREFIX/bin/run.stan" ]; then
    echo "Error: run.stan not found"
    exit 1
fi

if [ ! -f "$CONDA_PREFIX/bin/run_stan.py" ]; then
    echo "Error: run_stan.py not found"
    exit 1
fi

# Run the test
python "$CONDA_PREFIX/bin/run_stan.py"

# Cleanup compiled files (optional)
rm -f "$CONDA_PREFIX/bin/run" "$CONDA_PREFIX/bin/run.hpp"