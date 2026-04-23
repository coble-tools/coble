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


def load(path: str) -> pd.DataFrame:
    df = pd.read_csv(path, sep="\t", keep_default_na=False)
    df["ReleaseDate"] = pd.to_datetime(df["ReleaseDate"], errors="coerce")
    return df



def plot(df: pd.DataFrame, out_path: Path, t_min, t_max) -> None:
    packages = sorted(set(df["Package"]))

    # remove all packages starting with lib
    packages = [pkg for pkg in packages if not pkg.startswith("lib")]


    data = {pkg: {} for pkg in packages}
    for _, row in df.iterrows():
        row_pkg = row["Package"]
        col_pkg = row["Dependencies"]
        timestamp = row["ReleaseDate"].timestamp() if pd.notna(row["ReleaseDate"]) else np.nan
        if row_pkg in packages:
            deps = [d.strip() for d in col_pkg.split(";") if d.strip()]
            for dep in deps:
                if dep in packages:
                    data[row_pkg][dep] = timestamp

    mtx = pd.DataFrame(data).T.reindex(index=packages, columns=packages)
    print(mtx)
    df_long = mtx.stack().reset_index()
    df_long.columns = ["Package", "Dependency", "ReleaseDate"]

    z  = mtx.values          # 2D numpy array of timestamps (with NaN for empty)
    labels = mtx.columns.tolist() # same list for both axes

    text = pd.DataFrame(z, index=labels, columns=labels).applymap(
        lambda v: pd.Timestamp.fromtimestamp(v).strftime("%Y-%m-%d") if not pd.isna(v) else ""
    ).values
    fig = go.Figure(go.Scatter(
        x=df_long["Package"],
        y=df_long["Dependency"],
        mode="markers",
        marker=dict(
            size=8,
            color=df_long["ReleaseDate"],
            colorscale="rainbow",
            cmin=t_min,
            cmax=t_max,
            colorbar=dict(
                title="Release date",
                tickvals=[t_min, (t_min + t_max) / 2, t_max],
                ticktext=[
                    pd.Timestamp.fromtimestamp(t_min).strftime("%Y-%m"),
                    pd.Timestamp.fromtimestamp((t_min + t_max) / 2).strftime("%Y-%m"),
                    pd.Timestamp.fromtimestamp(t_max).strftime("%Y-%m"),
                ],
                thickness=12,
            ),
            showscale=True,
        ),
        text=df_long["ReleaseDate"].apply(
            lambda v: pd.Timestamp.fromtimestamp(v).strftime("%Y-%m-%d")
        ),
        hovertemplate="%{x} → %{y}<br>Released: %{text}<extra></extra>",
    ))

    fig.update_layout(
        title=f"COBLE Dependency Adjacency Matrix, no. of packages: {len(df_long)}",
        xaxis=dict(tickangle=45, tickfont=dict(size=7)),
        yaxis=dict(tickfont=dict(size=7)),
        width=1200,
        height=1200,
    )

    fig.update_layout(
        xaxis=dict(
            tickmode='linear',   # Show every tick, no skipping
            tick0=0,             # Starting tick value
            dtick=1,             # Interval between ticks (adjust to your data)
            tickangle=45,        # Rotate labels if they overlap
        ),
        yaxis=dict(
            tickmode='linear',
            tick0=0,
            dtick=1,
            tickangle=0,
        )
    )

    fig.write_html(str(out_path), include_plotlyjs="cdn")
    print(f"Saved -> {out_path.resolve()}")


def main():
    parser = argparse.ArgumentParser(description="Package dependency adjacency matrix")
    parser.add_argument("file", help="TSV data file")
    parser.add_argument("--out", default="adjacency.html", help="Output HTML file")
    parser.add_argument("--date-min", help="Minimum release date")
    parser.add_argument("--date-max", help="Maximum release date")
    args = parser.parse_args()
    t_min = pd.Timestamp(args.date_min).timestamp() if args.date_min else 0
    t_max = pd.Timestamp(args.date_max).timestamp() if args.date_max else pd.Timestamp(date.today()).timestamp()

    df = load(args.file)
    plot(df, Path(args.out), t_min=t_min, t_max=t_max)


if __name__ == "__main__":
    main()