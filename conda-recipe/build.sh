#!/bin/bash

# Create bin directory in the conda environment
mkdir -p $PREFIX/bin

# Copy your script to the bin directory
cp code/coble.sh $PREFIX/bin/coble
cp code/coble-capture.sh $PREFIX/bin/coble-capture.sh
cp code/coble-recreate.sh $PREFIX/bin/coble-recreate.sh
cp code/coble-recipise.sh $PREFIX/bin/coble-recipise.sh

# Make it executable
chmod +x $PREFIX/bin/coble
chmod +x $PREFIX/bin/coble-capture.sh
chmod +x $PREFIX/bin/coble-recreate.sh
chmod +x $PREFIX/bin/coble-recipise.sh