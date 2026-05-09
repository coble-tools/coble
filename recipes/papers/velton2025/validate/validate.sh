echo "--------------------------"
echo "Running validation script for Velton et al. 2025"
echo "--------------------------"
cwd=$(pwd)
cd $CONDA_PREFIX
Rscript bin/fig1.R $cwd
echo "Validation complete!"
