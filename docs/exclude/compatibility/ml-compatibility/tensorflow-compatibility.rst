:orphan:

.. meta::
    :description: TensorFlow compatibility
    :keywords: GPU, TensorFlow, deep learning, framework compatibility

.. version-set:: rocm_version latest

*******************************************************************************
TensorFlow compatibility
*******************************************************************************

`TensorFlow <https://www.tensorflow.org/>`__ is an open-source library for
solving machine learning, deep learning, and AI problems. It can solve many
problems across different sectors and industries, but primarily focuses on
neural network training and inference. It is one of the most popular deep 
learning frameworks and is very active in open-source development.

Support overview
================================================================================

- The ROCm-supported version of TensorFlow is maintained in the official `https://github.com/ROCm/tensorflow-upstream 
  <https://github.com/ROCm/tensorflow-upstream>`__ repository, which differs from the 
  `https://github.com/tensorflow/tensorflow <https://github.com/tensorflow/tensorflow>`__ upstream repository.

- To get started and install TensorFlow on ROCm, use the prebuilt :ref:`Docker images <tensorflow-docker-compat>`, 
  which include ROCm, TensorFlow, and all required dependencies.

  - See the :doc:`ROCm TensorFlow installation guide <rocm-install-on-linux:install/3rd-party/tensorflow-install>` 
    for installation and setup instructions.

  - You can also consult the `TensorFlow API versions <https://www.tensorflow.org/versions>`__ list 
    for additional context.

Version support
--------------------------------------------------------------------------------

The `official TensorFlow repository <http://github.com/tensorflow/tensorflow>`__
includes full ROCm support. AMD maintains a TensorFlow `ROCm repository
<http://github.com/rocm/tensorflow-upstream>`__ in order to quickly add bug
fixes, updates, and support for the latest ROCm versions.

.. _tensorflow-docker-compat:

Docker image compatibility
================================================================================

AMD provides preconfigured Docker images with TensorFlow and the ROCm backend.
These images are published on `Docker Hub <https://hub.docker.com/r/rocm/tensorflow>`__ and are the
recommended way to get started with deep learning with TensorFlow on ROCm.

To find the right image tag, see the :ref:`TensorFlow on ROCm installation
documentation <rocm-install-on-linux:tensorflow-docker-support>` for a list of
available ``rocm/tensorflow`` images.


Critical ROCm libraries for TensorFlow
===============================================================================

TensorFlow depends on multiple components and the supported features of those
components can affect the TensorFlow ROCm supported feature set. The versions
in the following table refer to the first TensorFlow version where the ROCm
library was introduced as a dependency. The versions described
are available in ROCm :version:`rocm_version`.

.. list-table::
    :widths: 25, 10, 35, 30
    :header-rows: 1

    * - ROCm library
      - Version
      - Purpose
      - Used in
    * - `hipBLAS <https://github.com/ROCm/hipBLAS>`__
      - :version-ref:`hipBLAS rocm_version`
      - Provides GPU-accelerated Basic Linear Algebra Subprograms (BLAS) for
        matrix and vector operations.
      - Accelerates operations like ``tf.matmul``, ``tf.linalg.matmul``, and
        other matrix multiplications commonly used in neural network layers.
    * - `hipBLASLt <https://github.com/ROCm/hipBLASLt>`__
      - :version-ref:`hipBLASLt rocm_version`
      - Extends hipBLAS with additional optimizations like fused kernels and
        integer tensor cores.
      - Optimizes matrix multiplications and linear algebra operations used in
        layers like dense, convolutional, and RNNs in TensorFlow.
    * - `hipCUB <https://github.com/ROCm/hipCUB>`__
      - :version-ref:`hipCUB rocm_version`
      - Provides a C++ template library for parallel algorithms for reduction,
        scan, sort and select.
      - Supports operations like ``tf.reduce_sum``, ``tf.cumsum``, ``tf.sort``
        and other tensor operations in TensorFlow, especially those involving
        scanning, sorting, and filtering.
    * - `hipFFT <https://github.com/ROCm/hipFFT>`__
      - :version-ref:`hipFFT rocm_version`
      - Accelerates Fast Fourier Transforms (FFT) for signal processing tasks.
      - Used for operations like signal processing, image filtering, and
        certain types of neural networks requiring FFT-based transformations.
    * - `hipSOLVER <https://github.com/ROCm/hipSOLVER>`__
      - :version-ref:`hipSOLVER rocm_version`
      - Provides GPU-accelerated direct linear solvers for dense and sparse
        systems.
      - Optimizes linear algebra functions such as solving systems of linear
        equations, often used in optimization and training tasks.
    * - `hipSPARSE <https://github.com/ROCm/hipSPARSE>`__
      - :version-ref:`hipSPARSE rocm_version`
      - Optimizes sparse matrix operations for efficient computations on sparse
        data.
      - Accelerates sparse matrix operations in models with sparse weight
        matrices or activations, commonly used in neural networks.
    * - `MIOpen <https://github.com/ROCm/MIOpen>`__
      - :version-ref:`MIOpen rocm_version`
      - Provides optimized deep learning primitives such as convolutions,
        pooling,
        normalization, and activation functions.
      - Speeds up convolutional neural networks (CNNs) and other layers. Used
        in TensorFlow for layers like ``tf.nn.conv2d``, ``tf.nn.relu``, and
        ``tf.nn.lstm_cell``.
    * - `RCCL <https://github.com/ROCm/rccl>`__
      - :version-ref:`RCCL rocm_version`
      - Optimizes for multi-GPU communication for operations like AllReduce and
        Broadcast.
      - Distributed data parallel training (``tf.distribute.MirroredStrategy``).
        Handles communication in multi-GPU setups.
    * - `rocThrust <https://github.com/ROCm/rocThrust>`__
      - :version-ref:`rocThrust rocm_version`
      - Provides a C++ template library for parallel algorithms like sorting,
        reduction, and scanning.
      - Reduction operations like ``tf.reduce_sum``, ``tf.cumsum`` for computing
        the cumulative sum of elements along a given axis or ``tf.unique`` to
        finds unique elements in a tensor can use rocThrust.

Supported and unsupported features
===============================================================================

The following section maps supported data types and GPU-accelerated TensorFlow
features to their minimum supported ROCm and TensorFlow versions.

Data types
---------------

The data type of a tensor is specified using the ``dtype`` attribute or
argument, and TensorFlow supports a wide range of data types for different use
cases.

The basic, single data types of `tf.dtypes <https://www.tensorflow.org/api_docs/python/tf/dtypes>`__
are as follows:

.. list-table::
    :header-rows: 1

    * - Data type
      - Description
      - Since TensorFlow
      - Since ROCm
    * - ``bfloat16``
      - 16-bit bfloat (brain floating point).
      - 1.0.0
      - 1.7
    * - ``bool``
      - Boolean.
      - 1.0.0
      - 1.7
    * - ``complex128``
      - 128-bit complex.
      - 1.0.0
      - 1.7
    * - ``complex64``
      - 64-bit complex.
      - 1.0.0
      - 1.7
    * - ``double``
      - 64-bit (double precision) floating-point.
      - 1.0.0
      - 1.7
    * - ``float16``
      - 16-bit (half precision) floating-point.
      - 1.0.0
      - 1.7
    * - ``float32``
      - 32-bit (single precision) floating-point.
      - 1.0.0
      - 1.7
    * - ``float64``
      - 64-bit (double precision) floating-point.
      - 1.0.0
      - 1.7
    * - ``half``
      - 16-bit (half precision) floating-point.
      - 2.0.0
      - 2.0
    * - ``int16``
      - Signed 16-bit integer.
      - 1.0.0
      - 1.7
    * - ``int32``
      - Signed 32-bit integer.
      - 1.0.0
      - 1.7
    * - ``int64``
      - Signed 64-bit integer.
      - 1.0.0
      - 1.7
    * - ``int8``
      - Signed 8-bit integer.
      - 1.0.0
      - 1.7
    * - ``qint16``
      - Signed quantized 16-bit integer.
      - 1.0.0
      - 1.7
    * - ``qint32``
      - Signed quantized 32-bit integer.
      - 1.0.0
      - 1.7
    * - ``qint8``
      - Signed quantized 8-bit integer.
      - 1.0.0
      - 1.7
    * - ``quint16``
      - Unsigned quantized 16-bit integer.
      - 1.0.0
      - 1.7
    * - ``quint8``
      - Unsigned quantized 8-bit integer.
      - 1.0.0
      - 1.7
    * - ``resource``
      - Handle to a mutable, dynamically allocated resource.
      - 1.0.0
      - 1.7
    * - ``string``
      - Variable-length string, represented as byte array.
      - 1.0.0
      - 1.7
    * - ``uint16``
      - Unsigned 16-bit (word) integer.
      - 1.0.0
      - 1.7
    * - ``uint32``
      - Unsigned 32-bit (dword) integer.
      - 1.5.0
      - 1.7
    * - ``uint64``
      - Unsigned 64-bit (qword) integer.
      - 1.5.0
      - 1.7
    * - ``uint8``
      - Unsigned 8-bit (byte) integer.
      - 1.0.0
      - 1.7
    * - ``variant``
      - Data of arbitrary type (known at runtime).
      - 1.4.0
      - 1.7

Features
---------------

This table provides an overview of key features in TensorFlow and their
availability in ROCm.

.. list-table::
    :header-rows: 1

    * - Module
      - Description
      - Since TensorFlow
      - Since ROCm
    * - ``tf.linalg`` (Linear Algebra)
      - Operations for matrix and tensor computations, such as
        ``tf.linalg.matmul`` (matrix multiplication), ``tf.linalg.inv``
        (matrix inversion) and ``tf.linalg.cholesky`` (Cholesky decomposition).
        These leverage GPUs for high-performance linear algebra operations.
      - 1.4
      - 1.8.2
    * - ``tf.nn`` (Neural Network Operations)
      - GPU-accelerated building blocks for deep learning models, such as 2D
        convolutions with ``tf.nn.conv2d``, max pooling operations with
        ``tf.nn.max_pool``, activation functions like ``tf.nn.relu`` or softmax
        for output layers with ``tf.nn.softmax``.
      - 1.0
      - 1.8.2
    * - ``tf.image`` (Image Processing)
      - GPU-accelerated functions for image preprocessing and augmentations,
        such as resize images with ``tf.image.resize``, flip images horizontally
        with ``tf.image.flip_left_right`` and adjust image brightness randomly
        with ``tf.image.random_brightness``.
      - 1.1
      - 1.8.2
    * - ``tf.keras`` (High-Level API)
      - GPU acceleration for Keras layers and models, including dense layers
        (``tf.keras.layers.Dense``), convolutional layers
        (``tf.keras.layers.Conv2D``) and recurrent layers
        (``tf.keras.layers.LSTM``).
      - 1.4
      - 1.8.2
    * - ``tf.math`` (Mathematical Operations)
      - GPU-accelerated mathematical operations, such as sum across dimensions
        with ``tf.math.reduce_sum``, elementwise exponentiation with
        ``tf.math.exp`` and sigmoid activation (``tf.math.sigmoid``).
      - 1.5
      - 1.8.2
    * - ``tf.signal`` (Signal Processing)
      - Functions for spectral analysis and signal transformations.
      - 1.13
      - 2.1
    * - ``tf.data`` (Data Input Pipeline)
      - GPU-accelerated data preprocessing for efficient input pipelines,
        Prefetching with ``tf.data.experimental.AUTOTUNE``. GPU-enabled
        transformations like map and batch.
      - 1.4
      - 1.8.2
    * - ``tf.distribute`` (Distributed Training)
      - Enabling to scale computations across multiple devices on a single
        machine or across multiple machines.
      - 1.13
      - 2.1
    * - ``tf.random`` (Random Number Generation)
      - GPU-accelerated random number generation
      - 1.12
      - 1.9.2
    * - ``tf.TensorArray`` (Dynamic Array Operations)
      - Enables dynamic tensor manipulation on GPUs.
      - 1.0
      - 1.8.2
    * - ``tf.sparse`` (Sparse Tensor Operations)
      - GPU-accelerated sparse matrix manipulations.
      - 1.9
      - 1.9.0
    * - ``tf.experimental.numpy``
      - GPU-accelerated NumPy-like API for numerical computations.
      - 2.4
      - 4.1.1
    * - ``tf.RaggedTensor``
      - Handling of variable-length sequences and ragged tensors with GPU
        support.
      - 1.13
      - 2.1
    * - ``tf.function`` with XLA (Accelerated Linear Algebra)
      - Enable GPU-accelerated functions in optimization.
      - 1.14
      - 2.4
    * - ``tf.quantization``
      - Quantized operations for inference, accelerated on GPUs.
      - 1.12
      - 1.9.2

Distributed library features
-----------------------------------

Enables developers to scale computations across multiple devices on a single machine or
across multiple machines.

.. list-table::
   :header-rows: 1

   * - Feature
     - Description
     - Since TensorFlow
     - Since ROCm
   * - ``MultiWorkerMirroredStrategy``
     - Synchronous training across multiple workers using mirrored variables.
     - 2.0
     - 3.0
   * - ``MirroredStrategy``
     - Synchronous training across multiple GPUs on one machine.
     - 1.5
     - 2.5
   * - ``TPUStrategy``
     - Efficiently trains models on Google TPUs.
     - 1.9
     - ❌
   * - ``ParameterServerStrategy``
     - Asynchronous training using parameter servers for variable management.
     - 2.1
     - 4.0
   * - ``CentralStorageStrategy``
     - Keeps variables on a single device and performs computation on multiple
       devices.
     - 2.3
     - 4.1
   * - ``CollectiveAllReduceStrategy``
     - Synchronous training across multiple devices and hosts.
     - 1.14
     - 3.5
   * - Distribution Strategies API
     - High-level API to simplify distributed training configuration and
       execution.
     - 1.10
     - 3.0

Unsupported TensorFlow features
===============================================================================

The following are GPU-accelerated TensorFlow features not currently supported by
ROCm.

.. list-table::
    :header-rows: 1

    * - Feature
      - Description
      - Since TensorFlow
    * - Mixed Precision with TF32
      - Mixed precision with TF32 is used for matrix multiplications,
        convolutions, and other linear algebra operations, particularly in
        deep learning workloads like CNNs and transformers.
      - 2.4
    * - ``tf.distribute.TPUStrategy``
      - Efficiently trains models on Google TPUs.
      - 1.9

Use cases and recommendations
===============================================================================

* The `Training a Neural Collaborative Filtering (NCF) Recommender on an AMD
  GPU <https://rocm.blogs.amd.com/artificial-intelligence/ncf/README.html>`__
  blog post discusses training an NCF recommender system using TensorFlow. It
  explains how NCF improves traditional collaborative filtering methods by
  leveraging neural networks to model non-linear user-item interactions. The
  post outlines the implementation using the recommenders library, focusing on
  the use of implicit data (for example, user interactions like viewing or
  purchasing) and how it addresses challenges like the lack of negative values.

* The `Creating a PyTorch/TensorFlow code environment on AMD GPUs
  <https://rocm.blogs.amd.com/software-tools-optimization/pytorch-tensorflow-env/README.html>`__
  blog post provides instructions for creating a machine learning environment
  for PyTorch and TensorFlow on AMD GPUs using ROCm. It covers steps like
  installing the libraries, cloning code repositories, installing dependencies,
  and troubleshooting potential issues with CUDA-based code. Additionally, it
  explains how to HIPify code (port CUDA code to HIP) and manage Docker images
  for a better experience on AMD GPUs. This guide aims to help data scientists
  and ML practitioners adapt their code for AMD GPUs.

For more use cases and recommendations, see the `ROCm Tensorflow blog posts <https://rocm.blogs.amd.com/blog/tag/tensorflow.html>`__.
