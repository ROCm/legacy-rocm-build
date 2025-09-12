:orphan:

.. meta::
    :description: llama.cpp deep learning framework compatibility
    :keywords: GPU, GGML, llama.cpp compatibility

.. version-set:: rocm_version latest

********************************************************************************
llama.cpp compatibility
********************************************************************************

`llama.cpp <https://github.com/ggml-org/llama.cpp>`__ is an open-source framework 
for Large Language Model (LLM) inference that runs on both central processing units 
(CPUs) and graphics processing units (GPUs). It is written in plain C/C++, providing 
a simple, dependency-free setup. 

The framework supports multiple quantization options, from 1.5-bit to 8-bit integers, 
to speed up inference and reduce memory usage. Originally built as a CPU-first library, 
llama.cpp is easy to integrate with other programming environments and is widely 
adopted across diverse platforms, including consumer devices. 

ROCm support for llama.cpp is upstreamed, and you can build the official source code
with ROCm support:

- ROCm support for llama.cpp is hosted in the official `https://github.com/ROCm/llama.cpp 
  <https://github.com/ROCm/llama.cpp>`_ repository.

- Due to independent compatibility considerations, this location differs from the 
  `https://github.com/ggml-org/llama.cpp <https://github.com/ggml-org/llama.cpp>`_ upstream repository.

- To install llama.cpp, use the prebuilt :ref:`Docker image <llama-cpp-docker-compat>`, 
  which includes ROCm, llama.cpp, and all required dependencies.

  - See the :doc:`ROCm llama.cpp installation guide <rocm-install-on-linux:install/3rd-party/llama-cpp-install>` 
    to install and get started.

  - See the `Installation guide <https://github.com/ggml-org/llama.cpp/blob/master/docs/build.md#hip>`__ 
    in the upstream llama.cpp documentation.

.. note::

  llama.cpp is supported on ROCm 6.4.0.

Supported devices
================================================================================

**Officially Supported**: AMD Instinct™ MI300X, MI210


Use cases and recommendations
================================================================================

llama.cpp can be applied in a variety of scenarios, particularly when you need to meet one or more of the following requirements:

- Plain C/C++ implementation with no external dependencies
- Support for 1.5-bit, 2-bit, 3-bit, 4-bit, 5-bit, 6-bit, and 8-bit integer quantization for faster inference and reduced memory usage
- Custom HIP (Heterogeneous-compute Interface for Portability) kernels for running large language models (LLMs) on AMD GPUs (graphics processing units)
- CPU (central processing unit) + GPU (graphics processing unit) hybrid inference for partially accelerating models larger than the total available VRAM (video random-access memory)

llama.cpp is also used in a range of real-world applications, including:

- Games such as `Lucy's Labyrinth <https://github.com/MorganRO8/Lucys_Labyrinth>`__:
  A simple maze game where AI-controlled agents attempt to trick the player.
- Tools such as `Styled Lines <https://marketplace.unity.com/packages/tools/ai-ml-integration/style-text-webgl-ios-stand-alone-llm-llama-cpp-wrapper-292902>`__:
  A proprietary, asynchronous inference wrapper for Unity3D game development, including pre-built mobile and web platform wrappers and a model example.
- Various other AI applications use llama.cpp as their inference engine;  
  for a detailed list, see the `user interfaces (UIs) section <https://github.com/ggml-org/llama.cpp?tab=readme-ov-file#description>`__.

For more use cases and recommendations, refer to the `AMD ROCm blog <https://rocm.blogs.amd.com/>`__, 
where you can search for llama.cpp examples and best practices to optimize your workloads on AMD GPUs.

- The `Llama.cpp Meets Instinct: A New Era of Open-Source AI Acceleration <https://rocm.blogs.amd.com/ecosystems-and-partners/llama-cpp/README.html>`__, 
  blog post outlines how the open-source llama.cpp framework enables efficient LLM inference—including interactive inference with ``llama-cli``, 
  server deployment with ``llama-server``, GGUF model preparation and quantization, performance benchmarking, and optimizations tailored for 
  AMD Instinct GPUs within the ROCm ecosystem. 

.. _llama-cpp-docker-compat:

Docker image compatibility
================================================================================

.. |docker-icon| raw:: html

   <i class="fab fa-docker"></i>

AMD validates and publishes `ROCm llama.cpp Docker images <https://hub.docker.com/r/rocm/llama.cpp>`__
with ROCm backends on Docker Hub. The following Docker image tags and associated
inventories were tested on `ROCm 6.4.0 <https://repo.radeon.com/rocm/apt/6.4/>`__.
Click |docker-icon| to view the image on Docker Hub.

.. important::

   Tag endings of ``_full``, ``_server``, and ``_light`` serve different purposes for entrypoints as follows:

   - Full: This image includes both the main executable file and the tools to convert ``LLaMA`` models into ``ggml`` and convert into 4-bit quantization.
   - Server: This image only includes the server executable file.
   - Light: This image only includes the main executable file.

.. list-table::
    :header-rows: 1
    :class: docker-image-compatibility

    * - Full Docker
      - Server Docker
      - Light Docker
      - llama.cpp
      - Ubuntu

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b5997_rocm6.4.0_ubuntu24.04_full/images/sha256-f78f6c81ab2f8e957469415fe2370a1334fe969c381d1fe46050c85effaee9d5"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b5997_rocm6.4.0_ubuntu24.04_server/images/sha256-275ad9e18f292c26a00a2de840c37917e98737a88a3520bdc35fd3fc5c9a6a9b"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b5997_rocm6.4.0_ubuntu24.04_light/images/sha256-cc324e6faeedf0e400011f07b49d2dc41a16bae257b2b7befa0f4e2e97231320"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - `b5997 <https://github.com/ROCm/llama.cpp/tree/release/b5997>`__
      - 24.04

Key ROCm libraries for llama.cpp
================================================================================

llama.cpp functionality on ROCm is determined by its underlying library
dependencies. These ROCm components affect the capabilities, performance, and
feature set available to developers.

.. list-table::
    :header-rows: 1

    * - ROCm library
      - Version
      - Purpose
      - Usage
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
      - By setting the flag ``ROCBLAS_USE_HIPBLASLT``, you can dispatch hipblasLt
        kernels where possible.
    * - `rocWMMA <https://github.com/ROCm/rocWMMA>`__
      - :version-ref:`rocWMMA rocm_version`
      - Accelerates warp-level matrix-multiply and matrix-accumulate to speed up matrix
        multiplication (GEMM) and accumulation operations with mixed precision
        support.
      - Can be used to enhance the flash attention performance on AMD compute, by enabling
        the flag during compile time.