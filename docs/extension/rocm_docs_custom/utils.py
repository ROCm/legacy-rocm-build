import json
import html
from docutils import nodes
from sphinx.util import logging

def normalize_key(key):
    return key.replace(" ", "_").lower().strip()


def register_output_flags(app):
    """Register the shared output-generation toggles (idempotently).

    Both the matrix and selector extensions read these flags, and either may be
    loaded first, so registration must not fail if the value already exists:

    - ``rocm_selector_pdf_generation``: when False, custom matrix/selector
      content is omitted from PDF (LaTeX) output instead of being converted to
      static tables/sections.
    - ``rocm_selector_markdown_generation``: when False, custom matrix/selector
      content is dropped from Markdown (llms-full.txt) output.
    """
    for name in ("rocm_selector_pdf_generation", "rocm_selector_markdown_generation"):
        if name not in app.config:
            app.add_config_value(name, True, "env")


def noop(translator, node):
    """No-op visit/depart handler for builders that render nothing."""
    pass


def skip_node(translator, node):
    """Visit handler that skips a node and its children entirely."""
    raise nodes.SkipNode


def make_unique_id(document, base, node=None):
    """Return an ID derived from *base* that is unique within *document*.

    ``nodes.make_id`` alone can collide when the same heading (e.g.
    "Prerequisites") appears in several conditional blocks. This appends a
    numeric suffix on collision and registers the chosen ID in
    ``document.ids`` so subsequent calls (and Sphinx's own reference
    resolution) see it as taken. Falls back to a slug for bases that
    ``make_id`` reduces to empty (e.g. starting with a digit).

    Pass *node* to register the owning element; otherwise the ID maps to the
    document, which is enough to reserve it against future collisions.
    """
    base_id = nodes.make_id(base) or "id-" + base.replace(".", "-").replace(" ", "-").lower()
    candidate = base_id
    counter = 1
    existing = document.ids
    while candidate in existing:
        counter += 1
        candidate = f"{base_id}-{counter}"
    existing[candidate] = node if node is not None else document
    return candidate

def kv_to_data_attr(name, kv_str, separator="="):
    """
    Convert key=value pairs delimited by spaces to stringified JSON.
    Format it as an HTML data attribute.

    Args:
        name: Name of the data attribute; it will be prefixed with "data-" for conventional HTML.
        condition_str: String in format "key=value os=ubuntu".

    Example output:
        'data-show-cond="{"os": "ubuntu"}"'
    """
    pairs = {}
    for token in kv_str.split():
        token = token.strip()
        if not token or separator not in token:
            continue

        key, value = token.split(separator, 1)
        if key and value:
            pairs.setdefault(key, []).append(value.strip())

    return f'data-{name}="{html.escape(json.dumps(pairs))}"' if pairs else ""


logger = logging.getLogger(__name__)

