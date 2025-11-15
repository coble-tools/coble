# COBLE - COnda BuiLdEr

<img src="coble.png" alt="COBLE logo" width="200" style="float: left; margin-right: 20px; margin-bottom: 10px;" />

**COBLE - COnda BuiLdEr**: Build and manage conda environments from the RSE team at the ICR

The GitLab for COBLE is at: [https://gitlab.com/icr-rse/apps/coble](https://gitlab.com/icr-rse/apps/coble)  

COBLE is a set of scripts to help build and manage conda environments, particularly for R and Bioconductor packages, along with Python packages. It allows you to define environments using YAML files or bash recipes, automates the installation process, captures logs for error analysis, and generates reproducible outputs including combined environment files and installation scripts.

COBLE packages are built on Docker and made available via DockerHub for easy use with Singularity. This enables the same conda environments to be used on secure systems without internet access.

## Key Features

- 🐍 **Multi-language Support**: Python, R, and Bioconductor packages
- 🐳 **Container-Ready**: Docker images published to DockerHub
- 🔒 **Offline-Capable**: Use Singularity images in air-gapped environments
- 📝 **Reproducible**: Auto-generated installation scripts and environment exports
- 🔍 **Error Analysis**: Built-in error reporting and package verification
- ⚙️ **Flexible**: YAML or bash recipe-based configuration

## Quick Links

- [Installation Guide](installation.md) - Get started with COBLE
- [Quick Start](quickstart.md) - Create your first environment
- [Docker Usage](docker.md) - Use pre-built Docker images
- [Singularity Usage](singularity.md) - Deploy in secure environments
- [Command Reference](cli-reference.md) - Full CLI documentation

## Available Images

All COBLE environments are available as Docker images on DockerHub:

- `icrsc/coble:452` - Full R 4.5.2 environment
- `icrsc/coble:mini-452` - Minimal R 4.5.2 environment
- `icrsc/coble:full-452` - Complete R 4.5.2 with extended packages

See the [Docker](docker.md) and [Singularity](singularity.md) pages for usage details.

## How It Works

1. **Define** your environment using YAML or bash recipes
2. **Build** conda environments with automated package installation
3. **Export** reproducible environment specifications
4. **Deploy** via Docker or Singularity containers
5. **Verify** with built-in error checking and package reports

## Support

For issues, questions, or contributions, visit the [GitLab repository](https://gitlab.com/icr-rse/apps/coble).
