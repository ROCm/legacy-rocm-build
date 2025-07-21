******************************
ROCm 7.0 Alpha 2 release notes
******************************

The ROCm 7.0 Alpha 2 is a preview of the upcoming ROCm 7.0 release,
which includes functional support for AMD Instinct™ MI355X and MI350X
on bare metal, single-node systems. It also introduces new ROCm features for
MI300X, MI200, and MI100 series accelerators. This is an Alpha-quality release;
expect issues and limitations that will be addressed in upcoming previews.

.. important::

   The Alpha 2 release is not intended for performance evaluation.
   For the latest stable release with production-level functionality,
   see `ROCm 6.4.2 documentation <https://rocm.docs.amd.com/en/latest/>`_.

This page provides a high-level summary of key changes added to the Alpha 2
release since `the previous Alpha
<https://rocm.docs.amd.com/en/docs-7.0-alpha/preview/index.html>`_.

.. _alpha-2-system-requirements:

Operating system and hardware support
=====================================

Only the accelerators and operating systems listed here are supported. Multi-node systems,
virtualized environments, and GPU partitioning are not supported in the Alpha 2 release.

* AMD Instinct accelerator: MI355X, MI350X, MI325X [#mi325x]_, MI300X, MI300A, MI250X, MI250, MI210, MI100
* Operating system: Ubuntu 22.04, Ubuntu 24.04, RHEL 9.6
* System type: Bare metal, single node only
* Partitioning: Not supported

.. [#mi325x] MI325X is only supported with Ubuntu 22.04.

.. _alpha-2-highlights:

Alpha 2 release highlights
==========================

This section highlights key features enabled in the ROCm 7.0 Alpha 2 release.

AI frameworks
-------------

The ROCm 7.0 Alpha 2 release supports PyTorch 2.7, TensorFlow 2.19, and Triton 3.3.0.

Libraries
---------

MIGraphX
~~~~~~~~

Added support for the Open Compute Project (OCP) ``FP8`` data type on MI350X accelerators.

RCCL support
~~~~~~~~~~~~

RCCL is supported for single-node functional usage only. Multi-node communication capabilities will
be supported in future preview releases.

HIP
---

The HIP runtime includes support for:

* Added ``constexpr`` operators for ``FP16`` and ``BF16``.

* Added ``__syncwarp`` operation.

* The ``_sync()`` version of crosslane builtins such as ``shfl_sync()`` and
  ``__reduce_add_sync`` are enabled by default. These can be disabled by
  setting the preprocessor macro ``HIP_DISABLE_WARP_SYNC_BUILTINS``.

In addition, the HIP runtime includes the following functional enhancements which improve runtime
performance and user experience:

* HIP runtime now enables peer-to-peer (P2P) memory copies to utilize all
  available SDMA engines, rather than being limited to a single engine. It also
  selects the best engine first to give optimal bandwidth.

* To match CUDA runtime behavior more closely, HIP runtime APIs no longer check
  the stream validity with streams passed as input parameters. If the input
  stream is invalid, it causes a segmentation fault instead of returning
  an error code ``hipErrorContextIsDestroyed``.

The following issues have been resolved:

* An issue when retrieving a memory object from the IPC memory handle causing
  failures in some framework test applications.

* An issue causing the incorrect return error ``hipErrorNoDevice`` when a crash occurred
  on a GPU due to an illegal operation or memory violation. The HIP runtime now
  handles the failure on the GPU side properly and reports the precise error
  code based on the last error seen on the GPU.

See :ref:`HIP compatibility <hip-known-limitation>` for more information about upcoming API changes.

Compilers
---------

The Alpha 2 release introduces the AMD Next-Gen Fortran compiler. ``llvm-flang``
(sometimes called ``new-flang`` or ``flang-18``) is a re-implementation of the
Fortran frontend. It is a strategic replacement for ``classic-flang`` and is
developed in LLVM's upstream repo at `<https://github.com/llvm/llvm-project/tree/main/flang>`__.

Key enhancements include:

* Compiler:

  * Improved memory load and store instructions.

  * Updated clang/llvm to `AMD clang version 20.0.0git` (equivalent to LLVM 20.0.0 with additional out-of-tree patches).

  * Support added for separate debug file generation for device code.

* Comgr:

  * Added support for an in-memory virtual file system (VFS) for storing temporary files
    generated during intermediate compilation steps. This is designed to
    improve performance by reducing on-disk file I/O. Currently, VFS is
    supported only for the device library link step, with plans for expanded
    support in future releases.

* SPIR-V:

  * Improved `target-specific extensions <https://github.com/ROCm/llvm-project/blob/c2535466c6e40acd5ecf6ba1676a4e069c6245cc/clang/docs/LanguageExtensions.rst>`_:

    * Added a new target-specific builtin ``__builtin_amdgcn_processor_is`` for late or deferred queries of the current target processor.

    * Added a new target-specific builtin ``__builtin_amdgcn_is_invocable``, enabling fine-grained, per-builtin feature availability.

* HIPIFY now supports NVIDIA CUDA 12.8.0 APIs:

  * Added support for all new device and host APIs, including ``FP4``, ``FP6``, and ``FP128`` -- including support for the corresponding ROCm HIP equivalents.

* Deprecated features:

  * ROCm components no longer use the ``__AMDGCN_WAVEFRONT_SIZE`` and
    ``__AMDGCN_WAVEFRONT_SIZE__`` macros nor HIP's ``warpSize`` variable as
    ``constexpr``s. These macros and reliance on ``warpSize`` as a ``constexpr`` are
    deprecated and will be disabled in a future release. Users are encouraged
    to update their code if needed to ensure future compatibility.

Instinct Driver / ROCm packaging separation
-------------------------------------------

The Instinct Driver is now distributed separately from the ROCm software stack and is now stored
in its own location in the package repository at `repo.radeon.com <https://repo.radeon.com/amdgpu/>`_ under ``/amdgpu/``.
The first release is designated as Instinct Driver version 30.10. See `ROCm Gets Modular: Meet the
Instinct Datacenter GPU Driver
<https://rocm.blogs.amd.com/ecosystems-and-partners/instinct-gpu-driver/README.html>`_ for more
information.

Forward and backward compatibility between the Instinct Driver and ROCm is not supported in the
Alpha 2 release. See the :doc:`installation instructions <install/index>`.

Known limitations
=================

.. _hip-known-limitation:

HIP compatibility
-----------------

HIP runtime APIs in the ROCm 7.0 Alpha 2 don't include the upcoming backward-incompatible changes. See `HIP 7.0 Is
Coming: What You Need to Know to Stay Ahead
<https://rocm.blogs.amd.com/ecosystems-and-partners/transition-to-hip-7.0-blog/README.html>`_ to learn about the
changes expected for HIP.
