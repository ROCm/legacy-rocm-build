.. meta::
   :description: Learn what ROCm is – AMD open software stack for GPU programming, including runtimes, compilers, libraries, and tools for Linux and Windows.
   :keywords: ROCm, AMD, GPU computing, ROCm Core SDK, ROCm components, TheRock, ROCm architecture, HPC, AI, machine learning, ROCm runtime

***********************
AMD ROCm |ROCM_VERSION|
***********************

AMD ROCm is an open, modular, and high‑performance GPU software ecosystem
— built collaboratively with the community, maintained transparently, and
optimized for consistent, scalable performance across data centers,
workstations, and edge devices.

ROCm |ROCM_VERSION| is built with
`TheRock <https://github.com/ROCm/TheRock>`__, AMD’s open build and release
system. TheRock replaces the previous monolithic release process with a modular
workflow that makes ROCm components easier to build, integrate, and distribute.
See the :doc:`release notes </about/release-notes>` for more information.

.. _what-is-rocm:

What is ROCm?
=============

ROCm is the AMD open software stack for GPU‑accelerated computing. It provides
the tools needed to program AMD GPUs — including runtimes, compilers,
performance and system utilities, and optimized math and compute libraries. The
wider ROCm ecosystem includes ROCm‑enabled HPC applications and deep learning
frameworks such as PyTorch.

**Some key features:**

* **Open source** -- Transparent development driven by community feedback
* **Cross‑platform** -- Supports Linux and Windows environments
* **Comprehensive** -- End‑to‑end toolchain from compilers to libraries
* **Performance‑focused** -- Tuned for AMD Instinct™, AMD Radeon™, and AMD Ryzen™ devices

.. raw:: html
   :file: data/landing-page/rocm-ontology.html

ROCm supports AMD GPU architectures spanning data center, workstation, and APU
product lines. TheRock enables a unified ROCm user‑space experience across
devices.

* **AMD Instinct GPUs** -- Purpose‑built for large‑scale compute, AI training, and HPC workloads.

* **AMD Radeon GPUs and AMD Ryzen AI APUs** -- Designed for workstations, desktop computing, and edge AI applications.

See :ref:`release-supported-hw` for the complete list of supported hardware.

ROCm Core SDK
-------------

The ROCm Core SDK provides the foundational components that power the ROCm
ecosystem — runtimes, compilers, math libraries, and system utilities for GPGPU
computing. See :doc:`/components/core` for more information.

.. raw:: html
   :file: data/landing-page/rocm-sdk-arch.html

ROCm Extra components are supplementary tools for benchmarking, validating, and managing ROCm
deployments. These tools are not required for GPU application development but are useful
for verifying hardware health, measuring system performance, and managing GPU fleets.
For more information, see :doc:`/components/extras`.

Get started
===========

* See the release notes -- :doc:`/about/release-notes` -- to learn about the
  latest changes and the current state of ROCm.

* See the :ref:`compat-matrix` -- for system requirements and AMD hardware
  compatibility information.

* Follow :doc:`/install/rocm` to set up ROCm on your system.
