#!/usr/bin/env bash
# export the input command first
echo "Starting in conda-step-create.sh at $(date)."

conda_exe=$1
new_mamba_prefix=$2
new_mamba_pkgs=$3
r_version=$4
python_version=$5
bash_script_output=$6
quiet=$7
exit_error=$8
dry_run=$9
output_file=${10}
error_file=${11}

# Bypass conda TOS checks
export CONDA_TOS_ACCEPTED=yes

echo "source ~/.bashrc" >> $bash_script_output
echo "export CONDA_PKGS_DIRS=$new_mamba_pkgs" >> $bash_script_output
if [ -d "$new_mamba_prefix" ]; then      
        echo "rm -rf $new_mamba_prefix" >> $bash_script_output
fi    
if [ -d "$new_mamba_pkgs" ]; then      
    echo "rm -rf $new_mamba_pkgs" >> $bash_script_output
fi
echo "conda clean --packages --tarballs -y" >> $bash_script_output
echo "$conda_exe create -y -q --override-channels -p $new_mamba_prefix -c conda-forge $r_version $python_version" >> $bash_script_output

if [[ $dry_run == "run" ]]; then                
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
    echo "=== >>> Creating... $conda_exe create -y -q --override-channels -c conda-forge -p $new_mamba_prefix $r_version $python_version "      
    start_time=$(date +%s)
    $conda_exe create -y -q --override-channels -c conda-forge -p $new_mamba_prefix $r_version $python_version
    end_time=$(date +%s)
    echo "# Time taken: $(($end_time - $start_time)) seconds." >> $bash_script_output
fi
