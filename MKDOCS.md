# Serving MkDocs Locally

To preview and serve your COBLE documentation site locally, follow these steps:

## 1. Install MkDocs and Material Theme

If you haven't already, install MkDocs and the Material theme (recommended):

```bash
pip install mkdocs mkdocs-material
```

## 2. Serve the Documentation

From the top-level project directory (where `mkdocs.yml` is located), run:

```bash
mkdocs serve
```

This will start a local development server. By default, you can view your site at:

```
http://127.0.0.1:8000/
```

The server will automatically reload if you edit Markdown files or the configuration.

## 3. Build the Documentation (Optional)

To build the static site for deployment:

```bash
mkdocs build
```

The output will be in the `site/` directory.

## Troubleshooting
- Make sure you are in the directory containing `mkdocs.yml` when running commands.
- If you get a command not found error, ensure your Python environment's `bin` directory is in your `PATH`.
- For more info, see the [MkDocs documentation](https://www.mkdocs.org/).
