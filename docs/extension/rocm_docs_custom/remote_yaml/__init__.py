"""
Sphinx extension that assembles the precision-support YAML at build time by
fetching per-component YAML files from their source repositories.

At builder-inited time, reads a meta YAML (precision-support-meta.yaml) that
contains the structural skeleton (groups, libraries, tags, doc_links) plus a
`source` block per library. For each library it fetches the component's
precision-support.yaml from GitHub raw content, extracts `data_types`, and
writes the assembled result to the path that datatemplate:yaml expects.

Source block options (mirroring remote-content where applicable):
  repo           GitHub repo in "owner/name" form.
  path           Path to the precision-support.yaml within the repo.
  default_branch Branch to use when not building from a version tag.
  tag_prefix     Optional prefix prepended to the version tag in release
                 builds (e.g. "docs/" produces ref "docs/6.4.0").
"""

import re
from pathlib import Path

import requests
import yaml
from sphinx.util import logging

logger = logging.getLogger(__name__)

META_FILENAME = "precision-support-meta.yaml"
OUTPUT_FILENAME = "precision-support.yaml"
GITHUB_RAW_BASE = "https://raw.githubusercontent.com"


def get_target_ref(source: dict, html_context: dict) -> str:
    """Resolve the git ref to fetch from, matching remote-content logic."""
    if html_context.get("official_branch") == 0:
        version = html_context.get("version", "")
        if re.match(r"^\d+\.\d+\.\d+$", version):
            tag_prefix = source.get("tag_prefix", "")
            return f"{tag_prefix}{version}"

    default_branch = source.get("default_branch")
    if not default_branch:
        logger.warning(
            "remote_yaml: no default_branch specified and not building from a "
            "version tag — skipping source fetch"
        )
        return ""
    return default_branch


def fetch_data_types(source: dict, ref: str) -> list:
    """Fetch a component's precision-support.yaml and return its data_types."""
    repo = source["repo"]
    path = source["path"].lstrip("/")
    url = f"{GITHUB_RAW_BASE}/{repo}/{ref}/{path}"

    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
    except requests.RequestException as exc:
        raise RuntimeError(
            f"remote_yaml: failed to fetch {url}: {exc}"
        ) from exc

    try:
        data = yaml.safe_load(response.text)
    except yaml.YAMLError as exc:
        raise RuntimeError(
            f"remote_yaml: failed to parse YAML from {url}: {exc}"
        ) from exc

    if "data_types" not in data:
        raise RuntimeError(
            f"remote_yaml: no 'data_types' key in {url}"
        )
    return data["data_types"]


def assemble_precision_support(app):
    """builder-inited handler: fetch and assemble the precision-support YAML."""
    data_dir = Path(app.srcdir) / "data" / "reference" / "precision-support"
    meta_path = data_dir / META_FILENAME
    output_path = data_dir / OUTPUT_FILENAME

    if not meta_path.exists():
        raise FileNotFoundError(
            f"remote_yaml: meta file not found: {meta_path}. "
            "Cannot assemble precision-support.yaml."
        )

    with open(meta_path, encoding="utf-8") as f:
        meta = yaml.safe_load(f)

    html_context = getattr(app.config, "html_context", {})
    assembled = {"library_groups": []}

    for group in meta.get("library_groups", []):
        assembled_group = {
            "group": group["group"],
            "tag": group["tag"],
            "libraries": [],
        }

        for library in group.get("libraries", []):
            source = library.get("source", {})
            ref = get_target_ref(source, html_context)
            data_types = fetch_data_types(source, ref) if ref else []

            assembled_group["libraries"].append(
                {
                    "name": library["name"],
                    "tag": library["tag"],
                    "doc_link": library["doc_link"],
                    "data_types": data_types,
                }
            )

        assembled["library_groups"].append(assembled_group)

    output_path.parent.mkdir(parents=True, exist_ok=True)
    with open(output_path, "w", encoding="utf-8") as f:
        yaml.dump(assembled, f, allow_unicode=True, sort_keys=False)

    logger.info("remote_yaml: assembled precision-support.yaml successfully")


def setup(app):
    app.connect("builder-inited", assemble_precision_support)
    return {
        "version": "0.1",
        "parallel_read_safe": True,
        "parallel_write_safe": True,
    }
