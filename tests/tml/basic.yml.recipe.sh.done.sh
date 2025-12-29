# Adding to env captured by ralcraft on 2025-12-29 at 14:15:25 GMT
source "$(conda info --base)/etc/profile.d/conda.sh"

source ~/.bashrc

conda create --prefix ./myenv -y

conda activate ./myenv
conda config --env --remove-key channels

conda config --env --set channel_priority strict

conda config --env --add channels defaults

conda config --env --add channels r

conda config --env --add channels bioconda

conda config --env --add channels conda-forge

conda install -y 'conda-forge::python=3.13.1'

conda install -y -c conda-forge 'r-base=4.3.1'

conda install -y  --no-update-deps \
'pandas' 

conda install -y  --no-update-deps \
'r-tidyverse' \
'r-ggplot2' 

# Adding to env captured by ralcraft on 2025-12-29 at 14:20:05 GMT
conda activate ./myenv
# Adding to env captured by ralcraft on 2025-12-29 at 14:28:01 GMT
conda activate ./myenv
# Adding to env captured by ralcraft on 2025-12-29 at 14:28:47 GMT
conda activate ./myenv
