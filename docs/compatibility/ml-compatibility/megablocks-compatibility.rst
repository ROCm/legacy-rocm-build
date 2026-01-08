:orphan:

.. meta::
    :description: Megablocks compatibility
    :keywords: GPU, megablocks, deep learning, framework compatibility

.. version-set:: rocm_version latest

********************************************************************************
Megablocks compatibility
********************************************************************************

`Megablocks <https://github.com/databricks/megablocks>`__ is a lightweight library 
for mixture-of-experts `(MoE) <https://huggingface.co/blog/moe>`__ training. 
The core of the system is efficient "dropless-MoE" and standard MoE layers. 
Megablocks is integrated with `https://github.com/stanford-futuredata/Megatron-LM 
<https://github.com/stanford-futuredata/Megatron-LM>`__, 
where data and pipeline parallel training of MoEs is supported.

Support overview
================================================================================

- The ROCm-supported version of Megablocks is maintained in the official `https://github.com/ROCm/megablocks 
  <https://github.com/ROCm/megablocks>`__ repository, which differs from the 
  `https://github.com/stanford-futuredata/Megatron-LM <https://github.com/stanford-futuredata/Megatron-LM>`__ upstream repository.

- To get started and install Megablocks on ROCm, use the prebuilt :ref:`Docker image <megablocks-docker-compat>`, 
  which includes ROCm, Megablocks, and all required dependencies.

  - See the :doc:`ROCm Megablocks installation guide <rocm-install-on-linux:install/3rd-party/megablocks-install>` 
    for installation and setup instructions.

  - You can also consult the upstream `Installation guide <https://github.com/databricks/megablocks>`__ 
    for additional context.

.. _megablocks-docker-compat:

Compatibility matrix
================================================================================

.. |docker-icon| raw:: html

   <i class="fab fa-docker"></i>

AMD validates and publishes `Megablocks images <https://hub.docker.com/r/rocm/megablocks/tags>`__
with ROCm backends on Docker Hub. The following Docker image tag and associated
inventories represent the latest available Megablocks version from the official Docker Hub. 
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
      - GPU

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/megablocks/megablocks-0.7.0_rocm6.3.0_ubuntu24.04_py3.12_pytorch2.4.0/images/sha256-372ff89b96599019b8f5f9db469c84add2529b713456781fa62eb9a148659ab4"><i class="fab fa-docker fa-lg"></i> rocm/megablocks</a>
      - `6.3.0 <https://repo.radeon.com/rocm/apt/6.3/>`_
      - `0.7.0 <https://github.com/databricks/megablocks/releases/tag/v0.7.0>`_
      - `2.4.0 <https://github.com/ROCm/pytorch/tree/release/2.4>`_
      - 24.04
      - `3.12.9 <https://www.python.org/downloads/release/python-3129/>`_
      - MI300X

Supported models and features with ROCm 6.3.0
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

