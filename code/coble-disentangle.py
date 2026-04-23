#!/usr/bin/env python

# e,g,
# code/coble-disentangle.py recipes/papers/DESeq2/DESeq2_freeze.cbl recipes/papers/DESeq2/DESeq2_network.txt
# python code/coble-plot-network.py recipes/papers/DESeq2/DESeq2_network.txt --hue date --out recipes/papers/DESeq2/DESeq2_network.html

# code/coble-disentangle.py recipes/icr/bcds/bcds_freeze.cbl recipes/icr/bcds/bcds_network.txt

# python code/coble-plot-network.py recipes/icr/bcds/bcds_network.txt --hue date --out recipes/icr/bcds/bcds_network.html
# python code/coble-plot-adjacency.py recipes/icr/bcds/bcds_network.txt --out recipes/icr/bcds/bcds_adj.html --tmin 2020-01-01

import re
import sys
import os
from datetime import datetime
import tomllib
from collections import defaultdict
import requests
import time
import configparser
from packaging.requirements import Requirement
import tomllib

BIOCVERSION = "3.22"

def fetch_r_github(url):
    headers = {"Authorization": f"token {os.environ['GITHUB_PAT']}"}
    owner, repo, commit = url.split("/")
    data = requests.get(f"https://api.github.com/repos/{owner}/{repo}/commits/{commit}", headers=headers).json()
    #print(data)
    date = data["commit"]["author"]["date"][:10]

    base = f"https://raw.githubusercontent.com/{owner}/{repo}/{commit}"
    r = requests.get(f"{base}/DESCRIPTION")
    text = r.text
    deps = []
    for field in ["Depends", "Imports"]:
        match = re.search(rf"{field}:\s*(.*?)(?=\n\w|\Z)", text, re.DOTALL)
        if match:
            raw = match.group(1).replace("\n", "").replace(" ", "")
            deps += [d.split("(")[0] for d in raw.split(",") if d]

    return date, deps, url

def fetch_py_github(url):
    #rachelicr/pysamstats/228700300f46943571b665467e3f7bcbb73dc45b
    headers = {"Authorization": f"token {os.environ['GITHUB_PAT']}"}
    print(f"Fetching GitHub info for: {url}")
    owner, repo, commit = url.split("/")
    base = f"https://raw.githubusercontent.com/{owner}/{repo}/{commit}"

    data = requests.get(f"https://api.github.com/repos/{owner}/{repo}/commits/{commit}", headers=headers).json()
    date = data["commit"]["author"]["date"][:10]
    deps = []
    base = f"https://raw.githubusercontent.com/{owner}/{repo}/{commit}"
    for filename in ["pyproject.toml", "setup.cfg", "setup.py"]:
        git_req = f"{base}/{filename}"
        r = requests.get(f"{git_req}", headers=headers)
        if r.status_code == 200:
            print(f"Fetching dependencies from: {git_req}")
            if filename == "pyproject.toml":
                data = tomllib.loads(r.text)
                deps += data.get("project", {}).get("dependencies", [])
            elif filename == "setup.cfg":
                config = configparser.ConfigParser()
                config.read_string(r.text)
                raw = config.get("options", "install_requires", fallback="")
                deps += [line.strip() for line in raw.strip().splitlines() if line.strip()]
            elif filename == "setup.py":
                match = re.search(r"install_requires\s*=\s*\[(.*?)\]", r.text, re.DOTALL)
                if match:
                    deps += re.findall(r"['\"]([^'\"]+)['\"]", match.group(1))



    for i, dep in enumerate(deps):
        req = dep.split("=")[0].split(">")[0].split("<")[0].strip()
        deps[i] = req
    return date, deps, url

def fetch_pypi(package, pkgver):
    url = f"https://pypi.org/pypi/{package}/{pkgver}/json"
    data = requests.get(url).json()
    #print(data)
    info = data["info"]
    #print(info)

    # First release date for this version
    date = data["urls"][0]["upload_time"][:10]

    # Bare dependency names
    deps = []
    for raw in (info.get("requires_dist") or []):
        try:
            req = Requirement(raw)
            if not (req.marker and "extra" in str(req.marker)):
                deps.append(req.name)
        except Exception:
            pass

    return date, deps, url

def get_bioc_package_info(package_name, bioc_version=BIOCVERSION):
    """Fetch package info from Bioconductor"""
    url = f"https://bioconductor.org/packages/json/{bioc_version}/bioc/packages.json"
    print(f"Fetching Bioconductor package index from: {url}")

    try:
        response = requests.get(url, timeout=10)
        if response.status_code == 200:
            all_packages = response.json()
            if package_name in all_packages:
                return all_packages[package_name], url
            else:
                print(f"Package '{package_name}' not found on Bioconductor")
                return None, url
        else:
            print(f"Failed to fetch Bioconductor index: {response.status_code}")
            return None, url
    except requests.exceptions.RequestException as e:
        print(f"Error fetching package index: {e}")
        return None, url

def parse_bioc_release_history(data, pkgver):
    """Get all Bioconductor releases with dates"""
    if not data:
        print("No data to parse for Bioconductor package.")
        return "", None, []
    release_date = data.get("Date/Publication")
    depends  = data.get("Depends", [])
    imports  = data.get("Imports", [])
    all_deps = depends + imports
    for i, dep in enumerate(all_deps):
        req = dep.split("(")[0].strip()
        all_deps[i] = req
    return pkgver, release_date, all_deps



def get_cran_package_info(package_name):
    """Fetch package info from CRAN"""
    url = f"https://crandb.r-pkg.org/{package_name.replace('=', '/')}"

    try:
        response = requests.get(url, timeout=5)
        if response.status_code == 200:
            return response.json(), url
        else:
            print(f"Package not found on CRAN: {package_name}")
            return None, url
    except requests.exceptions.RequestException as e:
        print(f"Error fetching {package_name}: {e}")
        return None, url

def parse_cran_release_history(data, pkgver):
    """Get all CRAN releases with dates"""
    if not data:
        return None
    release_date = data.get("Date/Publication")  # "2019-09-18 14:30:02 UTC"
    depends = data.get("Depends", {})   # {"R": ">= 3.0.0"}
    imports = data.get("Imports", {})   # {"formatR": "*"}
    dep_names = list(depends.keys()) + list(imports.keys())  # ["R", "formatR"]
    return pkgver, release_date, dep_names

def get_conda_package_info(package_name, channel):
    """Fetch package info from Anaconda Cloud API"""
    print(f"Fetching info for package: {package_name} from channel: {channel}")
    url = f"https://api.anaconda.org/package/{channel}/{package_name}"
    print(f"Fetching package info from: {url}")
    try:
        response = requests.get(url, timeout=5)
        if response.status_code == 200:
            return response.json(), url
        else:
            print(f"Package not found: {package_name}")
            return None, url
    except requests.exceptions.RequestException as e:
        print(f"Error fetching {package_name}: {e}")
        return None, url

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
                "r-github": set(),
                "bioc-conda": set(),
                "bioc-package": set(),
                "pip": set()}

    print(f"input_file: {input_file}")
    print(f"output_file: {ouput_file}")
    with open(ouput_file, "w") as f:
        f.write(f"Manager\tLib\tUrl\tPackage\tVersion\tReleaseDate\tDependencies\n")

    lines = []
    with open(input_file, "r") as f:
        for lne in f:
            line = lne.strip()
            if line == "":
                continue
            if line.startswith("#"):
                continue
            lines.append(line)


    for line in lines:
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
                print(line)
                if pm == "r-conda":
                    line = "r-" + line
                elif pm == "bioc-conda":
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
                elif pm in ["pip"] and "==" in line:
                    pkg=line.split("==")[0]
                    ver=line.split("==")[1]
                    cnl="pypi"
                elif pm in ["pip"] and "http" in line:
                    pkg="/".join(line.split("+")[-1].split(".git@")[0].split("/")[-2:])
                    ver=""
                    cnl="github"
                    url="/".join(line.split("+")[-1].split("/")[-2:]).replace(".git@","/")
                elif pm in ["r-github"]:
                    pkg="/".join(line.split("+")[-1].split("@github@")[1].split("/")[0:2])
                    ver=line.split("+")[-1].split("@github@")[0].split("=")[1]
                    url=line.split("+")[-1].split("@github@")[1]
                    cnl="github"
                    rel=""
                elif pm in ["r-package", "bioc-package"]:
                    pkg=line.split("=")[0]
                    ver=line.split("=")[-1]
                    rel=""
                    cnl="cran" if pm == "r-package" else "bioconductor"


                print(f"Checking package: {pkg} {ver} {cnl} from {pm}", flush=True)

                info = None
                tries = 0
                if cnl == "defaults":
                    with open(ouput_file, "a") as f:
                        f.write(f"{pm}\t{line}\t""\t{pkg}\t{ver}\t{""}\t{cnl}\n")

                elif pm in ["conda", "r-conda", "bioc-conda","languages"]:
                    while info is None and tries < 3:
                        tries += 1
                        info, url = get_conda_package_info(pkg, cnl)
                        if info is None:
                            print(f"Retrying ({tries}/3) for package: {pkg} from channel: {cnl}")
                            time.sleep(2)
                    if info is not None:
                        ver, rel, deps = parse_release_history(info, ver)
                    else:
                        ver, rel, deps = ver, None, []
                    with open(ouput_file, "a") as f:
                        f.write(f"{pm}\t{line}\t{url}\t{pkg}\t{ver}\t{rel}\t{';'.join(deps)}\n")
                elif pm in ["r-package"]:
                    info, url = get_cran_package_info(line)
                    if info is not None:
                        ver, rel, deps = parse_cran_release_history(info, ver)
                    else:
                        ver, rel, deps = ver, None, []
                    with open(ouput_file, "a") as f:
                        f.write(f"{pm}\t{line}\t{url}\t{pkg}\t{ver}\t{rel}\t{';'.join(deps)}\n")
                elif pm in ["bioc-package"]:
                    info, url = get_bioc_package_info(pkg)
                    if info is not None:
                        ver, rel, deps = parse_bioc_release_history(info, ver)
                    else:
                        ver, rel, deps = ver, None, []
                    with open(ouput_file, "a") as f:
                        f.write(f"{pm}\t{line}\t{url}\t{pkg}\t{ver}\t{rel}\t{';'.join(deps)}\n")
                elif pm in ["pip"] and "==" in line:
                    rel, deps, url = fetch_pypi(pkg, ver)
                    with open(ouput_file, "a") as f:
                        f.write(f"{pm}\t{line}\t{url}\t{pkg}\t{ver}\t{rel}\t{';'.join(deps)}\n")

                elif pm in ["pip"] and "http" in line:
                    rel, deps, url = fetch_py_github(url)
                    with open(ouput_file, "a") as f:
                        f.write(f"GitHub-Py\t{line}\t{url}\t{pkg}\t{ver}\t{rel}\t{';'.join(deps)}\n")

                elif pm in ["r-github"]:
                    rel, deps, url = fetch_r_github(url)
                    with open(ouput_file, "a") as f:
                        f.write(f"GitHub-R\t{line}\t{url}\t{pkg}\t{ver}\t{rel}\t{';'.join(deps)}\n")

                else:
                    with open(ouput_file, "a") as f:
                        f.write(f"{pm}\t{line}\tNOT HANDLED\t{pkg}\t{ver}\t{rel}\t\n")









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