#!/usr/bin/env bash

BLOCK=$1


if [[ "$BLOCK" == "fail" ]]; then

    echo "Running test designed to fail"
    > tests/github/log_fail_test.log
    code/coble build --recipe tests/fixtures/fail.cbl \
    --validate tests/fixtures/validate.sh \
    --env failx --rebuild \
    2>&1 | tee -a tests/github/log_fail_test.log
    exit ${PIPESTATUS[0]} 
elif [[ "$BLOCK" == "small" ]]; then

    echo "Running small test"
    > tests/github/log_small_test.log
    code/coble build --recipe tests/fixtures/small.cbl \
    --validate tests/fixtures/validate.sh \
    --env smallx --rebuild \
    2>&1 | tee -a tests/github/log_small_test.log
    exit ${PIPESTATUS[0]} 
elif [[ "$BLOCK" == "docker" ]]; then

    echo "Running docker test"
    > tests/github/log_old_docker.log
    code/coble build --recipe tests/fixtures/old.cbl \
    --validate tests/fixtures/validate.sh \
    --env oldx --containers docker \
    2>&1 | tee -a tests/github/log_old_docker.log
    exit ${PIPESTATUS[0]} 
# RECIPES

elif [[ "$BLOCK" == "carbine" ]]; then

    echo "Running carbine test"
    > tests/github/log_carbine_conda.log
    cp recipes/icr/carbine/carbine.cbl tests/github/carbine.cbl
    code/coble build --recipe tests/github/carbine.cbl \
    --validate recipes/icr/carbine/validate/validate.sh \
    --val-folder recipes/icr/carbine/validate/ \
    --env carbinex --containers conda \
    2>&1 | tee -a tests/github/log_carbine_conda.log
    exit ${PIPESTATUS[0]} 

elif [[ "$BLOCK" == "sylver" ]]; then

    echo "Running sylver test"
    #> tests/github/log_sylver_conda.log
    cp recipes/icr/sylver/sylver.cbl tests/github/sylver.cbl
    code/coble build --recipe tests/github/sylver.cbl \
    --validate recipes/icr/sylver/validate/validate.sh \
    --env sylverx --containers conda \
    2>&1 | tee -a tests/github/log_sylver_conda.log
    exit ${PIPESTATUS[0]} 

elif [[ "$BLOCK" == "deseq2" ]]; then

    echo "Running deseq2 test"
    #> tests/github/log_deseq2_conda.log
    cp recipes/papers/DESeq2/DESeq2.cbl tests/github/DESeq2.cbl
    code/coble build --recipe tests/github/DESeq2.cbl \
    --validate recipes/papers/DESeq2/validate/validate.sh \
    --val-folder recipes/papers/DESeq2/validate/ \
    --env deseq2x --containers conda \
    2>&1 | tee -a tests/github/log_deseq2_conda.log
    exit ${PIPESTATUS[0]} 

else

    echo "Unknown block: $BLOCK"
    exit 1
fi
