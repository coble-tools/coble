#!/usr/bin/env bash
source ~/.bashrc
# Go through the logs line by line to capture errors
# Output messages to the error report file
error_report=$1
done_report=$2
OUTPUT_FILE=$3
ERROR_FILE=$4
echo "Starting in conda-step-errors.sh at $(date)"
echo "Creating Error Log Report at $(date)" > $error_report
echo "Input output file="$OUTPUT_FILE >> $error_report
echo "Input error file="$ERROR_FILE >> $error_report
echo ">>> Producing error report from $ERROR_FILE..."
echo "# >>> Producing error report from $ERROR_FILE..." >> $error_report

echo "Creating DONE Log Report at $(date)" > $done_report
echo "Input error file="$ERROR_FILE >> $done_report
echo ">>> Producing done report from $ERROR_FILE..."
echo "# >>> Producing done report from $ERROR_FILE..." >> $done_report

total_lines=$(wc -l < "$ERROR_FILE")
current_line=0
start_time=$(date +%s)
############ ERROR FILE ############
while IFS= read -r line || [ -n "$line" ]; do
    current_line=$((current_line+1))
    now_time=$(date +%s)
    elapsed=$((now_time - start_time))
    now_str=$(date '+%Y-%m-%d %H:%M:%S')
    if (( current_line % 100 == 0 )); then
        echo "$current_line/$total_lines"
    fi
    # done report
    if [[ $line == *"DONE ("* ]]; then          
        echo "$line"
        echo "$line" >> $done_report
    fi
    # error report
    if [[ $line == *"=== >>> Processing:"* ]]; then          
        echo "$line"
        echo "$line" >> $error_report
    elif [[ $line == *"had non-zero exit status"* ]]; then
        echo "$line"
        echo "  ERROR:$line" >> $error_report
    elif [[ $line == *"had non-zero exit status"* ]]; then
        echo "$line"
        echo "  ERROR REPORT:$line" >> $error_report
    elif [[ $line == *"\`$ "* ]]; then
        echo "$line"
        echo "  WARNING:$line" >> $error_report    
    elif [[ $line == *"is not available for"* ]]; then
        echo "$line"
        echo "  WARNING:$line" >> $error_report    
    elif [[ $line == *"Perhaps you meant"* ]]; then
        echo "$line"
        echo "  WARNING:$line" >> $error_report    
    elif [[ $line == *"error:"* ]]; then
        echo "$line"
        echo "  MSG:$line" >> $error_report
    fi
    
done < $ERROR_FILE

echo ">>> Now producing error report from $OUTPUT_FILE..."
echo "# >>> Producing error report from $OUTPUT_FILE..." >> $error_report

############ OUTPUT FILE ############
last_look_for=""
mapfile -t lines < "$OUTPUT_FILE"
for i in "${!lines[@]}"; do
    if (( i % 100 == 0 )); then
        echo "$i/${#lines[@]}"
    fi
    line="${lines[$i]}"
    if [[ $line == *"=== >>> Processing:"* ]]; then          
        echo "$line"
        #echo "$line" >> $error_report
    elif [[ $line == *"is uninstallable because there are no viable options"* ]]; then
        echo "$line"
        echo "  ERROR:$line" >> $error_report
    elif [[ $line == *"does not exist"* ]]; then
        echo "$line"
        echo "  ERROR:$line" >> $error_report
    elif [[ $line == *"Encountered problems while solving"* ]]; then
        echo "$line"
        echo "  ERROR:$line" >> $error_report
    elif [[ $line == *"nothing provides"* ]]; then
        echo "$line"
        echo "  ERROR:$line" >> $error_report
    elif [[ $line == *"please re-install it"* ]]; then
        echo "$line"
        echo "  WARNING:$line" >> $error_report
    elif [[ $line == *"Looking for:"* ]]; then
        echo "$line"
        last_look_for="$line"    
    elif [[ $line == *"Old packages:"* ]]; then
        echo "$line"
        last_look_for="$line"
    elif [[ $line == *"Could not solve for environment specs"* ]]; then
        echo "$line"
        echo "  ERROR:$line - $last_look_for" >> $error_report
    fi
done
echo "Error report completed at $(date)" >> $error_report
echo "Done report completed at $(date)" >> $done_report
