#!/usr/bin/env bash

echo "# VALIDATING THE ProgGigaPath ENVIRONMENT FOR GPU SUPPORT"
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
import os
import torch
import huggingface_hub
from gigapath.pipeline import tile_one_slide
from gigapath.pipeline import load_tile_slide_encoder
from gigapath.pipeline import run_inference_with_tile_encoder
from gigapath.pipeline import run_inference_with_slide_encoder
import numpy as np

# Please set your Hugging Face API token
assert "HF_TOKEN" in os.environ, "Please set the HF_TOKEN environment variable to your Hugging Face API token"

# Check GPU compatibility
def get_gpu_sm():
    if not torch.cuda.is_available():
        return None
    capability = torch.cuda.get_device_capability()
    return capability[0] * 10 + capability[1]

def get_tile_encoder_device(sm):
    if sm is None:
        print("WARNING: No GPU available, using CPU for tile encoder")
        return "cpu"
    print(f"GPU sm{sm} available, using GPU for tile encoder")
    return "cuda"

def get_slide_encoder_device(sm):
    if sm is None:
        print("WARNING: No GPU available, using CPU for slide encoder")
        return "cpu"
    if sm < 75:
        print(f"WARNING: GPU sm{sm} is too old for flash-attn (requires sm75+), falling back to CPU for slide encoder")
        return "cpu"
    elif sm >= 120:
        print(f"WARNING: GPU sm{sm} is too new for flash-attn 2.5.8, falling back to CPU for slide encoder")
        return "cpu"
    else:
        print(f"GPU sm{sm} is compatible with flash-attn, using GPU for slide encoder")
        return "cuda"

sm = get_gpu_sm()
tile_device = get_tile_encoder_device(sm)
slide_device = get_slide_encoder_device(sm)

# Download a sample slide
local_dir = os.path.join(os.path.expanduser("~"), ".cache/")
huggingface_hub.hf_hub_download("prov-gigapath/prov-gigapath", filename="sample_data/PROV-000-000001.ndpi", local_dir=local_dir, force_download=True)
slide_path = os.path.join(local_dir, "sample_data/PROV-000-000001.ndpi")

# Tiling
tmp_dir = 'outputs/preprocessing/'
tile_one_slide(slide_path, save_dir=tmp_dir, level=1)

# Load tile images
slide_dir = "outputs/preprocessing/output/" + os.path.basename(slide_path) + "/"
image_paths = [os.path.join(slide_dir, img) for img in os.listdir(slide_dir) if img.endswith('.png')]
print(f"Found {len(image_paths)} image tiles")

# Subsample tiles based on available hardware
if slide_device == "cuda":
    # Compatible GPU - use all tiles as per paper
    print(f"Compatible GPU detected, using all {len(image_paths)} tiles as per paper")
elif sm is not None:
    # GPU available but slide encoder on CPU - limit tiles
    MAX_TILES = 50
    if len(image_paths) > MAX_TILES:
        print(f"WARNING: Slide encoder on CPU, subsampling to {MAX_TILES} tiles to avoid memory issues")
        image_paths = image_paths[:MAX_TILES]
else:
    # No GPU at all - be very conservative
    MAX_TILES = 20
    if len(image_paths) > MAX_TILES:
        print(f"WARNING: No GPU available, subsampling to {MAX_TILES} tiles for CPU inference")
        image_paths = image_paths[:MAX_TILES]

# Load the Prov-GigaPath model (tile and slide encoder models)
# NOTE: The CLS token is not trained during the slide-level pretraining.
# Here, we enable the use of global pooling for the output embeddings.
tile_encoder, slide_encoder_model = load_tile_slide_encoder(global_pool=True)

# Run tile-level inference
# Original code: tile_encoder_outputs = run_inference_with_tile_encoder(image_paths, tile_encoder)
if tile_device == "cpu":
    tile_encoder = tile_encoder.cpu()
tile_encoder_outputs = run_inference_with_tile_encoder(image_paths, tile_encoder)
for k in tile_encoder_outputs.keys():
    print(f"tile_encoder_outputs[{k}].shape: {tile_encoder_outputs[k].shape}")

# Run slide-level inference
# Original code: slide_embeds = run_inference_with_slide_encoder(slide_encoder_model=slide_encoder_model, **tile_encoder_outputs)
# Modified to fall back to CPU where flash-attn is not supported (sm<75 or sm>=120)
if slide_device == "cuda":
    slide_embeds = run_inference_with_slide_encoder(
        slide_encoder_model=slide_encoder_model,
        **tile_encoder_outputs
    )
else:
    slide_encoder_model = slide_encoder_model.cpu()
    slide_embeds = run_inference_with_slide_encoder(
        slide_encoder_model=slide_encoder_model,
        tile_embeds=tile_encoder_outputs['tile_embeds'].cpu(),
        coords=tile_encoder_outputs['coords'].cpu(),
        all_layer_embed=True
    )

print(slide_embeds.keys())
EOF
echo "--------------------------"
echo "Validation complete!"