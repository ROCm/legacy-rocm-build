.. meta::
   :description: System setup and validation steps for AI training and inference on ROCm
   :keywords: AMD Instinct, ROCm, GPU, AI, training, inference, benchmarking, performance, validation

*************************************
System setup for AI workloads on ROCm
*************************************

Before you begin training or inference on AMD Instinct™ accelerators, complete
the following system setup and validation steps to ensure optimal performance.

Prerequisite system validation
==============================

First, confirm that your system meets all software and hardware prerequisites.

- See :doc:`prerequisite-system-validation`.

Docker images for AMD Instinct accelerators
===========================================

AMD provides prebuilt Docker images for AMD Instinct™ MI300X and MI325X
accelerators. These images include ROCm-enabled deep learning frameworks and
essential software components.

- Supports both single-node and multi-node configurations
- Ready for training and inference workloads out of the box

Multi-node training
-------------------

For instructions on enabling multi-node training:

- See :doc:`multi-node-setup`.

System optimization and validation
==================================

Before running workloads, verify that the system is configured correctly and
operating at peak efficiency. Recommended steps include:

- Disabling NUMA auto-balancing
- Running system benchmarks to validate hardware performance

For details on running system health checks:

- See :doc:`system-health-check`.
