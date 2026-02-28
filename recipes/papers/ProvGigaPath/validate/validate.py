import sys
import os
import time
import psutil
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

if os.environ.get("APPTAINER_CONTAINER") or os.environ.get("SINGULARITY_CONTAINER"):
    os.environ["LD_LIBRARY_PATH"] = "/.singularity.d/libs:" + os.environ.get("LD_LIBRARY_PATH", "")

# ── Memory Check ───────────────────────────────────────────────────
print("=" * 60)
print("MEMORY CHECK")
print("=" * 60)

available_gb = psutil.virtual_memory().available / 1024**3
MEMORY_CAP_TILES = max(5, int((available_gb - 20) / 0.5))

print(f"Memory available:   {available_gb:.0f}GB")
print(f"⚠️  Minimum recommended: 80GB — if killed, request more: srun --mem=80G")
print(f"   Memory-based tile cap: {MEMORY_CAP_TILES}")
print("=" * 60)


# ── Environment Configuration ──────────────────────────────────────
print("=" * 60)
print("ENVIRONMENT CONFIGURATION")
print("=" * 60)

# Required
HF_TOKEN = os.environ.get("HF_TOKEN")
if not HF_TOKEN:
    print("❌ HF_TOKEN is not set. Please set it to your Hugging Face API token.")
    sys.exit(1)
print(f"HF_TOKEN:           ✅ set")

# Optional but important in container environments
HF_HOME = os.environ.get("HF_HOME", os.path.expanduser("~/.cache/huggingface"))
if "HF_HOME" not in os.environ:
    print(f"HF_HOME:            ⚠️  not set, using default: {HF_HOME}")
    print(f"                    In Singularity/Docker set HF_HOME to a writable path")
else:
    print(f"HF_HOME:            ✅ {HF_HOME}")

local_dir = os.path.join(HF_HOME, "downloads")
tmp_dir = os.path.join(HF_HOME, "tmp/outputs/preprocessing/")
slide_path = os.path.join(local_dir, "sample_data/PROV-000-000001.ndpi")
slide_dir = os.path.join(tmp_dir, "output", os.path.basename(slide_path)) + "/"
print("=" * 60)


# ── GPU Compatibility ──────────────────────────────────────────────
def get_gpu_sm():
    if not torch.cuda.is_available():
        return None
    capability = torch.cuda.get_device_capability()
    return capability[0] * 10 + capability[1]

def is_sm_supported_by_pytorch(sm):
    if sm is None:
        return False
    return f"sm_{sm}" in torch.cuda.get_arch_list()

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

def report_hardware(sm, tile_device, slide_device, max_tiles):
    print("=" * 60)
    print("PROV-GIGAPATH HARDWARE COMPATIBILITY REPORT")
    print("=" * 60)
    print(f"PyTorch version:    {torch.__version__}")
    print(f"CUDA available:     {torch.cuda.is_available()}")

    if sm is None:
        print(f"GPU:                None")
        print(f"Tile encoder:       CPU")
        print(f"Slide encoder:      CPU")
        print(f"Max tiles:          {max_tiles}")
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
        reproduction = "✅ Full reproduction possible"
    elif tile_device == "cuda":
        reproduction = "⚠️  Partial - tile encoder on CUDA, slide encoder on CPU"
    else:
        reproduction = "❌ CPU only - results valid but slow"

    print(f"GPU:                {gpu_name}")
    print(f"Architecture:       sm{sm}")
    print(f"VRAM:               {vram:.0f}GB")
    print(f"PyTorch sm support: {'✅' if supported else '❌'} ({', '.join(torch.cuda.get_arch_list())})")
    print(f"flash-attn 2.5.8:   {flash_attn}")
    print(f"Tile encoder:       {tile_device.upper()}")
    print(f"Slide encoder:      {slide_device.upper()}")
    print(f"Max tiles:          {max_tiles if max_tiles else 'all (full reproduction)'}")
    print(f"Paper hardware:     A100 sm80, 40GB VRAM")
    print(f"Reproduction:       {reproduction}")
    print("=" * 60)

sm = get_gpu_sm()
tile_device = get_tile_encoder_device(sm)
slide_device = get_slide_encoder_device(sm)

# Determine MAX_TILES from both hardware and memory constraints
if slide_device == "cuda":
    MAX_TILES = None  # full reproduction
elif sm is not None and is_sm_supported_by_pytorch(sm):
    MAX_TILES = min(50, MEMORY_CAP_TILES)
else:
    MAX_TILES = min(20, MEMORY_CAP_TILES)

report_hardware(sm, tile_device, slide_device, MAX_TILES)


# ── Download Sample Slide ──────────────────────────────────────────
if not os.path.exists(slide_path):
    print("Downloading sample slide...")
    huggingface_hub.hf_hub_download("prov-gigapath/prov-gigapath", filename="sample_data/PROV-000-000001.ndpi", local_dir=local_dir, force_download=False)
else:
    print(f"Sample slide already cached at {slide_path}")


# ── Tiling ─────────────────────────────────────────────────────────
if os.path.exists(slide_dir) and len(os.listdir(slide_dir)) > 0:
    print(f"Tiles already exist at {slide_dir}, skipping tiling")
else:
    print("Tiling slide...")
    tile_one_slide(slide_path, save_dir=tmp_dir, level=1)

image_paths = [os.path.join(slide_dir, img) for img in os.listdir(slide_dir) if img.endswith('.png')]
print(f"Found {len(image_paths)} image tiles")

if MAX_TILES is not None and len(image_paths) > MAX_TILES:
    print(f"WARNING: Subsampling to {MAX_TILES} tiles (hardware/memory constraint)")
    image_paths = image_paths[:MAX_TILES]
else:
    print(f"Using all {len(image_paths)} tiles")


# ── Load Models ────────────────────────────────────────────────────
print("Loading tile and slide encoder models (may take time on first run if not cached)...")
start = time.time()
tile_encoder, slide_encoder_model = load_tile_slide_encoder(
    global_pool=True,
    local_dir=local_dir
)
tile_encoder = tile_encoder.to(tile_device)
slide_encoder_model = slide_encoder_model.to(slide_device)
print(f"Models loaded in {time.time() - start:.1f}s")


# ── Inference ──────────────────────────────────────────────────────
tile_encoder_outputs = run_inference_with_tile_encoder(image_paths, tile_encoder)
for k in tile_encoder_outputs.keys():
    print(f"tile_encoder_outputs[{k}].shape: {tile_encoder_outputs[k].shape}")

slide_embeds = run_inference_with_slide_encoder(
    slide_encoder_model=slide_encoder_model,
    **tile_encoder_outputs
)

print(slide_embeds.keys())
