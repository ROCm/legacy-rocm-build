.. meta::
   :description: Workload optimization guide for AMD Instinct MI300X and MI350X GPUs.
   :keywords: AMD, Instinct, MI300X, MI350X, MI325X, MI355X, CDNA3, CDNA4, gfx942, gfx950,
              HPC, tuning, ROCm, environment variable, performance, HIP, Triton,
              PyTorch TunableOp, vLLM, RCCL, MIOpen, GPU, resource utilization,
              FP4, FP6, FP8, MXFP4, MXFP6, MXFP8, sparsity, micro-scaling, HBM3E

*****************************************************
AMD Instinct MI300X / MI350X workload optimization
*****************************************************

This document provides guidelines for optimizing the performance of AMD
Instinct™ MI300X and MI350X GPUs, covering GPU kernel programming,
high-performance computing (HPC), and deep learning operations using PyTorch.
It addresses specific workloads such as
:ref:`model inference <mi3xx-vllm-optimization>`, offering strategies to
enhance efficiency.

Where the two GPU families differ in architecture, hardware capabilities, or
tuning recommendations, GPU-specific guidance is provided using tabs or notes.
Content that applies to both architectures is presented once to avoid redundancy.

.. _mi3xx-arch-comparison:

Architecture comparison
========================

The following tables compare the AMD Instinct MI300X (CDNA 3, gfx942) and
MI350X (CDNA 4, gfx950) architectures. Understanding these differences is
essential for effective workload tuning.

.. figure:: ../../../data/shared/mi300-node-level-arch.png

   MI300 Series / MI350 Series node-level architecture: 8 fully interconnected
   GPU OAM modules connected via AMD Infinity Fabric™ links in a fully connected
   topology. Both MI300X and MI350X share this 8-GPU system design.

Compute architecture
--------------------

.. list-table::
   :header-rows: 1
   :widths: 40 30 30

   * - Feature
     - MI300X (CDNA 3)
     - MI350X (CDNA 4)
   * - LLVM target
     - gfx942
     - gfx950
   * - Process (XCDs / IODs)
     - TSMC N5 / N6
     - TSMC N3P / N6
   * - I/O dies (IODs)
     - 4
     - 2 (direct connection ~14% faster)
   * - XCDs
     - 8
     - 8
   * - CUs per XCD (total / active)
     - 40 / 38
     - 36 / 32
   * - Total active CUs
     - 304
     - 256
   * - Stream processors
     - 19,456
     - 16,384
   * - Matrix Cores
     - 1,216
     - 1,024
   * - Max engine clock
     - 2,100 MHz
     - 2,200 MHz (MI350X) / 2,400 MHz (MI355X)
   * - LDS per CU
     - 64 KB, 128 bytes/clock read
     - 160 KB, 256 bytes/clock read, L1→LDS direct load
   * - L1 data cache
     - 32 KB, 128B lines, 64-way
     - 32 KB, 128B lines, 64-way
   * - L2 cache per XCD
     - 4 MB, 16-way, 16 channels
     - 4 MB, 16-way, 16 channels (+ coherency enhancements)
   * - Infinity Cache
     - 256 MB, 16-way
     - 256 MB, 16-way
   * - Max power
     - 750W (MI300X) / 1000W (MI325X)
     - 1000W (MI350X) / 1400W (MI355X)

Matrix Core throughput (FLOPS/clock/CU)
---------------------------------------

.. list-table::
   :header-rows: 1
   :widths: 36 22 22 20

   * - Data type
     - MI300X
     - MI350X
     - Change
   * - Vector FP64
     - 128
     - 128
     - Same
   * - Vector FP32
     - 256
     - 256
     - Same
   * - Matrix FP64
     - 256
     - 128
     - **0.5×**
   * - Matrix FP32
     - 256
     - 256
     - Same
   * - Matrix TF32
     - 1,024 (hardware)
     - N/A (software via BF16)
     - Moved to SW
   * - Matrix FP16 / BF16
     - 2,048
     - 4,096
     - **2×**
   * - Matrix FP8 / INT8
     - 4,096
     - 8,192
     - **2×**
   * - Matrix MXFP8
     - N/A
     - 8,192
     - New
   * - Matrix MXFP6
     - N/A
     - 16,384
     - New
   * - Matrix MXFP4
     - N/A
     - 16,384
     - New
   * - Sparsity (2:4)
     - FP16, BF16, FP8, INT8
     - FP16, BF16, FP8, INT8
     - Same
   * - Transcendental rate
     - 1×
     - 2×
     - **2×**

Memory and I/O
--------------

.. list-table::
   :header-rows: 1
   :widths: 40 30 30

   * - Feature
     - MI300X (CDNA 3)
     - MI350X (CDNA 4)
   * - Memory capacity
     - 192 GB HBM3
     - 288 GB HBM3E
   * - Memory bandwidth (peak)
     - 5.3 TB/s
     - 8.0 TB/s
   * - Infinity Fabric link speed
     - 32 Gbps
     - 38.4 Gbps (+20%)
   * - P2P aggregate bandwidth
     - 896 GB/s (8 GPUs)
     - 1,075.2 GB/s (8 GPUs)
   * - Total peak aggregate I/O BW
     - 1,024 GB/s
     - 1,203.2 GB/s

Data type support
-----------------

.. list-table::
   :header-rows: 1
   :widths: 40 30 30

   * - Data type
     - MI300X (CDNA 3)
     - MI350X (CDNA 4)
   * - FP64, FP32, FP16, BF16, INT8
     - Yes
     - Yes
   * - TF32
     - Hardware
     - Software emulation via BF16
   * - FP8 (E5M2 / E4M3)
     - FNUZ variant
     - OCP variant
   * - MXFP8 / MXFP6 / MXFP4
     - No
     - Yes (OCP MX, shared exponent per 32 elements)

Partitioning
------------

.. list-table::
   :header-rows: 1
   :widths: 30 35 35

   * - Mode
     - MI300X
     - MI350X
   * - SPX
     - 8 XCDs, 192 GB, NPS1
     - 8 XCDs, 288 GB, NPS1
   * - DPX
     - 4 XCDs, 96 GB, NPS1
     - 4 XCDs, 144 GB, NPS2
   * - QPX
     - 2 XCDs, 48 GB, NPS1/4
     - 2 XCDs, 72 GB, NPS2
   * - CPX
     - 1 XCD, 24 GB, NPS1
     - 1 XCD, 36 GB, NPS2
   * - Most efficient mode
     - QPX + NPS4
     - DPX + NPS2

Workload tuning strategy
========================

By following a structured approach, you can systematically address
performance issues and enhance the efficiency of your workloads on AMD Instinct
MI300X and MI350X GPUs.

Measure the current workload
----------------------------

Begin by evaluating the performance of your workload in its current state. This
involves running benchmarks and collecting performance data to establish a
baseline.

.. _mi3xx-profiling-start:

Identify tuning requirements
----------------------------

Analyze the collected performance data to identify areas where tuning is
required. This could involve detecting bottlenecks in CPU, GPU, memory, or data
transfer. Profiling tools can provide insights into both high-level and granular
performance metrics. See :ref:`mi3xx-profiling-tools`.

High-level profiling tools
^^^^^^^^^^^^^^^^^^^^^^^^^^

For a broad overview, use the :ref:`PyTorch Profiler <mi3xx-pytorch-profiler>`,
which helps understand how PyTorch operations are executed and where time is
spent.

Kernel-level profiling tools
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When GPUs are the performance bottleneck, use tools such as the
:ref:`ROCr Debug Agent <mi3xx-rocr-debug-agent>`,
:ref:`ROCProfiler <mi3xx-rocprof>`, and
:ref:`ROCm Compute Profiler <mi3xx-rocprof-compute>` for detailed GPU kernel
execution insights.

Analyze and tune
----------------

Based on profiling insights, focus tuning efforts on identified bottlenecks.

Optimize model inference with vLLM
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

vLLM provides tools for efficient model inference on AMD Instinct GPUs. See the
official `vLLM installation docs
<https://docs.vllm.ai/en/latest/getting_started/installation/gpu.html>`__ for
installation guidance.

.. seealso::

   See :doc:`vllm-optimization` to learn more about vLLM performance
   optimization techniques for MI300X, MI325X, MI350X, and MI355X.

.. _mi3xx-auto-tune:

Auto-tunable configurations
^^^^^^^^^^^^^^^^^^^^^^^^^^^

* PyTorch: Use :ref:`TorchInductor auto-tuning <mi3xx-torchinductor-tuning>` and
  the :ref:`TunableOp <mi3xx-tunableop>` module.

* MIOpen: Leverage :ref:`MIOpen's auto-tuning <mi3xx-miopen-tuning>` for
  convolution operations.

* Triton: Use :ref:`Triton's auto-tuning <mi3xx-autotunable-kernel-config>` to
  explore kernel configurations.

Manual tuning
^^^^^^^^^^^^^

* ROCm libraries: Adjust parameters within :ref:`ROCm libraries <mi3xx-rocm-library-tuning>`.

* Triton: Tune kernels to :ref:`optimize GPU utilization <mi3xx-triton-gpu-utilization>`
  and :ref:`leverage hardware features <mi3xx-assembly-analysis>`.

* HIP: :ref:`Optimize HIP kernels <mi3xx-hip-optimization>` for parallel execution
  and memory access patterns.

Iterate and validate
--------------------

After applying tuning changes, re-profile to validate improvements. ROCm
provides a prebuilt Docker image with ROCm, PyTorch, and vLLM. See
:doc:`/how-to/rocm-for-ai/inference/benchmark-docker/vllm`.

.. _mi3xx-profiling-tools:

Profiling tools
===============

AMD profiling tools provide insights into hardware utilization and help
diagnose potential bottlenecks.

* :doc:`ROCProfiler <rocprofiler:index>` collects kernel execution performance metrics.

* :doc:`ROCm Compute Profiler <rocprofiler-compute:index>` provides guided analysis.

Refer to :doc:`profiling-and-debugging` for commonly used profiling tools and
usage patterns.

Once bottlenecks are identified, consider:

* :ref:`Auto-tuning with TunableOp <mi3xx-tunableop>`
* :ref:`Auto-tuning in MIOpen <mi3xx-miopen-tuning>`
* :ref:`Triton auto-tunable kernel configurations <mi3xx-autotunable-kernel-config>`
* :ref:`mi3xx-triton-kernel-performance-optimization` (for manual tuning)
* :ref:`RCCL tuning <mi3xx-rccl>` (for multi-GPU scale-out)

.. _mi3xx-pytorch-profiler:

PyTorch Profiler
----------------

`PyTorch Profiler <https://pytorch.org/docs/stable/profiler.html>`_ can be
invoked inside Python scripts to collect CPU and GPU performance metrics.
Visualize results with `Perfetto UI <https://ui.perfetto.dev>`_.

.. code-block:: python

   import torch
   import torchvision.models as models
   from torch.profiler import profile, record_function, ProfilerActivity
   model = models.resnet18().cuda()
   inputs = torch.randn(2000, 3, 224, 224).cuda()

   with profile(activities=[ProfilerActivity.CPU, ProfilerActivity.CUDA]) as prof:
       with record_function("model_inference"):
           model(inputs)
   prof.export_chrome_trace("resnet18_profile.json")

.. figure:: ../../../data/how-to/tuning-guides/perfetto-trace.svg
   :width: 800

   Perfetto trace visualization example.

.. _mi3xx-rocprof:

ROCProfiler
^^^^^^^^^^^

:doc:`ROCProfiler <rocprofiler:index>` is a low-level API for extracting GPU
hardware performance counters. The ``rocprof`` CLI collects counters and
timeline traces.

.. _mi3xx-rocprof-compute:

ROCm Compute Profiler
^^^^^^^^^^^^^^^^^^^^^

:doc:`ROCm Compute Profiler <rocprofiler-compute:index>` automates collection
of all hardware counters and provides graphical analysis including
Speed-of-Light, Memory Chart Analysis, and Roofline Analysis.

.. figure:: ../../../data/how-to/tuning-guides/rocprof-compute-analysis.png
   :width: 800

   ROCm Compute Profiler memory chart analysis panel.

.. _mi3xx-rocprof-systems:

ROCm Systems Profiler
^^^^^^^^^^^^^^^^^^^^^

:doc:`ROCm Systems Profiler <rocprofiler-systems:index>` is a comprehensive
profiling tool for parallel applications written in C, C++, Fortran, HIP,
OpenCL, and Python.

.. figure:: ../../../data/how-to/tuning-guides/rocprof-systems-timeline.png
   :width: 800

   ROCm Systems Profiler timeline trace example.

.. _mi3xx-vllm-optimization:

vLLM performance optimization
=============================

vLLM is a high-throughput inference and serving engine for LLMs. See
:doc:`vllm-optimization` for detailed optimization guidance covering AITER,
attention backends, parallelism strategies, quantization, and benchmarking
for MI300X, MI325X, MI350X, and MI355X.

.. tab-set::

   .. tab-item:: MI300X / MI325X

      * 192 GB HBM3 (MI300X) / 256 GB HBM3E (MI325X) at 5.3-6.0 TB/s
      * FP8 quantization uses **FNUZ** variant (E4M3, E5M2)
      * FP8 peak: 2.6 PF (MI300X)

   .. tab-item:: MI350X / MI355X

      * 288 GB HBM3E at 8.0 TB/s — fits larger models and longer context windows
      * FP8 quantization uses **OCP** variant (E4M3, E5M2) — different from MI300X
      * MXFP4 quantization supported natively (e.g.,
        `Llama-3.3-70B-Instruct-MXFP4-Preview <https://huggingface.co/amd/Llama-3.3-70B-Instruct-MXFP4-Preview>`__)
      * FP8 peak: 4.6 PF (MI350X) / 5.0 PF (MI355X); MXFP4 peak: 9.2 / 10 PF

.. _mi3xx-tunableop:

PyTorch TunableOp
==================

`TunableOp <https://github.com/pytorch/pytorch/blob/main/aten/src/ATen/cuda/tunable/README.md>`_
obtains the optimal GPU kernel for key PyTorch operations (GEMM, batched GEMM,
scaled GEMM). It tries thousands of algorithms available in rocBLAS and hipBLASLt.

Key environment variables:

``PYTORCH_TUNABLEOP_ENABLED``
   Main on/off switch. Default ``0``. Set to ``1`` to enable.

``PYTORCH_TUNABLEOP_TUNING``
   Run tuning if no entry found. Default ``1``. Set to ``0`` to disable.

``PYTORCH_TUNABLEOP_VERBOSE``
   Verbose output. Default ``0``. Set to ``1`` to enable.

Workflow
--------

1. **Tuning pass** (slow):

   .. code-block:: shell

      PYTORCH_TUNABLEOP_ENABLED=1 PYTORCH_TUNABLEOP_VERBOSE=1 your_script.sh

   Produces ``tunableop_results.csv``. Multi-GPU tuning produces one file per GPU.

2. **Measurement pass** with tuned results:

   .. code-block:: shell

      PYTORCH_TUNABLEOP_ENABLED=1 PYTORCH_TUNABLEOP_TUNING=0 your_script.sh

Compare wall-clock time against ``PYTORCH_TUNABLEOP_ENABLED=0`` baseline.

Offline tuning (PyTorch 2.6+) decouples tuning from workload execution. See
the `Offline Tuning documentation <https://github.com/pytorch/pytorch/blob/main/aten/src/ATen/cuda/tunable/README.md#offline-tuning>`_.

.. _mi3xx-torchinductor-tuning:

PyTorch inductor max-autotune
==============================

Optimize GEMM and convolution operations using ``inductor`` in the PyTorch
compilation framework.

* ``TORCHINDUCTOR_MAX_AUTOTUNE=1`` — benchmarks Triton configurations and selects the fastest.
* ``TORCHINDUCTOR_MAX_AUTOTUNE_GEMM_BACKENDS=TRITON,ATEN`` — select backends.
  Limiting to ``TRITON`` may enable more fused kernels.
* ``TORCHINDUCTOR_FREEZING=1`` — in-lines weights as constants for inference.
* ``TORCHINDUCTOR_CPP_WRAPPER=1`` — generates C++ that launches Triton via ``hipModuleLaunchKernel``.
* ``TORCHINDUCTOR_LAYOUT_OPTIMIZATION=1`` — enforces ``channel_last`` for convolutions.

**Composable Kernel (CK) backend**: Append ``CK`` to ``TORCHINDUCTOR_MAX_AUTOTUNE_GEMM_BACKENDS``.

.. code-block:: shell

   pip install git+https://github.com/rocm/composable_kernel@develop

.. _mi3xx-rocm-library-tuning:

ROCm library tuning
===================

.. _mi3xx-library-gemm:

GEMM (general matrix multiplication)
------------------------------------

GEMMs are a fundamental building block for neural networks. ``C = αAB + βC``
where A is ``MxK``, B is ``KxN``, C is ``MxN``.

.. _mi3xx-hipblaslt:

hipBLASLt benchmarking
^^^^^^^^^^^^^^^^^^^^^^

`hipBLASLt <https://rocm.docs.amd.com/projects/hipBLASLt/en/latest/index.html>`_
provides a benchmark tool. Example FP8 GEMM benchmark:

.. code-block:: shell

   HIP_FORCE_DEV_KERNARG=1 hipblaslt-bench --alpha 1 --beta 0 -r f16_r \
   --a_type f16_r --b_type f8_r --compute_type f32_f16_r \
   --initialization trig_float --cold_iters 100 --iters 1000 --rotating 256

hipBLASLt backend assembly generator (TensileLite)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

TensileLite enables performance optimization by tuning the backend assembly
generator. See
`hipBLASLt GitHub <https://github.com/ROCm/hipBLASLt/tree/develop/tensilelite>`_.

.. code-block:: shell

   cd /hipBLASLt/tensilelite
   ./Tensile/bin/Tensile config.yaml output_path

``LibraryLogic`` configuration:

.. tab-set::

   .. tab-item:: MI300X (CDNA 3)

      .. code-block:: yaml

         LibraryLogic:
           ScheduleName: "aquavanjaram"
           DeviceNames: [Device 7400]
           ArchitectureName: "gfx942"

   .. tab-item:: MI350X (CDNA 4)

      .. code-block:: yaml

         LibraryLogic:
           ScheduleName: "aquavanjaram"
           DeviceNames: [Device 75a0]
           ArchitectureName: "gfx950"

Tensile optimization tips
^^^^^^^^^^^^^^^^^^^^^^^^^

MI16x16 versus MI32x32
   ``mfma_16x16`` outperforms ``mfma_32x32`` due to superior power efficiency
   on both CDNA 3 and CDNA 4.

   .. note::

      MI350X additionally supports xf32 MFMA instructions
      (``v_mfma_f32_16x16x8_xf32``, ``v_mfma_f32_32x32x4_xf32``) and has
      doubled Matrix Core throughput for ≤16-bit types. Benchmark to verify
      optimal instruction size for your workload.

Clock differences among XCDs
   Clock speed variation exists among XCDs on both MI300X and MI350X. Use the
   XCD with the lowest average clock speed for efficiency calculations.

`WorkGroupMapping`
   Use multiples of 8 (the XCD count) to maximize L2 cache efficiency on
   both MI300X and MI350X — e.g., 24, 32, 40.

GEMM stride issues
   On MI300 Series GPUs, matrix strides that are multiples of 512 bytes can cause
   Tagram channel hotspotting. Use stride padding (e.g., ``lda = K + 128`` when
   ``K % 256 == 0``).

   .. note::

      Verify whether this stride alignment issue applies to MI350X (gfx950).
      The CDNA 4 memory hierarchy may behave differently.

.. _mi3xx-ck:

Composable Kernel GEMM optimization
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Performance hierarchy by input values (highest to lowest): all zeros > identical
integers > random integers > random floats (>20% drop between extremes).
``bf16`` matrix core execution is faster than ``f16``.

See :doc:`optimizing-with-composable-kernel` for details.

.. _mi3xx-miopen:

MIOpen
------

MIOpen's auto-tuning infrastructure optimizes convolution kernels.

.. _mi3xx-miopen-tuning:

Tuning in MIOpen
^^^^^^^^^^^^^^^^

* ``MIOPEN_FIND_ENFORCE=2`` (DB_UPDATE) — auto-tune and update PerfDb.
* ``MIOPEN_FIND_ENFORCE=3`` (SEARCH) — auto-tune only if PerfDb has no entry.
* ``MIOPEN_FIND_MODE=1`` (NORMAL) — benchmark all solvers.
* ``MIOPEN_FIND_MODE=3`` (HYBRID) — check FindDb, else benchmark.

See :doc:`miopen:conceptual/perfdb` and :doc:`miopen:how-to/find-and-immediate`.

.. _mi3xx-rccl:

RCCL
----

:doc:`RCCL <rccl:index>` implements standard collective communication routines
(all-reduce, all-gather, reduce, broadcast, etc.) for GPUs.

Use all eight GPUs
^^^^^^^^^^^^^^^^^^

Both MI300X and MI350X use 8 GPUs in a fully connected XGMI topology. Best
collective performance is achieved when all 8 GPUs are used.

.. tab-set::

   .. tab-item:: MI300X (CDNA 3)

      * 4 IODs, 8 Infinity Fabric links at 32 Gbps
      * P2P ring aggregate: 896 GB/s
      * 40 CUs per XCD (38 active), 304 total CUs

   .. tab-item:: MI350X (CDNA 4)

      * 2 IODs (direct connection ~14% faster), 8 links at 38.4 Gbps
      * P2P ring aggregate: 1,075.2 GB/s (+20%)
      * 36 CUs per XCD (32 active), 256 total CUs

Disable NUMA auto-balancing
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: shell

   # Check:
   cat /proc/sys/kernel/numa_balancing
   # Disable if output is 1:
   sudo sysctl kernel.numa_balancing=0

RCCL in E2E workloads
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: text

   export NCCL_MIN_NCHANNELS=112

.. note::

   The value ``112`` was empirically tuned for MI300X. Benchmark with different
   values on MI350X to determine the optimal channel count.

.. _mi3xx-triton-kernel-performance-optimization:

Triton kernel performance optimization
=======================================

.. _mi3xx-autotunable-kernel-config:

Auto-tunable kernel configurations
-----------------------------------

.. _mi3xx-cu-fig:

.. figure:: ../../../data/shared/compute-unit.png

   Schematic representation of a compute unit (CU).

.. tab-set::

   .. tab-item:: MI300X (CDNA 3)

      * **LDS**: 64 KB per CU, 32 banks, 128 bytes/clock read bandwidth
      * **L1 data cache**: 32 KB, 128B lines, 64-way
      * **Instruction cache**: 64 KB, 8-way, shared per 2 CUs

   .. tab-item:: MI350X (CDNA 4)

      * **LDS**: 160 KB per CU (2.5×), increased banks, 256 bytes/clock read bandwidth,
        direct L1→LDS loading (reduces VGPR usage and latency)
      * **L1 data cache**: 32 KB, 128B lines, 64-way (unchanged)
      * **Instruction cache**: 64 KB, 8-way, shared per 2 CUs (unchanged)

``num_stages=n``
   Pipeline stages. On AMD GPUs:

   * Single GEMM kernels: ``2``
   * Fused 2-GEMM kernels (Flash Attention): ``1``
   * GEMM + non-GEMM fusion (e.g., ReLU): ``2``
   * No-GEMM kernels: ``1``

   .. note::

      MI350X's 160 KB LDS and doubled read bandwidth may allow higher
      ``num_stages`` (3 or 4) for single-GEMM kernels. Benchmark to verify.

``waves_per_eu=n``
   Hints the compiler to reduce VGPR usage for target occupancy. Useful when
   VGPR usage is near an allocation boundary.

.. _mi3xx-occupancy-vgpr-table:

.. figure:: ../../../data/shared/occupancy-vgpr.png
   :align: center

   Occupancy vs VGPR usage. Each EU has 512 VGPRs allocated in blocks of 16.
   This table applies to both MI300X and MI350X (same VGPR allocation).

``BLOCK_M``, ``BLOCK_N``, ``BLOCK_K``
   Tile sizes to balance memory-to-computation ratio.

   .. note::

      MI350X's 160 KB LDS (vs 64 KB on MI300X) enables larger tile sizes.
      Explore larger ``BLOCK_M/N/K`` values to leverage the increased LDS
      and doubled read bandwidth.

``matrix_instr_nonkdim``
   Sets MFMA instruction size: ``16`` for ``mfma_16x16``, ``32`` for ``mfma_32x32``.
   ``mfma_16x16`` typically outperforms ``mfma_32x32`` on both CDNA 3 and CDNA 4.

.. _mi3xx-triton-gpu-utilization:

Overall GPU resource utilization
---------------------------------

.. tab-set::

   .. tab-item:: MI300X

      Each XCD contains 40 CUs (38 active). Total: 304 active CUs across 8 XCDs.
      Target a minimum of **1024 thread blocks** (~3.4 per CU).

      .. figure:: ../../../data/shared/xcd-sys-arch.png

         MI300X XCD architecture: 40 CUs (38 active), 4 MB L2, 4 ACEs, HWS.

   .. tab-item:: MI350X

      Each XCD contains 36 CUs (32 active). Total: 256 active CUs across 8 XCDs.
      Target a minimum of **768 thread blocks** (~3 per CU).
      Built on TSMC N3P with doubled Matrix Core throughput for ≤16-bit types.

Query hardware resources:

.. code-block:: shell

   rocminfo | grep "Compute Unit"
   rocminfo | grep "SIMD"
   rocminfo | grep "Wavefront Size"

.. _mi3xx-mlir-analysis:

MLIR analysis
-------------

Use ``MLIR_ENABLE_DUMP=1`` to dump Triton GPU Intermediate Representation:

.. code-block:: shell

   export MLIR_ENABLE_DUMP=1

Inspect layouts (blocked, shared, sliced, MFMA) to identify where computation
occurs and find optimization opportunities such as reducing LDS round-trips.

.. _mi3xx-assembly-analysis:

ISA assembly analysis
---------------------

Generate ISA with ``export AMDGCN_ENABLE_DUMP=1``. Key guidelines:

* Use ``global_load_dwordx4`` for global memory loads in loops.
* Use ``_b128`` for LDS load/store to minimize instruction count.
* Check ``s_waitcnt`` instructions (``lgkmcnt``, ``vmcnt``) for efficient synchronization.
* Trace inefficiencies back through LLVM IR → TTGIR → TTIR.

.. _mi3xx-hip-optimization:

HIP performance optimization
=============================

See :doc:`HIP performance guidelines <hip:how-to/performance_guidelines>`.
Key areas: parallel execution, memory usage optimization (minimize host↔device
transfers, maximize LDS usage), and throughput optimization.

.. tab-set::

   .. tab-item:: MI300X

      LDS: 64 KB per CU. Global memory is high-latency; transfer shared data to
      LDS for efficient intra-block access.

   .. tab-item:: MI350X

      LDS: 160 KB per CU with doubled read bandwidth (256 bytes/clock) and
      L1→LDS direct loading. Significantly more on-chip storage for data reuse.

Diagnostic and performance analysis
====================================

.. _mi3xx-rocr-debug-agent:

Debug memory access faults
--------------------------

The ROCr Debug Agent traps memory access faults and dumps all active wavefronts.
See :doc:`ROCr Debug Agent documentation <rocr_debug_agent:index>`.

.. code-block:: shell

   HSA_TOOLS_LIB=/opt/rocm/lib/librocm-debug-agent.so.2 HSA_ENABLE_DEBUG=1 ./my_program

Disable memory caching for best fault isolation:

.. code-block:: text

   PYTORCH_NO_HIP_MEMORY_CACHING=1
   HSA_DISABLE_FRAGMENT_ALLOCATOR=1

.. _mi3xx-compute-kernel-occ:

Compute the occupancy of a kernel
---------------------------------

1. Get VGPR count: search for ``.vgpr_count`` in ISA (value ``N``).

2. Get allocated LDS (value ``L``):

   .. code-block:: shell

      export MLIR_ENABLE_DUMP=1
      rm -rf ~/.triton/cache
      python kernel.py | grep "triton_gpu.shared = " | tail -n 1

3. Get waves per workgroup (value ``nW``):

   .. code-block:: shell

      python kernel.py | grep "triton_gpu.num-warps " | tail -n 1

4. Compute VGPR-limited occupancy (``occ_vgpr``) from the
   :ref:`occupancy table <mi3xx-occupancy-vgpr-table>`.

5. Compute LDS-limited occupancy:

   .. tab-set::

      .. tab-item:: MI300X

         ``occ_lds = floor(65536 / L)``  (64 KB = 65,536 bytes LDS per CU)

      .. tab-item:: MI350X

         ``occ_lds = floor(163840 / L)``  (160 KB = 163,840 bytes LDS per CU)

6. Final occupancy: ``occ = min(floor(occ_vgpr * 4 / nW), occ_lds) * nW / 4``

See the full script at
`occ.sh <https://github.com/ROCm/triton/blob/triton-mlir/scripts/amd/occ.sh>`__.

Special considerations
======================

Multi-GPU communications
------------------------

Both MI300X and MI350X have bandwidth limitations for 2- or 4-GPU collectives.
Use single GPU (no collective needed) or 8-GPU collectives for optimal performance.

Multi-node FSDP and RCCL settings
---------------------------------

For PyTorch FSDP, use high-priority RCCL streams:

.. code-block:: text

   export TORCH_NCCL_HIGH_PRIORITY=1
   export GPU_MAX_HW_QUEUES=2

This limits to 2 compute + 2 RCCL streams (optimal for hardware efficiency).

.. tab-set::

   .. tab-item:: MI300X

      4 IODs. RCCL is pre-optimized for MI300X topology.

   .. tab-item:: MI350X

      2 IODs with faster direct connection. The simplified topology reduces
      latency and frees power headroom for compute.

MI350X-specific features
------------------------

**Micro-scaled data types (OCP MX standard)**

MI350X introduces hardware support for MXFP8, MXFP6, and MXFP4, which use a
shared 8-bit exponent across blocks of 32 elements. This finer granularity
(vs per-tensor scaling) enables reduced precision on a wider variety of tensors.

* MXFP4 (E2M1): 4-bit, peak 9.2 PF (MI350X) / 10 PF (MI355X)
* MXFP6 (E3M2, E2M3): 6-bit, same peak as MXFP4
* MXFP8 (E5M2, E4M3): 8-bit with block scaling, peak 4.6 PF / 5.0 PF

**TF32 transition**

TF32 has moved from hardware to software emulation via BF16. BF16 Matrix
throughput on MI350X (4096 FLOPS/clock/CU) exceeds MI300X TF32 hardware
rate (1024 FLOPS/clock/CU) by 4×.

**FP64 Matrix reduction**

Matrix FP64 is halved (128 vs 256 FLOPS/clock/CU). HPC workloads relying
on FP64 matrix operations should benchmark and account for this change.

Further reading
===============

* :doc:`vllm-optimization`
* :doc:`workload` (MI300X-specific workload optimization guide)
* :doc:`mi350-workload` (MI350X-specific workload optimization guide)
