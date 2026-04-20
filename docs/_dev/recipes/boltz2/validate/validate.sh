
echo "Validating Boltz2 installation and functionality..." >&2
echo "Checking GPU availability with nvidia-smi..." >&2
nvidia-smi

echo "Running boltz predict with affinity.yaml configuration..." >&2
boltz predict "$CONDA_PREFIX/bin/affinity.yaml" \
	--accelerator gpu \
	--devices 1 \
	--num_workers 0 \
	--preprocessing-threads 1 \
	--use_msa_server \
	--cache /tmp/boltz_cache

