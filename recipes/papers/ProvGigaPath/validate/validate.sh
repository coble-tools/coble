#!/usr/bin/env bash
python << 'EOF'

import os
import time
import torch
import huggingface_hub
import numpy as np

import warnings
warnings.filterwarnings("ignore", category=FutureWarning)
warnings.filterwarnings("ignore", category=UserWarning)

from gigapath.pipeline import tile_one_slide
from gigapath.pipeline import load_tile_slide_encoder
from gigapath.pipeline import run_inference_with_tile_encoder
from gigapath.pipeline import run_inference_with_slide_encoder



# ── Environment Configuration ──────────────────────────────────────
print("=" * 60)
print("ENVIRONMENT CONFIGURATION")
print("=" * 60)

# Required
HF_TOKEN = os.environ.get("HF_TOKEN")
if not HF_TOKEN:
    raise EnvironmentError("HF_TOKEN is not set. Please set it to your Hugging Face API token.")
print(f"HF_TOKEN:           ✅ set")

# Optional but important in container environments
HF_HOME = os.environ.get("HF_HOME", os.path.expanduser("~/.cache/huggingface"))
if "HF_HOME" not in os.environ:
    print(f"HF_HOME:            ⚠️  not set, using default: {HF_HOME}")
    print(f"                    In Singularity/Docker set HF_HOME to a writable path")
else:
    print(f"HF_HOME:            ✅ {HF_HOME}")

TMPDIR = os.environ.get("TMPDIR", "/tmp")
if "TMPDIR" not in os.environ:
    print(f"TMPDIR:             ⚠️  not set, using default: {TMPDIR}")
    print(f"                    In Singularity/Docker set TMPDIR to a writable path")
else:
    print(f"TMPDIR:             ✅ {TMPDIR}")

print("=" * 60)

local_dir = os.path.join(HF_HOME, "downloads")
tmp_dir = os.path.join(TMPDIR, "outputs/preprocessing/")
slide_dir = os.path.join(TMPDIR, "outputs/preprocessing/output/", os.path.basename(slide_path)) + "/"


# Check GPU compatibility
def get_gpu_sm():
    if not torch.cuda.is_available():
        return None
    capability = torch.cuda.get_device_capability()
    return capability[0] * 10 + capability[1]

def is_sm_supported_by_pytorch(sm):
    """Check if the GPU sm version is supported by the current PyTorch installation"""
    if sm is None:
        return False
    supported = torch.cuda.get_arch_list()
    return f"sm_{sm}" in supported

def get_tile_encoder_device(sm):
    if sm is None:
        return "cpu"
    if not is_sm_supported_by_pytorch(sm):
        return "cpu"
    return "cuda"

def get_slide_encoder_device(sm):
    if sm is None:
        return "cpu"
    if not is_sm_supported_by_pytorch(sm):
        return "cpu"
    if sm < 75:
        return "cpu"
    elif sm >= 120:
        return "cpu"
    return "cuda"

def report_hardware(sm, tile_device, slide_device):
    print("=" * 60)
    print("PROV-GIGAPATH HARDWARE COMPATIBILITY REPORT")
    print("=" * 60)
    print(f"PyTorch version:    {torch.__version__}")
    print(f"CUDA available:     {torch.cuda.is_available()}")

    if sm is None:
        print(f"GPU:                None")
        print(f"Tile encoder:       CPU")
        print(f"Slide encoder:      CPU")
        print(f"Max tiles:          20")
        print(f"Paper hardware:     A100 sm80, 40GB VRAM")
        print(f"Reproduction:       ❌ No GPU available")
        print("=" * 60)
        return

    supported = is_sm_supported_by_pytorch(sm)
    gpu_name = torch.cuda.get_device_name(0)
    vram = torch.cuda.get_device_properties(0).total_memory / 1024**3

    if sm < 75:
        flash_attn = "❌ too old (requires sm75+)"
    elif sm >= 120:
        flash_attn = "❌ too new (flash-attn 2.5.8 max sm119)"
    else:
        flash_attn = "✅"

    if slide_device == "cuda":
        max_tiles = "all (full reproduction)"
        reproduction = "✅ Full reproduction possible"
    elif tile_device == "cuda":
        max_tiles = "50"
        reproduction = "⚠️  Partial - tile encoder on CUDA, slide encoder on CPU"
    else:
        max_tiles = "20"
        reproduction = "❌ CPU only - results valid but slow"

    print(f"GPU:                {gpu_name}")
    print(f"Architecture:       sm{sm}")
    print(f"VRAM:               {vram:.0f}GB")
    print(f"PyTorch sm support: {'✅' if supported else '❌'} ({', '.join(torch.cuda.get_arch_list())})")
    print(f"flash-attn 2.5.8:   {flash_attn}")
    print(f"Tile encoder:       {tile_device.upper()}")
    print(f"Slide encoder:      {slide_device.upper()}")
    print(f"Max tiles:          {max_tiles}")
    print(f"Paper hardware:     A100 sm80, 40GB VRAM")
    print(f"Reproduction:       {reproduction}")
    print("=" * 60)

# Detect hardware and report
sm = get_gpu_sm()
tile_device = get_tile_encoder_device(sm)
slide_device = get_slide_encoder_device(sm)
report_hardware(sm, tile_device, slide_device)

# Download a sample slide
slide_path = os.path.join(local_dir, "sample_data/PROV-000-000001.ndpi")
if not os.path.exists(slide_path):
    print("Downloading sample slide...")
    huggingface_hub.hf_hub_download("prov-gigapath/prov-gigapath", filename="sample_data/PROV-000-000001.ndpi", local_dir=local_dir, force_download=False)
else:
    print(f"Sample slide already cached at {slide_path}")

# Tiling
if os.path.exists(slide_dir) and len(os.listdir(slide_dir)) > 0:
    print(f"Tiles already exist at {slide_dir}, skipping tiling")
else:
    print("Tiling slide...")
    tile_one_slide(slide_path, save_dir=tmp_dir, level=1)

# Load tile images
image_paths = [os.path.join(slide_dir, img) for img in os.listdir(slide_dir) if img.endswith('.png')]
print(f"Found {len(image_paths)} image tiles")

# Subsample tiles based on available hardware
if slide_device == "cuda":
    print(f"Compatible GPU detected, using all {len(image_paths)} tiles as per paper")
elif sm is not None and is_sm_supported_by_pytorch(sm):
    MAX_TILES = 50
    if len(image_paths) > MAX_TILES:
        print(f"WARNING: Slide encoder on CPU, subsampling to {MAX_TILES} tiles to avoid memory issues")
        image_paths = image_paths[:MAX_TILES]
else:
    MAX_TILES = 20
    if len(image_paths) > MAX_TILES:
        print(f"WARNING: No supported GPU available, subsampling to {MAX_TILES} tiles for CPU inference")
        image_paths = image_paths[:MAX_TILES]

# Load the Prov-GigaPath model (tile and slide encoder models)
# NOTE: The CLS token is not trained during the slide-level pretraining.
# Here, we enable the use of global pooling for the output embeddings.
print("Loading tile and slide encoder models (may take time on first run if not cached)...")
start = time.time()
tile_encoder, slide_encoder_model = load_tile_slide_encoder(global_pool=True)
tile_encoder = tile_encoder.to(tile_device)
slide_encoder_model = slide_encoder_model.to(slide_device)
print(f"Models loaded in {time.time() - start:.1f}s")

# Run tile-level inference
# Original code: tile_encoder_outputs = run_inference_with_tile_encoder(image_paths, tile_encoder)

tile_encoder_outputs = run_inference_with_tile_encoder(image_paths, tile_encoder)
for k in tile_encoder_outputs.keys():
    print(f"tile_encoder_outputs[{k}].shape: {tile_encoder_outputs[k].shape}")

# Run slide-level inference
# Original code: slide_embeds = run_inference_with_slide_encoder(slide_encoder_model=slide_encoder_model, **tile_encoder_outputs)

slide_embeds = run_inference_with_slide_encoder(
    slide_encoder_model=slide_encoder_model,
    **tile_encoder_outputs
)

print(slide_embeds.keys())


EOF
echo "--------------------------"
echo "Validation complete!"