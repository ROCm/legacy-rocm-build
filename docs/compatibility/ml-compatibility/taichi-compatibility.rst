:orphan:

.. meta::
    :description: Taichi compatibility
    :keywords: GPU, Taichi compatibility

.. version-set:: rocm_version latest

*******************************************************************************
Taichi compatibility
*******************************************************************************

`Taichi <https://www.taichi-lang.org/>`_ is an open-source, imperative, and parallel 
programming language designed for high-performance numerical computation. 
Embedded in Python, it leverages just-in-time (JIT) compilation frameworks such as LLVM to accelerate 
compute-intensive Python code by compiling it to native GPU or CPU instructions.

Taichi is widely used across various domains, including real-time physical simulation, 
numerical computing, augmented reality, artificial intelligence, computer vision, robotics, 
visual effects in film and gaming, and general-purpose computing.

* ROCm support for Taichi is hosted in the official `https://github.com/ROCm/taichi <https://github.com/ROCm/taichi>`_ repository.
* Due to independent compatibility considerations, this location differs from the `https://github.com/taichi-dev <https://github.com/taichi-dev>`_ upstream repository.
* Use the prebuilt :ref:`Docker image <taichi-docker-compat>` with ROCm, PyTorch, and Taichi preinstalled.
* See the :doc:`ROCm Taichi installation guide <rocm-install-on-linux:install/3rd-party/taichi-install>` to install and get started.

.. note::

	Taichi is supported on ROCm 6.3.2.

Supported devices and features
===============================================================================
There is support through the ROCm software stack for all Taichi GPU features on AMD Instinct MI250X and MI210X Series GPUs with the exception of Taichi’s GPU rendering system, CGUI.
AMD Instinct MI300X Series GPUs will be supported by November.

.. _taichi-recommendations:

Use cases and recommendations
================================================================================
To fully leverage Taichi's performance capabilities in compute-intensive tasks, it is best to adhere to specific coding patterns and utilize Taichi decorators. 
A collection of example use cases is available in the `https://github.com/ROCm/taichi_examples <https://github.com/ROCm/taichi_examples>`_ repository, 
providing practical insights and foundational knowledge for working with the Taichi programming language. 
You can also refer to the `AMD ROCm blog <https://rocm.blogs.amd.com/>`_ to search for Taichi examples and best practices to optimize your workflows on AMD GPUs.

.. _taichi-docker-compat:

Docker image compatibility
================================================================================

.. |docker-icon| raw:: html

   <i class="fab fa-docker"></i>

AMD validates and publishes ready-made `ROCm Taichi Docker images <https://hub.docker.com/r/rocm/taichi/tags>`_
with ROCm backends on Docker Hub. The following Docker image tags and associated inventories 
represent the latest Taichi version from the official Docker Hub.
The Docker images have been validated for `ROCm 6.3.2 <https://rocm.docs.amd.com/en/docs-6.3.2/about/release-notes.html>`_. 
Click |docker-icon| to view the image on Docker Hub.

.. list-table:: 
    :header-rows: 1
    :class: docker-image-compatibility

    * - Docker image
      - ROCm
      - Taichi
      - Ubuntu
      - Python

    * - .. raw:: html

           <a href="https://hub.docker.com/layers/rocm/taichi/taichi-1.8.0b1_rocm6.3.2_ubuntu22.04_py3.10.12/images/sha256-e016964a751e6a92199032d23e70fa3a564fff8555afe85cd718f8aa63f11fc6"><i class="fab fa-docker fa-lg"></i> rocm/taichi</a>
      - `6.3.2 <https://repo.radeon.com/rocm/apt/6.3.2/>`_
      - `1.8.0b1 <https://github.com/taichi-dev/taichi>`_
      - 22.04
      - `3.10.12 <https://www.python.org/downloads/release/python-31012/>`_