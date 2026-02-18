#!/usr/bin/env bash

BASE=$1     # e.g. utils or icrs
NAME=$2     # e.g. carbine or sylver
    
echo "Running ${BASE} ${NAME} docker test"    
RECIPE="recipes/${BASE}/${NAME}/${NAME}.cbl"
VALIDATE="recipes/${BASE}/${NAME}/validate/validate.sh"
VALFOLDER="recipes/${BASE}/${NAME}/validate/"
ENV="${NAME}"
# make ENV lower case
ENV=$(echo "$ENV" | tr '[:upper:]' '[:lower:]') 

LOG="logs/log_${NAME}.log"
# reset log
> "$LOG"

echo $pwd

echo "Running coble build for ${NAME} with recipe ${RECIPE} and validation script ${VALIDATE}"

echo "Running coble build for ${NAME} with recipe ${RECIPE} and validation script ${VALIDATE}" >&2

# run coble
code/coble build \
    --recipe "$RECIPE" \
    --validate "$VALIDATE" \
    --val-folder "$VALFOLDER" \
    --env "$ENV" \
    --containers docker,singularity \
    2>&1 | tee -a "$LOG"

exit ${PIPESTATUS[0]}

