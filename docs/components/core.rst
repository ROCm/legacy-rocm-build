.. meta::
   :description: AMD ROCm Core SDK - list of libraries and tools
   :keywords: component, tool, lib, library, dnn, algorithm, cli, end, machine, learning, optimization, optimize, primitive, api, binding, wrapper

************************
ROCm Core SDK components
************************

The ROCm Core SDK is the foundation of the ROCm software stack. It provides the
libraries, runtimes, compilers, and tools needed to develop and run GPU-accelerated
applications on AMD hardware.

Math and compute libraries
==========================

A comprehensive set of GPU-accelerated math libraries covering dense and sparse
linear algebra, FFTs, random number generation, and more.

* Libraries prefixed with ``roc*`` libraries are native, high-performance
  implementations written in HIP specifically for AMD GPUs.

* Libraries prefixed with ``hip*`` are portable wrappers that implement
  NVIDIA CUDA-equivalent APIs, allowing CUDA applications to be ported to AMD GPUs
  with minimal code changes.

Libraries include:

* :doc:`Composable Kernel <composable_kernel:index>`

* :doc:`hipBLAS <hipblas:index>` and :doc:`rocBLAS <rocblas:index>`

* :doc:`hipBLASLt <hipblaslt:index>`

* :doc:`hipCUB <hipcub:index>`

* :doc:`hipFFT <hipfft:index>` and :doc:`rocFFT <rocfft:index>`

* :doc:`hipRAND <hiprand:index>` and :doc:`rocRAND <rocrand:index>`

* :doc:`hipSOLVER <hipsolver:index>` and :doc:`rocSOLVER <rocsolver:index>`

* :doc:`hipSPARSE <hipsparse:index>` and :doc:`rocSPARSE <rocsparse:index>`

* :doc:`hipSPARSELt <hipsparselt:index>`

* :doc:`MIOpen <miopen:index>`

* :doc:`rocPRIM <rocprim:index>`

* :doc:`rocThrust <rocthrust:index>`

* :doc:`rocWMMA <rocwmma:index>`

Communication libraries
=======================

Libraries for high-performance multi-GPU and multi-node communication:

* :doc:`RCCL <rccl:index>` -- Standalone library that provides multi-GPU and
  multi-node collective communication primitives.

* :doc:`rocSHMEM <rocshmem:index>` -- An intra-kernel networking library that
  provides GPU-centric networking through an OpenSHMEM-like interface.

Runtime and compilers
=====================

The core execution environment and programming tools for GPU development on AMD
hardware:

* :doc:`HIP <hip:index>` -- A C++ runtime API and kernel programming language
  designed for AMD GPUs. By providing an interface closely aligned with NVIDIA
  CUDA, HIP allows developers to write portable applications and efficiently
  migrate existing CUDA code to AMD platforms.

* :doc:`HIPIFY <hipify:index>` -- Source translation tools for converting CUDA code
  to HIP. Automates porting existing CUDA applications and libraries to ROCm.

* :doc:`LLVM <llvm-project:index>` -- AMD's LLVM-based compiler infrastructure,
  including the ROCm device compiler (``amdclang``), which compiles HIP and
  OpenCL code for AMD GPUs.

Profiling and debugging tools
==============================

Tools for measuring and analyzing GPU application performance and diagnosing issues:

* :doc:`ROCm Compute Profiler <rocprofiler-compute:index>`
  (rocprofiler-compute) -- Application-level GPU performance analysis for
  identifying compute bottlenecks and roofline analysis.

* :doc:`ROCm Systems Profiler <rocprofiler-systems:index>`
  (rocprofiler-systems) -- System-level profiling that captures GPU, CPU, and
  memory activity across an entire application run.

* :doc:`ROCprofiler-SDK <rocprofiler-sdk:index>` -- Low-level profiling API for
  building custom performance instrumentation on AMD GPUs.

* :doc:`ROCdbgapi <rocdbgapi:index>` -- AMD GPU debugger API providing
  low-level access to GPU execution state.

* :doc:`ROCm Debugger <rocgdb:index>` (ROCgdb) -- GDB-based debugger extended
  to support debugging GPU kernels running on AMD hardware.

* :doc:`ROCr Debug Agent <rocr_debug_agent:index>` -- Runtime debug agent for
  capturing and reporting GPU execution faults and exceptions.

Control and monitoring tools
=============================

Tools for inspecting and managing AMD GPU hardware state:

* :doc:`AMD SMI <amdsmi:index>` -- C, C++, Python, Go, and Rust library
  interfaces and CLI (``amd-smi``) for monitoring and managing AMD devices through
  the ``amdgpu`` kernel driver. Reports and monitors power, temperature,
  utilization, memory usage, clock frequencies, and more.

* :doc:`ROCm Data Center Tool <rdc:index>` (RDC) -- A monitoring and management framework for AMD GPUs
  in data center environments. Provides telemetry collection, health monitoring, and a
  plugin architecture for integration with cluster management systems.

* :doc:`rocminfo <rocminfo:index>` -- Reports HSA runtime and agent
  information, including GPU topology, capability flags, and memory regions
  visible to the ROCm runtime.
