echo "--------------------------"
echo "Running validation script for Velton et al. 2025"
echo "--------------------------"
cwd=$(pwd)
cd $CONDA_PREFIX
Rscript bin/fig1.R $cwd
Rscript bin/fig1c.R $cwd
echo "Validation complete!"
