#!/bin/bash
code/coble.sh recreate --input tests/sylver.yml --env sylver --outdir tests/output/sylver --debug
code/coble.sh recreate --input tests/latest.yml --env latest --outdir tests/output/latest




query="library(fgsea)"
# URL‑encode spaces and special characters
q=$(echo "$query" | sed 's/ /+/g')

curl -s \
-H "Accept: application/vnd.github.v3.text-match+json" \
"https://api.github.com/search/code?q=${q}" \
| grep '"html_url"' | cut -d'"' -f4


# GitHub search 
pkg="library(cdsrmodels)"
gh=$(curl -s "https://api.github.com/search/repositories?q=${pkg}+language:R" \
 | grep '"html_url"' | head -n10 | cut -d'"' -f4)
if [[ -n "$gh" ]]; then 
echo "Found on GitHub: $gh" 
fi

q=cdsr_models
gh=$(curl -s \ -H "Accept: application/vnd.github.v3.text-match+json" \
 "https://api.github.com/search/code?q=${q}+language:R" \
 | grep '"html_url"' | cut -d'"' -f4)
if [[ -n "$gh" ]]; then 
echo "Found on GitHub: $gh" 
fi
