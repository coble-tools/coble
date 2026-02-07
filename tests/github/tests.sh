#!/usr/bin/env bash

# Test an old R version
echo "Old small"
code/coble build --recipe tests/fixtures/small.cbl \
--validate tests/fixtures/validate.sh \
--env old --rebuild \
2>&1 | tee -a tests/github/log_small_test.log


# Test a small docker
#echo "Old test dicker"
#code/coble build --recipe tests/fixtures/old.cbl \
#--validate tests/fixtures/validate.sh \
#--env old --containers docker \
#2>&1 | tee -a tests/github/log_old_docker.log


