#!/bin/bash

# Create bin directory in the conda environment
mkdir -p $PREFIX/bin

# Copy your script to the bin directory
cp code/coble $PREFIX/bin/coble
cp code/coble-capture.sh $PREFIX/bin/coble-capture.sh
cp code/coble-errors.sh $PREFIX/bin/coble-errors.sh
cp code/coble-rationalise.sh $PREFIX/bin/coble-rationalise.sh
cp code/coble-resolve.sh $PREFIX/bin/coble-resolve.sh
cp code/coble-update.sh $PREFIX/bin/coble-update.sh
cp code/coble-capture-r.R $PREFIX/bin/coble-capture-r.R
cp code/coble-create.sh $PREFIX/bin/coble-create.sh
cp code/coble-find.sh $PREFIX/bin/coble-find.sh
cp code/coble-recipise.sh $PREFIX/bin/coble-recipise.sh
cp code/coble-template.sh $PREFIX/bin/coble-template.sh
# templates
cp code/tml_bioinf.cbl $PREFIX/bin/coble-tml_bioinf.sh
cp code/tml_sylver.cbl $PREFIX/bin/coble-tml_sylver.sh
cp code/tml_basic.cbl $PREFIX/bin/coble-tml_basic.sh
cp code/tml_fix.cbl $PREFIX/bin/coble-tml_fix.sh
cp code/tml_versions.cbl $PREFIX/bin/coble-tml_versions.sh
cp code/tml_bash.cbl $PREFIX/bin/coble-tml_bash.sh
# Docker and singularity
cp code/coble-container.sh $PREFIX/bin/coble-container.sh
cp code coble.Dockerfile $PREFIX/bin/coble.Dockerfile
# readme
cp README.md $PREFIX/bin/README.md

# Make them executable
chmod +x $PREFIX/bin/coble
chmod +x $PREFIX/bin/coble-capture.sh
chmod +x $PREFIX/bin/coble-errors.sh
chmod +x $PREFIX/bin/coble-rationalise.sh
chmod +x $PREFIX/bin/coble-resolve.sh
chmod +x $PREFIX/bin/coble-update.sh
chmod +x $PREFIX/bin/coble-tml_bioinf.sh
chmod +x $PREFIX/bin/coble-tml_sylver.sh
chmod +x $PREFIX/bin/coble-capture-r.R
chmod +x $PREFIX/bin/coble-create.sh
chmod +x $PREFIX/bin/coble-find.sh
chmod +x $PREFIX/bin/coble-recipise.sh
chmod +x $PREFIX/bin/coble-template.sh
chmod +x $PREFIX/bin/coble-tml_basic.sh
chmod +x $PREFIX/bin/coble-tml_fix.sh
chmod +x $PREFIX/bin/coble-tml_versions.sh
chmod +x $PREFIX/bin/coble-tml_bash.sh
chmod +x $PREFIX/bin/coble-container.sh