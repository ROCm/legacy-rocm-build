.. meta::
   :description: System optimization for AMD RDNA3 (gfx1100, gfx1101, gfx1102) GPUs running ROCm compute workloads on Linux.
   :keywords: AMD, RDNA3, gfx1100, gfx1101, gfx1102, ROCm, system optimization, BIOS, rocm-smi, amdgpu, compute, AI inference, HPC

.. _rdna3-system-optimization:

===========================
AMD RDNA3 system acceptance
===========================

This page describes system settings for AMD RDNA3 GPUs (``gfx1100``,
``gfx1101``, ``gfx1102``) running ROCm compute workloads on Linux, such as AI
inference and HPC applications. Gaming-specific settings, display configuration,
and SR-IOV virtualization are out of scope.

Overview
========

AMD RDNA3 GPUs (LLVM targets ``gfx1100``, ``gfx1101``, and ``gfx1102``) include
the Radeon RX 7000 series and Radeon PRO W7000 series. Use this page to
configure and tune an RDNA3 GPU for ROCm compute workloads, then validate it
with the :doc:`RDNA health checks <rdna-health-checks>` and
:doc:`RDNA validation <rdna-validation>`.

- `AMD RDNA3 instruction set architecture <https://www.amd.com/system/files/TechDocs/rdna3-shader-instruction-set-architecture-feb-2023_0.pdf>`_

System requirements
===================

Operating system support
------------------------

For supported distributions and kernel versions, see the ROCm system
requirements:

- `System requirements (Linux) <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/reference/system-requirements.html>`_
- `System requirements (Microsoft Windows) <https://rocm.docs.amd.com/projects/install-on-windows/en/latest/reference/system-requirements.html>`_

GPU identification
------------------

Confirm the GPU is present on the PCIe bus. AMD GPUs use PCI vendor ID
``1002``:

.. code-block:: shell

   lspci -d 1002: | grep -iE "VGA|Display"

Confirm that ROCm recognizes the GPU and report its target architecture:

.. code-block:: shell

   amd-smi static --asic

The ``TARGET_GRAPHICS_VERSION`` field reports ``gfx1100``, ``gfx1101``, or
``gfx1102`` for RDNA3.

.. _rdna3-bios-settings:

System BIOS settings
====================

The following BIOS settings are recommended for RDNA3 GPUs running compute
workloads. Enable them before installing ROCm.

.. list-table::
   :header-rows: 1

   * - BIOS setting
     - Recommended value
     - Notes

   * - Above 4G decoding
     - Enabled
     - Required for Resizable BAR support and to allow the GPU to address more
       than 4 GB of BAR space. Must be enabled before enabling Resizable BAR.

   * - Resizable BAR (ReBAR)
     - Enabled
     - Allows the CPU to access the full GPU VRAM at once, reducing PCIe
       transfer overhead for compute workloads.

.. _rdna3-grub-settings:

GRUB settings
=============

Edit ``/etc/default/grub`` and append the recommended parameters to
``GRUB_CMDLINE_LINUX``.

``iommu=pt``
   Enables IOMMU pass-through mode. In this mode the GPU does not require DMA
   translation for every memory access, which reduces overhead for compute
   workloads. On systems with AMD CPUs, add:

   .. code-block:: text

      iommu=pt

   On systems with Intel CPUs, add:

   .. code-block:: text

      intel_iommu=on iommu=pt

After editing the file, update GRUB and reboot:

.. code-block:: shell

   sudo grub2-mkconfig -o /boot/grub2/grub.cfg
   sudo reboot

On Debian-based systems, use ``update-grub`` instead of ``grub2-mkconfig``.

.. _rdna3-os-settings:

.. _rdna3-rocm-smi:

ROCm SMI tuning
===============

Use ``rocm-smi`` to inspect and adjust GPU operating parameters from the
command line. The commands below are scoped to compute workloads.

Checking GPU status
-------------------

Verify that ROCm recognizes the GPU and confirm its device ID and firmware
version:

.. code-block:: shell

   rocm-smi --showhw

Performance level
-----------------

The performance level controls how aggressively the driver manages GPU clocks.
For sustained compute workloads, set the performance level to ``high`` to keep
clocks at their maximum frequency:

.. code-block:: shell

   rocm-smi --setperflevel high

To enable manual clock control:

.. code-block:: shell

   rocm-smi --setperflevel manual

To query the current performance level:

.. code-block:: shell

   rocm-smi --showperflevel

To revert all settings to driver defaults:

.. code-block:: shell

   rocm-smi --reset

Power cap
---------

RDNA3 GPUs have a configurable power cap. Raising the cap can sustain higher
boost clocks during long compute jobs. Query the current and maximum allowed
power limit:

.. code-block:: shell

   rocm-smi --showpower

Set the power cap in watts (replace ``<watts>`` with your target value, up to
the hardware maximum):

.. code-block:: shell

   rocm-smi --setpoweroverdrive <watts>

.. note::

   The valid power cap range varies by card. Use ``rocm-smi --showpower`` to
   query the current limit and hardware maximum on your system before applying
   changes.

Clock frequencies
-----------------

When the performance level is set to ``manual``, you can pin the GPU compute
clock to a specific frequency. Query the available clock levels:

.. code-block:: shell

   rocm-smi --showclkfreq

Performance determinism
-----------------------

Performance determinism enforces a user-defined maximum GFXCLK frequency across
all GPUs in a system. This prevents clock frequency variation between GPUs due
to silicon variation, thermal conditions, and voltage-frequency curve
differences, which can cause synchronization stalls and unpredictable latency in
multi-GPU workloads.

RDNA3 GPUs have full support for performance determinism.

To enable performance determinism with the GFXCLK capped at a specific
frequency (in MHz):

.. code-block:: shell

   amd-smi set --perf-determinism <MHz>

To disable performance determinism and return to automatic clock management:

.. code-block:: shell

   amd-smi reset --perf-determinism

To query the current performance level and confirm determinism mode is active:

.. code-block:: shell

   amd-smi metric --perf-level

.. note::

   Performance determinism sets the GPU performance level to ``DETERMINISM``
   and requires the ``amd-smi`` tool. For more detail on how the feature works
   and the full support matrix across GPU families, see
   :doc:`Performance levels and performance determinism </conceptual/perf-determinism>`
   in the AMD SMI documentation.

.. _rdna3-counter-collection:

Counter collection
==================

RDNA3 GPUs (gfx11 architecture) require a stable power state for hardware
counter collection with ROCprofiler. Without this, counter values may be
inaccurate or unavailable.

Before profiling, set the GPU to a stable power state:

.. code-block:: shell

   sudo amd-smi set -g <N> -l stable_std

After profiling, restore automatic power management:

.. code-block:: shell

   sudo amd-smi set -g <N> -l auto

Replace ``<N>`` with the device index of your GPU. Use ``amd-smi monitor`` or
``rocm-smi`` to list device indices. To confirm the GPU architecture, run:

.. code-block:: shell

   amd-smi static --asic -g <N>

and check the ``TARGET_GRAPHICS_VERSION`` field.

.. _rdna3-amdgpu-params:

``amdgpu`` module parameters
=============================

The ``amdgpu`` kernel module exposes parameters that can affect compute
performance and stability. Parameters are set by adding a configuration file
under ``/etc/modprobe.d/``.

To view all available parameters and their current values:

.. code-block:: shell

   systool -m amdgpu -v | grep -E "^\s+\w+\s+="

The following parameters are relevant to compute workloads. Default values
were verified on RDNA3 (``gfx1100``-series, ``amdgpu`` 6.16.13).

.. list-table::
   :header-rows: 1

   * - Parameter
     - Default (RDNA3)
     - Notes

   * - ``ppfeaturemask``
     - ``0xfff7bfff``
     - Bitmask controlling which power management features are active. The
       default reflects AMD's recommended configuration for RDNA3.

   * - ``sched_policy``
     - ``0``
     - GPU scheduling policy. ``0`` uses the hardware scheduler, which is
       recommended for compute workloads.

   * - ``cwsr_enable``
     - ``1``
     - Enables compute wave save/restore, allowing the driver to preempt
       compute wavefronts. Keep enabled for compute workloads.

   * - ``no_system_mem_limit``
     - ``N``
     - When set to ``Y``, removes the driver limit on system memory that can
       be mapped for GPU use. May benefit workloads that exceed the default
       memory allocation limit.

   * - ``num_kcq``
     - ``-1`` (auto)
     - Number of kernel compute queues. ``-1`` uses the driver default.

   * - ``queue_preemption_timeout_ms``
     - ``9000``
     - Time in milliseconds before the driver forcibly preempts a hung compute
       queue.

XNACK and SRAM ECC
------------------

XNACK (unified virtual memory retry support) and SRAM ECC are not supported on
RDNA3 GPUs (gfx1100, gfx1101, gfx1102). Do not enable these features when
configuring the ``amdgpu`` module. They are enabled by default only on
compatible data center GPUs.
