.. meta::
  :description: Host software glossary for AMD GPUs
  :keywords: AMD, ROCm, GPU, host software, HIP, compiler, runtime, libraries,
    profiler, amd-smi

.. _glossary-host-software:

**********************
Host software glossary
**********************

This section provides brief definitions of development tools, compilers,
libraries, and runtime environments for programming AMD GPUs.

.. glossary::
    :sorted:

    ROCm software platform
        ROCm is AMD's GPU software stack, providing compiler
        toolchains, runtime environments, and performance libraries for HPC and
        AI applications. See :doc:`../../what-is-rocm` for a complete component
        overview.

    HIP C++ language extension
        HIP extends the C++ language with additional features designed for
        programming heterogeneous applications. These extensions mostly relate
        to the kernel language, but some can also be applied to host
        functionality. See :doc:`hip:how-to/hip_cpp_language_extensions` for
        language fundamentals.

    AMD SMI
        The ``amd-smi`` command-line utility queries, monitors, and manages
        AMD GPU state, providing hardware information and performance metrics.
        See :doc:`amdsmi:index` for detailed usage.

    HIP runtime API
        The HIP runtime API provides an interface for GPU programming, offering
        functions for memory management, kernel launches, and synchronization. See
        :ref:`hip:hip_runtime_api_how-to` for API overview.

    HIP compiler
        The HIP compiler ``amdclang++`` compiles HIP C++ programs into binaries
        that contain both host CPU and device GPU code. See
        :doc:`llvm-project:reference/rocmcc` for compiler flags and options.

    HIP runtime compiler
        The HIP Runtime Compiler (HIPRTC) compiles HIP source code at runtime
        into :term:`AMDGPU <AMDGPU assembly>` binary code objects, enabling
        just-in-time kernel generation, device-specific optimization, and
        dynamic code creation for different GPUs. See
        :ref:`hip:hip_runtime_compiler_how-to` for API details.

    ROCgdb
        ROCgdb is AMD's source-level debugger for HIP and ROCm applications,
        enabling debugging of both host CPU and GPU device code, including
        kernel breakpoints, stepping, and variable inspection. See
        :doc:`rocgdb:index` for usage and command reference.

    rocprofv3
        ``rocprofv3`` is AMD's primary performance analysis tool, providing
        profiling, tracing, and performance counter collection.
        See :ref:`rocprofiler-sdk:using-rocprofv3` for profiling workflows.

    ROCm and LLVM binary utilities
        ROCm and LLVM binary utilities are command-line tools for examining and
        manipulating GPU binaries and code objects. See
        :ref:`hip:binary_utilities` for utility details.
