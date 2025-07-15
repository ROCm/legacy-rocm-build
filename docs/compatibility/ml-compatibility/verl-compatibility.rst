:orphan:

.. meta::
   :description: verl compatibility
   :keywords: GPU, verl compatibility

.. version-set:: rocm_version latest

*******************************************************************************
verl compatibility
*******************************************************************************

Volcano Engine Reinforcement Learning for LLMs (verl) is a reinforcement learning framework designed for large language models (LLMs). 
verl offers a scalable, open-source fine-tuning solution optimized for AMD Instinct GPUs with full ROCm support.

* See the `verl documentation <https://verl.readthedocs.io/en/latest/>`_ for more information about verl. 
* The official verl GitHub repository is `https://github.com/volcengine/verl <https://github.com/volcengine/verl>`_.
* Use the AMD-validated :ref:`Docker images <verl-docker-compat>` with ROCm and verl preinstalled. 
* See the :doc:`ROCm verl installation guide <rocm-install-on-linux:install/3rd-party/dgl-install>` to get started.

.. note::

	verl is supported on ROCm 6.2.0.


.. _verl-recommendations:

Use cases and recommendations
================================================================================

The benefits of verl in large-scale reinforcement leaning from human feedback (RLHF) are discussed in the `Reinforcement Learning from Human Feedback on AMD GPUs with verl and ROCm Integration <https://rocm.blogs.amd.com/artificial-intelligence/verl-large-scale/README.html>`_ blog.

.. _verl-docker-compat:

Docker image compatibility
================================================================================

.. |docker-icon| raw:: html

   <i class="fab fa-docker"></i>

AMD validates and publishes ready-made `ROCm verl Docker images <https://hub.docker.com/r/rocm/verl>`_
with ROCm backends on Docker Hub. The following Docker image tags and associated inventories represent the latest verl version from the official Docker Hub. The Docker images have been validated for `ROCm 6.2.0 <https://repo.radeon.com/rocm/apt/6.2/>`_. 

.. list-table:: 
    :header-rows: 1

    *   - Docker image
        - verl
        - Linux
        - Pytorch
        - Python
        - vllm

    *   - .. raw:: html

            <a href="https://hub.docker.com/layers/rocm/verl/verl-0.3.0.post0_rocm6.2_vllm0.6.3/images/sha256-cbe423803fd7850448b22444176bee06f4dcf22cd3c94c27732752d3a39b04b2"><i class="fab fa-docker fa-lg"></i> rocm/verl</a>
        - `0.3.0post0 <https://github.com/volcengine/verl/releases/tag/v0.3.0.post0>`_
        - Ubuntu 20.04
        - `2.5.0 <https://download.pytorch.org/whl/cu118/torch-2.5.0%2Bcu118-cp39-cp39-linux_x86_64.whl#sha256=1ee24b267418c37b297529ede875b961e382c1c365482f4142af2398b92ed127>`_
        - `3.9.19 <https://www.python.org/downloads/release/python-3919/>`_
        - `0.6.4 <https://github.com/vllm-project/vllm/releases/tag/v0.6.4>`_


Supported features
===============================================================================

The following table shows verl and ROCm support for GPU-accelerated modules.

.. list-table::
    :header-rows: 1

    * - Module
      - Description
      - verl version
      - ROCm version
    * - ``FSDP``
      - Training engine
      - 0.3.0.post0
      - 6.2
    * - ``vllm``
      - Inference engine
      - 0.3.0.post0
      - 6.2
  
