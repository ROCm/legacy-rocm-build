.. meta::
   :description: How to install deep learning frameworks for ROCm
   :keywords: deep learning, frameworks, ROCm, install, PyTorch, TensorFlow, JAX, MAGMA, DeepSpeed, ML, AI

**********************************
Deep learning frameworks for ROCm
**********************************

Deep learning frameworks provide environments for machine learning, training, fine-tuning, inference, and performance optimization.

ROCm offers a complete ecosystem for developing and running deep learning applications efficiently. It also provides ROCm-compatible versions of popular frameworks and libraries, such as PyTorch, TensorFlow, JAX, and others.

The AMD ROCm organization actively contributes to open-source development and collaborates closely with framework organizations. This collaboration ensures that framework-specific optimizations effectively leverage AMD GPUs and accelerators.

The table below summarizes information about ROCm-enabled deep learning frameworks. It includes details on ROCm compatibility and third-party tool support, installation steps and options, and links to GitHub resources. For a complete list of supported framework versions on ROCm, see the :doc:`Compatibility matrix <../compatibility/compatibility-matrix>` topic.

.. list-table:: 
    :header-rows: 1
    :widths: 5 3 6 3

    * - Framework
      - Installation
      - Installation options
      - GitHub

    * - `PyTorch <https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/pytorch-compatibility.html>`__
      - .. raw:: html

          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/pytorch-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        - `Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/pytorch-install.html#using-a-docker-image-with-pytorch-pre-installed>`__
        - `Wheels package <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/pytorch-install.html#using-a-wheels-package>`__
        - `ROCm Base Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/pytorch-install.html#using-the-pytorch-rocm-base-docker-image>`__
        - `Upstream Docker file <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/pytorch-install.html#using-the-pytorch-upstream-dockerfile>`__
      - .. raw:: html

          <a href="https://github.com/ROCm/pytorch"><i class="fab fa-github fa-lg"></i></a>

    * - `TensorFlow <https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/tensorflow-compatibility.html>`__
      - .. raw:: html

          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/tensorflow-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        - `Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/tensorflow-install.html#using-a-docker-image-with-tensorflow-pre-installed>`__
        - `Wheels package <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/tensorflow-install.html#using-a-wheels-package>`__

      - .. raw:: html

          <a href="https://github.com/ROCm/tensorflow-upstream"><i class="fab fa-github fa-lg"></i></a> 

    * - `JAX <https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/jax-compatibility.html>`__
      - .. raw:: html

          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/jax-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        - `Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/jax-install.html#using-a-prebuilt-docker-image>`__
      - .. raw:: html

          <a href="https://github.com/ROCm/jax"><i class="fab fa-github fa-lg"></i></a>

    * - `verl <https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/verl-compatibility.html>`__
      - .. raw:: html

          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/verl-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        - `Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/verl-install.html#use-a-prebuilt-docker-image-with-verl-pre-installed>`__
      - .. raw:: html

          <a href="https://github.com/ROCm/verl"><i class="fab fa-github fa-lg"></i></a>

    * - `Stanford Megatron-LM <https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/stanford-megatron-lm-compatibility.html>`__
      - .. raw:: html

          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/stanford-megatron-lm-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        - `Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/stanford-megatron-lm-install.html#use-a-prebuilt-docker-image-with-stanford-megatron-lm-pre-installed>`__
      - .. raw:: html

          <a href="https://github.com/ROCm/Stanford-Megatron-LM"><i class="fab fa-github fa-lg"></i></a>

    * - `DGL <https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/dgl-compatibility.html>`__
      - .. raw:: html

          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/dgl-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        - `Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/dgl-install.html#use-a-prebuilt-docker-image-with-dgl-pre-installed>`__
      - .. raw:: html

          <a href="https://github.com/ROCm/dgl"><i class="fab fa-github fa-lg"></i></a> 

    * - `Megablocks <https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/megablocks-compatibility.html>`__
      - .. raw:: html

          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/megablocks-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        - `Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/megablocks-install.html#using-a-prebuilt-docker-image-with-megablocks-pre-installed>`__
      - .. raw:: html

          <a href="https://github.com/ROCm/megablocks"><i class="fab fa-github fa-lg"></i></a>

    * - `Taichi <https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/taichi-compatibility.html>`__
      - .. raw:: html

          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/taichi-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        - `Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/taichi-install.html#use-a-prebuilt-docker-image-with-taichi-pre-installed>`__
        - `Wheels package <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/taichi-install.html#use-a-wheels-package>`__

      - .. raw:: html

          <a href="https://github.com/ROCm/taichi"><i class="fab fa-github fa-lg"></i></a>

    * - `Ray <https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/ray-compatibility.html>`__
      - .. raw:: html

          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/ray-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        - `Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/ray-install.html#using-a-prebuilt-docker-image-with-ray-pre-installed>`__
        - `Wheels package <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/ray-install.html#install-ray-on-bare-metal-or-a-custom-container>`__
        - `ROCm Base Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/ray-install.html#build-your-own-docker-image>`__
      - .. raw:: html

          <a href="https://github.com/ROCm/ray"><i class="fab fa-github fa-lg"></i></a>

    * - `llama.cpp <https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/llama-cpp-compatibility.html>`__
      - .. raw:: html

          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/llama-cpp-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        - `Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/llama-cpp-install.html#use-a-prebuilt-docker-image-with-llama-cpp-pre-installed>`__
        - `ROCm Base Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/llama-cpp-install.html#build-your-own-docker-image>`__
      - .. raw:: html

          <a href="https://github.com/ROCm/llama.cpp"><i class="fab fa-github fa-lg"></i></a>

    * - `FlashInfer <https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/flashinfer-compatibility.html>`__
      - .. raw:: html

          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/flashinfer-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        - `Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/flashinfer-install.html#use-a-prebuilt-docker-image-with-flashinfer-pre-installed>`__
        - `ROCm Base Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/flashinfer-install.html#build-your-own-docker-image>`__
      - .. raw:: html

          <a href="https://github.com/ROCm/flashinfer"><i class="fab fa-github fa-lg"></i></a>

Learn how to use your ROCm deep learning environment for training, fine-tuning, inference, and performance optimization
through the following guides.

* :doc:`rocm-for-ai/index`

* :doc:`Use ROCm for training <rocm-for-ai/training/index>`

* :doc:`Use ROCm for fine-tuning LLMs <rocm-for-ai/fine-tuning/index>`

* :doc:`Use ROCm for AI inference <rocm-for-ai/inference/index>`

* :doc:`Use ROCm for AI inference optimization <rocm-for-ai/inference-optimization/index>`

