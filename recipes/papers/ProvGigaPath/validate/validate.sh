#!/usr/bin/env bash
python ${CONDA_PREFIX}/bin/validate.py

PYTHON_EXIT=$?

echo "--------------------------"
if [ $PYTHON_EXIT -ne 0 ]; then
    echo "Validation FAILED (exit code $PYTHON_EXIT)"
    exit $PYTHON_EXIT
else
    echo "Validation complete!"
fi
