#!/usr/bin/env bash
# Wrapper script for Stan CI testing

set -e

# Check required files exist
if [ ! -f "test.stan" ]; then
    echo "Error: test.stan not found"
    exit 1
fi

if [ ! -f "test_stan.py" ]; then
    echo "Error: test_stan.py not found"
    exit 1
fi

# Run the test
python test_stan.py

# Cleanup compiled files (optional)
rm -f test test.hpp