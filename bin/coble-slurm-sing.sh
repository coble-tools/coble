#!/usr/bin/env bash
#SBATCH -J "CobleSingularityBuild"
#SBATCH --output=logs/coble-sing-build-%j.out
#SBATCH --error=logs/coble-sing-build-%j.err
#SBATCH -n 2
#SBATCH -t 10:00:00
#SBATCH --mem=16G

# COBLE Singularity Build Script for SLURM
# Usage: sbatch bin/coble-slurm-sing.sh <variant>
# Example: sbatch bin/coble-slurm-sing.sh 452

# Get variant from command line argument (default to mini)
VARIANT=${1:-mini}

# Validate variant
if [[ ! -f "singularity/coble-${VARIANT}.def" ]]; then
    echo "ERROR: Definition file singularity/coble-${VARIANT}.def not found"
    echo "Available variants:"
    ls singularity/coble-*.def 2>/dev/null | sed 's/.*coble-\(.*\)\.def/  - \1/'
    exit 1
fi

if [[ ! -f "config/coble-${VARIANT}.yml" ]]; then
    echo "ERROR: Config file config/coble-${VARIANT}.yml not found"
    exit 1
fi

# Export SLURM environment info
echo "### SLURM ###################################"
echo "SLURM_JOB_ID=$SLURM_JOB_ID"
echo "SLURM_JOB_NODELIST=$SLURM_JOB_NODELIST"
echo "SLURM_NNODES=$SLURM_NNODES"
echo "SLURM_NTASKS=$SLURM_NTASKS"
echo "SLURM_CPUS_ON_NODE=$SLURM_CPUS_ON_NODE"
echo "SLURM_MEM_PER_CPU=$SLURM_MEM_PER_CPU"
echo "SLURM_MEM_PER_NODE=$SLURM_MEM_PER_NODE"
echo "SLURM_TIME_LIMIT=$SLURM_TIME_LIMIT"
echo "############################################"
echo ""
echo "### BUILD INFO #############################"
echo "VARIANT: $VARIANT"
echo "DEFINITION FILE: singularity/coble-${VARIANT}.def"
echo "CONFIG FILE: config/coble-${VARIANT}.yml"
echo "OUTPUT IMAGE: singularity/coble-${VARIANT}.sif"
echo "############################################"
echo ""

# Ensure directories exist
mkdir -p logs singularity

# Load singularity module (adjust for your HPC)
source ~/.bashrc

# Check if singularity is available
if ! command -v singularity &> /dev/null; then
    echo "ERROR: singularity command not found"
    exit 1
fi

echo "Singularity version:"
singularity --version
echo ""

# Build the image
echo "Starting Singularity build at $(date)"
echo "Command: singularity build --force --fakeroot singularity/coble-${VARIANT}.sif singularity/coble-${VARIANT}.def"
echo ""

# Try fakeroot first, fall back to sudo if available
if singularity build --fakeroot --force "singularity/coble-${VARIANT}.sif" "singularity/coble-${VARIANT}.def"; then
    echo ""
    echo "Build completed successfully at $(date)"
    echo "Image: singularity/coble-${VARIANT}.sif"
    
    # Show image info
    echo ""
    echo "### IMAGE INFO #############################"
    singularity inspect "singularity/coble-${VARIANT}.sif" 2>/dev/null || echo "Image inspection not available"
    
    # Show image size
    if [[ -f "singularity/coble-${VARIANT}.sif" ]]; then
        echo ""
        echo "Image size: $(du -h singularity/coble-${VARIANT}.sif | cut -f1)"
    fi
    echo "############################################"
    
    exit 0
else
    BUILD_EXIT=$?
    echo ""
    echo "ERROR: Build failed with exit code $BUILD_EXIT at $(date)"
    echo ""
    echo "Troubleshooting:"
    echo "  - Check if fakeroot is enabled: singularity version"
    echo "  - Try building with sudo if you have permissions"
    echo "  - Check logs/coble-sing-build-${SLURM_JOB_ID}.err for details"
    echo "  - Verify config file: config/coble-${VARIANT}.yml"
    echo "  - Check internet connectivity for base image and conda channels"
    
    exit $BUILD_EXIT
fi
