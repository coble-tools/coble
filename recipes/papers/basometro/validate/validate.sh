#!/usr/bin/env bash

echo "================================================================================================"
echo "Validate the basometro recipe in an interactive session by running the jupyter notebook"
echo "The notebook should run without errors and generate outputs"
echo "Select the notebook: mattree_basometro.ipynb"
echo "Then in the top left select the enviornment: Python (mat_basometro)"
echo ""
echo ""
echo " jupyter lab \\"
echo "    --NotebookApp.token='' \\"
echo "    --NotebookApp.password='' \\"
echo "    --notebook-dir=$CONDA_PREFIX/GitHub/mat-basometro \\"
echo "    $CONDA_PREFIX/GitHub/mat-basometro/mattree_basometro.ipynb"
echo ""
echo ""
echo "================================================================================================"
echo "Additionally, this script performs a minor environment check for scripting environments..."#
echo "================================================================================================"

start_dir=$(pwd)
python $CONDA_PREFIX/GitHub/mat-basometro/mattree_basometro.py $start_dir/output

echo "Files have been saved to:"
echo "  $start_dir/output/*.html"
echo "  $start_dir/output/images/*.pdf"
echo "  $start_dir/output/preprocessing/*.csv"


