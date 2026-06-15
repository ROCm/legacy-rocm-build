.. meta::
   :description: Performance benchmark tools applicable to AMD RDNA GPUs running ROCm workloads.
   :keywords: AMD, RDNA, RDNA3, RDNA4, Radeon, ROCm, benchmark, performance, TransferBench, rocBLAS, BabelStream

.. _rdna-benchmarks:

================
RDNA benchmarks
================

After the :doc:`health checks <rdna-health-checks>` and
:doc:`validation <rdna-validation>` pass, use these tools to measure the
performance of an AMD RDNA GPU.

.. note::

   This page is in progress. AMD has not published RDNA-specific pass/fail
   thresholds for these benchmarks. Until validated thresholds are available,
   use the tools below to measure performance and compare against your card's
   published specifications, not against an acceptance bar.

The following tools run on RDNA GPUs. Each links to its own documentation for
installation and usage.

Compute throughput
==================

``rocblas-bench`` measures GEMM (matrix multiply) throughput. It is included
with the rocBLAS library and dispatches kernels for the installed GPU.

See the `rocBLAS documentation
<https://rocm.docs.amd.com/projects/rocBLAS/en/latest/>`_.

.. note::

   RDNA-specific GEMM throughput thresholds have not been published. Note that
   the data types and target values used in the AMD data center GPU acceptance
   guide are specific to data center accelerators and do not apply to RDNA
   cards.

Memory bandwidth
================

BabelStream measures sustained GPU memory bandwidth. Build it with the HIP
backend to target RDNA GPUs.

See the `BabelStream repository <https://github.com/UoB-HPC/BabelStream>`_.

.. note::

   RDNA-specific memory bandwidth thresholds have not been published. Compare
   results against your card's published memory bandwidth specification.

Data transfer
=============

TransferBench measures transfer bandwidth between CPUs and GPUs. It is useful
for confirming host-to-device and device-to-host PCIe performance.

See the `TransferBench repository <https://github.com/ROCm/TransferBench>`_.

.. note::

   RDNA-specific transfer thresholds have not been published. Compare results
   against your platform's PCIe generation and width.

Open data dependencies
======================

Validated, AMD-published pass/fail thresholds for RDNA3 and RDNA4 are required
before this page can present acceptance criteria. The benchmark commands and
expected values in the
`AMD data center GPU customer acceptance guide
<https://instinct.docs.amd.com/projects/system-acceptance/en/latest/>`_ are
specific to data center accelerators and are not transferable to RDNA cards.
