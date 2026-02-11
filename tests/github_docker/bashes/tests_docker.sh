#!/usr/bin/env bash

BASE=$1     # e.g. utils or icrs
NAME=$2     # e.g. carbine or sylver
    
echo "Running ${BASE} ${NAME} test"    
RECIPE="recipes/${BASE}/${NAME}/${NAME}.cbl"
VALIDATE="recipes/${BASE}/${NAME}/validate/validate.sh"
VALFOLDER="recipes/${BASE}/${NAME}/validate/"
ENV="${NAME}"

LOG="tests/github_docker/logs/log_${NAME}_conda.log"
# reset log
> "$LOG"

# For the dockers the recipe is used directly from the recipe area as it is copied in anyway

echo "Running coble build for ${NAME} with recipe ${RECIPE} and validation script ${VALIDATE}" >&2

echo "Running coble docker build for ${NAME} with recipe ${RECIPE} and validation script ${VALIDATE}" >> "$LOG"

echo "" >> "$LOG"


# run coble
echo "code/coble build \\
     --recipe \"$RECIPE\" \\
     --validate \"$VALIDATE\" \\
     --val-folder \"$VALFOLDER\" \\
     --env \"$ENV\" \\
     --containers docker" >> "$LOG"
        
# run coble
code/coble build \
    --recipe "$RECIPE" \
    --validate "$VALIDATE" \
    --val-folder "$VALFOLDER" \
    --env "$ENV" \
    --containers docker
    2>&1 | tee -a "$LOG"

exit ${PIPESTATUS[0]}

