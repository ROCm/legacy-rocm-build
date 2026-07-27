# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

import os
import re
import shutil
import sys
from pathlib import Path
from subprocess import run

ROCM_VERSION = "7.14.0"
GA_DATE = "2026-07-15"

DOCS_DIR = Path(__file__).parent.resolve()
ROOT_DIR = DOCS_DIR.parent


def copy_rtd_file(src_path: Path, dest_path: Path):
    dest_path.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src_path, dest_path)
    print(f"📁 Copied {src_path} → {dest_path}")


gh_changelog_path = ROOT_DIR / "CHANGELOG.md"
rtd_changelog_path = DOCS_DIR / "release" / "changelog.md"
copy_rtd_file(gh_changelog_path, rtd_changelog_path)


# Mark the consolidated changelog as orphan to prevent Sphinx from warning about missing toctree entries
with open(rtd_changelog_path, "r+", encoding="utf-8") as file:
    content = file.read()
    file.seek(0)
    file.write(":orphan:\n" + content)

# Replace GitHub-style [!ADMONITION]s with Sphinx-compatible ```{admonition} blocks
# with open(rtd_changelog_path, "r", encoding="utf-8") as file:
#     lines = file.readlines()
#
#     modified_lines = []
#     in_admonition_section = False
#
#     # Map for matching the specific admonition type to its corresponding Sphinx markdown syntax
#     admonition_types = {
#         "> [!NOTE]": "```{note}",
#         "> [!TIP]": "```{tip}",
#         "> [!IMPORTANT]": "```{important}",
#         "> [!WARNING]": "```{warning}",
#         "> [!CAUTION]": "```{caution}",
#     }
#
#     for line in lines:
#         if any(line.startswith(k) for k in admonition_types):
#             for key in admonition_types:
#                 if line.startswith(key):
#                     modified_lines.append(admonition_types[key] + "\n")
#                     break
#             in_admonition_section = True
#         elif in_admonition_section:
#             if line.strip() == "":
#                 # If we encounter an empty line, close the admonition section
#                 modified_lines.append("```\n\n")  # Close the admonition block
#                 in_admonition_section = False
#             else:
#                 modified_lines.append(line.lstrip("> "))
#         else:
#             modified_lines.append(line)
#
#     # In case the file ended while still in a admonition section, close it
#     if in_admonition_section:
#         modified_lines.append("```")
#
#     file.close()
#
#     with open(rtd_changelog_path, "w", encoding="utf-8") as file:
#         file.writelines(modified_lines)
#
# matrix_path = os.path.join("compatibility", "compatibility-matrix-historical-6.0.csv")
# rtd_path = os.path.join("..", "_readthedocs", "html", "downloads")
# if not os.path.exists(rtd_path):
#     os.makedirs(rtd_path)
# shutil.copy2(matrix_path, rtd_path)

latex_engine = "xelatex"
latex_elements = {
    "fontpkg": r"""
\usepackage{tgtermes}
\usepackage{tgheros}
\renewcommand\ttdefault{txtt}
"""
}

# configurations for PDF output by Read the Docs
project = "ROCm documentation"
project_path = str(DOCS_DIR).replace("\\", "/")
author = "Advanced Micro Devices, Inc."
copyright = "Copyright (c) %Y Advanced Micro Devices, Inc. All rights reserved."
version = ROCM_VERSION
release = ROCM_VERSION

setting_all_article_info = False
all_article_info_os = ["linux", "windows"]
all_article_info_author = ""
# pages with specific settings
article_pages = [
    {"file": "about/release-notes", "date": GA_DATE, "os": ["linux", "windows"]},
    {"file": "compatibility/compatibility-matrix"},
]

external_toc_path = "./sphinx/_toc.yml"

# Register Sphinx extensions and static assets
sys.path.append(str(DOCS_DIR / "extension"))
extensions = [
    "rocm_docs",
    "rocm_docs_custom.selector",
    "rocm_docs_custom.matrix",
    "rocm_docs_custom.icon",
    "rocm_docs_custom.csv_list_to_table",
    "rocm_docs_custom.remote_content",
    "rocm_docs_custom.remote_yaml",
    "rocm_docs_custom.version_ref",
    "rocm_docs_custom.merge_components",
    "sphinxcontrib.datatemplates",
    "sphinx_substitution_extensions",
    # "sphinx_reredirects",
    # "sphinx_sitemap",
]
templates_path = ["extension/rocm_docs_custom/selector/templates"]

# Omit custom matrix/selector content from PDF (LaTeX) output.
rocm_selector_pdf_generation = False

# Generate llms.txt and llms-full.txt (requires the rocm-docs-core[llms] extra).
rocm_docs_generate_llms = True
# The GPU atomics operation page is very large; keep it in the llms.txt index
# but exclude its body from llms-full.txt.
rocm_docs_llms_full_exclude = ["reference/gpu-atomics-operation"]

html_static_path = ["sphinx/static"]
html_js_files = ["setup-toc-install-headings.js", "legacy/vllm-benchmark.js"]
html_css_files = ["legacy/vllm-benchmark.css"]

# this is used for framework compat pages
# compatibility_matrix_file = str(
#     DOCS_DIR / "compatibility/compatibility-matrix-historical-6.0.csv"
# )

external_projects_current_project = "rocm"
html_theme = "rocm_docs_theme"
html_theme_options = {
    "announcement": f"Looking for an older ROCm release? See the <a id='rocm-banner' href='https://rocm.docs.amd.com/en/latest/release/versions.html'>ROCm release history</a>.",
    "flavor": "rocm",
    "use_download_button": True,
    "link_main_doc": False,
    "repository_url": "https://github.com/ROCm/ROCm",
    "use_repository_button": True,
    "use_issues_button": True,
    # "secondary_sidebar_items": {
        # "training/Primus**": ["framework-version-toc2"],
        # "**": ["framework-version-toc2"],
    # },
}
html_title = f"AMD ROCm {ROCM_VERSION}"

html_baseurl = os.environ.get("READTHEDOCS_CANONICAL_URL", "rocm.docs.amd.com")
html_context = {
    "project_path": {project_path},
    "gpu_type": [
        ("AMD Instinct accelerators", "intrinsic"),
        ("AMD gfx families", "gfx"),
        ("NVIDIA families", "nvidia"),
    ],
    "atomics_type": [("HW atomics", "hw-atomics"), ("CAS emulation", "cas-atomics")],
    "pcie_type": [("No PCIe atomics", "nopcie"), ("PCIe atomics", "pcie")],
    "memory_type": [
        ("Device DRAM", "device-dram"),
        ("Migratable Host DRAM", "migratable-host-dram"),
        ("Pinned Host DRAM", "pinned-host-dram"),
    ],
    "granularity_type": [
        ("Coarse-grained", "coarse-grained"),
        ("Fine-grained", "fine-grained"),
    ],
    "scope_type": [("Device", "device"), ("System", "system")],
}
if os.environ.get("READTHEDOCS", "") == "True":
    html_context["READTHEDOCS"] = True

# For substitutions in MyST Markdown and rST files.
# Usage:
#   ```md              | ```rst
#   {{ ROCM_VERSION }} | |ROCM_VERSION|
#   ```                | ```
myst_substitutions = {"ROCM_VERSION": ROCM_VERSION}
rst_prolog = "\n".join(
    f".. |{key}| replace:: {val}" for key, val in myst_substitutions.items()
)

numfig = False

exclude_patterns = [
    "exclude/**",
    "**/include/**",
    "**/extension/**",
    "**/images/**",
]
# suppress_warnings = ["autosectionlabel.*"]

# Check if the branch is a docs/ branch
official_branch = run(
    ["git", "rev-parse", "--abbrev-ref", "HEAD"], capture_output=True, text=True
).stdout.find("docs/")

rocdoc_components_data_current = DOCS_DIR / "data" / "components.yaml"
rocdoc_components_data_previous = DOCS_DIR / "data" / "components-previous.yaml"
rocdoc_components_data_default = DOCS_DIR / "data" / "components-default.yaml"
rocdoc_components_data_output = DOCS_DIR / "_data" / "components.yaml"
