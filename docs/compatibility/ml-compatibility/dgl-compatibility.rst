:orphan:

.. meta::
    :description: Deep Graph Library (DGL) compatibility
    :keywords: GPU, CPU, deep graph library, DGL, deep learning, framework compatibility

.. version-set:: rocm_version latest

********************************************************************************
DGL compatibility
********************************************************************************

Deep Graph Library (`DGL <https://www.dgl.ai/>`__) is an easy-to-use, high-performance, and scalable 
Python package for deep learning on graphs. DGL is framework agnostic, meaning 
that if a deep graph model is a component in an end-to-end application, the rest of 
the logic is implemented using PyTorch.  

DGL provides a high-performance graph object that can reside on either CPUs or GPUs. 
It bundles structural data features for better control and provides a variety of functions 
for computing with graph objects, including efficient and customizable message passing 
primitives for Graph Neural Networks.

Support overview
================================================================================

- The ROCm-supported version of DGL is maintained in the official `https://github.com/ROCm/dgl 
  <https://github.com/ROCm/dgl>`__ repository, which differs from the 
  `https://github.com/dmlc/dgl <https://github.com/dmlc/dgl>`__ upstream repository.

- To get started and install DGL on ROCm, use the prebuilt :ref:`Docker images <dgl-docker-compat>`, 
  which include ROCm, DGL, and all required dependencies.

  - See the :doc:`ROCm DGL installation guide <rocm-install-on-linux:install/3rd-party/dgl-install>` 
    for installation and setup instructions.

  - You can also consult the upstream `Installation guide <https://www.dgl.ai/pages/start.html>`__ 
    for additional context.

Version support
--------------------------------------------------------------------------------

DGL is supported on `ROCm 7.0.0 <https://repo.radeon.com/rocm/apt/7.0/>`__, 
`ROCm 6.4.3 <https://repo.radeon.com/rocm/apt/6.4.3/>`__, and `ROCm 6.4.0 <https://repo.radeon.com/rocm/apt/6.4/>`__.

Supported devices
--------------------------------------------------------------------------------

**Officially Supported**: AMD Instinct™ MI300X, MI250X

.. _dgl-recommendations:

Use cases and recommendations
================================================================================

DGL can be used for Graph Learning, and building popular graph models like  
GAT, GCN, and GraphSage. Using these models, a variety of use cases are supported:

- Recommender systems
- Network Optimization and Analysis
- 1D (Temporal) and 2D (Image) Classification
- Drug Discovery

For use cases and recommendations, refer to the `AMD ROCm blog <https://rocm.blogs.amd.com/>`__, 
where you can search for DGL examples and best practices to optimize your workloads on AMD GPUs.

* Although multiple use cases of DGL have been tested and verified, a few have been  
  outlined in the `DGL in the Real World: Running GNNs on Real Use Cases 
  <https://rocm.blogs.amd.com/artificial-intelligence/dgl_blog2/README.html>`__ blog 
  post, which walks through four real-world graph neural network (GNN) workloads 
  implemented with the Deep Graph Library on ROCm. It covers tasks ranging from 
  heterogeneous e-commerce graphs and multiplex networks (GATNE) to molecular graph 
  regression (GNN-FiLM) and EEG-based neurological diagnosis (EEG-GCNN). For each use 
  case, the authors detail: the dataset and task, how DGL is used, and their experience 
  porting to ROCm. It is shown that DGL codebases often run without modification, with 
  seamless integration of graph operations, message passing, sampling, and convolution. 

* The `Graph Neural Networks (GNNs) at Scale: DGL with ROCm on AMD Hardware 
  <https://rocm.blogs.amd.com/artificial-intelligence/why-graph-neural/README.html>`__ 
  blog post introduces the Deep Graph Library (DGL) and its enablement on the AMD ROCm platform, 
  bringing high-performance graph neural network (GNN) training to AMD GPUs. DGL bridges 
  the gap between dense tensor frameworks and the irregular nature of graph data through a 
  graph-first, message-passing abstraction. Its design ensures scalability, flexibility, and 
  interoperability across frameworks like PyTorch and TensorFlow. AMD’s ROCm integration 
  enables DGL to run efficiently on HIP-based GPUs, supported by prebuilt Docker containers 
  and open-source repositories. This marks a major step in AMD's mission to advance open, 
  scalable AI ecosystems beyond traditional architectures.

You can pre-process datasets and begin training on AMD GPUs through:

* Single-GPU training/inference
* Multi-GPU training

.. _dgl-docker-compat:

Docker image compatibility
================================================================================

.. |docker-icon| raw:: html

   <i class="fab fa-docker"></i>

AMD validates and publishes `DGL images <https://hub.docker.com/r/rocm/dgl/tags>`__
with ROCm backends on Docker Hub. The following Docker image tags and associated
inventories represent the latest available DGL version from the official Docker Hub. 
Click the |docker-icon| to view the image on Docker Hub.

.. list-table::
    :header-rows: 1
    :class: docker-image-compatibility

    * - Docker image
      - ROCm
      - DGL
      - PyTorch
      - Ubuntu
      - Python

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/dgl/dgl-2.4.0.amd0_rocm7.0.0_ubuntu24.04_py3.12_pytorch_2.8.0/images/sha256-943698ddf54c22a7bcad2e5b4ff467752e29e4ba6d0c926789ae7b242cbd92dd"><i class="fab fa-docker fa-lg"></i> rocm/dgl</a>

      - `7.0.0 <https://repo.radeon.com/rocm/apt/7.0/>`__
      - `2.4.0 <https://github.com/dmlc/dgl/releases/tag/v2.4.0>`__
      - `2.8.0 <https://github.com/pytorch/pytorch/releases/tag/v2.8.0>`__
      - 24.04
      - `3.12.9 <https://www.python.org/downloads/release/python-3129/>`__

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/dgl/dgl-2.4.0.amd0_rocm7.0.0_ubuntu24.04_py3.12_pytorch_2.6.0/images/sha256-b2ec286a035eb7d0a6aab069561914d21a3cac462281e9c024501ba5ccedfbf7"><i class="fab fa-docker fa-lg"></i> rocm/dgl</a>

      - `7.0.0 <https://repo.radeon.com/rocm/apt/7.0/>`__
      - `2.4.0 <https://github.com/dmlc/dgl/releases/tag/v2.4.0>`__
      - `2.6.0 <https://github.com/pytorch/pytorch/releases/tag/v2.6.0>`__
      - 24.04
      - `3.12.9 <https://www.python.org/downloads/release/python-3129/>`__

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/dgl/dgl-2.4.0.amd0_rocm7.0.0_ubuntu22.04_py3.10_pytorch_2.7.1/images/sha256-d27aee16df922ccf0bcd9107bfcb6d20d34235445d456c637e33ca6f19d11a51"><i class="fab fa-docker fa-lg"></i> rocm/dgl</a>

      - `7.0.0 <https://repo.radeon.com/rocm/apt/7.0/>`__
      - `2.4.0 <https://github.com/dmlc/dgl/releases/tag/v2.4.0>`__
      - `2.7.1 <https://github.com/pytorch/pytorch/releases/tag/v2.7.1>`__
      - 22.04
      - `3.10.16 <https://www.python.org/downloads/release/python-31016/>`__

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/dgl/dgl-2.4.0.amd0_rocm6.4.3_ubuntu24.04_py3.12_pytorch_2.6.0/images/sha256-f3ba6a3c9ec9f6c1cde28449dc9780e0c4c16c4140f4b23f158565fbfd422d6b"><i class="fab fa-docker fa-lg"></i> rocm/dgl</a>

      - `6.4.3 <https://repo.radeon.com/rocm/apt/6.4.3/>`__
      - `2.4.0 <https://github.com/dmlc/dgl/releases/tag/v2.4.0>`__
      - `2.6.0 <https://github.com/pytorch/pytorch/releases/tag/v2.6.0>`__
      - 24.04
      - `3.12.9 <https://www.python.org/downloads/release/python-3129/>`__

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/dgl/dgl-2.4_rocm6.4_ubuntu24.04_py3.12_pytorch_release_2.6.0/images/sha256-8ce2c3bcfaa137ab94a75f9e2ea711894748980f57417739138402a542dd5564"><i class="fab fa-docker fa-lg"></i> rocm/dgl</a>

      - `6.4.0 <https://repo.radeon.com/rocm/apt/6.4/>`__
      - `2.4.0 <https://github.com/dmlc/dgl/releases/tag/v2.4.0>`__
      - `2.6.0 <https://github.com/pytorch/pytorch/releases/tag/v2.6.0>`__
      - 24.04
      - `3.12.9 <https://www.python.org/downloads/release/python-3129/>`__

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/dgl/dgl-2.4_rocm6.4_ubuntu24.04_py3.12_pytorch_release_2.4.1/images/sha256-cf1683283b8eeda867b690229c8091c5bbf1edb9f52e8fb3da437c49a612ebe4"><i class="fab fa-docker fa-lg"></i> rocm/dgl</a>

      - `6.4.0 <https://repo.radeon.com/rocm/apt/6.4/>`__
      - `2.4.0 <https://github.com/dmlc/dgl/releases/tag/v2.4.0>`__
      - `2.4.1 <https://github.com/pytorch/pytorch/releases/tag/v2.4.1>`__
      - 24.04
      - `3.12.9 <https://www.python.org/downloads/release/python-3129/>`__


    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/dgl/dgl-2.4_rocm6.4_ubuntu22.04_py3.10_pytorch_release_2.4.1/images/sha256-4834f178c3614e2d09e89e32041db8984c456d45dfd20286e377ca8635686554"><i class="fab fa-docker fa-lg"></i> rocm/dgl</a>

      - `6.4.0 <https://repo.radeon.com/rocm/apt/6.4/>`__
      - `2.4.0 <https://github.com/dmlc/dgl/releases/tag/v2.4.0>`__
      - `2.4.1 <https://github.com/pytorch/pytorch/releases/tag/v2.4.1>`__
      - 22.04
      - `3.10.16 <https://www.python.org/downloads/release/python-31016/>`__


    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/dgl/dgl-2.4_rocm6.4_ubuntu22.04_py3.10_pytorch_release_2.3.0/images/sha256-88740a2c8ab4084b42b10c3c6ba984cab33dd3a044f479c6d7618e2b2cb05e69"><i class="fab fa-docker fa-lg"></i> rocm/dgl</a>

      - `6.4.0 <https://repo.radeon.com/rocm/apt/6.4/>`__
      - `2.4.0 <https://github.com/dmlc/dgl/releases/tag/v2.4.0>`__
      - `2.3.0 <https://github.com/pytorch/pytorch/releases/tag/v2.3.0>`__
      - 22.04
      - `3.10.16 <https://www.python.org/downloads/release/python-31016/>`__
      

Key ROCm libraries for DGL
================================================================================

DGL on ROCm depends on specific libraries that affect its features and performance.
Using the DGL Docker container or building it with the provided Docker file or a ROCm base image is recommended.
If you prefer to build it yourself, ensure the following dependencies are installed:

.. list-table:: 
    :header-rows: 1

    * - ROCm library
      - ROCm 7.0.0 Version
      - ROCm 6.4.x Version
      - Purpose
    * - `Composable Kernel <https://github.com/ROCm/composable_kernel>`_
      - 1.1.0
      - 1.1.0
      - Enables faster execution of core operations like matrix multiplication
        (GEMM), convolutions and transformations.
    * - `hipBLAS <https://github.com/ROCm/hipBLAS>`_
      - 3.0.0
      - 2.4.0
      - Provides GPU-accelerated Basic Linear Algebra Subprograms (BLAS) for
        matrix and vector operations.
    * - `hipBLASLt <https://github.com/ROCm/hipBLASLt>`_
      - 1.0.0
      - 0.12.0
      - hipBLASLt is an extension of the hipBLAS library, providing additional
        features like epilogues fused into the matrix multiplication kernel or
        use of integer tensor cores.
    * - `hipCUB <https://github.com/ROCm/hipCUB>`_
      - 4.0.0
      - 3.4.0
      - Provides a C++ template library for parallel algorithms for reduction,
        scan, sort and select.
    * - `hipFFT <https://github.com/ROCm/hipFFT>`_
      - 1.0.20
      - 1.0.18
      - Provides GPU-accelerated Fast Fourier Transform (FFT) operations.
    * - `hipRAND <https://github.com/ROCm/hipRAND>`_
      - 3.0.0
      - 2.12.0
      - Provides fast random number generation for GPUs.
    * - `hipSOLVER <https://github.com/ROCm/hipSOLVER>`_
      - 3.0.0
      - 2.4.0
      - Provides GPU-accelerated solvers for linear systems, eigenvalues, and
        singular value decompositions (SVD).
    * - `hipSPARSE <https://github.com/ROCm/hipSPARSE>`_
      - 4.0.1
      - 3.2.0
      - Accelerates operations on sparse matrices, such as sparse matrix-vector
        or matrix-matrix products.
    * - `hipSPARSELt <https://github.com/ROCm/hipSPARSELt>`_
      - 0.2.4
      - 0.2.3
      - Accelerates operations on sparse matrices, such as sparse matrix-vector
        or matrix-matrix products.
    * - `hipTensor <https://github.com/ROCm/hipTensor>`_
      - 2.0.0
      - 1.5.0
      - Optimizes for high-performance tensor operations, such as contractions.
    * - `MIOpen <https://github.com/ROCm/MIOpen>`_
      - 3.5.0
      - 3.4.0
      - Optimizes deep learning primitives such as convolutions, pooling,
        normalization, and activation functions.
    * - `MIGraphX <https://github.com/ROCm/AMDMIGraphX>`_
      - 2.13.0
      - 2.12.0
      - Adds graph-level optimizations, ONNX models and mixed precision support
        and enable Ahead-of-Time (AOT) Compilation.
    * - `MIVisionX <https://github.com/ROCm/MIVisionX>`_
      - 3.3.0
      - 3.2.0
      - Optimizes acceleration for computer vision and AI workloads like
        preprocessing, augmentation, and inferencing.
    * - `rocAL <https://github.com/ROCm/rocAL>`_
      - 3.3.0
      - 2.2.0
      - Accelerates the data pipeline by offloading intensive preprocessing and
        augmentation tasks. rocAL is part of MIVisionX.
    * - `RCCL <https://github.com/ROCm/rccl>`_
      - 2.26.6
      - 2.22.3
      - Optimizes for multi-GPU communication for operations like AllReduce and
        Broadcast.
    * - `rocDecode <https://github.com/ROCm/rocDecode>`_
      - 1.0.0
      - 0.10.0
      - Provides hardware-accelerated data decoding capabilities, particularly
        for image, video, and other dataset formats.
    * - `rocJPEG <https://github.com/ROCm/rocJPEG>`_
      - 1.1.0
      - 0.8.0
      - Provides hardware-accelerated JPEG image decoding and encoding.
    * - `RPP <https://github.com/ROCm/RPP>`_
      - 2.0.0
      - 1.9.10
      - Speeds up data augmentation, transformation, and other preprocessing steps.
    * - `rocThrust <https://github.com/ROCm/rocThrust>`_
      - 4.0.0
      - 3.3.0
      - Provides a C++ template library for parallel algorithms like sorting,
        reduction, and scanning.
    * - `rocWMMA <https://github.com/ROCm/rocWMMA>`_
      - 2.0.0
      - 1.7.0
      - Accelerates warp-level matrix-multiply and matrix-accumulate to speed up matrix
        multiplication (GEMM) and accumulation operations with mixed precision
        support.


Supported features
================================================================================

Many functions and methods available upstream are also supported in DGL on ROCm.
Instead of listing them all, support is grouped into the following categories to provide a general overview. 

* DGL Base
* DGL Backend 
* DGL Data
* DGL Dataloading
* DGL Graph
* DGL Function
* DGL Ops
* DGL Sampling
* DGL Transforms
* DGL Utils
* DGL Distributed
* DGL Geometry
* DGL Mpops
* DGL NN
* DGL Optim
* DGL Sparse
* GraphBolt

Unsupported features
================================================================================

* TF32 Support (only supported for PyTorch 2.7 and above)
* Kineto/ROCTracer integration


Unsupported functions
================================================================================

* ``bfs``
* ``format``
* ``multiprocess_sparse_adam_state_dict``
* ``half_spmm``
* ``segment_mm`` 
* ``gather_mm_idx_b``
* ``sample_labors_prob``
* ``sample_labors_noprob``
* ``sparse_admin``

Previous versions
===============================================================================
See :doc:`rocm-install-on-linux:install/3rd-party/previous-versions/dgl-history` to find documentation for previous releases
of the ``ROCm/dgl`` Docker image.