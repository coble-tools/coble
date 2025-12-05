"""
COBLE - COnda BuiLdEr
Build and manage conda environments with support for conda, R, and pip packages
"""

__version__ = "0.1.0"
__author__ = "Rachel Alcraft"
__license__ = "MIT"

import os
import sys

# Get the package directory
PACKAGE_DIR = os.path.dirname(os.path.abspath(__file__))
# Get the scripts directory
SCRIPTS_DIR = os.path.join(os.path.dirname(PACKAGE_DIR), 'code')

def get_script_path(script_name):
    """Get the full path to a coble script"""
    return os.path.join(SCRIPTS_DIR, script_name)

# Export commonly used paths
COBLE_RECIPE_BASH = get_script_path('coble-recipe-bash.sh')
COBLE_RECIPE_SLURM = get_script_path('coble-recipe-slurm.sh')
