
# Chief
https://github.com/hms-dbmi/CHIEF?tab=readme-ov-file
https://www.nature.com/articles/s41586-024-07894-z

From Sina
```bash
conda create -n chief python=3.8.10
pip install torch==1.8.1+cu111 torchvision==0.9.1+cu111 -f https://download.pytorch.org/whl/torch_stable.html

pip install h5py==3.6.0 matplotlib==3.5.2 numpy==1.22.3 opencv-python==4.5.5.64 openslide-python==1.3.0 pandas==1.4.2 Pillow==10.0.0 scikit-image==0.21.0 scikit-learn==1.2.2 scikit-survival==0.21.0 scipy==1.8.0 tensorboardX==2.6.1 tensorboard==2.8.0
pip install timm-0.5.4.tar
pip install openslide-bin
python -m pip install "pip<24.1"
python -m pip install -U "setuptools>=68" wheel packaging
pip install -r requirements.txt
```

```bash
code/coble build \
--recipe recipes/papers/chief/chief.cbl \
--env chief \
--validate recipes/papers/chief/validate/validate.sh \
--val-folder recipes/papers/chief/validate \
--rebuild
```