.. meta::
   :description: How to install deep learning frameworks for ROCm
   :keywords: deep learning, frameworks, ROCm, install, PyTorch, TensorFlow, JAX, MAGMA, DeepSpeed, ML, AI

**********************************
Deep learning frameworks for ROCm
**********************************

Deep learning frameworks provide environments for machine learning, training, fine-tuning, inference, and performance optimization.

ROCm offers a comprehensive ecosystem for optimized deep learning development and operations, along with ROCm-aware versions of widely used deep learning frameworks and libraries, including PyTorch, TensorFlow, and JAX.

The AMD ROCm organization, which is actively involved in open-source contributions and development, collaborates closely with in-demand framework organizations to ensure that framework-specific optimizations effectively leverage AMD accelerators and GPU architectures.

The topics noted in the following table provide information about the installation and compatibility of these ROCm-enabled deep learning frameworks. The compatibility topics note the ROCm and third-party tool version support. Additionally, the :doc:`Compatibility matrix <../compatibility/compatibility-matrix>` topic notes the supported deep learning framework versions.

.. list-table:: 
    :header-rows: 1
    :widths: 10 10 10 10

    * - Framework (Compatibility topic)
      - Installation topic
      - Installation options
      - ROCm GitHub

    * - `PyTorch <https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/pytorch-compatibility.html>`_
      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/pytorch-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        - | `Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/pytorch-install.html#using-a-docker-image-with-pytorch-pre-installed>`_ 
        - | `Wheels package <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/pytorch-install.html#using-a-wheels-package>`_
        - | `ROCm Base Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/pytorch-install.html#using-the-pytorch-rocm-base-docker-image>`_ 
        - | `Upstream Docker file <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/pytorch-install.html#using-the-pytorch-upstream-dockerfile>`_
      - .. raw:: html
         
          <a href="https://github.com/ROCm/pytorch"><i class="fab fa-github fa-lg"></i></a>
   
    * - `TensorFlow <https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/tensorflow-compatibility.html>`_
      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/tensorflow-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        - | `Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/tensorflow-install.html#using-a-docker-image-with-tensorflow-pre-installed>`_
        - | `Wheels package <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/tensorflow-install.html#using-a-wheels-package>`_

      - .. raw:: html
         
          <a href="https://github.com/ROCm/tensorflow-upstream"><i class="fab fa-github fa-lg"></i></a> 

    * - `JAX <https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/jax-compatibility.html>`_
      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/jax-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        - | `Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/jax-install.html#using-a-prebuilt-docker-image>`_
      - .. raw:: html
         
          <a href="https://github.com/ROCm/jax"><i class="fab fa-github fa-lg"></i></a>
   
    * - `verl <https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/verl-compatibility.html>`_
      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/verl-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        - | `Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/verl-install.html#use-a-prebuilt-docker-image-with-verl-pre-installed>`_
      - .. raw:: html
         
          <a href="https://github.com/ROCm/verl"><i class="fab fa-github fa-lg"></i></a>

    * - `Stanford Megatron-LM <https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/stanford-megatron-lm-compatibility.html>`_
      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/stanford-megatron-lm-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        - | `Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/stanford-megatron-lm-install.html#use-a-prebuilt-docker-image-with-stanford-megatron-lm-pre-installed>`_
      - .. raw:: html
         
          <a href="https://github.com/ROCm/Stanford-Megatron-LM"><i class="fab fa-github fa-lg"></i></a>
   
    * - `DGL <https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/dgl-compatibility.html>`_
      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/dgl-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        - | `Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/dgl-install.html#use-a-prebuilt-docker-image-with-dgl-pre-installed>`_
      - .. raw:: html
         
          <a href="https://github.com/ROCm/dgl"><i class="fab fa-github fa-lg"></i></a> 

    * - `Megablocks <https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/megablocks-compatibility.html>`_
      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/megablocks-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        - | `Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/megablocks-install.html#using-a-prebuilt-docker-image-with-megablocks-pre-installed>`_
      - .. raw:: html
         
          <a href="https://github.com/ROCm/megablocks"><i class="fab fa-github fa-lg"></i></a>
   
    * - `Taichi <https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/taichi-compatibility.html>`_
      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/taichi-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        - | `Docker image <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/taichi-install.html#use-a-prebuilt-docker-image-with-taichi-pre-installed>`_ 
        - | `Wheels package <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/taichi-install.html#use-a-wheels-package>`_

      - .. raw:: html
         
          <a href="https://github.com/ROCm/taichi"><i class="fab fa-github fa-lg"></i></a>      


Learn how to use your ROCm deep learning environment for training, fine-tuning, inference, and performance optimization
through the following guides.

* :doc:`rocm-for-ai/index`

* :doc:`Use ROCm for training <rocm-for-ai/training/index>`

* :doc:`Use ROCm for fine-tuning LLMs <rocm-for-ai/fine-tuning/index>`

* :doc:`Use ROCm for AI inference <rocm-for-ai/inference/index>`

* :doc:`Use ROCm for AI inference optimization <rocm-for-ai/inference-optimization/index>`








