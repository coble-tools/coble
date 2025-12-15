

conda activate build-conda
conda activate build-conda
conda install -c conda-forge requests conda-build anaconda-client conda-index

# In installing locally
conda install --use-local my-bash-utility

# To release to anaconda.org
conda build conda-recipe
anaconda login #rachelSA # K!d25


# The build command will show where the package was saved
# It will look something like:
# /path/to/conda-bld/noarch/my-bash-utility-1.0.0-0.tar.bz2

anaconda upload /home/ralcraft/miniconda3/conda-bld/noarch/coble-0.0.1-0.conda
anaconda upload --private /home/ralcraft/miniconda3/conda-bld/noarch/coble-0.0.1-0.conda

conda install -c your-username my-bash-utility