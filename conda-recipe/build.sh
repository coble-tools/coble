#!/bin/bash
set -euo pipefail

mkdir -p "$PREFIX/bin"

# Copy and make executable all coble-* files (scripts, R files, Dockerfile, etc.)
for f in code/coble*; do
    cp "$f" "$PREFIX/bin/"
    chmod +x "$PREFIX/bin/$(basename "$f")"
done

# Copy .cbl templates as-is — not executable
for f in code/tml_*.cbl; do
    cp "$f" "$PREFIX/bin/"
done

# Non-executable extras
cp README.md "$PREFIX/bin/README.md"