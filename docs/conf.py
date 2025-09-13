# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

import os
import shutil
import sys
from pathlib import Path

gh_release_path = os.path.join("..", "RELEASE.md")
gh_changelog_path = os.path.join("..", "CHANGELOG.md")
sphinx_release_path = os.path.join("about", "release-notes.md")
sphinx_changelog_path = os.path.join("release", "changelog.md")
shutil.copy2(gh_release_path, sphinx_release_path)
shutil.copy2(gh_changelog_path, sphinx_changelog_path)

# Mark the consolidated changelog as orphan to prevent Sphinx from warning about missing toctree entries
with open(sphinx_changelog_path, "r+", encoding="utf-8") as file:
    content = file.read()
    file.seek(0)
    file.write(":orphan:\n" + content)

# Replace GitHub-style [!ADMONITION]s with Sphinx-compatible ```{admonition} blocks
with open(sphinx_changelog_path, "r", encoding="utf-8") as file:
    lines = file.readlines()

    modified_lines = []
    in_admonition_section = False

    # Map for matching the specific admonition type to its corresponding Sphinx markdown syntax
    admonition_types = {
        '> [!NOTE]': '```{note}',
        '> [!TIP]': '```{tip}',
        '> [!IMPORTANT]': '```{important}',
        '> [!WARNING]': '```{warning}',
        '> [!CAUTION]': '```{caution}'
    }

    for line in lines:
        if any(line.startswith(k) for k in admonition_types):
            for key in admonition_types:
                if(line.startswith(key)):
                    modified_lines.append(admonition_types[key] + '\n')
                    break
            in_admonition_section = True
        elif in_admonition_section:
            if line.strip() == '':
                # If we encounter an empty line, close the admonition section
                modified_lines.append('```\n\n')  # Close the admonition block
                in_admonition_section = False
            else:
                modified_lines.append(line.lstrip('> '))
        else:
            modified_lines.append(line)

    # In case the file ended while still in a admonition section, close it
    if in_admonition_section:
        modified_lines.append('```')

    file.close()

    with open(sphinx_changelog_path, "w", encoding="utf-8") as file:
        file.writelines(modified_lines)

matrix_path = os.path.join("compatibility", "compatibility-matrix-historical-6.0.csv")
rtd_path = os.path.join("..", "_readthedocs", "html", "downloads")
if not os.path.exists(rtd_path):
    os.makedirs(rtd_path)
shutil.copy2(matrix_path, rtd_path)

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
all_article_info_os = ["linux", "windows"]
all_article_info_author = ""

# pages with specific settings
article_pages = [
    {"file": "about/release-notes", "os": ["linux"], "date": "2025-09-16"},
    {"file": "release/changelog", "os": ["linux"],},
    {"file": "compatibility/compatibility-matrix", "os": ["linux"]},
    {"file": "compatibility/ml-compatibility/pytorch-compatibility", "os": ["linux"]},
    {"file": "compatibility/ml-compatibility/tensorflow-compatibility", "os": ["linux"]},
    {"file": "compatibility/ml-compatibility/jax-compatibility", "os": ["linux"]},
    {"file": "compatibility/ml-compatibility/verl-compatibility", "os": ["linux"]},
    {"file": "compatibility/ml-compatibility/stanford-megatron-lm-compatibility", "os": ["linux"]},
    {"file": "compatibility/ml-compatibility/dgl-compatibility", "os": ["linux"]},
    {"file": "compatibility/ml-compatibility/megablocks-compatibility", "os": ["linux"]},
    {"file": "compatibility/ml-compatibility/taichi-compatibility", "os": ["linux"]},
    {"file": "compatibility/ml-compatibility/ray-compatibility", "os": ["linux"]},
    {"file": "compatibility/ml-compatibility/llama-cpp-compatibility", "os": ["linux"]},
    {"file": "how-to/deep-learning-rocm", "os": ["linux"]},

    {"file": "how-to/rocm-for-ai/index", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/install", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/system-health-check", "os": ["linux"]},

    {"file": "how-to/rocm-for-ai/training/index", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/train-a-model", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/prerequisite-system-validation", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/scale-model-training", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/benchmark-docker/megatron-lm", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/benchmark-docker/previous-versions/megatron-lm-history", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/benchmark-docker/previous-versions/megatron-lm-v24.12-dev", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/benchmark-docker/previous-versions/megatron-lm-v25.3", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/benchmark-docker/previous-versions/megatron-lm-v25.4", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/benchmark-docker/previous-versions/megatron-lm-v25.5", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/benchmark-docker/previous-versions/megatron-lm-v25.6", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/benchmark-docker/previous-versions/megatron-lm-primus-migration-guide", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/benchmark-docker/primus-megatron", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/benchmark-docker/pytorch-training", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/benchmark-docker/previous-versions/pytorch-training-history", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/benchmark-docker/previous-versions/pytorch-training-v25.3", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/benchmark-docker/previous-versions/pytorch-training-v25.4", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/benchmark-docker/previous-versions/pytorch-training-v25.5", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/benchmark-docker/previous-versions/pytorch-training-v25.6", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/benchmark-docker/previous-versions/pytorch-training-v25.7", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/benchmark-docker/primus-pytorch", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/benchmark-docker/pytorch-training", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/benchmark-docker/jax-maxtext", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/benchmark-docker/previous-versions/jax-maxtext-history", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/benchmark-docker/previous-versions/jax-maxtext-v25.4", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/benchmark-docker/previous-versions/jax-maxtext-v25.5", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/training/benchmark-docker/mpt-llm-foundry", "os": ["linux"]},

    {"file": "how-to/rocm-for-ai/fine-tuning/index", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/fine-tuning/overview", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/fine-tuning/fine-tuning-and-inference", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/fine-tuning/single-gpu-fine-tuning-and-inference", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/fine-tuning/multi-gpu-fine-tuning-and-inference", "os": ["linux"]},

    {"file": "how-to/rocm-for-ai/inference/index", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference/hugging-face-models", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference/llm-inference-frameworks", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference/benchmark-docker/vllm", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference/benchmark-docker/previous-versions/vllm-history", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference/benchmark-docker/previous-versions/vllm-0.4.3", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference/benchmark-docker/previous-versions/vllm-0.6.4", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference/benchmark-docker/previous-versions/vllm-0.6.6", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference/benchmark-docker/previous-versions/vllm-0.7.3-20250325", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference/benchmark-docker/previous-versions/vllm-0.8.3-20250415", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference/benchmark-docker/previous-versions/vllm-0.8.5-20250513", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference/benchmark-docker/previous-versions/vllm-0.8.5-20250521", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference/benchmark-docker/previous-versions/vllm-0.9.0.1-20250605", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference/benchmark-docker/previous-versions/vllm-0.9.0.1-20250702", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference/benchmark-docker/previous-versions/vllm-0.9.1-20250702", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference/benchmark-docker/previous-versions/vllm-0.9.1-20250715", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference/benchmark-docker/previous-versions/vllm-0.10.0-20250812", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference/benchmark-docker/previous-versions/sglang-history", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference/benchmark-docker/pytorch-inference", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference/deploy-your-model", "os": ["linux"]},

    {"file": "how-to/rocm-for-ai/inference-optimization/index", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference-optimization/model-quantization", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference-optimization/model-acceleration-libraries", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference-optimization/optimizing-with-composable-kernel", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference-optimization/optimizing-triton-kernel", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference-optimization/profiling-and-debugging", "os": ["linux"]},
    {"file": "how-to/rocm-for-ai/inference-optimization/workload", "os": ["linux"]},

    {"file": "how-to/system-optimization/index", "os": ["linux"]},
    {"file": "how-to/system-optimization/mi300x", "os": ["linux"]},
    {"file": "how-to/system-optimization/mi200", "os": ["linux"]},
    {"file": "how-to/system-optimization/mi100", "os": ["linux"]},
    {"file": "how-to/system-optimization/w6000-v620", "os": ["linux"]},
    {"file": "how-to/tuning-guides/mi300x/index", "os": ["linux"]},
    {"file": "how-to/tuning-guides/mi300x/system", "os": ["linux"]},
    {"file": "how-to/tuning-guides/mi300x/workload", "os": ["linux"]},
    {"file": "how-to/system-debugging", "os": ["linux"]},
    {"file": "how-to/gpu-enabled-mpi", "os": ["linux"]},
]

external_toc_path = "./sphinx/_toc.yml"

# Add the _extensions directory to Python's search path
sys.path.append(str(Path(__file__).parent / 'extension'))

extensions = ["rocm_docs", "sphinx_reredirects", "sphinx_sitemap", "sphinxcontrib.datatemplates", "version-ref", "csv-to-list-table"]

compatibility_matrix_file = str(Path(__file__).parent / 'compatibility/compatibility-matrix-historical-6.0.csv')

external_projects_current_project = "rocm"

# Uncomment if facing rate limit exceed issue with local build
# external_projects_remote_repository = ""

html_baseurl = os.environ.get("READTHEDOCS_CANONICAL_URL", "https://rocm-stg.amd.com/")
html_context = {}
if os.environ.get("READTHEDOCS", "") == "True":
    html_context["READTHEDOCS"] = True

html_theme = "rocm_docs_theme"
html_theme_options = {"flavor": "rocm-docs-home"}

html_static_path = ["sphinx/static/css", "extension/how-to/rocm-for-ai/inference"]
html_css_files = ["rocm_custom.css", "rocm_rn.css", "vllm-benchmark.css"]
html_js_files = ["vllm-benchmark.js"]

html_title = "ROCm Documentation"

html_theme_options = {"link_main_doc": False}

redirects = {"reference/openmp/openmp": "../../about/compatibility/openmp.html"}

numfig = False
suppress_warnings = ["autosectionlabel.*"]

html_context = {
    "project_path" : {project_path},
    "gpu_type" : [('AMD Instinct accelerators', 'intrinsic'), ('AMD gfx families', 'gfx'), ('NVIDIA families', 'nvidia') ],
    "atomics_type" : [('HW atomics', 'hw-atomics'), ('CAS emulation', 'cas-atomics')],
    "pcie_type" : [('No PCIe atomics', 'nopcie'), ('PCIe atomics', 'pcie')],
    "memory_type" : [('Device DRAM', 'device-dram'), ('Migratable Host DRAM', 'migratable-host-dram'), ('Pinned Host DRAM', 'pinned-host-dram')],
    "granularity_type" : [('Coarse-grained', 'coarse-grained'), ('Fine-grained', 'fine-grained')],
    "scope_type" : [('Device', 'device'), ('System', 'system')]
}
