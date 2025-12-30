# Writing Recipes for COBLE

COBLE recipes are simple bash scripts that define the steps to build your environment. You can also use any valid bash command in a recipe, giving you full flexibility to customize your build process. The format is based on yaml and assigning the `cbl` extension a yaml association fro colour formatting makes sense, but differs from yaml in the multiplicity so the name is different. Specifically, becuase the recipe is sequential, the same section can be repeated. The yaml like headers are commands to change package manager. Yaml itself is not used as the utility is pure bash.

## Recipe generation

- To generate a starter recipe, run:

   ```
   coble recipe --input tst.cbl --flavour ???
   ```
   This will create a recipe cbl input file you can edit.

- There are five recipe flavours, selectable with `--flavour`:
   - `basic` (default)  
   - `bioinf` (very complex)  
   - `fix` (tutorial on fixing)  
   - `sylver` (publication tutorial)  
   - `versions` (shows specifying versions)  
   - `bash` (pure bash example)  

You can activate a flavour by passing `--flavour <type>` to the recipe command.

---  