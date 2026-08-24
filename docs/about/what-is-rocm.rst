.. meta::
   :description: Learn what ROCm is – AMD open software stack for GPU programming, including runtimes, compilers, libraries, and tools for Linux and Windows.
   :keywords: ROCm, AMD, GPU computing, ROCm Core SDK, ROCm components, TheRock, ROCm architecture, HPC, AI, machine learning, ROCm runtime

.. _what-is-rocm:

*************
What is ROCm?
*************

ROCm is the AMD open software stack for GPU‑accelerated computing. It provides
the tools needed to program AMD GPUs — including runtimes, compilers,
performance and system utilities, and optimized math and compute libraries. The
wider ROCm ecosystem includes ROCm‑enabled HPC applications and deep learning
frameworks such as PyTorch.

ROCm |ROCM_VERSION| is built through `TheRock
<https://github.com/ROCm/TheRock>`__, AMD’s open build and release system.
TheRock replaces the previous monolithic release process with a modular
workflow that makes ROCm components easier to build, integrate, and distribute.
See the :doc:`release notes </about/release-notes>` for more information.

ROCm Core SDK
=============

The ROCm Core SDK provides the foundational components that power the ROCm
ecosystem — runtimes, compilers, math libraries, and system utilities for GPGPU
computing. See :doc:`/components/core` for more information.

.. raw:: html
   :file: ../images/landing-page/rocm-sdk-arch.html

ROCm Extras
===========

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
