#!/usr/bin/env bash

BLOCK=$1


run_block () {
    local BASE="$1"      # e.g. icr/utils or icr/recipes
    local NAME="$2"      # e.g. carbine or sylver

    echo "Running ${BASE} ${NAME} test"    
    
    local RECIPE="${BASE}/${NAME}/${NAME}.cbl"
    local VALIDATE="${BASE}/${NAME}/validate/validate.sh"
    local VALFOLDER="${BASE}/${NAME}/validate/"
    local LOG="tests/github/log_${NAME}_conda.log"
    local ENV="${NAME}x"

    # reset log
    > "$LOG"

    # copy recipe into test area
    cp "$RECIPE" "tests/github/${NAME}.cbl"

    echo "Running coble build for ${NAME} with recipe ${RECIPE} and validation script ${VALIDATE}" >&2
    
    
    # run coble
    code/coble build \
        --recipe "tests/github/${NAME}.cbl" \
        --validate "$VALIDATE" \
        --val-folder "$VALFOLDER" \
        --env "$ENV" \
        --containers conda \
        --rebuild \
        --clean \
        2>&1 | tee -a "$LOG"

    exit ${PIPESTATUS[0]}
}




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

    run_block "recipes/icr" "carbine"

elif [[ "$BLOCK" == "sylver" ]]; then

    run_block "recipes/icr" "sylver"

elif [[ "$BLOCK" == "deseq2" ]]; then

    run_block "recipes/icr" "deseq2"


elif [[ "$BLOCK" == "r-452" ]]; then

    run_block "recipes/utils" "r-452"

elif [[ "$BLOCK" == "r-362" ]]; then

    run_block "recipes/utils" "r-362"

elif [[ "$BLOCK" == "r-360" ]]; then

    run_block "recipes/utils" "r-360"

else

    echo "Unknown block: $BLOCK"
    exit 1
fi
