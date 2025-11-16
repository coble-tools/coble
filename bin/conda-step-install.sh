#!/usr/bin/env bash
conda_exe=$1
new_mamba_prefix=$2
new_mamba_pkgs=$3
bash_script_output=$4
mamba_yaml_input=$5
dry_run=$6

echo "# Starting in conda-step-install.sh at $(date)" >> $bash_script_output

source ~/.bashrc
echo "Starting in conda-step-install.sh at $(date)"
echo "=== >>> Activating... $conda_exe activate $new_mamba_prefix"
echo "$conda_exe activate $new_mamba_prefix" >> $bash_script_output  
$conda_exe activate $new_mamba_prefix

export CONDA_PKGS_DIRS=$new_mamba_pkgs

is_channel=False; is_package=False; is_pip=False; \
is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
is_r_conda=False; is_github=False; is_wget=False; is_bash=False
install_source=""
total_lines=$(wc -l < "$mamba_yaml_input")
current_line=0
start_time=$(date +%s)
while IFS= read -r line || [ -n "$line" ]; do
current_line=$((current_line+1))
now_time=$(date +%s)
elapsed=$((now_time - start_time))
now_str=$(date '+%Y-%m-%d %H:%M:%S')
echo "$current_line/$total_lines - [$now_str | +${elapsed}s] === >>> Processing: $line"
line_cleaned=${line#*- } # need to strip from the - and the first space
line_cleaned=$(echo "$line_cleaned" | xargs) # trim trailing/leading whitespace
if [[ $line_cleaned == \#* || -z $line_cleaned ]]; then
    echo "=== === >>> Skipping comment or empty line."
    continue
fi
if [[ $line == *"channels:"* ]]; then
    is_channel=False; is_package=False; is_pip=False; \
    is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
    is_r_conda=False; is_github=False; is_wget=False; is_bash=False
    is_channel=True    
    echo "=== === >>> Switching to channel mode. === === >>>"
    echo "=== === >>> Switching to channel mode. === === >>>" >&2
    echo "# === === >>> Switching to channel mode." >> $bash_script_output
elif [[ $line == *"dependencies:"* ]]; then
    is_channel=False; is_package=False; is_pip=False; \
    is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
    is_r_conda=False; is_github=False; is_wget=False; is_bash=False
    is_package=True
    install_source="conda"
    echo "=== === >>> Switching to package mode. === === >>>"
    echo "=== === >>> Switching to package mode. === === >>>" >&2
    echo "# === === >>> Switching to package mode." >> $bash_script_output
elif [[ $line == *"  - conda:"* ]]; then
    is_channel=False; is_package=False; is_pip=False; \
    is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
    is_r_conda=False; is_github=False; is_wget=False; is_bash=False
    is_package=True
    install_source="conda"
    # conda_exe="conda"
    echo "=== === >>> Switching to package mode. === === >>>"
    echo "=== === >>> Switching to package mode. === === >>>" >&2
    echo "# === === >>> Switching to package mode. $conda_exe" >> $bash_script_output
elif [[ $line == *"  - mamba:"* ]]; then
    is_channel=False; is_package=False; is_pip=False; \
    is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
    is_r_conda=False; is_github=False; is_wget=False; is_bash=False
    is_package=True
    install_source="conda"
    # conda_exe="mamba"
    echo "=== === >>> Switching to package mode. === === >>>"
    echo "=== === >>> Switching to package mode. === === >>>" >&2
    echo "# === === >>> Switching to package mode. $conda_exe" >> $bash_script_output
elif [[ $line == *"  - anaconda:"* ]]; then
    is_channel=False; is_package=False; is_pip=False; \
    is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
    is_r_conda=False; is_github=False; is_wget=False; is_bash=False
    is_package=True
    install_source="conda"
    # conda_exe="/opt/software/applications/anaconda/3/bin/conda"
    echo "=== === >>> Switching to package mode. === === >>>"
    echo "=== === >>> Switching to package mode. === === >>>" >&2
    echo "# === === >>> Switching to package mode. $conda_exe" >> $bash_script_output
elif [[ $line == *"prefix:"* ]]; then
    is_channel=False; is_package=False; is_pip=False; \
    is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
    is_r_conda=False; is_github=False; is_wget=False; is_bash=False
elif [[ $line == *"  - pip:"* ]]; then
    is_channel=False; is_package=False; is_pip=False; \
    is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
    is_r_conda=False; is_github=False; is_wget=False; is_bash=False
    is_pip=True
    install_source="pip"
    echo "=== === >>> Switching to pip mode. === === >>>"
    echo "=== === >>> Switching to pip mode. === === >>>" >&2
    echo "# === === >>> Switching to pip mode." >> $bash_script_output
elif [[ $line == *"  - r_conda:"* ]]; then
    is_channel=False; is_package=False; is_pip=False; \
    is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
    is_r_conda=False; is_github=False; is_wget=False; is_bash=False
    is_r_conda=True
    install_source="r-conda"
    echo "=== === >>> Switching to R conda mode. === === >>>"
    echo "=== === >>> Switching to R conda mode. === === >>>" >&2
    echo "# === === >>> Switching to R conda mode." >> $bash_script_output
elif [[ $line == *"  - r_package:"* ]]; then
    is_channel=False; is_package=False; is_pip=False; \
    is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
    is_r_conda=False; is_github=False; is_wget=False; is_bash=False
    is_r_package=True
    install_source="r-package"
    echo "=== === >>> Switching to R package mode. === === >>>"
    echo "=== === >>> Switching to R package mode. === === >>>" >&2
    echo "# === === >>> Switching to R package mode." >> $bash_script_output
elif [[ $line == *"  - bio_conda:"* ]]; then
    is_channel=False; is_package=False; is_pip=False; \
    is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
    is_r_conda=False; is_github=False; is_wget=False; is_bash=False
    is_bioc_conda=True
    install_source="bio-conda"
    echo "=== === >>> Switching to Bioconda mode. === === >>>"
    echo "=== === >>> Switching to Bioconda mode. === === >>>" >&2
    echo "# === === >>> Switching to Bioconda mode." >> $bash_script_output
elif [[ $line == *"  - bio_package:"* ]]; then
    is_channel=False; is_package=False; is_pip=False; \
    is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
    is_r_conda=False; is_github=False; is_wget=False; is_bash=False
    is_biocmanager=True
    install_source="bio-package"
    echo "=== === >>> Switching to BiocManager mode."
    echo "=== === >>> Switching to BiocManager mode." >&2
    echo "# === === >>> Switching to BiocManager mode." >> $bash_script_output
elif [[ $line == *"  - github:"* ]]; then
    is_channel=False; is_package=False; is_pip=False; \
    is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
    is_r_conda=False; is_github=False; is_wget=False; is_bash=False
    is_github=True
    install_source="github"
    echo "=== === >>> Switching to GitHub mode."
    echo "=== === >>> Switching to GitHub mode." >&2
    echo "# === === >>> Switching to GitHub mode." >> $bash_script_output
elif [[ $line == *"  - wget:"* ]]; then
    is_channel=False; is_package=False; is_pip=False; \
    is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
    is_r_conda=False; is_github=False; is_wget=False; is_bash=False
    is_wget=True
    install_source="wget"
    echo "=== === >>> Switching to wget mode."
    echo "=== === >>> Switching to wget mode." >&2
    echo "# === === >>> Switching to wget mode." >> $bash_script_output
elif [[ $line == *"  - bash:"* ]]; then
    is_channel=False; is_package=False; is_pip=False; \
    is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
    is_r_conda=False; is_github=False; is_wget=False; is_bash=False
    is_bash=True
    install_source="bash"
    echo "=== === >>> Switching to bash mode."
    echo "=== === >>> Switching to bash mode." >&2
    echo "# === === >>> Switching to bash mode." >> $bash_script_output
elif [[ $is_channel == True ]]; then
    echo "=== === >>> Adding channel: $line_cleaned"      
    echo "$conda_exe config --add channels $line_cleaned" >> $bash_script_output
    if [[ $dry_run == "run" ]]; then      
      $conda_exe config --add channels $line_cleaned          
    fi      
elif [[ $is_package == True ]]; then                        
    echo "=== === >>> INSTALLING: $conda_exe install -y -q $line_cleaned --freeze-installed"
    echo "$conda_exe install -y -q $line_cleaned --freeze-installed" >> $bash_script_output
    if [[ $dry_run == "run" ]]; then
      start_time=$(date +%s)
      $conda_exe install -y -q $line_cleaned --freeze-installed
      end_time=$(date +%s)
      echo "# Time taken: $(($end_time - $start_time)) seconds." >> $bash_script_output
    fi
    conda_list+=("$line_cleaned:$install_source")
elif [[ $is_pip == True ]]; then
    echo "=== === >>> INSTALLING: python -m pip install $line_cleaned"
    echo "python -m pip install $line_cleaned" >> $bash_script_output
    if [[ $dry_run == "run" ]]; then
      start_time=$(date +%s)
      python -m pip install $line_cleaned
      end_time=$(date +%s)
      echo "# Time taken: $(($end_time - $start_time)) seconds." >> $bash_script_output
    fi
    conda_list+=("$line_cleaned:$install_source")
elif [[ $is_r_conda == True ]]; then                        
    echo "=== === >>> INSTALLING: $conda_exe install -y -q r-$line_cleaned --freeze-installed"
    echo "$conda_exe install -y -q r-$line_cleaned --freeze-installed" >> $bash_script_output
    if [[ $dry_run == "run" ]]; then
      start_time=$(date +%s)
      $conda_exe install -y -q r-$line_cleaned --freeze-installed
      end_time=$(date +%s)
      echo "# Time taken: $(($end_time - $start_time)) seconds." >> $bash_script_output
    fi
    conda_list+=("$line_cleaned:$install_source")
elif [[ $is_r_package == True ]]; then
    echo "=== === >>> INSTALLING: Rscript -e \"install.packages('$line_cleaned', repo='https://cloud.r-project.org',force=TRUE,quiet=TRUE)\""
    echo "Rscript -e \"install.packages('$line_cleaned', repo='https://cloud.r-project.org',force=TRUE,quiet=TRUE)\"" >> $bash_script_output
    if [[ $dry_run == "run" ]]; then
      start_time=$(date +%s)
      Rscript -e "install.packages('$line_cleaned', repo='https://cloud.r-project.org',force=TRUE,quiet=TRUE)"
      end_time=$(date +%s)
      echo "# Time taken: $(($end_time - $start_time)) seconds." >> $bash_script_output
    fi
    conda_list+=("$line_cleaned:$install_source")
elif [[ $is_bioc_conda == True ]]; then
    echo "=== === >>> INSTALLING: $conda_exe install -y -q bioconda::bioconductor-$line_cleaned --freeze-installed"
    echo "$conda_exe install -y -q bioconda::bioconductor-$line_cleaned --freeze-installed" >> $bash_script_output
    if [[ $dry_run == "run" ]]; then
      start_time=$(date +%s)
      $conda_exe install -y -q bioconda::bioconductor-$line_cleaned --freeze-installed
      end_time=$(date +%s)
      echo "# Time taken: $(($end_time - $start_time)) seconds." >> $bash_script_output
    fi
    conda_list+=("$line_cleaned:$install_source")
elif [[ $is_biocmanager == True ]]; then      
    echo "=== === >>> INSTALLING: Rscript -e \"BiocManager::install('$line_cleaned',force=TRUE,quiet=TRUE)\""
    echo "Rscript -e \"BiocManager::install('$line_cleaned',force=TRUE,quiet=TRUE)\"" >> $bash_script_output
    if [[ $dry_run == "run" ]]; then
      start_time=$(date +%s)
      Rscript -e "BiocManager::install('$line_cleaned',force=TRUE,quiet=TRUE)"
      end_time=$(date +%s)
      echo "# Time taken: $(($end_time - $start_time)) seconds." >> $bash_script_output
    fi
    conda_list+=("$line_cleaned:$install_source")
elif [[ $is_github == True ]]; then
    echo "=== === >>> INSTALLING: Rscript -e \"devtools::install_github('$line_cleaned',quiet=TRUE)\""
    echo "Rscript -e \"devtools::install_github('$line_cleaned',quiet=TRUE)\"" >> $bash_script_output
    if [[ $dry_run == "run" ]]; then
      start_time=$(date +%s)
      Rscript -e "devtools::install_github('$line_cleaned',quiet=TRUE)"
      end_time=$(date +%s)
      echo "# Time taken: $(($end_time - $start_time)) seconds." >> $bash_script_output
    fi
    conda_list+=("$line_cleaned:$install_source")   
elif [[ $is_wget == True ]]; then    
    wget_url="$line_cleaned"    
    #file_name=$(basename "$wget_url")
    #echo "=== === >>> INSTALLING: wget $wget_url -O $file_name"
    #echo "wget $wget_url -O $file_name" >> $bash_script_output
    #echo "R CMD INSTALL $file_name" >> $bash_script_output
    #echo "rm -rf $file_name" >> $bash_script_output
    echo "=== === >>> INSTALLING: R -e \"devtools::install_url('$wget_url')\""
    echo "Rscript -e \"devtools::install_url('$wget_url')\"" >> $bash_script_output
    if [[ $dry_run == "run" ]]; then
      #wget $wget_url -O $file_name
      #R CMD INSTALL $file_name
      #rm -rf $file_name
      start_time=$(date +%s)
      Rscript -e "devtools::install_url('$wget_url')"
      end_time=$(date +%s)
      echo "# Time taken: $(($end_time - $start_time)) seconds." >> $bash_script_output
    fi        
    conda_list+=("$line_cleaned:$install_source")   
elif [[ $is_bash == True ]]; then    
    bash_cmd="$line_cleaned"        
    echo "=== === >>> Line of bash to execute: $bash_cmd"
    if [[ $dry_run == "run" ]]; then
      start_time=$(date +%s)
      eval $bash_cmd
      #bash -c "$bash_cmd"
      echo "$bash_cmd" >> $bash_script_output
      end_time=$(date +%s)
      echo "# Time taken: $(($end_time - $start_time)) seconds." >> $bash_script_output
    fi        
    conda_list+=("$line_cleaned:$install_source")
fi
done < $mamba_yaml_input
echo "=== >>> Finished processing conda environment file at $(date)."
echo "# === >>> Finished processing conda environment file at $(date)." >> $bash_script_output
