:orphan:

.. meta::
    :description: Ray compatibility
    :keywords: GPU, Ray, deep learning, framework compatibility

.. version-set:: rocm_version latest

*******************************************************************************
Ray compatibility
*******************************************************************************

Ray is a unified framework for scaling AI and Python applications from your laptop 
to a full cluster, without changing your code. Ray consists of `a core distributed 
runtime  <https://docs.ray.io/en/latest/ray-core/walkthrough.html>`__ and a set of 
`AI libraries <https://docs.ray.io/en/latest/ray-air/getting-started.html>`__ for 
simplifying machine learning computations.

Ray is a general-purpose framework that runs many types of workloads efficiently. 
Any Python application can be scaled with Ray, without extra infrastructure.

Support overview
================================================================================

- The ROCm-supported version of Ray is maintained in the official `https://github.com/ROCm/ray 
  <https://github.com/ROCm/ray>`__ repository, which differs from the 
  `https://github.com/ray-project/ray <https://github.com/ray-project/ray>`__ upstream repository.

- To get started and install Ray on ROCm, use the prebuilt :ref:`Docker image <ray-docker-compat>`, 
  which includes ROCm, Ray, and all required dependencies.

  - See the :doc:`ROCm Ray installation guide <rocm-install-on-linux:install/3rd-party/ray-install>`
    for installation and setup instructions.

  - You can also consult the upstream `Installation guide <https://docs.ray.io/en/latest/ray-overview/installation.html>`__ 
    for additional context.

.. _ray-docker-compat:

Compatibility matrix
================================================================================

.. |docker-icon| raw:: html

   <i class="fab fa-docker"></i>

AMD validates and publishes `ROCm Ray Docker images <https://hub.docker.com/r/rocm/ray/tags>`__
with ROCm backends on Docker Hub. The following Docker image tags and
associated inventories represent the latest Ray version from the official Docker Hub.
Click |docker-icon| to view the image on Docker Hub.

.. list-table::
    :header-rows: 1
    :class: docker-image-compatibility

    * - Docker image
      - ROCm
      - Ray
      - Pytorch
      - Ubuntu
      - Python
      - GPU

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/ray/ray-2.51.1_rocm7.0.0_ubuntu22.04_py3.12_pytorch2.9.0/images/sha256-a02f6766b4ba406f88fd7e85707ec86c04b569834d869a08043ec9bcbd672168"><i class="fab fa-docker fa-lg"></i> rocm/ray</a>
      - `7.0.0 <https://repo.radeon.com/rocm/apt/7.0/>`__
      - `2.51.1 <https://github.com/ROCm/ray/tree/release/2.51.1>`__
      - 2.9.0a0+git1c57644
      - 22.04
      - `3.12.12 <https://www.python.org/downloads/release/python-31212/>`__
      - MI300X

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/ray/ray-2.48.0.post0_rocm6.4.1_ubuntu24.04_py3.12_pytorch2.6.0/images/sha256-0d166fe6bdced38338c78eedfb96eff92655fb797da3478a62dd636365133cc0"><i class="fab fa-docker fa-lg"></i> rocm/ray</a>
      - `6.4.1 <https://repo.radeon.com/rocm/apt/6.4.1/>`__
      - `2.48.0.post0 <https://github.com/ROCm/ray/tree/release/2.48.0.post0>`__
      - 2.6.0+git684f6f2
      - 24.04
      - `3.12.10 <https://www.python.org/downloads/release/python-31210/>`__
      - MI300X, MI210

Use cases and recommendations
================================================================================

* The `Reinforcement Learning from Human Feedback on AMD GPUs with verl and ROCm 
  Integration <https://rocm.blogs.amd.com/artificial-intelligence/verl-large-scale/README.html>`__  
  blog provides an overview of Volcano Engine Reinforcement Learning (verl) 
  for large language models (LLMs) and discusses its benefits in large-scale 
  reinforcement learning from human feedback (RLHF). It uses Ray as part of a 
  hybrid orchestration engine to schedule and coordinate training and inference 
  tasks in parallel, enabling optimized resource utilization and potential overlap 
  between these phases. This dynamic resource allocation strategy significantly 
  improves overall system efficiency. The blog presents verl’s performance results, 
  focusing on throughput and convergence accuracy achieved on AMD Instinct™ MI300X 
  GPUs. Follow this guide to get started with verl on AMD Instinct GPUs and 
  accelerate your RLHF training with ROCm-optimized performance.

* The `Exploring Use Cases for Scalable AI: Implementing Ray with ROCm Support for Efficient ML Workflows 
  <https://rocm.blogs.amd.com/artificial-intelligence/rocm-ray/README.html>`__
  blog post describes key use cases such as training and inference for large language models (LLMs), 
  model serving, hyperparameter tuning, reinforcement learning, and the orchestration of large-scale 
  workloads using Ray in the ROCm environment.

For more use cases and recommendations, see the AMD GPU tabs in the `Accelerator Support 
topic <https://docs.ray.io/en/latest/ray-core/scheduling/accelerators.html#accelerator-support>`__ 
of the Ray core documentation and refer to the `AMD ROCm blog <https://rocm.blogs.amd.com/>`__, 
where you can search for Ray examples and best practices to optimize your workloads on AMD GPUs.

Previous versions
===============================================================================
See :doc:`rocm-install-on-linux:install/3rd-party/previous-versions/ray-history` to find documentation for previous releases
of the ``ROCm/ray`` Docker image.
