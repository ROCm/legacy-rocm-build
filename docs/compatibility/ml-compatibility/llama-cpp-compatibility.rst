:orphan:

.. meta::
    :description: llama.cpp compatibility
    :keywords: GPU, GGML, llama.cpp, deep learning, framework compatibility

.. version-set:: rocm_version latest

********************************************************************************
llama.cpp compatibility
********************************************************************************

`llama.cpp <https://github.com/ggml-org/llama.cpp>`__ is an open-source framework 
for Large Language Model (LLM) inference that runs on both central processing units 
(CPUs) and graphics processing units (GPUs). It is written in plain C/C++, providing 
a simple, dependency-free setup. 

The framework supports multiple quantization options, from 1.5-bit to 8-bit integers, 
to accelerate inference and reduce memory usage. Originally built as a CPU-first library, 
llama.cpp is easy to integrate with other programming environments and is widely 
adopted across diverse platforms, including consumer devices. 

Support overview
================================================================================

- The ROCm-supported version of llama.cpp is maintained in the official `https://github.com/ROCm/llama.cpp 
  <https://github.com/ROCm/llama.cpp>`__ repository, which differs from the 
  `https://github.com/ggml-org/llama.cpp <https://github.com/ggml-org/llama.cpp>`__ upstream repository.

- To get started and install llama.cpp on ROCm, use the prebuilt :ref:`Docker images <llama-cpp-docker-compat>`, 
  which include ROCm, llama.cpp, and all required dependencies.

  - See the :doc:`ROCm llama.cpp installation guide <rocm-install-on-linux:install/3rd-party/llama-cpp-install>` 
    for installation and setup instructions.

  - You can also consult the upstream `Installation guide <https://github.com/ggml-org/llama.cpp/blob/master/docs/build.md>`__ 
    for additional context.

.. _llama-cpp-docker-compat:

Compatibility matrix
================================================================================

.. |docker-icon| raw:: html

   <i class="fab fa-docker"></i>

AMD validates and publishes `llama.cpp images <https://hub.docker.com/r/rocm/llama.cpp/tags>`__
with ROCm backends on Docker Hub. The following Docker image tags and associated
inventories represent the latest available llama.cpp versions from the official Docker Hub.
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
      - ROCm
      - Ubuntu
      - GPU

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6652.amd0_rocm7.0.0_ubuntu24.04_full/images/sha256-a94f0c7a598cc6504ff9e8371c016d7a2f93e69bf54a36c870f9522567201f10g"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6652.amd0_rocm7.0.0_ubuntu24.04_server/images/sha256-be175932c3c96e882dfbc7e20e0e834f58c89c2925f48b222837ee929dfc47ee"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6652.amd0_rocm7.0.0_ubuntu24.04_light/images/sha256-d8ba0c70603da502c879b1f8010b439c8e7fa9f6cbdac8bbbbbba97cb41ebc9e"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - `b6652 <https://github.com/ROCm/llama.cpp/tree/release/b6652>`__
      - `7.0.0 <https://repo.radeon.com/rocm/apt/7.0/>`__
      - 24.04
      - MI325X, MI300X, MI210

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6652.amd0_rocm7.0.0_ubuntu22.04_full/images/sha256-37582168984f25dce636cc7288298e06d94472ea35f65346b3541e6422b678ee"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6652.amd0_rocm7.0.0_ubuntu22.04_server/images/sha256-7e70578e6c3530c6591cc2c26da24a9ee68a20d318e12241de93c83224f83720"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6652.amd0_rocm7.0.0_ubuntu22.04_light/images/sha256-9a5231acf88b4a229677bc2c636ea3fe78a7a80f558bd80910b919855de93ad5"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - `b6652 <https://github.com/ROCm/llama.cpp/tree/release/b6652>`__
      - `7.0.0 <https://repo.radeon.com/rocm/apt/7.0/>`__
      - 22.04
      - MI325X, MI300X, MI210

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6356_rocm6.4.3_ubuntu24.04_full/images/sha256-5960fc850024a8a76451f9eaadd89b7e59981ae9f393b407310c1ddf18892577"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6356_rocm6.4.3_ubuntu24.04_server/images/sha256-1b79775d9f546065a6aaf9ca426e1dd4ed4de0b8f6ee83687758cc05af6538e6"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6356_rocm6.4.3_ubuntu24.04_light/images/sha256-8f863c4c2857ae42bebd64e4f1a0a1e7cc3ec4503f243e32b4a4dcad070ec361"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - `b6356 <https://github.com/ROCm/llama.cpp/tree/release/b6356>`__
      - `6.4.3 <https://repo.radeon.com/rocm/apt/6.4.3/>`__
      - 24.04
      - MI325X, MI300X, MI210

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6356_rocm6.4.3_ubuntu22.04_full/images/sha256-888879b3ee208f9247076d7984524b8d1701ac72611689e89854a1588bec9867"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6356_rocm6.4.3_ubuntu22.04_server/images/sha256-90e4ff99a66743e33fd00728cd71a768588e5f5ef355aaa196669fe65ac70672"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6356_rocm6.4.3_ubuntu22.04_light/images/sha256-bd447a049939cb99054f8fbf3f2352870fe906a75e2dc3339c845c08b9c53f9b"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - `b6356 <https://github.com/ROCm/llama.cpp/tree/release/b6356>`__
      - `6.4.3 <https://repo.radeon.com/rocm/apt/6.4.3/>`__
      - 22.04
      - MI325X, MI300X, MI210

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6356_rocm6.4.2_ubuntu24.04_full/images/sha256-5b3a1bc4889c1fcade434b937fbf9cc1c22ff7dc0317c130339b0c9238bc88c4"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6356_rocm6.4.2_ubuntu24.04_server/images/sha256-5228ff99d0f627a9032d668f4381b2e80dc1e301adc3e0821f26d8354b175271"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6356_rocm6.4.2_ubuntu24.04_light/images/sha256-b12723b332a826a89b7252dddf868cbe4d1a869562fc4aa4032f59e1a683b968"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - `b6356 <https://github.com/ROCm/llama.cpp/tree/release/b6356>`__
      - `6.4.2 <https://repo.radeon.com/rocm/apt/6.4.2/>`__
      - 24.04
      - MI325X, MI300X, MI210

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6356_rocm6.4.2_ubuntu22.04_full/images/sha256-cd6e21a6a73f59b35dd5309b09dd77654a94d783bf13a55c14eb8dbf8e9c2615"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6356_rocm6.4.2_ubuntu22.04_server/images/sha256-c2b4689ab2c47e6626e8fea22d7a63eb03d47c0fde9f5ef8c9f158d15c423e58"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6356_rocm6.4.2_ubuntu22.04_light/images/sha256-1acc28f29ed87db9cbda629cb29e1989b8219884afe05f9105522be929e94da4"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - `b6356 <https://github.com/ROCm/llama.cpp/tree/release/b6356>`__
      - `6.4.2 <https://repo.radeon.com/rocm/apt/6.4.2/>`__
      - 22.04
      - MI325X, MI300X, MI210

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6356_rocm6.4.1_ubuntu24.04_full/images/sha256-2f8ae8a44510d96d52dea6cb398b224f7edeb7802df7ec488c6f63d206b3cdc9"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6356_rocm6.4.1_ubuntu24.04_server/images/sha256-fece497ff9f4a28b12f645de52766941da8ead8471aa1ea84b61d4b4568e51f2"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6356_rocm6.4.1_ubuntu24.04_light/images/sha256-3e14352fa6f8c6128b23cf9342531c20dbfb522550b626e09d83b260a1947022"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - `b6356 <https://github.com/ROCm/llama.cpp/tree/release/b6356>`__
      - `6.4.1 <https://repo.radeon.com/rocm/apt/6.4.1/>`__
      - 24.04
      - MI325X, MI300X, MI210

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6356_rocm6.4.1_ubuntu22.04_full/images/sha256-80763062ef0bec15038c35fd01267f1fc99a5dd171d4b48583cc668b15efad69"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6356_rocm6.4.1_ubuntu22.04_server/images/sha256-db2a6c957555ed83b819bbc54aea884a93192da0fb512dae63d32e0dc4e8ab8f"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b6356_rocm6.4.1_ubuntu22.04_light/images/sha256-c6dbb07cc655fb079d5216e4b77451cb64a9daa0585d23b6fb8b32cb22021197"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - `b6356 <https://github.com/ROCm/llama.cpp/tree/release/b6356>`__
      - `6.4.1 <https://repo.radeon.com/rocm/apt/6.4.1/>`__
      - 22.04
      - MI325X, MI300X, MI210

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b5997_rocm6.4.0_ubuntu24.04_full/images/sha256-f78f6c81ab2f8e957469415fe2370a1334fe969c381d1fe46050c85effaee9d5"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b5997_rocm6.4.0_ubuntu24.04_server/images/sha256-275ad9e18f292c26a00a2de840c37917e98737a88a3520bdc35fd3fc5c9a6a9b"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/llama.cpp/llama.cpp-b5997_rocm6.4.0_ubuntu24.04_light/images/sha256-cc324e6faeedf0e400011f07b49d2dc41a16bae257b2b7befa0f4e2e97231320"><i class="fab fa-docker fa-lg"></i> rocm/llama.cpp</a>
      - `b5997 <https://github.com/ROCm/llama.cpp/tree/release/b5997>`__
      - `6.4.0 <https://repo.radeon.com/rocm/apt/6.4/>`__
      - 24.04
      - MI300X, MI210

.. _llama-cpp-key-rocm-libraries:

Key ROCm libraries for llama.cpp
================================================================================

llama.cpp functionality on ROCm is determined by its underlying library
dependencies. These ROCm components affect the capabilities, performance, and
feature set available to developers. Ensure you have the required libraries for 
your corresponding ROCm version.

.. list-table::
    :header-rows: 1

    * - ROCm library
      - ROCm 7.0.0 version
      - ROCm 6.4.x version
      - Purpose
      - Usage
    * - `hipBLAS <https://github.com/ROCm/hipBLAS>`__
      - 3.0.0
      - 2.4.0
      - Provides GPU-accelerated Basic Linear Algebra Subprograms (BLAS) for
        matrix and vector operations.
      - Supports operations such as matrix multiplication, matrix-vector
        products, and tensor contractions. Utilized in both dense and batched
        linear algebra operations.
    * - `hipBLASLt <https://github.com/ROCm/hipBLASLt>`__
      - 1.0.0
      - 0.12.0
      - hipBLASLt is an extension of the hipBLAS library, providing additional
        features like epilogues fused into the matrix multiplication kernel or
        use of integer tensor cores.
      - By setting the flag ``ROCBLAS_USE_HIPBLASLT``, you can dispatch hipblasLt
        kernels where possible.
    * - `rocWMMA <https://github.com/ROCm/rocWMMA>`__
      - 2.0.0
      - 1.7.0
      - Accelerates warp-level matrix-multiply and matrix-accumulate to speed up matrix
        multiplication (GEMM) and accumulation operations with mixed precision
        support.
      - Can be used to enhance the flash attention performance on AMD compute, by enabling
        the flag during compile time.

.. _llama-cpp-uses-recommendations:

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

- The `Llama.cpp Meets Instinct: A New Era of Open-Source AI Acceleration <https://rocm.blogs.amd.com/ecosystems-and-partners/llama-cpp/README.html>`__ 
  blog post outlines how the open-source llama.cpp framework enables efficient LLM inference—including interactive inference with ``llama-cli``, 
  server deployment with ``llama-server``, GGUF model preparation and quantization, performance benchmarking, and optimizations tailored for 
  AMD Instinct GPUs within the ROCm ecosystem. 


Previous versions
===============================================================================
See :doc:`rocm-install-on-linux:install/3rd-party/previous-versions/llama-cpp-history` to find documentation for previous releases
of the ``ROCm/llama.cpp`` Docker image.