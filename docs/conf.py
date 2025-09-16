# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

import os
import sys
from pathlib import Path

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
if os.environ.get("READTHEDOCS", "") == "True":
    html_context["READTHEDOCS"] = True

# configurations for PDF output by Read the Docs
project = "ROCm Documentation"
project_path = os.path.abspath(".").replace("\\", "/")
author = "Advanced Micro Devices, Inc."
copyright = "Copyright (c) 2025 Advanced Micro Devices, Inc. All rights reserved."
version = "7.0.0"
release = "7.0.0"
setting_all_article_info = True
all_article_info_os = ["linux"]
all_article_info_author = ""

article_pages = [
    {"file": "preview/release", "date": "2025-08-07",},
]

external_toc_path = "./sphinx/_toc.yml"
external_projects_remote_repository = "" # don't fetch data to resolve intersphinx xrefs

# Add the _extensions directory to Python's search path
sys.path.append(str(Path(__file__).parent / 'extension'))

extensions = ["rocm_docs", "sphinx_reredirects", "sphinx_sitemap", "sphinxcontrib.datatemplates", "version-ref", "csv-to-list-table"]

external_projects_current_project = "rocm"

html_baseurl = os.environ.get("READTHEDOCS_CANONICAL_URL", "https://rocm-stg.amd.com/")
html_context = {}
if os.environ.get("READTHEDOCS", "") == "True":
    html_context["READTHEDOCS"] = True

html_theme = "rocm_docs_theme"
html_theme_options = {"flavor": "rocm-docs-home"}

html_static_path = ["sphinx/static/css", "sphinx/static/js"]
html_css_files = ["rocm_custom.css", "rocm_rn.css"]

html_title = "ROCm 7.0 AI Training and Inference Performance"

html_theme_options = {"link_main_doc": False}

numfig = False

html_context = {
    "project_path" : {project_path},
    "gpu_type" : [('AMD Instinct accelerators', 'intrinsic'), ('AMD gfx families', 'gfx'), ('NVIDIA families', 'nvidia') ],
    "atomics_type" : [('HW atomics', 'hw-atomics'), ('CAS emulation', 'cas-atomics')],
    "pcie_type" : [('No PCIe atomics', 'nopcie'), ('PCIe atomics', 'pcie')],
    "memory_type" : [('Device DRAM', 'device-dram'), ('Migratable Host DRAM', 'migratable-host-dram'), ('Pinned Host DRAM', 'pinned-host-dram')],
    "granularity_type" : [('Coarse-grained', 'coarse-grained'), ('Fine-grained', 'fine-grained')],
    "scope_type" : [('Device', 'device'), ('System', 'system')]
}
