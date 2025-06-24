****************************
ROCm 7.0 Alpha release notes
****************************

The ROCm 7.0 Alpha is an early look into the upcoming ROCm 7.0 major release,
which introduces functional support for AMD Instinct™ MI355X and MI350X
on bare metal, single node systems. It also includes new features for current-generation
MI300X, MI200, and MI100 series accelerators. This is an alpha-quality release;
expect issues and limitations that will be addressed in upcoming previews.

.. important::

   This Alpha release is not intended for performance evaluation.
   For the latest stable release for production-level functionality,
   see `ROCm documentation <https://rocm.docs.amd.com/en/latest/>`_.

This page provides a high-level summary of supported systems, key changes to the ROCm software
stack, developments related to AI frameworks, current known limitations, and installation
information.

.. _alpha-system-requirements:

Operating system and hardware support
=====================================

Only the accelerators and operating systems listed here are supported. Multi-node systems,
virtualized environments, and GPU partitioning are not supported in this Alpha.

* AMD accelerator: Instinct MI355X, MI350X, MI325X [#mi325x]_, MI300X, MI300A, MI250X, MI250, MI210, MI100
* Operating system: Ubuntu 22.04, Ubuntu 24.04, or RHEL 9.6
* System type: Bare metal, single node only
* Partitioning: Not supported

.. [#mi325x] MI325X is only supported with Ubuntu 22.04.

.. _alpha-highlights:

Alpha release highlights
========================

This section highlights key features enabled in the ROCm 7.0 Alpha.

AI frameworks
-------------

PyTorch
~~~~~~~

The ROCm 7.0 Alpha enables the following PyTorch features:

* Support for PyTorch 2.7

* Integrated Fused Rope kernels in APEX

* Compilation of Python C++ extensions using amdclang++

* Support for channels-last NHWC format for convolutions via MIOpen

TensorFlow
~~~~~~~~~~

This Alpha enables support for TensorFlow 2.19.

vLLM
~~~~

* Support for Open Compute Project (OCP) ``FP8`` data type

* ``FP4`` precision for Llama 3.1 405B

Libraries
---------

.. _alpha-new-data-type-support:

New data type support
~~~~~~~~~~~~~~~~~~~~~

MX-compliant data types bring microscaling support to ROCm. For more information, see the `OCP
Microscaling (MX) Formats Specification
<https://www.opencompute.org/documents/ocp-microscaling-formats-mx-v1-0-spec-final-pdf>`_. The ROCm
7.0 Alpha enables functional support for MX data types ``FP4``, ``FP6``, and ``FP8`` on MI355X
systems in these ROCm libraries:

* Composable Kernel (``FP4`` and ``FP8`` only)

* hipBLASLt

* MIGraphX (``FP4`` only)

The following libraries are updated to support the Open Compute Project (OCP) floating-point ``FP8``
format on MI355X instead of the NANOO ``FP8`` format:

* Composable Kernel

* hipBLASLt

* hipSPARSELt

* MIGraphX

* rocWMMA

MIGraphX now also supports ``BF16``.

RCCL support
~~~~~~~~~~~~

RCCL is supported for single-node functional usage only. Multi-node communication capabilities will
be supported in future preview releases.

MIGraphX
~~~~~~~~

* Support for OCP ``FP8`` and MX ``FP4`` data types on MI355X

* Support for ``BF16`` on all hardware

* Support for PyTorch 2.7 via Torch-MIGraphX

Tools
-----

AMD SMI
~~~~~~~

* The default output of the ``amd-smi`` CLI now displays a simple table view.

* New APIs: CPU affinity shows GPUs' affinitization to each CPU in a system.

ROCgdb
~~~~~~

* MX data types support: ``FP4``, ``FP6``, and ``FP8``

ROCprof Compute Viewer
~~~~~~~~~~~~~~~~~~~~~~

* Initial release: ``rocprof-compute-viewer`` allows the visualization of ``rocprofv3``'s thread
  trace output

ROCprof Trace Decoder
~~~~~~~~~~~~~~~~~~~~~

* Initial release: ``rocprof-trace-decoder`` a plugin API for decoding thread traces

ROCm Compute Profiler
~~~~~~~~~~~~~~~~~~~~~

* MX data types support: ``FP4``, ``FP6``, and ``FP8``

* MI355X and MI350X performance counters: CPC, SPI, SQ, TA/TD/TCP, and TCC

* Enhanced roofline analysis with support for ``INT8``, ``INT32``, ``FP8``, ``FP16``, and ``BF16``
  data types

* Roofline distinction for ``FP32`` and ``FP64`` data types

* Selective kernel profiling

ROCm Systems Profiler
~~~~~~~~~~~~~~~~~~~~~

* Trace support for computer vision APIs: H264, H265, AV1, VP9, and JPEG

* Trace support for computer vision engine activity

* OpenMP for C++ language and kernel activity support

ROCm Validation Suite
~~~~~~~~~~~~~~~~~~~~~

* MI355X and MI350X accelerator support in the IET (Integrated Execution Test), GST (GPU Stress Test), and Babel (memory bandwidth test) modules.

ROCprofiler-SDK
~~~~~~~~~~~~~~~

* Program counter (PC) sampling (host trap-based)

* API for profiling applications using thread traces (beta)

* Support in ``rocprofv3`` CLI tool for thread trace service

HIP
---

The HIP runtime includes support for:

* Open Compute Project (OCP) MX floating-point ``FP4``, ``FP6``, and ``FP8`` data types and APIs

* Improved logging by adding more precise pointer information and launch arguments for better
  tracking and debugging in dispatch methods

In addition, the HIP runtime includes the following functional improvements which improve runtime
performance and user experience:

* Optimized HIP runtime lock contention in some events and kernel handling APIs. Event processing
  and memory object look-ups now use the shared mutex implementation. Kernel object look-up during
  C++ kernel launch can now avoid a global lock. These changes improve performance in certain
  applications with high usage, particularly for multiple GPUs, multiple threads, and HIP streams
  per GPU.

* Programmatic support for scratch buffer limit on GPU device. Developers can now change the default
  allocation size with the expected scratch limit.

* Unified managed buffer and kernel argument buffers so the HIP runtime no longer needs to create
  and load a separate kernel argument buffer.

* Refactored memory validation to create a unique function to validate a variety of memory copy
  operations.

* Shader names are now demangled for more readable kernel logs

See :ref:`HIP compatibility <hip-known-limitation>`.

Compilers
---------

* The compiler driver now uses parallel code generation by default when compiling using full LTO
  (including when using the ``-fgpu-rdc`` option) for HIP. This divides the optimized LLVM IR module
  into roughly equal partitions before instruction selection and lowering, which can help improve
  build times.

  Each kernel in the linked LTO module may be put in a separate partition, and any non-inlined
  function it depends on may be copied alongside it. Thus, while parallel code generation can
  improve build time, it can duplicate non-inlined, non-kernel functions across multiple partitions,
  potentially increasing the binary size of the final object file.

  * Compiler option ``-flto-partitions=<num>``.

    Equivalent to the ``--lto-partitions=<num>`` LLD option. Controls the number of partitions used for
    parallel code generation when using full LTO (including when using ``-fgpu-rdc``). The number of
    partitions must be greater than 0, and a value of 1 disables the feature. The default value is 8.

    Developers are encouraged to experiment with different numbers of partitions using the
    ``-flto-partitions`` Clang command line option. Recommended values are 1 to 16 partitions, with
    especially large projects containing many kernels potentially benefitting from up to 64
    partitions. It is not recommended to use a value greater than the number of threads on the
    machine. Smaller projects, or projects that contain only a few kernels may also not benefit at
    all from partitioning and may even see a slight increase in build time due to the small overhead
    of analyzing and partitioning the modules.

* HIPIFY now supports NVIDIA CUDA 12.8.0 APIs. See
  `<https://github.com/ROCm/HIPIFY/blob/amd-develop/docs/reference/supported_apis.md>`_ for more
  information.

Instinct Driver / ROCm packaging separation
-------------------------------------------

The Instinct Driver is now distributed separately from the ROCm software stack -- it is now stored
in its own location in the package repository at `<repo.radeon.com>`_ under ``/amdgpu/``.
The first release is designated as Instinct Driver version 30.10 See `ROCm Gets Modular: Meet the
Instinct Datacenter GPU Driver
<https://rocm.blogs.amd.com/ecosystems-and-partners/instinct-gpu-driver/README.html>`_ for more
information.

Forward and backward compatibility between the Instinct Driver and ROCm are not supported in this
Alpha release. See the :doc:`installation instructions <install/index>`.

Known limitations
=================

.. _hip-known-limitation:

HIP compatibility
-----------------

HIP runtime APIs in the ROCm 7.0 Alpha do not include backward-incompatible changes. See `HIP 7.0 Is
Coming: What You Need to Know to Stay Ahead
<https://rocm.blogs.amd.com/ecosystems-and-partners/transition-to-hip-7.0:-guidance-on-upcoming-compatibility-changes/README.html>`_ for more information.
