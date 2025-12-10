:orphan:

.. meta::
   :description: verl compatibility
   :keywords: GPU, verl, deep learning, framework compatibility

.. version-set:: rocm_version latest

*******************************************************************************
verl compatibility
*******************************************************************************

Volcano Engine Reinforcement Learning for LLMs (`verl <https://verl.readthedocs.io/en/latest/>`__)  
is a reinforcement learning framework designed for large language models (LLMs). 
verl offers a scalable, open-source fine-tuning solution by using a hybrid programming model 
that makes it easy to define and run complex post-training dataflows efficiently. 

Its modular APIs separate computation from data, allowing smooth integration with other frameworks. 
It also supports flexible model placement across GPUs for efficient scaling on different cluster sizes.
verl achieves high training and generation throughput by building on existing LLM frameworks. 
Its 3D-HybridEngine reduces memory use and communication overhead when switching between training 
and inference, improving overall performance.

Support overview
================================================================================

- The ROCm-supported version of verl is maintained in the official `https://github.com/ROCm/verl 
  <https://github.com/ROCm/verl>`__ repository, which differs from the 
  `https://github.com/volcengine/verl <https://github.com/volcengine/verl>`__ upstream repository.

- To get started and install verl on ROCm, use the prebuilt :ref:`Docker image <verl-docker-compat>`, 
  which includes ROCm, verl, and all required dependencies.

  - See the :doc:`ROCm verl installation guide <rocm-install-on-linux:install/3rd-party/verl-install>`
    for installation and setup instructions.

  - You can also consult the upstream `verl documentation <https://verl.readthedocs.io/en/latest/>`__ 
    for additional context.

Version support
--------------------------------------------------------------------------------

verl is supported on `ROCm 7.0.0 <https://repo.radeon.com/rocm/apt/7.0/>`__ and
`ROCm 6.2.0 <https://repo.radeon.com/rocm/apt/6.2/>`__.

Supported devices
--------------------------------------------------------------------------------

**Officially Supported**: AMD Instinct™ MI300X

.. _verl-recommendations:

Use cases and recommendations
================================================================================

* The benefits of verl in large-scale reinforcement learning from human feedback 
  (RLHF) are discussed in the `Reinforcement Learning from Human Feedback on AMD 
  GPUs with verl and ROCm Integration <https://rocm.blogs.amd.com/artificial-intelligence/verl-large-scale/README.html>`__ 
  blog. The blog post outlines how the Volcano Engine Reinforcement Learning 
  (verl) framework integrates with the AMD ROCm platform to optimize training on 
  AMD Instinct™ GPUs. The guide details the process of building a Docker image, 
  setting up single-node and multi-node training environments, and highlights 
  performance benchmarks demonstrating improved throughput and convergence accuracy. 
  This resource serves as a comprehensive starting point for deploying verl on AMD GPUs, 
  facilitating efficient RLHF training workflows.

.. _verl-supported_features:

Supported features
===============================================================================

The following table shows verl on ROCm support for GPU-accelerated modules.

.. list-table::
    :header-rows: 1

    * - Module
      - Description
      - verl version
      - ROCm version
    * - ``FSDP``
      - Training engine
      - 
       * 0.6.0
       * 0.3.0.post0
      - 
       * 7.0.0
       * 6.2.0
    * - ``vllm``
      - Inference engine
      - 
       * 0.6.0
       * 0.3.0.post0
      - 
       * 7.0.0
       * 6.2.0

.. _verl-docker-compat:

Docker image compatibility
================================================================================

.. |docker-icon| raw:: html

   <i class="fab fa-docker"></i>

AMD validates and publishes `verl Docker images <https://hub.docker.com/r/rocm/verl/tags>`_
with ROCm backends on Docker Hub. The following Docker image tag and associated inventories 
represent the latest verl version from the official Docker Hub. 
Click |docker-icon| to view the image on Docker Hub.

.. list-table::
   :header-rows: 1
   :class: docker-image-compatibility

   * - Docker image
     - ROCm
     - verl
     - Ubuntu
     - PyTorch
     - Python
     - vllm

   * - .. raw:: html

        <a href="https://hub.docker.com/layers/rocm/verl/verl-0.6.0.amd0_rocm7.0_vllm0.11.0.dev/images/sha256-f70a3ebc94c1f66de42a2fcc3f8a6a8d6d0881eb0e65b6958d7d6d24b3eecb0d"><i class="fab fa-docker fa-lg"></i> rocm/verl</a>
     - `7.0.0 <https://repo.radeon.com/rocm/apt/7.0/>`__
     - `0.6.0 <https://github.com/volcengine/verl/releases/tag/v0.6.0>`__
     - 22.04
     - `2.9.0 <https://github.com/ROCm/pytorch/tree/release/2.9-rocm7.x-gfx115x>`__
     - `3.12.11 <https://www.python.org/downloads/release/python-31211/>`__
     - `0.11.0 <https://github.com/vllm-project/vllm/releases/tag/v0.11.0>`__

   * - .. raw:: html

        <a href="https://hub.docker.com/layers/rocm/verl/verl-0.3.0.post0_rocm6.2_vllm0.6.3/images/sha256-cbe423803fd7850448b22444176bee06f4dcf22cd3c94c27732752d3a39b04b2"><i class="fab fa-docker fa-lg"></i> rocm/verl</a>
     - `6.2.0 <https://repo.radeon.com/rocm/apt/6.2/>`__
     - `0.3.0.post0 <https://github.com/volcengine/verl/releases/tag/v0.3.0.post0>`__
     - 20.04
     - `2.5.0 <https://github.com/ROCm/pytorch/tree/release/2.5>`__
     - `3.9.19 <https://www.python.org/downloads/release/python-3919/>`__
     - `0.6.3 <https://github.com/vllm-project/vllm/releases/tag/v0.6.3>`__


Previous versions
===============================================================================
See :doc:`rocm-install-on-linux:install/3rd-party/previous-versions/verl-history` to find documentation for previous releases
of the ``ROCm/verl`` Docker image.
