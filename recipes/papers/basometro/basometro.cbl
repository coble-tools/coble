#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
# ProvGigaPath
#######################################

coble:
  - environment: basometro
channels:
  - conda-forge
languages:
  - python=3.10
pip:
  - pydata-google-auth==1.9.0
  - pydot==3.0.3
  - pydotplus==2.0.2
  #- PyDrive==1.3.1
  - PyDrive2==1.21.3
  - pyerfa==2.0.1.5
  - pygit2==1.16.0
  - Pygments==2.18.0
  #- PyGObject==3.42.1
  - PyJWT==2.10.1
  #- pylibcudf-cu12 @ https://pypi.nvidia.com/pylibcudf-cu12/pylibcudf_cu12-24.10.1-cp310-cp310-manylinux_2_24_x86_64.manylinux_2_28_x86_64.whl
  #- pylibcugraph-cu12==24.10.0
  #- pylibraft-cu12==24.10.0
  - pymc==5.19.1
  - pymystem3==0.2.0
  #- pynvjitlink-cu12==0.4.0
  - pyogrio==0.10.0
  - PyOpenGL==3.1.7
  - pyOpenSSL==24.2.1
  - pyparsing==3.2.0
  - pyperclip==1.9.0
  - pyproj==3.7.0
  - pyshp==2.3.1
  - python-dateutil==2.8.2
  - python-louvain==0.16
  - python-slugify==8.0.4
  - python-utils==3.9.1
  - pytz==2024.2
  - pyviz_comms==3.0.3
  - PyYAML==6.0.2
  - pyzmq==24.0.1
  - qdldl==0.1.7.post4
  - ratelim==0.1.6
  - referencing==0.35.1
  - regex==2024.11.6
  - requests==2.32.3
  - requests-oauthlib==1.3.1
  - requests-toolbelt==1.0.0
  - requirements-parser==0.9.0
  - rich==13.9.4
  #- rmm-cu12==24.10.0
  - rpds-py==0.22.3
  - seaborn==0.13.2
  - sklearn-pandas==2.2.0
  - slicer==0.0.8
  - smart-open==7.0.5
  - smmap==5.0.1
  - sniffio==1.3.1
  - snowballstemmer==2.2.0
  - soundfile==0.12.1
  - soupsieve==2.6
  - soxr==0.5.0.post1
  - spacy==3.7.5
  - spacy-legacy==3.0.12
  - spacy-loggers==1.0.5
  - SQLAlchemy==2.0.36
  - sqlglot==25.1.0
  - sqlparse==0.5.3
  - srsly==2.5.0
  - stanio==0.5.1
  - statsmodels==0.14.4
  - StrEnum==0.4.15
  - stringzilla==3.11.1
  - sympy==1.13.1
  - tables==3.10.1
  - tabulate==0.9.0
  - tbb==2022.0.0
  - tcmlib==1.2.0
  - tifffile==2024.12.12
  - timm==1.0.12
  - tinycss2==1.4.0
  - tokenizers==0.21.0
  - toml==0.10.2
  - tomli==2.2.1
  - toolz==0.12.1
  - tqdm==4.67.1
  - traitlets==5.7.1
  - traittypes==0.2.1
  - transformers==4.47.0
  - tweepy==4.14.0
  - typeguard==4.4.1
  - typer
  - types-pytz==2024.2.0.20241003
  - types-setuptools==75.6.0.20241126
  - typing_extensions
  - tzdata==2024.2
  - tzlocal==5.2
  - uc-micro-py==1.0.3
  - umf==0.9.1
  - uritemplate==4.1.1
  - urllib3==2.2.3
  - zipp==3.21.0
  - ipykernel
  - jupyterlab
  - graphviz
  - ipywidgets
  - plotly
  - openpyxl
  - kaleido==0.2.1

bash:
  - python -m ipykernel install --user --name=mat-basometro --display-name='Python (mat-basometro)'
  - mkdir -p $CONDA_PREFIX/GitHub/mat-basometro
  - git clone https://github.com/rachelicr/mat-basometro.git $CONDA_PREFIX/GitHub/mat-basometro
  - rm -rf $CONDA_PREFIX/GitHub/mat-basometro-run/.git
  - unzip $CONDA_PREFIX/GitHub/mat-basometro/datasets/basometro/basometro_v2.csv.zip -d $CONDA_PREFIX/GitHub/mat-basometro/datasets/basometro/
  - cp $CONDA_PREFIX/GitHub/mat-basometro/datasets/basometro/basometro_v2.csv $CONDA_PREFIX/GitHub/mat-basometro/datasets/basometro/basometro.csv
  #- jupyter nbconvert --to notebook --inplace --ExecutePreprocessor.kernel_name=mat-basometro $CONDA_PREFIX/GitHub/mat-basometro/mattree_basometro.ipynb

