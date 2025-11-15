# Using coble with singularity

There are docker containers on dockerhub with pre-build conda enviropnments as per the config files in `config` with matching names.

For example if you want to use the conda environment defined in `config/coble-452.yml` you can use the docker image `icrsc/coble:452`.

To pull an image and give it a specific file name you can use (-F forces a replace over the existing file):

```bash
singularity pull -F coble-452.sif docker://icrsc/coble:452
```

You can then run the container with:

```bash
singularity shell coble-452.sif
```
This opens up a shell inside the container. There is an activation script that runs automatically to activate the envirtonment so you are immediately inside the singularity container with an actove conda environment. Due to the way singularity works you will have access to the files on the host system so you can continue to work in the same way as you would were this a conda environment, interactig with files on the host system and running scripts, accessing image files etc.

The singularity images are entirely self contained so once downloaded as a file they can be, for example, copied to a TRE or other secure non-internet connected system and run there without any further downloads or setup.



