#!/usr/bin/env bash
set -euo pipefail

# module-error-check.sh (utility for other scripts)
# Parameters (positional):
#   error_log=$1   -> path to the file to scan
#   start_line=$2  -> (optional) start scanning from this line number (default: 1)
# Behavior:
#   - Scans lines starting at start_line for fixed strings "12345" or "ABCDE".
#   - Outputs a tuple on the first line: "True,<first_match_line>" or "False,0".
#   - When True, subsequently prints all offending lines as "<line>:<content>".

error_log="${1-}"
start_line="${2-1}"

if [[ -z "${error_log}" ]]; then
	echo "False,0"
	exit 0
fi

if [[ ! -e "${error_log}" || ! -r "${error_log}" ]]; then
	echo "False,0"
	exit 0
fi

# Validate start_line is a positive integer
if ! [[ "${start_line}" =~ ^[0-9]+$ ]] || [[ "${start_line}" -lt 1 ]]; then
	start_line=1
fi

# Patterns (fixed strings)
PATTERN_ONE='12345'
PATTERN_TWO='ABCDE'

# Filter from start_line, preserve original line numbers, then match patterns
mapfile -t MATCHES < <(
	awk -v start="${start_line}" 'NR>=start {print NR ":" $0}' "${error_log}" \
	| grep -F -e "${PATTERN_ONE}" -e "${PATTERN_TWO}" \
	|| true
)

if (( ${#MATCHES[@]} > 0 )); then
	first_line_number=$(printf '%s\n' "${MATCHES[0]}" | cut -d: -f1)
	echo "True,${first_line_number}"
	printf '%s\n' "${MATCHES[@]}"
else
	echo "False,0"
fi

