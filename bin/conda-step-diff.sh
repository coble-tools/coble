#!/usr/bin/env bash
source ~/.bashrc

# Go through the exported envs and check for libs against input
# Output messages to the installed report file


installed_report_orig=$1
mamba_yaml_output=$2
diff_file=$3
installed_report="${installed_report_orig}.different_report.txt"

echo "Starting in conda-step-diff.sh at $(date)"

echo ">>> Running DIFF report to $installed_report"
echo "Producing lib mismatch report to $installed_report"
echo "----------------------------" >> $installed_report
echo "Exported compare file="$mamba_yaml_output >> $installed_report
echo "Input diff file="$diff_file >> $installed_report
echo "Reporting on each lib in diff file and whether it is in current export" >> $installed_report
echo "----------------------------" >> $installed_report

missings=()
mismatches=()
unchecked=()

while IFS= read -r line_exp; do
  [[ $line_exp == *"="* ]] || continue
  lib_exp=${line_exp%%=*}
  version_exp=${line_exp#*=}
  lib_exp=$(echo "$lib_exp" | xargs)
  version_exp=$(echo "$version_exp" | xargs)
  printf "%s %s\n" "$lib_exp" "$version_exp"
  found=False
  version_match=True
  unchecked=False
  while IFS= read -r line || [ -n "$line" ]; do
    if [[ $line == *"$lib_exp="* ]]; then
      found=True      
      # Extract the version from the line
      version_comp=${line#*=}
      version_comp=$(echo "$version_comp" | xargs)
      # Compare with expected version (assuming you have $expected_version)
      if [[ "$version_comp" != "$version_exp" ]]; then
        version_match=False
      fi
      break
    fi
    #if http is in the string then we haven't checked ot
    if [[ $line == *"http"* ]]; then
      unchecked=True
    fi

  done < "$mamba_yaml_output"
  if [[ $unchecked == True ]]; then
    echo "UNCHECKED lib: $lib_exp"
    unchecked+=("UNCHECKED lib: $lib_exp")    
  elif [[ $found == False ]]; then
    echo "MISSING lib: $lib_exp"
    missings+=("MISSING lib: $lib_exp")    
  elif [[ $version_match == False ]]; then
    echo "VERSION MISMATCH: $lib_exp Expected: $version_exp, Found: $version_comp"
    mismatches+=("VERSION MISMATCH: $lib_exp Expected: $version_exp, Found: $version_comp")    
  else
    echo "OK: $lib_exp"
  fi  
done < "$diff_file"

echo "### MISSING LIBS ###" >> $installed_report  
for item in "${missings[@]}"; do
  echo "$item" >> $installed_report
done
echo "" >> $installed_report
echo "### VERSION MISMATCHES ###" >> $installed_report
for item in "${mismatches[@]}"; do
  echo "$item" >> $installed_report
done
echo "### UNCHECKED LIBS ###" >> $installed_report
for item in "${unchecked[@]}"; do
  echo "$item" >> $installed_report
done
echo ">>> Finished producing diff report at $(date). to $installed_report" >> $installed_report
echo ">>> Finished producing diff report at $(date). to $installed_report"