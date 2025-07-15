:orphan:

.. meta::
    :description: Stanford Megatron-LM compatibility
    :keywords: Stanford, Megatron-LM, compatibility

.. version-set:: rocm_version latest

********************************************************************************
Stanford Megatron-LM compatibility
********************************************************************************

Stanford Megatron-LM is a large-scale language model training framework developed by NVIDIA `https://github.com/NVIDIA/Megatron-LM <https://github.com/NVIDIA/Megatron-LM>`_. It is
designed to train massive transformer-based language models efficiently by model and data parallelism. 

* ROCm support for Stanford Megatron-LM is hosted in the official `https://github.com/ROCm/Stanford-Megatron-LM <https://github.com/ROCm/Stanford-Megatron-LM>`_ repository. 
* Due to independent compatibility considerations, this location differs from the `https://github.com/stanford-futuredata/Megatron-LM <https://github.com/stanford-futuredata/Megatron-LM>`_ upstream repository. 
* Use the prebuilt :ref:`Docker image <megatron-lm-docker-compat>` with ROCm, PyTorch, and Megatron-LM preinstalled. 
* See the :doc:`ROCm Stanford Megatron-LM installation guide <rocm-install-on-linux:install/3rd-party/stanford-megatron-lm-install>` to install and get started.

.. note::

	Stanford Megatron-LM is supported on ROCm 6.3.0.


Supported Devices
================================================================================

- **Officially Supported**: AMD Instinct MI300X
- **Partially Supported** (functionality or performance limitations): AMD Instinct MI250X, MI210X


Supported models and features
================================================================================

This section details models & features that are supported by the ROCm version on Stanford Megatron-LM.

Models:

* Bert
* GPT
* T5
* ICT

Features:

* Distributed Pre-training
* Activation Checkpointing and Recomputation
* Distributed Optimizer
* Mixture-of-Experts

.. _megatron-lm-recommendations:

Use cases and recommendations
================================================================================

See the `Efficient MoE training on AMD ROCm: How-to use Megablocks on AMD GPUs blog <https://rocm.blogs.amd.com/artificial-intelligence/megablocks/README.html>`_ post  
to leverage the ROCm platform for pre-training by using the Stanford Megatron-LM framework of pre-processing datasets on AMD GPUs. 
Coverage includes:

  * Single-GPU pre-training
  * Multi-GPU pre-training


.. _megatron-lm-docker-compat:

Docker image compatibility
================================================================================

.. |docker-icon| raw:: html

   <i class="fab fa-docker"></i>

AMD validates and publishes `Stanford Megatron-LM images <https://hub.docker.com/r/rocm/megatron-lm>`_
with ROCm and Pytorch backends on Docker Hub. The following Docker image tags and associated
inventories represent the latest Megatron-LM version from the official Docker Hub.
The Docker images have been validated for `ROCm 6.3.0 <https://repo.radeon.com/rocm/apt/6.3/>`_.
Click |docker-icon| to view the image on Docker Hub.

.. list-table:: 
    :header-rows: 1
    :class: docker-image-compatibility

    * - Docker image
      - Stanford Megatron-LM
      - PyTorch
      - Ubuntu
      - Python

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/stanford-megatron-lm/stanford-megatron-lm85f95ae_rocm6.3.0_ubuntu24.04_py3.12_pytorch2.4.0/images/sha256-070556f078be10888a1421a2cb4f48c29f28b02bfeddae02588d1f7fc02a96a6"><i class="fab fa-docker fa-lg"></i></a>

      - `85f95ae <https://github.com/stanford-futuredata/Megatron-LM/commit/85f95aef3b648075fe6f291c86714fdcbd9cd1f5>`_
      - `2.4.0 <https://github.com/ROCm/pytorch/tree/release/2.4>`_
      - 24.04
      - `3.12.9 <https://www.python.org/downloads/release/python-3129/>`_

      

