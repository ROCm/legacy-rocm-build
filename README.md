# AMD ROCm Software

ROCm is an open-source stack, composed primarily of open-source software, designed for graphics
processing unit (GPU) computation. ROCm consists of a collection of drivers, development tools, and
APIs that enable GPU programming from low-level kernel to end-user applications.

With ROCm, you can customize your GPU software to meet your specific needs. You can develop,
collaborate, test, and deploy your applications in a free, open source, integrated, and secure software
ecosystem. ROCm is particularly well-suited to GPU-accelerated high-performance computing (HPC),
artificial intelligence (AI), scientific computing, and computer aided design (CAD).

ROCm is powered by AMD’s
[Heterogeneous-computing Interface for Portability (HIP)](https://github.com/ROCm/HIP),
an open-source software C++ GPU programming environment and its corresponding runtime. HIP
allows ROCm developers to create portable applications on different platforms by deploying code on a
range of platforms, from dedicated gaming GPUs to exascale HPC clusters.

ROCm supports programming models, such as OpenMP and OpenCL, and includes all necessary open
source software compilers, debuggers, and libraries. ROCm is fully integrated into machine learning
(ML) frameworks, such as PyTorch and TensorFlow.

> [!IMPORTANT]
> A new open source build platform for ROCm is under development at
> https://github.com/ROCm/TheRock, featuring a unified CMake build with bundled
> dependencies, Windows support, and more.

## Getting and Building ROCm from Source

Please use [TheRock](https://github.com/ROCm/TheRock) build system to build ROCm from source.

## ROCm documentation

This repository contains the [manifest file](https://gerrit.googlesource.com/git-repo/+/HEAD/docs/manifest-format.md)
for ROCm releases, changelogs, and release information.

The `default.xml` file contains information for all repositories and the associated commit used to build
the current ROCm release; `default.xml` uses the [Manifest Format repository](https://gerrit.googlesource.com/git-repo/).

Source code for our documentation is located in the `/docs` folder of most ROCm repositories. The
`develop` branch of our repositories contains content for the next ROCm release.

The ROCm documentation homepage is [rocm.docs.amd.com](https://rocm.docs.amd.com).

For information on how to contribute to the ROCm documentation, see [Contributing to the ROCm documentation](https://rocm.docs.amd.com/en/latest/contribute/contributing.html).

## Older ROCm releases

For release information for older ROCm releases, refer to the
[ROCm release history](https://rocm.docs.amd.com/en/latest/release/versions.html).
