.. meta::
   :description: System acceptance and optimization for AMD data center, Radeon, and Ryzen GPUs running ROCm workloads, covering configuration, tuning, health checks, and validation.
   :keywords: AMD, data center GPU, Radeon, Ryzen, RDNA, CDNA, system acceptance, validation, health checks, optimization, tuning, ROCm

***************************
AMD GPU system acceptance
***************************

This guide provides a methodology for configuring, tuning, and validating AMD
GPUs for ROCm workloads. Step through the workflow for your hardware to establish
a known-good baseline: configure and tune the GPU, then validate that it operates
correctly.

Supported GPUs
==============

The following table lists the AMD GPU architectures covered by this guide. For
the complete list of supported cards and processors, see the
:doc:`ROCm compatibility matrix </compatibility/compatibility-matrix>`.

.. list-table::
   :header-rows: 1
   :widths: 20 25 30 25

   * - Architecture
     - LLVM target
     - Example GPUs
     - Guide

   * - CDNA4
     - gfx950
     - MI355X
     - `MI355X acceptance <https://instinct.docs.amd.com/projects/system-acceptance/en/latest/gpus/mi355x.html>`_

   * - CDNA4
     - gfx950
     - MI350X
     - `MI350X acceptance <https://instinct.docs.amd.com/projects/system-acceptance/en/latest/gpus/mi350x.html>`_

   * - CDNA3
     - gfx942
     - MI325X
     - `MI325X acceptance <https://instinct.docs.amd.com/projects/system-acceptance/en/latest/gpus/mi325x.html>`_

   * - CDNA3
     - gfx942
     - MI300X
     - `MI300X acceptance <https://instinct.docs.amd.com/projects/system-acceptance/en/latest/gpus/mi300x.html>`_

   * - RDNA4
     - gfx1200, gfx1201
     - Radeon RX 9070, RX 9060, Radeon AI PRO R9700
     - :doc:`RDNA4 system acceptance <rdna4>`

   * - RDNA3
     - gfx1100, gfx1101, gfx1102
     - Radeon RX 7900 XTX, RX 7800 XT, RX 7600, Radeon PRO W7900
     - :doc:`RDNA3 system acceptance <rdna3>`

   * - RDNA3.5
     - gfx1150, gfx1151, gfx1152
     - Ryzen AI Max and Ryzen AI 300 series APUs
     - :doc:`RDNA3.5 system acceptance <rdna3-5>`

   * - RDNA2
     - gfx1030
     - Radeon PRO W6800, V620
     - :doc:`RDNA2 system acceptance <rdna2>`

Acceptance validation
=====================

After configuring and tuning an AMD Radeon or Ryzen GPU, run the validation
steps in order. Each step lists pass/fail criteria.

* :doc:`RDNA health checks <rdna-health-checks>` -- Confirm the GPU is detected
  and operating correctly at idle.
* :doc:`RDNA validation <rdna-validation>` -- Run the ROCm Validation Suite
  stress, memory, and PCIe qualification tests.
* :doc:`RDNA benchmarks <rdna-benchmarks>` -- Measure compute, memory, and
  transfer performance.

For data center acceptance of AMD data center GPUs at single-node and cluster
scale, see the
`AMD data center GPU customer acceptance guide
<https://instinct.docs.amd.com/projects/system-acceptance/en/latest/index.html>`_.

Common system settings
======================

These topics apply across AMD hardware and workload types.

* :doc:`GPU isolation techniques <gpu-isolation>`
* :doc:`BAR access limits <bar-access-limits>`

.. note::

   Acceptance validation for AMD Radeon and Ryzen RDNA GPUs is being built out.
   Health checks and RDNA3 stress-test qualification (ROCm Validation Suite) are
   available now. RVS configurations are not yet available for RDNA4. AMD has not
   yet published RDNA-specific benchmark pass/fail thresholds.
