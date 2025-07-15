:orphan:

.. meta::
    :description: Deep Graph Library (DGL) compatibility
    :keywords: GPU, DGL compatibility

.. version-set:: rocm_version latest

********************************************************************************
DGL compatibility
********************************************************************************

Deep Graph Library `(DGL) <https://www.dgl.ai/>`_ is an easy-to-use, high-performance and scalable 
Python package for deep learning on graphs. DGL is framework agnostic, meaning 
if a deep graph model is a component in an end-to-end application, the rest of 
the logic is implemented using PyTorch.  

* ROCm support for DGL is hosted in the `https://github.com/ROCm/dgl <https://github.com/ROCm/dgl>`_ repository. 
* Due to independent compatibility considerations, this location differs from the `https://github.com/dmlc/dgl <https://github.com/dmlc/dgl>`_ upstream repository. 
* Use the prebuilt :ref:`Docker images <dgl-docker-compat>` with DGL, PyTorch, and ROCm preinstalled.
* See the :doc:`ROCm DGL installation guide <rocm-install-on-linux:install/3rd-party/dgl-install>` 
  to install and get started.


Supported devices
================================================================================

- **Officially Supported**: TF32 with AMD Instinct MI300X (through hipblaslt)
- **Partially Supported**: TF32 with AMD Instinct MI250X


.. _dgl-recommendations:

Use cases and recommendations
================================================================================

DGL can be used for Graph Learning, and building popular graph models like  
GAT, GCN and GraphSage. Using these we can support a variety of use-cases such as:

- Recommender systems
- Network Optimization and Analysis
- 1D (Temporal) and 2D (Image) Classification
- Drug Discovery

Refer to :doc:`ROCm DGL blog posts <https://rocm.blogs.amd.com/blog/tag/dgl.html>` 
for examples and best practices to optimize your training workflows on AMD GPUs. 

Coverage includes:

- Single-GPU training/inference
- Multi-GPU training

Benchmarking details are included in the :doc:`Benchmarks` section.


.. _dgl-docker-compat:

Docker image compatibility
================================================================================

.. |docker-icon| raw:: html

   <i class="fab fa-docker"></i>

AMD validates and publishes `DGL images <https://hub.docker.com/r/rocm/dgl>`_
with ROCm and Pytorch backends on Docker Hub. The following Docker image tags and associated
inventories were tested on `ROCm 6.4.0 <https://repo.radeon.com/rocm/apt/6.4/>`_.
Click the |docker-icon| to view the image on Docker Hub.

.. list-table:: DGL Docker image components
    :header-rows: 1
    :class: docker-image-compatibility

    * - Docker
      - DGL
      - PyTorch
      - Ubuntu
      - Python

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/dgl/dgl-2.4_rocm6.4_ubuntu24.04_py3.12_pytorch_release_2.6.0/images/sha256-8ce2c3bcfaa137ab94a75f9e2ea711894748980f57417739138402a542dd5564"><i class="fab fa-docker fa-lg"></i></a>

      - `2.4.0 <https://github.com/dmlc/dgl/releases/tag/v2.4.0>`_
      - `2.6.0 <https://github.com/ROCm/pytorch/tree/release/2.6>`_
      - 24.04
      - `3.12.9 <https://www.python.org/downloads/release/python-3129/>`_

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/dgl/dgl-2.4_rocm6.4_ubuntu24.04_py3.12_pytorch_release_2.4.1/images/sha256-cf1683283b8eeda867b690229c8091c5bbf1edb9f52e8fb3da437c49a612ebe4"><i class="fab fa-docker fa-lg"></i></a>

      - `2.4.0 <https://github.com/dmlc/dgl/releases/tag/v2.4.0>`_
      - `2.4.1 <https://github.com/ROCm/pytorch/tree/release/2.4>`_
      - 24.04
      - `3.12.9 <https://www.python.org/downloads/release/python-3129/>`_


    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/dgl/dgl-2.4_rocm6.4_ubuntu22.04_py3.10_pytorch_release_2.4.1/images/sha256-4834f178c3614e2d09e89e32041db8984c456d45dfd20286e377ca8635686554"><i class="fab fa-docker fa-lg"></i></a>

      - `2.4.0 <https://github.com/dmlc/dgl/releases/tag/v2.4.0>`_
      - `2.4.1 <https://github.com/ROCm/pytorch/tree/release/2.4>`_
      - 22.04
      - `3.10.16 <https://www.python.org/downloads/release/python-31016/>`_


    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/dgl/dgl-2.4_rocm6.4_ubuntu22.04_py3.10_pytorch_release_2.3.0/images/sha256-88740a2c8ab4084b42b10c3c6ba984cab33dd3a044f479c6d7618e2b2cb05e69"><i class="fab fa-docker fa-lg"></i></a>

      - `2.4.0 <https://github.com/dmlc/dgl/releases/tag/v2.4.0>`_
      - `2.3.0 <https://github.com/ROCm/pytorch/tree/release/2.3>`_
      - 22.04
      - `3.10.16 <https://www.python.org/downloads/release/python-31016/>`_
      

Key ROCm libraries for DGL
================================================================================

DGL on ROCm depends on specific libraries that affect its features and performance.
Using the DGL Docker container or building it with the provided docker file or a ROCm base image is recommended.
If you prefer to build it yourself, ensure the following dependencies are installed:

.. list-table:: 
    :header-rows: 1

    * - ROCm library
      - Version
      - Purpose
    * - `Composable Kernel <https://github.com/ROCm/composable_kernel>`_
      - :version-ref:`"Composable Kernel" rocm_version`
      - Enables faster execution of core operations like matrix multiplication
        (GEMM), convolutions and transformations.
    * - `hipBLAS <https://github.com/ROCm/hipBLAS>`_
      - :version-ref:`hipBLAS rocm_version`
      - Provides GPU-accelerated Basic Linear Algebra Subprograms (BLAS) for
        matrix and vector operations.
    * - `hipBLASLt <https://github.com/ROCm/hipBLASLt>`_
      - :version-ref:`hipBLASLt rocm_version`
      - hipBLASLt is an extension of the hipBLAS library, providing additional
        features like epilogues fused into the matrix multiplication kernel or
        use of integer tensor cores.
    * - `hipCUB <https://github.com/ROCm/hipCUB>`_
      - :version-ref:`hipCUB rocm_version`
      - Provides a C++ template library for parallel algorithms for reduction,
        scan, sort and select.
    * - `hipFFT <https://github.com/ROCm/hipFFT>`_
      - :version-ref:`hipFFT rocm_version`
      - Provides GPU-accelerated Fast Fourier Transform (FFT) operations.
    * - `hipRAND <https://github.com/ROCm/hipRAND>`_
      - :version-ref:`hipRAND rocm_version`
      - Provides fast random number generation for GPUs.
    * - `hipSOLVER <https://github.com/ROCm/hipSOLVER>`_
      - :version-ref:`hipSOLVER rocm_version`
      - Provides GPU-accelerated solvers for linear systems, eigenvalues, and
        singular value decompositions (SVD).
    * - `hipSPARSE <https://github.com/ROCm/hipSPARSE>`_
      - :version-ref:`hipSPARSE rocm_version`
      - Accelerates operations on sparse matrices, such as sparse matrix-vector
        or matrix-matrix products.
    * - `hipSPARSELt <https://github.com/ROCm/hipSPARSELt>`_
      - :version-ref:`hipSPARSELt rocm_version`
      - Accelerates operations on sparse matrices, such as sparse matrix-vector
        or matrix-matrix products.
    * - `hipTensor <https://github.com/ROCm/hipTensor>`_
      - :version-ref:`hipTensor rocm_version`
      - Optimizes for high-performance tensor operations, such as contractions.
    * - `MIOpen <https://github.com/ROCm/MIOpen>`_
      - :version-ref:`MIOpen rocm_version`
      - Optimizes deep learning primitives such as convolutions, pooling,
        normalization, and activation functions.
    * - `MIGraphX <https://github.com/ROCm/AMDMIGraphX>`_
      - :version-ref:`MIGraphX rocm_version`
      - Adds graph-level optimizations, ONNX models and mixed precision support
        and enable Ahead-of-Time (AOT) Compilation.
    * - `MIVisionX <https://github.com/ROCm/MIVisionX>`_
      - :version-ref:`MIVisionX rocm_version`
      - Optimizes acceleration for computer vision and AI workloads like
        preprocessing, augmentation, and inferencing.
    * - `rocAL <https://github.com/ROCm/rocAL>`_
      - :version-ref:`rocAL rocm_version`
      - Accelerates the data pipeline by offloading intensive preprocessing and
        augmentation tasks. rocAL is part of MIVisionX.
    * - `RCCL <https://github.com/ROCm/rccl>`_
      - :version-ref:`RCCL rocm_version`
      - Optimizes for multi-GPU communication for operations like AllReduce and
        Broadcast.
    * - `rocDecode <https://github.com/ROCm/rocDecode>`_
      - :version-ref:`rocDecode rocm_version`
      - Provides hardware-accelerated data decoding capabilities, particularly
        for image, video, and other dataset formats.
    * - `rocJPEG <https://github.com/ROCm/rocJPEG>`_
      - :version-ref:`rocJPEG rocm_version`
      - Provides hardware-accelerated JPEG image decoding and encoding.
    * - `RPP <https://github.com/ROCm/RPP>`_
      - :version-ref:`RPP rocm_version`
      - Speeds up data augmentation, transformation, and other preprocessing steps.
    * - `rocThrust <https://github.com/ROCm/rocThrust>`_
      - :version-ref:`rocThrust rocm_version`
      - Provides a C++ template library for parallel algorithms like sorting,
        reduction, and scanning.
    * - `rocWMMA <https://github.com/ROCm/rocWMMA>`_
      - :version-ref:`rocWMMA rocm_version`
      - Accelerates warp-level matrix-multiply and matrix-accumulate to speed up matrix
        multiplication (GEMM) and accumulation operations with mixed precision
        support.


Supported features
================================================================================

Many functions and methods available in DGL Upstream are also supported in DGL ROCm.
Instead of listing them all, support is grouped into the following categories to provide a general overview. 

* DGL Base
* DGL Backend 
* DGL Data
* DGL Dataloading
* DGL DGLGraph
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


Unsupported features
================================================================================

* Graphbolt
* Partial TF32 Support (MI250x only)
* Kineto/ ROCTracer integration


Unsupported functions
================================================================================

* ``more_nnz``
* ``format``
* ``multiprocess_sparse_adam_state_dict``
* ``record_stream_ndarray``
* ``half_spmm``
* ``segment_mm`` 
* ``gather_mm_idx_b``
* ``pgexplainer``
* ``sample_labors_prob``
* ``sample_labors_noprob``