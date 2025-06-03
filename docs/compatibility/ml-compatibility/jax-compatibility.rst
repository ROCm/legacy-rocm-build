:orphan:

.. meta::
   :description: JAX compatibility
   :keywords: GPU, JAX compatibility

.. version-set:: rocm_version latest

*******************************************************************************
JAX compatibility
*******************************************************************************

JAX provides a NumPy-like API, which combines automatic differentiation and the
Accelerated Linear Algebra (XLA) compiler to achieve high-performance machine
learning at scale.

JAX uses composable transformations of Python and NumPy through just-in-time
(JIT) compilation, automatic vectorization, and parallelization. To learn about
JAX, including profiling and optimizations, see the official `JAX documentation
<https://jax.readthedocs.io/en/latest/notebooks/quickstart.html>`_.

ROCm support for JAX is upstreamed, and users can build the official source code
with ROCm support:

- ROCm JAX release:

  - Offers AMD-validated and community :ref:`Docker images <jax-docker-compat>`
    with ROCm and JAX preinstalled.

  - ROCm JAX repository: `ROCm/jax <https://github.com/ROCm/jax>`_

  - See the :doc:`ROCm JAX installation guide <rocm-install-on-linux:install/3rd-party/jax-install>`
    to get started.

- Official JAX release:

  - Official JAX repository: `jax-ml/jax <https://github.com/jax-ml/jax>`_

  - See the `AMD GPU (Linux) installation section
    <https://jax.readthedocs.io/en/latest/installation.html#amd-gpu-linux>`_ in
    the JAX documentation.

.. note::

   AMD releases official `ROCm JAX Docker images <https://hub.docker.com/r/rocm/jax>`_
   quarterly alongside new ROCm releases. These images undergo full AMD testing.
   `Community ROCm JAX Docker images <https://hub.docker.com/r/rocm/jax-community>`_
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
  classification task. The blog post discuss techniques for parallelizing the
  fine-tuning across multiple AMD GPUs and assess the model's performance on a
  holdout dataset. During the fine-tuning, a BERT-base-cased transformer model
  and the General Language Understanding Evaluation (GLUE) benchmark dataset was
  used on a multi-GPU setup.

* The `MI300X workload optimization guide <https://rocm.docs.amd.com/en/latest/how-to/tuning-guides/mi300x/workload.html>`_
  provides detailed guidance on optimizing workloads for the AMD Instinct MI300X
  accelerator using ROCm. The page is aimed at helping users achieve optimal
  performance for deep learning and other high-performance computing tasks on
  the MI300X GPU.

For more use cases and recommendations, see `ROCm JAX blog posts <https://rocm.blogs.amd.com/blog/tag/jax.html>`_.

.. _jax-docker-compat:

Docker image compatibility
================================================================================

.. |docker-icon| raw:: html

   <i class="fab fa-docker"></i>

AMD validates and publishes ready-made `ROCm JAX Docker images <https://hub.docker.com/r/rocm/jax>`_
with ROCm backends on Docker Hub. The following Docker image tags and
associated inventories represent the latest JAX version from the official Docker Hub and are validated for
`ROCm 6.4.1 <https://repo.radeon.com/rocm/apt/6.4.1/>`_. Click the |docker-icon|
icon to view the image on Docker Hub.

.. list-table:: JAX Docker image components
    :header-rows: 1

    * - Docker image
      - JAX
      - Linux
      - Python

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/jax/rocm6.4.1-jax0.4.35-py3.12/images/sha256-7a0745a2a2758bdf86397750bac00e9086cbf67d170cfdbb08af73f7c7d18a6a"><i class="fab fa-docker fa-lg"></i> rocm/jax</a>

      - `0.4.35 <https://github.com/ROCm/jax/releases/tag/rocm-jax-v0.4.35>`_
      - Ubuntu 24.04
      - `3.12.10 <https://www.python.org/downloads/release/python-31210/>`_

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/jax/rocm6.4.1-jax0.4.35-py3.10/images/sha256-5f9e8d6e6e69fdc9a1a3f2ba3b1234c3f46c53b7468538c07fd18b00899da54f"><i class="fab fa-docker fa-lg"></i> rocm/jax</a>

      - `0.4.35 <https://github.com/ROCm/jax/releases/tag/rocm-jax-v0.4.35>`_
      - Ubuntu 22.04
      - `3.10.17 <https://www.python.org/downloads/release/python-31017/>`_

AMD publishes `Community ROCm JAX Docker images <https://hub.docker.com/r/rocm/jax-community>`_
with ROCm backends on Docker Hub. The following Docker image tags and
associated inventories are tested for `ROCm 6.3.2 <https://repo.radeon.com/rocm/apt/6.3.2/>`_.

.. list-table:: JAX community Docker image components
    :header-rows: 1

    * - Docker image
      - JAX
      - Linux
      - Python

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/jax-community/rocm6.3.2-jax0.5.0-py3.12.8/images/sha256-25dfaa0183e274bd0a3554a309af3249c6f16a1793226cb5373f418e39d3146a"><i class="fab fa-docker fa-lg"></i> rocm/jax-community</a>

      - `0.5.0 <https://github.com/ROCm/jax/releases/tag/rocm-jax-v0.5.0>`_
      - Ubuntu 22.04
      - `3.12.8 <https://www.python.org/downloads/release/python-3128/>`_

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/jax-community/rocm6.3.2-jax0.5.0-py3.11.11/images/sha256-ff9baeca9067d13e6c279c911e5a9e5beed0817d24fafd424367cc3d5bd381d7"><i class="fab fa-docker fa-lg"></i> rocm/jax-community</a>

      - `0.5.0 <https://github.com/ROCm/jax/releases/tag/rocm-jax-v0.5.0>`_
      - Ubuntu 22.04
      - `3.11.11 <https://www.python.org/downloads/release/python-31111/>`_

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/jax-community/rocm6.3.2-jax0.5.0-py3.10.16/images/sha256-8bab484be1713655f74da51a191ed824bb9d03db1104fd63530a1ac3c37cf7b1"><i class="fab fa-docker fa-lg"></i> rocm/jax-community</a>

      - `0.5.0 <https://github.com/ROCm/jax/releases/tag/rocm-jax-v0.5.0>`_
      - Ubuntu 22.04
      - `3.10.16 <https://www.python.org/downloads/release/python-31016/>`_

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

  JAX data type support is effected by the :ref:`key_rocm_libraries` and it's
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
  JAX API modules is maintained by the JAX project and is subject to change. 
  Refer to the official Jax documentation for the most up-to-date information.
