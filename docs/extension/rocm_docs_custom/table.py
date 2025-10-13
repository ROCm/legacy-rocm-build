from sphinx.util.docutils import SphinxDirective, directives, nodes
from pathlib import Path

def setup(app):
    static_assets_dir = Path(__file__).parent / "static"
    app.config.html_static_path.append(str(static_assets_dir))
    app.add_css_file("table.css")

    return {"version": "1.0", "parallel_read_safe": True}
