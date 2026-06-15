.. meta::
   :description: System optimization for AMD RDNA4 (gfx1200, gfx1201) GPUs running ROCm compute workloads on Linux.
   :keywords: AMD, RDNA4, gfx1200, gfx1201, ROCm, system optimization, BIOS, rocm-smi, amdgpu, compute, AI inference, HPC

.. _rdna4-system-optimization:

===========================
AMD RDNA4 system acceptance
===========================

This page describes system settings for AMD RDNA4 GPUs (``gfx1200``,
``gfx1201``) running ROCm compute workloads on Linux, such as AI inference and
HPC applications. Gaming-specific settings, display configuration, and SR-IOV
virtualization are out of scope.

.. list-table::
   :header-rows: 1
   :stub-columns: 1

   * - System guide
     - Architecture reference
   * - :ref:`System BIOS settings <rdna4-bios-settings>`
     - `AMD RDNA4 instruction set architecture <https://www.amd.com/content/dam/amd/en/documents/radeon-tech-docs/instruction-set-architectures/rdna4-instruction-set-architecture.pdf>`_

.. _rdna4-bios-settings:

System BIOS settings
====================

The following BIOS settings are recommended for RDNA4 GPUs running compute
workloads. Enable them before installing ROCm.

.. note::

   The Above 4G decoding and Resizable BAR rows have not yet been validated on
   a confirmed RDNA4 platform. Specific menu paths and recommended values will
   be added once testing is complete. The descriptions reflect the purpose of
   each setting.

.. list-table::
   :header-rows: 1

   * - BIOS setting
     - Recommended value
     - Notes

   * - CSM (Compatibility Support Module)
     - Disabled
     - RDNA4 GPUs require UEFI mode. CSM emulates legacy BIOS behavior and
       disables UEFI features including Resizable BAR (Smart Access Memory).
       See `UEFI-only support for AMD graphics cards
       <https://www.amd.com/en/resources/support-articles/faqs/GPU-N4XCSM.html>`_.

   * - Above 4G decoding
     - Enabled
     - Required for Resizable BAR support and to allow the GPU to address more
       than 4 GB of BAR space. Must be enabled before enabling Resizable BAR.

   * - Resizable BAR (ReBAR)
     - Enabled
     - Allows the CPU to access the full GPU VRAM at once, reducing PCIe
       transfer overhead for compute workloads.

.. _rdna4-grub-settings:

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

.. note::

   The benefit of ``iommu=pt`` on consumer desktop platforms running RDNA4
   has not yet been confirmed. This recommendation is consistent with MI300X
   guidance and should be verified on a representative RDNA4 system.

After editing the file, update GRUB and reboot:

.. code-block:: shell

   sudo grub2-mkconfig -o /boot/grub2/grub.cfg
   sudo reboot

On Debian-based systems, use ``update-grub`` instead of ``grub2-mkconfig``.

.. _rdna4-os-settings:

Operating system settings
=========================

For supported distributions and kernel versions, see the ROCm system
requirements:

- `System requirements (Linux) <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/reference/system-requirements.html>`_
- `System requirements (Microsoft Windows) <https://rocm.docs.amd.com/projects/install-on-windows/en/latest/reference/system-requirements.html>`_

No RDNA4-specific kernel version requirements beyond the standard ROCm support
matrix are known at this time. This section will be updated if any are
identified.

.. _rdna4-rocm-smi:

ROCm SMI tuning
===============

Use ``rocm-smi`` to inspect and adjust GPU operating parameters from the
command line. The commands below are scoped to compute workloads.

.. note::

   The specific performance levels, power limits, and clock ranges available on
   ``gfx1200`` and ``gfx1201`` have not been fully verified. Use
   ``rocm-smi --showperflevel``, ``rocm-smi --showpower``, and
   ``rocm-smi --showclkfreq`` to query the current state and valid ranges on
   your system before applying changes.

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

RDNA4 GPUs have a configurable power cap. Raising the cap can sustain higher
boost clocks during long compute jobs. Query the current and maximum allowed
power limit:

.. code-block:: shell

   rocm-smi --showpower

Set the power cap in watts (replace ``<watts>`` with your target value, up to
the hardware maximum):

.. code-block:: shell

   rocm-smi --setpoweroverdrive <watts>

.. note::

   The valid power cap range varies by card and requires confirmation on
   ``gfx1200`` and ``gfx1201``.

Clock frequencies
-----------------

When the performance level is set to ``manual``, you can pin the GPU compute
clock to a specific frequency. Query the available clock levels:

.. code-block:: shell

   rocm-smi --showclkfreq

.. _rdna4-counter-collection:

Counter collection
==================

RDNA4 GPUs (gfx12 architecture) require a stable power state for hardware
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

.. _rdna4-amdgpu-params:

``amdgpu`` module parameters
=============================

The ``amdgpu`` kernel module exposes parameters that can affect compute
performance and stability. Parameters are set by adding a configuration file
under ``/etc/modprobe.d/``.

To view all available parameters and their current values:

.. code-block:: shell

   systool -m amdgpu -v | grep -E "^\s+\w+\s+="

The following parameters are relevant to compute workloads. Default values
were verified on RDNA4 (``gfx1200``-series, ``amdgpu`` 6.12.12).

.. list-table::
   :header-rows: 1

   * - Parameter
     - Default (RDNA4)
     - Notes

   * - ``ppfeaturemask``
     - ``0xfff7bfff``
     - Bitmask controlling which power management features are active. The
       default reflects AMD's recommended configuration for RDNA4.

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
RDNA4 GPUs (gfx1200, gfx1201). Do not enable these features when configuring
the ``amdgpu`` module. They are enabled by default only on compatible data
center GPUs.