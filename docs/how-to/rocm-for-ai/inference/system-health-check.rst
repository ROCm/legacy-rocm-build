.. meta::
   :description: 
   :keywords: system, health,

************************
System health benchmarks
************************

Before running inference, use the following system health benchmarks to validate the optimal performance
of your AMD hardware.

Benchmark, stress, and qualification tests
==========================================

The GPU stress test runs various GEMM computations as workloads to stress the GPU FLOPS performance and check whether it
meets the configured target GFLOPS.

.. _inference-healthcheck-install-rvs:

Install ROCm Validation Suite (RVS)
-----------------------------------

To get started, install the ROCm Validation Suite (RVS). For example, on an Ubuntu system with ROCm
installed, run the following command:

.. code-block::

   sudo apt install rocm-validation-suite

See the `ROCm Validation Suite installation instructions <https://rocm.docs.amd.com/projects/ROCmValidationSuite/en/latest/install/installation.html>`_
and `System validation tests <https://instinct.docs.amd.com/projects/system-acceptance/en/latest/mi300x/system-validation.html#system-validation-tests>`_
in the Instinct documentation for more detailed instructions.

Run the tests
-------------

Run the benchmark, stress, and qualification tests included with RVS. See `Benchmark, stress, qualification
<https://instinct.docs.amd.com/projects/system-acceptance/en/latest/mi300x/system-validation.html#benchmark-stress-qualification>`_
for more information.

For more information, see `System validation tests
<https://instinct.docs.amd.com/projects/system-acceptance/en/latest/mi300x/system-validation.html>`_ in the Instinct
documentation.

RCCL tests
==========

RCCL provides a test suite to test and benchmark performance -- these tests check both the performance and the correctness of RCCL operations.
See `<https://github.com/ROCm/rccl-tests>`__ for more information.

Build and run the tests.

For installations, follow the RCCL tests instructions at `Performance benchmarking
<https://instinct.docs.amd.com/projects/system-acceptance/en/latest/mi300x/performance-bench.html#rccl-benchmarking-results>`_
in the Instinct documentation.

BabelStream test
================

BabelStream is a synthetic GPU benchmark based on the STREAM benchmark for CPUs, measuring memory
transfer rates to and from global device memory.

BabelStream tests are included with the :ref:`RVS package <inference-healthcheck-install-rvs>` as part of the `BABEL module
<https://rocm.docs.amd.com/projects/ROCmValidationSuite/en/latest/conceptual/rvs-modules.html#babel-benchmark-test-babel-module>`_.

For details, see `Performance benchmarking
<https://instinct.docs.amd.com/projects/system-acceptance/en/latest/mi300x/performance-bench.html#babelstream-benchmarking-results>`_
in the Instinct documentation.

TransferBench test
==================

TransferBench is a utility to benchmark simultaneous transfers between user-specified devices (CPUs
and GPUs).

.. _inference-healthcheck-install-transferbench:

Install TransferBench
---------------------

.. code:: shell

   git clone https://github.com/ROCm/TransferBench.git
   cd TransferBench
   CC=hipcc make

For installation and usage instructions, see the `Performance benchmarking
<https://instinct.docs.amd.com/projects/system-acceptance/en/latest/mi300x/performance-bench.html#transferbench-benchmarking-results>`_
section in the Instinct documentation.

TransferBench tests are not part of RVS.
