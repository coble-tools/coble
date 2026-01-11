# COBLE Installation

Installation can be done through conda or github.

## Conda Installation
```bash
# In your chosen conda environment, or in base:
conda install rachelsa::coble
# Test it
coble -h
```
When installed through conda, the utility and all the scripts are in the path so you can refer to it as `coble` wherever you are.

## Requirements
COBLE is a high-level bash utility that uses other package managers to build environments. It requires *bash*, *conda*, *R* and *python* to be installed and accessible from the command line as needed. It also has the option to use *docker*, and *singularity*/*apptainer*. These are all referred to by triggering the relevant package manager commands from bash and if you have alternative installations you canalisa the executables.

## Github installation
```bash
git clone git@github.com:ICR-RSE-Group/coble.git
# Test it, and you can also test/(find the help for) each of the child commands:
coble/code/coble -h 
coble/code/coble recipe -h 
coble/code/coble build -h 
```
You need to add the folder coble/code to the path or refer to the coble utility script by full or relative path.




