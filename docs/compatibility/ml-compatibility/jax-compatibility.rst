:orphan:

.. meta::
   :description: JAX compatibility
   :keywords: GPU, JAX, deep learning, framework compatibility

.. version-set:: rocm_version latest

*******************************************************************************
JAX compatibility
*******************************************************************************

`JAX <https://docs.jax.dev/en/latest/notebooks/thinking_in_jax.html>`__ is a library 
for array-oriented numerical computation (similar to NumPy), with automatic differentiation 
and just-in-time (JIT) compilation to enable high-performance machine learning research.

JAX provides an API that combines automatic differentiation and the 
Accelerated Linear Algebra (XLA) compiler to achieve high-performance machine 
learning at scale. JAX uses composable transformations of Python and NumPy through 
JIT compilation, automatic vectorization, and parallelization.

Support overview
================================================================================

- The ROCm-supported version of JAX is maintained in the official `https://github.com/ROCm/rocm-jax 
  <https://github.com/ROCm/rocm-jax>`__ repository, which differs from the 
  `https://github.com/jax-ml/jax <https://github.com/jax-ml/jax>`__ upstream repository.

- To get started and install JAX on ROCm, use the prebuilt :ref:`Docker images <jax-docker-compat>`, 
  which include ROCm, JAX, and all required dependencies.

  - See the :doc:`ROCm JAX installation guide <rocm-install-on-linux:install/3rd-party/jax-install>` 
    for installation and setup instructions.

  - You can also consult the upstream `Installation guide <https://jax.readthedocs.io/en/latest/installation.html#amd-gpu-linux>`__ 
    for additional context.

Version support
--------------------------------------------------------------------------------

AMD releases official `ROCm JAX Docker images <https://hub.docker.com/r/rocm/jax/tags>`_
quarterly alongside new ROCm releases. These images undergo full AMD testing.
`Community ROCm JAX Docker images <https://hub.docker.com/r/rocm/jax-community/tags>`_
follow upstream JAX releases and use the latest available ROCm version.

Use cases and recommendations
================================================================================

* The `nanoGPT in JAX <https://rocm.blogs.amd.com/artificial-intelligence/nanoGPT-JAX/README.html>`_
  blog explores the implementation and training of a Generative Pre-trained
  Transformer (GPT) model in JAX, inspired by Andrej Karpathy’s JAX-based
  nanoGPT. Comparing how essential GPT components—such as self-attention
  mechanisms and optimizers—are realized in JAX and JAX, also highlights
  JAX’s unique features.

* The `Optimize GPT Training: Enabling Mixed Precision Training in JAX using
  ROCm on AMD GPUs <https://rocm.blogs.amd.com/artificial-intelligence/jax-mixed-precision/README.html>`_
  blog post provides a comprehensive guide on enhancing the training efficiency
  of GPT models by implementing mixed precision techniques in JAX, specifically
  tailored for AMD GPUs utilizing the ROCm platform.

* The `Supercharging JAX with Triton Kernels on AMD GPUs <https://rocm.blogs.amd.com/artificial-intelligence/jax-triton/README.html>`_
  blog demonstrates how to develop a custom fused dropout-activation kernel for
  matrices using Triton, integrate it with JAX, and benchmark its performance
  using ROCm.

* The `Distributed fine-tuning with JAX on AMD GPUs <https://rocm.blogs.amd.com/artificial-intelligence/distributed-sft-jax/README.html>`_
  outlines the process of fine-tuning a Bidirectional Encoder Representations
  from Transformers (BERT)-based large language model (LLM) using JAX for a text
  classification task. The blog post discusses techniques for parallelizing the
  fine-tuning across multiple AMD GPUs and assess the model's performance on a
  holdout dataset. During the fine-tuning, a BERT-base-cased transformer model
  and the General Language Understanding Evaluation (GLUE) benchmark dataset was
  used on a multi-GPU setup.

* The `MI300X workload optimization guide <https://rocm.docs.amd.com/en/latest/how-to/tuning-guides/mi300x/workload.html>`_
  provides detailed guidance on optimizing workloads for the AMD Instinct MI300X
  GPU using ROCm. The page is aimed at helping users achieve optimal
  performance for deep learning and other high-performance computing tasks on
  the MI300X GPU.

For more use cases and recommendations, see `ROCm JAX blog posts <https://rocm.blogs.amd.com/blog/tag/jax.html>`_.

.. _jax-docker-compat:

Docker image compatibility
================================================================================

AMD validates and publishes `JAX images <https://hub.docker.com/r/rocm/jax/tags>`__
with ROCm backends on Docker Hub.

For ``jax-community`` images, see `rocm/jax-community
<https://hub.docker.com/r/rocm/jax-community/tags>`__ on Docker Hub.

To find the right image tag, see the :ref:`JAX on ROCm installation
documentation <rocm-install-on-linux:jax-docker-support>` for a list of
available ``rocm/jax`` images.

.. _key_rocm_libraries:

Key ROCm libraries for JAX
================================================================================

The following ROCm libraries represent potential targets that could be utilized
by JAX on ROCm for various computational tasks. The actual libraries used will
depend on the specific implementation and operations performed.

.. list-table::
    :header-rows: 1

    * - ROCm library
      - Version
      - Purpose
    * - `hipBLAS <https://github.com/ROCm/hipBLAS>`_
      - :version-ref:`hipBLAS rocm_version`
      - Provides GPU-accelerated Basic Linear Algebra Subprograms (BLAS) for
        matrix and vector operations.
    * - `hipBLASLt <https://github.com/ROCm/hipBLASLt>`_
      - :version-ref:`hipBLASLt rocm_version`
      - hipBLASLt is an extension of hipBLAS, providing additional
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
    * - `MIOpen <https://github.com/ROCm/MIOpen>`_
      - :version-ref:`MIOpen rocm_version`
      - Optimized for deep learning primitives such as convolutions, pooling,
        normalization, and activation functions.
    * - `RCCL <https://github.com/ROCm/rccl>`_
      - :version-ref:`RCCL rocm_version`
      - Optimized for multi-GPU communication for operations like  all-reduce,
        broadcast, and scatter.
    * - `rocThrust <https://github.com/ROCm/rocThrust>`_
      - :version-ref:`rocThrust rocm_version`
      - Provides a C++ template library for parallel algorithms like sorting,
        reduction, and scanning.

.. note::

    This table shows ROCm libraries that could potentially be utilized by JAX. Not
    all libraries may be used in every configuration, and the actual library usage
    will depend on the specific operations and implementation details.

Supported data types and modules
===============================================================================

The following tables lists the supported public JAX API data types and modules.

Supported data types
--------------------------------------------------------------------------------

ROCm supports all the JAX data types of `jax.dtypes <https://docs.jax.dev/en/latest/jax.dtypes.html>`_
module, `jax.numpy.dtype <https://docs.jax.dev/en/latest/_autosummary/jax.numpy.dtype.html>`_
and `default_dtype <https://docs.jax.dev/en/latest/default_dtypes.html>`_ .
The ROCm supported data types in JAX are collected in the following table.

.. list-table::
    :header-rows: 1

    * - Data type
      - Description

    * - ``bfloat16``
      - 16-bit bfloat (brain floating point).

    * - ``bool``
      - Boolean.

    * - ``complex128``
      - 128-bit complex.

    * - ``complex64``
      - 64-bit complex.

    * - ``float16``
      - 16-bit (half precision) floating-point.

    * - ``float32``
      - 32-bit (single precision) floating-point.

    * - ``float64``
      - 64-bit (double precision) floating-point.

    * - ``half``
      - 16-bit (half precision) floating-point.

    * - ``int16``
      - Signed 16-bit integer.

    * - ``int32``
      - Signed 32-bit integer.

    * - ``int64``
      - Signed 64-bit integer.

    * - ``int8``
      - Signed 8-bit integer.

    * - ``uint16``
      - Unsigned 16-bit (word) integer.

    * - ``uint32``
      - Unsigned 32-bit (dword) integer.

    * - ``uint64``
      - Unsigned 64-bit (qword) integer.

    * - ``uint8``
      - Unsigned 8-bit (byte) integer.

.. note::

  JAX data type support is affected by the :ref:`key_rocm_libraries` and it's
  collected on :doc:`ROCm data types and precision support <rocm:reference/precision-support>`
  page.

Supported modules
--------------------------------------------------------------------------------

For a complete and up-to-date list of JAX public modules (for example, ``jax.numpy``,
``jax.scipy``, ``jax.lax``), their descriptions, and usage, please refer directly to the
`official JAX API documentation <https://jax.readthedocs.io/en/latest/jax.html>`_.

.. note::

  Since version 0.1.56, JAX has full support for ROCm, and the
  :ref:`Known issues and important notes <jax_comp_known_issues>` section
  contains details about limitations specific to the ROCm backend. The list of
  JAX API modules are maintained by the JAX project and is subject to change.
  Refer to the official Jax documentation for the most up-to-date information.

Key features and enhancements for ROCm 7.0
===============================================================================

- Upgraded XLA backend: Integrates a newer XLA version, enabling better
  optimizations, broader operator support, and potential performance gains.

- RNN support: Native RNN support (including LSTMs via ``jax.experimental.rnn``)
  now available on ROCm, aiding sequence model development.

- Comprehensive linear algebra capabilities: Offers robust ``jax.linalg``
  operations, essential for scientific and machine learning tasks.

- Expanded AMD GPU architecture support: Provides ongoing support for gfx1101
  GPUs and introduces support for gfx950 and gfx12xx GPUs.

- Mixed FP8 precision support: Enables ``lax.dot_general`` operations with mixed FP8
  types, offering pathways for memory and compute efficiency.

- Streamlined PyPi packaging: Provides reliable PyPi wheels for JAX on ROCm,
  simplifying the installation process.

- Pallas experimental kernel development: Continued Pallas framework
  enhancements for custom GPU kernels, including new intrinsics (specific
  kernel behaviors under review).

- Improved build system and CI: Enhanced ROCm build system and CI for greater
  reliability and maintainability.

- Enhanced distributed computing setup: Improved JAX setup in multi-GPU
  distributed environments.

.. _jax_comp_known_issues:

Known issues and notes for ROCm 7.0
===============================================================================

- ``nn.dot_product_attention``: Certain configurations of ``jax.nn.dot_product_attention``
  may cause segmentation faults, though the majority of use cases work correctly.

- SVD with dynamic shapes: SVD on inputs with dynamic/symbolic shapes might result in an error.
  SVD with static shapes is unaffected.

- QR decomposition with symbolic shapes: QR decomposition operations may fail when using
  symbolic/dynamic shapes in shape polymorphic contexts.

- Pallas kernels: Specific advanced Pallas kernels may exhibit variations in
  numerical output or resource usage. These are actively reviewed as part of
  Pallas's experimental development.
