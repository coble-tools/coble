# Chief coble
```bash
code/coble build \
--recipe dev-recipes/chief/chief.cbl \
--env ./CHIEF \
--validate dev-recipes/chief/validate/validate.sh \
--val-folder dev-recipes/chief/validate \
--containers conda \
--rebuild

code/coble export \
--xrecipe dev-recipes/chief/chief_export.cbl \
--env chief \
--debug
```



# Chief
https://github.com/hms-dbmi/CHIEF?tab=readme-ov-file
https://www.nature.com/articles/s41586-024-07894-z

Instructions to create on gpudev:

srun --pty -t 1:00:00 -p gpudev --gres=gpu:1 bash

cd /data/scratch/DCO/DIGOPS/SCIENCOM/ralcraft/DEV/syed-gpu
conda create -y -p ./chief-env python=3.10
conda activate ./chief-env
conda config --env --remove-key channels
conda config --env --set channel_priority strict
conda config --env --add channels pytorch
conda config --env --add channels nvidia
conda config --env --add channels conda-forge

conda install -y \
	--solver=libmamba \
    typing_extensions \
	pillow \
	pyyaml \
	pandas \
	scikit-learn \
	ipykernel
	
conda install -y \
    --solver=libmamba \
	tensorflow	

conda install -y \
    --solver=libmamba \
	pytorch \
	torchvision \
	torchaudio \
	pytorch-cuda

conda install -y timm=0.5.4
conda install -y -c conda-forge libstdcxx-ng

# set the environment variable both now and in conda for when you next activate
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH
conda env config vars set LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH

python -c "import torch, torchvision; print('OK')"

# Now verify what we have
# Before doing anything, check current GPU support
python -c "import torch; print(torch.__version__, torch.cuda.is_available(), torch.version.cuda)"

git clone https://github.com/hms-dbmi/CHIEF.git
cd CHIEF


# run the examples
conda activate ./chief-env
python Get_CHIEF_patch_feature.py
python Get_CHIEF_WSI_level_feature_batch.py
python Get_CHIEF_WSI_level_feature.py

