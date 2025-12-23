23/12/25
-[ ] Need to implement an updater now
-[ ] Need to create the basics of a web app for icr
-[ ] Make a basic dependency viewer for the web app using the summary txt format. For conda packages take the 

20/12/25
- [x] I need to ensure the channels are correct, decide do I alwayse use the ones in the env or pass in each command?
string or flexible?
-[ ] I also need to sort out inputs, --recipe or --yaml or input?
-[ ] Maybe either recipe or yaml is given? or recipe is given it is copied to a fixed place and used otherwise that fixed place is the given recipe for the capture.
-[ ] So a restriction is made that to "create" you cannot pass both yaml and recipe only one or the other. No I don;t like that.
To create you pass input, it detects if it is yaml or recipe and then creates recipe for the recipse and create stages. And passes --recipe there explicitly not input soince it has to be.
-[ ] coble-rationalise - implement it is empty at the moment

19/12/25
Meeting with Syed
He wants it to be the simplest thing possible for a user.
They make a yaml file i the way we suggest.
If they don;t know they use find at the bottom.
For everything if it is wrong it stops and tells them it is wrong straight away so they are forced to fix the yaml before anythong else.
Simplest case and also make the inputs simple
manager:
  - pkg=version@source

manager as in conda or r-package
source as in a channel or a url or a local path

Use case is that you can't expect to be able to do everythong but can tell the user what they need to do.
2 r versions won;t work for example.



######################
15/12/25
-[x] Keep logs needs to be a param that defaults to no
-[x] Need to parse out logs
-[x] Need to create a set og configs from publictions ot web, sylver, nanostring cosmx, random one: https://github.com/MICS-Lab/novae  
-[x] Need to make it a provate conda package
-[x] change script to do conda activate and have the name in it explicitly as it is an output of the build.
-[x] recipe is wrong name file 
-[x] needs to be put in a specific folder
-[x] versions don; work for r
-[x] sylver get that working, the file paths not quiote  make removal of all interim files the deauly (recipe and capture only)


14/12/25
-[x] Flags implement for upgrades and deps
-[ ] env name hiearchy of inputs established
-[x] Split into capture, recipise and recreate scripts
-[ ] Ensure r, bioc, pip and conda work as well as pip giuthub and r githum and r url
-[ ] Make a test that does those things
-[ ] Add to conda as a private package
-[x] remove duplicates
-[ ] Put back the error parsing and logging and the ability to exit.
-[ ] I have completely lost the function to resume from where last left off.
-[ ] Struggling to get rid of the TOCs


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