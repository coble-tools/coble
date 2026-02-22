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
EOF
echo "--------------------------"