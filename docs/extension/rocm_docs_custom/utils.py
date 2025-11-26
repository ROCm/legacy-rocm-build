import json
import html
from sphinx.util import logging

def normalize_key(key):
    return key.replace(" ", "_").lower().strip()

def kv_to_data_attr(name, kv_str, separator="="):
    """
    Convert key=value pairs delimited by spaces to stringified JSON.
    Format it as an HTML data attribute.

    Args:
        name: Name of the data attribute; it will be prefixed with "data-".
        condition_str: String in format "key=value os=ubuntu".

    Example output:
        'data-show-when="{"os": "ubuntu"}"'
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

