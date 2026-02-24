#!/usr/bin/env bash

echo "# VALIDATING THE CHIEF ENVIRONMENT FOR GPU SUPPORT"
echo "1. Check the GPU capability"
nvidia-smi
echo "--------------------------"
echo "2. Confirm if pytorch is running with GPU support"
python -c "import torch; print(torch.__version__, torch.cuda.is_available(), torch.version.cuda)"
python -c "import torch; print(torch.cuda.get_device_name(0))"
python -c "import torch; print(torch.cuda.get_device_properties(0))"
echo "--------------------------"
# python heredoc for time testing
echo "3. Runnning a time test on CPU vs GPU"
python << 'EOF'
import torch
import time

# Create large tensors
a = torch.randn(10000, 10000)
b = torch.randn(10000, 10000)

# CPU timing
start = time.time()
c = torch.matmul(a, b)
print(f"CPU: {time.time() - start:.2f}s")

# GPU timing
a, b = a.cuda(), b.cuda()
torch.cuda.synchronize()  # make sure GPU is ready
start = time.time()
c = torch.matmul(a, b)
torch.cuda.synchronize()  # wait for GPU to finish
print(f"GPU: {time.time() - start:.2f}s")

print("4. More advanced device test")
device = torch.accelerator.current_accelerator().type if torch.accelerator.is_available() else "cpu"
print(f"Using {device} device")
x = torch.randn(10000, device=device)
torch.cuda.synchronize()
print("Device is ok")
EOF
echo "--------------------------"

echo "5. Verify the gitinstall of CHIEF code works and is on the expected branch/commit"
cd $CONDA_PREFIX/CHIEF
git log --oneline -n 5

echo "6. Run their first python script: Get_CHIEF_patch_feature.py"
cd $CONDA_PREFIX/CHIEF
echo "Code run with PyTorch 2.6 on NVIDIA RTX PRO 500 Blackwell; weights_only=False added to torch.load calls due to PyTorch 2.6 API change. Results are otherwise identical."
sed -i 's/torch.load(\(.*\))/torch.load(\1, weights_only=False)/g' Get_CHIEF_WSI_level_feature.py
echo "edit line 20 of Get_CHIEF_patch_feature.py to add weights_only=False to torch.load calls"
ech "Before edit:"
echo "td = torch.load(r'./model_weight/CHIEF_CTransPath.pth')"
echo "After edit:"
echo "td = torch.load(r'./model_weight/CHIEF_CTransPath.pth', weights_only=False)"
python Get_CHIEF_patch_feature.py



echo "7. Run their second python script: Get_CHIEF_WSI_level_feature.py"
echo "Unfortunately we have to get their pt file from a docker image!"
docker run -d --name chief_temp chiefcontainer/chief:v1.11
mkdir -p ./Downstream/Tumor_origin/src/feature/tcga
docker cp chief_temp:/root/CHIEF/Downstream/Tumor_origin/src/feature/tcga/TCGA-LN-A8I1-01Z-00-DX1.F2C4FBC3-1FFA-45E9-9483-C3F1B2B7EF2D.pt ./Downstream/Tumor_origin/src/feature/tcga/
docker stop chief_temp
docker rm chief_temp
python3 Get_CHIEF_WSI_level_feature.py

echo "8. Run their third python script: Get_CHIEF_WSI_level_feature.py"
python3 Get_CHIEF_WSI_level_feature.py




