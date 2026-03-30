.. meta::
   :description: System optimization of AMD RDNA3.5 Ryzen APUs (gfx1150/gfx1151/gfx1152) systems. Learn about VRAM, GTT, TTM tuning, shared memory configuration, and required Linux kernel support.
   :keywords: AMD RDNA3.5, Ryzen APU, gfx1150, gfx1151, gfx1152, ROCm, VRAM, GTT, GART, TTM, GPUVM, system optimization

:orphan:

.. _strix-halo-optimization:

==========================================
AMD RDNA3.5 system optimization
==========================================

This topic describes how to optimize systems powered by AMD Ryzen APUs with
RDNA3.5 architecture. These APUs combine high-performance CPU cores with
integrated RDNA3.5 graphics, and support LPDDR5X-8000 or DDR5 memory, making
them particularly well-suited for:

* LLM development and inference systems
* High-performance workstations
* Virtualization hosts running multiple VMs
* GPU compute and parallel processing
* Gaming systems
* Home servers and AI development platforms

.. _memory-settings:

Memory settings
===============

AMD Ryzen APUs with RDNA3.5 architecture (gfx1150, gfx1151, and gfx1152 LLVM
target) memory access is handled through GPU Virtual Memory (GPUVM), which
provides per-process GPU virtual address spaces (VMIDs) rather than a separate,
discrete VRAM pool.

As a result, memory on RDNA3.5 APUs is mapped rather than physically
partitioned. The terms Graphics Address Remapping Table (GART) and Graphics
Translation Table (GTT) describe limits on how much system memory can be mapped
into GPU address spaces and who can use it, rather than distinct types of
physical memory.

* **GART**

  Defines the amount of platform address space (system RAM or Memory-Mapped I/O)
  that can be mapped into the GPU virtual address space used by the kernel driver.
  On systems with physically shared CPU and GPU memory, such as RDNA3.5-based
  systems, this mapped system memory effectively serves as VRAM for the GPU.
  GART is typically kept relatively small to limit GPU page-table size and is
  mainly used for driver-internal operations.

* **GTT**

  Defines the amount of system RAM that can be mapped into GPU virtual address
  spaces for user processes. This is the memory pool used by applications such
  as PyTorch and other AI/compute workloads. GTT allocations are dynamic and
  not permanently reserved, allowing the operating system to reclaim memory when
  the GPU isn't actively using it. By default, the GTT limit is set to
  approximately 50 percent of total system RAM.

.. note::

  On systems with physically shared CPU and GPU memory, such as RDNA3.5-based
  systems, several terms are often used interchangeably in firmware menus,
  documentation, and community discussions:

  * VRAM
  * Carve-out
  * GART
  * Dedicated GPU memory
  * Firmware-reserved GPU memory

  In this topic, VRAM will be used going forward.

You can adjust the amount of memory available to the GPU by:

* Increasing the VRAM in BIOS, or

* Reducing the configured GTT size to be smaller than the reserved amount.

If the GTT size is larger than the VRAM, the AMD GPU driver performs VRAM
allocations using GTT (GTT-backed allocations), as described in the
`torvalds/linux@759e764 <https://github.com/torvalds/linux/commit/759e764f7d587283b4e0b01ff930faca64370e59>`_
GitHub commit.

Because memory is physically shared, there is no performance distinction
similar to discrete GPUs where dedicated VRAM is significantly faster than
system memory. Firmware may optionally reserve some memory exclusively for GPU
use, but this provides little benefit for most workloads while permanently
Because memory is physically shared, there's no performance distinction
like that of discrete GPUs where dedicated VRAM is significantly faster than
system memory. Firmware may optionally reserve some memory exclusively for GPU
use, but this provides little benefit for most workloads while permanently
reducing available system memory.

For this reason, AI frameworks work more efficiently with GTT-backed allocations. GTT
allows large, flexible mappings without permanently reserving memory, resulting
in better overall system utilization on unified memory systems.

Configuring shared memory limits on Linux
-----------------------------------------

The maximum amount of shared GPU-accessible memory can be increased by changing
the kernel **Translation Table Manager (TTM)** page limit. This setting controls
how many system memory pages can be mapped for GPU use and is exposed at:

::

   /sys/module/ttm/parameters/pages_limit

The value is expressed in **pages**, and not bytes or gigabytes (GB).

.. note::

   It's recommended to keep the dedicated VRAM reservation in BIOS small
   (for example, 0.5 GB) and increasing the shared (TTM/GTT) limit instead.

A helper utility is available to simplify configuration.

1. Install ``pipx``:

   ::

      sudo apt install pipx
      pipx ensurepath

2. Install the AMD debug tools:

   ::

      pipx install amd-debug-tools

3. Query the current shared memory configuration:

   ::

      amd-ttm

4. Set the usable shared memory (in GB):

   ::

      amd-ttm --set <NUM>

5. Reboot for changes to take effect.

.. note::

  The amd-ttm convert the pages to GB to help the users.

Example with output
^^^^^^^^^^^^^^^^^^^

Check the current settings:

::

   amd-ttm
   💻 Current TTM pages limit: 16469033 pages (62.82 GB)
   💻 Total system memory: 125.65 GB

Change the usable shared memory:

::

   ❯ amd-ttm --set 100
   🐧 Successfully set TTM pages limit to 26214400 pages (100.00 GB)
   🐧 Configuration written to /etc/modprobe.d/ttm.conf
   ○ NOTE: You need to reboot for changes to take effect.
   Would you like to reboot the system now? (y/n): y

Revert to kernel defaults:

::

   ❯ amd-ttm --clear
  🐧 Configuration /etc/modprobe.d/ttm.conf removed
   Would you like to reboot the system now? (y/n): y

.. _operating-system-support:

Operating system support
========================

The ROCm compatibility tables can be found at the following links:

- `System requirements (Linux) <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/reference/system-requirements.html>`_
- `System requirements (Windows) <https://rocm.docs.amd.com/projects/install-on-windows/en/latest/reference/system-requirements.html>`_

AMD Ryzen AI Max series APUs (gfx1151) have additional kernel version
requirements, as described in the  following section.

Required kernel version
-----------------------

Support for AMD Ryzen AI Max series APUs requires specific Linux kernel fixes
that update internal limits in the AMD KFD driver to ensure correct queue
creation and memory availability checks. Without these updates, GPU compute
workloads might fail to initialize or exhibit unpredictable behavior.

The following commits are required for AMD Ryzen AI Max series support:

- `gregkh/linux@7f26af7 <https://github.com/gregkh/linux/commit/7f26af7bf9b76c2c2a1a761aab5803e52be21eea>`_
- `gregkh/linux@7445db6 <https://github.com/gregkh/linux/commit/7445db6a7d5a0242d8214582b480600b266cba9e>`_

These patches are available in the following minimum kernel versions:

- Ubuntu 24.04 Hardware Enablement (HWE): ``6.17.0-19.19~24.04.2`` or later
- Ubuntu 24.04 Original Equipment Manufacturer (OEM): ``6.14.0-1018`` or later
- All other distributions: Linux kernel ``6.18.4`` or later

The table below reflects compatibility for AMD-released pre-built ROCm
binaries only. Distributions that ship native ROCm packaging might
provide different support levels.

.. list-table::
   :header-rows: 0
   :widths: 10 90

   * - ❌
     - Unsupported combination
   * - ⚠️
     - Unstable/experimental combination
   * - ✅
     - Stable and supported combination

.. list-table::
   :header-rows: 1
   :widths: 20 50 15 15

   * - ROCm Release
     - | Ubuntu 24.04 HWE (>= 6.17.0-19.19~24.04.2),
       | Ubuntu 24.04 OEM (>= 6.14.0-1018) or
       | Ubuntu 26.04 Generic
     - Other distributions >= 6.18.4
     - Other distributions < 6.18.4

   * - 7.11.0 or newer
     - ✅
     - ✅
     - ⚠️

   * - 7.10.0 or 7.9.0
     - ❌
     - ❌
     - ⚠️

   * - 7.2.1 or newer
     - ✅
     - ✅
     - ⚠️

   * - 7.2.0
     - ✅
     - ✅
     - ❌

   * - 7.1.x
     - ❌
     - ❌
     - ⚠️

   * - 6.4.x
     - ❌
     - ❌
     - ⚠️

.. note::

  Ubuntu 24.04 HWE kernels earlier than ``6.17.0-19.19~24.04.2`` and Ubuntu
  24.04 OEM kernels earlier than ``6.14.0-1018`` are not supported for
  RDNA3.5 APUs.
  
  The following distributions include the required fixes in their native
  packaging, independent of AMD pre-built binaries: 

  - Fedora 43
  - Ubuntu 26.04
  - Arch Linux 2026.02.01
