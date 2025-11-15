#!/usr/bin/env bash
mamba_recipe=$1
bash_script_output=$2
dry_run=$3

echo "Starting in conda-step-recipe.sh at $(date)"
echo "Processing recipe file: $mamba_recipe"
echo "Output script: $bash_script_output"
echo "Mode: $dry_run"

source ~/.bashrc

total_lines=$(wc -l < "$mamba_recipe")
current_line=0
start_time=$(date +%s)
while IFS= read -r line || [ -n "$line" ]; do    
    current_line=$((current_line+1))    
    now_time=$(date +%s)
    elapsed=$((now_time - start_time))
    now_str=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$current_line/$total_lines - [$now_str | +${elapsed}s] === >>> Processing: $line"        
    line_cleaned="${line#"${line%%[![:space:]]*}"}"  # remove leading whitespace
    line_cleaned="${line_cleaned%"${line_cleaned##*[![:space:]]}"}"  # remove trailing whitespace

    if [[ -z $line_cleaned ]]; then        
        continue
    fi
    
    if [[ $dry_run == "run" ]]; then
        if [[ $line_cleaned == \#* ]]; then
            # Comment line - just write to script, don't execute or time
            echo "$line_cleaned" >> $bash_script_output
        else
            # Executable line - write, run, and time
            echo "...Bashing: $line_cleaned"        
            echo "$line_cleaned" >> $bash_script_output
            cmd_start=$(date +%s)
            #bash -c "$line_cleaned"
            eval "$line_cleaned"
            cmd_end=$(date +%s)
            echo "# Time taken: $(($cmd_end - $cmd_start)) seconds."
            echo "# Time taken: $(($cmd_end - $cmd_start)) seconds." >> $bash_script_output
        fi
    fi
done < $mamba_recipe
echo "=== >>> Finished processing conda environment file at $(date)."
echo "# === >>> Finished processing conda environment file at $(date)." >> $bash_script_output
