05/12/25
-[ ] make it recognise either ENV_NAME or ENVS_DIR for prefix, or make it more explicirly ENV_NAME or PREFIX
-[x] genericbase docker image!!!
-[ ] Add a find or order list to try, eg straight, r-, r, bioc-, bioc, 
-[ ] Put yaml back with R: Biocmanager: Pip: and Coble: (which tries)
-[ ] Make it pip install and download ONLY the 3 files that are relevant in the code folder. scripts and docker. Oh also configs then and docker. url.

13/11/2025
-[ ] change to new name coble
-[ ] Have slurm and bash scruots serpeatey
-[ ] R and python versions "latest" and "none" options
-[ ] Add a compare option for between envs or files

10/11/2025
-[ ] Test the order in the history for 4.4.2 for shjoincount
-[x] How to fix the throttle problem with devtools? wget? auth? - with wget and direct download
-[ ] make mamba or conda optional - add a block for mamba or conda install

07/11/2025
-[x] Add Switching to in missing file so I know where to move the block to
-[ ] Try large scale with moved packages, what is still missing, stjoin?
-[x] add a wget block and a devtools and remotes (are they the same?)
-[ ] How do I know if it has worked? Simple fixed compare for hardcoded yaml, and renvlock and pip freeze?
-[x] Add a mode to update only specific packages, ie give the env and a small yml
-[x] Save reults of error and missing to specified output folder
-[ ] Test if order of things matters by simply doing it twice and checking the missings each time
-[ ] Workthough 4.5.2 errors in detail