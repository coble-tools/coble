#!/usr/bin/env python3
"""
COBLE CLI - Command-line interface for COBLE
"""

import sys
import os
import subprocess
import argparse
from pathlib import Path

# Import coble module
try:
    import coble
except ImportError:
    # If not installed, try to import from parent directory
    sys.path.insert(0, str(Path(__file__).parent.parent))
    import coble


def main():
    """Main CLI entry point"""
    parser = argparse.ArgumentParser(
        description='COBLE - COnda BuiLdEr for reproducible bioinformatics environments',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  coble --version
  coble build --input my-recipe.sh --env ./myenv --r-version 4.5.2
  coble --help

For more information, visit: https://github.com/ICR-RSE-Group/coble
        """
    )
    
    parser.add_argument('--version', action='version', version=f'COBLE {coble.__version__}')
    
    subparsers = parser.add_subparsers(dest='command', help='Available commands')
    
    # Build command
    build_parser = subparsers.add_parser('build', help='Build a conda environment from a recipe')
    build_parser.add_argument('--input', required=True, help='Input recipe file')
    build_parser.add_argument('--results', default='./results', help='Results directory')
    build_parser.add_argument('--env', required=True, help='Environment path/name')
    build_parser.add_argument('--r-version', default='4.5.2', help='R version')
    build_parser.add_argument('--python-version', default='3.14.0', help='Python version')
    build_parser.add_argument('--skip-errors', action='store_true', help='Continue on errors')
    build_parser.add_argument('--override-r', action='store_true', help='Override R_LIBS_USER')
    build_parser.add_argument('--override-pkgs', action='store_true', help='Override CONDA_PKGS_DIRS')
    
    args = parser.parse_args()
    
    if args.command == 'build':
        build(args)
    else:
        parser.print_help()


def build(args):
    """Build a conda environment"""
    script_path = coble.COBLE_RECIPE_BASH
    
    if not os.path.exists(script_path):
        print(f"Error: coble-recipe-bash.sh not found at {script_path}", file=sys.stderr)
        sys.exit(1)
    
    if not os.path.exists(args.input):
        print(f"Error: Recipe file not found: {args.input}", file=sys.stderr)
        sys.exit(1)
    
    # Build the command
    cmd = [
        'bash',
        script_path,
        '--input', args.input,
        '--results', args.results,
        '--env', args.env,
        '--r-version', args.r_version,
        '--python-version', args.python_version,
    ]
    
    if args.skip_errors:
        cmd.append('--skip-errors')
    if args.override_r:
        cmd.append('--override-r')
    if args.override_pkgs:
        cmd.append('--override-pkgs')
    
    print(f"Running: {' '.join(cmd)}")
    
    # Execute the script
    result = subprocess.run(cmd)
    sys.exit(result.returncode)


if __name__ == '__main__':
    main()
