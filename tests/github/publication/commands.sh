#!/usr/bin/env bash

# To run this script:
#$ tests/github/publication/commands.sh

this_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

LOG="$this_dir/log.txt"
# reset log
> "$LOG"

choose_steps=1,2,3,4,5,*,7,8
# A simple filecheck for correctness
incorrect=0

# Delete all files we are going to create
rm -rf "${this_dir}/codex_export.cbl"
rm -rf "${this_dir}/codex_export_export.cbl"
rm -rf "${this_dir}/basic.cbl"
rm -rf "${this_dir}/codex-export.cbl"
rm -rf "${this_dir}/codex_dependencies.txt"
rm -rf "${this_dir}/found.cbl"
rm -rf "${this_dir}/stjc_export.cbl"
rm -rf "${this_dir}/cbl-codex.tar"
rm -rf "${this_dir}/cbl-codex.sif"

# if 1 in steps
if [[ $choose_steps == *"1"* ]]; then
    echo "1. Basic coble command" | tee -a "$LOG"
    code/coble build --recipe "${this_dir}/codex.cbl" --env codex --rebuild | tee -a "$LOG"

    if [[ -f "${this_dir}/codex_export.cbl" ]]; then
        echo "Exported recipe file found: ${this_dir}/codex_export.cbl" | tee -a "$LOG"
    else
        echo "Error: Exported recipe file not found: ${this_dir}/codex_export.cbl" | tee -a "$LOG"
        incorrect=$((incorrect + 1))
    fi
fi

if [[ $choose_steps == *"2"* ]]; then
    echo "2. Mirrored coble command" | tee -a "$LOG"
    code/coble build --recipe "${this_dir}/codex_export.cbl" --env codex-mirror --rebuild | tee -a "$LOG"

    if [[ -f "${this_dir}/codex_export_export.cbl" ]]; then
        echo "Exported recipe file found: ${this_dir}/codex_export_export.cbl" | tee -a "$LOG"
    else
        echo "Error: Exported recipe file not found: ${this_dir}/codex_export_export.cbl" | tee -a "$LOG"
        incorrect=$((incorrect + 1))
    fi
fi

if [[ $choose_steps == *"3"* ]]; then
    echo "3. Debug and validation" | tee -a "$LOG"
    rm -rf "${this_dir}/validate_logs"
    code/coble build \
      --recipe codex.cbl \
      --env codex \
      --rebuild \
      --validate validate.sh \
      --val-folder validate \
      --skip-errors | tee -a "$LOG"

    if [[ -f "${this_dir}/codex_export.cbl" ]]; then
        echo "Exported recipe file found: ${this_dir}/codex_export.cbl" | tee -a "$LOG"
    else
        echo "Error: Exported recipe file not found: ${this_dir}/codex_export.cbl" | tee -a "$LOG"
        incorrect=$((incorrect + 1))
    fi
fi

if [[ $choose_steps == *"4"* ]]; then
    echo "4. Templates" | tee -a "$LOG"
    code/coble template \
      --recipe basic.cbl \
      --flavour basic | tee -a "$LOG"

    if [[ -f "${this_dir}/basic.cbl" ]]; then
        echo "Exported recipe file found: ${this_dir}/basic.cbl" | tee -a "$LOG"
    else
        echo "Error: Exported recipe file not found: ${this_dir}/basic.cbl" | tee -a "$LOG"
        incorrect=$((incorrect + 1))
    fi
fi

if [[ $choose_steps == *"5"* ]]; then
    echo "5. export" | tee -a "$LOG"
    code/coble export --export "${this_dir}/codex-export.cbl" --env codex | tee -a "$LOG"

    if [[ -f "${this_dir}/codex-export.cbl" ]]; then
        echo "Exported recipe file found: ${this_dir}/codex-export.cbl" | tee -a "$LOG"
    else
        echo "Error: Exported recipe file not found: ${this_dir}/codex-export.cbl" | tee -a "$LOG"
        incorrect=$((incorrect + 1))
    fi

fi

if [[ $choose_steps == *"6"* ]]; then
    echo "6. network" | tee -a "$LOG"
    code/coble network --export "${this_dir}/codex-export.cbl" --env codex | tee -a "$LOG"

    if [[ -f "${this_dir}/codex_dependencies.cbl" ]]; then
        echo "Exported recipe file found: ${this_dir}/codex_dependencies.cbl" | tee -a "$LOG"
    else
        echo "Error: Exported recipe file not found: ${this_dir}/codex_dependencies.cbl" | tee -a "$LOG"
        incorrect=$((incorrect + 1))
    fi
fi

if [[ $choose_steps == *"7"* ]]; then
    echo "7. find" | tee -a "$LOG"
    rm -rf "${this_dir}/found.cbl"
    cp "${this_dir}/find.cbl" "${this_dir}/found.cbl"
    code/coble build --recipe "${this_dir}/found.cbl" --env found | tee -a "$LOG"

    if [[ -f "${this_dir}/found.cbl" ]]; then
        echo "Exported recipe file found: ${this_dir}/found.cbl" | tee -a "$LOG"
    else
        echo "Error: Exported recipe file not found: ${this_dir}/found.cbl" | tee -a "$LOG"
        incorrect=$((incorrect + 1))
    fi
fi

if [[ $choose_steps == *"8"* ]]; then
    echo "8. StJoinCount" | tee -a "$LOG"
    code/coble build --recipe "${this_dir}/stjc.cbl" --env stjc | tee -a "$LOG"

    if [[ -f "${this_dir}/stjc_export.cbl" ]]; then
        echo "Exported recipe file found: ${this_dir}/stjc_export.cbl" | tee -a "$LOG"
    else
        echo "Error: Exported recipe file not found: ${this_dir}/stjc_export.cbl" | tee -a "$LOG"
        incorrect=$((incorrect + 1))
    fi
fi

if [[ $choose_steps == *"9"* ]]; then
    echo "9 Validation in containers" | tee -a "$LOG"
    coble build \
      --recipe "${this_dir}/codex.cbl" \
      --env codex \
      --containers docker,singularity \
      --validate "${this_dir}/validate/validate.sh" \
      --val-folder "${this_dir}/validate" | tee -a "$LOG"

    if [[ -f "${this_dir}/cbl-codex.tar" ]]; then
        echo "Docker: ${this_dir}/cbl-codex.tar" | tee -a "$LOG"
    else
        echo "Error: Docker not found: ${this_dir}/cbl-codex.tar" | tee -a "$LOG"
        incorrect=$((incorrect + 1))
    fi

    if [[ -f "${this_dir}/cbl-codex.sif" ]]; then
        echo "Singularity: ${this_dir}/cbl-codex.sif" | tee -a "$LOG"
    else
        echo "Error: Singularity not found: ${this_dir}/cbl-codex.sif" | tee -a "$LOG"
        incorrect=$((incorrect + 1))
    fi
fi

if [[ $incorrect -gt 0 ]]; then
    echo "There were $incorrect errors detected in the commands test." | tee -a "$LOG"
else
    echo "All commands tests passed successfully!" | tee -a "$LOG"
fi

# clear up files we don't need
rm -rf "${this_dir}/codex_export.cbl.bak"
rm -rf "${this_dir}/codex_export_summary.txt"
rm -rf "${this_dir}/codex_export.cbl.tmp"
rm -rf "${this_dir}/codex_export.delta"
rm -rf "${this_dir}/codex_export.done"
rm -rf "${this_dir}/codex_export.err"
rm -rf "${this_dir}/codex_export.log"
rm -rf "${this_dir}/codex_export.sh"
rm -rf "${this_dir}/codex_export.sh.bak"

rm -rf "${this_dir}/codex.cbl.bak"
rm -rf "${this_dir}/codex_summary.txt"
rm -rf "${this_dir}/codex.cbl.tmp"
rm -rf "${this_dir}/codex.delta"
rm -rf "${this_dir}/codex.done"
rm -rf "${this_dir}/codex.err"
rm -rf "${this_dir}/codex.log"
rm -rf "${this_dir}/codex.sh"
rm -rf "${this_dir}/codex.sh.bak"

rm -rf "${this_dir}/find.cbl.bak"
rm -rf "${this_dir}/find_summary.txt"
rm -rf "${this_dir}/find.cbl.tmp"
rm -rf "${this_dir}/find.delta"
rm -rf "${this_dir}/find.done"
rm -rf "${this_dir}/find.err"
rm -rf "${this_dir}/find.log"
rm -rf "${this_dir}/find.sh"
rm -rf "${this_dir}/find.sh.bak"

rm -rf "${this_dir}/stjc.cbl.bak"
rm -rf "${this_dir}/stjc_summary.txt"
rm -rf "${this_dir}/stjc.cbl.tmp"
rm -rf "${this_dir}/stjc.delta"
rm -rf "${this_dir}/stjc.done"
rm -rf "${this_dir}/stjc.err"
rm -rf "${this_dir}/stjc.log"
rm -rf "${this_dir}/stjc.sh"
rm -rf "${this_dir}/stjc.sh.bak"

exit ${PIPESTATUS[0]}
