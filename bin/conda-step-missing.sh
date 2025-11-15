#!/usr/bin/env bash
source ~/.bashrc

# Go through the exported envs and check for missing packages
# Output messages to the installed report file

installed_report=$1
mamba_yaml_input=$2
mamba_yaml_output=$3
r_packages_output=$4
pip_packages_output=$5

echo "Starting in conda-step-missing.sh at $(date)"

echo ">>> Running MISSING, producing install report in $installed_report"
echo "Exported conda file="$mamba_yaml_output >> $installed_report
echo "Exported R file="$r_packages_output >> $installed_report
echo "Exported pip file="$pip_packages_output >> $installed_report

# First build a list of all the libs that were requested to be installed
conda_list=()
total_lines=$(wc -l < "$mamba_yaml_input")
current_line=0
start_time=$(date +%s)
while IFS= read -r line || [ -n "$line" ]; do
    current_line=$((current_line+1))
    now_time=$(date +%s)
    elapsed=$((now_time - start_time))
    now_str=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$current_line/$total_lines - [$now_str | +${elapsed}s] === >>> Processing: $line"
    line_cleaned=${line#*- }
    if [[ $line == \#* || -z $line ]]; then    
        continue
    fi
    if [[ $line == *"channel:"* ]]; then
        is_channel=False; is_package=False; is_pip=False; \
        is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
        is_r_conda=False; is_github=False; is_wget=False; is_bash=False
        is_channel=True            
    elif [[ $line == *"dependencies:"* ]]; then
        is_channel=False; is_package=False; is_pip=False; \
        is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
        is_r_conda=False; is_github=False; is_wget=False; is_bash=False
        is_package=True
        install_source="conda"        
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
    elif [[ $line == *"  - r_conda:"* ]]; then
        is_channel=False; is_package=False; is_pip=False; \
        is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
        is_r_conda=False; is_github=False; is_wget=False; is_bash=False
        is_r_conda=True
        install_source="r-conda"        
    elif [[ $line == *"  - r_package:"* ]]; then
        is_channel=False; is_package=False; is_pip=False; \
        is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
        is_r_conda=False; is_github=False; is_wget=False; is_bash=False
        is_r_package=True
        install_source="r-package"        
    elif [[ $line == *"  - bio_conda:"* ]]; then
        is_channel=False; is_package=False; is_pip=False; \
        is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
        is_r_conda=False; is_github=False; is_wget=False; is_bash=False
        is_bioc_conda=True
        install_source="bio-conda"        
    elif [[ $line == *"  - bio_package:"* ]]; then
        is_channel=False; is_package=False; is_pip=False; \
        is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
        is_r_conda=False; is_github=False; is_wget=False; is_bash=False
        is_biocmanager=True      
        install_source="bio-package"
    elif [[ $line == *"  - github:"* ]]; then
        is_channel=False; is_package=False; is_pip=False; \
        is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
        is_r_conda=False; is_github=False; is_wget=False; is_bash=False
        is_github=True      
        install_source="github"
    elif [[ $line == *"  - wget:"* ]]; then
        is_channel=False; is_package=False; is_pip=False; \
        is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
        is_r_conda=False; is_github=False; is_wget=False; is_bash=False
        is_wget=True      
        install_source="wget"
    elif [[ $line == *"  - wget:"* ]]; then
        is_channel=False; is_package=False; is_pip=False; \
        is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
        is_r_conda=False; is_github=False; is_wget=False; is_bash=False
        is_bash=True
        install_source="bash"
    elif [[ $line == *"  - conda:"* ]]; then
        is_channel=False; is_package=False; is_pip=False; \
        is_r_package=False; is_biocmanager=False; is_bioc_conda=False; \
        is_r_conda=False; is_github=False; is_wget=False; is_bash=False
        is_package=True
        install_source="conda"
    elif [[ $is_package == True ]]; then                                
        conda_list+=("$line_cleaned|$install_source")
    elif [[ $is_pip == True ]]; then        
        conda_list+=("$line_cleaned|$install_source")
    elif [[ $is_r_conda == True ]]; then                                
        conda_list+=("$line_cleaned|$install_source")
    elif [[ $is_r_package == True ]]; then        
        conda_list+=("$line_cleaned|$install_source")
    elif [[ $is_bioc_conda == True ]]; then        
        conda_list+=("$line_cleaned|$install_source")
    elif [[ $is_biocmanager == True ]]; then              
        conda_list+=("$line_cleaned|$install_source")   
    elif [[ $is_github == True ]]; then              
        conda_list+=("$line_cleaned|$install_source")   
    elif [[ $is_wget == True ]]; then
        conda_list+=("$line_cleaned|$install_source")
    fi
done < $mamba_yaml_input

# Now loop through this to find the missing libs
echo ">>> Producing install report in $installed_report"

echo "Creating Install Log Report at $(date)" > $installed_report
echo "Input yaml file="$mamba_yaml_input >> $installed_report
echo "Exported conda file="$mamba_yaml_output >> $installed_report
echo "Exported R file="$r_packages_output >> $installed_report
echo "Exported pip file="$pip_packages_output >> $installed_report

for item in "${conda_list[@]}"; do
# Trim whitespace from item
item=$(echo "$item" | xargs)
# item consists of package:source so split to get both
item_lc=$(printf '%s' "$item" | tr '[:upper:]' '[:lower:]')
item_lc=$(echo "$item_lc" | xargs)
item_pkg=${item_lc%%|*}
item_pkg=$(echo "$item_pkg" | xargs)
item_src=${item_lc##*|}
# skip if item_pkg is empty
if [[ -z $item_pkg ]]; then
    continue
fi
found=False
if [[ $item_src == *"conda"* ]]; then    
    while IFS= read -r line || [ -n "$line" ]; do
    if [[ $line == *"$item_pkg="* ]]; then        
        found=True
    fi
    done < "$mamba_yaml_output"
elif [[ $item_src == *"package"* ]]; then    
    while IFS= read -r line || [ -n "$line" ]; do
    line_lc=$(printf '%s' "$line" | tr '[:upper:]' '[:lower:]')
    if [[ $line_lc == *"$item_pkg="* ]]; then        
        found=True
    fi
    done < "$r_packages_output"
elif [[ $item_src == *"github"* ]]; then    
    while IFS= read -r line || [ -n "$line" ]; do
    line_lc=$(printf '%s' "$line" | tr '[:upper:]' '[:lower:]')    
    repo_name=${line##*/}
    if [[ $line_lc == *"$repo_name="* ]]; then        
        found=True
    fi
    done < "$r_packages_output"
elif [[ $item_src == *"wget"* ]]; then    
    while IFS= read -r line || [ -n "$line" ]; do
    line_lc=$(printf '%s' "$line" | tr '[:upper:]' '[:lower:]')
    file_name=$(basename "$line_lc")
    stem="$(echo "$file_name" | sed -E 's/\.(tar\.(gz|bz2|xz)|t?gz|zip)$//')"
    lib="$(echo "$stem" | sed -E 's/([_-])[0-9].*$//')"
    if [[ $line_lc == *"$lib="* ]]; then    
        found=True
    fi
    done < "$r_packages_output"
elif [[ $item_src == *"pip"* ]]; then    
    while IFS= read -r line || [ -n "$line" ]; do
    line_lc=$(printf '%s' "$line" | tr '[:upper:]' '[:lower:]')
    if [[ $line_lc == *"$item_pkg="* ]]; then        
        found=True
    fi
    done < "$pip_packages_output"
else
    echo "SKIPPING non-recognised check for: $item"
fi

if [[ $found == False ]]; then
    echo "MISSING lib: $item_pkg, source: $item_src"
    echo "MISSING lib: $item_pkg, source: $item_src" >> $installed_report
fi
done
echo ">>> Finished producing install report at $(date)." >> $installed_report



