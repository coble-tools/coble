#!/usr/bin/env bash

# COBLE - COnda BuiLdEr
# Build and manage conda environments with support for conda, R, and pip packages
#
# Initialize variables
COBLE_SCRIPT_VERSION="0.1.0"  # Increment manually when releasing a new script version

INPUT_RECIPE=""
RESULTS_DIR=""
ENV_NAME=""
SKIP_ERRORS=false
OVERRIDE_ENVS=false
KEEP_LOGS=false

# Set default R and Python versions
COBLE_R_VERSION="4.5.2"
COBLE_PYTHON_VERSION="3.14.0"

# Check for help flag first
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] || [[ "$*" == *"--help"* ]] || [[ "$*" == *"-h"* ]]; then
  echo "Usage: coble-bash.sh [OPTIONS]"
  echo ""
  echo "COBLE - COnda BuiLdEr: Build and manage conda environments from the RSE team at the ICR"
  echo ""
  echo "(c) 2025 Rachel Alcraft"
  echo "Options:"        
  echo "  --input FILE            Input recipe(bash) file with package specifications"
  echo "  --results DIR           Directory to store results (required)"          
  echo "  --env NAME              Name of the conda environment to create/use (required, as a prefix path)"  
  echo "  --r-version VERSION     R version to use (default: $COBLE_R_VERSION)"
  echo "  --python-version VERSION Python version to use (default: $COBLE_PYTHON_VERSION)"
  echo "  --skip-errors           Continue processing even if errors are detected"
  echo "  --override-envs         Override R_LIBS_USER and CONDA_PKGS_DIRS to isolate environments"
  exit 0
fi

# Parse arguments

while [[ $# -gt 0 ]]; do
  case $1 in  
    --input)
      INPUT_RECIPE="$2"
      shift 2
      ;;
    --results)
      RESULTS_DIR="$2"
      shift 2
      ;;    
    --env)
      ENV_NAME="$2"
      shift 2
      ;;
    --r-version)
      COBLE_R_VERSION="$2"
      shift 2
      ;;
    --python-version)
      COBLE_PYTHON_VERSION="$2"
      shift 2
      ;;
    --skip-errors)
      SKIP_ERRORS=true
      shift 1
      ;;
    --override-envs)
      OVERRIDE_ENVS=true
      shift 1
      ;;
    --keep-logs)
      KEEP_LOGS=true
      shift 1
      ;;
    --version)
      echo "coble-bash.sh version: ${COBLE_SCRIPT_VERSION}"; exit 0 ;;
    -h|--help)
      # Already handled above, this is just for completeness
      exit 0
      ;;    
    *)
      echo "Unknown option: $1"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

# Export R and Python version variables for use in recipes
export COBLE_R_VERSION
export COBLE_PYTHON_VERSION

echo "CMD: COBLE_R_VERSION: ${COBLE_R_VERSION}"
echo "CMD: COBLE_PYTHON_VERSION: ${COBLE_PYTHON_VERSION}"

# Validate required inputs
if [ -z "$RESULTS_DIR" ]; then
  echo "Error: --results directory is required"
  exit 1
fi
if [ -z "$INPUT_RECIPE" ]; then
  echo "Error: --input recipe file is required"
  exit 1
fi
if [ -z "$ENV_NAME" ]; then
  echo "Error: --env environment name is required"
  exit 1
fi
echo "DEBUG: ENV_NAME='$ENV_NAME'"
export CONDA_COBLE_ENV="$ENV_NAME"
if [ "$OVERRIDE_ENVS" = true ]; then
  export R_LIBS_USER="${ENV_NAME}_rlibs"
  echo "Setting env variable R_LIBS_USER=$R_LIBS_USER"
  mkdir -p "$R_LIBS_USER"
  echo "  Created R_LIBS_USER: $R_LIBS_USER"
fi

# Make results directory if it doesn't exist
mkdir -p $RESULTS_DIR
# Divert the output files to files in the results directory
OUTPUT_FILE="$RESULTS_DIR/coble-stdout.log"
ERROR_FILE="$RESULTS_DIR/coble-stderr.log"
# I want them to be cleaned each time not appended
# but only if it says KEEP_LOGS
if [ "$KEEP_LOGS" = true ]; then
  if [ $(wc -l < "$ERROR_FILE") -gt 1 ]; then
    cp "$ERROR_FILE" "$ERROR_FILE.$(date +%s).log"
  fi
  if [ $(wc -l < "$OUTPUT_FILE") -gt 1 ]; then
    cp "$OUTPUT_FILE" "$OUTPUT_FILE.$(date +%s).log"
  fi
fi
> "$OUTPUT_FILE"
> "$ERROR_FILE"
exec > >(tee -a "$OUTPUT_FILE") 2> >(tee -a "$ERROR_FILE" >&2)
echo "Redirecting stdout to $OUTPUT_FILE"
echo "Redirecting stderr to $ERROR_FILE"

echo "#################################################"
echo "Recipe coble environment creation script started at $(date)"
echo "#################################################"
echo "CMD: INPUT_RECIPE: ${INPUT_RECIPE}"
echo "CMD: RESULTS_DIR: ${RESULTS_DIR}"
echo "CMD: ENV_NAME: ${ENV_NAME}"
echo "CMD: SKIP_ERRORS: ${SKIP_ERRORS}"
echo "CMD: KEEP_LOGS: ${KEEP_LOGS}"
echo "#################################################"

# Convert a YAML file to a recipe file (key=value pairs)
convert_yaml_to_recipe() {
  local yaml_file="$1"
  local recipe_file="$2"
  local coble_mode="bash"

  # empty the recipe file
  > "$recipe_file"

  # loop through each line of the yaml file and convert to key=value pairs
  while IFS= read -r line; do
    # Skip comments and blank lines
    if [[ "$line" =~ ^# ]] || [[ -z "$line" ]]; then
      continue
    fi
    # remove indentation and recognise if the directive is create:, packages:, conda:, r:, bioc:, pip:
    trimmed_line="${line#"${line%%[![:space:]]*}"}"
    # add the triummed line to the recipe file with appropriate formatting
    if [[ "$trimmed_line" =~ ^create: ]]; then
      coble_mode="create"
    elif [[ "$trimmed_line" =~ ^packages: ]]; then
      coble_mode="packages"
    elif [[ "$trimmed_line" =~ ^conda: ]]; then
      coble_mode="conda"
    elif [[ "$trimmed_line" =~ ^r: ]]; then
      coble_mode="r"
    elif [[ "$trimmed_line" =~ ^bioc: ]]; then
      coble_mode="bioc"
    elif [[ "$trimmed_line" =~ ^pip: ]]; then
      coble_mode="pip"
    elif [[ "$trimmed_line" =~ ^channels: ]]; then
      coble_mode="channels"
    elif [[ "$trimmed_line" =~ ^r-github: ]]; then
      coble_mode="r-github"
    elif [[ "$trimmed_line" =~ ^r-url: ]]; then
      coble_mode="r-url"
    elif [[ "$trimmed_line" =~ ^bash: ]]; then
      coble_mode="bash"
    else
      # it's a package line, determine which section we are in
      # take off the - and any leading spaces
      if [[ "$line" =~ ^[[:space:]]+-[[:space:]]* ]]; then
        package_name=$(echo "$trimmed_line" | sed 's/^-[[:space:]]*//')
        package_name="$(echo "$package_name" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
        if [[ "$coble_mode" == "create" ]]; then
          echo "conda create -y -n $ENV_NAME -c conda-forge r-base=$COBLE_R_VERSION python=$COBLE_PYTHON_VERSION" >> "$recipe_file"
        elif [[ "$coble_mode" == "channels" ]]; then        
          echo "conda config --add channels $package_name" >> "$recipe_file"
        elif [[ "$coble_mode" == "conda" ]]; then
          echo "conda install -y $package_name --no-update-deps" >> "$recipe_file"
        elif [[ "$coble_mode" == "r" ]]; then
          echo "coble@r@$package_name" >> "$recipe_file"
        elif [[ "$coble_mode" == "bioc" ]]; then
          echo "coble@bioc@$package_name" >> "$recipe_file"
        elif [[ "$coble_mode" == "pip" ]]; then
          echo "python -m pip install $package_name" >> "$recipe_file"
        elif [[ "$coble_mode" == "bash" ]]; then
          echo "$package_name" >> "$recipe_file"  
        elif [[ "$coble_mode" == "r-github" ]]; then
          echo "Rscript -e \"devtools::install_github('$package_name')\"" >> "$recipe_file"  
        elif [[ "$coble_mode" == "r-url" ]]; then
          echo "Rscript -e \"devtools::install_url('$package_name', dependencies=FALSE)\"" >> "$recipe_file"
        fi

      fi    
    fi
  done < "$yaml_file"

    
}

if [[ "$INPUT_RECIPE" == *.yaml || "$INPUT_RECIPE" == *.yml ]]; then  
  echo "Converting YAML recipe $INPUT_RECIPE to bash recipe"
  converted_recipe="$RESULTS_DIR/converted-recipe.sh"
  convert_yaml_to_recipe "$INPUT_RECIPE" "$converted_recipe"
  if [ $? -ne 0 ]; then
    echo "Error converting YAML to recipe."
    exit 1
  fi
  INPUT_RECIPE="$converted_recipe"
  echo "Converted recipe saved to $INPUT_RECIPE"
fi

start_time=$(date +%s)
#################################################
source ~/.bashrc
# Initialize conda for bash shell
if [ -f "${CONDA_EXE%/bin/conda}/etc/profile.d/conda.sh" ]; then
    source "${CONDA_EXE%/bin/conda}/etc/profile.d/conda.sh"
elif [ -f "/opt/conda/etc/profile.d/conda.sh" ]; then
    source "/opt/conda/etc/profile.d/conda.sh"
elif [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
    source "$HOME/miniconda3/etc/profile.d/conda.sh"
elif [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
    source "$HOME/anaconda3/etc/profile.d/conda.sh"
fi

#################################################
conda_exe="conda"
echo "Using conda executable: $conda_exe"
echo "Conda version: $($conda_exe --version)"
CONDA_PKGS_DIRS="${ENV_NAME}_pkgs"
if [ "$OVERRIDE_ENVS" = true ]; then
  export CONDA_PKGS_DIRS=$CONDA_PKGS_DIRS
  echo "Setting env variable CONDA_PKGS_DIRS=$CONDA_PKGS_DIRS"
  mkdir -p "$CONDA_PKGS_DIRS"
  echo "  Created CONDA_PKGS_DIRS: $CONDA_PKGS_DIRS"
fi
echo "Current conda configuration:"
conda config --get
conda config --get pkgs_dirs
conda config --show-sources
conda config --show > "$RESULTS_DIR/.condarc_backup"
conda config --show-sources > "$RESULTS_DIR/.conda-config-sources.txt"
#################################################
RECIPE_FILE="$RESULTS_DIR/recipe.sh"
# Check if it exists, if not create it with header
if [ ! -f "$RECIPE_FILE" ]; then
  echo "#!/usr/bin/env bash" > "$RECIPE_FILE"  
  echo "# ==============================================" >> "$RECIPE_FILE"  
  echo "# Generated COBLE recipe script on $(date)" >> "$RECIPE_FILE"  
  echo "# Input recipe file: $INPUT_RECIPE" >> "$RECIPE_FILE"  
  echo "# Conda version: $($conda_exe --version)" >> "$RECIPE_FILE"
  echo "# pwd: $(pwd)" >> "$RECIPE_FILE"
  echo "# ==============================================" >> "$RECIPE_FILE"  
  echo "Created recipe file at $RECIPE_FILE"
else
  echo "# ==============================================" >> "$RECIPE_FILE"  
  echo "# Appending COBLE recipe script on $(date)" >> "$RECIPE_FILE"  
  echo "# Input recipe file: $INPUT_RECIPE" >> "$RECIPE_FILE"  
  echo "# Conda version: $($conda_exe --version)" >> "$RECIPE_FILE"
  echo "# pwd: $(pwd)" >> "$RECIPE_FILE"
  echo "# ==============================================" >> "$RECIPE_FILE"  
  echo "Appended recipe file at $RECIPE_FILE"
fi
echo

DONE_FILE="$RESULTS_DIR/done.txt"
# Check if it exists, if not create it with header
if [ ! -f "$DONE_FILE" ]; then  
  echo "# ==============================================" >> "$DONE_FILE"  
  echo "# Generated COBLE done log on $(date)" > "$DONE_FILE"  
  echo "# Input recipe file: $INPUT_RECIPE" >> "$DONE_FILE"  
  echo "# ==============================================" >> "$DONE_FILE"  
  echo "Created done file at $DONE_FILE"
else  
  echo "# ==============================================" >> "$DONE_FILE"
  echo "# Appending COBLE done log on $(date)" from "$INPUT_RECIPE" >> "$DONE_FILE"    
  echo "Appended done file at $DONE_FILE"
fi
echo

################################################################################
# Function to take the contents of the .condarc and copy it to results so we know exactly
# what channels and settings were used during the build

################################################################################
# Function set for processing either r packages, bioc packages or straight command line
coble_cmd() {
  clean_logs
  local input="$1"  
  echo "Processing command: $input"
  if [[ "$input" == coble@r@* ]]; then
    local package_list="${input#coble@r@}"
    IFS=' ' read -r -a packages <<< "$package_list"
    r_packages="c("
    conda_packages=""
    for package in "${packages[@]}"; do
      # Escape single quotes in package names for R syntax
      safe_package=$(printf "%s" "$package" | sed "s/'/\\\\'/g")
      r_packages+="'$safe_package',"
      conda_packages+=" r-$safe_package"
    done
    # Remove trailing comma for valid R syntax
    r_packages=${r_packages%,}
    r_packages+=")"
    echo "Trying conda install for R package: $conda_packages"
    echo "# conda install -y $conda_packages  --no-update-deps" >> "$RECIPE_FILE"
    echo "# conda install -y $conda_packages  --no-update-deps" >> "$DONE_FILE"
    conda install -y $conda_packages --no-update-deps
    check_for_errors
    if [ $? -eq 0 ]; then
      echo "conda install failed, falling back to R install for: $r_packages"
      clean_logs
      echo "Processing command: $input"
      echo "# Rscript -e \"install.packages($r_packages, repos='https://cloud.r-project.org', force=TRUE, quiet=FALSE)\""
      echo "# Rscript -e \"install.packages($r_packages, repos='https://cloud.r-project.org', force=TRUE, quiet=FALSE)\"" >> "$RECIPE_FILE"
      echo "# Rscript -e \"install.packages($r_packages, repos='https://cloud.r-project.org', force=TRUE, quiet=FALSE)\"" >> "$DONE_FILE"
      Rscript -e "install.packages($r_packages, repos='https://cloud.r-project.org', force=TRUE, quiet=FALSE)"
      check_for_errors
      if [ $? -eq 0 ]; then
        echo "R install also failed for: $r_packages"          
      else
        echo "R install succeeded for: $r_packages"
        echo "Rscript -e install.packages($r_packages, repos='https://cloud.r-project.org', force=TRUE, quiet=FALSE) #$input" >> "$RECIPE_FILE"
      fi
    else
      echo "conda install succeeded for: $conda_packages"
      echo "conda install -y $conda_packages --no-update-deps #$input" >> "$RECIPE_FILE"      
    fi      
  elif [[ "$input" == coble@bioc@* ]]; then
    local package_list="${input#coble@bioc@}"
    IFS=' ' read -r -a packages <<< "$package_list"
    r_packages="c("
    conda_packages=""
    for package in "${packages[@]}"; do
      # Escape single quotes in package names for R syntax
      safe_package=$(printf "%s" "$package" | sed "s/'/\\\\'/g")
      r_packages+="'$safe_package',"
      conda_packages+=" bioconda::bioconductor-$safe_package"
    done
    # Remove trailing comma for valid R syntax
    r_packages=${r_packages%,}
    r_packages+=")"
    echo "Trying conda install for Bioconductor package: $conda_packages --no-update-deps"
    echo "# conda install -y $conda_packages --no-update-deps" >> "$RECIPE_FILE"
    echo "# conda install -y $conda_packages --no-update-deps" >> "$DONE_FILE"
    conda install -y $conda_packages --no-update-deps
    check_for_errors
    if [ $? -eq 0 ]; then
      echo "conda install failed, falling back to BiocManager for: $r_packages"
      clean_logs
      echo "Processing command: $input"
      echo "# Rscript -e \"BiocManager::install($r_packages, ask=FALSE, update=FALSE, force=TRUE)\""
      echo "# Rscript -e \"BiocManager::install($r_packages, ask=FALSE, update=FALSE, force=TRUE)\"" >> "$RECIPE_FILE"
      echo "# Rscript -e \"BiocManager::install($r_packages, ask=FALSE, update=FALSE, force=TRUE)\"" >> "$DONE_FILE"
      Rscript -e "BiocManager::install($r_packages, ask=FALSE, update=FALSE, force=TRUE)"
      check_for_errors
      if [ $? -eq 0 ]; then
        echo "BiocManager install also failed for: $r_packages"                  
      else
        echo "BiocManager install succeeded for: $r_packages"
        echo "Rscript -e BiocManager::install($r_packages, ask=FALSE, update=FALSE, force=TRUE) #$input" >> "$RECIPE_FILE"
      fi
    else
      echo "conda install succeeded for: $conda_packages"
      echo "conda install -y $conda_packages --no-update-deps #$input" >> "$RECIPE_FILE"
    fi      
  else
      echo "Executing command: $input"
      eval "$input"
  fi
}
################################################################################
# Function to check for errors after each line execution
# Returns 0 (true) if errors are detected, 1 (false) if no errors
check_for_errors() {  
  # convert to int if it is blank  
  local found_errors=false
    
  #### ERRORS TO CHECK FOR #########
  # Patterns for log matching
  local stdout_patterns=(
    "is uninstallable because there are no viable options" 
    "does not exist" 
    "Encountered problems while solving" 
    "nothing provides" 
    "please re-install it" 
    "Could not solve for environment specs"
  )  
  local error_patterns=(
    "had non-zero exit status" 
    "exit" 
    "fatal" 
    "EnvironmentNotWritableError"     
    "Rscript: command not found"     
    "is not available for this version of R"
    "EnvironmentLocationNotFound" 
    "CondaValueError" 
    "ERROR: failed to lock directory" 
    "trying to use CRAN without setting a mirror"     
    "API rate limit exceeded" 
    "The channel is not accessible or is invalid" 
    "PackagesNotFoundError" 
    "Killed" 
    "LibMambaUnsatisfiableError" 
    "Error in loadNamespace(x)"
    )
  local done_patterns=(
    "DONE ("   
    "linux-64::" 
    "noarch::"  
    "Successfully installed" 
    "** this is package"
    )
  # Ensure done messages are only reported once
  mapfile -t done_lines < "$DONE_FILE"

  if [ -f "$OUTPUT_FILE" ]; then
    while IFS= read -r log_line; do
      for pattern in "${stdout_patterns[@]}"; do
        if echo "$log_line" | grep -qi "$pattern"; then
          echo "# ERROR: Found '$pattern' in stdout: $log_line" >> "$RECIPE_FILE"
          found_errors=true          
        fi
      done
      for pattern in "${done_patterns[@]}"; do
        if echo "$log_line" | grep -qi "$pattern"; then          
          # change - always output as we have a clean set of logs with each install
          #if [[ ! " ${done_lines[*]} " =~ " $log_line " ]]; then            
            echo "$log_line" >> "$DONE_FILE"                    
          #fi
        fi
      done
    done < "$OUTPUT_FILE"
  fi            
  if [ -f "$ERROR_FILE" ]; then
    while IFS= read -r err_line; do
      for pattern in "${error_patterns[@]}"; do
        if echo "$err_line" | grep -qi "$pattern"; then
          echo "# ERROR: Found '$pattern' in stderr: $err_line" >> "$RECIPE_FILE"
          found_errors=true          
          # if it is a PackagesNotFoundError I want to report the next 2 lines as well
          if [[ "$pattern" == "PackagesNotFoundError"* ]]; then
            read -r next_line1
            echo "# ERROR: $next_line1" >> "$RECIPE_FILE"
            read -r next_line2
            echo "# ERROR: $next_line2" >> "$RECIPE_FILE"
          fi
        fi
      done
      for pattern in "${done_patterns[@]}"; do
        if echo "$err_line" | grep -qi "$pattern"; then          
          # change - always output as we have a clean set of logs with each install
          #if [[ ! " ${done_lines[*]} " =~ " $err_line " ]]; then            
            echo "$err_line" >> "$DONE_FILE"                    
          #fi
        fi
      done
    done < "$ERROR_FILE"
  fi
        
  if [ "$found_errors" = true ]; then
    return 0
  else
    return 1
  fi
}
clean_logs() {
  # clean logs with each install  
  if [ "$KEEP_LOGS" = true ]; then
    cp "$ERROR_FILE" "$ERROR_FILE.$(date +%s).log"
    cp "$OUTPUT_FILE" "$OUTPUT_FILE.$(date +%s).log"
  fi  
  > "$ERROR_FILE"    
  > "$OUTPUT_FILE"    
}
################################################################################
check_if_line_exists() {
  local needle="$1"
  #echo "DEBUG: Checking if line exists in recipe: $needle"
  # Return 1 (false) if no needle provided or recipe file missing
  if [ -z "$needle" ] || [ ! -f "$RECIPE_FILE" ]; then
    return 1
  fi
  found=false  
  # Loop through recipe file to find exact whole-line match (case sensitive)
  while IFS= read -r line; do
    # if coble@ in needle and line==*needle
    if [[ "$needle" == *"coble@"* ]] && [[ "$line" == *"#$needle"* ]]; then
        found=true
        break        
    elif [ "$line" == "$needle" ]; then
        found=true
        break
    fi            
  done < "$RECIPE_FILE"
  if [ "$found" = true ]; then
    return 0  # found
  else
    return 1  # not found
  fi
}
################################################################################

started=false
is_comment=false
is_blank=false
is_activation_line=false
last_stdout_line=0
last_stderr_line=0
while IFS= read -r line || [ -n "$line" ]; do  
  line=$(echo "$line" | envsubst)
  expanded_line=$line
  line_exists=false
  
  # Keep the error log a reasonable size    
  #if [ $(wc -l < "$ERROR_FILE") -gt 1000 ]; then
  #  cp "$ERROR_FILE" "$ERROR_FILE.$(date +%s)"
  #  > "$ERROR_FILE"
  #fi
  #if [ $(wc -l < "$OUTPUT_FILE") -gt 1000 ]; then
  #  cp "$OUTPUT_FILE" "$OUTPUT_FILE.$(date +%s)"
  #  > "$OUTPUT_FILE"
  #fi
  
  # Skip blank lines when trimmed
  trimmed_line="${line#"${line%%[![:space:]]*}"}"
  trimmed_line="${trimmed_line%"${trimmed_line##*[![:space:]]}"}"
  if [ -z "$trimmed_line" ]; then
    is_blank=true
  else
    is_blank=false
  fi
  
  # Check if line is a comment
  if [[ "$trimmed_line" =~ ^# ]]; then
    is_comment=true
  else
    is_comment=false
  fi
  
  # Check if "activate" line to handle environment activation
  if [[ "$trimmed_line" == conda\ activate* ]]; then
    is_activation_line=true
  else
    is_activation_line=false
  fi
   
  # Execute non-comment lines
  if [ "$started" = false ] && [ "$is_blank" = false ] && [ "$is_comment" = false ]; then
    # get the explanded line to check if it exists    
    if check_if_line_exists "$expanded_line"; then
      echo "SKIPPING $ $expanded_line"      
      line_exists=true      
    else
      line_exists=false
      # First line not found means we start from here
      echo "###################################################"
      echo "Starting execution from $ $expanded_line"      
      echo "###################################################"
      started=true      
    fi
  fi

  if [ "$started" = false ] && [ "$is_activation_line" = true ]; then
    echo "###################################################"
    echo "Activation line being run before starting execution:"    
    echo "$ $expanded_line"
    eval "$line"      
    echo "###################################################"
  elif [ "$started" = true ]; then
    if [ "$is_blank" = true ] || [ "$is_comment" = true ]; then
      echo "$line"
      echo "$line" >> "$RECIPE_FILE"
      continue
    fi    
    start_time_line=$(date +%s)    
    echo "@@@ RECIPE LINE @@@ $(date)>>$expanded_line"
    #eval "$expanded_line"  
    coble_cmd "$expanded_line"
    end_time_line=$(date +%s)    
    # check for errors then check return code
    echo "#$ $expanded_line" >> "$DONE_FILE"
    check_for_errors    
    is_error=$?        
    if [ $is_error -eq 0 ] && [ "$SKIP_ERRORS" != true ]; then
      echo "Error detected after executing line: $expanded_line"      
      echo "Terminating script."
      echo "# ERROR: Terminating script at $(date) due to error after executing line:" >> "$RECIPE_FILE"
      echo "#!!! >> $expanded_line" >> "$RECIPE_FILE"
      echo "#    time taken for line: $((end_time_line - start_time_line)) seconds."
      echo "EXIT 1"
      exit 1
    else      
      if [ $is_error -eq 0 ]; then
        echo "Error detected after executing line: $expanded_line"
        echo "Skipping error as per --skip-errors flag."      
        echo "# WARNING: Error detected but skipping as per --skip-errors flag at $(date) after executing line:" >> "$RECIPE_FILE"        
      fi      
      if [[ "$expanded_line" != *"coble@"* ]]; then
        echo "$expanded_line" >> "$RECIPE_FILE"      
      fi
      echo "#    time taken for line: $((end_time_line - start_time_line)) seconds."
      echo "#    time taken for line: $((end_time_line - start_time_line)) seconds." >> "$RECIPE_FILE"
    fi
  else
    if [ "$is_comment" = true ] && [ "$started" = true ]; then      
      echo "$ $expanded_line"
      echo "$expanded_line" >> "$RECIPE_FILE"            
    fi
  fi
  
done < "$INPUT_RECIPE"

# Now print out the environm,ents
# CONDA OUTPUT
conda_yml="$RESULTS_DIR/environment.yml"
echo "Exporting conda environment to $conda_yml"
echo "conda env export --no-builds --file $conda_yml"
conda env export --no-builds --file "$conda_yml"
# R PACKAGES
r_packages="$RESULTS_DIR/r-packages.txt"
echo "Exporting R packages to $r_packages"
Rscript -e "installed <- as.data.frame(installed.packages()[,c('Package','Version')]); write.table(installed, file='$r_packages', sep='\t', row.names=FALSE, col.names=TRUE, quote=FALSE)"
# Python PACKAGES
python_packages="$RESULTS_DIR/python-packages.txt"
echo "Exporting Python packages to $python_packages"
pip freeze > "$python_packages"


echo "###################################################################"
echo "All steps completed successfully at $(date)."
echo "Time taken: $(($(date +%s) - $start_time)) seconds."
echo "###################################################################"

echo "###################################################################" >> "$RECIPE_FILE"
echo "# All steps completed successfully at $(date)." >> "$RECIPE_FILE"
echo "# Time taken: $(($(date +%s) - $start_time)) seconds." >> "$RECIPE_FILE"
echo "###################################################################" >> "$RECIPE_FILE"