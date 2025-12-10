:orphan:

.. meta::
    :description: PyTorch compatibility
    :keywords: GPU, PyTorch, deep learning, framework compatibility

.. version-set:: rocm_version latest

********************************************************************************
PyTorch compatibility
********************************************************************************

`PyTorch <https://pytorch.org/>`__ is an open-source tensor library designed for
deep learning. PyTorch on ROCm provides mixed-precision and large-scale training
using `MIOpen <https://github.com/ROCm/MIOpen>`__ and
`RCCL <https://github.com/ROCm/rccl>`__ libraries.

PyTorch provides two high-level features:

- Tensor computation (like NumPy) with strong GPU acceleration

- Deep neural networks built on a tape-based autograd system (rapid computation 
  of multiple partial derivatives or gradients)

Support overview
================================================================================

ROCm support for PyTorch is upstreamed into the official PyTorch repository. 
ROCm development is aligned with the stable release of PyTorch, while upstream 
PyTorch testing uses the stable release of ROCm to maintain consistency:

- The ROCm-supported version of PyTorch is maintained in the official `https://github.com/ROCm/pytorch 
  <https://github.com/ROCm/pytorch>`__ repository, which differs from the 
  `https://github.com/pytorch/pytorch <https://github.com/pytorch/pytorch>`__ upstream repository.

- To get started and install PyTorch on ROCm, use the prebuilt :ref:`Docker images <pytorch-docker-compat>`, 
  which include ROCm, PyTorch, and all required dependencies.

  - See the :doc:`ROCm PyTorch installation guide <rocm-install-on-linux:install/3rd-party/pytorch-install>` 
    for installation and setup instructions.

  - You can also consult the upstream `Installation guide <https://pytorch.org/get-started/locally/>`__ or 
    `Previous versions <https://pytorch.org/get-started/previous-versions/>`__ for additional context.

PyTorch includes tooling that generates HIP source code from the CUDA backend.
This approach allows PyTorch to support ROCm without requiring manual code
modifications. For more information, see :doc:`HIPIFY <hipify:index>`.

Version support
--------------------------------------------------------------------------------

AMD releases official `ROCm PyTorch Docker images <https://hub.docker.com/r/rocm/pytorch/tags>`_
quarterly alongside new ROCm releases. These images undergo full AMD testing.

.. _pytorch-recommendations:

Use cases and recommendations
================================================================================

* :doc:`Using ROCm for AI: training a model </how-to/rocm-for-ai/training/benchmark-docker/pytorch-training>`
  guides how to leverage the ROCm platform for training AI models. It covers the
  steps, tools, and best practices for optimizing training workflows on AMD GPUs
  using PyTorch features.

* :doc:`Single-GPU fine-tuning and inference </how-to/rocm-for-ai/fine-tuning/single-gpu-fine-tuning-and-inference>`
  describes and demonstrates how to use the ROCm platform for the fine-tuning
  and inference of machine learning models, particularly large language models
  (LLMs), on systems with a single GPU. This topic provides a detailed guide for
  setting up, optimizing, and executing fine-tuning and inference workflows in
  such environments.

* :doc:`Multi-GPU fine-tuning and inference optimization </how-to/rocm-for-ai/fine-tuning/multi-gpu-fine-tuning-and-inference>`
  describes and demonstrates the fine-tuning and inference of machine learning
  models on systems with multiple GPUs.

* The :doc:`Instinct MI300X workload optimization guide </how-to/rocm-for-ai/inference-optimization/workload>`
  provides detailed guidance on optimizing workloads for the AMD Instinct MI300X
  GPU using ROCm. This guide helps users achieve optimal performance for
  deep learning and other high-performance computing tasks on the MI300X
  GPU.

* The :doc:`Inception with PyTorch documentation </conceptual/ai-pytorch-inception>`
  describes how PyTorch integrates with ROCm for AI workloads. It outlines the
  use of PyTorch on the ROCm platform and focuses on efficiently leveraging AMD
  GPU hardware for training and inference tasks in AI applications.

For more use cases and recommendations, see `ROCm PyTorch blog posts <https://rocm.blogs.amd.com/blog/tag/pytorch.html>`__.

.. _pytorch-docker-compat:

Docker image compatibility
================================================================================

AMD validates and publishes `PyTorch images <https://hub.docker.com/r/rocm/pytorch/tags>`__
with ROCm backends on Docker Hub.

To find the right image tag, see the :ref:`PyTorch on ROCm installation
documentation <rocm-install-on-linux:pytorch-docker-support>` for a list of
available ``rocm/pytorch`` images.

Key ROCm libraries for PyTorch
================================================================================

PyTorch functionality on ROCm is determined by its underlying library
dependencies. These ROCm components affect the capabilities, performance, and
feature set available to developers.

.. list-table::
    :header-rows: 1

    * - ROCm library
      - Version
      - Purpose
      - Used in
    * - `Composable Kernel <https://github.com/ROCm/composable_kernel>`__
      - :version-ref:`"Composable Kernel" rocm_version`
      - Enables faster execution of core operations like matrix multiplication
        (GEMM), convolutions and transformations.
      - Speeds up ``torch.permute``, ``torch.view``, ``torch.matmul``,
        ``torch.mm``, ``torch.bmm``, ``torch.nn.Conv2d``, ``torch.nn.Conv3d``
        and ``torch.nn.MultiheadAttention``.
    * - `hipBLAS <https://github.com/ROCm/hipBLAS>`__
      - :version-ref:`hipBLAS rocm_version`
      - Provides GPU-accelerated Basic Linear Algebra Subprograms (BLAS) for
        matrix and vector operations.
      - Supports operations such as matrix multiplication, matrix-vector
        products, and tensor contractions. Utilized in both dense and batched
        linear algebra operations.
    * - `hipBLASLt <https://github.com/ROCm/hipBLASLt>`__
      - :version-ref:`hipBLASLt rocm_version`
      - hipBLASLt is an extension of the hipBLAS library, providing additional
        features like epilogues fused into the matrix multiplication kernel or
        use of integer tensor cores.
      - Accelerates operations such as ``torch.matmul``, ``torch.mm``, and the
        matrix multiplications used in convolutional and linear layers.
    * - `hipCUB <https://github.com/ROCm/hipCUB>`__
      - :version-ref:`hipCUB rocm_version`
      - Provides a C++ template library for parallel algorithms for reduction,
        scan, sort and select.
      - Supports operations such as ``torch.sum``, ``torch.cumsum``,
        ``torch.sort`` irregular shapes often involve scanning, sorting, and
        filtering, which hipCUB handles efficiently.
    * - `hipFFT <https://github.com/ROCm/hipFFT>`__
      - :version-ref:`hipFFT rocm_version`
      - Provides GPU-accelerated Fast Fourier Transform (FFT) operations.
      - Used in functions like the ``torch.fft`` module.
    * - `hipRAND <https://github.com/ROCm/hipRAND>`__
      - :version-ref:`hipRAND rocm_version`
      - Provides fast random number generation for GPUs.
      - The ``torch.rand``, ``torch.randn``, and stochastic layers like
        ``torch.nn.Dropout`` rely on hipRAND.
    * - `hipSOLVER <https://github.com/ROCm/hipSOLVER>`__
      - :version-ref:`hipSOLVER rocm_version`
      - Provides GPU-accelerated solvers for linear systems, eigenvalues, and
        singular value decompositions (SVD).
      - Supports functions like ``torch.linalg.solve``,
        ``torch.linalg.eig``, and ``torch.linalg.svd``.
    * - `hipSPARSE <https://github.com/ROCm/hipSPARSE>`__
      - :version-ref:`hipSPARSE rocm_version`
      - Accelerates operations on sparse matrices, such as sparse matrix-vector
        or matrix-matrix products.
      - Sparse tensor operations ``torch.sparse``.
    * - `hipSPARSELt <https://github.com/ROCm/hipSPARSELt>`__
      - :version-ref:`hipSPARSELt rocm_version`
      - Accelerates operations on sparse matrices, such as sparse matrix-vector
        or matrix-matrix products.
      - Sparse tensor operations ``torch.sparse``.
    * - `hipTensor <https://github.com/ROCm/hipTensor>`__
      - :version-ref:`hipTensor rocm_version`
      - Optimizes for high-performance tensor operations, such as contractions.
      - Accelerates tensor algebra, especially in deep learning and scientific
        computing.
    * - `MIOpen <https://github.com/ROCm/MIOpen>`__
      - :version-ref:`MIOpen rocm_version`
      - Optimizes deep learning primitives such as convolutions, pooling,
        normalization, and activation functions.
      - Speeds up convolutional neural networks (CNNs), recurrent neural
        networks (RNNs), and other layers. Used in operations like
        ``torch.nn.Conv2d``, ``torch.nn.ReLU``, and ``torch.nn.LSTM``.
    * - `MIGraphX <https://github.com/ROCm/AMDMIGraphX>`__
      - :version-ref:`MIGraphX rocm_version`
      - Adds graph-level optimizations, ONNX models and mixed precision support
        and enable Ahead-of-Time (AOT) Compilation.
      - Speeds up inference models and executes ONNX models for
        compatibility with other frameworks.
        ``torch.nn.Conv2d``, ``torch.nn.ReLU``, and ``torch.nn.LSTM``.
    * - `MIVisionX <https://github.com/ROCm/MIVisionX>`__
      - :version-ref:`MIVisionX rocm_version`
      - Optimizes acceleration for computer vision and AI workloads like
        preprocessing, augmentation, and inferencing.
      - Faster data preprocessing and augmentation pipelines for datasets like
        ImageNet or COCO and easy to integrate into PyTorch's ``torch.utils.data``
        and ``torchvision`` workflows.
    * - `rocAL <https://github.com/ROCm/rocAL>`__
      - :version-ref:`rocAL rocm_version`
      - Accelerates the data pipeline by offloading intensive preprocessing and
        augmentation tasks. rocAL is part of MIVisionX.
      - Easy to integrate into PyTorch's ``torch.utils.data`` and
        ``torchvision`` data load workloads.
    * - `RCCL <https://github.com/ROCm/rccl>`__
      - :version-ref:`RCCL rocm_version`
      - Optimizes for multi-GPU communication for operations like AllReduce and
        Broadcast.
      - Distributed data parallel training (``torch.nn.parallel.DistributedDataParallel``).
        Handles communication in multi-GPU setups.
    * - `rocDecode <https://github.com/ROCm/rocDecode>`__
      - :version-ref:`rocDecode rocm_version`
      - Provides hardware-accelerated data decoding capabilities, particularly
        for image, video, and other dataset formats.
      - Can be integrated in ``torch.utils.data``, ``torchvision.transforms``
        and ``torch.distributed``.
    * - `rocJPEG <https://github.com/ROCm/rocJPEG>`__
      - :version-ref:`rocJPEG rocm_version`
      - Provides hardware-accelerated JPEG image decoding and encoding.
      - GPU accelerated ``torchvision.io.decode_jpeg`` and
        ``torchvision.io.encode_jpeg`` and can be integrated in
        ``torch.utils.data`` and ``torchvision``.
    * - `RPP <https://github.com/ROCm/RPP>`__
      - :version-ref:`RPP rocm_version`
      - Speeds up data augmentation, transformation, and other preprocessing steps.
      - Easy to integrate into PyTorch's ``torch.utils.data`` and
        ``torchvision`` data load workloads to speed up data processing.
    * - `rocThrust <https://github.com/ROCm/rocThrust>`__
      - :version-ref:`rocThrust rocm_version`
      - Provides a C++ template library for parallel algorithms like sorting,
        reduction, and scanning.
      - Utilized in backend operations for tensor computations requiring
        parallel processing.
    * - `rocWMMA <https://github.com/ROCm/rocWMMA>`__
      - :version-ref:`rocWMMA rocm_version`
      - Accelerates warp-level matrix-multiply and matrix-accumulate to speed up matrix
        multiplication (GEMM) and accumulation operations with mixed precision
        support.
      - Linear layers (``torch.nn.Linear``), convolutional layers
        (``torch.nn.Conv2d``), attention layers, general tensor operations that
        involve matrix products, such as ``torch.matmul``, ``torch.bmm``, and
        more.

Supported modules and data types
================================================================================

The following section outlines the supported data types, modules, and domain
libraries available in PyTorch on ROCm.

Supported data types
--------------------------------------------------------------------------------

The tensor data type is specified using the ``dtype`` attribute or argument.
PyTorch supports many data types for different use cases.

The following table lists `torch.Tensor <https://pytorch.org/docs/stable/tensors.html>`__
single data types:

.. list-table::
    :header-rows: 1

    * - Data type
      - Description
    * - ``torch.float8_e4m3fn``
      - 8-bit floating point, e4m3
    * - ``torch.float8_e5m2``
      - 8-bit floating point, e5m2
    * - ``torch.float16`` or ``torch.half``
      - 16-bit floating point
    * - ``torch.bfloat16``
      - 16-bit floating point
    * - ``torch.float32`` or ``torch.float``
      - 32-bit floating point
    * - ``torch.float64`` or ``torch.double``
      - 64-bit floating point
    * - ``torch.complex32`` or ``torch.chalf``
      - 32-bit complex numbers
    * - ``torch.complex64`` or ``torch.cfloat``
      - 64-bit complex numbers
    * - ``torch.complex128`` or ``torch.cdouble``
      - 128-bit complex numbers
    * - ``torch.uint8``
      - 8-bit integer (unsigned)
    * - ``torch.uint16``
      - 16-bit integer (unsigned);
        Not natively supported in ROCm
    * - ``torch.uint32``
      - 32-bit integer (unsigned);
        Not natively supported in ROCm
    * - ``torch.uint64``
      - 64-bit integer (unsigned);
        Not natively supported in ROCm
    * - ``torch.int8``
      - 8-bit integer (signed)
    * - ``torch.int16`` or ``torch.short``
      - 16-bit integer (signed)
    * - ``torch.int32`` or ``torch.int``
      - 32-bit integer (signed)
    * - ``torch.int64`` or ``torch.long``
      - 64-bit integer (signed)
    * - ``torch.bool``
      - Boolean
    * - ``torch.quint8``
      - Quantized 8-bit integer (unsigned)
    * - ``torch.qint8``
      - Quantized 8-bit integer (signed)
    * - ``torch.qint32``
      - Quantized 32-bit integer (signed)
    * - ``torch.quint4x2``
      - Quantized 4-bit integer (unsigned)

.. note::

  Unsigned types, except ``uint8``, have limited support in eager mode. They
  primarily exist to assist usage with ``torch.compile``.

  See :doc:`ROCm precision support <rocm:reference/precision-support>` for the
  native hardware support of data types.

Supported modules
--------------------------------------------------------------------------------

For a complete and up-to-date list of PyTorch core modules (for example., ``torch``,
``torch.nn``, ``torch.cuda``, ``torch.backends.cuda`` and
``torch.backends.cudnn``), their descriptions, and usage, please refer directly
to the `official PyTorch documentation <https://pytorch.org/docs/stable/index.html>`_.

Core PyTorch functionality on ROCm includes tensor operations, neural network
layers, automatic differentiation, distributed training, mixed-precision
training, compilation features, and domain-specific libraries for audio, vision,
text processing, and more.

Supported domain libraries
--------------------------------------------------------------------------------

PyTorch offers specialized `domain libraries <https://pytorch.org/domains/>`_ with
GPU acceleration that build on its core features to support specific application
areas. The table below lists the PyTorch domain libraries that are compatible
with ROCm.

.. list-table::
    :header-rows: 1

    * - Library
      - Description

    * - `torchaudio <https://docs.pytorch.org/audio/stable/index.html>`_
      - Audio and signal processing library for PyTorch. Provides utilities for
        audio I/O, signal and data processing functions, datasets, model
        implementations, and application components for audio and speech
        processing tasks.

        **Note:** To ensure GPU-acceleration with ``torchaudio.transforms``,
        you need to explicitly move audio data (waveform tensor) to GPU using
        ``.to('cuda')``.

    * - `torchtune <https://meta-pytorch.org/torchtune/stable/index.html>`_
      - PyTorch-native library designed for fine-tuning large language models
        (LLMs). Provides supports the full fine-tuning workflow and offers
        compatibility with popular production inference systems.

        **Note:** Only official release exists.

    * - `torchvision <https://docs.pytorch.org/vision/stable/index.html>`_
      - Computer vision library that is part of the PyTorch project. Provides
        popular datasets, model architectures, and common image transformations
        for computer vision applications.

    * - `torchdata <https://meta-pytorch.org/data/beta/index.html#torchdata>`_
      - Beta library of common modular data loading primitives for easily
        constructing flexible and performant data pipelines, with features still
        in prototype stage.

    * - `torchrec <https://meta-pytorch.org/torchrec/>`_
      - PyTorch domain library for common sparsity and parallelism primitives
        needed for large-scale recommender systems, enabling authors to train
        models with large embedding tables shared across many GPUs.

        **Note:** ``torchrec`` does not implement ROCm-specific kernels. ROCm
        acceleration is provided through the underlying PyTorch framework and
        ROCm library integration.

    * - `torchserve <https://docs.pytorch.org/serve/>`_
      - Performant, flexible and easy-to-use tool for serving PyTorch models in
        production, providing features for model management, batch processing,
        and scalable deployment.

        **Note:** `torchserve <https://docs.pytorch.org/serve/>`_ is no longer
        actively maintained. Last official release is sent out with PyTorch 2.4.

    * - `torchrl <https://docs.pytorch.org/rl/stable/index.html>`_
      - Open-source, Python-first Reinforcement Learning library for PyTorch
        with a focus on high modularity and good runtime performance, providing
        low and high-level RL abstractions and reusable functionals for cost
        functions, returns, and data processing.

        **Note:** Only official release exists.

    * - `tensordict <https://docs.pytorch.org/tensordict/stable/index.html>`_
      - Dictionary-like class that simplifies operations on batches of tensors,
        enhancing code readability, compactness, and modularity by abstracting
        tailored operations and reducing errors through automatic operation
        dispatching.

        **Note:** Only official release exists.

Key features and enhancements for PyTorch 2.9 with ROCm 7.1.1
================================================================================
- Scaled Dot Product Attention (SDPA) upgraded to use AOTriton version 0.11b.

- Default hipBLASLt support enabled for gfx908 architecture on ROCm 6.3 and later.

- MIOpen now supports channels last memory format for 3D convolutions and batch normalization.

- NHWC convolution operations in MIOpen optimized by eliminating unnecessary transpose operations.

- Improved tensor.item() performance by removing redundant synchronization.

- Enhanced performance for element-wise operations and reduction kernels.

- Added support for grouped GEMM operations through fbgemm_gpu generative AI components.

- Resolved device error in Inductor when using CUDA graph trees with HIP.

- Corrected logsumexp scaling in AOTriton-based SDPA implementation.

- Added stream graph capture status validation in memory copy synchronization functions.

Key features and enhancements for PyTorch 2.8 with ROCm 7.1
================================================================================

- MIOpen deep learning optimizations: Further optimized NHWC BatchNorm feature.

- Added float8 support for the DeepSpeed extension, allowing for decreased
  memory footprint and increased throughput in training and inference workloads.

- ``torch.nn.functional.scaled_dot_product_attention`` now calling optimized
  flash attention kernel automatically.

Key features and enhancements for PyTorch 2.7/2.8 with ROCm 7.0
================================================================================

- Enhanced TunableOp framework: Introduces ``tensorfloat32`` support for
  TunableOp operations, improved offline tuning for ScaledGEMM operations,
  submatrix offline tuning capabilities, and better logging for BLAS operations
  without bias vectors.

- Expanded GPU architecture support: Provides optimized support for newer GPU
  architectures, including gfx1200 and gfx1201 with preferred hipBLASLt backend
  selection, along with improvements for gfx950 and gfx1100 Series GPUs.

- Advanced Triton Integration: AOTriton 0.10b introduces official support for
  gfx950 and gfx1201, along with experimental support for gfx1101, gfx1151,
  gfx1150, and gfx1200.

- Improved element-wise kernel performance: Delivers enhanced vectorized
  element-wise kernels with better support for heterogeneous tensor types and
  optimized input vectorization for tensors with mixed data types.

- MIOpen deep learning optimizations: Enables NHWC BatchNorm by default on
  ROCm 7.0+, provides ``maxpool`` forward and backward performance improvements
  targeting ResNet scenarios, and includes updated launch configurations for
  better performance.

- Enhanced memory and tensor operations: Features fixes for in-place ``aten``
  sum operations with specialized templated kernels, improved 3D tensor
  performance with NHWC format, and better handling of memory-bound matrix
  multiplication operations.

- Robust testing and quality improvements: Includes comprehensive test suite
  updates with improved tolerance handling for Navi3x architectures, generalized
  ROCm-specific test conditions, and enhanced unit test coverage for Flash
  Attention and Memory Efficient operations.

- Composable Kernel (CK) updates: Features updated CK submodule integration with
  the latest optimizations and performance improvements for core mathematical
  operations.

- Development and debugging enhancements: Includes improved source handling for
  dynamic compilation, better error handling for atomic operations, and enhanced
  state checking for trace operations.

- Integrate APEX fused layer normalization, which can have positive impact on
  text-to-video models.

- Integrate APEX distributed fused LAMB and distributed fused ADAM, which can
  have positive impact on BERT-L and Llama2-SFT.

- FlashAttention v3 has been integrated for AMD GPUs.

- `Pytorch C++ extensions <https://pytorch.org/tutorials/advanced/cpp_extension.html>`_
  provide a mechanism for compiling custom operations that can be used during
  network training or inference. For AMD platforms, ``amdclang++`` has been
  validated as the supported compiler for building these extensions.

Known issues and notes for PyTorch 2.7/2.8 with ROCm 7.0 and ROCm 7.1
================================================================================

- The ``matmul.allow_fp16_reduced_precision_reduction`` and
  ``matmul.allow_bf16_reduced_precision_reduction`` options under
  ``torch.backends.cuda`` are not supported. As a result,
  reduced-precision reductions using FP16 or BF16 accumulation types are not
  available.
