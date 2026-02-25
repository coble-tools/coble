#######################################
# COBLE:Reproducible environment yaml, (c) ICR 2026
# PyTorch environment
#######################################

coble:
  - environment: torch
channels:
  - conda-forge
flags:
  # The flags control which version of PyTorch is installed
  # This may need some trial and error for your hardware
  - export: CUDA="cu128"
  - export: TORCH="2.7.0"
  - export: TORCHVISION="0.22.0"
languages:
  - python=3.10
conda:
  - typing_extensions
  - pillow
  - pyyaml
  - pandas
  - scikit-learn
  - ipykernel
  - requests
  - openslide
  - openslide-python
  - h5py
  - timm
bash:
  - python -m pip install torch==$TORCH torchvision==$TORCHVISION torchaudio==$TORCH --index-url https://download.pytorch.org/whl/$CUDA
pip:
  - addict
  - gdown
  - iterative-stratification
  - exhaustive-weighted-random-sampler
  - scikit-survival
flags:
  - export: LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH
validate:
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