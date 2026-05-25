<div align="center">
<img src="docs/data/amd-rocm-logo.png" width="200px" alt="ROCm logo">

<h3 align="center">
Open-source stack designed for GPU computation
</h3>

<p align="center">
<a href="https://rocm.docs.amd.com/en/latest/"><b>Docs</b></a> • <a href="https://rocm.blogs.amd.com/"><b>Blogs</b></a> • <a href="https://rocm.docs.amd.com/projects/ai-developer-hub/en/latest/"><b>Tutorials</b></a> • <a href="https://rocm.docs.amd.com/en/latest/how-to/deep-learning-rocm.html"><b>Deep learning frameworks</b></a> • <a href="https://rocm.docs.amd.com/en/latest/how-to/rocm-for-ai/index.html"><b>ROCm for AI</b></a>
</p>

</div>

# AMD ROCm™ software

ROCm is an open-source stack, composed primarily of open-source software, designed for graphics
processing unit (GPU) computation. ROCm consists of a collection of drivers, development tools, and
APIs that enable GPU programming from low-level kernel to end-user applications.

You can customize the ROCm software to meet your specific needs. You can develop,
collaborate, test, and deploy your applications in a free, open-source, integrated, and secure software
ecosystem. ROCm is particularly well-suited to GPU-accelerated high-performance computing (HPC),
artificial intelligence (AI), scientific computing, and computer-aided design (CAD).

ROCm is powered by [HIP](https://github.com/ROCm/rocm-systems/tree/develop/projects/hip),
a C++ runtime API and kernel language for AMD GPUs. HIP allows developers to create portable
applications by providing a programming interface that is similar to NVIDIA CUDA™.

ROCm supports programming models, such as OpenMP and OpenCL, and includes all necessary
open-source software compilers, debuggers, and libraries. ROCm is fully integrated into machine learning
(ML) frameworks, such as PyTorch and TensorFlow.

> [!IMPORTANT]
> A new open-source build platform for ROCm is under development at
> https://github.com/ROCm/TheRock, featuring a unified CMake build with bundled
> dependencies, Microsoft Windows support, and more.

## Table of contents

- [Supported hardware and operating systems](#supported-hardware-and-operating-systems)
- [Quick start](#quick-start)
  - [Get started with ROCm](#get-started-with-rocm)
  - [Get started with PyTorch on ROCm](#get-started-with-pytorch-on-rocm)
- [Core components](#core-components)
  - [Math libraries](#math-libraries)
  - [ML and computer vision](#ml-and-computer-vision)
  - [Collective communication and primitives](#collective-communication-and-primitives)
  - [System management tools](#system-management-tools)
  - [Profiling tools](#profiling-tools)
  - [Development tools](#development-tools)
  - [Runtimes and compilers](#runtimes-and-compilers)
- [Release notes](#release-notes)
- [Licenses](#licenses)
- [ROCm release history](#rocm-release-history)
- [Contribute](#contribute)

---

## Supported hardware and operating systems

Use the [Compatibility matrix](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/reference/system-requirements.html) for official support across ROCm versions, operating system kernels, and GPU architectures (CDNA/Instinct™, RDNA/Radeon™, and Radeon Pro). Recent releases cover Ubuntu, RHEL, SLES, Oracle Linux, Debian, Rocky Linux, and more. GPU targets include CDNA4, CDNA3, CDNA2, RDNA4, and RDNA3.

If you’re using AMD Radeon GPUs or Ryzen APUs in a workstation setting with a display connected, see the [ROCm on Radeon and Ryzen documentation](https://rocm.docs.amd.com/projects/radeon-ryzen/en/latest/index.html) for operating system/framework support and step-by-step installation instructions.

---

## Quick start

Follow these instructions to start using ROCm.

### Get started with ROCm

Follow the [ROCm installation guide](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/quick-start.html) to install ROCm on your system.

### Get started with PyTorch on ROCm

Follow the [PyTorch on ROCm installation guide](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/3rd-party/pytorch-install.html) to install PyTorch with ROCm support in a Docker environment.

---

## Core components

The core ROCm stack consists of the following components:

### Math libraries

- [rocBLAS](https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocblas), [hipBLAS](https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipblas), and [hipBLASLt](https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipblaslt)
- [rocFFT](https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocfft) and [hipFFT](https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipfft)
- [rocRAND](https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocrand) and [hipRAND](https://github.com/ROCm/rocm-libraries/tree/develop/projects/hiprand)
- [rocSOLVER](https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocsolver) and [hipSOLVER](https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipsolver)
- [rocSPARSE](https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocsparse) and [hipSPARSE](https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipsparse)
- [rocWMMA](https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocwmma) and [hipTensor](https://github.com/ROCm/rocm-libraries/tree/develop/projects/hiptensor)

### ML and computer vision

- [Composable Kernel](https://github.com/ROCm/rocm-libraries/tree/develop/projects/composablekernel)
- [MIGraphX](https://github.com/ROCm/AMDMIGraphX/)
- [MIOpen](https://github.com/ROCm/rocm-libraries/tree/develop/projects/miopen)
- [MIVisionX](https://github.com/ROCm/MIVisionX)
- [ROCm Performance Primitives (RPP)](https://github.com/ROCm/rpp)

### Collective communication and primitives

- [hipCUB](https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipcub)
- [RCCL](https://github.com/ROCm/rocm-systems/tree/develop/projects/rccl)
- [rocPRIM](https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocprim)
- [rocSHMEM](https://github.com/ROCm/rocm-systems/tree/develop/projects/rocshmem)
- [rocThrust](https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocthrust)

### System management tools

- [AMD SMI](https://github.com/ROCm/rocm-systems/tree/develop/projects/amdsmi)
- [rocminfo](https://github.com/ROCm/rocm-systems/tree/develop/projects/rocminfo)

### Profiling tools

- [ROCprofiler-SDK](https://github.com/ROCm/rocm-systems/tree/develop/projects/rocprofiler-sdk)
- [ROCm Compute Profiler](https://github.com/ROCm/rocm-systems/tree/develop/projects/rocprofiler-compute)

### Development tools

- [ROCm Debugger (ROCgdb)](https://github.com/ROCm/ROCgdb)
- [ROCdbgapi](https://github.com/ROCm/rocm-systems/tree/develop/projects/rocdbgapi)

### Runtimes and compilers

- [HIP](https://github.com/ROCm/rocm-systems/tree/develop/projects/hip)
- [LLVM](https://github.com/ROCm/llvm-project)
- [ROCR Runtime (ROCR)](https://github.com/ROCm/rocm-systems/tree/develop/projects/rocr-runtime)

For a complete list of ROCm components and version information, see the
[ROCm components](https://rocm.docs.amd.com/en/latest/about/release-notes.html#rocm-components).

---

## Release notes

- [Latest version of ROCm](https://rocm.docs.amd.com/en/latest/about/release-notes.html) - production
- [ROCm 7.13.0](https://rocm.docs.amd.com/en/7.13.0-preview/about/release-notes.html) – preview stream

---

## Licenses

- [ROCm licenses](https://rocm.docs.amd.com/en/latest/about/license.html)

---

## ROCm release history

For information on older ROCm releases, see the
[ROCm release history](https://rocm.docs.amd.com/en/latest/release/versions.html).

---

## Contribute

AMD welcomes ROCm contributions using GitHub PRs or issues. See the links
below for contribution guidelines.

- [ROCm](CONTRIBUTING.md)
- [TheRock](https://github.com/ROCm/TheRock/blob/main/CONTRIBUTING.md)
- [ROCm documentation](https://rocm.docs.amd.com/en/latest/contribute/contributing.html)
- [ROCm Systems](https://github.com/ROCm/rocm-systems/blob/develop/CONTRIBUTING.md)
- [ROCm Libraries](https://github.com/ROCm/rocm-libraries/blob/develop/CONTRIBUTING.md)
