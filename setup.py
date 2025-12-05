#!/usr/bin/env python3
"""
COBLE - COnda BuiLdEr
Setup configuration for installing coble as a Python package
"""

from setuptools import setup, find_packages
import os

# Read the README for long description
def read_readme():
    readme_path = os.path.join(os.path.dirname(__file__), 'README.md')
    if os.path.exists(readme_path):
        with open(readme_path, 'r', encoding='utf-8') as f:
            return f.read()
    return "COBLE - COnda BuiLdEr for reproducible bioinformatics environments"

setup(
    name="coble",
    version="0.1.0",
    description="COnda BuiLdEr for reproducible bioinformatics environments",
    long_description=read_readme(),
    long_description_content_type="text/markdown",
    author="Rachel Alcraft",
    author_email="rachel.alcraft@icr.ac.uk",
    url="https://github.com/ICR-RSE-Group/coble",
    license="MIT",
    packages=find_packages(),
    package_data={
        'coble': [
            'code/*.sh',
            'config/*.sh',
            'config/*.yml',
        ],
    },
    include_package_data=True,
    entry_points={
        'console_scripts': [
            'coble=coble.cli:main',
            'coble-build=coble.cli:build',
        ],
    },
    python_requires='>=3.7',
    install_requires=[
        # No Python dependencies needed for bash scripts
    ],
    classifiers=[
        'Development Status :: 4 - Beta',
        'Intended Audience :: Science/Research',
        'Topic :: Scientific/Engineering :: Bio-Informatics',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
        'Programming Language :: Python :: 3.11',
    ],
    keywords='conda bioinformatics reproducibility docker singularity',
)
