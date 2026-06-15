.. meta::
   :description: Validate an AMD RDNA3 GPU with the ROCm Validation Suite (RVS), including compute stress, memory, and PCIe qualification tests.
   :keywords: AMD, RDNA3, Radeon, ROCm, RVS, ROCm Validation Suite, validation, acceptance, gst, iet, mem, peqt, pebb, gpup

.. _rdna-validation:

===================
RDNA validation
===================

After the :doc:`health checks <rdna-health-checks>` pass, use the ROCm
Validation Suite (``rvs``) to confirm an AMD RDNA3 GPU operates correctly under
load. RVS is a collection of modules, each targeting a specific subsystem of the
system under test.

.. note::

   RVS ships configuration files for RDNA3 (``gfx1100``, ``gfx1101``,
   ``gfx1102``). Configuration files are not yet available for RDNA4
   (``gfx1200``, ``gfx1201``). This page covers RDNA3 only.

This page covers single-card validation. The peer-to-peer module (``pbqt``)
requires two or more GPUs and is out of scope here.

Prerequisites
=============

Install RVS if it is not already present (Ubuntu):

.. code-block:: shell

   sudo apt install rocm-validation-suite

Add the ``rvs`` executable at ``/opt/rocm/bin`` to your path:

.. code-block:: shell

   export PATH=$PATH:/opt/rocm/bin

RVS reads configuration files with the ``-c`` option. The bundled configurations
are installed under ``/opt/rocm/share/rocm-validation-suite/conf/``. Define an
environment variable to shorten the commands below:

.. code-block:: shell

   export RVS_CONF=/opt/rocm/share/rocm-validation-suite/conf

For a full description of the configuration file format and keys, see the
`ROCm Validation Suite user guide
<https://github.com/ROCm/ROCmValidationSuite/blob/master/docs/ug1main.md#configuration-files>`_.

Confirm the GPU is detected
===========================

List the GPUs that RVS recognizes:

.. code-block:: shell

   rvs -g

**Pass:** Your RDNA3 GPU is listed with its PCIe location and device ID.

**Fail:** The GPU is not listed. Resolve detection before continuing; see the
:doc:`health checks <rdna-health-checks>`.

GPU properties (GPUP)
=====================

The GPUP module queries the static properties of the GPU, such as compute unit
count and clocks. Use it to confirm the device reports its expected
characteristics:

.. code-block:: shell

   rvs -c ${RVS_CONF}/gpup_single.conf

**Pass:** Properties are displayed with no errors.

**Fail:** The module reports errors or missing properties.

GPU stress test (GST)
=====================

The GST module runs a sustained GEMM workload to stress the compute engine. The
RDNA3 configuration runs a single-precision (``sgemm``) workload for 10 seconds:

.. code-block:: shell

   rvs -c ${RVS_CONF}/gst_single.conf

The configuration sets a ``target_stress`` of 10000 GFLOPS. RVS reports
``met: TRUE`` when the GPU sustains the target.

**Pass:** The log reports ``met: TRUE``.

**Fail:** The target is not met, or the module reports errors.

.. note::

   The ``target_stress`` value in the bundled RDNA3 configuration is the test's
   built-in target, not an AMD-published acceptance threshold for a specific
   card. Treat a ``met: TRUE`` result as confirmation the GPU runs the workload
   without errors rather than a performance qualification.

Input EDPp stress test (IET)
============================

The IET module drives the GPU toward a target power draw to validate the power
delivery subsystem. The RDNA3 configuration targets 127 W using a
double-precision (``dgemm``) workload:

.. code-block:: shell

   rvs -c ${RVS_CONF}/iet_stress.conf

**Pass:** The module completes with ``met: TRUE`` and no violations beyond the
configured tolerance.

**Fail:** The target power is not reached, or violations exceed the tolerance.

.. note::

   The 127 W target in the bundled configuration is the test's built-in value.
   Adjust it to your card's specification before treating the result as a power
   qualification.

Memory test (MEM)
=================

The MEM module runs a series of memory patterns to detect errors in GPU memory:

.. code-block:: shell

   rvs -c ${RVS_CONF}/mem.conf

**Pass:** All enabled subtests report ``TRUE`` (no memory errors).

**Fail:** Any subtest reports a memory error.

PCIe qualification (PEQT)
=========================

The PEQT module checks the PCIe capabilities of the GPU, including link speed
and width:

.. code-block:: shell

   rvs -c ${RVS_CONF}/peqt_single.conf

**Pass:** The PCIe check reports ``TRUE``.

**Fail:** The check reports ``FALSE``. Confirm the card is in a slot wired for
its full lane count and that the BIOS PCIe settings are correct.

PCIe bandwidth benchmark (PEBB)
===============================

The PEBB module measures host-to-device and device-to-host bandwidth over PCIe:

.. code-block:: shell

   rvs -c ${RVS_CONF}/pebb_single.conf

**Pass:** Bandwidth values are reported for the configured transfers.

**Fail:** No data is reported, or the module errors.

.. note::

   RDNA-specific PCIe bandwidth pass/fail thresholds have not been published.
   Compare the reported bandwidth against your platform's PCIe generation and
   width.

Next steps
==========

Performance benchmark validation with pass/fail thresholds is in progress. No
RDNA-specific benchmark thresholds have been published yet.
