#!/usr/bin/env bash

BASE=$1     # e.g. utils or icrs
NAME=$2     # e.g. carbine or sylver
    
echo "Running ${BASE} ${NAME} test"    
RECIPE="recipes/${BASE}/${NAME}/${NAME}.cbl"
VALIDATE="recipes/${BASE}/${NAME}/validate/validate.sh"
VALFOLDER="recipes/${BASE}/${NAME}/validate/"
ENV="${NAME}x"
echo "Copying recipe from ${RECIPE} to tests/github/logs/${NAME}.cbl" >&2

LOG="tests/github/logs/log_${NAME}_conda.log"
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
    --containers docker    
    2>&1 | tee -a "$LOG"

exit ${PIPESTATUS[0]}

