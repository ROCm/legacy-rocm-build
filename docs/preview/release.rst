***************************
ROCm 7.0 RC1 release notes
***************************

The ROCm 7.0 RC1 is a release candidate for the upcoming ROCm 7.0 major
release, which introduces functional support for AMD Instinct™ MI355X and
MI350X on single node systems and new features for current-generation
accelerators.
In this RC1, system support is widened to include more AMD GPUs, Linux
distributions, and virtualization options. This preview includes enhancements
to the HIP runtime, ROCm libraries, and system management tooling.

This is a first release candidate; expect issues and limitations that will be
addressed in upcoming previews.

.. important::

   This preview is not intended for performance evaluation. For the latest stable
   release with production-level functionality, see `ROCm 6.4.2 documentation
   <https://rocm.docs.amd.com/en/latest/>`_.

This document highlights the key changes in the RC1 build since the
`Beta <https://rocm.docs.amd.com/en/docs-7.0-beta/preview/release.html>`__.
For a complete history, see the :doc:`ROCm 7.0 preview release history <versions>`.

.. _rc1-system-requirements:

Operating system and hardware support
=====================================

This preview supports the following AMD accelerators and Linux distributions in single node setups.

.. tab-set::

   .. tab-item:: Instinct MI355X, MI350X

      .. list-table::
         :stub-columns: 1
         :widths: 30, 70

         * - Ubuntu
           - 24.04, 22.04

         * - RHEL
           - 9.6

         * - Oracle Linux
           - 9

   .. tab-item:: Instinct MI325X

      .. list-table::
         :stub-columns: 1
         :widths: 30, 70

         * - Ubuntu
           - 22.04

   .. tab-item:: Instinct MI300X

      .. list-table::
         :stub-columns: 1
         :widths: 30, 70

         * - Ubuntu
           - 24.04, 22.04

         * - RHEL
           - 9.6, 8.10

         * - SLES
           - 15 SP7, 15 SP6

         * - Oracle Linux
           - 9, 8

         * - Debian
           - 12

   .. tab-item:: Instinct MI300A

      .. list-table::
         :stub-columns: 1
         :widths: 30, 70

         * - Ubuntu
           - 24.04, 22.04

         * - RHEL
           - 9.6, 8.10

         * - SLES
           - 15 SP7, 15 SP6

   .. tab-item:: Instinct MI250X, MI250, MI210

      .. list-table::
         :stub-columns: 1
         :widths: 30, 70

         * - Ubuntu
           - 24.04, 22.04

         * - RHEL
           - 9.6, 9.4, 8.10

         * - SLES
           - 15 SP7, 15 SP6

   .. tab-item:: Instinct MI100

      .. list-table::
         :stub-columns: 1
         :widths: 30, 70

         * - Ubuntu
           - 24.04, 22.04

         * - RHEL
           - 9.6, 8.10

         * - SLES
           - 15 SP7, 15 SP6

   .. tab-item:: Radeon PRO V710, V620

      .. list-table::
         :stub-columns: 1
         :widths: 30, 70

         * - Ubuntu
           - 24.04, 22.04

         * - RHEL
           - 9.6, 8.10

         * - SLES
           - 15 SP7, 15 SP6

   .. tab-item:: Radeon RX 9000 series

      .. list-table::
         :stub-columns: 1
         :widths: 30, 70

         * - Ubuntu
           - 24.04, 22.04

         * - RHEL
           - 9.6

         * - SLES
           - 15 SP7, 15 SP6

   .. tab-item:: Radeon RX 7000 series

      .. list-table::
         :stub-columns: 1
         :widths: 30, 70

         * - Ubuntu
           - 24.04, 22.04

         * - RHEL
           - 9.6, 8.10

         * - SLES
           - 15 SP7, 15 SP6

See the :doc:`installation instructions <install/index>` to install ROCm 7.0 RC1 and the Instinct Driver
for your hardware and distribution.

Virtualization support
----------------------

The RC1 includes support for GPU virtualization on KVM-based SR-IOV and VMware ESXi 8.
The following tables detail supported OS configurations per AMD accelerator.

.. tab-set::

   .. tab-item:: KVM SR-IOV

      All supported configurations require the `GIM SR-IOV driver version
      8.3.0K <https://github.com/amd/MxGPU-Virtualization/releases>`__.

      .. list-table::
         :header-rows: 1

         * - AMD accelerator
           - Host OS
           - Guest OS

         * - Instinct MI350X
           - Ubuntu 24.04
           - Ubuntu 24.04

         * - Instinct MI325X
           - Ubuntu 22.04
           - Ubuntu 22.04

         * - Instinct MI300X
           - Ubuntu 22.04
           - Ubuntu 22.04

         * - Instinct MI210
           - RHEL 9.4
           - Ubuntu 22.04 or RHEL 9.4

         * - Radeon PRO V710
           - Ubuntu 22.04
           - Ubuntu 24.04

   .. tab-item:: ESXi 8

      The following configurations are supported on hosts running VMware ESXi 8.

      .. list-table::
         :header-rows: 1

         * - AMD accelerator
           - Guest OS

         * - Instinct MI325X
           - Ubuntu 24.04

         * - Instinct MI300X
           - Ubuntu 24.04

         * - Instinct MI210
           - Ubuntu 24.04

.. _rc1-highlights:

RC1 release highlights
=======================

This section highlights key features enabled in the ROCm 7.0 RC1.

AI frameworks
-------------

The ROCm 7.0 RC1 supports PyTorch 2.7, TensorFlow 2.19, and Triton 3.3.0.

Libraries
---------

Composable Kernel
~~~~~~~~~~~~~~~~~

The RC1 adds functional support for microscaling (MX) data type ``FP6`` in
Composable Kernel. This builds upon `MX data type support (ROCm 7.0 Alpha)
<https://rocm.docs.amd.com/en/docs-7.0-alpha/preview/release.html#new-data-type-support>`__.

hipBLASLt
~~~~~~~~~

GEMM performance has been improved for ``FP8``, ``FP16``, ``BF16``, and ``FP32`` data types.

RCCL support
~~~~~~~~~~~~

RCCL is supported for single node functional usage only. Multi-node communication capabilities will
be supported in a future release.

HIP
---

The following changes improve functionality and runtime performance:

* Improved launch latency for device-to-device (D2D) copies and ``memset`` operations on AMD Instinct MI300 series accelerators.

* Added ``hipMemGetHandleForAddressRange`` to retrieve a handle for a specified
  memory address range. This provides functional parity with CUDA
  ``cuMemGetHandleForAddressRange``.

* Resolved an issue causing crashes in TensorFlow applications. The HIP runtime now
  combines multiple definitions of ``callbackQueue`` into a single function; in
  case of an exception, it passes its handler to the application and provides
  the proper error code.

Compilers
---------

``llvm-strip`` now supports AMD GPU device code objects (``EM_AMDGPU``).

HIPCC
~~~~~

The legacy Perl-based HIPCC scripts -- ``hipcc.pl`` and ``hipconfig.pl`` -- have been removed.

AMD SMI
-------

* Added:

  * New default view when using ``amd-smi`` without arguments. The
    improved default view provides a snapshot of commonly requested information
    such as bdf, current partition mode, version information, and more. You can
    obtain the same information in other output formats using ``amd-smi default
    --json`` or ``amd-smi default --csv``.

  * New APIs:

    * ``amdsmi_get_gpu_bad_page_threshold()`` to get bad page threshold counts.

    * ``amdsmi_get_cpu_model_name()`` to get CPU model names (not sourced from E-SMI library).

    * ``amdsmi_get_cpu_affinity_with_scope()`` to get CPU affinity.

  * API enhancements:

    * ``amdsmi_get_power_info()`` now populates ``socket_power``.

    * ``amdsmi_asic_info_t`` now also includes ``subsystem_id``.

  * CLI enhancements:

    * ``amd-smi topology`` is now available in guest environments.

    * ``amd-smi monitor -p`` now displays the power cap alongside power.

* Optimized:

  * Improved overall performance by reducing the number of backend API calls for ``amd-smi`` CLI commands.

  * Removed partition information from the default ``amd-smi static`` CLI
    command to avoid waking the GPU unnecessarily. This info remains available
    via ``amd-smi`` (default view) and ``amd-smi static -p``.

  * Optimized CLI command ``amd-smi topology`` in partition mode.

* Changed:

  * Updated ``amdsmi_get_clock_info`` in ``amdsmi_interface.py``. The ``clk_deep_sleep`` field now returns the sleep integer value.

  * The char arrays in the following structures have been changed.

    * ``amdsmi_vbios_info_t`` member ``build_date`` changed from ``AMDSMI_MAX_DATE_LENGTH`` to ``AMDSMI_MAX_STRING_LENGTH``.

    * ``amdsmi_dpm_policy_entry_t`` member ``policy_description`` changed from ``AMDSMI_MAX_NAME`` to ``AMDSMI_MAX_STRING_LENGTH``.

    * ``amdsmi_name_value_t`` member ``name`` changed from ``AMDSMI_MAX_NAME`` to ``AMDSMI_MAX_STRING_LENGTH``.

  * Added new event notification types to ``amdsmi_evt_notification_type_t``:
    ``AMDSMI_EVT_NOTIF_EVENT_MIGRATE_START``,
    ``AMDSMI_EVT_NOTIF_EVENT_MIGRATE_END``,
    ``AMDSMI_EVT_NOTIF_EVENT_PAGE_FAULT_START``,
    ``AMDSMI_EVT_NOTIF_EVENT_PAGE_FAULT_END``,
    ``AMDSMI_EVT_NOTIF_EVENT_QUEUE_EVICTION``,
    ``AMDSMI_EVT_NOTIF_EVENT_QUEUE_RESTORE``,
    ``AMDSMI_EVT_NOTIF_EVENT_UNMAP_FROM_GPU``,
    ``AMDSMI_EVT_NOTIF_PROCESS_START``, ``AMDSMI_EVT_NOTIF_PROCESS_END``.

  * The ``amdsmi_bdf_t`` union was changed to have an identical unnamed struct for backwards compatiblity.

* Removed:

  * Cleaned up and unified the API by removing unused definitions and redundant components.

    * Removed unneeded API ``amdsmi_free_name_value_pairs()``.

    * Removed unused definitions: ``AMDSMI_MAX_NAME``, ``AMDSMI_256_LENGTH``,
      ``AMDSMI_MAX_DATE_LENGTH``, ``MAX_AMDSMI_NAME_LENGTH``, ``AMDSMI_LIB_VERSION_YEAR``,
      ``AMDSMI_DEFAULT_VARIANT``, ``AMDSMI_MAX_NUM_POWER_PROFILES``,
      ``AMDSMI_MAX_DRIVER_VERSION_LENGTH``.

      * Removed unused member ``year`` in struct ``amdsmi_version_t``.

    * Replaced ``amdsmi_io_link_type_t`` with the unified ``amdsmi_link_type_t``. ``amdsmi_io_link_type_t`` is no longer needed.
      Code using the old enum might need to be updated; this change also affects ``amdsmi_link_metrics_t``, where the ``link_type`` field is changed from ``amdsmi_io_link_type_t`` to ``amdsmi_link_type_t``.

    * Removed the ``amdsmi_get_power_info_v2()`` function as its functionality is now unified in ``amdsmi_get_power_info()``.

    * Removed ``AMDSMI_EVT_NOTIF_RING_HANG`` event notification type in ``amdsmi_evt_notification_type_t``.

    * Removed enum ``amdsmi_vram_vendor_type_t``. ``amdsmi_get_gpu_vram_info()`` now provides vendor names as a string.

  * Removed backwards compatibility for the ``jpeg_activity`` and ``vcn_activity`` fields in ``amdsmi_get_gpu_metrics_info()``.
    Use ``xcp_stats.jpeg_busy`` or ``xcp_stats.vcn_busy`` instead. This change removes ambiguity between new and old fields
    and supports the expanded metrics available in modern ASICs.

* Resolved issues:

  * Removed duplicated GPU IDs when receiving events using the ``amd-smi event`` command.

Instinct Driver/ROCm packaging separation
-------------------------------------------

The Instinct Driver is now distributed separately from the ROCm software stack and is now stored
in its own location in the package repository at `repo.radeon.com <https://repo.radeon.com/amdgpu/>`_ under ``/amdgpu/``.
The first release is designated as Instinct Driver version 30.10. See `ROCm Gets Modular: Meet the
Instinct Datacenter GPU Driver
<https://rocm.blogs.amd.com/ecosystems-and-partners/instinct-gpu-driver/README.html>`_ for more
information.

Forward and backward compatibility between the Instinct Driver and ROCm is not supported in the
RC1. See the :doc:`installation instructions <install/index>`.
