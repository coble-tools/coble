# CountReg - solving errors

The takes you through some of the frustrating messages you get on conda installations and how to solve them.

Start with getting the tutorial recipe template:
```bash
coble template --recipe tutorials/countreg/countreg.cbl --flavour fix
```

We get back from the finds the following:
```yaml
coble:
  - environment: coble-env
channels:
# note the reverse order of priority
  - defaults
  - r
  - bioconda
  - conda-forge
flags:
  - dependencies: True
  - build-tools: True
find:
#   - countreg  
found|r-package:
  - countreg@r-forge

#   - r-base=4.4.2
found|languages:
  - r-base=4.4.2@conda-forge
```

Turn it into instructions we can build:
```yaml
coble:
  - environment: coble-env
channels:
# note the reverse order of priority
  - defaults
  - r
  - bioconda
  - conda-forge
flags:
  - dependencies: True
  - build-tools: True
languages:
  - r-base=4.4.2
r-package:
  - countreg@r-forge
```

```bash
coble build --recipe tutorials/countreg/countreg.cbl --env fix-env
```

Finally we exit from the installation, the `summary.txt` has this message:
```text
[coble-create] Start time: 2025-12-30 17:18:18 48/49
install: Rscript -e 'install.packages("countreg", repos="https://R-Forge.R-project.org", dependencies=TRUE, Ncpus=4)'
dep: # * DONE (abind)
dep: # * DONE (carData)
dep: # * DONE (Formula)
dep: # * DONE (TH.data)
dep: # * DONE (mvtnorm)
dep: # * DONE (sandwich)
dep: # * DONE (libcoin)
dep: # * DONE (strucchange)
dep: # * DONE (multcomp)
dep: # * DONE (gamlss.dist)
    # ERROR: from stderr found: installation of 6 packages failed:
[coble-errors] Errors were found during recreation. Please review the recipe file: tutorials/countreg/countreg.cbl.recipe.sh.summary.txt
[coble-errors] Errors found, exiting due to --skip-errors flag
```

We can look in the `.err` file for more info:
```text
The downloaded source packages are in
	‘/tmp/RtmphZ1DG4/downloaded_packages’
Updating HTML index of packages in '.Library'
Making 'packages.html' ... done
Warning message:
In install.packages("countreg", repos = "https://R-Forge.R-project.org",  :
  installation of 6 packages failed:
  ‘topmodels’, ‘car’, ‘countreg’, ‘coin’, ‘party’, ‘mboost’
```

Let's find those packages
```bash
coble build --recipe tutorials/countreg/countreg.cbl --env fix-env
```

```yaml
coble:
  - environment: coble-env
channels:
# note the reverse order of priority
  - defaults
  - r
  - bioconda
  - conda-forge
flags:
  - dependencies: True
  - build-tools: True
languages:
  - r-base=4.4.2
find:
  - topmodels
  - car  
  - coin
  - party
  - mboost
r-package:
  - countreg@r-forge
```

Then edit the instructions:
```yaml
coble:
  - environment: coble-env
channels:
# note the reverse order of priority
  - defaults
  - r
  - bioconda
  - conda-forge
flags:
  - dependencies: True
  - build-tools: True
languages:
  - r-base=4.4.2
r-package:
  - topmodels@r-forge
r-conda:
  - car
  - coin
  - party
  - mboost
r-package:
  - countreg@r-forge

```

Run on update:
```bash
coble build --recipe tutorials/countreg/countreg.cbl --env fix-env
```

The `.delta.sh` file will show the commands being run as part of the update.
```bash
conda activate fix-env
conda config --env --set channel_priority strict
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-c++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gfortran $CONDA_PREFIX/bin/x86_64-conda_cos6-linux-gnu-gfortran
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/gcc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-gcc $CONDA_PREFIX/bin/cc
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/g++
ln -sf $CONDA_PREFIX/bin/x86_64-conda-linux-gnu-g++ $CONDA_PREFIX/bin/c++
export CFLAGS="-I$CONDA_PREFIX/include"
export CXXFLAGS="-I$CONDA_PREFIX/include"
export CPPFLAGS="-I$CONDA_PREFIX/include"
export LDFLAGS="-L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib"
conda install -y 'r-base=4.4.2'

conda install -y  --no-update-deps \
'r-topmodels' \
'r-car' \
'r-coin' \
'r-party' \
'r-mboost' 

Rscript -e 'install.packages("countreg", repos="https://R-Forge.R-project.org", dependencies=TRUE, Ncpus=4)'
```

Keep working though these messages:
`ERROR: dependency` add in dependency3, MBA bamlss, jjags compilation error suggests conda would be better so:
```yaml
coble:
  - environment: coble-env
channels:
# note the reverse order of priority
  - defaults
  - r
  - bioconda
  - conda-forge
flags:
  - dependencies: True
  - build-tools: True
languages:
  - r-base=4.4.2 
r-conda:
  - coda
  - sp
  - car
  - coin
  - party
  - mboost
  - rjags
r-package:
  - distributions3
  - MBA
  - bamlss
  - ordinal
  - topmodels@r-forge
  - countreg@r-forge
```
Run on update:
```bash
coble build --recipe tutorials/countreg/countreg.cbl --env fix-env
```
It works!  
To be certian re-run from the beginning:

```bash
coble build --inprecipeut tutorials/countreg/countreg.cbl --env fix-env --rebuild
```