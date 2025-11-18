18/11/2025 Feedback from Syed
- [ ] He really wants to run from recipe, have it kick out if there are ANY errors, then resume when he has fixed it from a chosen location.
- [ ] So what we are looking for is checkpointing and resume. So a batch is started. It stops. When the confg is fixed you press "resume". It simply starts agin going thorugh the bash lines it generates 1 by 1 but if it finds 1 identical to a line it has already done it doesn;t execute. When it exits gracelessly it copes the recipe to a file_recipe_checkpoint.txt so you can see where it got to. If that file already exists it copies it and then reretaes it. At the beginning of every run if you have chosen checkointing it checks if that file exists and if so uses that to skip lines already done.

17/11/2025
-[ ] Outstanding issue with the order of channlels when running in singularity from slurm.

15/11/2025
-[x] move to guthub and use runners
-[x] add docker images
-[x] build as singularity
-[ ] restructure so it takes within 6 hours for the runners on github NO using singularity instead of docker
-[x] logs do not exist in container build so error report is not created, need to divert stout to files
-[x] logs now double , add a flag to divert or not so only need to divert in a docker contaner or bash if required.

13/11/2025
-[x] change to new name coble
-[x] Have slurm and bash scruots serpeatey
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