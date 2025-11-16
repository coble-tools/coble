#!/usr/bin/env bash
# export the input command first
echo "Starting in conda-step-create.sh at $(date)."

conda_exe=$1
new_mamba_prefix=$2
new_mamba_pkgs=$3
r_version=$4
python_version=$5
bash_script_output=$6
dry_run=$7

echo "source ~/.bashrc" >> $bash_script_output
echo "export CONDA_PKGS_DIRS=$new_mamba_pkgs" >> $bash_script_output
if [ -d "$new_mamba_prefix" ]; then      
        echo "rm -rf $new_mamba_prefix" >> $bash_script_output
fi    
if [ -d "$new_mamba_pkgs" ]; then      
    echo "rm -rf $new_mamba_pkgs" >> $bash_script_output
fi
echo "conda clean --packages --tarballs -y" >> $bash_script_output
echo "$conda_exe create -y -q -p $new_mamba_prefix $r_version $python_version" >> $bash_script_output

if [[ $dry_run == "run" ]]; then                
    source ~/.bashrc    
    export CONDA_PKGS_DIRS=$new_mamba_pkgs    
    # remove everything at the prefix if it exists
    if [ -d "$new_mamba_prefix" ]; then
        echo "Removing existing conda env at $new_mamba_prefix"
        rm -rf "$new_mamba_prefix"        
    fi
    # remove all the packages too
    if [ -d "$new_mamba_pkgs" ]; then
        echo "Removing existing conda pkgs at $new_mamba_pkgs"
        rm -rf "$new_mamba_pkgs"        
    fi
    # clean tarballs
    conda clean --packages --tarballs -y    
    echo "=== >>> Creating... $conda_exe create -y -q -p $new_mamba_prefix $r_version $python_version "      
    start_time=$(date +%s)
    $conda_exe create -y -q -p $new_mamba_prefix $r_version $python_version
    end_time=$(date +%s)
    echo "# Time taken: $(($end_time - $start_time)) seconds." >> $bash_script_output
fi
