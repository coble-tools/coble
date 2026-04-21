#!/usr/bin/env python

# e,g,
# code/coble-disentangle.py recipes/papers/DESeq2/DESeq2_freeze.cbl recipes/papers/DESeq2/DESeq2_network.txt
# python code/coble-network.py recipes/papers/DESeq2/DESeq2_network.txt --hue date --out recipes/papers/DESeq2/DESeq2_network.html

# code/coble-disentangle.py recipes/papers/ProvGigaPath/ProvGigaPath_freeze.cbl recipes/papers/ProvGigaPath/ProvGigaPath_network.txt
# python code/coble-network.py recipes/papers/ProvGigaPath/ProvGigaPath_network.txt --hue date --out recipes/papers/ProvGigaPath/ProvGigaPath_network.html

import sys
import os
import subprocess
from datetime import datetime
from collections import defaultdict
import requests
import json
import time

def get_package_info(package_name, channel):
    """Fetch package info from Anaconda Cloud API"""
    print(f"Fetching info for package: {package_name} from channel: {channel}")
    url = f"https://api.anaconda.org/package/{channel}/{package_name}"
    print(f"Fetching package info from: {url}")
    try:
        response = requests.get(url, timeout=5)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Package not found: {package_name}")
            return None
    except requests.exceptions.RequestException as e:
        print(f"Error fetching {package_name}: {e}")
        return None

def parse_release_history(data, pkgver):
    """Extract version history with release dates"""
    versions = defaultdict(lambda: {"dates": [], "dependencies": set()})
    for file in data["files"]:
        version = file["version"]
         # Date
        upload_time = file.get("upload_time")
        if upload_time:
            date = datetime.fromisoformat(upload_time.replace("Z", "+00:00")).date()
            versions[version]["dates"].append(date)

        # Dependencies
        deps = file.get("dependencies", {})
        if isinstance(deps, dict):
            for dep in deps.get("depends", []):
                if isinstance(dep, dict):
                    versions[version]["dependencies"].add(dep["name"])
                elif isinstance(dep, str):
                    versions[version]["dependencies"].add(dep)
    # Summarise: use the earliest upload date per version
    result = {}
    for version, info in sorted(versions.items()):
        result[version] = {
            "first_release": min(info["dates"]) if info["dates"] else None,
            "dependencies": sorted(info["dependencies"]),
        }

    for version, info in result.items():
        if version == pkgver:
            return version, info['first_release'], info['dependencies']

    return None, None, None

def main(input_file, ouput_file):
    current_pm = ""
    not_used = {"flags", "compilers", "coble", "channels"}

    packages = {"languages": set(),
                "conda": set(),
                "r-conda": set(),
                "r-package": set(),
                "bioc-conda": set(),
                "bioc-package": set(),
                "pip": set()}

    print(f"input_file: {input_file}")
    print(f"output_file: {ouput_file}")
    with open(ouput_file, "w") as f:
        f.write(f"Manager\tPackage\tVersion\tReleaseDate\tDependencies\n")
    lines = []
    with open(input_file, "r") as f:
        for lne in f:
            line = lne.strip()
            if line == "":
                continue
            if line.startswith("#"):
                continue
            if line[-1] == ":":
                current_pm = ""
                if line[:-1] in packages:
                    current_pm = line[:-1]
                    print(f"Switching to package manager: {current_pm}")
                elif line[:-1] not in not_used:
                    print(f"Warning: Unrecognized package manager '{line[:-1]}' in line: {line}")
                    current_pm = ""
            elif current_pm != "":
                if line[0] == "-":
                    line = line[1:].strip()
                packages[current_pm].add(line)


    for pm, pkgs in packages.items():
        if len(pkgs) > 0:
            for line in sorted(pkgs):
                if pm == "r-conda":
                    line = "r-" + line
                if pm == "bioc-conda":
                    line = "bioconductor-" + line
                if pm in ["conda", "r-conda", "bioc-conda","languages"]:
                    print(f"Processing package: {line} from manager: {pm}")
                    if "@" in line:
                        cnl = line.split("@")[1]
                        pkgv = line.split("@")[0]
                    else:
                        cnl = "conda-forge"
                        pkgv = line
                    pkg=pkgv.split("=")[0]
                    ver=pkgv.split("=")[1]

                    print(f"Checking package: {pkg} {ver} {cnl} from {pm}", flush=True)

                    if cnl == "defaults":
                        with open(ouput_file, "a") as f:
                            f.write(f"{pm}\t{pkg}\t{ver}\t{""}\t{cnl}\n")

                    else:
                        info = None
                        tries = 0
                        while info is None and tries < 3:
                            tries += 1
                            info = get_package_info(pkg, cnl)
                            if info is None:
                                print(f"Retrying ({tries}/3) for package: {pkg} from channel: {cnl}")
                                time.sleep(2)
                        if info is not None:
                            ver, rel, deps = parse_release_history(info, ver)
                            with open(ouput_file, "a") as f:
                                f.write(f"{pm}\t{pkg}\t{ver}\t{rel}\t{';'.join(deps)}\n")









if __name__ == "__main__":
    if len(sys.argv) <= 2:
        print("Usage: coble-disentangle.py <input_file> <output_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2]
    if not os.path.isfile(input_file):
        print(f"Error: File '{input_file}' does not exist.")
        sys.exit(1)

    main(input_file, output_file)