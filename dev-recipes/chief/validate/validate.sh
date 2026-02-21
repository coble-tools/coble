#!/usr/bin/env bash

echo "# VALIDATING THE CHIEF ENVIRONMENT FOR GPU SUPPORT"
echo "Check the GPU capability"
nvidia-smi  
echo ""
echo "Confirm if pytorch is running with GPU support"
python -c "import torch; print(torch.__version__, torch.cuda.is_available(), torch.version.cuda)"
python -c "import torch; print(torch.cuda.get_device_name(0))"
python -c "import torch; print(torch.cuda.get_device_properties(0))"
