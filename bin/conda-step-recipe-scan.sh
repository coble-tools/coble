#!/usr/bin/env bash
# Scan a recipe file and classify each line by install type.
# For matched cases, echo the case name; for others, eval the line as bash.
# Patterns:
#  - conda install
#  - mamba install
#  - install.packages / install.package
#  - BiocManager::install
#  - install_github

set -eo pipefail

recipe_file=$1
output_yaml=$2

if [[ -z "${recipe_file}" ]]; then
  echo "Usage: recipe-scan.sh <recipe_file>" >&2
  exit 1
fi

if [[ ! -f "${recipe_file}" ]]; then
  echo "Error: file not found: ${recipe_file}" >&2
  exit 1
fi

mode=""
echo "#coble-yml" > "$output_yaml"
echo "dependencies:" >> "$output_yaml"


while IFS= read -r line || [[ -n "$line" ]]; do
  # Preserve original for bash eval fallback
  orig_line="$line"
  
  # Trim leading/trailing whitespace
  line_trimmed="${line#"${line%%[![:space:]]*}"}"
  line_trimmed="${line_trimmed%"${line_trimmed##*[![:space:]]}"}"
  # (mamba/pip handlers moved below with other classifiers)
  # Strip leading YAML-style bullet "- " if present, then re-trim
  line_stripped="$line_trimmed"
  if [[ "$line_stripped" == -* ]]; then
    line_stripped="${line_stripped#-}"
    line_stripped="${line_stripped# }"
    line_stripped="${line_stripped#\t}"
    line_stripped="${line_stripped#"${line_stripped%%[![:space:]]*}"}"
  fi

  # Skip empty lines
  if [[ -z "$line_stripped" ]]; then
    continue
  fi

  # Comments: write into bash section as plain string
  if [[ "$line_stripped" == \#* ]]; then
    if [[ "$mode" != "bash:" ]]; then
      mode="bash:"
      echo "  - bash:" >> "$output_yaml"
    fi
    echo "    - $line_stripped" >> "$output_yaml"
    continue
  fi

  # Normalize for matching: collapse spaces for robust substring checks
  norm="$(echo "$line_stripped" | tr -s ' ')"
  if [[ "$norm" == *"conda install"* ]]; then
    echo "conda-install"        
    if [[ "$mode" != "conda:" ]]; then
      mode="conda:"
      echo "  - conda:" >> "$output_yaml"      
    fi
    # we want to strip out everything after install and then make a list based on the space
    norm_list=${norm#*install }
    IFS=' ' read -r -a pkg_array <<< "$norm_list"
    last_channel=False
    for pkg in "${pkg_array[@]}"; do
      # skip items that start with -
      # we need to skip any immediatey preceeded by -c as well      
      if [[ "$pkg" != -* ]]; then        
        if [[ "$last_channel" == "True" ]]; then
          last_channel=False
        else          
          new_norm=$pkg
          # if the pkg trains r- then it is a different mode it is r_conda:
          if [[ "$new_norm" == r-* ]]; then
            if [[ "$mode" != "r_conda:" ]]; then
              mode="r_conda:"
              echo "  - r_conda:" >> "$output_yaml"      
            fi
            # and take the r- off
            new_norm=${new_norm#r-}
          fi
          echo "    - $new_norm" >> "$output_yaml"        
        fi        
      elif [[ "$pkg" == "-c" ]]; then
        last_channel=True        
      fi
    done      
  elif [[ "$norm" == *"mamba install"* ]]; then
    echo "mamba-install"        
    if [[ "$mode" != "mamba:" ]]; then
      mode="mamba:"
      echo "  - mamba:" >> "$output_yaml"      
    fi
    norm_list=${norm#*install }
    IFS=' ' read -r -a pkg_array <<< "$norm_list"
    last_channel=False
    for pkg in "${pkg_array[@]}"; do
      if [[ "$pkg" != -* ]]; then        
        if [[ "$last_channel" == "True" ]]; then
          last_channel=False
        else          
          new_norm=$pkg
          if [[ "$new_norm" == r-* ]]; then
            if [[ "$mode" != "r_conda:" ]]; then
              mode="r_conda:"
              echo "  - r_conda:" >> "$output_yaml"      
            fi
            new_norm=${new_norm#r-}
          fi
          echo "    - $new_norm" >> "$output_yaml"        
        fi        
      elif [[ "$pkg" == "-c" ]]; then
        last_channel=True        
      fi
    done
  elif [[ "$norm" == *"pip install"* ]]; then
    echo "pip-install"        
    if [[ "$mode" != "pip:" ]]; then
      mode="pip:"
      echo "  - pip:" >> "$output_yaml"      
    fi
    norm_list=${norm#*install }
    IFS=' ' read -r -a pkg_array <<< "$norm_list"
    for pkg in "${pkg_array[@]}"; do
      if [[ "$pkg" != -* ]]; then
        echo "    - $pkg" >> "$output_yaml"
      fi
    done      
  elif [[ "$norm" == *"="* ]]; then
    if [[ "$mode" != "bash:" ]]; then
      mode="bash:"
      echo "  - bash:" >> "$output_yaml"
    fi
    echo "    - $orig_line" >> "$output_yaml"
  elif [[ "$norm" == *"install.packages"* ]] || [[ "$norm" == *"install.package"* ]]; then
    echo "r-install.packages"    
    if [[ "$mode" != "r_package:" ]]; then
      mode="r_package:"
      echo "  - r_package:" >> "$output_yaml"      
    fi    
    pkg_list=${line_stripped#*install.packages(}
    pkg_list=${pkg_list%)*}
    IFS=',' read -r -a pkg_array <<< "$pkg_list"
    # now go through the list and output each one
    for pkg in "${pkg_array[@]}"; do
      pkg_cleaned="${pkg#"${pkg%%[![:space:]]*}"}"
      pkg_cleaned="${pkg_cleaned%"${pkg_cleaned##*[![:space:]]}"}"      
      if [[ "$pkg_cleaned" == c\(* ]]; then pkg_cleaned=${pkg_cleaned#c(}; fi
      pkg_cleaned="${pkg_cleaned%)}"
      pkg_cleaned="${pkg_cleaned//\'/}"
      pkg_cleaned="${pkg_cleaned//\"/}"
      pkg_cleaned="${pkg_cleaned#"${pkg_cleaned%%[![:space:]]*}"}"
      pkg_cleaned="${pkg_cleaned%"${pkg_cleaned##*[![:space:]]}"}"
      echo "    - $pkg_cleaned" >> "$output_yaml"
    done    
  elif [[ "$norm" == *"BiocManager::install"* ]]; then
    echo "biocmanager-install"
    if [[ "$mode" != "bio_package:" ]]; then
      mode="bio_package:"
      echo "  - bio_package:" >> "$output_yaml"      
    fi
    # Extract argument list inside BiocManager::install(...)
    bioc_args=${line_stripped#*BiocManager::install(}
    bioc_args=${bioc_args%)*}
    IFS=',' read -r -a pkg_array <<< "$bioc_args"
    for pkg in "${pkg_array[@]}"; do
      pkg_cleaned="${pkg#"${pkg%%[![:space:]]*}"}"
      pkg_cleaned="${pkg_cleaned%"${pkg_cleaned##*[![:space:]]}"}"
      if [[ "$pkg_cleaned" == c\(* ]]; then pkg_cleaned=${pkg_cleaned#c(}; fi
      pkg_cleaned="${pkg_cleaned%)}"
      pkg_cleaned="${pkg_cleaned//\'/}"
      pkg_cleaned="${pkg_cleaned//\"/}"
      pkg_cleaned="${pkg_cleaned#"${pkg_cleaned%%[![:space:]]*}"}"
      pkg_cleaned="${pkg_cleaned%"${pkg_cleaned##*[![:space:]]}"}"
      [[ -n "$pkg_cleaned" ]] && echo "    - $pkg_cleaned" >> "$output_yaml"
    done
    continue
  elif [[ "$norm" == *"install_github"* ]]; then
    if [[ "$mode" != "github:" ]]; then
      mode="github:"
      echo "  - github:" >> "$output_yaml"      
    fi
    # Extract primary repo argument inside install_github(...)
    gh_args=${line_stripped#*install_github(}
    gh_args=${gh_args%)*}
    IFS=',' read -r -a gh_array <<< "$gh_args"
    gh_repo="${gh_array[0]:-}"
    gh_repo="${gh_repo#"${gh_repo%%[![:space:]]*}"}"
    gh_repo="${gh_repo%"${gh_repo##*[![:space:]]}"}"
    gh_repo="${gh_repo//\'/}"
    gh_repo="${gh_repo//\"/}"
    [[ -n "$gh_repo" ]] && echo "    - $gh_repo" >> "$output_yaml"
    echo "install_github"
    continue
  elif [[ "$norm" == *"install_url"* ]]; then
    if [[ "$mode" != "wget:" ]]; then
      mode="wget:"
      echo "  - wget:" >> "$output_yaml"      
    fi
    # Extract URL argument list inside install_url(...)
    url_args=${line_stripped#*install_url(}
    url_args=${url_args%)*}
    IFS=',' read -r -a url_array <<< "$url_args"
    for u in "${url_array[@]}"; do
      u_cleaned="${u#"${u%%[![:space:]]*}"}"
      u_cleaned="${u_cleaned%"${u_cleaned##*[![:space:]]}"}"
      if [[ "$u_cleaned" == c\(* ]]; then u_cleaned=${u_cleaned#c(}; fi
      u_cleaned="${u_cleaned%)}"
      u_cleaned="${u_cleaned//\'/}"
      u_cleaned="${u_cleaned//\"/}"
      u_cleaned="${u_cleaned#"${u_cleaned%%[![:space:]]*}"}"
      u_cleaned="${u_cleaned%"${u_cleaned##*[![:space:]]}"}"
      [[ -n "$u_cleaned" ]] && echo "    - $u_cleaned" >> "$output_yaml"
    done
    echo "wget"
    continue
  else
    # Fallback: treat as bash
    if [[ "$mode" != "bash:" ]]; then
      mode="bash:"
      echo "  - bash:" >> "$output_yaml"      
    fi
    echo "    - $line_stripped" >> "$output_yaml"    
  fi

done < "$recipe_file"

# Append generation timestamp at end of file
echo "" >> "$output_yaml"
echo "# generated at $(date -Iseconds)" >> "$output_yaml"
