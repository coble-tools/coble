#!/usr/bin/env bash
source ~/.bashrc

# Initialize conda for bash shell
if [ -f "${CONDA_EXE%/bin/conda}/etc/profile.d/conda.sh" ]; then
    source "${CONDA_EXE%/bin/conda}/etc/profile.d/conda.sh"
elif [ -f "/opt/conda/etc/profile.d/conda.sh" ]; then
    source "/opt/conda/etc/profile.d/conda.sh"
elif [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
    source "$HOME/miniconda3/etc/profile.d/conda.sh"
elif [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
    source "$HOME/anaconda3/etc/profile.d/conda.sh"
fi

new_mamba_prefix=$1
mamba_yaml_output=$2
r_packages_output=$3
pip_packages_output=$4
coble_output=$5

echo "Starting in conda-step-export.sh at $(date)"
echo "=== >>> Activating... conda activate $new_mamba_prefix"
conda activate $new_mamba_prefix

echo ">>> Saving new conda environment to yaml file $mamba_yaml_output..."
conda env export -p $new_mamba_prefix > $mamba_yaml_output
echo ">>> Saving pip package list to $pip_packages_output..."
python -m pip freeze > $pip_packages_output
echo ">>> Saving R package list to $r_packages_output..."
Rscript -e "pkgs <- installed.packages()[,c('Package','Version')]; cat(paste0(pkgs[,'Package'], '==', pkgs[,'Version']), sep='\n', file='$r_packages_output')"

# Also want to export in the format that we can import so 1 file for the entire thing
echo "#coble-yml" > $coble_output
echo "name: $new_mamba_prefix" >> $coble_output

# Get current channels and write to both files
echo ">>> Getting current channel list..."
echo "channels:" >> $coble_output

conda config --show channels | grep -v "^channels:" | while IFS= read -r line || [ -n "$line" ]; do
  line_trimmed=$(echo "$line" | xargs)
  if [ -n "$line_trimmed" ]; then
    echo "- $line_trimmed" >> $coble_output    
  fi
done
echo "dependencies:" >> $coble_output

# Export Python and R versions first
echo ">>> Exporting Python and R versions..."
python_version=$(python --version 2>&1 | awk '{print $2}')
r_version=$(Rscript -e "cat(paste0(R.version\$major, '.', R.version\$minor))" 2>/dev/null)

if [ -n "$r_version" ]; then
  echo "  - r-base=$r_version" >> $coble_output  
  echo "    R version: $r_version"
fi

if [ -n "$python_version" ]; then
  echo "  - python=$python_version" >> $coble_output  
  echo "    Python version: $python_version"
fi

# Now both files are open and ready to receive package information
# Process conda packages
echo ">>> Processing conda packages for coble output files..."
conda list --explicit | grep -v "^#" | while IFS= read -r line || [ -n "$line" ]; do
  pkg_name_version=$(basename "$line" | sed 's/-[0-9].*//')
  pkg_version=$(basename "$line" | sed -E 's/.*-([0-9]+(\.[0-9]+)*).*/\1/')
  
  if [[ "$pkg_name_version" == @* ]] || [[ "$pkg_name_version" == r-base=* ]] || [[ "$pkg_name_version" == python=* ]]; then
    continue
  fi
  if [ -n "$pkg_name_version" ] && [ -n "$pkg_version" ]; then
    echo "  - $pkg_name_version=$pkg_version" >> $coble_output    
  fi
done

# Process R packages
echo ">>> Processing R packages for coble output files..."
echo "  - r_package:" >> $coble_output
while IFS= read -r line || [ -n "$line" ]; do
  pkg_name=$(echo "$line" | cut -d'=' -f1)
  pkg_version=$(echo "$line" | cut -d'=' -f3)
  if [ -n "$pkg_name" ] && [ -n "$pkg_version" ]; then
    echo "    - $pkg_name=$pkg_version" >> $coble_output    
  fi
done < "$r_packages_output"

# Process pip packages
echo ">>> Processing pip packages for coble output files..."
echo "  - pip:" >> $coble_output
while IFS= read -r line || [ -n "$line" ]; do
  pkg_name=$(echo "$line" | cut -d'=' -f1)
  pkg_version=$(echo "$line" | cut -d'=' -f3)
  if [ -n "$pkg_name" ] && [ -n "$pkg_version" ]; then    
    echo "    - $pkg_name==$pkg_version" >> $coble_output        
  fi
done < "$pip_packages_output"

  



  

