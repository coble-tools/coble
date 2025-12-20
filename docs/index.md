# COBLE Workflow Overview

This page describes the basic workflow for using the COBLE environment creation tool.

## Basic Command

```
coble create --input my.yml --env my-env --outdir tmp-out
```

## Workflow Steps

1. **Find Block Resolution**
   - The tool first processes any packages listed in the `find:` block of your YAML file.
   - You will be prompted to review and confirm these packages before proceeding.
   - The YAML file is updated in place based on your input.

2. **Recipe Generation**
   - After confirmation (or if no find required), COBLE generates a recipe file (a bash script) from your YAML in the outdir.


3. **Recipe Execution**
    - No further prompting, the tool then executes the generated recipe script to create the environment.
    - By default, the process will exit immediately if any errors are encountered, allowing you to correct issues and re-run as needed.
    - You can override this behavior and continue on errors by passing the `--skip-errors` flag.

---

## Further Information

- The environment (`--env`) can be either a name or a folder path. COBLE will automatically use `--name` or `--prefix` as appropriate.
- If you specify more than one R or more than one Python version in the language block, COBLE will complain and refuse to continue. Otherwise, it will create a special language block in the YAML.
- To generate a starter template, run:

   ```
   coble template --input tst.yml
   ```
   This will create a template YAML file you can edit.

- There are four template flavours, selectable with `--flavour`:
   - `mixed` (default)
   - `R`
   - `python`
   - `find`

You can activate a flavour by passing `--flavour <type>` to the template command.

---
