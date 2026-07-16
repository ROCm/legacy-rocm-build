<div align="center">
  <img src="docs/images/amd-rocm-logo.png" width="200px" alt="ROCm logo">
  <h3 align="center">
    Open-source software stack for AMD GPU computing
  </h3>
  <p align="center">
    <a href="https://rocm.docs.amd.com/en/latest/">
      <b>ROCm Core SDK</b>
    </a>
    <span> • </span>
    <a href="https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/">
      <b>AI Ecosystem</b>
    </a>
    <span> • </span>
    <a href="https://instinct.docs.amd.com/latest/">
      <b>GPU Systems and Infrastructure</b>
    </a>
    <span> • </span>
    <a href="https://rocm.blogs.amd.com/">
      <b>Blogs</b>
    </a>
  </p>
</div>

# AMD ROCm™

ROCm is an open-source software stack of drivers, development tools, and APIs
that enable GPU programming from low-level kernels to end-user applications. It
is particularly well-suited to GPU-accelerated high-performance computing (HPC),
AI, scientific computing, and computer-aided design (CAD).

ROCm is powered by [HIP](https://rocm.docs.amd.com/projects/HIP/en/latest/), a
C++ runtime API and kernel language that lets developers write portable GPU code
with an interface similar to NVIDIA CUDA™. It also supports OpenMP and OpenCL,
and includes the compilers, debuggers, and libraries needed to build and run GPU
workloads. ROCm integrates with machine learning frameworks such as PyTorch and
TensorFlow.

> [!IMPORTANT]
> A new open-source build platform for ROCm is under development at
> https://github.com/ROCm/TheRock, featuring a unified CMake build with bundled
> dependencies, Windows support, and more.

## Table of contents

- [Supported hardware and operating systems](#supported-hardware-and-operating-systems)
- [Quick start](#quick-start)
  - [Get started with ROCm](#get-started-with-rocm)
  - [Deep learning frameworks on ROCm](#deep-learning-frameworks-on-rocm)
- [Core components](#core-components)
  - [Math and compute libraries](#math-and-compute-libraries)
  - [Communication libraries](#communication-libraries)
  - [Runtimes and compilers](#runtimes-and-compilers)
  - [Profiling and debugging tools](#profiling-and-debugging-tools)
  - [Control and monitoring tools](#control-and-monitoring-tools)
  - [Media libraries](#media-libraries)
  - [Storage](#storage)
- [ROCm Extras](#rocm-extras)
- [Release notes](#release-notes)
- [Licenses](#licenses)
- [Contribute](#contribute)

---

## Supported hardware and operating systems

Use the [Compatibility matrix](https://rocm.docs.amd.com/en/latest/compatibility/compatibility-matrix.html) for official support across ROCm versions, operating system kernels, and GPU architectures (CDNA/Instinct™, RDNA/Radeon™, and Radeon Pro). Recent releases cover Ubuntu, RHEL, SLES, Oracle Linux, Debian, Rocky Linux, and more. GPU targets include CDNA4, CDNA3, CDNA2, RDNA4, and RDNA3.

---

## Quick start

Follow these instructions to start using ROCm.

### Get started with ROCm

Follow the [ROCm installation guide](https://rocm.docs.amd.com/en/latest/install/rocm.html) to install ROCm on your system.

### Deep learning frameworks on ROCm

See [Install PyTorch for ROCm](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/frameworks/pytorch/install.html) or
[Install JAX for ROCm](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/frameworks/jax/install.html) to get started.

To learn more about AI training and inference workloads on ROCm, see the [AI
Ecosystem](https://rocm.docs.amd.com/projects/ai-ecosystem/en/latest/index.html)
documentation portal.

---

## Core components

The core ROCm software stack consists of the following components. Most of them
are divided across the [ROCm Libraries](https://github.com/ROCm/rocm-libraries)
and [ROCm Systems](https://github.com/ROCm/rocm-systems/) super-repos by domain.

### Math and compute libraries

- [Composable Kernel](https://github.com/ROCm/rocm-libraries/tree/develop/projects/composablekernel)
- [hipBLAS](https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipblas) and [rocBLAS](https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocblas)
- [hipBLASLt](https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipblaslt)
- [hipCUB](https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipcub)
- [hipFFT](https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipfft) and [rocFFT](https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocfft)
- [hipRAND](https://github.com/ROCm/rocm-libraries/tree/develop/projects/hiprand) and [rocRAND](https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocrand)
- [hipSOLVER](https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipsolver) and [rocSOLVER](https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocsolver)
- [hipSPARSE](https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipsparse) and [rocSPARSE](https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocsparse)
- [MIOpen](https://github.com/ROCm/rocm-libraries/tree/develop/projects/miopen)
- [rocPRIM](https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocprim)
- [rocThrust](https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocthrust)
- [rocWMMA](https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocwmma)

### Communication libraries

- [RCCL](https://github.com/ROCm/rocm-systems/tree/develop/projects/rccl)
- [rocSHMEM](https://github.com/ROCm/rocm-systems/tree/develop/projects/rocshmem)

### Runtimes and compilers

- [HIP](https://github.com/ROCm/rocm-systems/tree/develop/projects/hip)
- [HIPIFY](https://github.com/ROCm/HIPIFY)
- [LLVM](https://github.com/ROCm/llvm-project)
- [ROCr Runtime](https://github.com/ROCm/rocm-systems/tree/develop/projects/rocr-runtime)
- [SPIRV-LLVM-Translator](https://github.com/ROCm/SPIRV-LLVM-Translator)

### Profiling and debugging tools

- [ROCm Compute Profiler (rocprofiler-compute)](https://github.com/ROCm/rocm-systems/tree/develop/projects/rocprofiler-compute)
- [ROCm Systems Profiler (rocprofiler-systems)](https://github.com/ROCm/rocm-systems/tree/develop/projects/rocprofiler-systems)
- [ROCprofiler-SDK](https://github.com/ROCm/rocm-systems/tree/develop/projects/rocprofiler-sdk)
- [ROCdbgapi](https://github.com/ROCm/rocm-systems/tree/develop/projects/rocdbgapi)
- [ROCgdb](https://github.com/ROCm/ROCgdb)
- [ROCr Debug Agent](https://github.com/ROCm/rocr_debug_agent)

### Control and monitoring tools

- [AMD SMI](https://github.com/ROCm/rocm-systems/tree/develop/projects/amdsmi)
- [ROCm Data Center Tool](https://github.com/ROCm/rocm-systems/tree/develop/projects/rdc)
- [rocminfo](https://github.com/ROCm/rocm-systems/tree/develop/projects/rocminfo)

### Media libraries

- [rocDecode](https://github.com/ROCm/rocm-systems/tree/develop/projects/rocdecode)
- [rocJPEG](https://github.com/ROCm/rocm-systems/tree/develop/projects/rocjpeg)

### Storage

- [hipFile](https://github.com/ROCm/rocm-systems/tree/develop/projects/hipfile)

For a complete list of foundational ROCm components, see [ROCm Core
SDK components](https://rocm.docs.amd.com/en/latest/components/core.html).

## ROCm Extras

ROCm Extras include supplementary tools for benchmarking, validating, and managing ROCm deployment.

- [ROCm Validation Suite (RVS)](https://github.com/ROCm/ROCmValidationSuite) and [TransferBench](https://github.com/ROCm/TransferBench)

---

## Release notes

- [Latest ROCm release](https://rocm.docs.amd.com/en/latest/about/release-notes.html)

For information on older ROCm releases, see the
[ROCm release history](https://rocm.docs.amd.com/en/latest/release/versions.html).

---

## Licenses

- [ROCm licenses](https://rocm.docs.amd.com/en/latest/about/license.html)

---

## Contribute

AMD welcomes ROCm contributions using GitHub PRs or issues. See the links
below for contribution guidelines.

- [ROCm](CONTRIBUTING.md)
- [TheRock](https://github.com/ROCm/TheRock/blob/main/CONTRIBUTING.md)
- [ROCm documentation](https://rocm.docs.amd.com/en/latest/contribute/contributing.html)
- [ROCm Systems](https://github.com/ROCm/rocm-systems/blob/develop/CONTRIBUTING.md)
- [ROCm Libraries](https://github.com/ROCm/rocm-libraries/blob/develop/CONTRIBUTING.md)
