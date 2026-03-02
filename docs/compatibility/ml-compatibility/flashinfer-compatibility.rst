:orphan:

.. meta::
    :description: FlashInfer compatibility
    :keywords: GPU, LLM, FlashInfer, deep learning, framework compatibility

.. version-set:: rocm_version latest

********************************************************************************
FlashInfer compatibility
********************************************************************************

`FlashInfer <https://docs.flashinfer.ai/index.html>`__ is a library and kernel generator 
for Large Language Models (LLMs) that provides a high-performance implementation of graphics 
processing units (GPUs) kernels. FlashInfer focuses on LLM serving and inference, as well 
as advanced performance across diverse scenarios.

FlashInfer features highly efficient attention kernels, load-balanced scheduling, and memory-optimized 
techniques, while supporting customized attention variants. It’s compatible with ``torch.compile``, and 
offers high-performance LLM-specific operators, with easy integration through PyTorch, and C++ APIs.

.. note::

  The ROCm port of FlashInfer is under active development, and some features are not yet available. 
  For the latest feature compatibility matrix, refer to the ``README`` of the 
  `https://github.com/ROCm/flashinfer <https://github.com/ROCm/flashinfer>`__ repository.

Support overview
================================================================================

- The ROCm-supported version of FlashInfer is maintained in the official `https://github.com/ROCm/flashinfer 
  <https://github.com/ROCm/flashinfer>`__ repository, which differs from the 
  `https://github.com/flashinfer-ai/flashinfer <https://github.com/flashinfer-ai/flashinfer>`__ 
  upstream repository.

- To get started and install FlashInfer on ROCm, use the prebuilt :ref:`Docker images <flashinfer-docker-compat>`, 
  which include ROCm, FlashInfer, and all required dependencies.

  - See the :doc:`ROCm FlashInfer installation guide <rocm-install-on-linux:install/3rd-party/flashinfer-install>` 
    for installation and setup instructions.

  - You can also consult the upstream `Installation guide <https://docs.flashinfer.ai/installation.html>`__ 
    for additional context.

.. _flashinfer-docker-compat:

Compatibility matrix
================================================================================

.. |docker-icon| raw:: html

   <i class="fab fa-docker"></i>

AMD validates and publishes `FlashInfer images <https://hub.docker.com/r/rocm/flashinfer/tags>`__
with ROCm backends on Docker Hub. The following Docker image tag and associated
inventories represent the latest available FlashInfer version from the official Docker Hub. 
Click |docker-icon| to view the image on Docker Hub.

.. list-table:: 
    :header-rows: 1
    :class: docker-image-compatibility

    * - Docker image
      - ROCm
      - FlashInfer
      - PyTorch
      - Ubuntu
      - Python
      - GPU

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/flashinfer/flashinfer-0.2.5.amd2_rocm7.1.1_ubuntu24.04_py3.12_pytorch2.8/images/sha256-9ab6426750a11dbab9bcddeaccaf492683bfd96a1d60b21dd9fc3a609a98175b"><i class="fab fa-docker fa-lg"></i> rocm/flashinfer</a>
      - `7.1.1 <https://repo.radeon.com/rocm/apt/7.1.1/>`__
      - `v0.2.5 <https://github.com/flashinfer-ai/flashinfer/releases/tag/v0.2.5>`__
      - `2.8.0 <https://github.com/ROCm/pytorch/releases/tag/v2.8.0>`__
      - 24.04
      - `3.12 <https://www.python.org/downloads/release/python-3129/>`__
      - MI325X, MI300X

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/flashinfer/flashinfer-0.2.5_rocm6.4_ubuntu24.04_py3.12_pytorch2.7/images/sha256-558914838821c88c557fb6d42cfbc1bdb67d79d19759f37c764a9ee801f93313"><i class="fab fa-docker fa-lg"></i> rocm/flashinfer</a>
      - `6.4.1 <https://repo.radeon.com/rocm/apt/6.4.1/>`__
      - `v0.2.5 <https://github.com/flashinfer-ai/flashinfer/releases/tag/v0.2.5>`__
      - `2.7.1 <https://github.com/ROCm/pytorch/releases/tag/v2.7.1>`__
      - 24.04
      - `3.12 <https://www.python.org/downloads/release/python-3129/>`__
      - MI300X

.. _flashinfer-recommendations:

Use cases and recommendations
================================================================================

FlashInfer on ROCm enables you to perform LLM inference for both prefill and decode:
during prefill, your model efficiently processes input prompts to build KV caches
and internal activations; during decode, it generates tokens sequentially based on
prior outputs and context. Use the attention mode supported upstream (Multi-Head
Attention, Grouped-Query Attention, or Multi-Query Attention) that matches your
model configuration.

FlashInfer on ROCm also includes capabilities such as load balancing, 
sparse and dense attention optimizations, and single and batch decode, alongside
prefill for high‑performance execution on MI300X GPUs.

For currently supported use cases and recommendations, refer to the `AMD ROCm blog <https://rocm.blogs.amd.com/search.html?q=flashinfer>`__, 
where you can search for examples and best practices to optimize your workloads on AMD GPUs.

Previous versions
===============================================================================
See :doc:`rocm-install-on-linux:install/3rd-party/previous-versions/flashinfer-history` to find documentation for previous releases
of the ``ROCm/flashinfer`` Docker image.
