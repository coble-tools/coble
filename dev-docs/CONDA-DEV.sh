
https://anaconda.org/

conda create -n build-conda
conda activate build-conda
conda install -c conda-forge requests conda-build anaconda-client conda-index


# In installing locally
conda install --use-local my-bash-utility

# To release to anaconda.org
conda build conda-recipe

# The build command will show where the package was saved
# It will look something like:
# /path/to/conda-bld/noarch/my-bash-utility-1.0.0-0.tar.bz2

# rachelsa, <password>

anaconda org login # interactivly click the link and log in
anaconda upload  /home/ralcraft/miniconda/conda-bld/noarch/coble-0.0.2-1.conda
anaconda upload --private  /home/ralcraft/miniconda/conda-bld/noarch/coble-0.0.2-1.conda

conda install -c your-username my-bash-utility