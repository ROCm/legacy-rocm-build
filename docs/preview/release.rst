***************************
ROCm 7.0 Beta release notes
***************************

The AMD ROCm 7.0 Beta is a preview of the upcoming ROCm 7.0 release,
which includes functional support for AMD Instinct™ MI355X and MI350X accelerators
on single-node systems. It also introduces new ROCm features for
MI300X, MI200, and MI100 series accelerators. These include the addition of
KVM-based SR-IOV for GPU virtualization, major improvements to the HIP runtime,
and enhancements to profilers.

As this is a Beta release, expect issues and limitations that will be addressed
in upcoming previews.

.. important::

   The Beta release is not intended for performance evaluation.
   For the latest stable release for use in production, see the `ROCm documentation <https://rocm.docs.amd.com/en/latest/>`__.

This document highlights the key changes in the Beta release since the
`Alpha 2 <https://rocm.docs.amd.com/en/docs-7.0-alpha-2/preview/release.html>`__.
For a complete history, see the :doc:`ROCm 7.0 preview release history <versions>`.

.. _beta-system-requirements:

Operating system and hardware support
=====================================

Only the accelerators and operating systems listed below are supported. Multi-node systems
and GPU partitioning are not supported in the Beta release.

.. list-table::
   :stub-columns: 1

   * - AMD Instinct accelerator
     - MI355X, MI350X, MI325X [#mi325x]_, MI300X, MI300A, MI250X, MI250, MI210, MI100

   * - Operating system
     - Ubuntu 22.04, Ubuntu 24.04, RHEL 9.6

   * - System type
     - Single node only

   * - GPU partitioning
     - Not supported

.. [#mi325x] MI325X is only supported with Ubuntu 22.04.

Virtualization support
----------------------

The Beta introduces support for KVM-based SR-IOV on select accelerators. All
supported configurations require the `GIM SR-IOV driver version 8.3.0K
<https://github.com/amd/MxGPU-Virtualization/releases>`__.

.. list-table::
   :header-rows: 1

   * - Accelerator
     - Host OS
     - Guest OS

   * - MI350X
     - Ubuntu 24.04
     - Ubuntu 24.04

   * - MI325X
     - Ubuntu 22.04
     - Ubuntu 22.04

   * - MI300X
     - Ubuntu 24.04
     - Ubuntu 24.04

   * - MI210
     - Ubuntu 22.04
     - Ubuntu 22.04

.. _beta-highlights:

Beta release highlights
=======================

This section highlights key features enabled in the ROCm 7.0 Beta release.

AI frameworks
-------------

The ROCm 7.0 Beta release supports PyTorch 2.7, TensorFlow 2.19, and Triton 3.3.0.

RCCL support
------------

RCCL is supported for single-node functional usage only. Multi-node communication capabilities will
be supported in future preview releases.

HIP
---

Enhancements
~~~~~~~~~~~~

* Added ``hipDeviceGetAttribute``, a new device attribute to query the number
  of compute dies (chiplets, XCCs), enabling performance optimizations based on
  cache locality.

* Extended fine-grained system memory pools.

* To improve API consistency, ``num_threads`` is now an alias for the legacy
  ``size`` parameter.

Fixes
~~~~~

* Fixed an issue where ``hipExtMallocWithFlags()`` did not correctly handle the
  ``hipDeviceMallocContiguous`` flag. The function now properly enables the
  ``HSA_AMD_MEMORY_POOL_CONTIGUOUS_FLAG`` for memory pool allocations on the GPU.

* Resolved a compilation failure caused by incorrect vector type alignment. The
  HIP runtime has been refactored to use ``__hip_vec_align_v`` for proper
  alignment.

Backwards-incompatible changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Backwards-incompatible API changes previously described in `HIP 7.0 Is Coming:
What You Need to Know to Stay Ahead
<https://rocm.blogs.amd.com/ecosystems-and-partners/transition-to-hip-7.0-blog/README.html>`__
are enabled in the Beta. These changes -- aimed at improving GPU code
portability -- include:

Behavior changes
^^^^^^^^^^^^^^^^

* To align with NVIDIA CUDA behavior, ``hipGetLastError`` now returns the last actual
  error code caught in the current thread during application execution -- neither
  ``hipSuccess`` nor ``hipErrorNotReady`` are considered errors.
  ``hipExtGetLastError`` retains the previous behavior of ``hipGetLastError``.

* Cooperative groups: added stricter input parameter validation to
  ``hipLaunchCooperativeKernel`` and ``hipLaunchCooperativeKernelMultiDevice``.

* ``hipPointerGetAttributes`` now returns ``hipSuccess`` instead of
  ``hipErrorInvalidValue`` when a null pointer is passed as an input parameter,
  aligning its behaviour with ``cudaPointerGetAttributes`` (CUDA 11+).

* ``hipFree`` no longer performs an implicit device-wide wait when freeing
  memory allocated with ``hipMallocAsync`` or ``hipMallocFromPoolAsync``. This
  matches the behavior of ``cudaFree``.

hipRTC changes
^^^^^^^^^^^^^^

* ``hipRTC`` symbols are now removed from the HIP runtime library.
  Any application using hipRTC APIs should link explicitly with the hipRTC
  library. This makes the usage of hipRTC library on Linux the same as on
  Windows and matches the behavior of CUDA nvRTC.

* hipRTC compilation: the device code compilation now uses namespace
  ``__hip_internal``, instead of the standard headers std, to avoid namespace
  collision.

* Datatype definitions such as ``int64_t``, ``uint64_t``, ``int32_t``,
  ``uint32_t``, and so on, are removed to avoid any potential conflicts in
  some applications as they use their own definitions for these types. HIP
  now uses internal datatypes instead, prefixed with ``__hip`` --  for
  example, ``__hip_int64_t``.

HIP header clean up
^^^^^^^^^^^^^^^^^^^

* Removed non-essential C++ standard library headers; HIP header files now
  only include necessary STL headers.

* The deprecated struct ``HIP_MEMSET_NODE_PARAMS`` is now removed from the
  API. Developers can use the definition ``hipMemsetParams`` instead.

API changes
^^^^^^^^^^^

* Some APIs' signatures have been adjusted to match corresponding CUDA counterparts. Impacted
  APIs are: 

  * ``hiprtcCreateProgram``

  * ``hiprtcCompileProgram``

  * ``hipMemcpyHtoD``

  * ``hipCtxGetApiVersion``

* Updated ``hipMemsetParams`` for compatibility with the CUDA equivalent structure.

* HIP vector constructors for ``hipComplex`` initialization now generate
  correct values. The affected constructors are small vector types such as
  ``float2``, ``int4``, and so on.

Stream capture
^^^^^^^^^^^^^^

Stream capture mode is now more restrictive in HIP APIs through the addition
of the ``CHECK_STREAM_CAPTURE_SUPPORTED`` macro.

* HIP now only supports ``hipStreamCaptureModeRelaxed``. Attempts to initiate
  stream capture with any other mode will fail and return
  ``hipErrorStreamCaptureUnsupported``. Consequently, the following APIs are
  only permitted in Relaxed mode and will return an error if called during
  capture with a now disallowed mode:

  * ``hipMallocManaged``

  * ``hipMemAdvise``

* The following APIs check the stream capture mode and return error codes, matching
  CUDA behavior:

  * ``hipLaunchCooperativeKernelMultiDevice``

  * ``hipEventQuery``

  * ``hipStreamAddCallback``

* During stream capture, the following HIP APIs now return the error
  ``hipErrorStreamCaptureUnsupported`` on the AMD platform, not always
  ``hipSuccess``. This aligns with CUDA's behavior.

  * ``hipDeviceSetMemPool``

  * ``hipMemPoolCreate``

  * ``hipMemPoolDestroy``

  * ``hipDeviceSetSharedMemConfig``

  * ``hipDeviceSetCacheConfig``

Error codes
^^^^^^^^^^^

Error and value codes returned by HIP APIs have been updated to align with
their CUDA counterparts.

* Module management-related APIs: ``hipModuleLaunchKernel``,
  ``hipExtModuleLaunchKernel``, ``hipExtLaunchKernel``,
  ``hipDrvLaunchKernelEx``, ``hipLaunchKernel``, ``hipLaunchKernelExC``,
  ``hipModuleLaunchCooperativeKernel``, ``hipModuleLoad``

* Texture management-related APIs:

  * ``hipTexObjectCreate`` -- now supports zero width and height for 2D images. If
    either is zero, will not return false.

  * ``hipBindTexture2D`` -- now returns ``hipErrorNotFound`` for null texture or device pointers.

  * ``hipBindTextureToArray`` -- now returns
    ``hipErrorInvalidChannelDescriptor`` (instead of ``hipErrorInvalidValue``)
    for null inputs.

  * ``hipGetTextureAlignmentOffset`` -- now returns ``hipErrorInvalidTexture``
    for a null texture reference.

* Cooperative group-related APIs: added stricter validations to ``hipLaunchCooperativeKernelMultiDevice`` and ``hipLaunchCooperativeKernel``

Invalid stream input parameter handling
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To match the CUDA runtime behavior more closely, HIP APIs with streams passed
as input parameters no longer check the stream validity. Previously, the HIP
runtime returned an error code ``hipErrorContextIsDestroyed`` if the stream was
invalid. In CUDA version 12 and later, the equivalent behavior is to raise a
segmentation fault. In HIP 7.0, the HIP runtime matches the CUDA by causing a
segmentation fault. The list of APIs impacted by this change are as follows:

* Stream management-related APIs: ``hipStreamGetCaptureInfo``,
  ``hipStreamGetPriority``, ``hipStreamGetFlags``, ``hipStreamDestroy``,
  ``hipStreamAddCallback``, ``hipStreamQuery``, ``hipLaunchHostFunc``

* Graph management-related APIs: ``hipGraphUpload``, ``hipGraphLaunch``,
  ``hipStreamBeginCaptureToGraph``, ``hipStreamBeginCapture``,
  ``hipStreamIsCapturing``, ``hipStreamGetCaptureInfo``,
  ``hipGraphInstantiateWithParams``

* Memory management-related APIs: ``hipMemcpyPeerAsync``,
  ``hipMemcpy2DValidateParams``, ``hipMallocFromPoolAsync``, ``hipFreeAsync``,
  ``hipMallocAsync``, ``hipMemcpyAsync``, ``hipMemcpyToSymbolAsync``,
  ``hipStreamAttachMemAsync``, ``hipMemPrefetchAsync``, ``hipDrvMemcpy3D``,
  ``hipDrvMemcpy3DAsync``, ``hipDrvMemcpy2DUnaligned``, ``hipMemcpyParam2D``,
  ``hipMemcpyParam2DAsync``, ``hipMemcpy2DArrayToArray``, ``hipMemcpy2D``,
  ``hipMemcpy2DAsync``, ``hipDrvMemcpy2DUnaligned``, ``hipMemcpy3D``

* Event management-related APIs: ``hipEventRecord``,
  ``hipEventRecordWithFlags``

warpSize
^^^^^^^^

To align with the CUDA specification, the ``warpSize`` device variable is no longer a
compile-time constant (``constexpr``). This is a backwards-incompatible change for applications
that use ``warpSize`` in a compile-time context.

ROCprofiler-SDK and rocprofv3
-----------------------------

rocpd
~~~~~

Support has been added for the ``rocpd`` (ROCm Profiling Data) output format,
which is now the default format for rocprofv3. A subproject of the
ROCprofiler-SDK, ``rocpd`` enables saving profiling results to a SQLite3
database, providing a structured and efficient foundation for analysis and
post-processing.

Core SDK enhancements
~~~~~~~~~~~~~~~~~~~~~

* ROCprofiler-SDK is now compatible with the HIP 7.0 API.

* Added stochastic and host-trap PC sampling support for all MI300 series accelerators.

* Added support for tracing KFD events.

rocprofv3 CLI tool enhancements
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* Added stochastic and host-trap PC sampling support for all MI300 series accelerators.

* HIP streams translate to Queues in Time Traces in Perfetto output.

Instinct Driver / ROCm packaging separation
-------------------------------------------

The Instinct Driver is now distributed separately from the ROCm software stack and is now stored
in its own location in the package repository at `repo.radeon.com <https://repo.radeon.com/amdgpu/>`_ under ``/amdgpu/``.
The first release is designated as Instinct Driver version 30.10. See `ROCm Gets Modular: Meet the
Instinct Datacenter GPU Driver
<https://rocm.blogs.amd.com/ecosystems-and-partners/instinct-gpu-driver/README.html>`_ for more
information.

Forward and backward compatibility between the Instinct Driver and ROCm is not supported in the
Beta release. See the :doc:`installation instructions <install/index>`.
