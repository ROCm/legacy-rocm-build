.. meta::
   :description: 
   :keywords: system, health, 

************************
System health benchmarks
************************

System Health Benchmarks are prerequisite to running inference on AMD hardware to test the optimal performance of the hardware.

Benchmark, stress, and qualification test
=========================================

The GPU stress test runs various GEMM computations as workloads to stress the GPU FLOPS performance and check whether it
meets the configured target GFLOPS.

To get started, install the ROCm Validation Suite (RVS).

Run the benchmark, stress, and qualification tests included with RVS. See `Benchmark, stress, qualification
<https://instinct.docs.amd.com/projects/system-acceptance/en/latest/mi300x/system-validation.html#benchmark-stress-qualification>`_
for more information.

For more information, see `System validation tests
<https://instinct.docs.amd.com/projects/system-acceptance/en/latest/mi300x/system-validation.html>`_ in the Instinct
documentation.

RCCL test
=========

These tests check both the performance and the correctness of RCCL operations. For installations, follow the RCCL tests
instructions at `Performance benchmarking <https://instinct.docs.amd.com/projects/system-acceptance/en/latest/mi300x/performance-bench.html#rccl-benchmarking-results>`_
in the Instinct documentation.

BabelStream test
================

BabelStream is a synthetic GPU benchmark based on the STREAM benchmark for CPUs, measuring memory transfer rates to and
from global device memory. For details, see `Performance benchmarking <https://instinct.docs.amd.com/projects/system-acceptance/en/latest/mi300x/performance-bench.html#babelstream-benchmarking-results>`_
in the Instinct documentation.
We will run babelstream tests using RVS package.

TransferBench test
==================

TransferBench is a utility to benchmark simultaneous transfers between user-specified devices (CPUs or GPUs). For
detailed usage and installation, follow `Performance benchmarking
<https://instinct.docs.amd.com/projects/system-acceptance/en/latest/mi300x/performance-bench.html#transferbench-benchmarking-results>`_
in the Instinct documentation.

TransferBench tests are not part of RVS.
