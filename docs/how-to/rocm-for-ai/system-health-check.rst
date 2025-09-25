.. meta::
   :description: System health checks with RVS, RCCL tests, BabelStream, and TransferBench to validate AMD hardware performance running AI workloads.
   :keywords: gpu, accelerator, system, health, validation, bench, perf, performance, rvs, rccl, babel, mi300x, mi325x, flops, bandwidth, rbt, training, inference

.. _rocm-for-ai-system-health-bench:

************************
System health benchmarks
************************

Before running AI workloads, it is important to validate that your AMD hardware is configured correctly and is performing optimally. This topic outlines several system health benchmarks you can use to test key aspects like GPU compute capabilities (FLOPS), memory bandwidth, and interconnect performance. Many of these tests are part of the ROCm Validation Suite (RVS).

ROCm Validation Suite (RVS) tests
=================================

RVS provides a collection of tests, benchmarks, and qualification tools, each
targeting a specific subsystem of the system under test. It includes tests for
GPU stress and memory bandwidth.

.. _healthcheck-install-rvs:

Install ROCm Validation Suite
-----------------------------

To get started, install RVS. For example, on an Ubuntu system with ROCm already
installed, run the following command:

.. code-block:: shell

   sudo apt update
   sudo apt install rocm-validation-suite

See the `ROCm Validation Suite installation instructions <https://rocm.docs.amd.com/projects/ROCmValidationSuite/en/latest/install/installation.html>`_,
and `System validation tests <https://instinct.docs.amd.com/projects/system-acceptance/en/latest/common/system-validation.html>`_
in the Instinct documentation for more detailed instructions.

Benchmark, stress, and qualification tests
------------------------------------------

The GPU stress test runs various GEMM computations as workloads to stress the GPU FLOPS performance and check whether it
meets the configured target GFLOPS.

Run the benchmark, stress, and qualification tests included with RVS. See the `Benchmark, stress, qualification
<https://instinct.docs.amd.com/projects/system-acceptance/en/latest/common/system-validation.html#benchmark-stress-qualification>`_
section of the Instinct documentation for usage instructions.

BabelStream test
----------------

BabelStream is a synthetic GPU benchmark based on the STREAM benchmark for
CPUs, measuring memory transfer rates to and from global device memory.
BabelStream tests are included with the RVS package as part of the `BABEL module
<https://rocm.docs.amd.com/projects/ROCmValidationSuite/en/latest/conceptual/rvs-modules.html#babel-benchmark-test-babel-module>`_.

For more information, see `Performance benchmarking
<https://instinct.docs.amd.com/projects/system-acceptance/en/latest/common/system-validation.html#babelstream>`_
in the Instinct documentation.

RCCL tests
==========

The ROCm Communication Collectives Library (RCCL) enables efficient multi-GPU
communication. The `<https://github.com/ROCm/rccl-tests>`__ suite benchmarks
the performance and verifies the correctness of these collective operations.
This helps ensure optimal scaling for multi-accelerator tasks.

1. To get started, build RCCL-tests using the official instructions in the README at
   `<https://github.com/ROCm/rccl-tests?tab=readme-ov-file#build>`__ or use the
   following commands:

   .. code-block:: shell

      git clone https://github.com/ROCm/rccl-tests.git
      cd rccl-tests
      make

2. Run the suggested RCCL tests -- see `RCCL benchmarking
   <https://instinct.docs.amd.com/projects/system-acceptance/en/latest/mi300x/performance-bench.html#rccl-benchmarking-results>`_
   in the Instinct performance benchmarking documentation for instructions.

TransferBench test
==================

TransferBench is a standalone utility for benchmarking simultaneous data
transfer performance between various devices in the system, including
CPU-to-GPU and GPU-to-GPU (peer-to-peer). This helps identify potential
bottlenecks in data movement between the host system and the GPUs, or between
GPUs, which can impact end-to-end latency.

.. _healthcheck-install-transferbench:

1. To get started, use the instructions in the `TransferBench documentation
   <https://rocm.docs.amd.com/projects/TransferBench/en/latest/install/install.html#install-transferbench>`_
   or use the following commands:

   .. code:: shell

      git clone https://github.com/ROCm/TransferBench.git
      cd TransferBench
      CC=hipcc make

2. Run the suggested TransferBench tests -- see `TransferBench benchmarking
   <https://instinct.docs.amd.com/projects/system-acceptance/en/latest/mi300x/performance-bench.html#transferbench-benchmarking-results>`_
   in the Instinct performance benchmarking documentation for instructions.
