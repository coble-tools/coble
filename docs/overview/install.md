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
COBLE is a high-level bash utility that uses other package managers to build environments. It requires *bash*, *conda*, *R* and *python* to be installed and accessible from the command line as needed. It also has the option to use *docker*, and *singularity*/*apptainer*. These are all referred to by triggering the relevant package manager commands from bash and if you have alternative installations you can alias the executables.

## To install conda
We recommend the miniforge version in conda-forge which defaults to the conda-forge channel: 
[install miniforge](https://github.com/conda-forge/miniforge)  

## The **.bashrc**
The utility is not tied to **conda**, you can use any executable you like by passing the --alias setting. This means that rather than handle all the possible inits for hooks for the different package managers, COBLE sources the ~./bashrc, so it is there that you need to ensure that your package manager has the necessary hooks.

Generally this accomplished by following the install instructions which will end up with somethin glike `conda init` and the instruction to resstart your shell.  
```bash
# In your ~/.bashrc
# For conda and mamba installed through conda
source "$(conda info --base)/etc/profile.d/conda.sh"
# For mamba (standalone):
eval "$(mamba shell hook --shell=bash)"
# For micromamba (standalone):
eval "$(micromamba shell hook --shell=bash)"
```
Thake care that your mamba and conda init are not interactive only. This would be signalled by a block like this:
```text
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac
```
which can be commented out.

## Github installation
```bash
git clone git@github.com:ICR-RSE-Group/coble.git
# Test it, and you can also test/(find the help for) each of the child commands:
coble/code/coble -h 
coble/code/coble recipe -h 
coble/code/coble build -h 
```
You need to add the folder coble/code to the path or refer to the coble utility script by full or relative path.




