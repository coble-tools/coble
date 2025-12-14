#!/bin/bash

# Detect install context (bin vs code dir)
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
script_base="$(basename "$script_dir")"
if [[ "$script_base" == "bin" ]]; then
	install_context="conda"
else
	install_context="github"
fi
# Optionally, you can use $install_context in help or logic

show_help() {
	echo "Usage: $0 <command> [options]"
	echo "  capture   Capture the current environment (calls coble-capture.sh)"
	echo "  recreate  Recreate an environment from a capture (calls coble-recreate.sh)"
	echo "Example:"
	echo "  $0 capture [options]"
	echo "  $0 recreate [options]"
}

# Global help option
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
	show_help
	exit 0
fi

# If the first argument is 'capture', call coble-capture.sh and exit
if [[ "$1" == "capture" ]]; then
	script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	"$script_dir/coble-capture.sh" "${@:2}"
	exit $?
fi

# If the first argument is 'recreate', call coble-recreate.sh and exit
if [[ "$1" == "recreate" ]]; then
	script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	"$script_dir/coble-recreate.sh" "${@:2}"
	exit $?
fi

# output a requirements.txt file
echo "Not a valid command provided: $1."
show_help