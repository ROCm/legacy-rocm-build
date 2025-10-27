:orphan:

.. meta::
    :description: Stanford Megatron-LM compatibility
    :keywords: Stanford, Megatron-LM, deep learning, framework compatibility

.. version-set:: rocm_version latest

********************************************************************************
Stanford Megatron-LM compatibility
********************************************************************************

Stanford Megatron-LM is a large-scale language model training framework developed 
by NVIDIA at `https://github.com/NVIDIA/Megatron-LM <https://github.com/NVIDIA/Megatron-LM>`_. 
It is designed to train massive transformer-based language models efficiently by model 
and data parallelism. 

It provides efficient tensor, pipeline, and sequence-based model parallelism for 
pre-training transformer-based language models such as GPT (Decoder Only), BERT 
(Encoder Only), and T5 (Encoder-Decoder). 

Support overview
================================================================================

- The ROCm-supported version of Stanford Megatron-LM is maintained in the official `https://github.com/ROCm/Stanford-Megatron-LM 
  <https://github.com/ROCm/Stanford-Megatron-LM>`__ repository, which differs from the 
  `https://github.com/stanford-futuredata/Megatron-LM <https://github.com/stanford-futuredata/Megatron-LM>`__ upstream repository.

- To get started and install Stanford Megatron-LM on ROCm, use the prebuilt :ref:`Docker image <megatron-lm-docker-compat>`, 
  which includes ROCm, Stanford Megatron-LM, and all required dependencies.

  - See the :doc:`ROCm Stanford Megatron-LM installation guide <rocm-install-on-linux:install/3rd-party/stanford-megatron-lm-install>` 
    for installation and setup instructions.

  - You can also consult the upstream `Installation guide <https://github.com/NVIDIA/Megatron-LM>`__ 
    for additional context.

Version support
--------------------------------------------------------------------------------

Stanford Megatron-LM is supported on `ROCm 6.3.0 <https://repo.radeon.com/rocm/apt/6.3/>`__.

Supported devices
--------------------------------------------------------------------------------

- **Officially Supported**: AMD Instinct™ MI300X
- **Partially Supported** (functionality or performance limitations): AMD Instinct™ MI250X, MI210

Supported models and features
--------------------------------------------------------------------------------

This section details models & features that are supported by the ROCm version on Stanford Megatron-LM.

Models:

* BERT
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

The following blog post mentions Megablocks, but you can run Stanford Megatron-LM with the same steps to pre-process datasets on AMD GPUs:

* The `Efficient MoE training on AMD ROCm: How-to use Megablocks on AMD GPUs 
  <https://rocm.blogs.amd.com/artificial-intelligence/megablocks/README.html>`__ 
  blog post guides how to leverage the ROCm platform for pre-training using the 
  Megablocks framework. It introduces a streamlined approach for training Mixture-of-Experts 
  (MoE) models using the Megablocks library on AMD hardware. Focusing on GPT-2, it 
  demonstrates how block-sparse computations can enhance scalability and efficiency in MoE 
  training. The guide provides step-by-step instructions for setting up the environment, 
  including cloning the repository, building the Docker image, and running the training container. 
  Additionally, it offers insights into utilizing the ``oscar-1GB.json`` dataset for pre-training 
  language models. By leveraging Megablocks and the ROCm platform, you can optimize your MoE 
  training workflows for large-scale transformer models.

It features how to pre-process datasets and how to begin pre-training on AMD GPUs through:

* Single-GPU pre-training
* Multi-GPU pre-training

.. _megatron-lm-docker-compat:

Docker image compatibility
================================================================================

.. |docker-icon| raw:: html

   <i class="fab fa-docker"></i>

AMD validates and publishes `Stanford Megatron-LM images <https://hub.docker.com/r/rocm/stanford-megatron-lm/tags>`_
with ROCm and Pytorch backends on Docker Hub. The following Docker image tags and associated
inventories represent the latest Stanford Megatron-LM version from the official Docker Hub.
Click |docker-icon| to view the image on Docker Hub.

.. list-table:: 
    :header-rows: 1
    :class: docker-image-compatibility

    * - Docker image
      - ROCm
      - Stanford Megatron-LM
      - PyTorch
      - Ubuntu
      - Python

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/stanford-megatron-lm/stanford-megatron-lm85f95ae_rocm6.3.0_ubuntu24.04_py3.12_pytorch2.4.0/images/sha256-070556f078be10888a1421a2cb4f48c29f28b02bfeddae02588d1f7fc02a96a6"><i class="fab fa-docker fa-lg"></i></a>

      - `6.3.0 <https://repo.radeon.com/rocm/apt/6.3/>`_
      - `85f95ae <https://github.com/stanford-futuredata/Megatron-LM/commit/85f95aef3b648075fe6f291c86714fdcbd9cd1f5>`_
      - `2.4.0 <https://github.com/ROCm/pytorch/tree/release/2.4>`_
      - 24.04
      - `3.12.9 <https://www.python.org/downloads/release/python-3129/>`_

      

