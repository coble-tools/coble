# COBLE: COnda BuiLdEr
`COBLE - COnda BuiLdEr: Build and manage conda environments`  
Created by the RSE team at the ICR for and with the Breast Cancer Research Data Science Group.  
*Contacts: Rachel Alcraft, Syed Haider*  

---  

Documentation:
- GitHub Docs Site: [icr-rse-group.github.io/coble/](https://icr-rse-group.github.io/coble/)  
- GitHub repo: [github.com/ICR-RSE-Group/coble](https://github.com/ICR-RSE-Group/coble)  
- GitHub Issues: [github.com/ICR-RSE-Group/coble/issues](https://github.com/ICR-RSE-Group/coble/issues)  

---  

## Installation

Installation can be done through conda or github.

### Conda Installation
```bash
# In your chosen conda environment, or in base:
conda install rachelsa::coble
# Test it
coble -h
```
When installed through conda the utility and all the scripts are in the path so you can refer to it as `coble` wherever you are.


### Github installation
```bash
git clone git@github.com:ICR-RSE-Group/coble.git
coble/code/coble -h 
```
You need to add the folder `coble/code` to the path or refer to the coble utility script by full or relative path.
