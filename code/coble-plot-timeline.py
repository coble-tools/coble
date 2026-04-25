"""
Adjacency matrix for package dependencies — outputs interactive Plotly HTML.

Usage:
    python adjacency.py data.tsv
    python adjacency.py data.tsv --out matrix.html
"""

import argparse
from pathlib import Path

import pandas as pd
import plotly.graph_objects as go
from datetime import date
import numpy as np
import plotly.express as px


def load(path: str) -> pd.DataFrame:
    df = pd.read_csv(path, sep="\t", keep_default_na=False)
    df = df[df["ReleaseDate"].notna()]
    df["ReleaseDate"] = pd.to_datetime(df["ReleaseDate"], errors="coerce", utc=True)
    # completely remove any row that starts with "lib"
    df = df[~df["Package"].str.startswith("lib")]
    # remove bioc- or r- from start of any package NameError
    df["Package"] = df["Package"].apply(lambda x: x[13:] if x.startswith("bioconductor-") else x)
    df["Package"] = df["Package"].apply(lambda x: x[2:] if x.startswith("r-") else x)
    # make all packages lower case
    df["Package"] = df["Package"].str.lower()
    return df



def plot(dfs: list[pd.DataFrame], filenames, out_path: Path) -> None:
    # create a combined list of date times and package names
    all_dates = []
    all_packages = set()
    for df in dfs:
        all_dates.extend(df["ReleaseDate"].dropna().tolist())
        all_packages.update(df["Package"].unique().tolist())
    all_dates = sorted(set(all_dates))
    all_packages = sorted(all_packages)


     # use plotly to make a scatter plot of each df
    colors = px.colors.qualitative.Bold_r
     # plotting pacakge on the x axis against date on the y axis, with "df" as marker color
    fig = go.Figure()
    for i, df in enumerate(dfs):
        df["text"] = df["Package"] + " (" + df["Version"] + ")"

        fig.add_trace(
            go.Scatter(
                x=df["ReleaseDate"],
                y=df["Package"],
                mode="markers",
                name=f"{filenames[i]}",
                marker=dict(size=10-(2*i), opacity=0.5, color=colors[i % len(colors)]),
                text=df["text"],
                hovertemplate="%{text}<extra></extra>",
            )
        )
    fig.update_layout(
        title="Package Release Timeline",
        xaxis_title="Release Date",
        yaxis_title="Package",
        xaxis=dict(tickformat="%Y-%m-%d"),
        yaxis=dict(tickmode="array", tickvals=all_packages, tickangle=45),
        height=600,
    )
    fig.write_html(out_path)


def main():
    parser = argparse.ArgumentParser(description="Package dependency adjacency matrix")
    parser.add_argument("file", help="TSV data file(s)")
    parser.add_argument("--out", default="adjacency.html", help="Output HTML file")
    args = parser.parse_args()

    files = args.file.split(",")
    dfs = [load(f) for f in files]
    filenames = [Path(f).stem for f in files]
    plot(dfs, filenames, Path(args.out))


if __name__ == "__main__":
    main()