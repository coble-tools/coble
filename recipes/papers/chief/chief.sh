#!/usr/bin/env bash

#####################################################
# COBLE:recipe, (c) ICR 2026
# Capture date: 2026-02-12
# Capture time: 19:45:42 GMT
# Captured by: ralcraft
#####################################################
# source bashrc for conda
source ~/.bashrc
if [ -f ~/.bashrc ]; then source ~/.bashrc; else if command -v conda &> /dev/null; then eval "$(conda shell.bash hook)"; fi; fi
# Using conda executable conda: /home/ralcraft/miniforge3/envs/pytest/bin/conda
# Using conda alias conda: /home/ralcraft/miniforge3/envs/pytest/bin/conda
#####################################################

conda env remove --name chief -y 2>/dev/null || true
conda create --no-default-packages --name chief -y
export PYTHONNOUSERSITE=1
unset PYTHONPATH
# clean up conda cache first
conda  clean --all -y --force-pkgs-dirs
# deactivate environment
conda deactivate | true
conda deactivate | true
# activate environment
conda activate chief

export PYTHONNOUSERSITE=1
export | grep PYTHONNOUSERSITE
# Channels section
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels defaults
conda config --env --add channels bioconda
conda config --env --add channels conda-forge

# INSTALL SECTION FOR CONDA
# channels: # note the reverse order of priority
# languages:
conda install -y  'python=3.8'
python -m site
conda env config vars set PYTHONNOUSERSITE=1
export PYTHONNOUSERSITE=1
# pip:
python -m pip install 'torch===1.8.1+cu111' 
python -m pip install 'torchvision===0.9.1+cu111' 
# bash:
python -m pip install -U "setuptools>=68" wheel packaging
python -m pip install -f https://download.pytorch.org/whl/torch_stable.html
# pip:
python -m pip install 'h5py===3.6.0' 
python -m pip install 'matplotlib===3.5.2' 
python -m pip install 'numpy===1.22.3' 
python -m pip install 'opencv-python===4.5.5.64' 
python -m pip install 'openslide-python===1.3.0' 
python -m pip install 'pandas===1.4.2' 
python -m pip install 'Pillow===10.0.0' 
python -m pip install 'scikit-image===0.21.0' 
python -m pip install 'scikit-learn===1.2.2' 
python -m pip install 'scikit-survival===0.21.0' 
python -m pip install 'scipy===1.8.0' 
python -m pip install 'tensorboardX===2.6.1' 
python -m pip install 'tensorboard===2.8.0' 
python -m pip install 'timm-0.5.4.tar' 
python -m pip install 'openslide-bin' 
# pip:
python -m pip install 'absl-py===1.0.0' 
python -m pip install 'addict===2.4.0' 
python -m pip install 'anyio===3.5.0' 
python -m pip install 'argon2-cffi===21.3.0' 
python -m pip install 'argon2-cffi-bindings===21.2.0' 
python -m pip install 'astor===0.8.1' 
python -m pip install 'asttokens===2.0.5' 
python -m pip install 'astunparse===1.6.3' 
python -m pip install 'attrs===21.4.0' 
python -m pip install 'autograd===1.6.2' 
python -m pip install 'autograd-gamma===0.5.0' 
python -m pip install 'Babel===2.10.1' 
python -m pip install 'backcall===0.2.0' 
python -m pip install 'beautifulsoup4===4.11.1' 
python -m pip install 'bleach===5.0.0' 
python -m pip install 'blinker===1.4' 
python -m pip install 'cachetools===5.0.0' 
python -m pip install 'certifi===2021.10.8' 
python -m pip install 'cffi===1.15.0' 
python -m pip install 'chardet===3.0.4' 
python -m pip install 'charset-normalizer===2.0.12' 
python -m pip install 'Click===7.0' 
python -m pip install 'colorama===0.4.3' 
python -m pip install 'colorbrewer===0.2.0' 
python -m pip install 'cryptography===2.8' 
python -m pip install 'cycler===0.11.0' 
python -m pip install 'dbus-python===1.2.16' 
python -m pip install 'debugpy===1.6.0' 
python -m pip install 'decorator===5.1.1' 
python -m pip install 'defer===1.0.4' 
python -m pip install 'defusedxml===0.7.1' 
python -m pip install 'distro===1.4.0' 
python -m pip install 'distro-info===1.0' 
python -m pip install 'docopt===0.6.2' 
python -m pip install 'ecos===2.0.12' 
python -m pip install 'einops===0.6.1' 
python -m pip install 'entrypoints===0.4' 
python -m pip install 'et-xmlfile===1.1.0' 
python -m pip install 'exceptiongroup===1.1.3' 
python -m pip install 'executing===0.8.3' 
python -m pip install 'exhaustive-weighted-random-sampler===0.0.2' 
python -m pip install 'fastjsonschema===2.15.3' 
python -m pip install 'filelock===3.12.2' 
python -m pip install 'flatbuffers===2.0' 
python -m pip install 'fonttools===4.33.3' 
python -m pip install 'formulaic===0.6.4' 
python -m pip install 'fsspec===2023.6.0' 
python -m pip install 'future===0.18.3' 
python -m pip install 'gast===0.5.3' 
python -m pip install 'google-auth===2.6.6' 
python -m pip install 'google-auth-oauthlib===0.4.6' 
python -m pip install 'google-pasta===0.2.0' 
python -m pip install 'graphlib-backport===1.0.3' 
python -m pip install 'grpcio===1.45.0' 
python -m pip install 'h11===0.14.0' 
python -m pip install 'h5py===3.6.0' 
python -m pip install 'httplib2===0.14.0' 
python -m pip install 'huggingface-hub===0.16.4' 
python -m pip install 'idna===3.3' 
python -m pip install 'imageio===2.31.1' 
python -m pip install 'importlib-metadata===4.11.3' 
python -m pip install 'importlib-resources===5.7.1' 
python -m pip install 'interface-meta===1.3.0' 
python -m pip install 'ipykernel===6.13.0' 
python -m pip install 'ipython===8.3.0' 
python -m pip install 'ipython-genutils===0.2.0' 
python -m pip install 'iterative-stratification===0.1.7' 
python -m pip install 'jedi===0.18.1' 
python -m pip install 'Jinja2===3.1.2' 
python -m pip install 'joblib===1.3.1' 
python -m pip install 'json5===0.9.6' 
python -m pip install 'jsonschema===4.4.0' 
python -m pip install 'jupyter-client===7.3.0' 
python -m pip install 'jupyter-core===4.10.0' 
python -m pip install 'jupyter-server===1.17.0' 
python -m pip install 'jupyterlab===3.3.4' 
python -m pip install 'jupyterlab-language-pack-zh-CN===3.3.post3' 
python -m pip install 'jupyterlab-pygments===0.2.2' 
python -m pip install 'jupyterlab-server===2.13.0' 
python -m pip install 'keras===2.8.0' 
python -m pip install 'Keras-Preprocessing===1.1.2' 
python -m pip install 'keyring===18.0.1' 
python -m pip install 'kiwisolver===1.4.2' 
python -m pip install 'launchpadlib===1.10.13' 
python -m pip install 'lazr.restfulclient===0.14.2' 
python -m pip install 'lazr.uri===1.0.3' 
python -m pip install 'lazy-loader===0.3' 
python -m pip install 'libclang===14.0.1' 
python -m pip install 'lifelines===0.27.7' 
python -m pip install 'Markdown===3.3.6' 
python -m pip install 'MarkupSafe===2.1.1' 
python -m pip install 'matplotlib===3.5.2' 
python -m pip install 'matplotlib-inline===0.1.3' 
python -m pip install 'mistune===0.8.4' 
python -m pip install 'nbclassic===0.3.7' 
python -m pip install 'nbclient===0.6.0' 
python -m pip install 'nbconvert===6.5.0' 
python -m pip install 'nbformat===5.3.0' 
python -m pip install 'nest-asyncio===1.5.5' 
python -m pip install 'networkx===3.1' 
python -m pip install 'notebook===6.4.11' 
python -m pip install 'notebook-shim===0.1.0' 
python -m pip install 'numexpr===2.8.4' 
python -m pip install 'numpy===1.22.3' 
python -m pip install 'nystrom-attention===0.0.11' 
python -m pip install 'oauthlib===3.2.0' 
python -m pip install 'opencv-python===4.5.5.64' 
python -m pip install 'openpyxl===3.1.2' 
python -m pip install 'openslide-python===1.3.0' 
python -m pip install 'opt-einsum===3.3.0' 
python -m pip install 'osqp===0.6.3' 
python -m pip install 'outcome===1.3.0' 
python -m pip install 'packaging===21.3' 
python -m pip install 'pandas===1.4.2' 
python -m pip install 'pandocfilters===1.5.0' 
python -m pip install 'parso===0.8.3' 
python -m pip install 'pexpect===4.8.0' 
python -m pip install 'pickleshare===0.7.5' 
python -m pip install 'Pillow===10.0.0' 
python -m pip install 'pipreqs===0.4.13' 
python -m pip install 'prettytable===3.9.0' 
python -m pip install 'prometheus-client===0.14.1' 
python -m pip install 'prompt-toolkit===3.0.29' 
python -m pip install 'protobuf===4.23.4' 
python -m pip install 'psutil===5.9.0' 
python -m pip install 'ptyprocess===0.7.0' 
python -m pip install 'pure-eval===0.2.2' 
python -m pip install 'pyasn1===0.4.8' 
python -m pip install 'pyasn1-modules===0.2.8' 
python -m pip install 'pycparser===2.21' 
python -m pip install 'pyecharts===2.0.4' 
python -m pip install 'Pygments===2.12.0' 
python -m pip install 'PyJWT===1.7.1' 
python -m pip install 'pyparsing===3.0.8' 
python -m pip install 'pyrsistent===0.18.1' 
python -m pip install 'PySocks===1.7.1' 
python -m pip install 'python-dateutil===2.8.2' 
python -m pip install 'pytz===2022.1' 
python -m pip install 'PyWavelets===1.4.1' 
python -m pip install 'PyYAML===5.3.1' 
python -m pip install 'pyzmq===22.3.0' 
python -m pip install 'qdldl===0.1.7.post0' 
python -m pip install 'requests===2.27.1' 
python -m pip install 'requests-oauthlib===1.3.1' 
python -m pip install 'requests-unixsocket===0.2.0' 
python -m pip install 'rsa===4.8' 
python -m pip install 'safetensors===0.3.1' 
python -m pip install 'scikit-image===0.21.0' 
python -m pip install 'scikit-learn===1.2.2' 
python -m pip install 'scikit-survival===0.21.0' 
python -m pip install 'scipy===1.8.0' 
python -m pip install 'seaborn===0.11.2' 
python -m pip install 'SecretStorage===2.3.1' 
python -m pip install 'selenium===4.14.0' 
python -m pip install 'Send2Trash===1.8.0' 
python -m pip install 'simplejson===3.16.0' 
python -m pip install 'six===1.16.0' 
python -m pip install 'snapshot-selenium===0.0.2' 
python -m pip install 'sniffio===1.2.0' 
python -m pip install 'sortedcontainers===2.4.0' 
python -m pip install 'soupsieve===2.3.2.post1' 
python -m pip install 'ssh-import-id===5.10' 
python -m pip install 'stack-data===0.2.0' 
python -m pip install 'tensorboard===2.8.0' 
python -m pip install 'tensorboard-data-server===0.6.1' 
python -m pip install 'tensorboard-plugin-wit===1.8.1' 
python -m pip install 'tensorboardX===2.6.1' 
python -m pip install 'tensorflow-gpu===2.8.0' 
python -m pip install 'tensorflow-io-gcs-filesystem===0.25.0' 
python -m pip install 'termcolor===1.1.0' 
python -m pip install 'terminado===0.13.3' 
python -m pip install 'tf-estimator-nightly===2.8.0.dev2021122109' 
python -m pip install 'thop===0.0.31.post2005241907' 
python -m pip install 'threadpoolctl===3.2.0' 
python -m pip install 'tifffile===2023.7.10' 
python -m pip install 'timm===0.5.4' 
python -m pip install 'tinycss2===1.1.1' 
python -m pip install 'torch===1.8.1+cu111' 
python -m pip install 'torchvision===0.9.1+cu111' 
python -m pip install 'tornado===6.1' 
python -m pip install 'tqdm===4.64.0' 
python -m pip install 'traitlets===5.1.1' 
python -m pip install 'trio===0.22.2' 
python -m pip install 'trio-websocket===0.11.1' 
python -m pip install 'typing-extensions===4.2.0' 
python -m pip install 'urllib3===1.26.9' 
python -m pip install 'wadllib===1.3.3' 
python -m pip install 'wcwidth===0.2.5' 
python -m pip install 'webencodings===0.5.1' 
python -m pip install 'websocket-client===1.3.2' 
python -m pip install 'Werkzeug===2.1.2' 
python -m pip install 'wrapt===1.14.0' 
python -m pip install 'wsproto===1.2.0' 
python -m pip install 'xlwings===0.30.12' 
python -m pip install 'yarg===0.1.9' 
python -m pip install 'zipp===3.8.0' 

# Validate script available in environment at CONDA PREFIX: validate.sh
cp recipes/papers/chief/validate/validate.sh ${CONDA_PREFIX}/bin/validate.sh
chmod +x ${CONDA_PREFIX}/bin/validate.sh

