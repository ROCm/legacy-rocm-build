# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

import os
import shutil
import sys
from pathlib import Path

ROCM_VERSION = "7.9.0"
GA_DATE = "2025-10-20"

DOCS_DIR = Path(__file__).parent.resolve()
ROOT_DIR = DOCS_DIR.parent


def copy_rtd_file(src_path: Path, dest_path: Path):
    dest_path.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src_path, dest_path)
    print(f"📁 Copied {src_path} → {dest_path}")


# compat_matrix_src = DOCS_DIR / "compatibility" / "compatibility-matrix-historical-6.0.csv" # fmt: skip
# compat_matrix_dest = ROOT_DIR / "_readthedocs" / "html" / "downloads" / "compatibility-matrix-historical-6.0.csv"  # fmt: skip
# copy_rtd_file(compat_matrix_src, compat_matrix_dest)

gh_release_path = ROOT_DIR / "RELEASE.md"
rtd_release_path = DOCS_DIR / "about" / "release-notes.md"
copy_rtd_file(gh_release_path, rtd_release_path)

# gh_changelog_path = ROOT_DIR / "CHANGELOG.md"
# rtd_changelog_path = DOCS_DIR / "release" / "changelog.md"
# copy_rtd_file(gh_changelog_path, rtd_changelog_path)


# Mark the consolidated changelog as orphan to prevent Sphinx from warning about missing toctree entries
# with open(rtd_changelog_path, "r+", encoding="utf-8") as file:
#     content = file.read()
#     file.seek(0)
#     file.write(":orphan:\n" + content)
#
# # Replace GitHub-style [!ADMONITION]s with Sphinx-compatible ```{admonition} blocks
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

html_baseurl = os.environ.get("READTHEDOCS_CANONICAL_URL", "rocm.docs.amd.com")
html_context = {}

# configurations for PDF output by Read the Docs
project = "ROCm Documentation"
project_path = str(DOCS_DIR).replace("\\", "/")
author = "Advanced Micro Devices, Inc."
copyright = "Copyright (c) %Y Advanced Micro Devices, Inc. All rights reserved."
version = ROCM_VERSION
release = ROCM_VERSION
setting_all_article_info = True
all_article_info_os = ["linux", "windows"]
all_article_info_author = ""

# pages with specific settings
article_pages = [
    {"file": "about/release-notes", "date": GA_DATE},
]

external_toc_path = "./sphinx/_toc.yml"

# Register Sphinx extensions and static assets
sys.path.append(str(DOCS_DIR / "extension"))

# "sphinx/static/css", "extension/how-to/rocm-for-ai/inference"]
# html_css_files = [
    # "rocm_custom.css",
    # "rocm_rn.css",
    # "dynamic_picker.css",
    # "vllm-benchmark.css",
# ]
templates_path = ["extension/rocm_docs_custom/templates", "extension/templates"]

extensions = [
    "rocm_docs",
    "rocm_docs_custom.selector",
    "rocm_docs_custom.table",
    "rocm_docs_custom.icon",
    # "sphinx_reredirects",
    # "sphinx_sitemap",
    # "sphinxcontrib.datatemplates",
    # "version-ref",
    # "csv-to-list-table",
]

# compatibility_matrix_file = str(
#     DOCS_DIR / "compatibility/compatibility-matrix-historical-6.0.csv"
# )

external_projects_current_project = "rocm"
html_theme = "rocm_docs_theme"
html_theme_options = {
    "announcement": "This is ROCm 7.9.0 technology preview release documentation. For production use, refer to <a id='rocm-banner' href='https://rocm.docs.amd.com/en/latest/'>ROCm 7.1.0 documentation</a>.",
    "flavor": "generic",
    "header_title": "ROCm™ 7.9.0 Preview",
    "header_link": "https://rocm.docs.amd.com/en/7.9.0-preview/index.html",
    "version_list_link": "https://rocm.docs.amd.com/en/7.9.0-preview/release/versions.html",
    "nav_secondary_items": {
        "GitHub": "https://github.com/ROCm/ROCm",
        "Community": "https://github.com/ROCm/ROCm/discussions",
        "Blogs": "https://rocm.blogs.amd.com/",
        "Instinct™ Docs": "https://instinct.docs.amd.com/",
        "Support": "https://github.com/ROCm/ROCm/issues/new/choose",
    },
    "link_main_doc": False,
    "secondary_sidebar_items": {
        "**": ["page-toc"],
        "install/rocm": ["selector-toc2"],
        "compatibility/compatibility-matrix": ["selector-toc2"],
    }
}
html_title = f"AMD ROCm {ROCM_VERSION} preview"

numfig = False
suppress_warnings = ["autosectionlabel.*"]

# html_baseurl = os.environ.get("READTHEDOCS_CANONICAL_URL", "https://rocm-stg.amd.com/")
# html_context = {
#     "project_path": {project_path},
#     "gpu_type": [
#         ("AMD Instinct accelerators", "intrinsic"),
#         ("AMD gfx families", "gfx"),
#         ("NVIDIA families", "nvidia"),
#     ],
#     "atomics_type": [("HW atomics", "hw-atomics"), ("CAS emulation", "cas-atomics")],
#     "pcie_type": [("No PCIe atomics", "nopcie"), ("PCIe atomics", "pcie")],
#     "memory_type": [
#         ("Device DRAM", "device-dram"),
#         ("Migratable Host DRAM", "migratable-host-dram"),
#         ("Pinned Host DRAM", "pinned-host-dram"),
#     ],
#     "granularity_type": [
#         ("Coarse-grained", "coarse-grained"),
#         ("Fine-grained", "fine-grained"),
#     ],
#     "scope_type": [("Device", "device"), ("System", "system")],
# }
if os.environ.get("READTHEDOCS", "") == "True":
    html_context["READTHEDOCS"] = True

# temporary settings to speed up docs build for faster iteration
# external_projects_remote_repository = ""
# external_toc_exclude_missing = True
