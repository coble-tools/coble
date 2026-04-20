# Development Guide

There is a rev recipe with coble which you can install locally:
```bash
code/coble build --recipe recipes/icr-dev/icr-dev.cbl --env DEV --rebuild
```

## Testing
```bash
# all the tests
pytest tests/github
# a specific one
pytest tests/github/test_circle.py
```