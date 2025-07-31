:orphan:

.. meta::
    :description: Megablocks compatibility
    :keywords: GPU, megablocks, compatibility

.. version-set:: rocm_version latest

********************************************************************************
Megablocks compatibility
********************************************************************************

Megablocks is a light-weight library for mixture-of-experts (MoE) training. 
The core of the system is efficient "dropless-MoE" and standard MoE layers. 
Megablocks is integrated with `https://github.com/stanford-futuredata/Megatron-LM <https://github.com/stanford-futuredata/Megatron-LM>`_, 
where data and pipeline parallel training of MoEs is supported.

* ROCm support for Megablocks is hosted in the official `https://github.com/ROCm/megablocks <https://github.com/ROCm/megablocks>`_ repository. 
* Due to independent compatibility considerations, this location differs from the `https://github.com/stanford-futuredata/Megatron-LM <https://github.com/stanford-futuredata/Megatron-LM>`_ upstream repository. 
* Use the prebuilt :ref:`Docker image <megablocks-docker-compat>` with ROCm, PyTorch, and Megablocks preinstalled. 
* See the :doc:`ROCm Megablocks installation guide <rocm-install-on-linux:install/3rd-party/megablocks-install>` to install and get started.

.. note::

  Megablocks is supported on ROCm 6.3.0.

Supported devices
================================================================================

- **Officially Supported**: AMD Instinct MI300X
- **Partially Supported** (functionality or performance limitations): AMD Instinct MI250X, MI210X

Supported models and features
================================================================================

This section summarizes the Megablocks features supported by ROCm.

* Distributed Pre-training
* Activation Checkpointing and Recomputation
* Distributed Optimizer
* Mixture-of-Experts
* dropless-Mixture-of-Experts


.. _megablocks-recommendations:

Use cases and recommendations
================================================================================

The `ROCm Megablocks blog posts <https://rocm.blogs.amd.com/artificial-intelligence/megablocks/README.html>`_ 
guide how to leverage the ROCm platform for pre-training using the Megablocks framework. 
It features how to pre-process datasets and how to begin pre-training on AMD GPUs through:

* Single-GPU pre-training
* Multi-GPU pre-training


.. _megablocks-docker-compat:

Docker image compatibility
================================================================================

.. |docker-icon| raw:: html

   <i class="fab fa-docker"></i>

AMD validates and publishes `ROCm Megablocks images <https://hub.docker.com/r/rocm/megablocks/tags>`_
with ROCm and Pytorch backends on Docker Hub. The following Docker image tags and associated
inventories represent the latest Megatron-LM version from the official Docker Hub.
The Docker images have been validated for `ROCm 6.3.0 <https://repo.radeon.com/rocm/apt/6.3/>`_.
Click |docker-icon| to view the image on Docker Hub.

.. list-table:: 
    :header-rows: 1
    :class: docker-image-compatibility

    * - Docker image
      - ROCm
      - Megablocks
      - PyTorch
      - Ubuntu
      - Python

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/megablocks/megablocks-0.7.0_rocm6.3.0_ubuntu24.04_py3.12_pytorch2.4.0/images/sha256-372ff89b96599019b8f5f9db469c84add2529b713456781fa62eb9a148659ab4"><i class="fab fa-docker fa-lg"></i> rocm/megablocks</a>
      - `6.3.0 <https://repo.radeon.com/rocm/apt/6.3/>`_
      - `0.7.0 <https://github.com/databricks/megablocks/releases/tag/v0.7.0>`_
      - `2.4.0 <https://github.com/ROCm/pytorch/tree/release/2.4>`_
      - 24.04
      - `3.12.9 <https://www.python.org/downloads/release/python-3129/>`_


