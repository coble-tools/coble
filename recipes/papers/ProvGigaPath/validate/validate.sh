#!/usr/bin/env bash

#!/usr/bin/env bash
if [ -n "$APPTAINER_CONTAINER" ] || [ -n "$SINGULARITY_CONTAINER" ]; then
    export LD_LIBRARY_PATH=/.singularity.d/libs:$LD_LIBRARY_PATH
    echo "Singularity container detected - LD_LIBRARY_PATH set for GPU support"
    echo "Note: run 'export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH' if using Python directly"
fi
python ${CONDA_PREFIX}/bin/validate.py

PYTHON_EXIT=$?

echo "--------------------------"
if [ $PYTHON_EXIT -ne 0 ]; then
    echo "Validation FAILED (exit code $PYTHON_EXIT)"
    exit $PYTHON_EXIT
else
    echo "Validation complete!"
fi
