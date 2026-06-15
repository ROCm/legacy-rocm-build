.. meta::
   :description: Basic health checks to verify an AMD RDNA GPU is detected and operating correctly before running ROCm compute workloads.
   :keywords: AMD, RDNA, RDNA3, RDNA4, Radeon, ROCm, health check, acceptance, validation, amd-smi, lspci, throttle, PCIe

.. _rdna-health-checks:

==================
RDNA health checks
==================

Use these checks to confirm that a single AMD RDNA GPU is detected and operating
correctly before running ROCm compute workloads. Each check lists the command,
example output, and pass/fail criteria.

These checks apply to discrete RDNA3 (``gfx1100``, ``gfx1101``, ``gfx1102``) and
RDNA4 (``gfx1200``, ``gfx1201``) GPUs. Run them after installing the ``amdgpu``
driver and ROCm, and after applying the settings in the corresponding system
optimization page (:doc:`RDNA3 <rdna3>`, :doc:`RDNA4 <rdna4>`).

Prerequisites
=============

- A supported Linux distribution and ROCm version. See the
  `ROCm system requirements (Linux) <https://rocm.docs.amd.com/projects/install-on-linux/en/latest/reference/system-requirements.html>`_.
- The ``amdgpu`` driver and ROCm installed.
- ``amd-smi`` available on the system path. It is included with ROCm.

Check the operating system
==========================

Verify the distribution is one of the supported versions in the ROCm
compatibility matrix:

.. code-block:: shell

   cat /etc/os-release

**Pass:** The distribution and version are listed in the
`ROCm compatibility matrix <https://rocm.docs.amd.com/en/latest/compatibility/compatibility-matrix.html>`_.

**Fail:** The distribution is not listed. Install a supported distribution
before continuing.

Check GPU presence
==================

Confirm the GPU is present on the PCIe bus. AMD GPUs use PCI vendor ID
``1002``:

.. code-block:: shell

   lspci -d 1002: | grep -iE "VGA|Display|Processing accelerators"

**Pass:** Your RDNA GPU is listed.

**Fail:** The GPU is not listed. Reseat the card, confirm it has power, and
verify it is enabled in the system BIOS.

To confirm ROCm recognizes the GPU and report its target architecture:

.. code-block:: shell

   amd-smi static --asic

Check the ``TARGET_GRAPHICS_VERSION`` field. It reports ``gfx1100`` through
``gfx1102`` for RDNA3 and ``gfx1200`` or ``gfx1201`` for RDNA4.

.. note::

   Unlike AMD data center accelerators, which have a single PCIe device ID per
   model, RDNA cards span many board SKUs with different device IDs. Detect RDNA
   GPUs by vendor ID (``1002``) and confirm the target architecture with
   ``amd-smi static --asic`` rather than matching a specific device ID.

Check the PCIe link speed and width
===================================

Confirm the GPU is running at its full PCIe link speed and width:

.. code-block:: shell

   amd-smi metric --pcie

**Pass:** The current link speed and width match the GPU's maximum supported
values.

**Fail:** The link is training at a reduced speed or width. Check that the card
is seated in a slot wired for its full lane count and that
:ref:`Above 4G decoding and Resizable BAR <rdna3-bios-settings>` are enabled in
the BIOS.

Check for driver errors
=======================

Check the kernel log for ``amdgpu`` driver errors:

.. code-block:: shell

   sudo dmesg -T | grep amdgpu | grep -i error

**Pass:** No errors are reported.

**Fail:** Errors are present. Investigate the reported messages and reinstall
the ``amdgpu`` driver if necessary.

Check idle metrics
==================

With no compute workload running, check temperature, power, and clocks:

.. code-block:: shell

   amd-smi metric --temperature --power --clock

When the GPU is idle, utilization should be near zero, clocks should be low, and
temperature should be well below the GPU's thermal limit.

.. note::

   Specific idle temperature, power, and clock ranges have not been validated
   per RDNA model. Compare against your card's published specifications until
   validated ranges are added here.

Check the throttle status
=========================

On RDNA GPUs, ``amd-smi metric --power`` reports the current throttle status.
The ``throttle_status`` field shows whether the GPU is throttling right now, and
``indep_throttle_status`` reports per-reason bit flags such as ``PROCHOT_GFX``,
``TDC_GFX``, and ``TEMP_MEM``:

.. code-block:: shell

   amd-smi metric --power

**Pass:** ``throttle_status`` reports unthrottled when the GPU is idle.

**Fail:** The GPU reports active throttling at idle. Check airflow, ambient
temperature, and the power connection.

.. note::

   The time-based violations API (``amd-smi metric --violation``) is not
   available on RDNA GPUs and returns N/A. Use ``throttle_status`` instead. For
   details, see
   `GPU violations <https://rocm.docs.amd.com/projects/amdsmi/en/latest/conceptual/gpu-violations.html>`_
   in the AMD SMI documentation.

Next steps
==========

After the health checks pass, tune the GPU for your workload using the
:doc:`RDNA3 <rdna3>` or :doc:`RDNA4 <rdna4>` system optimization page.

Stress-test qualification and performance benchmark validation with pass/fail
criteria are in progress:

- **Stress-test qualification (RVS):** ROCm Validation Suite configurations are
  available for RDNA3 (``gst``, ``iet``, ``mem``, ``pebb``, ``peqt``, ``pbqt``,
  and memory bandwidth). RVS configurations are not yet available for RDNA4.
- **Performance benchmarks:** RDNA-specific pass/fail thresholds for benchmark
  tools have not yet been published.
