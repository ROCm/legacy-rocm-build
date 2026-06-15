.. meta::
   :description: System acceptance for AMD Radeon and Ryzen RDNA GPUs, covering configuration, tuning, health checks, and validation for ROCm workloads.
   :keywords: RDNA, Radeon, Ryzen, system acceptance, validation, health checks, tuning, AMD, ROCm

**************************************
AMD Radeon and Ryzen system acceptance
**************************************

This topic provides a methodology for configuring, tuning, and validating a
single AMD Radeon or Ryzen RDNA GPU for ROCm workloads. Step through the
workflow in sequence to establish a known-good baseline: configure and tune the
GPU, then validate that it operates correctly.

Configuration and tuning
========================

Apply the system and GPU settings for your architecture.

* :doc:`AMD RDNA4 system acceptance <rdna4>`
* :doc:`AMD RDNA3 system acceptance <rdna3>`
* :doc:`AMD RDNA3.5 system acceptance <rdna3-5>`
* :doc:`AMD RDNA2 system acceptance <rdna2>`

Acceptance validation
=====================

After configuring and tuning the GPU, run the validation steps in order. Each
step lists pass/fail criteria.

* :doc:`RDNA health checks <rdna-health-checks>` -- Confirm the GPU is detected
  and operating correctly at idle.
* :doc:`RDNA validation <rdna-validation>` -- Run the ROCm Validation Suite
  stress, memory, and PCIe qualification tests.
* :doc:`RDNA benchmarks <rdna-benchmarks>` -- Measure compute, memory, and
  transfer performance.

.. note::

   Acceptance validation for AMD Radeon and Ryzen RDNA GPUs is being built out.
   Health checks and RDNA3 stress-test qualification (ROCm Validation Suite) are
   available now. RVS configurations are not yet available for RDNA4. AMD has not
   yet published RDNA-specific benchmark pass/fail thresholds.
