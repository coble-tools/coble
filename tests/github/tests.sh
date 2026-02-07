#!/usr/bin/env bash

BLOCK=$1


if [[ "$BLOCK" == "small" ]]; then

    echo "Running small test"
    code/coble build --recipe tests/fixtures/small.cbl \
    --validate tests/fixtures/validate.sh \
    --env old --rebuild \
    2>&1 | tee -a tests/github/log_small_test.log

elif [[ "$BLOCK" == "docker" ]]; then

    echo "Running docker test"
    code/coble build --recipe tests/fixtures/old.cbl \
    --validate tests/fixtures/validate.sh \
    --env old --containers docker \
    2>&1 | tee -a tests/github/log_old_docker.log

else

    echo "Unknown block: $BLOCK"
    exit 1
fi
