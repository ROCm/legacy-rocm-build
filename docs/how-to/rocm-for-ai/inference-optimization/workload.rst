.. meta::
   :description: Learn about workload tuning on AMD Instinct MI300X (and MI355X) GPUs for HPC and deep-learning workloads, with a self-contained vLLM performance section covering attention backends, AITER, Quick Reduce, parallelism, and engine/compilation tuning.
   :keywords: AMD, Instinct, MI300X, MI355X, HPC, tuning, BIOS settings, NBIO, ROCm,
              environment variable, performance, HIP, Triton, PyTorch TunableOp, vLLM, RCCL,
              MIOpen, GPU, resource utilization

*****************************************
AMD Instinct MI300X workload optimization
*****************************************

This document provides guidelines for optimizing the performance of AMD
Instinct™ MI300X GPUs (and notes where MI355X differs), with a focus on
GPU-kernel programming, high-performance computing (HPC), and deep-learning
operations using PyTorch and vLLM. It includes complete, self-contained guidance
for :ref:`vLLM performance optimization <mi300x-vllm-optimization>`, including
attention backends, AITER, Quick Reduce, parallelism on ROCm, and engine &
compilation tuning.

The following topics highlight :ref:`auto-tunable configurations <mi300x-auto-tune>` as
well as :ref:`Triton kernel optimization <mi300x-triton-kernel-performance-optimization>`
for meticulous tuning.

Workload tuning strategy
========================

By following a structured approach, you can systematically address
performance issues and enhance the efficiency of your workloads on AMD Instinct
MI300X GPUs.

Measure the current workload
----------------------------

Begin by evaluating the performance of your workload in its current state. This
involves running benchmarks and collecting performance data to establish a
baseline. Understanding how your workload behaves under different conditions
provides critical insights into where improvements are needed.

.. _mi300x-profiling-start:

Identify tuning requirements
----------------------------

Analyze the collected performance data to identify areas where tuning is
required. This could involve detecting bottlenecks in CPU, GPU, memory, or data
transfer. Understanding these requirements will help direct your optimization
efforts more effectively.

Profiling is a fundamental step in workload tuning. It allows you to gather
detailed information about how your workload utilizes system resources, and
where potential inefficiencies lie. Profiling tools can provide insights into
both high-level and granular performance metrics. See :ref:`mi300x-profiling-tools`.

High-level profiling tools
^^^^^^^^^^^^^^^^^^^^^^^^^^

For a broad overview, use tools like the
:ref:`PyTorch Profiler <mi300x-pytorch-profiler>`, which helps in
understanding how PyTorch operations are executed and where time is spent. This
is particularly useful for developers new to workload tuning, as it provides a
comprehensive view without requiring in-depth knowledge of lower-level
operations.

Kernel-level profiling tools
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When profiling indicates that GPUs are a performance bottleneck, delve deeper
into kernel-level profiling. Tools such as the
:ref:`ROCr Debug Agent <mi300x-rocr-debug-agent>`,
:ref:`ROCProfiler <mi300x-rocprof>`, and
:ref:`ROCm Compute Profiler <mi300x-rocprof-compute>` offer detailed insights
into GPU kernel execution. These tools can help isolate problematic GPU
operations and provide data needed for targeted optimizations.

Analyze and tune
----------------

Based on the insights gained from profiling, focus your tuning efforts on the
identified bottlenecks. This might involve optimizing specific kernel
operations, adjusting memory access patterns, or modifying computational
algorithms.

The following subsections discuss optimization ranging from high-level and more
automated strategies to more involved, hands-on optimization.

Optimize model inference with vLLM
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

vLLM provides tools and techniques designed for efficient model inference on AMD
Instinct MI300X . See :ref:`fine-tuning-llms-vllm` for installation
guidance. Optimizing performance with vLLM involves configuring parallelism,
choosing the right attention backend, leveraging advanced (ROCm-specific)
features, and ensuring efficient execution. A complete, self-contained guide is
provided in :ref:`vLLM performance optimization <mi300x-vllm-optimization>`.

.. _mi300x-auto-tune:

Auto-tunable configurations
^^^^^^^^^^^^^^^^^^^^^^^^^^^
Auto-tunable configurations can significantly streamline performance
optimization by automatically adjusting parameters based on workload
characteristics. For example:

* PyTorch: Utilize :ref:`PyTorch’s built-in auto-tuning features <mi300x-torchinductor-tuning>`,
  such as the :ref:`TunableOp <mi300x-tunableop>` module, which helps in
  optimizing operation performance by exploring different configurations.

* MIOpen: Leverage :ref:`MIOpen’s auto-tuning capabilities <mi300x-miopen-tuning>`
  for convolutional operations and other primitives to find optimal settings for
  your specific hardware.

* Triton: Use :ref:`Triton’s auto-tuning features <mi300x-autotunable-kernel-config>`
  to explore various kernel configurations and select the best-performing ones.

Manual tuning
^^^^^^^^^^^^^

Advanced developers can manually adjust parameters and configurations to
optimize performance. Both Triton and HIP involve manual tuning aspects.

* ROCm libraries: Optimize GPU performance by adjusting various parameters and
  configurations within :ref:`ROCm libraries <mi300x-rocm-library-tuning>`. This
  approach involves hands-on optimization to maximize efficiency for specific
  workloads.

* Triton: Tune Triton kernels by adjusting parameters tailored to
  your workload to
  :ref:`optimize GPU resource utilization <mi300x-triton-gpu-utilization>` and
  better :ref:`leverage specific hardware features <mi300x-assembly-analysis>`.

* HIP: Profile and :ref:`optimize HIP kernels <mi300x-hip-optimization>` by
  optimizing parallel execution, memory access patterns, and other aspects.

Iterate and validate
--------------------

Optimization is an iterative process. After applying tuning changes, re-profile
the workload to validate improvements and ensure that the changes have had the
desired effect. Continuous iteration helps refine the performance gains and
address any new bottlenecks that may emerge.

ROCm provides a prebuilt optimized Docker image that has everything required to implement
the LLM inference tips in this section. It includes ROCm, PyTorch, and vLLM.
For more information, see :doc:`/how-to/rocm-for-ai/inference/benchmark-docker/vllm`.

.. _mi300x-profiling-tools:

Profiling tools
===============

AMD profiling tools provide valuable insights into how efficiently your
application utilizes hardware and help diagnose potential bottlenecks that
contribute to poor performance. Developers targeting AMD GPUs have multiple
tools available depending on their specific profiling needs.

* ROCProfiler tool collects kernel execution performance
  metrics. For more information, see the
  :doc:`ROCProfiler <rocprofiler:index>`
  documentation.

* ROCm Compute Profiler builds upon ROCProfiler but provides more guided analysis.
  For more information, see
  :doc:`ROCm Compute Profiler documentation <rocprofiler-compute:index>`.

Refer to :doc:`profiling-and-debugging`
to explore commonly used profiling tools and their usage patterns.

Once performance bottlenecks are identified, you can implement an informed workload
tuning strategy. If kernels are the bottleneck, consider:

* :ref:`Auto-tuning in PyTorch with TunableOp <mi300x-tunableop>`

* :ref:`Auto-tuning in MIOpen <mi300x-miopen-tuning>`

* :ref:`Triton auto-tunable kernel configurations <mi300x-autotunable-kernel-config>`

If auto-tuning does not meet your requirements, consider
:ref:`mi300x-triton-kernel-performance-optimization`.

If the issue is multi-GPU scale-out, try
:ref:`RCCL tuning and configuration <mi300x-rccl>`.

This section discusses profiling and debugging tools and some of their common usage patterns with ROCm applications.

.. _mi300x-pytorch-profiler:

PyTorch Profiler
----------------

`PyTorch Profiler <https://pytorch.org/docs/stable/profiler.html>`_ can be invoked inside Python scripts, letting you
collect CPU and GPU performance metrics while the script is running. See the `PyTorch Profiler tutorial
<https://pytorch.org/tutorials/recipes/recipes/profiler_recipe.html>`_ for more information.

You can then visualize and view these metrics using an open-source profile visualization tool like
`Perfetto UI <https://ui.perfetto.dev>`_.

#. Use the following snippet to invoke PyTorch Profiler in your code.

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

#. Profile results in ``resnet18_profile.json`` can be viewed by the Perfetto visualization tool. Go to
   `<https://ui.perfetto.dev>`__ and import the file. In your Perfetto visualization, you'll see that the upper section
   shows transactions denoting the CPU activities that launch GPU kernels while the lower section shows the actual GPU
   activities where it processes the ``resnet18`` inferences layer by layer. 

   .. figure:: ../../../data/how-to/tuning-guides/perfetto-trace.svg
      :width: 800

      Perfetto trace visualization example.

ROCm profiling tools
--------------------

Heterogenous systems, where programs run on both CPUs and GPUs, introduce additional complexities. Understanding the
critical path and kernel execution is all the more important. So, performance tuning is a necessary component in the
benchmarking process.

With AMD's profiling tools, developers are able to gain important insight into how efficiently their application is
using hardware resources and effectively diagnose potential bottlenecks contributing to poor performance. Developers
working with AMD Instinct GPUs have multiple tools depending on their specific profiling needs; these include:

* :ref:`ROCProfiler <mi300x-rocprof>`

* :ref:`ROCm Compute Profiler <mi300x-rocprof-compute>`

* :ref:`ROCm Systems Profiler <mi300x-rocprof-systems>`

.. _mi300x-rocprof:

ROCProfiler
^^^^^^^^^^^

:doc:`ROCProfiler <rocprofiler:index>` is primarily a low-level API for accessing and extracting GPU hardware performance
metrics, commonly called *performance counters*. These counters quantify the performance of the underlying architecture
showcasing which pieces of the computational pipeline and memory hierarchy are being utilized.

Your ROCm installation contains a script or executable command called ``rocprof`` which provides the ability to list all
available hardware counters for your specific GPU or GPU, and run applications while collecting counters during
their execution.

This ``rocprof`` utility also depends on the :doc:`ROCTracer and ROC-TX libraries <roctracer:index>`, giving it the
ability to collect timeline traces of the GPU software stack as well as user-annotated code regions.

.. note::

   ``rocprof`` is a CLI-only utility where inputs and outputs take the form of text and CSV files. These
   formats provide a raw view of the data and puts the onus on the user to parse and analyze. ``rocprof``
   gives the user full access and control of raw performance profiling data, but requires extra effort to analyze the
   collected data.

.. _mi300x-rocprof-compute:

ROCm Compute Profiler
^^^^^^^^^^^^^^^^^^^^^

:doc:`ROCm Compute Profiler <rocprofiler-compute:index>` is a system performance profiler for high-performance computing (HPC) and
machine learning (ML) workloads using Instinct GPUs. Under the hood, ROCm Compute Profiler uses
:ref:`ROCProfiler <mi300x-rocprof>` to collect hardware performance counters. The ROCm Compute Profiler tool performs
system profiling based on all approved hardware counters for Instinct
GPU architectures. It provides high level performance analysis features including System Speed-of-Light, IP
block Speed-of-Light, Memory Chart Analysis, Roofline Analysis, Baseline Comparisons, and more.

ROCm Compute Profiler takes the guesswork out of profiling by removing the need to provide text input files with lists of counters
to collect and analyze raw CSV output files as is the case with ROCProfiler. Instead, ROCm Compute Profiler automates the collection
of all available hardware counters in one command and provides graphical interfaces to help users understand and
analyze bottlenecks and stressors for their computational workloads on AMD Instinct GPUs.

.. note::

   ROCm Compute Profiler collects hardware counters in multiple passes, and will therefore re-run the application during each pass
   to collect different sets of metrics.

.. figure:: ../../../data/how-to/tuning-guides/rocprof-compute-analysis.png
   :width: 800

   ROCm Compute Profiler memory chart analysis panel.

In brief, ROCm Compute Profiler provides details about hardware activity for a particular GPU kernel. It also supports both
a web-based GUI or command-line analyzer, depending on your preference.

.. _mi300x-rocprof-systems:

ROCm Systems Profiler
^^^^^^^^^^^^^^^^^^^^^

:doc:`ROCm Systems Profiler <rocprofiler-systems:index>` is a comprehensive profiling and tracing tool for parallel applications,
including HPC and ML packages, written in C, C++, Fortran, HIP, OpenCL, and Python which execute on the CPU or CPU and
GPU. It is capable of gathering the performance information of functions through any combination of binary
instrumentation, call-stack sampling, user-defined regions, and Python interpreter hooks.

ROCm Systems Profiler supports interactive visualization of comprehensive traces in the web browser in addition to high-level
summary profiles with ``mean/min/max/stddev`` statistics. Beyond runtime
information, ROCm Systems Profiler supports the collection of system-level metrics such as CPU frequency, GPU temperature, and GPU
utilization. Process and thread level metrics such as memory usage, page faults, context switches, and numerous other
hardware counters are also included.

.. tip::

   When analyzing the performance of an application, it is best not to assume you know where the performance
   bottlenecks are and why they are happening. ROCm Systems Profiler is the ideal tool for characterizing where optimization would
   have the greatest impact on the end-to-end execution of the application and to discover what else is happening on the
   system during a performance bottleneck.

.. figure:: ../../../data/how-to/tuning-guides/rocprof-systems-timeline.png
   :width: 800

   ROCm Systems Profiler timeline trace example.

.. _mi300x-vllm-optimization:

vLLM performance optimization
=============================

This guide helps you maximize vLLM throughput and minimize latency on AMD MI300X/MI355X GPUs. Learn how to:

* Enable **AITER** (AI Tensor Engine for ROCm) for speedups on LLM models
* Configure **environment variables** for optimal HIP, RCCL, and Quick Reduce performance
* Select the right **attention backend** for your workload (AITER MHA/MLA vs Triton)
* Choose **parallelism strategies** (tensor, pipeline, data, expert) for multi-GPU deployments
* Apply **quantization** (FP8/FP4) to reduce memory usage by 2-4× with minimal accuracy loss
* Tune **engine arguments** (batch size, memory utilization, graph modes) for your use case
* Benchmark and scale across **single-node** and **multi-node** configurations

Performance environment variables
---------------------------------

The following variables are generally useful for MI300X/MI355X and vLLM:

* **HIP & math libraries**

  * ``export HIP_FORCE_DEV_KERNARG=1`` — improves kernel launch performance by forcing device kernel arguments. **Already set by default in vLLM ROCm Docker images.** Bare-metal users should set this manually.
  * ``export TORCH_BLAS_PREFER_HIPBLASLT=1`` — explicitly prefers hipBLASLt over hipBLAS for GEMM operations. By default, PyTorch uses heuristics to choose the best BLAS library. Setting this can improve linear layer performance in some workloads.

* **RCCL (collectives for multi-GPU)**

  * ``export NCCL_MIN_NCHANNELS=112`` — increases RCCL channels from default (typically 32-64) to 112 on MI300X. **Only beneficial for multi-GPU distributed workloads** (tensor parallelism, pipeline parallelism). Single-GPU inference does not need this.

AITER (AI Tensor Engine for ROCm) switches
------------------------------------------

**AITER** (AI Tensor Engine for ROCm) provides ROCm-specific fused kernels optimized for MI300X/MI355X GPUs in vLLM V1.

**How AITER flags work:**

* ``VLLM_ROCM_USE_AITER`` is the **master switch** (defaults to **False/0**)
* Individual feature flags (``VLLM_ROCM_USE_AITER_LINEAR``, ``VLLM_ROCM_USE_AITER_MOE``, etc.) default to **True** but only activate when the master switch is enabled
* To enable a specific AITER feature, you must set **both** ``VLLM_ROCM_USE_AITER=1`` **and** the specific feature flag to ``1``

**Quick start examples:**

.. code-block:: bash

   # Enable all AITER optimizations (recommended for most workloads)
   export VLLM_ROCM_USE_AITER=1
   vllm serve MODEL_NAME

   # Enable only AITER Triton Prefill-Decode (split) attention
   export VLLM_ROCM_USE_AITER=1
   export VLLM_V1_USE_PREFILL_DECODE_ATTENTION=1
   export VLLM_ROCM_USE_AITER_MHA=0
   vllm serve MODEL_NAME

   # Disable AITER entirely (i.e, use vLLM Triton Unified Attention Kernel)
   export VLLM_ROCM_USE_AITER=0
   vllm serve MODEL_NAME

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Environment variable
     - Description (default behavior)

   * - ``VLLM_ROCM_USE_AITER``
     - **Master switch** to enable AITER kernels (**0/False** by default). All other ``VLLM_ROCM_USE_AITER_*`` flags require this to be set to ``1``.

   * - ``VLLM_ROCM_USE_AITER_LINEAR``
     - Use AITER quantization operators + GEMM for linear layers (defaults to **True** when AITER is on). Accelerates matrix multiplications in all transformer layers. **Recommended: keep enabled.**

   * - ``VLLM_ROCM_USE_AITER_MOE``
     - Use AITER fused-MoE kernels (defaults to **True** when AITER is on). Accelerates Mixture-of-Experts routing and computation. **See detailed requirements below.**

   * - ``VLLM_ROCM_USE_AITER_RMSNORM``
     - Use AITER RMSNorm kernels (defaults to **True** when AITER is on). Accelerates normalization layers. **Recommended: keep enabled.**

   * - ``VLLM_ROCM_USE_AITER_MLA``
     - Use AITER Multi-head Latent Attention for supported models e.g. DeepSeek-V3/R1 (defaults to **True** when AITER is on). **See detailed requirements below.**

   * - ``VLLM_ROCM_USE_AITER_MHA``
     - Use AITER Multi-Head Attention kernels (defaults to **True** when AITER is on; set **0** to use Triton attention backends and Prefill-Decode attention backend instead). **See attention backend selection below.**

   * - ``VLLM_ROCM_USE_AITER_UNIFIED_ATTENTION``
     - Enable AITER's optimized unified attention kernel (defaults to **False**). Only takes effect when: (1) AITER is enabled, (2) unified attention mode is active (``VLLM_V1_USE_PREFILL_DECODE_ATTENTION=0``), and (3) AITER MHA is disabled (``VLLM_ROCM_USE_AITER_MHA=0``). When disabled, falls back to vLLM's Triton unified attention.

   * - ``VLLM_ROCM_USE_AITER_FP8BMM``
     - Use AITER FP8 batched matmul (defaults to **True** when AITER is on). Fuses FP8 per-token quantization with batched GEMM (used in MLA models like DeepSeek-V3). **Requires MI300X/MI355X.**

   * - ``VLLM_ROCM_USE_SKINNY_GEMM``
     - Prefer skinny-GEMM kernel variants for small batch sizes (defaults to **True**). Improves performance when ``M`` dimension is small. **Recommended: keep enabled.**

   * - ``VLLM_ROCM_FP8_PADDING``
     - Pad FP8 linear weight tensors to improve memory locality (defaults to **True**). Minor memory overhead for better performance.

   * - ``VLLM_ROCM_MOE_PADDING``
     - Pad MoE weight tensors for better memory access patterns (defaults to **True**). Same memory/performance tradeoff as FP8 padding.

   * - ``VLLM_ROCM_CUSTOM_PAGED_ATTN``
     - Use custom paged-attention decode kernel when Prefill-Decode attention backend is selected (defaults to **True**). **See attention backend selection below.**

.. note::

   When ``VLLM_ROCM_USE_AITER=1``, most AITER component flags (LINEAR, MOE, RMSNORM, MLA, MHA, FP8BMM) automatically default to **True**. You typically only need to set the master switch ``VLLM_ROCM_USE_AITER=1`` to enable all optimizations.

AITER MoE requirements (Mixtral, DeepSeek-V2/V3, Qwen-MoE models)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``VLLM_ROCM_USE_AITER_MOE`` enables AITER's optimized Mixture-of-Experts kernels, such as expert routing (topk selection) and expert computation for better performance.

**Applicable models:**

* Mixtral series: for example, Mixtral-8x7B / Mixtral-8x22B
* Llama-4 family: for example, Llama-4-Scout-17B-16E / Llama-4-Maverick-17B-128E
* DeepSeek family: DeepSeek-V2 / DeepSeek-V3 / DeepSeek-R1
* Qwen family: Qwen1.5-MoE / Qwen2-MoE / Qwen2.5-MoE series
* Other MoE architectures

**When to enable:**

* **Enable (default):** For all MoE models on MI300X/MI355X for best throughput
* **Disable:** Only for debugging or if you encounter numerical issues

**Example usage:**

.. code-block:: bash

   # Standard MoE model (Mixtral)
   VLLM_ROCM_USE_AITER=1 vllm serve mistralai/Mixtral-8x7B-Instruct-v0.1

   # Hybrid MoE+MLA model (DeepSeek-V3) - requires both MOE and MLA flags
   VLLM_ROCM_USE_AITER=1 vllm serve deepseek-ai/DeepSeek-V3 \
       --block-size 1 \
       --tensor-parallel-size 8

AITER MLA requirements (DeepSeek-V3/R1 models)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``VLLM_ROCM_USE_AITER_MLA`` enables AITER MLA (Multi-head Latent Attention) optimization for supported models. Defaults to **True** when AITER is on.

**Critical requirement:**

* **Must** explicitly set ``--block-size 1``

.. important::

   If you omit ``--block-size 1``, vLLM will raise an error rather than defaulting to 1.

**Applicable models:**

* DeepSeek-V3 / DeepSeek-R1
* DeepSeek-V2
* Other models using multi-head latent attention (MLA) architecture

**Example usage:**

.. code-block:: bash

   # DeepSeek-R1 with AITER MLA (requires 8 GPUs)
   VLLM_ROCM_USE_AITER=1 vllm serve deepseek-ai/DeepSeek-R1 \
       --block-size 1 \
       --tensor-parallel-size 8

Attention backend selection with AITER
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Understanding which attention backend to use helps optimize your deployment.

**Quick Reference: Which Attention Backend Will I Get?**

**Default Behavior (No Configuration)**

Without setting any environment variables, vLLM uses:

* **vLLM Triton Unified Attention** — A single Triton kernel handling both prefill and decode phases
* Works on all ROCm platforms
* Good baseline performance

**Recommended: Enable AITER (Set VLLM_ROCM_USE_AITER=1)**

When you enable AITER, the backend is automatically selected based on your model:

.. code-block:: text

   Is your model using MLA architecture? (DeepSeek-V3/R1/V2)
   ├─ YES → AITER MLA Backend
   │         • Requires --block-size 1
   │         • Best performance for MLA models
   │         • Automatically selected
   │
   └─ NO  → AITER MHA Backend
             • For standard transformer models (Llama, Mistral, etc.)
             • Optimized for MI300X/MI355X
             • Automatically selected

**Advanced: Manual Backend Selection**

Most users won't need this, but you can override the defaults:

.. list-table::
   :widths: 40 60
   :header-rows: 1

   * - To Use This Backend
     - Set These Flags

   * - AITER MLA (MLA models only)
     - ``VLLM_ROCM_USE_AITER=1`` (auto-selects for DeepSeek-V3/R1)

   * - AITER MHA (standard models)
     - ``VLLM_ROCM_USE_AITER=1`` (auto-selects for non-MLA models)

   * - AITER Triton Prefill-Decode (split)
     - | ``VLLM_ROCM_USE_AITER=1``
       | ``VLLM_ROCM_USE_AITER_MHA=0``
       | ``VLLM_V1_USE_PREFILL_DECODE_ATTENTION=1``

   * - vLLM Triton Unified (default)
     - ``VLLM_ROCM_USE_AITER=0`` (or unset)

   * - AITER Unified Attention
     - | ``VLLM_ROCM_USE_AITER=1``
       | ``VLLM_ROCM_USE_AITER_MHA=0``
       | ``VLLM_ROCM_USE_AITER_UNIFIED_ATTENTION=1``

**Quick Start Examples:**

.. code-block:: bash

   # Recommended: Standard model with AITER (Llama, Mistral, Qwen, etc.)
   VLLM_ROCM_USE_AITER=1 vllm serve meta-llama/Llama-3.3-70B-Instruct

   # MLA model with AITER (DeepSeek-V3/R1)
   VLLM_ROCM_USE_AITER=1 vllm serve deepseek-ai/DeepSeek-R1 \
       --block-size 1 \
       --tensor-parallel-size 8

   # Advanced: Use Prefill-Decode split (for short input cases)
   VLLM_ROCM_USE_AITER=1 \
   VLLM_ROCM_USE_AITER_MHA=0 \
   VLLM_V1_USE_PREFILL_DECODE_ATTENTION=1 \
   vllm serve meta-llama/Llama-3.3-70B-Instruct

**Which Backend Should I Choose?**

.. list-table::
   :widths: 30 70
   :header-rows: 1

   * - Your Use Case
     - Recommended Backend

   * - **Standard transformer models** (Llama, Mistral, Qwen, Mixtral)
     - **AITER MHA** (``VLLM_ROCM_USE_AITER=1``) — **Recommended for most workloads** on MI300X/MI355X. Provides optimized attention kernels for both prefill and decode phases.

   * - **MLA models** (DeepSeek-V3/R1/V2)
     - **AITER MLA** (auto-selected with ``VLLM_ROCM_USE_AITER=1``) — Required for optimal performance, must use ``--block-size 1``

   * - **gpt-oss models** (gpt-oss-120b/20b)
     - **AITER Unified Attention** (``VLLM_ROCM_USE_AITER=1``, ``VLLM_​ROCM_​USE_​AITER_​MHA=0``, ``VLLM_​ROCM_​USE_​AITER_​UNIFIED_​ATTENTION=1``) — Required for optimal performance

  * - **Debugging or compatibility**
     - **vLLM Triton Unified** (default with ``VLLM_ROCM_USE_AITER=0``) — Generic fallback, works everywhere

**Important Notes:**

* **AITER MHA and AITER MLA are mutually exclusive** — vLLM automatically detects MLA models and selects the appropriate backend
* **For 95% of users:** Simply set ``VLLM_ROCM_USE_AITER=1`` and let vLLM choose the right backend
* **When in doubt:** Start with AITER enabled (the recommended configuration) and profile your specific workload

Backend choice quick recipes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* **Standard transformers (any prompt length):** Start with ``VLLM_ROCM_USE_AITER=1`` → AITER MHA. For CUDA graph modes, see architecture-specific guidance below (Dense vs MoE models have different optimal modes).
* **Latency-sensitive chat (low TTFT):** keep ``--max-num-batched-tokens`` ≤ **8k–16k** with AITER.
* **Streaming decode (low ITL):** raise ``--max-num-batched-tokens`` to **32k–64k**.
* **Offline max throughput:** ``--max-num-batched-tokens`` ≥ **32k** with ``cudagraph_mode=FULL``.

**How to Verify Which Backend is Active**

Check vLLM's startup logs to confirm which attention backend is being used:

.. code-block:: bash

   # Start vLLM and check logs
   VLLM_ROCM_USE_AITER=1 vllm serve meta-llama/Llama-3.3-70B-Instruct 2>&1 | grep -i attention

**Expected log messages:**

* AITER MHA: ``Using Aiter Flash Attention backend on V1 engine.``
* AITER MLA: ``Using AITER MLA backend on V1 engine.``
* vLLM Triton MLA: ``Using Triton MLA backend on V1 engine.``
* vLLM Triton Unified: ``Using Triton Attention backend on V1 engine.``
* AITER Triton Unified: ``Using Aiter Unified Attention backend on V1 engine.``
* AITER Triton Prefill-Decode: ``Using Rocm Attention backend on V1 engine.``

Attention backend technical details
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This section provides technical details about vLLM's attention backends on ROCm.

vLLM V1 on ROCm provides these attention implementations:

1. **vLLM Triton Unified Attention** (default when AITER is **off**)

   * Single unified Triton kernel handling both chunked prefill and decode phases
   * Generic implementation that works across all ROCm platforms
   * Good baseline performance
   * Automatically selected when ``VLLM_ROCM_USE_AITER=0`` (or unset)
   * Support GPT-OSS

2. **AITER Triton Unified Attention** (advanced, requires manual configuration)

   * AMD's optimized unified Triton kernel
   * Enable with ``VLLM_ROCM_USE_AITER=1``, ``VLLM_ROCM_USE_AITER_MHA=0``, and ``VLLM_ROCM_USE_AITER_UNIFIED_ATTENTION=1``
   * Only useful for specific workloads; most users should use AITER MHA instead
   * Recommended this backend when running GPT-OSS.

3. **AITER Triton Prefill–Decode Attention** (hybrid, MI300X-optimized)

   * Enable with ``VLLM_ROCM_USE_AITER=1`` and ``VLLM_ROCM_USE_AITER_MHA=0`` and ``VLLM_V1_USE_PREFILL_DECODE_ATTENTION=1``
   * Uses separate kernels for prefill and decode phases:

     * **Prefill:** ``context_attention_fwd`` Triton kernel
     * **Primary decode:** ``torch.ops._rocm_C.paged_attention`` (custom ROCm kernel optimized for head sizes 64/128, block sizes 16/32, GQA 1–16, context ≤131k; sliding window not supported)
     * **Fallback decode:** ``kernel_paged_attention_2d`` Triton kernel when shapes don't meet primary decode requirements

   * Usually better compared to unified Triton kernels (both vLLM and AITER variants)
   * Performance vs AITER MHA varies: AITER MHA is typically faster overall, but Prefill-Decode split may win in short input scenarios
   * The custom paged attention decode kernel is controlled by ``VLLM_ROCM_CUSTOM_PAGED_ATTN`` (default **True**)

4. **AITER Multi-Head Attention (MHA)** (default when AITER is **on**)

   * Controlled by ``VLLM_ROCM_USE_AITER_MHA`` (**1** = enabled)
   * Best all-around performance for standard transformer models
   * Automatically selected when ``VLLM_ROCM_USE_AITER=1`` and model is not MLA

5. **vLLM Triton Multi-head Latent Attention (MLA)** (for DeepSeek-V3/R1/V2)
   
   * Automatically selected when ``VLLM_ROCM_USE_AITER=0`` (or unset)

6. **AITER Multi-head Latent Attention (MLA)** (for DeepSeek-V3/R1/V2)

   * Controlled by ``VLLM_ROCM_USE_AITER_MLA`` (**1** = enabled)
   * Required for optimal performance on MLA architecture models
   * Automatically selected when ``VLLM_ROCM_USE_AITER=1`` and model uses MLA
   * Requires ``--block-size 1``

Quick Reduce (large all-reduces on ROCm)
-----------------------------------------

**Quick Reduce** is an alternative to RCCL/custom all-reduce for **large** inputs (MI300-class GPUs).
It supports FP16/BF16 as well as symmetric INT8/INT6/INT4 quantized all-reduce (group size 32).

.. warning::

   Quantization can affect accuracy. Validate quality before deploying.

Control via:

* ``VLLM_ROCM_QUICK_REDUCE_QUANTIZATION`` ∈ ``["NONE","FP","INT8","INT6","INT4"]`` (default ``NONE``).
* ``VLLM_ROCM_QUICK_REDUCE_CAST_BF16_TO_FP16``: cast BF16 input to FP16 (``1/True`` by default for performance).
* ``VLLM_ROCM_QUICK_REDUCE_MAX_SIZE_BYTES_MB``: cap the preset buffer (default ``NONE`` ≈ ``2048`` MB).

Quick Reduce tends to help **throughput** at higher TP counts (e.g., 4–8) with many concurrent requests.

Parallelism strategies (run vLLM on multiple GPUs)
---------------------------------------------------

vLLM supports the following parallelism strategies:

1. Tensor parallelism
2. Pipeline parallelism
3. Data parallelism
4. Expert parallelism

For more details, see `Parallelism and scaling <https://docs.vllm.ai/en/stable/serving/parallelism_scaling.html>`_.

**Choosing the right strategy:**

* **Tensor Parallelism (TP)**: Use when model doesn't fit on one GPU. Prefer staying within a single XGMI island (≤8 GPUs on MI300X).
* **Pipeline Parallelism (PP)**: Use for very large models across nodes. Set TP to GPUs per node, scale with PP across nodes.
* **Data Parallelism (DP)**: Use when model fits on single GPU or TP group, and you need higher throughput. Combine with TP/PP for large models.
* **Expert Parallelism (EP)**: Use for MoE models with ``--enable-expert-parallel``. More efficient than TP for MoE layers.

Tensor parallelism
^^^^^^^^^^^^^^^^^^

Tensor parallelism splits each layer of the model weights across multiple GPUs when the model doesn't fit on a single GPU. This is primarily for memory capacity.

**Use tensor parallelism when:**

* Model does not fit on one GPU (OOM)
* Need to enable larger batch sizes by distributing KV cache across GPUs

**Examples:**

.. code-block:: bash

   # Tensor parallelism: Split model across 2 GPUs
   vllm serve /path/to/model --dtype float16 --tensor-parallel-size 2

   # Combining TP and two vLLM instance, each split across 2 GPUs (4 GPUs total)
   CUDA_VISIBLE_DEVICES=0,1 vllm serve /path/to/model --dtype float16 --tensor-parallel-size 2 --port 8000
   CUDA_VISIBLE_DEVICES=2,3 vllm serve /path/to/model --dtype float16 --tensor-parallel-size 2 --port 8001

.. note::
   **ROCm GPU visibility:** vLLM on ROCm reads ``CUDA_VISIBLE_DEVICES``. Keep ``HIP_VISIBLE_DEVICES`` unset to avoid conflicts.

.. tip::
   For structured data parallelism deployments with load balancing, see :ref:`data-parallelism-section`.

Pipeline parallelism
^^^^^^^^^^^^^^^^^^^^

Pipeline parallelism splits the model's layers across multiple GPUs or nodes, with each GPU processing different layers sequentially. This is primarily used for multi-node deployments where the model is too large for a single node.

**Use pipeline parallelism when:**

* Model is too large for a single node (combine PP with TP)
* GPUs on a node lack high-speed interconnect (e.g., no NVLink/XGMI) - PP may perform better than TP
* GPU count doesn't evenly divide the model (PP supports uneven splits)

**Common pattern for multi-node:**

.. code-block:: bash

   # 2 nodes × 8 GPUs = 16 GPUs total
   # TP=8 per node, PP=2 across nodes
   vllm serve meta-llama/Llama-3.1-405B-Instruct \
       --tensor-parallel-size 8 \
       --pipeline-parallel-size 2

.. note::
   **ROCm best practice:** On MI300X, prefer staying within a single XGMI island (≤8 GPUs) using TP only. Use PP when scaling beyond 8 GPUs or across nodes.

.. _data-parallelism-section:

Data parallelism
^^^^^^^^^^^^^^^^

Data parallelism replicates model weights across separate instances/GPUs to process independent batches of requests. This approach increases throughput by distributing the workload across multiple replicas.

**Use data parallelism when:**

* Model fits on one GPU, but you need higher request throughput
* Scaling across multiple nodes horizontally
* Combining with tensor parallelism (e.g., DP=2 + TP=4 = 8 GPUs total)

**Quick start - single-node:**

.. code-block:: bash

   # Model fit in 1 GPU. Creates 2 model replicas (requires 2 GPUs)
   vllm serve /path/to/model --data-parallel-size 2

Choosing a load balancing strategy
"""""""""""""""""""""""""""""""""""

vLLM supports two modes for routing requests to DP ranks:

.. list-table::
   :header-rows: 1
   :widths: 30 35 35

   * -
     - **Internal LB** (recommended)
     - **External LB**
   * - **HTTP endpoints**
     - 1 endpoint, vLLM routes internally
     - N endpoints, you provide external router
   * - **Single-node config**
     - ``--data-parallel-size N``
     - ``--data-parallel-size N --data-parallel-rank 0..N-1`` + different ports
   * - **Multi-node config**
     - ``--data-parallel-size``, ``--data-parallel-size-local``, ``--data-parallel-address``
     - ``--data-parallel-size N --data-parallel-rank 0..N-1`` + ``--data-parallel-address``
   * - **Client view**
     - Single URL/port
     - Multiple URLs/ports
   * - **Load balancer**
     - Built-in (vLLM handles)
     - External (Nginx, Kong, K8s Service)
   * - **Coordination**
     - DP ranks sync via RPC (for MoE/MLA)
     - DP ranks sync via RPC (for MoE/MLA)
   * - **Best for**
     - Most deployments (simpler)
     - K8s/cloud environments with existing LB

.. tip::
   **Dense (non-MoE) models only:** You can run fully independent ``vllm serve`` instances without any DP flags, using your own load balancer. This avoids RPC coordination overhead entirely.

For more technical details, see `vLLM Data Parallel Deployment <https://docs.vllm.ai/en/stable/serving/data_parallel_deployment.html>`_

Data Parallel Attention (advanced)
""""""""""""""""""""""""""""""""""

For models with Multi-head Latent Attention (MLA) architecture like DeepSeek V2, V3, and R1, vLLM supports **Data Parallel Attention**,
which provides request-level parallelism instead of model replication. This avoids KV cache duplication across tensor parallel ranks,
significantly reducing memory usage and enabling larger batch sizes.

**Key benefits for MLA models:**

* Eliminates KV cache duplication when using tensor parallelism
* Enables higher throughput for high-QPS serving scenarios
* Better memory efficiency for large context windows

**Usage with Expert Parallelism:**

Data parallel attention works seamlessly with Expert Parallelism for MoE models:

.. code-block:: bash

   # DeepSeek-R1 with DP attention and expert parallelism
   VLLM_ALL2ALL_BACKEND="allgather_reducescatter" vllm serve deepseek-ai/DeepSeek-R1 \
       --data-parallel-size 8 \
       --enable-expert-parallel \
       --disable-nccl-for-dp-synchronization

For more technical details, see `vLLM RFC #16037 <https://github.com/vllm-project/vllm/issues/16037>`_.

Expert parallelism
^^^^^^^^^^^^^^^^^^

Expert parallelism (EP) distributes expert layers of Mixture-of-Experts (MoE) models across multiple GPUs,
where tokens are routed to the GPUs holding the experts they need.

**Performance considerations:**

Expert parallelism is designed primarily for cross-node MoE deployments where high-bandwidth interconnects (like InfiniBand) between nodes make EP communication efficient. For single-node MI300X/MI355X deployments with XGMI connectivity, **tensor parallelism typically provides better performance** due to optimized all-to-all collectives on XGMI.

**When to use EP:**

* Multi-node MoE deployments with fast inter-node networking
* Models with very large numbers of experts that benefit from expert distribution
* Workloads where EP's reduced data movement outweighs communication overhead

**Single-node recommendation:** For MI300X/MI355X within a single node (≤8 GPUs), prefer tensor parallelism over expert parallelism for MoE models to leverage XGMI's high bandwidth and low latency.

**Basic usage:**

.. code-block:: bash

   # Enable expert parallelism for MoE models (DeepSeek example with 8 GPUs)
   vllm serve deepseek-ai/DeepSeek-R1 \
       --tensor-parallel-size 8 \
       --enable-expert-parallel

**Combining with Tensor Parallelism:**

When EP is enabled alongside tensor parallelism:

* Fused MoE layers use expert parallelism
* Non-fused MoE layers use tensor parallelism

**Combining with Data Parallelism:**

EP works seamlessly with Data Parallel Attention for optimal memory efficiency in MLA+MoE models (e.g., DeepSeek V3):

.. code-block:: bash

   # DP attention + EP for DeepSeek-R1
   VLLM_ALL2ALL_BACKEND="allgather_reducescatter" vllm serve deepseek-ai/DeepSeek-R1 \
       --data-parallel-size 8 \
       --enable-expert-parallel \
       --disable-nccl-for-dp-synchronization

Throughput benchmarking
-----------------------

This guide evaluates LLM inference by tokens per second (TPS). vLLM provides a
built-in benchmark:

.. code-block:: bash

   # Synthetic or dataset-driven benchmark

   vllm bench throughput --model /path/to/model [other args]

* **Real-world dataset** (ShareGPT) example:

  .. code-block:: bash

     wget https://huggingface.co/datasets/anon8231489123/ShareGPT_Vicuna_unfiltered/resolve/main/ShareGPT_V3_unfiltered_cleaned_split.json

     vllm bench throughput --model /path/to/model  --dataset /path/to/ShareGPT_V3_unfiltered_cleaned_split.json

* **Synthetic**: set fixed ``--input-len`` and ``--output-len`` for reproducible runs.

.. tip::

   **Profiling checklist (ROCm)**

   1. Fix your prompt distribution (ISL/OSL) and **vary one knob at a time** (graph mode, MBT).
   2. Measure **TTFT**, **ITL**, and **TPS** together; don't optimize one in isolation.
   3. Compare graph modes: **PIECEWISE** (balanced) vs **FULL**/``FULL_DECODE_ONLY`` (max throughput).
   4. Sweep ``--max-num-batched-tokens`` around **8k–64k** to find your latency/throughput balance.

Maximizing instances per node
-----------------------------

To maximize **per-node throughput**, run as many vLLM instances as model memory allows,
balancing KV-cache capacity.

* **HBM capacities**: MI300X = 192 GB HBM3; MI355X = 288 GB HBM3E.

* Up to **eight** single-GPU vLLM instances can run in parallel on an 8×GPU node (one per GPU):

  .. code-block:: bash

      for i in $(seq 0 7); do
         CUDA_VISIBLE_DEVICES="$i" vllm bench throughput 
         -tp 1 --model /path/to/model 
         --dataset /path/to/ShareGPT_V3_unfiltered_cleaned_split.json &
      done

Total throughput from **N** single-GPU instances usually exceeds one instance stretched across **N** GPUs (`-tp N`).

**Model coverage**: Llama 2 (7B/13B/70B), Llama 3 (8B/70B), Qwen2 (7B/72B), Mixtral-8x7B/8x22B, etc. Llama2‑70B
and Llama3‑70B can fit a single MI300X/MI355X; Llama3.1‑405B fits on a single 8×MI300X/MI355X node.

Configure the ``gpu-memory-utilization`` parameter
--------------------------------------------------

The ``--gpu-memory-utilization`` parameter controls the fraction of GPU memory reserved for the KV-cache. The default is **0.9** (90%).

There are two strategies:

1. **Increase** ``--gpu-memory-utilization`` to maximize throughput for a single instance (up to **0.95**).
   Example:

   .. code-block:: bash

      vllm serve meta-llama/Llama-3.3-70B-Instruct \
         --gpu-memory-utilization 0.95 \
         --max-model-len 8192 \
         --port 8000

2. **Decrease** to pack **multiple** instances on the same GPU (for small models like 7B/8B), keeping KV-cache viable:

   .. code-block:: bash

      # Instance 1 on GPU 0
      CUDA_VISIBLE_DEVICES=0 vllm serve meta-llama/Llama-3.1-8B-Instruct \
         --gpu-memory-utilization 0.45 \
         --max-model-len 4096 \
         --port 8000

      # Instance 2 on GPU 0
      CUDA_VISIBLE_DEVICES=0 vllm serve meta-llama/Llama-Guard-3-8B \
         --gpu-memory-utilization 0.45 \
         --max-model-len 4096 \
         --port 8001

vLLM engine arguments
---------------------

Selected arguments that often help on ROCm. See `engine args docs <https://docs.vllm.ai/en/latest/serving/engine_args.html>`_ for the full list.

Configure ``--max-num-seqs``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The default value is **1024** in vLLM V1 (increased from **256** in V0). This flag controls the maximum number of sequences processed per batch, directly affecting concurrency and memory usage.

* **To increase throughput**: Raise to **2048** or **4096** if memory allows, enabling more sequences per iteration.
* **To reduce memory usage**: Lower to **256** or **128** for large models or long-context generation. For example, set ``--max-num-seqs 128`` to reduce concurrency and lower memory requirements.

In vLLM V1, KV-cache token requirements are computed as ``max-num-seqs * max-model-len``.

Example usage:

.. code-block:: bash

   vllm serve <model> --max-num-seqs 128 --max-model-len 8192

Configure ``--max-num-batched-tokens``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Chunked prefill is enabled by default** in vLLM V1.

* Lower values improve **ITL** (less prefill interrupting decode).
* Higher values improve **TTFT** (more prefill per batch).

Defaults: **8192** for online serving, **16384** for offline. However, optimal values vary significantly by model size—smaller models can efficiently handle larger batch sizes. Setting it near ``--max-model-len`` mimics V0 behavior and often maximizes throughput.

**Guidance:**

* **Interactive (low TTFT)**: keep MBT ≤ **8k–16k**.
* **Streaming (low ITL)**: MBT **16k–32k**.
* **Offline max throughput**: MBT **≥32k** (diminishing TPS returns beyond ~32k).

**Pattern:** Smaller/more efficient models benefit from larger batch sizes. MoE models with expert parallelism can handle very large batches efficiently.

**Rule of thumb**

* Push MBT **up** to trade TTFT↑ for ITL↓ and slightly higher TPS.
* Pull MBT **down** to trade ITL↑ for TTFT↓ (interactive UX).

Async scheduling
^^^^^^^^^^^^^^^^

``--async-scheduling`` (replaces deprecated ``num_scheduler_steps``) can improve throughput/ITL by trading off TTFT.
Prefer **off** for latency-sensitive serving; **on** for offline batch throughput.

CUDA graphs configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^

CUDA graphs reduce kernel launch overhead by capturing and replaying GPU operations, improving inference throughput. Configure using ``--compilation-config '{"cudagraph_mode": "MODE"}'``.

**Available modes:**

* ``NONE`` — CUDA graphs disabled (debugging)
* ``PIECEWISE`` — Attention stays eager, other ops use CUDA graphs (most compatible)
* ``FULL`` — Full CUDA graphs for all batches (best for small models/prompts)
* ``FULL_DECODE_ONLY`` — Full CUDA graphs only for decode (saves memory in prefill/decode split setups)
* ``FULL_AND_PIECEWISE`` — **(default)** Full graphs for decode + piecewise for prefill (best performance, highest memory)

**Default behavior:** V1 defaults to ``FULL_AND_PIECEWISE`` with piecewise compilation enabled; otherwise ``NONE``.

**Backend compatibility:** Not all attention backends support all CUDA graph modes. Choose a mode your backend supports:

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Attention backend
     - CUDA graph support
   * - vLLM/AITER Triton Unified Attention, vLLM Prefill-Decode Attention
     - Full support (prefill + decode)
   * - AITER MHA, AITER MLA
     - Uniform batches only
   * - vLLM Triton MLA
     - Must exclude attention from graph — ``PIECEWISE`` required

**Usage examples:**

.. code-block:: bash

   # Default (best performance, highest memory)
   vllm serve meta-llama/Llama-3.1-8B-Instruct

   # Decode-only graphs (lower memory, good for P/D split)
   vllm serve meta-llama/Llama-3.1-8B-Instruct \
     --compilation-config '{"cudagraph_mode": "FULL_DECODE_ONLY"}'

   # Full graphs for offline throughput (small models)
   vllm serve meta-llama/Llama-3.1-8B-Instruct \
     --compilation-config '{"cudagraph_mode": "FULL"}'

**Migration from legacy flags:**

* ``use_cudagraph=False`` → ``NONE``
* ``use_cudagraph=True, full_cuda_graph=False`` → ``PIECEWISE``
* ``full_cuda_graph=True`` → ``FULL`` (with automatic fallback)

Quantization support
--------------------

vLLM supports FP4/FP8 (4-bit/8-bit floating point) weight and activation quantization using hardware acceleration on the Instinct MI300X and MI355X. 
Quantization of models with FP4/FP8 allows for a **2x-4x** reduction in model memory requirements and up to a **1.6x** 
improvement in throughput with minimal impact on accuracy. 

vLLM ROCm supports a variety of quantization demands: 

1. On-the-fly quantization 

2. Pre-quantized model through Quark and llm-compressor 

Supported Quantization Methods
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

vLLM on ROCm supports the following quantization methods for AMD MI300 series and MI355X GPUs:

.. list-table::
   :header-rows: 1
   :widths: 20 15 15 20 30

   * - Method
     - Precision
     - ROCm Support
     - Memory Reduction
     - Best Use Case
   * - **FP8** (W8A8)
     - 8-bit float
     - ✅ Excellent
     - 2× (50%)
     - Production, balanced speed/accuracy
   * - **PTPC-FP8**
     - 8-bit float
     - ✅ Excellent
     - 2× (50%)
     - High throughput, better than FP8
   * - **AWQ**
     - 4-bit int (W4A16)
     - ✅ Good
     - 4× (75%)
     - Large models, memory-constrained
   * - **GPTQ**
     - 4-bit/8-bit int
     - ✅ Good
     - 2-4× (50-75%)
     - Pre-quantized models available
   * - **FP8 KV-cache**
     - 8-bit float
     - ✅ Excellent
     - KV cache: 50%
     - All inference workloads
   * - **Quark (AMD)**
     - FP8/MXFP4
     - ✅ Optimized
     - 2-4× (50-75%)
     - AMD pre-quantized models
   * - **compressed-tensors**
     - W8A8 INT8/FP8
     - ✅ Good
     - 2× (50%)
     - LLM Compressor models

**Key:**

- ✅ Excellent: Fully supported with optimized kernels
- ✅ Good: Supported, may not have AMD-optimized kernels
- ✅ Optimized: AMD-specific optimizations available

Using Pre-quantized Models
^^^^^^^^^^^^^^^^^^^^^^^^^^^

AMD provides pre-quantized models optimized for ROCm. These models are ready to use with vLLM.

**AMD Quark Quantized Models:**

Available on `Hugging Face <https://huggingface.co/models?other=quark>`_:

  * `Llama‑3.1‑8B‑Instruct‑FP8‑KV <https://huggingface.co/amd/Llama-3.1-8B-Instruct-FP8-KV>`__ (FP8 W8A8)
  * `Llama‑3.1‑70B‑Instruct‑FP8‑KV <https://huggingface.co/amd/Llama-3.1-70B-Instruct-FP8-KV>`__ (FP8 W8A8)
  * `Llama‑3.1‑405B‑Instruct‑FP8‑KV <https://huggingface.co/amd/Llama-3.1-405B-Instruct-FP8-KV>`__ (FP8 W8A8)
  * `Mixtral‑8x7B‑Instruct‑v0.1‑FP8‑KV <https://huggingface.co/amd/Mixtral-8x7B-Instruct-v0.1-FP8-KV>`__ (FP8 W8A8)
  * `Mixtral‑8x22B‑Instruct‑v0.1‑FP8‑KV <https://huggingface.co/amd/Mixtral-8x22B-Instruct-v0.1-FP8-KV>`__ (FP8 W8A8)
  * `Llama-3.3-70B-Instruct-MXFP4-Preview <https://huggingface.co/amd/Llama-3.3-70B-Instruct-MXFP4-Preview>`__ (MXFP4)
  * `Llama-3.1-405B-Instruct-MXFP4-Preview <https://huggingface.co/amd/Llama-3.1-405B-Instruct-MXFP4-Preview>`__ (MXFP4)
  * `DeepSeek-R1-0528-MXFP4-Preview <https://huggingface.co/amd/DeepSeek-R1-0528-MXFP4-Preview>`__ (MXFP4)

**Quick Start:**

.. code-block:: bash

   # FP8 W8A8 Quark model
   vllm serve amd/Llama-3.1-8B-Instruct-FP8-KV \
      --dtype auto

   # MXFP4 Quark model
   vllm serve amd/Llama-3.3-70B-Instruct-MXFP4-Preview \
      --dtype auto \
      --tensor-parallel-size 1

**Other Pre-quantized Models:**

- **AWQ models**: `Hugging Face awq flag <https://huggingface.co/models?other=awq>`_
- **GPTQ models**: `Hugging Face gptq flag <https://huggingface.co/models?other=gptq>`_
- **LLM Compressor models**: `Hugging Face compressed-tensors flag <https://huggingface.co/models?other=compressed-tensors>`_

On-the-fly Quantization
^^^^^^^^^^^^^^^^^^^^^^^^

For models without pre-quantization, vLLM can quantize FP16/BF16 models at server startup.

**Supported Methods:**

- ``fp8``: Per-tensor FP8 weight and activation quantization
- ``ptpc_fp8``: Per-token-activation per-channel-weight FP8 (better accuracy same FP8 speed). See `PTPC-FP8 on ROCm blog post <https://blog.vllm.ai/2025/02/24/ptpc-fp8-rocm.html>`_ for details

**Usage:**

.. code-block:: bash

   # On-the-fly FP8 quantization
   vllm serve meta-llama/Llama-3.1-8B-Instruct \
      --quantization fp8 \
      --dtype auto

   # On-the-fly PTPC-FP8 (recommended as default)
   vllm serve meta-llama/Llama-3.1-70B-Instruct \
      --quantization ptpc_fp8 \
      --dtype auto \
      --tensor-parallel-size 4

**Note:** On-the-fly quantization adds 2-5 minutes startup time but eliminates pre-quantization. For production with frequent restarts, use pre-quantized models.

GPTQ
^^^^

GPTQ is a 4-bit/8-bit weight quantization method that compresses models with minimal accuracy loss. GPTQ
is fully supported on ROCm via HIP-compiled kernels in vLLM.

**ROCm Support Status:**

- ✅ **Fully supported** - GPTQ kernels compile and run on ROCm via HIP
- ✅ **Pre-quantized models work** with standard GPTQ kernels

**Recommendation:** For AMD MI300X, **AWQ with Triton kernels** or **FP8 quantization** may provide better
performance due to ROCm-specific optimizations, but GPTQ is a viable alternative.

**Using Pre-quantized GPTQ Models:**

.. code-block:: bash

   # Using pre-quantized GPTQ model on ROCm
   vllm serve RedHatAI/Meta-Llama-3.1-70B-Instruct-quantized.w4a16 \
      --quantization gptq \
      --dtype auto \
      --tensor-parallel-size 1

**Important Notes:**

- **Kernel support:** GPTQ uses standard HIP-compiled kernels on ROCm
- **Performance:** AWQ with Triton kernels may offer better throughput on AMD GPUs due to ROCm optimizations
- **Compatibility:** GPTQ models from Hugging Face work on ROCm with standard performance
- **Use case:** GPTQ is suitable when pre-quantized GPTQ models are readily available

AWQ (Activation-aware Weight Quantization)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

AWQ (Activation-aware Weight Quantization) is a 4-bit weight quantization technique that provides excellent
model compression with minimal accuracy loss (<1%). ROCm supports AWQ quantization on AMD MI300 series and
MI355X GPUs with vLLM.

**Using Pre-quantized AWQ Models:**

Many AWQ-quantized models are available on Hugging Face. Use them directly with vLLM:

.. code-block:: bash

   # vLLM serve with AWQ model
   VLLM_USE_TRITON_AWQ=1 \
   vllm serve hugging-quants/Meta-Llama-3.1-70B-Instruct-AWQ-INT4 \
      --quantization awq \
      --tensor-parallel-size 1 \
      --dtype auto 

**Important Notes:**

* **ROCm requirement:** Set ``VLLM_USE_TRITON_AWQ=1`` to enable Triton-based AWQ kernels on ROCm
* **dtype parameter:** AWQ requires ``--dtype auto`` or ``--dtype float16``. The ``--dtype`` flag controls
  the **activation dtype** (FP16/BF16 for computations), not the weight dtype. AWQ weights remain as INT4
  (4-bit integers) as specified in the model's quantization config, but are dequantized to FP16/BF16 during
  matrix multiplication operations.
* **Group size:** 128 is recommended for optimal performance/accuracy balance
* **Model compatibility:** AWQ is primarily tested on Llama, Mistral, and Qwen model families

Quark (AMD Quantization Toolkit)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

AMD Quark is AMD's quantization toolkit optimized for ROCm. It supports FP8 W8A8, MXFP4, W8A8 INT8, and
other quantization formats with native vLLM integration. The quantization format will automatically be inferred
from the model config file, thus we can omit `--quantization quark`.

**Running Quark Models:**

.. code-block:: bash

   # FP8 W8A8: Single GPU
   vllm serve amd/Llama-3.1-8B-Instruct-FP8-KV \
      --dtype auto \
      --max-model-len 8192 \
      --gpu-memory-utilization 0.90

   # MXFP4: Extreme memory efficiency
   vllm serve amd/Llama-3.3-70B-Instruct-MXFP4-Preview \
      --dtype auto \
      --tensor-parallel-size 1 \
      --max-model-len 8192

**Key Features:**

- **FP8 models**: ~50% memory reduction, 2× compression
- **MXFP4 models**: ~75% memory reduction, 4× compression
- **Embedded scales**: Quark FP8-KV models include pre-calibrated KV-cache scales
- **Hardware optimized**: Leverages AMD MI300 series FP8 acceleration

For creating your own Quark-quantized models, see `Quark Documentation <https://quark.docs.amd.com/latest/>`_.

FP8 `kv-cache` dtype
^^^^^^^^^^^^^^^^^^^^

FP8 KV-cache quantization reduces memory footprint by approximately 50%, enabling longer context lengths
or higher concurrency. ROCm supports FP8 KV-cache with both ``fp8_e4m3`` and ``fp8_e5m2`` formats on
AMD MI300 series and other CDNA™ GPUs.

Use ``--kv-cache-dtype fp8`` to enable FP8 KV-cache quantization. For best accuracy, use calibrated
scaling factors generated via `LLM Compressor <https://github.com/vllm-project/llm-compressor>`_.
Without calibration, scales are calculated dynamically (``--calculate-kv-scales``) with minimal
accuracy impact.


**Quick Start (Dynamic Scaling):**

.. code-block:: bash

   # vLLM serve with dynamic FP8 KV-cache
   vllm serve meta-llama/Llama-3.1-8B-Instruct \
      --kv-cache-dtype fp8 \
      --calculate-kv-scales \
      --gpu-memory-utilization 0.90

**Calibrated Scaling (Advanced):**

For optimal accuracy, pre-calibrate KV-cache scales using representative data. The calibration process:

#. Runs the model on calibration data (512+ samples recommended)
#. Computes optimal FP8 quantization scales for key/value cache tensors
#. Embeds these scales into the saved model as additional parameters
#. vLLM loads the model and uses the embedded scales automatically when ``--kv-cache-dtype fp8`` is specified

The quantized model can be used like any other model—the embedded scales are stored as part of the model weights.

**Using pre-calibrated models:**

AMD provides ready-to-use models with pre-calibrated FP8 KV cache scales:

* `amd/Llama-3.1-8B-Instruct-FP8-KV <https://huggingface.co/amd/Llama-3.1-8B-Instruct-FP8-KV>`_
* `amd/Llama-3.3-70B-Instruct-FP8-KV <https://huggingface.co/amd/Llama-3.3-70B-Instruct-FP8-KV>`_

To verify a model has pre-calibrated KV cache scales, check ``config.json`` for:

.. code-block:: json

   "quantization_config": {
     "kv_cache_scheme": "static"  // Indicates pre-calibrated scales are embedded
   }

**Creating your own calibrated model:**

.. code-block:: bash

   # 1. Install LLM Compressor
   pip install llmcompressor

   # 2. Run calibration script (see llm-compressor repo for full example)
   python llama3_fp8_kv_example.py

   # 3. Use calibrated model in vLLM
   vllm serve ./Meta-Llama-3-8B-Instruct-FP8-KV \
      --kv-cache-dtype fp8

For detailed instructions and the complete calibration script, see the `FP8 KV Cache Quantization Guide <https://github.com/vllm-project/llm-compressor/blob/main/examples/quantization_kv_cache/README.md>`_.

**Format Options:**

- ``fp8`` or ``fp8_e4m3``: Higher precision (default, recommended)
- ``fp8_e5m2``: Larger dynamic range, slightly lower precision

Speculative decoding (experimental)
-----------------------------------

Recent vLLM versions add support for speculative decoding backends (e.g., Eagle‑v3). Evaluate for your model and latency/throughput goals.
Speculative decoding is a technique to reduce latency when max number of concurrency is low. 
Depending on the methods, the effective concurrency varies, e.g. 16 to 64.

Example command:

.. code-block:: bash

   vllm serve meta-llama/Llama-3.1-8B-Instruct \
      --trust-remote-code \
      --swap-space 16 \
      --disable-log-requests \
      --tensor-parallel-size 1 \
      --distributed-executor-backend mp \
      --dtype float16 \
      --quantization fp8 \
      --kv-cache-dtype fp8 \
      --no-enable-chunked-prefill \
      --max-num-seqs 300 \
      --max-num-batched-tokens 131072 \
      --gpu-memory-utilization 0.8 \
      --speculative_config '{"method": "eagle3", "model": "yuhuili/EAGLE3-LLaMA3.1-Instruct-8B", "num_speculative_tokens": 2, "draft_tensor_parallel_size": 1, "dtype": "float16"}' \
      --port 8001

Multi-node checklist & troubleshooting
--------------------------------------

1. Use ``--distributed-executor-backend ray`` across nodes to manage HIP-visible ranks and RCCL communicators. (Ray is the default for multi-node; explicitly setting this flag is optional.)
2. Ensure ``/dev/shm`` is shared across ranks (Docker ``--shm-size``, Kubernetes ``emptyDir``), as RCCL uses shared memory for rendezvous.
3. For GPUDirect RDMA, set ``RCCL_NET_GDR_LEVEL=2`` and verify links (``ibstat``). Requires supported NICs (e.g., ConnectX‑6+).
4. Collect RCCL logs: ``RCCL_DEBUG=INFO`` and optionally ``RCCL_DEBUG_SUBSYS=INIT,GRAPH`` for init/graph stalls.

.. note::

   See also:

   * vLLM how-to and performance: https://rocm.docs.amd.com/en/latest/how-to/rocm-for-ai/inference-optimization/workload.html#vllm-performance-optimization
   * vLLM benchmark Docker (with ROCm, PyTorch, vLLM): https://rocm.docs.amd.com/en/latest/how-to/rocm-for-ai/inference/benchmark-docker/vllm.html

.. _mi300x-tunableop:

PyTorch TunableOp
==================

`TunableOp <https://github.com/pytorch/pytorch/blob/main/aten/src/ATen/cuda/tunable/README.md>`_
is a feature used to obtain the optimal GPU kernel for a key PyTorch operations. At the moment,
TunableOp supports the tuning of dense matrix multiplies (GEMM, batched GEMM, GEMM and bias, and scaled GEMM).
This feature is useful for squeezing out the last bit of performance.
In short, it will try up to thousands of matrix multiply algorithms that are available in rocBLAS and hipBLASLt.
A caveat is that as the math libraries improve over time, there is a less benefit to using TunableOp,
and there is also no guarantee that the workload being tuned will be able to outperform the default GEMM algorithm in hipBLASLt.

Some additional references for PyTorch TunableOp include `ROCm blog <https://rocm.blogs.amd.com/artificial-intelligence/pytorch-tunableop/README.html>`__, 
TunableOp `README <https://github.com/pytorch/pytorch/blob/main/aten/src/ATen/cuda/tunable/README.md>`__, and 
`llm tuning <https://rocm.docs.amd.com/en/latest/how-to/llm-fine-tuning-optimization/model-acceleration-libraries.html#fine-tuning-llms-pytorch-tunableop>`__.

The three most important environment variables for controlling TunableOp are:

``PYTORCH_TUNABLEOP_ENABLED``
   The main on/off switch for all TunableOp implementations. Default is ``0`` (disabled). Set to ``1`` to enable.

``PYTORCH_TUNABLEOP_TUNING``
   When enabled, if a tuned entry isn't found, runs the tuning step and records the entry. Default is ``1`` (enabled). Set to ``0`` to disable.

``PYTORCH_TUNABLEOP_VERBOSE``
   Enables verbose output for debugging purposes -- it can be useful to see if TunableOp is being used at all. Default is ``0`` (disabled). Set to ``1`` to enable.

For the complete list of environment variables, see the
TunableOp `README <https://github.com/pytorch/pytorch/blob/main/aten/src/ATen/cuda/tunable/README.md>`__.
There are also Python APIs to set some of these environment variables,
but the preferred way to set the TunableOp tuning parameters is to use the environment variables.

Workflow
--------

Use these environment variables to enable TunableOp for any applications or libraries that use PyTorch (2.3 or later).

The first step is the tuning pass:

1. Enable TunableOp and tuning. Optionally enable verbose mode: 

   .. code-block:: shell

      PYTORCH_TUNABLEOP_ENABLED=1 PYTORCH_TUNABLEOP_VERBOSE=1 your_script.sh

   This pass can be very slow. The output will be the ``tunableop_results.csv`` file containing a list of GEMMs encountered
   and the optimal GPU kernel that was identified.



   Multi-GPU tuning is supported, producing a separate tunableop_results.csv file for each GPU. The
   tuning algorithm executes independently on each GPU, with each tuning process sandboxed to its
   respective GPU. There is no inter-GPU communication during tuning.

   For data-parallel algorithms, where GEMM configurations across GPUs are typically identical, this
   approach can result in redundant work. In such cases, running the workload on a single GPU might
   suffice. However, for algorithms involving multiple levels of parallelism (as in data parallelism
   combined with ML model parallelism), different GPUs might require distinct GEMM parameters. In
   these scenarios, a multi-GPU configuration is recommended.

In the second step, we re-run the workload with optimal configuration using the ``tunableop_results.csv`` file obtained in step 1.

2. Enable TunableOp, disable tuning, and measure:

   .. code-block:: shell

      PYTORCH_TUNABLEOP_ENABLED=1 PYTORCH_TUNABLEOP_TUNING=0 your_script.sh

Compare the wall-clock time from this second step to your reference wall-clock time with TunableOp completely disabled (``PYTORCH_TUNABLEOP_ENABLED=0``).

Offline tuning
--------------

A new feature of TunableOp, offline tuning, is available in upstream PyTorch and supported in PyTorch 2.6 or later.

Traditionally, tuning is performed in-place during workload execution. While convenient for one-off
tuning, this approach can become cumbersome if frequent re-tuning is required -- such as when a new
version of a math library is released. In these cases, re-running the workload and performing tuning
repeatedly can be inefficient.

Offline tuning addresses this challenge by decoupling the tuning process from workload execution. It
enables the collection of GEMMs from a workload during a collection pass, followed by tuning these
GEMMs in a separate tuning pass, without re-running the original workload. This approach
significantly reduces compute resource requirements, particularly for time-intensive workloads.

For workflow instructions, refer to the `Offline Tuning documentation <https://github.com/pytorch/pytorch/blob/main/aten/src/ATen/cuda/tunable/README.md#offline-tuning>`_.

.. _mi300x-torchinductor-tuning:

PyTorch inductor max-autotune tuning knobs
==========================================

The following are suggestions for optimizing matrix multiplication (GEMM) and
convolution (``conv``) operations in PyTorch using ``inductor``, a part of the
PyTorch compilation framework.

Learn more about TorchInductor environment variables and usage in the
`PyTorch documentation <https://pytorch.org/docs/2.3/torch.compiler_inductor_profiling.html>`_.

.. note::

   Triton is not used if regular :doc:`MIOpen <miopen:index>` or
   :doc:`rocBLAS <rocblas:index>` performs faster for a specific operation.

.. note::

   Experimental: TunableOp (see the :ref:`PyTorch TunableOp <mi300x-tunableop>` section) can also be used in combination
   with ``TorchInductor`` ``max-autotune`` mode to boost ATen GEMM performance but will further increase tuning time.
   The environment variable ``TORCHINDUCTOR_AUTOTUNE_MULTI_DEVICE=1`` can be useful in single GPU workloads to distribute Triton GEMM tuning.

Triton backend
--------------

The goal is to leverage Triton to achieve better performance. To tune Triton kernels with ``gemm`` and convolution ops (``conv``), use the
``torch.compile`` function with the ``max-autotune`` mode. This benchmarks a
predefined list of Triton configurations and selects the fastest one for each
shape. See the configurations in PyTorch source code:

* `conv configurations for "max-autotune" <https://github.com/pytorch/pytorch/blob/a1d02b423c6b4ccacd25ebe86de43f650463bbc6/torch/_inductor/kernel/conv.py#L51>`_

* `matmul configurations for "max-autotune" <https://github.com/pytorch/pytorch/blob/a1d02b423c6b4ccacd25ebe86de43f650463bbc6/torch/_inductor/kernel/mm_common.py#L118>`_

This tuning will select the best Triton ``gemm`` configurations according to tile-size 
``(BLOCK_M, BLOCK_N, BLOCK_K), num_stages, num_warps`` and ``mfma`` instruction size ( ``matrix_instr_nonkdim`` ) 
(see "Triton kernel optimization" section for more details).

* Set ``torch._inductor.config.max_autotune = True`` or ``TORCHINDUCTOR_MAX_AUTOTUNE=1``.

* Or, for more fine-grained control:

  ``torch._inductor.config.max_autotune_gemm = True``
     To enable tuning or lowering of ``mm``/``conv``\s.

  ``torch._inductor.config.max_autotune.pointwise = True``
     To enable tuning for ``pointwise``/``reduction`` ops.

  ``torch._inductor.max_autotune_gemm_backends`` or ``TORCHINDUCTOR_MAX_AUTOTUNE_GEMM_BACKENDS``
     Selects the candidate backends for ``mm`` auto-tuning. Defaults to
     ``TRITON,ATEN``. 
     Limiting this to ``TRITON`` might improve performance by
     enabling more fused ``mm`` kernels instead of going to rocBLAS.

* Inference can see large improvements on AMD GPUs by utilizing
  ``torch._inductor.config.freezing=True`` or the ``TORCHINDUCTOR_FREEZING=1`` variable, which
  in-lines weights as constants and enables constant folding optimizations.

* Enabling ``inductor``’s cpp_wrapper might improve overhead. This generates
  C++ code which launches Triton binaries directly with
  ``hipModuleLaunchKernel`` and relies on `hipification`.

  ``torch._inductor.config.cpp_wrapper=True`` or ``TORCHINDUCTOR_CPP_WRAPPER=1``

* Convolution workloads might see a performance benefit by specifying  
  ``torch._inductor.config.layout_optimization=True`` or ``TORCHINDUCTOR_LAYOUT_OPTIMIZATION=1``.
  This can help performance by enforcing ``channel_last`` memory format on the
  convolution in TorchInductor, avoiding any unnecessary transpose operations. 
  Note that ``PYTORCH_MIOPEN_SUGGEST_NHWC=1`` is recommended if using this.

* To extract the Triton kernels generated by ``inductor``, set the environment variable
  ``TORCH_COMPILE_DEBUG=1``, which will create a ``torch_compile_debug/`` directory
  in the current path. The wrapper codes generated by ``inductor`` are in one or more
  ``output_code.py`` files corresponding to the FX graphs associated with the model.
  The Triton kernels are defined in these generated codes.


Composable Kernel backend
--------------------------

You can enable the Composable Kernel (``CK``) backend by appending ``CK`` to the comma-separated list of backends. This allows the
auto-tuning process to use kernels from the Composable Kernel library.

``torch._inductor.max_autotune_gemm_backends`` or ``TORCHINDUCTOR_MAX_AUTOTUNE_GEMM_BACKENDS``.

Install the Composable Kernel library's Python wrapper via pip using the following command:

.. code-block:: shell

   pip install git+https://github.com/rocm/composable_kernel@develop

This wrapper library is responsible for constructing a list of kernel instances available in the Composable Kernel library,
as well as storing the kernel instance C++ includes in a known location (so clang can look into these paths when compiling the ``gemm`` auto-tune candidates).

  * ``matmul`` (with ``float16`` and ``bfloat16`` inputs, row-major X, row-major or column-major W)
  * ``addmm`` (with ``float16`` or ``bfloat16`` X, W and Bias; row-major X, row-major or column-major W; Bias can be broadcast either along row-major or column-major dimension)
  * ``scaled_mm`` (``float8_e4m3fnuz`` inputs, ``bfloat16`` output)
  * ``conv2d`` (with ``float32``, ``float16`` or ``bfloat16`` inputs, channels-last weight layout)

* For working examples, see `test/inductor/test_ck_backend.py <https://github.com/pytorch/pytorch/blob/main/test/inductor/test_ck_backend.py>`_.

* Compiling or build time can be configured by modifying ``torch._inductor.config`` to reduce the build time to avoid time-out.

  * ``compile_threads``: Number of threads used for compilation. Set it to the number of available CPU cores.
  * ``rocm.n_max_profiling_configs``: Limiting the number of kernels to speed up compilation.

* Setting environment variable ``PYTORCH_MIOPEN_SUGGEST_NHWC=1`` to optimize convolution operations.

Debugging and troubleshooting performance:

* Generate a standalone executable runner to debug or assess kernels' performance by setting environment variable
  ``INDUCTOR_CK_BACKEND_GENERATE_TEST_RUNNER_CODE=1`` to facilitate debugging and profiling. By default,
  the CK backend will not build a standalone executable runner.
* Enable debug by passing compilation flags (e.g., ``is_debug``) to clang when compiling the kernels in ``torch._inductor.config.rocm`` class.
* The generated source files and other products of clang compilation are located in the torch inductor root directory (default: ``/tmp/torchinductor_root``)

.. _mi300x-rocm-library-tuning:

ROCm library tuning
===================

ROCm library tuning involves optimizing the performance of routine computational
operations (such as ``GEMM``) provided by ROCm libraries like
:ref:`hipBLASLt <mi300x-hipblaslt>`, :ref:`Composable Kernel <mi300x-ck>`,
:ref:`MIOpen <mi300x-miopen>`, and :ref:`RCCL <mi300x-rccl>`. This tuning aims
to maximize efficiency and throughput on Instinct MI300X GPUs to gain 
improved application performance.

.. _mi300x-library-gemm:

GEMM (general matrix multiplication)
------------------------------------

GEMMs (General Matrix Multiplications) are a fundamental building block for many operations in neural networks.
GEMM is defined as ``C = αAB + βC`` where A is an ``MxK`` matrix input and B is ``KxN`` matrix input,
and C is ``MxN`` matrix input and is overwritten by the output. α and β are scalar inputs.
hipBLASLt is a library that provides general matrix-matrix operations with a flexible API
and extends functionalities beyond a traditional BLAS library.

.. _mi300x-hipblaslt:

hipBLASLt benchmarking
^^^^^^^^^^^^^^^^^^^^^^

The GEMM library
`hipBLASLt <https://rocm.docs.amd.com/projects/hipBLASLt/en/latest/index.html>`_
provides a benchmark tool for its supported operations. Refer to the
`documentation <https://github.com/ROCm/hipBLASLt/blob/develop/clients/bench/README.md>`_
for details.

* Example 1: Benchmark mix fp8 GEMM

  .. code-block:: shell

     HIP_FORCE_DEV_KERNARG=1  hipblaslt-bench --alpha 1 --beta 0 -r f16_r \
     --a_type f16_r --b_type f8_r --compute_type f32_f16_r \
     --initialization trig_float  --cold_iters 100 --iters 1000 --rotating 256

* Example 2: Benchmark forward epilogues and backward epilogues

  *  ``HIPBLASLT_EPILOGUE_RELU: "--activation_type relu";``

  *  ``HIPBLASLT_EPILOGUE_BIAS: "--bias_vector";``

  *  ``HIPBLASLT_EPILOGUE_RELU_BIAS: "--activation_type relu --bias_vector";``

  *  ``HIPBLASLT_EPILOGUE_GELU: "--activation_type gelu";``

  *  ``HIPBLASLT_EPILOGUE_DGELU": --activation_type gelu --gradient";``

  *  ``HIPBLASLT_EPILOGUE_GELU_BIAS: "--activation_type gelu --bias_vector";``

  *  ``HIPBLASLT_EPILOGUE_GELU_AUX: "--activation_type gelu --use_e";``

  *  ``HIPBLASLT_EPILOGUE_GELU_AUX_BIAS: "--activation_type gelu --bias_vector --use_e";``

  *  ``HIPBLASLT_EPILOGUE_DGELU_BGRAD: "--activation_type gelu --bias_vector --gradient";``

  *  ``HIPBLASLT_EPILOGUE_BGRADA: "--bias_vector --gradient --bias_source a";``

  *  ``HIPBLASLT_EPILOGUE_BGRADB:  "--bias_vector --gradient --bias_source b";``


hipBLASLt auto-tuning using hipblaslt-bench
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Use the auto-tuning tool in hipBLASLt to get the best solution for a given problem size.

Prerequisite
''''''''''''

Build hipBLASLt.
See the `hipBLASLt repository <https://github.com/ROCm/hipBLASLt>`_ to see detailed build instructions.

Quick start
'''''''''''

Create a working folder for the auto-tuning tool, for example, ``tuning/``.

1. Set the ``ProblemType``, ``TestConfig``, and ``TuningParameters`` in the YAML file. You can modify the template YAML file in ``hipblaslt/utilities``.

.. figure:: ../../../data/how-to/tuning-guides/hipblaslt_yaml_template.png
   :align: center
   :alt: HipBLASLt auto-tuning yaml file template

2. Run the following command to start tuning.

   .. code-block:: shell

      # python3 hipblaslt/utilities/find_exact.py <path-to-config-yaml> <path-to-the-root-of-built-hipblaslt> <working-directory>
      # Assume we're in folder tuning, the default root of the build folder of hipblaslt is hipblaslt/build/release
      python3 ../hipblaslt/utilities/find_exact.py tuning.yaml hipblaslt/build/release ./


Output
''''''

The tool will create two output folders. The first one is the benchmark results, 
the second one is the generated equality kernels. If ``SplitK`` is used, the solution's ``GlobalSplitU`` will 
also change if the winner is using a different ``SplitK`` from the solution. The YAML files generated inside the 
folder ``1_LogicYaml`` are logic ones. These YAML files are just like those generated from TensileLite.

.. figure:: ../../../data/how-to/tuning-guides/hipblaslt_auto_tuning_output_files.png
   :align: center
   :alt: HipBLASLt auto-tuning output folder


A quick view of the config YAML
'''''''''''''''''''''''''''''''

The tuning tool is a two-step tool. It first runs the benchmark, then it creates the equality YAML for the user. Note that this config YAML file is different from the config YAML used in TensileLite.

* **Benchmarking**

  The first step is to run the benchmark, ``find_exact.py`` will run the benchmark with ``hipblaslt-bench``.
  For the default configurations, see the Python file.

  .. code-block:: python

     defaultBenchOptions = {"ProblemType": {
         "TransposeA": 0,
         "TransposeB": 0,
         "ComputeInputDataType": "s",
         "ComputeDataType": "s",
         "DataTypeC": "s",
         "DataTypeD": "s",
         "UseBias": False
     }, "TestConfig": {
         "ColdIter": 20,
         "Iter": 100,
         "AlgoMethod": "all",
         "RequestedSolutions": 2, # Only works in AlgoMethod heuristic
         "SolutionIndex": None, # Only works in AlgoMethod index
         "ApiMethod": "cpp",
         "RotatingBuffer": 0,
     }, "TuningParameters": {
         "SplitK": [0]
     }, "ProblemSizes": []}
     defaultCreateLogicOptions = {}  # Currently unused

* ``TestConfig``
   1. ``ColdIter``: This is number the warm-up iterations before starting the kernel benchmark.
   2. ``Iter``: This is the number of iterations in kernel benchmarking
   3. ``AlgoMethod``: We recommended to keep this unchanged because method "all" returns all the available solutions for the problem type.
   4. ``ApiMethod``: We have c, mix, and cpp. Doesn't affect the result much.
   5. ``RotatingBuffer``: This is a size in the unit of MB. Recommended to set the value equal to the size of the cache of the card to avoid the kernel fetching data from the cache.
   
* ``TuningParameters``
   ``SplitK``: Divide ``K`` into ``N`` portions. Not every solution supports ``SplitK``. 
   The solution will be skipped if not supported.

* ``CreateLogic``
   Currently no control parameters.

hipBLASLt backend assembly generator tuning
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

:doc:`hipBLASLt <hipblaslt:index>` has a backend assembly generator in
`hipBLASLt's GitHub repository <https://github.com/ROCm/hipBLASLt/tree/develop/tensilelite>`_,
named TensileLite. TensileLite enables performance optimization by tuning the backend assembly generator.
The following section explains how to use TensileLite to tune hipBLASLt for better performance.

.. code-block:: shell

   cd /hipBLASLt/tensilelite
   ./Tensile/bin/Tensile config.yaml output_path

config.yaml
'''''''''''

This file contains the parameters and settings for the tuning process. Here’s
a breakdown of the important sections:

``GlobalParameters``
   The set of parameters which provides context for the entire tuning exercise.

   Using ``0`` for ``NumElementsToValidate`` is suggested for performance tuning to avoid validation overhead.

   .. code-block:: python

      globalParameters["NumElementsToValidate"] = 0

``BenchmarkProblems``
   Defines the set of kernel specifications as well as the size definitions
   for the tuning exercise.

   * ``ProblemType`` (``OperationType``, ``DataType``, ``TransposeA``, ``TransposeB``)
   * ``BenchmarkCommonParameters`` (the same parameters for all solutions)
   * ``ForkParameters``
   * ``BenchmarkFinalParameters`` (``ProblemSizes``)

``LibraryLogic``
   Specifies the target environment and platform.

   * ``ScheduleName``

     * ``aldebaran`` is MI200

     * ``aquavanjaram`` is MI300

   .. code-block:: shell

      $ ls
      aldebaran  aquavanjaram  navi31  navi32

   .. code-block:: yaml

      LibraryLogic:
        ScheduleName: "aldebaran"
        DeviceNames: [Device 0050, Device 0052, Device 0054, Device 0062, Device 7400]
        ArchitectureName: "gfx90a"

``LibraryClient``
   If defined, this will enable step 4 of the tuning process, which means the final
   library will be created.

   .. code-block:: shell

      $ ls
      aldebaran_Cijk_Ailk_Bjlk_S.yaml

TensileLite tuning flow
------------------------

The TensileLite tuning flow consists of seven steps. In the first six steps,
the programmable benchmarking protocol generates fast kernel candidates. In the
final step (:ref:`step 7 <tensilelite-tuning-step-7>`), these candidates are benchmarked against a predefined set
of problem sizes.

.. _tensilelite-tuning-flow-fig:

.. figure:: ../../../data/how-to/tuning-guides/tensilelite-tuning-flow.png
   :align: center
   :alt: TensileLite tuning flow

.. _tensilelite-tuning-step-1:

Step 1: Initial solution parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Before Tensile is able to benchmark a kernel parameter in Step 2 of the :ref:`preceding figure <tensilelite-tuning-flow-fig>`,
such as ``PrefetchGlobalRead={False, True}``, all other kernel parameters not being measured must be specified.
Therefore, the first step is to initialize a list of default kernel parameters, then subsequent steps of
benchmarking will override a parameter from this default list, with the parameter determined from benchmarking.
Tensile is pre-loaded with default parameters for any unspecified during tuning.

Step 2: Benchmark common parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Benchmarking common parameters determines parameters which are universally preferable to their alternatives
regardless of other parameters. To benchmark common parameters:

* User specifies parameters and values to benchmark.

* Tensile benchmarks all parameter combinations for a user-specified problem size.

* Tensile selects the fastest parameter combination which is now labeled determined and will subsequently be used.

In practice, these parameters are not used, since globally preferred parameters are set as defaults in Tensile and do not need to be re-measured.

Step 3: Fork parameters
^^^^^^^^^^^^^^^^^^^^^^^

Rather than continuing to determine globally fastest parameters, which eventually leads
to a single fastest kernel, forking creates many different kernels,
all of which will be considered for use. All forked
parameters are considered determined, i.e., they aren't measured to determine 
which is fastest. The :ref:`preceding figure <tensilelite-tuning-flow-fig>` shows 7 kernels being forked in Step 3.

Step 4: Benchmark fork parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Next, tuning continues its refinement by determining fastest parameters for
each forked permutation, same as in Step 2.

Step 5: Join parameters
^^^^^^^^^^^^^^^^^^^^^^^

After tuning the forked kernels, joining reduces the list of kernels so that fewer kernels
will be considered for final use. Each kernel in the resulting list must have different values
for the listed ``JoinParameters``, for example, employing ``JoinParameters`` = ``MacroTile`` will result in only a
few final kernels, each with a different ``MacroTile``. If there are multiple kernels with the same ``MacroTile``,
only the fastest is kept. In the above figure the 7 forked kernel have been reduced to 3 joined kernels.

Step 6: Benchmark join parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Users can further tune parameters of the joined kernels. This steps is same as Steps 4 except
that it tunes after joining so that there are fewer kernels to be tuned. In practice,
this step is not used; using Step 4 is preferred so that all parameters are measured before joining.

.. _tensilelite-tuning-step-7:

Step 7: Benchmark final parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

At the conclusion of Step 6, all parameters of all kernels have been determined and the
final set of kernels for consideration has been established. Now all final kernels will be
measured against all problem sizes specified by the user. Problem sizes can be specified
as Range sizes and Exact sizes. Range sizes cause benchmarking of a broad range of sizes,
and Tensile will be able to interpolate which kernel is best even between the specifically
measured sizes. Exact sizes cause a single problem size to be measured, and the final
library is guaranteed to choose the fastest kernel for that size. This final benchmarking
generates the data that is subsequently analyzed for creating the mapping of problem size
to optimal kernel.

Update logic YAML files
------------------------

The logic YAML files in hipBLASLt are located in
``library/src/amd_detail/rocblaslt/src/Tensile/Logic/asm_full/``.

To merge the YAML files from the tuned results in TensileLite, use the
``merge.py`` located in ``tensilelite/Tensile/Utilities`` with the following
command:

.. code-block:: shell

   merge.py original_dir new_tuned_yaml_dir output_dir 

The following table describes the logic YAML files.

+----------------+------------------------------------------------------+
| Logic YAML     | Description                                          |
+================+======================================================+
| ``Equality``   | Update the equality file when your tuned YAML is     |
|                | an exact tuning.                                     |
+----------------+------------------------------------------------------+
| ``GridBased``  | Update the gridbased file when your tuned YAML is    |
|                | a grid-based tuning.                                 |
+----------------+------------------------------------------------------+
| ``FreeSize``   | Update the freesize file when your tuned YAML        |
|                | contains confidential sizes, or others. Note that    |
|                | freesize YAML files do not require any problem size. |
+----------------+------------------------------------------------------+

Tensile optimization and performance tuning tips
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

MI16x16 versus MI32x32
   MI16x16 outperforms MI32x32 due to its superior power efficiency. The MI16x16
   format refers to the ``v_mfma`` instruction (such as
   ``v_mfma_f32_16x16x16f16``). See
   `<https://llvm.org/docs/AMDGPU/AMDGPUAsmGFX940.html#vop3p>`__.

Clock differences among XCDs
   There can be a clock speed variation of 3% to 10% among different XCDs.
   Typically, XCD0 has the highest clock speed, while XCD7 has the lowest on
   MI300X. For optimal efficiency calculations on MI300X, use the XCD with the
   lowest average clock speed. If the average clock speed of XCD0 is used,
   target efficiencies (such as, 95% for DGEMM HPL cases with K=512) may not be
   achievable.

`WorkGroupMapping`
   To maximize L2 cache efficiency, use multiples of the XCD number. For MI300X,
   this means using multiples of 8 (such as, 24, 32, 40).

GEMM stride issues
   On MI300, if the matrix stride in GEMM is a multiple of 512 bytes, it can lead to
   Tagram channel hotspotting issues, causing a significant performance drop, especially for TN
   transpose cases. This can increase the latency of VMEM instructions and cause
   a notable performance drop. To avoid this, use stride padding to ensure the
   stride is not a multiple of 512 bytes (for instance, for TN F16 GEMM, set
   ``lda = ldb = K + 128`` when ``K % 256 == 0``).

.. _mi300x-ck:

Optimizing Composable Kernel GEMM kernels
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The performance of a GEMM kernel is significantly influenced by the input
values. The performance hierarchy based on input value types, from highest to
lowest, is as follows:

* Case 1: [all 0]

* Case 2: [all identical integers]

* Case 3: [random integers]

* Case 4: [random floats]

There can be more than a 20 percent performance drop between Case 1 and Case 4,
and a 10 percent drop between random integers and random floats.

Additionally, ``bf16`` matrix core execution is noticeably faster than ``f16``.

Distributing workgroups with data sharing on the same XCD can enhance
performance (reduce latency) and improve benchmarking stability.

CK provides a rich set of template parameters for generating flexible accelerated 
computing kernels for difference application scenarios.

See :doc:`optimizing-with-composable-kernel`
for an overview of Composable Kernel GEMM kernels, information on tunable
parameters, and examples.

.. _mi300x-miopen:

MIOpen
------

MIOpen is AMD's open-source, deep learning primitives library for GPUs. It
implements fusion to optimize for memory bandwidth and GPU launch overheads,
providing an auto-tuning infrastructure to overcome the large design space of
problem configurations.

Convolution
^^^^^^^^^^^

Many of MIOpen kernels have parameters which affect
their performance. Setting these kernel parameters to optimal values
for a given convolution problem, allows reaching the best possible
throughput. The optimal values of these kernel parameters are saved
in PerfDb (Performance database). PerfDb is populated through
tuning. To manipulate the tuning level, use the environment variable
``MIOPEN_FIND_ENFORCE`` (1-6). Optimal values of kernel parameters are
used to benchmark all applicable convolution kernels for the given
convolution problem. These values reside in the FindDb. To manipulate
how to find the best performing kernel for a given convolution
problem, use the environment variable ``MIOPEN_FIND_MODE`` (1-5).

.. _mi300x-miopen-tuning:

Tuning in MIOpen
^^^^^^^^^^^^^^^^

``MIOPEN_FIND_ENFORCE=DB_UPDATE``, ``2``
   Performs auto-tuning and update to the PerfDb.

``MIOPEN_FIND_ENFORCE=SEARCH``, ``3``
   Only perform auto-tuning if PerfDb does not contain optimized value for a
   given convolution problem

What does :doc:`PerfDb <miopen:conceptual/perfdb>` look like?

.. code-block:: 

   [
    2x128x56xNHWCxF, [
                     ConvAsm1x1U          :  1,8,2,64,2,4,1,8 ;       // optimum kernel params for convolution problem 2x128x56xNHWCxF
                     ConvOclDirectFwd1x1  : 1,128,1,1,0,2,32,4,0;     // optimum kernel params for convolution problem 2x128x56xNHWCxF
                     ],
   2x992x516xNHWCxF, [
                     ConvAsm1x1U          :  64,18,2,64,2,4,41,6 ;    // optimum kernel params for convolution problem 2x992x516xNHWCxF
                     ConvOclDirectFwd1x1  : 54,128,21,21,1,23,32,4,0  // optimum kernel params for convolution problem 2x992x516xNHWCxF
                     ]
    ...
   ]

See :doc:`miopen:conceptual/perfdb` for more information.

Finding the fastest kernel
^^^^^^^^^^^^^^^^^^^^^^^^^^

``MIOPEN_FIND_MODE=NORMAL``, ``1``
   Benchmark all the solvers and return a list (front element is the fastest kernel).

``MIOPEN_FIND_MODE=FAST``, ``2``
   Check FindDb (Find database) if convolution problem is found return - else
   immediate fallback mode (predict the performing kernel parameters based on
   mathematical and AI models).

``MIOPEN_FIND_MODE=HYBRID``, ``3``
   Check FindDb if convolution problem is found return - else benchmark that
   problem.

What does :doc:`FindDb <miopen:conceptual/finddb>` look like?

.. code-block:: 

   [

    2x128x56xNHWCxF, [
                     ConvAsm1x1U          :  0.045 (time), 12312 (workspace), algo_type;
                     ConvOclDirectFwd1x1  : 1.145 (time), 0 (workspace), algo_type;
                     ],

   2x992x516xNHWCxF, [
                     ConvAsm1x1U          :  2.045 (time), 12312 (workspace), algo_type;
                     ConvOclDirectFwd1x1  : 1.145 (time), 0 (workspace), algo_type;
                     ]
    ...
   ]

See :doc:`miopen:how-to/find-and-immediate` for more information.

For example:

.. code-block:: shell

   MIOPEN_FIND_ENFORCE=3 MIOPEN_FIND_MODE=1 ./bin/MIOpenDriver convbfp16 -n 1 -c 1024 -H 14 -W 14 -k 256 -y 1 -x 1 -p 0 -q 0 -u 1 -v 1 -l 1 -j 1 -m conv -g 1 -F 1

.. _mi300x-rccl:

RCCL
----

:doc:`RCCL <rccl:index>` is a stand-alone library of standard collective
communication routines for GPUs, implementing all-reduce, all-gather, reduce,
broadcast, reduce-scatter, gather, scatter, and all-to-all. RCCL supports an
arbitrary number of GPUs installed in a single node or multiple nodes
and can be used in either single- or multi-process (such as MPI)
applications.

The following subtopics include information on RCCL features and optimization
strategies:

* :ref:`Use all eight GPUs <mi300x-rccl-8-gpu>`

* :ref:`Disable NUMA auto-balancing <mi300x-rccl-disable-numa>`

* :ref:`Disable ACS for multi-node RCCL <mi300x-rccl-disable-acs>`

* :ref:`Run RCCL-Unittests <mi300x-rccl-unittests>`

* :ref:`NPKit profiler <mi300x-rccl-npkit>`

* :ref:`RCCL-tests <mi300x-rccl-tests>`

* :ref:`Use one-process-per-GPU mode <mi300x-rccl-one-process-per-gpu>`

* :ref:`RCCL in E2E workloads <mi300x-rccl-e2e>`

.. _mi300x-rccl-8-gpu:

Use all eight GPUs
^^^^^^^^^^^^^^^^^^

In an :ref:`MI300X architecture <mi300x-node-level-arch-fig>`, there are
dedicated links between each pair of GPUs in a fully connected topology.
Therefore, for collective operations, the best performance is achieved
when all 8 GPUs and, hence, all the links between them are used. In the
case of 2- or 4-GPU collective operations (generally less than 8 GPUs),
you can only use a fraction of the potential bandwidth on the node.

The following figure shows an
:doc:`MI300X node-level architecture </conceptual/gpu-arch/mi300>` of a
system with AMD EPYC processors in a dual-socket configuration and eight
AMD Instinct MI300X GPUs. The MI300X OAMs attach to the host system via
PCIe Gen 5 x16 links (yellow lines). The GPUs use seven high-bandwidth,
low-latency AMD Infinity Fabric™ links (red lines) to form a fully connected
8-GPU system.

.. _mi300x-node-level-arch-fig:

.. figure:: ../../../data/shared/mi300-node-level-arch.png

   MI300 series node-level architecture showing 8 fully interconnected MI300X
   OAM modules connected to (optional) PCIe switches via re-timers and HGX
   connectors.

.. _mi300x-rccl-disable-numa:

Disable NUMA auto-balancing
^^^^^^^^^^^^^^^^^^^^^^^^^^^

In order to reduce performance variability and also achieve better
performance, you need to make sure that NUMA auto-balancing is disabled
on the node.

Check whether NUMA auto-balancing is disabled, by running the
following command: ``cat /proc/sys/kernel/numa_balancing`` and
checking whether the output is ``0``.

If the output is ``1``, you can disable NUMA auto-balancing by running the
following command: ``sudo sysctl kernel.numa_balancing=0``. For more details,
see `AMD Instinct MI300X system optimization
<https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/system-optimization/mi300x.html#disable-numa-auto-balancing>`_.

.. _mi300x-rccl-disable-acs:

Disable ACS for multi-node RCCL
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Check if ACS is disabled with ``sudo lspci -vvv \| grep -i "acsctl"``.
This will print many lines. Check if there are any that show ``SrcValid+``

If there are any ``SrcValid+``, then use the following ``disable_acs.sh`` script
to disable ACS (requires ``sudo``).

.. code-block:: shell

   #!/bin/bash

   #

   # Disable ACS on every device that supports it

   #

   PLATFORM=$(dmidecode --string system-product-name)

   logger "PLATFORM=${PLATFORM}"

   # Enforce platform check here.

   #case "${PLATFORM}" in

   #"OAM"*)

   #logger "INFO: Disabling ACS is no longer necessary for ${PLATFORM}"

   #exit 0

   #;;

   #*)

   #;;

   #esac

   # must be root to access extended PCI config space

   if [ "$EUID" -ne 0 ]; then

   echo "ERROR: $0 must be run as root"

   exit 1

   fi

   for BDF in \`lspci -d "*:*:*" \| awk '{print $1}'`; do

   # skip if it doesn't support ACS

   setpci -v -s ${BDF} ECAP_ACS+0x6.w > /dev/null 2>&1

   if [ $? -ne 0 ]; then

   #echo "${BDF} does not support ACS, skipping"

   continue

   fi

   logger "Disabling ACS on \`lspci -s ${BDF}`"

   setpci -v -s ${BDF} ECAP_ACS+0x6.w=0000

   if [ $? -ne 0 ]; then

   logger "Error enabling directTrans ACS on ${BDF}"

   continue

   fi

   NEW_VAL=`setpci -v -s ${BDF} ECAP_ACS+0x6.w \| awk '{print $NF}'\`

   if [ "${NEW_VAL}" != "0000" ]; then

   logger "Failed to enabling directTrans ACS on ${BDF}"

   continue

   fi

   done

   exit 0

.. _mi300x-rccl-unittests:

Run RCCL-Unittests
^^^^^^^^^^^^^^^^^^

In order to verify RCCL installation and test whether all parts and
units of RCCL work as expected you can run the RCCL-Unittests which is
explained in `<https://github.com/ROCm/rccl?tab=readme-ov-file#tests>`__.

.. _mi300x-rccl-npkit:

NPKit profiler
^^^^^^^^^^^^^^

To collect fine-grained trace events in RCCL components, especially in
giant collective GPU kernels you can use the NPKit profiler explained
in `<https://github.com/ROCm/rccl?tab=readme-ov-file#npkit>`__.

.. _mi300x-rccl-tests:

RCCL-tests
^^^^^^^^^^

RCCL-tests are performance and error-checking tests for RCCL
maintained in `<https://github.com/ROCm/rccl-tests>`__.

These tests are one of the best ways to check the performance of
different collectives provided by RCCL. You can select collectives,
message sizes, datatypes, operations, number of iterations, etc., for
your test, and then rccl-tests deliver performance metrics such as
latency, algorithm bandwidth, and bus bandwidth for each case.

.. _mi300x-rccl-one-process-per-gpu:

Use one-process-per-GPU mode
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

RCCL delivers the best performance for collectives when it is configured
in a one-process-per-GPU mode. This is due to the fact that for a
one-process-per-multiple-GPUs configuration, you can run into kernel launch
latency issues. This is because ROCm serializes kernel launches on multiple GPUs
from one process which hurts performance.

.. _mi300x-rccl-e2e:

RCCL in E2E workloads
^^^^^^^^^^^^^^^^^^^^^

Use the following environment variable to increase the number of
channels used by RCCL when using RCCL in end-to-end workloads to potentially
improve the performance:

.. code-block:: text

   export NCCL_MIN_NCHANNELS=112

.. _mi300x-triton-kernel-performance-optimization:

Triton kernel performance optimization
======================================

Triton kernel optimization encompasses a variety of strategies aimed at
maximizing the efficiency and performance of GPU computations. These strategies
include
:ref:`optimizing overall GPU resource utilization <mi300x-triton-gpu-utilization>`,
:ref:`tuning kernel configurations <mi300x-autotunable-kernel-config>`, and
:ref:`leveraging specific hardware features <mi300x-assembly-analysis>` to
achieve higher throughput and lower latency.

.. _mi300x-autotunable-kernel-config:

Auto-tunable kernel configurations
----------------------------------

Auto-tunable kernel configuration involves adjusting memory access and computational
resources assigned to each compute unit. It encompasses the usage of
:ref:`LDS <mi300x-cu-fig>`, register, and task scheduling on a compute unit.

The GPU contains global memory, local data share (LDS), and
registers. Global memory has high access latency, but is large. LDS access has
much lower latency, but is smaller. It is a fast on-CU software-managed memory
that can be used to efficiently share data between all work items in a block.
Register access is the fastest yet smallest among the three.

.. _mi300x-cu-fig:

.. figure:: ../../../data/shared/compute-unit.png

   Schematic representation of a CU in the CDNA2 or CDNA3 architecture.

The following is a list of kernel arguments used for tuning performance and
resource allocation on AMD GPUs, which helps in optimizing the
efficiency and throughput of various computational kernels.

``num_stages=n``
   Adjusts the number of pipeline stages for different types of kernels. On AMD GPUs, set ``num_stages``
   according to the following rules:

   * For kernels with a single GEMM, set to ``2``.

   * For kernels with two GEMMs fused (Flash Attention, or any other kernel
     that fuses 2 GEMMs), set to ``1``.

   * For kernels that fuse a single GEMM with another non-GEMM operator
     (for example ReLU activation), set to ``2``.

   * For kernels that have no GEMMs, set to ``1``.

``waves_per_eu=n``
   Helps to manage Vector General Purpose Registers (VGPR) usage to achieve
   desired occupancy levels. This argument hints to the compiler to reduce VGPR
   to achieve ``n`` occupancy where ``n`` is a number. The goal is to achieve a
   certain occupancy level for each Execution Unit (EU, also called
   :ref:`SIMD Unit <mi300x-cu-fig>`) to achieve better latency or throughput.
   For more information on how to compute occupancy, see
   :ref:`mi300x-compute-kernel-occ`.

   This argument is useful if:

   * The occupancy of the kernel is limited by VGPR usage, and

   * The current VGPR usage is only a few above a boundary in
     :ref:`Occupancy related to VGPR usage in an Instinct MI300X GPU <mi300x-occupancy-vgpr-table>`.

.. _mi300x-occupancy-vgpr-table:

.. figure:: ../../../data/shared/occupancy-vgpr.png
   :alt: Occupancy related to VGPR usage in an Instinct MI300X GPU.
   :align: center

   Occupancy related to VGPRs usage on an Instinct MI300X GPU

For example, according to the table, each Execution Unit (EU) has 512 available
VGPRs, which are allocated in blocks of 16. If the current VGPR usage is 170,
it will be rounded up to 176 due to the allocation granularity. In this case,
the occupancy is limited to 2 waves per EU because :math:`176 \times 3 > 512`.
So, if you set ``waves_per_eu`` to 3, the LLVM backend will attempt to reduce
VGPR usage so that it might fit 3 waves per EU.

``BLOCK_M``, ``BLOCK_N``, ``BLOCK_K``
   Tile sizes to be tuned to balance the memory-to-computation ratio. The goal
   is to minimize the memory transfer from global to shared and reuse memory
   across different threads. This needs to be tuned. The tile sizes should be
   large enough to maximize the efficiency of the memory-to-computation
   ratio but small enough to parallelize the greatest number of workgroups at
   the grid level.

``matrix_instr_nonkdim``
   Experimental feature for Flash Attention-like kernels that determines the size of the Matrix Fused Multiply-Add
   (MFMA) instruction used.

   -  ``matrix_instr_nonkdim = 16``: ``mfma_16x16`` is used.

   -  ``matrix_instr_nonkdim = 32``: ``mfma_32x32`` is used.

   For GEMM kernels on an MI300X GPU, ``mfma_16x16`` typically outperforms ``mfma_32x32``, even for large
   tile/GEMM sizes.


.. _mi300x-triton-gpu-utilization:

Overall GPU resource utilization
--------------------------------

As depicted in the following figure, each XCD in
:doc:`MI300X </conceptual/gpu-arch/mi300>` contains 40 compute units (CUs),
with 38 active. Each MI300X contains eight vertical XCDs, and a total of 304
active compute units capable of parallel computation. The first consideration is
the number of CUs a kernel can distribute its task across.

.. figure:: ../../../data/shared/xcd-sys-arch.png

   XCD-level system architecture showing 40 compute units,
   each with 32 KB L1 cache, a unified compute system with 4 ACE compute
   GPUs, shared 4MB of L2 cache, and a hardware scheduler (HWS).

You can query hardware resources with the command ``rocminfo`` in the
``/opt/rocm/bin`` directory. For instance, query the number of CUs, number of
SIMD, and wavefront size using the following commands.

.. code-block:: shell

   rocminfo | grep "Compute Unit"

   rocminfo | grep "SIMD"

   rocminfo | grep "Wavefront Size"

For the MI300X, the goal is to have a minimum of 1024 thread
blocks or workgroups in the grid (kernel), with a preference for
more.

Identifying additional parallelism within the algorithm is necessary to
enhance GPU utilization. For more information and examples, see
`Accelerating A Triton Fused Kernel For W4a16 Quantized Inference With
SplitK Work Decomposition <https://arxiv.org/pdf/2402.00025v1>`__.

.. _mi300x-mlir-analysis:

MLIR analysis
-------------

Triton includes the following layouts: **blocked**, **shared**, **sliced**, and **MFMA**.

Use the Triton GPU Intermediate Representation (IR) to identify the memory in
which each computation takes place.

Use the environment variable ``MLIR_ENABLE_DUMP`` to dump MLIR:

.. code-block:: shell

   export MLIR_ENABLE_DUMP=1

The following is a snippet of IR from the Flash Attention decode ``int4`` KV program. It is to
de-quantize the ``int4`` key-value from the ``int4`` data type to ``fp16``.

.. code-block:: text

   %190 = tt.load %189 {cache = 1 : i32, evict = 1 : i32, isVolatile =
   false} : tensor<1x64xi32, #blocked6> loc(#loc159)

   %266 = arith.andi %190, %cst_28 : tensor<1x64xi32, #blocked6>
   loc(#loc250)

   %267 = arith.trunci %266 : tensor<1x64xi32, #blocked6> to
   tensor<1x64xi16, #blocked6> loc(#loc251)

   %268 = tt.bitcast %267 : tensor<1x64xi16, #blocked6> -> tensor<1x64xf16,
   #blocked6> loc(#loc252)

   %269 = triton_gpu.convert_layout %268 : (tensor<1x64xf16, #blocked6>) ->
   tensor<1x64xf16, #shared1> loc(#loc252)

   %270 = tt.trans %269 : (tensor<1x64xf16, #shared1>) -> tensor<64x1xf16,
   #shared2> loc(#loc194)

   %276 = triton_gpu.convert_layout %270 : (tensor<64x1xf16, #shared2>) ->
   tensor<64x1xf16, #blocked5> loc(#loc254)

   %293 = arith.mulf %276, %cst_30 : tensor<64x1xf16, #blocked5>
   loc(#loc254)

   %295 = arith.mulf %292, %294 : tensor<64x32xf16, #blocked5> loc(#loc264)

   %297 = arith.addf %295, %296 : tensor<64x32xf16, #blocked5> loc(#loc255)

   %298 = triton_gpu.convert_layout %297 : (tensor<64x32xf16, #blocked5>)
   -> tensor<64x32xf16, #shared1> loc(#loc255)

   %299 = tt.trans %298 : (tensor<64x32xf16, #shared1>) ->
   tensor<32x64xf16, #shared2> loc(#loc196)

   %300 = triton_gpu.convert_layout %299 : (tensor<32x64xf16, #shared2>) ->
   tensor<32x64xf16, #triton_gpu.dot_op<{opIdx = 1, parent = #mfma, kWidth
   = 4}>> loc(#loc197)

From the IR snippet, you can see ``i32`` data is loaded from global memory to
registers (``%190``). With a few element-wise operations in registers, it is
stored in shared memory (``%269``) for the transpose operation (``%270``), which
needs data movement across different threads. With the transpose done, it is
loaded from LDS to register again (``%276``), and with a few more
element-wise operations, it is stored to LDS again (``%298``). The last step
loads from LDS to registers and converts to the dot-operand layout
(``%300``).

The IR snippet uses the LDS twice. The first is for the transpose, and
the second is to convert a blocked layout to a dot operand layout.
There’s an opportunity to optimize performance by using LDS once.

.. _mi300x-assembly-analysis:

ISA assembly analysis
---------------------

To generate ISA, ``export AMDGCN_ENABLE_DUMP=1`` when running the Triton
program. The generated ISA will be printed as standard output. You can
dump it to a file for analysis.

*  Ensure ``global_load_dwordx4`` is used in the ISA, especially when the
   global memory load happens in the loop.

*  In most cases, the LDS load and store should use ``_b128`` to
   minimize the number of LDS access instructions.

*  The AMD ISA has ``s_waitcnt`` instruction to synchronize the dependency
   of memory access and computations. The ``s_waitcnt`` instructions can
   typically have two signals in the Triton context:

   *  ``lgkmcnt(n)``: ``lgkm`` stands for LDS, GDS
      (Global Data Share), Constant, and Message. It is often related to
      LDS access. The ``n`` indicates the number of data accesses can still
      be ongoing before moving on to the next step. For example, if ``n`` is
      ``0``, wait for all ``lgkm`` access to finish before continuing. If ``n``
      is ``1``, move on even if ``1`` ``lgkm`` access is still running
      asynchronously.

   *  ``vmcnt(n)``: ``vm`` represents vector memory. This happens when
      vector memory is accessed, for example, when global load moves
      from global memory to vector memory. The variable ``n`` is the same as
      the previous setting.

Generally recommended guidelines are as follows.

*  Vectorize memory access as much as possible.

*  Ensure synchronization is done efficiently.

*  Overlap of instructions to hide latency, but it requires thoughtful
   analysis of the algorithms.

*  If you find inefficiencies, you can trace it back to LLVM IR, TTGIR
   and even TTIR to see where the problem comes from. If you find it
   during compiler optimization, activate the MLIR dump
   (``export MLIR_ENABLE_DUMP=1``) and check which optimization pass caused the
   problem.

.. _mi300x-hip-optimization:

HIP performance optimization
============================

This section summarizes the best practices described in the
:doc:`Performance guidelines <hip:how-to/performance_guidelines>` section of the
HIP documentation.

Optimization areas of concern include:

* Parallel execution

* Memory usage optimization

* Optimization for maximum throughput

* Minimizing memory thrashing

Parallel execution and GPU hardware utilization
-----------------------------------------------

The application should reveal and efficiently imply as much parallelism as
possible for optimal use to keep all system components active.

Memory usage optimization
-------------------------

To optimize memory throughput, minimize low-bandwidth data transfers,
particularly between the host and device. Maximize on-chip memory, including
shared memory and caches, to reduce data transfers between global memory and the
device.

In a GPU, global memory has high latency but a large size, while local data
share (LDS) has lower latency but a smaller size, and registers have the fastest
but smallest access. Aim to limit load/store operations in global memory. If
multiple threads in a block need the same data, transfer it from global memory
to LDS for efficient access.

See :doc:`HIP's performance guidelines <hip:how-to/performance_guidelines>` for
greater detail.

Diagnostic and performance analysis
===================================

.. _mi300x-rocr-debug-agent:

Debug memory access faults
--------------------------

Identifying a faulting kernel is often enough to triage a memory access
fault. The ROCr Debug Agent can trap a memory access fault and provide a
dump of all active wavefronts that caused the error, as well as the name
of the kernel. For more information, see
:doc:`ROCr Debug Agent documentation <rocr_debug_agent:index>`.

To summarize, the key points include:

1. Compiling with ``-ggdb -O0`` is recommended but not required.

2. ``HSA_TOOLS_LIB=/opt/rocm/lib/librocm-debug-agent.so.2 HSA_ENABLE_DEBUG=1 ./my_program``

When the debug agent traps the fault, it produces verbose output of all
wavefront registers and memory content. Importantly, it also prints
something similar to the following:

.. code-block:: text

   Disassembly for function vector_add_assert_trap(int*, int*, int*):

   code object:
   file:////rocm-debug-agent/build/test/rocm-debug-agent-test#offset=14309&size=31336

   loaded at: [0x7fd4f100c000-0x7fd4f100e070]

The kernel name and the code object file should be listed. In the
example above, the kernel name is vector_add_assert_trap, but this might
also look like:

.. code-block:: text

   Disassembly for function memory:///path/to/codeobject#offset=1234&size=567:

In this case, it's an in-memory kernel that was generated at runtime.
Using the environment variable ``ROCM_DEBUG_AGENT_OPTIONS="--all --save-code-objects"``
will have the debug agent save all code objects to the current directory. Use
``--save-code-objects=[DIR]`` to save them in another location.

The code objects will be renamed from the URI format with special
characters replaced by ‘_’. Use ``llvm-objdump`` to disassemble the
indicated in-memory code object that has been saved to disk. The name of
the kernel is often found in the disassembled code object.

.. code-block:: shell

   llvm-objdump --disassemble-all path/to/code-object.co

Disabling memory caching strategies within the ROCm stack and PyTorch is
recommended, where possible. This gives the debug agent the best chance
of finding the memory fault where it originates. Otherwise, it could be
masked by writing past the end of a cached block within a larger
allocation.

.. code-block:: text

   PYTORCH_NO_HIP_MEMORY_CACHING=1

   HSA_DISABLE_FRAGMENT_ALLOCATOR=1

.. _mi300x-compute-kernel-occ:

Compute the occupancy of a kernel
---------------------------------

1. Get the VGPR count, search for ``.vgpr_count`` in the ISA (for example,
   ``N``).

2. Get the allocated LDS following the steps (for example, L for the kernel).

   a. ``export MLIR_ENABLE_DUMP=1``

   b. ``rm -rf ~/.triton/cache``

   c. ``python kernel.py | | grep "triton_gpu.shared = " | tail -n 1``

   d. You should see something like ``triton_gpu.shared = 65536``, indicating
      65536 bytes of LDS are allocated for the kernel.

3. Get number of waves per workgroup using the following steps (for example, ``nW``).

   a. ``export MLIR_ENABLE_DUMP=1``

   b. ``rm -rf ~/.triton/cache``

   c. ``python kernel.py | | grep "triton_gpu.num-warps " | tail -n 1``

   d. You should see something like ``“triton_gpu.num-warps" = 8``, indicating 8
      waves per workgroup.

4. Compute occupancy limited by VGPR based on N according to the
   :ref:`preceding table <mi300x-occupancy-vgpr-table>`. For example, waves per
   EU as ``occ_vgpr``.

5. Compute occupancy limited by LDS based on L by: ``occ_lds = floor(65536 / L)``.

6. Then the occupancy is ``occ = min(floor(occ_vgpr * 4 / nW), occ_lds) * nW / 4``

   a. ``occ_vgpr \* 4`` gives the total number of waves on all 4 execution units (SIMDs)
      per CU.

   b. ``floor(occ_vgpr * 4 / nW)`` gives the occupancy of workgroups per CU
      regrading VGPR usage.

   c. The true ``occ`` is the minimum of the two.

Find the full ``occ.sh`` at
`<https://github.com/ROCm/triton/blob/triton-mlir/scripts/amd/occ.sh>`__.

Special considerations
======================

Multi-GPU communications
------------------------

Because of the characteristics of MI300X inter-GPU communication and
limitation of bandwidth between and among 2 GPUs and 4 GPUs, avoid running
workloads that use 2 or 4 GPU collectives. It's optimal to either use a
single GPU (where no collective is required) or employ 8 GPU
collectives.

Multi-node FSDP and RCCL settings
---------------------------------

When using PyTorch's FSDP (Full Sharded Data Parallel) feature, the HIP
streams used by RCCL and HIP streams used for compute kernels do not
always overlap well. As a workaround, it's recommended to use
high-priority HIP streams with RCCL.

To configure high-priority streams:

-  Set environment variable ``TORCH_NCCL_HIGH_PRIORITY=1`` to force all RCCL
   streams to be high-priority.

-  Set environment variable ``GPU_MAX_HW_QUEUES=2`` via the HIP runtime
   library.

Hardware efficiency is maximized with 4 or fewer HIP streams. These environment variables limit the
configuration to two compute streams and two RCCL streams, aligning with this best practice.
Additionally, RCCL is often pre-optimized for MI300 systems in production by querying the node
topology during startup, reducing the need for extensive manual tuning.
