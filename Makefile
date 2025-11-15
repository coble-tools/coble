.PHONY: help docs docs-serve docs-build docs-deploy docs-setup clean

VENV := .venv-docs
PYTHON := $(VENV)/bin/python
MKDOCS := $(VENV)/bin/mkdocs

help:
	@echo "COBLE Documentation Commands"
	@echo ""
	@echo "  make docs-setup   - Set up virtual environment and install dependencies"
	@echo "  make docs         - Serve documentation locally (auto-reload)"
	@echo "  make docs-serve   - Same as 'make docs'"
	@echo "  make docs-build   - Build documentation to site/"
	@echo "  make docs-deploy  - Deploy to GitLab Pages (CI only)"
	@echo "  make clean        - Remove built documentation and venv"
	@echo ""
	@echo "First time setup: make docs-setup"

docs-setup:
	@echo "Setting up documentation environment..."
	python3 -m venv $(VENV)
	$(VENV)/bin/pip install -r docs/requirements.txt
	@echo "Setup complete! Run 'make docs' to serve locally."

docs: docs-serve

docs-serve: $(MKDOCS)
	@echo "Starting MkDocs development server..."
	@echo "Documentation will be available at http://127.0.0.1:8000"
	@echo "Press Ctrl+C to stop"
	$(MKDOCS) serve

docs-build: $(MKDOCS)
	@echo "Building documentation..."
	$(MKDOCS) build
	@echo "Documentation built to site/"

docs-deploy: $(MKDOCS)
	@echo "Deploying to GitLab Pages..."
	$(MKDOCS) build --strict
	@echo "Documentation ready for deployment"

clean:
	@echo "Cleaning built documentation and virtual environment..."
	rm -rf site/ $(VENV)
	@echo "Done"

$(MKDOCS):
	@echo "Virtual environment not found. Run 'make docs-setup' first."
	@exit 1
