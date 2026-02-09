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
    cp "$RECIPE" "tests/github/logs/${NAME}.cbl"
    
    echo "Running coble build for ${NAME} with recipe ${RECIPE} and validation script ${VALIDATE}" >&2
    
    
    # run coble
    code/coble build \
        --recipe "tests/github/logs/${NAME}.cbl" \
        --validate "$VALIDATE" \
        --val-folder "$VALFOLDER" \
        --env "$ENV" \
        --containers conda \
        --rebuild \
        --clean \
        2>&1 | tee -a "$LOG"

    exit ${PIPESTATUS[0]}
}

if [[ "$BLOCK" == "deseq2" ]]; then

    run_block "recipes/papers" "DESeq2"

else

    echo "Unknown block: $BLOCK"
    exit 1
fi