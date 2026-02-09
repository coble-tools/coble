#!/usr/bin/env bash

BLOCK=$1


if [[ "$BLOCK" == "fail" ]]; then

    echo "Running test designed to fail"
    > tests/github/log_fail_test.log
    code/coble build --recipe tests/fixtures/fail.cbl \
    --validate tests/fixtures/validate.sh \
    --env failx --rebuild \
    2>&1 | tee -a tests/github/logs/log_fail_test.log
    exit ${PIPESTATUS[0]} 
elif [[ "$BLOCK" == "small" ]]; then

    echo "Running small test"
    > tests/github/log_small_test.log
    code/coble build --recipe tests/fixtures/small.cbl \
    --validate tests/fixtures/validate.sh \
    --env smallx --rebuild \
    2>&1 | tee -a tests/github/logs/log_small_test.log
    exit ${PIPESTATUS[0]} 
elif [[ "$BLOCK" == "docker" ]]; then

    echo "Running docker test"
    > tests/github/log_old_docker.log
    code/coble build --recipe tests/fixtures/old.cbl \
    --validate tests/fixtures/validate.sh \
    --env oldx --containers docker \
    2>&1 | tee -a tests/github/logs/log_old_docker.log
    exit ${PIPESTATUS[0]} 

    echo "Unknown block: $BLOCK"
    exit 1
fi