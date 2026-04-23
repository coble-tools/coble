"""
Package dependency network visualizer — outputs an interactive HTML file.

Usage:
    python network_vis.py data.tsv --hue date
    python network_vis.py data.tsv --hue manager
    python network_vis.py data.tsv --hue date --out my_graph.html

Requires:
    pip install pyvis pandas numpy
"""

import argparse
import colorsys
from datetime import datetime
from pathlib import Path

import numpy as np
import pandas as pd
from pyvis.network import Network


# ── data ──────────────────────────────────────────────────────────────────────

def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path, sep="\t", keep_default_na=False)
    df["ReleaseDate"] = pd.to_datetime(df["ReleaseDate"], errors="coerce")
    return df


# ── colour helpers ────────────────────────────────────────────────────────────

def plasma(t: float) -> str:
    """Approximate matplotlib plasma colormap -> hex string. t in [0, 1]."""
    colours = [
        (0.050383, 0.029803, 0.527975),
        (0.494877, 0.012490, 0.657865),
        (0.798216, 0.280197, 0.469538),
        (0.973381, 0.585730, 0.254593),
        (0.940015, 0.975158, 0.131326),
    ]
    t = max(0.0, min(1.0, t))
    scaled = t * (len(colours) - 1)
    lo = int(scaled)
    hi = min(lo + 1, len(colours) - 1)
    frac = scaled - lo
    r = colours[lo][0] + frac * (colours[hi][0] - colours[lo][0])
    g = colours[lo][1] + frac * (colours[hi][1] - colours[lo][1])
    b = colours[lo][2] + frac * (colours[hi][2] - colours[lo][2])
    return "#{:02x}{:02x}{:02x}".format(int(r * 255), int(g * 255), int(b * 255))


def distinct_colours(n: int) -> list:
    """Generate n visually distinct hex colours."""
    return [
        "#{:02x}{:02x}{:02x}".format(
            *[int(c * 255) for c in colorsys.hls_to_rgb(i / n, 0.55, 0.75)]
        )
        for i in range(n)
    ]


# ── graph builder ─────────────────────────────────────────────────────────────

def build_records(df: pd.DataFrame) -> tuple:
    """
    Returns:
        nodes  - {name: {manager, date, version}}
        edges  - set of (src, dst) tuples
    """
    nodes = {}
    edges = set()

    for _, row in df.iterrows():
        name = row["Package"]
        nodes[name] = {
            "manager": row["Manager"],
            "date": row["ReleaseDate"],
            "version": row["Version"],
        }

    for _, row in df.iterrows():
        raw = row["Dependencies"]
        if not raw:
            continue
        for dep in raw.split(";"):
            dep = dep.strip()
            if dep:
                if dep not in nodes:
                    nodes[dep] = {"manager": "unknown", "date": pd.NaT, "version": "?"}
                edges.add((row["Package"], dep))

    return nodes, edges


def degree(name: str, edges: set) -> int:
    return sum(1 for s, d in edges if s == name or d == name)


# ── visualiser ────────────────────────────────────────────────────────────────

def build_html(nodes: dict, edges: set, hue: str, out_path: Path) -> None:
    net = Network(
        height="100vh",
        width="100%",
        directed=True,
        bgcolor="#e9e9ee",
        font_color="#110838",
        notebook=False,
    )

    net.set_options("""
    {
      "physics": {
        "forceAtlas2Based": {
          "gravitationalConstant": -60,
          "centralGravity": 0.005,
          "springLength": 120,
          "springConstant": 0.06,
          "damping": 0.45
        },
        "solver": "forceAtlas2Based",
        "stabilization": { "iterations": 150 }
      },
      "edges": {
        "arrows": { "to": { "enabled": true, "scaleFactor": 0.6 } },
        "color": { "color": "#AAA2CE", "highlight": "#100744" },
        "width": 0.8,
        "smooth": { "type": "dynamic" }
      },
      "interaction": {
        "hover": true,
        "tooltipDelay": 100,
        "navigationButtons": true,
        "keyboard": true
      }
    }
    """)

    # --- colour maps ---
    if hue == "date":
        timestamps = [
            n["date"].timestamp()
            for n in nodes.values()
            if pd.notna(n["date"])
        ]
        t_min, t_max = (min(timestamps), max(timestamps)) if timestamps else (0, 1)

        def node_colour(meta):
            if pd.isna(meta["date"]):
                return "#6D6D7A"
            t = (meta["date"].timestamp() - t_min) / max(t_max - t_min, 1)
            return plasma(t)

    else:  # manager
        managers = sorted({m["manager"] for m in nodes.values()})
        palette = distinct_colours(len(managers))
        manager_colour = dict(zip(managers, palette))

        def node_colour(meta):
            return manager_colour.get(meta["manager"], "#888888")

    # --- add nodes ---
    base_size = 10
    scale = 3
    max_size = 500

    for name, meta in nodes.items():
        deg = degree(name, edges)
        size = base_size + scale * deg
        size = min(size, max_size)
        colour = node_colour(meta)
        date_str = meta["date"].strftime("%Y-%m-%d") if pd.notna(meta["date"]) else "unknown"
        tooltip = (
            f"{name}\n"
            f"Manager: {meta['manager']}\n"
            f"Version: {meta['version']}\n"
            f"Released: {date_str}\n"
            f"Connections: {deg}"
        )
        net.add_node(
            name,
            label=name,
            size=size,
            color=colour,
            title=tooltip,
            borderWidth=1,
            borderWidthSelected=3,
        )

    # --- add edges ---
    for src, dst in edges:
        net.add_edge(src, dst)

    # --- build legend HTML ---
    if hue == "manager":
        legend_items = "".join(
            f'<div style="display:flex;align-items:center;gap:6px;margin:3px 0">'
            f'<div style="width:12px;height:12px;border-radius:50%;background:{c};flex-shrink:0"></div>'
            f'<span style="font-size:12px">{m}</span></div>'
            for m, c in manager_colour.items()
        )
        legend_html = f"""
        <div style="position:fixed;top:16px;left:16px;z-index:9999;
                    background:#1a1a2e;border:1px solid #333;border-radius:8px;
                    padding:12px 16px;color:#ddd;font-family:monospace">
          <div style="font-weight:bold;margin-bottom:8px;font-size:13px">Package manager</div>
          {legend_items}
        </div>"""
    else:
        t_min_dt = datetime.fromtimestamp(t_min).strftime("%Y-%m") if timestamps else "?"
        t_max_dt = datetime.fromtimestamp(t_max).strftime("%Y-%m") if timestamps else "?"
        stops = "".join(
            f'<stop offset="{int(i*100/4)}%" stop-color="{plasma(i/4)}"/>'
            for i in range(5)
        )
        legend_html = f"""
        <div style="position:fixed;top:16px;left:16px;z-index:9999;
                    background:#1a1a2e;border:1px solid #333;border-radius:8px;
                    padding:12px 16px;color:#ddd;font-family:monospace;width:160px">
          <div style="font-weight:bold;margin-bottom:8px;font-size:13px">Release date</div>
          <svg width="130" height="14" style="display:block;border-radius:4px">
            <defs><linearGradient id="g">{stops}</linearGradient></defs>
            <rect width="130" height="14" fill="url(#g)" rx="3"/>
          </svg>
          <div style="display:flex;justify-content:space-between;font-size:10px;margin-top:4px">
            <span>{t_min_dt}</span><span>{t_max_dt}</span>
          </div>
          <div style="margin-top:6px;font-size:11px;color:#888">Grey = unknown date</div>
        </div>"""

    title_html = f"""
    <div style="position:fixed;top:16px;left:50%;transform:translateX(-50%);z-index:9999;
                background:#1a1a2e;border:1px solid #333;border-radius:8px;
                padding:8px 20px;color:#fff;font-family:monospace;font-size:14px;
                font-weight:bold;letter-spacing:0.5px">
      COBLE package dependency graph<br>colour = {hue}
      &nbsp;&middot;&nbsp; {len(nodes)} nodes &nbsp;&middot;&nbsp; {len(edges)} edges &nbsp;&middot;&nbsp; directed
    </div>"""

    # Save then inject legend + title into the body
    net.save_graph(str(out_path))
    raw = out_path.read_text(encoding="utf-8")
    injection = legend_html + title_html
    raw = raw.replace("<body>", f"<body>\n{injection}", 1)
    out_path.write_text(raw, encoding="utf-8")

    print(f"Saved -> {out_path.resolve()}")


# ── entry point ───────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description="Package dependency network -> HTML")
    parser.add_argument("file", help="Path to the TSV data file")
    parser.add_argument(
        "--hue",
        choices=["date", "manager"],
        default="date",
        help="Colour nodes by 'date' or 'manager' (default: date)",
    )
    parser.add_argument(
        "--out",
        default=None,
        help="Output HTML filename (default: network_hue_<hue>.html)",
    )
    args = parser.parse_args()

    out_path = Path(args.out) if args.out else Path(f"network_hue_{args.hue}.html")

    df = load_data(args.file)
    nodes, edges = build_records(df)

    print(f"Graph: {len(nodes)} nodes, {len(edges)} edges")
    build_html(nodes, edges, hue=args.hue, out_path=out_path)


if __name__ == "__main__":
    main()
