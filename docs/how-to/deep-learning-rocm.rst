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
    :widths: 25 10 20 20
    :align: center

    * - Framework (ROCm GitHub)
      - Installation topic
      - Installation options
      - Compatibility topic

    * - `PyTorch <https://github.com/ROCm/pytorch>`_
      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/pytorch-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        | Docker image 
        | Wheels package 
        | ROCm Base Docker image 
        | Upstream Docker file
      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/pytorch-compatibility.html"><i class="fas fa-link fa-lg"></i></a>
   
    * - `TensorFlow <https://github.com/ROCm/tensorflow-upstream>`_
      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/tensorflow-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        | Docker image 
        | Wheels package 

      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/tensorflow-compatibility.html"><i class="fas fa-link fa-lg"></i></a> 

    * - `JAX <https://github.com/ROCm/jax>`_
      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/jax-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        | Docker image 
      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/jax-compatibility.html"><i class="fas fa-link fa-lg"></i></a>
   
    * - `verl <https://github.com/ROCm/verl>`_
      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/verl-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        | Docker image 
      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/verl-compatibility.html"><i class="fas fa-link fa-lg"></i></a>

    * - `Stanford Megatron-LM <https://github.com/ROCm/Stanford-Megatron-LM>`_
      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/stanford-megatron-lm-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        | Docker image 
      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/stanford-megatron-lm-compatibility.html"><i class="fas fa-link fa-lg"></i></a>
   
    * - `DGL <https://github.com/ROCm/dgl>`_
      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/dgl-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        | Docker image 
      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/dgl-compatibility.html"><i class="fas fa-link fa-lg"></i></a> 

    * - `Megablocks <https://github.com/ROCm/megablocks>`_
      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/megablocks-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        | Docker image 
      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/megablocks-compatibility.html"><i class="fas fa-link fa-lg"></i></a>
   
    * - `Taichi <https://github.com/ROCm/taichi>`_
      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/taichi-install.html"><i class="fas fa-link fa-lg"></i></a>
      - 
        | Docker image 
        | Wheels package 

      - .. raw:: html
         
          <a href="https://rocm.docs.amd.com/en/latest/compatibility/ml-compatibility/taichi-compatibility.html"><i class="fas fa-link fa-lg"></i></a>      


Learn how to use your ROCm deep learning environment for training, fine-tuning, inference, and performance optimization
through the following guides.

* :doc:`rocm-for-ai/index`

* :doc:`Training <rocm-for-ai/training/index>`

* :doc:`Fine-tuning LLMs <rocm-for-ai/fine-tuning/index>`

* :doc:`Inference <rocm-for-ai/inference/index>`

* :doc:`Inference optimization <rocm-for-ai/inference-optimization/index>`








