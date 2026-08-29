.. meta::
   :description: AMD ROCm Extras - list of tools and test suites
   :keywords: component, lib, rbt, bw, rvs, validate, test, tb, transfer, bench, system, communication, suite

*********************
ROCm Extra components
*********************

ROCm Extra components are supplementary tools for benchmarking, validating, and managing ROCm
deployments. These tools are not required for GPU application development but are useful
for verifying hardware health, measuring system performance, and managing GPU fleets.

.. * :doc:`ROCm Bandwidth Test <rocm_bandwidth_test:index>` (RBT) -- Measures memory
..   bandwidth between host and device memory, and between GPU devices. Useful for
..   verifying that PCIe and Infinity Fabric links are operating at expected
..   bandwidth.

* `ROCm Validation Suite <https://rocm.docs.amd.com/projects/ROCmValidationSuite/en/docs-1.5/index.html>`_ (RVS) -- A suite of tests for validating ROCm installations
  and AMD GPU hardware. Includes tests for GPU functionality, memory, power behavior, and
  peer-to-peer communication, helping diagnose installation issues and hardware faults.

  * `TransferBench <https://rocm.docs.amd.com/projects/TransferBench/en/latest/index.html>`_ -- A utility for benchmarking simultaneous memory transfers between user-specified devices (CPUs, GPUs, and NICs). This component is part of the ROCmValidationSuite (RVS) and is installed with it.

* More coming soon.
