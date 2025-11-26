.. meta::
   :description: Learn how to build the ROCm Core SDK from source using TheRock. Includes references to environment setup guides for Ubuntu 24.04 and Windows 11, plus links to official instructions and compatibility guidance.
   :keywords: AMD ROCm Core SDK, build ROCm from source, TheRock, ROCm SDK, Ubuntu 24.04, Windows 11, ROCm environment setup, AMD GPU compute, ROCm compatibility, ROCm build guide

***********************************
Build the ROCm Core SDK from source
***********************************

You can build the ROCm Core SDK from source using the open-source unified build
system `TheRock <https://github.com/ROCm/TheRock>`__. To learn more about the
motivation and architecture behind this system, see `ROCm Technology Preview:
ROCm Core SDK and TheRock Build System
<https://rocm.blogs.amd.com/software-tools-optimization/therock/README.html>`__.

This page consists mainly of key references to `TheRock's README
<https://github.com/ROCm/TheRock?tab=readme-ov-file#building-from-source>`__
and `supporting development manuals
<https://github.com/ROCm/TheRock/blob/main/README.md#development-manuals>`__
which provide up-to-date build instructions and guidance for supported
platforms. See `TheRock Development Guide
<https://github.com/ROCm/TheRock/blob/main/docs/development/development_guide.md#therock-development-guide>`__
to learn about the overall build architecture.

.. tip::

   Building from source is recommended only if you need custom builds or are
   contributing to ROCm development.
   For most users, installing from official AMD releases is faster and easier.
   See :doc:`/install/rocm` for installation instructions.

Prerequisites
=============

A successful build depends on a correctly configured environment. Before you
begin, ensure your system meets all hardware and software requirements. Review the
following resources:

* `Environment setup guide
  <https://github.com/ROCm/TheRock/blob/main/docs/environment_setup_guide.md>`__

* :doc:`/compatibility/compatibility-matrix`

High-level build process
========================

For an overview of the build architecture, start with TheRock's `development guide
<https://github.com/ROCm/TheRock/blob/main/docs/development/development_guide.md>`__.
While specific commands vary by platform, the general workflow for building
from source involves these stages:

1. Clone the repository and install build dependencies. See :ref:`build-from-src-plat-setup`.

2. Configure the build: Use CMake feature flags to configure the build. This
   step allows you to target specific platforms, build subsets of ROCm Core SDK
   components, and toggle component features. See `Build configuration
   <https://github.com/ROCm/TheRock/blob/main/README.md#build-configuration>`__
   for optional and required build flags.

3. Execute the build: Run the build command to compile the source code. This
   can be a time- and resource-intensive process. See `CMake build usage
   <https://github.com/ROCm/TheRock/blob/main/README.md#cmake-build-usage>`__.

4. After a successful build, the outputs are available for use in downstream
   tasks. To learn more about build outputs, see the relevant `TheRock
   documentation <https://github.com/ROCm/TheRock/blob/main/docs/development/artifacts.md>`__.
   Common post-build tasks include:

   * Using ``build/dist/rocm``: When the build completes, you should have a
     build of ROCm in the ``build/dist/rocm/`` directory. See `Using installed
     tarballs <https://github.com/ROCm/TheRock/blob/main/RELEASES.md#using-installed-tarballs>`__
     for more information.

   * Building Python packages: Prepare the build artifacts for distribution as
     Python packages. See `Building Python packages
     <https://github.com/ROCm/TheRock/blob/main/docs/packaging/python_packaging.md#building-packages>`__.

   * Building PyTorch: Build a compatible PyTorch version against ROCm wheels.
     See the `PyTorch build instructions
     <https://github.com/ROCm/TheRock/tree/main/external-builds/pytorch#build-instructions>`__.

.. _build-from-src-plat-setup:

Platform-specific setup
=======================

ManyLinux
---------

On Linux, it's recommended to build with ManyLinux to produce binaries that are
portable across Ubuntu and other Linux distributions. To learn more about what
a ROCm ManyLinux build entails, see `ManyLinux builds
<https://github.com/ROCm/TheRock/blob/main/docs/design/manylinux_builds.md>`__.
Refer to `ManyLinux x86_84
<https://github.com/ROCm/TheRock/blob/main/docs/environment_setup_guide.md#manylinux-x84-64>`__
in the environment setup guide.

Ubuntu 24.04
------------

TheRock provides detailed instructions and scripts for preparing an Ubuntu
24.04 system, including installing necessary packages via apt.
Refer to `Setup — Ubuntu 24.04 <https://github.com/ROCm/TheRock?tab=readme-ov-file#setup---ubuntu-2404>`__
in the TheRock repository for guidance.

Windows 11
----------

For setup instructions on Windows 11 using Visual Studio 2022, see
`Setup — Windows 11
<https://github.com/ROCm/TheRock?tab=readme-ov-file#setup---windows-11-vs-2022>`__
in the TheRock repository.

.. seealso::

   For details on supported configurations, known issues, and other
   Windows-specific considerations, review the `Windows support
   <https://github.com/ROCm/TheRock/blob/main/docs/development/windows_support.md>`__
   documentation.
