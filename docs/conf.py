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
version = "7.0 Alpha 2"
release = "7.0 Alpha 2"
setting_all_article_info = True
all_article_info_os = ["linux", "windows"]
all_article_info_author = ""

# pages with specific settings
article_pages = [
    {"file": "preview/index", "os": ["linux"],},
    {"file": "preview/release", "os": ["linux"],},
    {"file": "preview/versions", "os": ["linux"],},
    {"file": "preview/install/index", "os": ["linux"],},
    {"file": "preview/install/instinct-driver", "os": ["linux"],},
    {"file": "preview/install/rocm", "os": ["linux"],},
    {"file": "preview/benchmark-docker/index", "os": ["linux"],},
    {"file": "preview/benchmark-docker/training", "os": ["linux"],},
    {"file": "preview/benchmark-docker/pre-training-megatron-lm-llama-3-8b", "os": ["linux"],},
    {"file": "preview/benchmark-docker/pre-training-torchtitan-llama-3-70b", "os": ["linux"],},
    {"file": "preview/benchmark-docker/fine-tuning-lora-llama-2-70b", "os": ["linux"],},
    {"file": "preview/benchmark-docker/inference", "os": ["linux"],},
    {"file": "preview/benchmark-docker/inference-vllm-llama-3.1-405b-fp4", "os": ["linux"],},
    {"file": "preview/benchmark-docker/inference-sglang-deepseek-r1-fp4", "os": ["linux"],},
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
html_js_files = ["preview-version-list.js"]

html_title = "ROCm 7.0 Alpha 2 documentation"

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
