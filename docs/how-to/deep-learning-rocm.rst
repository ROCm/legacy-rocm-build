.. meta::
   :description: How to install deep learning frameworks for ROCm
   :keywords: deep learning, frameworks, ROCm, install, PyTorch, TensorFlow, JAX, MAGMA, DeepSpeed, ML, AI

**********************************
Deep learning frameworks for ROCm
**********************************

Deep learning frameworks provide environments for machine learning, training, fine-tuning, inference, and performance optimization.

ROCm offers a complete ecosystem for developing and running deep learning applications efficiently. It also provides ROCm-compatible versions of popular frameworks and libraries, such as PyTorch, TensorFlow, JAX, and others.

The AMD ROCm organization actively contributes to open-source development and collaborates closely with framework organizations. This collaboration ensures that framework-specific optimizations effectively leverage AMD GPUs.

The table below summarizes information about ROCm-enabled deep learning frameworks. It includes details on ROCm compatibility and third-party tool support, installation steps and options, and links to GitHub resources. For a complete list of supported framework versions on ROCm, see the :doc:`Compatibility matrix <../compatibility/compatibility-matrix>` topic.

.. list-table:: 
    :header-rows: 1
    :widths: 5 3 6 3

    * - Framework
      - Installation guide
      - Installation options
      - GitHub

    * - :doc:`PyTorch <../compatibility/ml-compatibility/pytorch-compatibility>`
      - :doc:`link <rocm-install-on-linux:install/3rd-party/pytorch-install>`
      - 
        - Docker image
        - Wheels package
        - ROCm Base Docker image
        - Upstream Docker file
      - .. raw:: html

          <a href="https://github.com/ROCm/pytorch"><i class="fab fa-github fa-lg"></i></a>

    * - :doc:`TensorFlow <../compatibility/ml-compatibility/tensorflow-compatibility>`
      - :doc:`link <rocm-install-on-linux:install/3rd-party/tensorflow-install>`
      - 
        - Docker image
        - Wheels package

      - .. raw:: html

          <a href="https://github.com/ROCm/tensorflow-upstream"><i class="fab fa-github fa-lg"></i></a> 

    * - :doc:`JAX <../compatibility/ml-compatibility/jax-compatibility>`
      - :doc:`link <rocm-install-on-linux:install/3rd-party/jax-install>`
      - 
        - Docker image
      - .. raw:: html

          <a href="https://github.com/ROCm/jax"><i class="fab fa-github fa-lg"></i></a>

    * - :doc:`DGL <../compatibility/ml-compatibility/dgl-compatibility>`
      - :doc:`link <rocm-install-on-linux:install/3rd-party/dgl-install>`
      - 
        - Docker image
      - .. raw:: html

          <a href="https://github.com/ROCm/dgl"><i class="fab fa-github fa-lg"></i></a> 

Learn how to use your ROCm deep learning environment for training, fine-tuning, inference, and performance optimization
through the following guides.

* :doc:`rocm-for-ai/index`

* :doc:`Use ROCm for training <rocm-for-ai/training/index>`

* :doc:`Use ROCm for fine-tuning LLMs <rocm-for-ai/fine-tuning/index>`

* :doc:`Use ROCm for AI inference <rocm-for-ai/inference/index>`

* :doc:`Use ROCm for AI inference optimization <rocm-for-ai/inference-optimization/index>`

