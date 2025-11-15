# Developer Notes

Internal development notes and workflows for COBLE maintainers.

## Development Environment Setup

### Prerequisites

- Bash shell
- Conda/Miniconda
- Docker
- Git

### Local Development

```bash
git clone https://gitlab.com/icr-rse/apps/coble.git
cd coble
```

## Project Structure

```
coble/
├── bin/                    # Executable scripts
│   ├── coble-bash.sh      # Main bash entry point
│   ├── coble-slurm.sh     # SLURM job wrapper
│   └── conda-step-*.sh    # Individual step scripts
├── config/                 # Environment configurations
│   ├── coble-*.yml        # Standard configurations
│   └── *.txt              # Recipe files
├── docker/                 # Docker build files
│   ├── 452.docker         # Classic R 4.5.2
│   └── 452.mini.docker    # Multi-variant build
├── docs/                   # Documentation
├── results/               # Build outputs (gitignored)
├── envs/                  # Conda environments (gitignored)
├── pkgs/                  # Package cache (gitignored)
└── logs/                  # Build logs (gitignored)
```

## Development Workflow

### Testing Changes Locally

1. Modify scripts in `bin/`
2. Test with a minimal config:

```bash
bin/coble-bash.sh \
  --steps conda:create:export \
  --input ./config/coble-mini.yml \
  --results ./results/test \
  --r-version 4.5.2 \
  --python-version 3.14.0 \
  --env ./envs/test \
  --pkg ./pkgs/test
```

### Testing Docker Builds

```bash
# Test mini build
docker build -f docker/452.mini.docker --build-arg BUILD_TAG=mini -t test-coble:mini .

# Test classic build
docker build -f docker/452.docker -t test-coble:452 .
```

### CI/CD Pipeline

The GitLab CI pipeline automatically:

1. Builds all Docker images on push to `main`/`master`
2. Tags with commit SHA for traceability
3. Pushes to DockerHub

See `.gitlab-ci.yml` for details.

## Additional Development Notes

More detailed development notes are available in the repository under `docs/dev-notes/`:

- Manual build process
- Nightly build configuration
- R 4.5.2 fixes and troubleshooting

## Adding New Environments

### 1. Create Configuration File

Create `config/coble-newenv.yml`:

```yaml
name: newenv
channels:
  - conda-forge
  - bioconda
dependencies:
  - python=3.14.0
  - r-base=4.5.2
  # ... more packages
```

### 2. Test Locally

```bash
bin/coble-bash.sh \
  --steps conda:create:export \
  --input ./config/coble-newenv.yml \
  --results ./results/newenv \
  --r-version 4.5.2 \
  --python-version 3.14.0 \
  --env ./envs/newenv \
  --pkg ./pkgs/newenv
```

### 3. Create Dockerfile

Add to `docker/` or modify existing with build args.

### 4. Update CI Pipeline

Add new job to `.gitlab-ci.yml`:

```yaml
build-newenv:
  stage: build
  image: docker:24-dind
  services:
    - docker:24-dind
  before_script:
    - echo "$DOCKER_HUB_TOKEN" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin
  script:
    - docker build -f docker/newenv.docker -t ${IMAGE_REPO}:newenv .
    - docker push ${IMAGE_REPO}:newenv
  after_script:
    - docker logout
  only:
    - main
```

### 5. Document

Update documentation:
- Add to available images list
- Update README
- Add to this MkDocs site

## Code Style

### Bash Scripts

- Use 4-space indentation
- Quote variables: `"$variable"`
- Check exit codes: `if [ $? -ne 0 ]; then`
- Add comments for complex logic

### YAML Files

- Use 2-space indentation
- Keep alphabetical order where possible
- Pin critical package versions

## Testing Checklist

Before merging changes:

- [ ] Local bash script tests pass
- [ ] Docker builds complete successfully
- [ ] Singularity conversion works
- [ ] Documentation updated
- [ ] CI pipeline passes
- [ ] No credentials in code

## Release Process

1. Update version/changelog (if applicable)
2. Merge to `main`
3. CI automatically builds and pushes images
4. Tag release in GitLab
5. Update documentation if needed

## Troubleshooting Development Issues

### Docker Build Fails

Check logs:
```bash
docker build -f docker/452.docker -t test:latest . 2>&1 | tee build.log
```

### Conda Solve Takes Forever

Use mamba or smaller test sets first.

### Permission Issues

Ensure scripts are executable:
```bash
chmod +x bin/*.sh
```

## Contributing

See project README for contribution guidelines.

## Contact

RSE Team at ICR - see GitLab project page for contact information.
