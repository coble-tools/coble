#!/bin/bash

code/coble.sh recreate --input tests/small.yml --env small --outdir tests/output/small
code/coble.sh recreate --input tests/sylver.yml --env sylver --outdir tests/output/sylver --debug
code/coble.sh recreate --input tests/latest.yml --env latest --outdir tests/output/latest