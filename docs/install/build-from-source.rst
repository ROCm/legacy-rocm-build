.. meta::
   :description: Learn how to build the ROCm Core SDK from source using TheRock. Includes references to environment setup guides for Ubuntu 24.04 and Windows 11, plus links to official instructions and compatibility guidance.
   :keywords: AMD ROCm Core SDK, build ROCm from source, TheRock, ROCm SDK, Ubuntu 24.04, Windows 11, ROCm environment setup, AMD GPU compute, ROCm compatibility, ROCm build guide

***********************************
Build the ROCm Core SDK from source
***********************************

You can build the ROCm Core SDK from source using the open-source unified build
system `TheRock <https://github.com/ROCm/TheRock>`__. To learn more about the
motivation and architecture behind this system, see `ROCm 7.9 Technology
Preview: ROCm Core SDK and TheRock Build System
<https://rocm.blogs.amd.com/software-tools-optimization/therock/README.html>`__.

This page consists mostly of key references to `TheRock's README
<https://github.com/ROCm/TheRock?tab=readme-ov-file#building-from-source>`__
and `supporting development guides
<https://github.com/ROCm/TheRock/blob/main/README.md#development-manuals>`__
which provide up-to-date build instructions and guidance for supported
platforms.

.. tip::

   Building from source is recommended only if you need custom builds or are
   contributing to ROCm development. For most users, installing from official
   AMD releases is faster and easier.
   See :doc:`rocm` for installation instructions.

Prerequisites
=============

A successful build depends on a correctly configured environment. Before you
begin, ensure your system meets all hardware and software requirements. Review the
following resources:

* `Environment setup guide
  <https://github.com/ROCm/TheRock/blob/main/docs/environment_setup_guide.md>`__

* :doc:`compatibility-matrix`

High-level build process
========================

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

4. Install the artifacts: See `Installing artifacts
   <https://github.com/ROCm/TheRock/blob/main/docs/development/installing_artifacts.md>`__.
   To learn more about, the TheRock build artifacts, see `Build artifacts
   <https://github.com/ROCm/TheRock/blob/main/docs/development/artifacts.md>`__.

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
