#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-03-01
# Capture time: 10:12:44 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi
# Using conda executable conda: /home/ralcraft/miniforge3/condabin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/condabin/conda
#####################################################

conda env remove --name basometro -y 2>/dev/null || true
conda create --no-default-packages --name basometro -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate basometro

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
# ProvGigaPath
#######################################

# languages:
conda install -y --solver=libmamba --no-update-deps 'python=3.10'
python -m site
conda env config vars set PYTHONNOUSERSITE=1
export PYTHONNOUSERSITE=1
# pip:
python -m pip install 'pydata-google-auth==1.9.0' 
python -m pip install 'pydot==3.0.3' 
python -m pip install 'pydotplus==2.0.2' 
#- PyDrive==1.3.1
python -m pip install 'PyDrive2==1.21.3' 
python -m pip install 'pyerfa==2.0.1.5' 
python -m pip install 'pygit2==1.16.0' 
python -m pip install 'Pygments==2.18.0' 
#- PyGObject==3.42.1
python -m pip install 'PyJWT==2.10.1' 
#- pylibcudf-cu12 @ https://pypi.nvidia.com/pylibcudf-cu12/pylibcudf_cu12-24.10.1-cp310-cp310-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl
#- pylibcugraph-cu12==24.10.0
#- pylibraft-cu12==24.10.0
python -m pip install 'pymc==5.19.1' 
python -m pip install 'pymystem3==0.2.0' 
#- pynvjitlink-cu12==0.4.0
python -m pip install 'pyogrio==0.10.0' 
python -m pip install 'PyOpenGL==3.1.7' 
python -m pip install 'pyOpenSSL==24.2.1' 
python -m pip install 'pyparsing==3.2.0' 
python -m pip install 'pyperclip==1.9.0' 
python -m pip install 'pyproj==3.7.0' 
python -m pip install 'pyshp==2.3.1' 
python -m pip install 'python-dateutil==2.8.2' 
python -m pip install 'python-louvain==0.16' 
python -m pip install 'python-slugify==8.0.4' 
python -m pip install 'python-utils==3.9.1' 
python -m pip install 'pytz==2024.2' 
python -m pip install 'pyviz_comms==3.0.3' 
python -m pip install 'PyYAML==6.0.2' 
python -m pip install 'pyzmq==24.0.1' 
python -m pip install 'qdldl==0.1.7.post4' 
python -m pip install 'ratelim==0.1.6' 
python -m pip install 'referencing==0.35.1' 
python -m pip install 'regex==2024.11.6' 
python -m pip install 'requests==2.32.3' 
python -m pip install 'requests-oauthlib==1.3.1' 
python -m pip install 'requests-toolbelt==1.0.0' 
python -m pip install 'requirements-parser==0.9.0' 
python -m pip install 'rich==13.9.4' 
#- rmm-cu12==24.10.0
python -m pip install 'rpds-py==0.22.3' 
python -m pip install 'seaborn==0.13.2' 
python -m pip install 'sklearn-pandas==2.2.0' 
python -m pip install 'slicer==0.0.8' 
python -m pip install 'smart-open==7.0.5' 
python -m pip install 'smmap==5.0.1' 
python -m pip install 'sniffio==1.3.1' 
python -m pip install 'snowballstemmer==2.2.0' 
python -m pip install 'soundfile==0.12.1' 
python -m pip install 'soupsieve==2.6' 
python -m pip install 'soxr==0.5.0.post1' 
python -m pip install 'spacy==3.7.5' 
python -m pip install 'spacy-legacy==3.0.12' 
python -m pip install 'spacy-loggers==1.0.5' 
python -m pip install 'SQLAlchemy==2.0.36' 
python -m pip install 'sqlglot==25.1.0' 
python -m pip install 'sqlparse==0.5.3' 
python -m pip install 'srsly==2.5.0' 
python -m pip install 'stanio==0.5.1' 
python -m pip install 'statsmodels==0.14.4' 
python -m pip install 'StrEnum==0.4.15' 
python -m pip install 'stringzilla==3.11.1' 
python -m pip install 'sympy==1.13.1' 
python -m pip install 'tables==3.10.1' 
python -m pip install 'tabulate==0.9.0' 
python -m pip install 'tbb==2022.0.0' 
python -m pip install 'tcmlib==1.2.0' 
python -m pip install 'tifffile==2024.12.12' 
python -m pip install 'timm==1.0.12' 
python -m pip install 'tinycss2==1.4.0' 
python -m pip install 'tokenizers==0.21.0' 
python -m pip install 'toml==0.10.2' 
python -m pip install 'tomli==2.2.1' 
python -m pip install 'toolz==0.12.1' 
python -m pip install 'tqdm==4.67.1' 
python -m pip install 'traitlets==5.7.1' 
python -m pip install 'traittypes==0.2.1' 
python -m pip install 'transformers==4.47.0' 
python -m pip install 'tweepy==4.14.0' 
python -m pip install 'typeguard==4.4.1' 
python -m pip install 'typer' 
python -m pip install 'types-pytz==2024.2.0.20241003' 
python -m pip install 'types-setuptools==75.6.0.20241126' 
python -m pip install 'typing_extensions' 
python -m pip install 'tzdata==2024.2' 
python -m pip install 'tzlocal==5.2' 
python -m pip install 'uc-micro-py==1.0.3' 
python -m pip install 'umf==0.9.1' 
python -m pip install 'uritemplate==4.1.1' 
python -m pip install 'urllib3==2.2.3' 
python -m pip install 'zipp==3.21.0' 
python -m pip install 'ipykernel' 
python -m pip install 'jupyterlab' 
# bash:
python -m ipykernel install --user --name=mat-basometro --display-name='Python (mat-basometro)'
mkdir -p $CONDA_PREFIX/GitHub/mat-basometro
git clone https://github.com/Yuri-Nassar/mat-basometro.git $CONDA_PREFIX/GitHub/mat-basometro
echo "#!/usr/bin/env bash" > ${CONDA_PREFIX}/bin/validate.sh
echo 'echo "COBLE validation: No script has been specified for basometro environment."' >> ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh

