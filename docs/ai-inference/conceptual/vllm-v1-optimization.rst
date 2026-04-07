.. meta::
   :description: Learn about vLLM V1 inference tuning on AMD Instinct GPUs for optimal performance.
   :keywords: AMD, Instinct, MI300X, MI325X, MI350X, MI355X, HPC, tuning, BIOS settings, NBIO, ROCm,
              environment variable, performance, HIP, Triton, PyTorch TunableOp, vLLM, RCCL,
              MIOpen, GPU, resource utilization

.. _mi300x-vllm-optimization:
.. _vllm-optimization:

********************************
vLLM V1 performance optimization
********************************

This guide helps you maximize vLLM throughput and minimize latency on AMD
Instinct MI300X, MI325X, MI350X, and MI355X GPUs. Learn how to:

* Enable AITER (AI Tensor Engine for ROCm) for speedups on LLM models.
* Configure environment variables for optimal HIP, RCCL, and Quick Reduce performance.
* Select the right attention backend for your workload (AITER MHA/MLA vs. Triton).
* Choose parallelism strategies (tensor, pipeline, data, expert) for multi-GPU deployments.
* Apply quantization (``FP8``/``FP4``) to reduce memory usage by 2-4× with minimal accuracy loss.
* Tune engine arguments (batch size, memory utilization, graph modes) for your use case.
* Benchmark and scale across single-node and multi-node configurations.

Performance environment variables
=================================

The following variables are generally useful for Instinct MI300X/MI325X/MI350X/MI355X GPUs and vLLM:

* **HIP and math libraries**

  * ``export HIP_FORCE_DEV_KERNARG=1`` — improves kernel launch performance by
    forcing device kernel arguments. This is already set by default in
    :doc:`vLLM ROCm Docker images </ai-inference/vllm>`. Bare-metal users
    should set this manually.
  * ``export SAFETENSORS_FAST_GPU=1`` — enables GPU-accelerated safetensors
    loading, significantly reducing model load time for large models. Already
    set in vLLM ROCm Docker images. Bare-metal users should set this manually.
  * ``export TORCH_BLAS_PREFER_HIPBLASLT=1`` — explicitly prefers hipBLASLt
    over hipBLAS for GEMM operations. By default, PyTorch uses heuristics to
    choose the best BLAS library. Setting this can improve linear layer
    performance in some workloads.

* **RCCL (collectives for multi-GPU)**

  * ``export NCCL_MIN_NCHANNELS=112`` — increases RCCL channels from default
    (typically 32-64) to 112 on the Instinct MI300X/MI325X. **Only beneficial for
    multi-GPU distributed workloads** (tensor parallelism, pipeline
    parallelism). Single-GPU inference does not need this.

.. _vllm-optimization-aiter-switches:

AITER (AI Tensor Engine for ROCm) switches
==========================================

AITER (AI Tensor Engine for ROCm) provides ROCm-specific fused kernels optimized for Instinct MI350 Series and MI300X/MI325X GPUs in vLLM V1.

Enable all AITER optimizations with a single master switch:

.. code-block:: bash

   export VLLM_ROCM_USE_AITER=1
   vllm serve MODEL_NAME

Most individual AITER sub-flags default to ``1`` when the master switch is on,
while specialized features retain the defaults listed below. You rarely need to
change them. To select a specific attention backend, use ``--attention-backend``
(see :ref:`backend selection <vllm-optimization-aiter-backend-selection>`).

**Flags you might adjust:**

* ``VLLM_ROCM_SHUFFLE_KV_CACHE_LAYOUT=1`` — Set for high-concurrency MHA workloads (≥32 concurrent requests) with ``ROCM_AITER_FA``. Defaults to ``0``.
* ``VLLM_ROCM_USE_AITER_MOE=0`` — Disable only if you hit ``RuntimeError: wrong! device_gemm ...``. Try ``AITER_ONLINE_TUNE=1`` first. See :ref:`AITER MoE requirements <vllm-optimization-aiter-moe-requirements>`.
* ``VLLM_ROCM_USE_AITER=0`` — Disable AITER entirely to fall back to Triton kernels (for debugging).

Advanced: individual AITER flags
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following table lists AITER-related sub-flags for fine-grained control. Most
users do not need to modify these; the default behavior for each flag is listed below.

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Environment variable
     - Description (default behavior)

   * - ``VLLM_ROCM_USE_AITER``
     - Master switch to enable AITER kernels (``0`` by default). All other ``VLLM_ROCM_USE_AITER_*`` flags require this to be set to ``1``.

   * - ``VLLM_ROCM_USE_AITER_LINEAR``
     - Use AITER quantization operators + GEMM for linear layers (defaults to ``1`` when AITER is on). Accelerates matrix multiplications in all transformer layers. **Recommended to keep enabled**.

   * - ``VLLM_ROCM_USE_AITER_MOE``
     - Use AITER fused-MoE kernels (defaults to ``1`` when AITER is on). Accelerates Mixture-of-Experts routing and computation. See the note on :ref:`AITER MoE requirements <vllm-optimization-aiter-moe-requirements>`.

   * - ``VLLM_ROCM_USE_AITER_RMSNORM``
     - Use AITER RMSNorm kernels (defaults to ``1`` when AITER is on). Accelerates normalization layers. **Recommended: keep enabled.**

   * - ``VLLM_ROCM_USE_AITER_MLA``
     - Use AITER Multi-head Latent Attention for supported models, for example, DeepSeek-V3/R1 (defaults to ``1`` when AITER is on). See the section on :ref:`AITER MLA requirements <vllm-optimization-aiter-mla-requirements>`.

   * - ``VLLM_ROCM_USE_AITER_MHA``
     - Use AITER Multi-Head Attention kernels (defaults to ``1`` when AITER is on; set to ``0`` to use Triton attention backends or ``ROCM_ATTN`` backend instead). See :ref:`attention backend selection <vllm-optimization-aiter-backend-selection>`.

   * - ``VLLM_ROCM_USE_AITER_UNIFIED_ATTENTION``
     - Enable AITER's optimized unified attention kernel (defaults to ``0``). Only takes effect when AITER is enabled and AITER MHA is disabled (``VLLM_ROCM_USE_AITER_MHA=0``). When set to ``0``, falls back to vLLM's Triton unified attention. Can also be enabled via ``--attention-backend ROCM_AITER_UNIFIED_ATTN``.

   * - ``VLLM_ROCM_USE_AITER_FP8BMM``
     - Use AITER ``FP8`` batched matmul (defaults to ``1`` when AITER is on). Fuses ``FP8`` per-token quantization with batched GEMM (used in MLA models like DeepSeek-V3).

   * - ``VLLM_ROCM_USE_AITER_FP4BMM``
     - Use AITER ``FP4`` batched matmul (defaults to ``1`` when AITER is on). Fuses ``FP4`` per-token quantization with batched GEMM (used in MLA models like DeepSeek-V3). Requires an Instinct MI350X/MI355X GPU.

   * - ``VLLM_ROCM_USE_AITER_FUSION_SHARED_EXPERTS``
     - Fuse shared expert computation into the AITER fused-MoE kernel (defaults to ``0``). Applies to MoE models with shared experts (for example, DeepSeek-V3/R1 with 1 shared expert). Requires SiLU/GELU activation (``is_act_and_mul``). Incompatible with `MoRI <https://github.com/ROCm/mori#mori>`__ scheduling — disable with ``VLLM_ROCM_USE_AITER_FUSION_SHARED_EXPERTS=0`` if using MoRI.

   * - ``VLLM_ROCM_USE_AITER_FP4_ASM_GEMM``
     - Enable AITER assembly (HIP) FP4 GEMM kernels for MXFP4-quantized models (defaults to ``0``). When set to ``1``, uses hand-tuned ASM kernels instead of Triton for ``FP4×FP4`` weight GEMMs — faster at small batch sizes (``M`` ≤ 64). Requires Instinct MI350X/MI355X (``supports_mx()``). Combine with ``--quantization quark`` for MXFP4 models.

   * - ``VLLM_ROCM_USE_SKINNY_GEMM``
     - Prefer skinny-GEMM kernel variants for small batch sizes (defaults to ``1``). Improves performance when ``M`` dimension is small. **Recommended to keep enabled**.

   * - ``VLLM_ROCM_FP8_PADDING``
     - Pad ``FP8`` linear weight tensors to improve memory locality (defaults to ``1``). Minor memory overhead for better performance.

   * - ``VLLM_ROCM_MOE_PADDING``
     - Pad MoE weight tensors for better memory access patterns (defaults to ``1``). Same memory/performance tradeoff as ``FP8`` padding.

   * - ``VLLM_ROCM_SHUFFLE_KV_CACHE_LAYOUT``
     - This only affects the ``ROCM_AITER_FA`` backend. When set to ``0``, it uses the HIP Paged Attention implementation ``torch.ops.aiter.paged_attention_v1`` from AITER. **Good for low concurrency (for example, concurrency ≤32).** When set to ``1``, it uses the ASM Paged Attention Kernel ``pa_fwd_asm`` from AITER. **Good for high concurrency (for example, concurrency ≥32).** (Defaults to ``0`` when AITER is on.)

   * - ``VLLM_ROCM_CUSTOM_PAGED_ATTN``
     - Use custom paged-attention decode kernel when Prefill-Decode attention backend is selected (defaults to ``True``). See :ref:`Attention backend selection with AITER <vllm-optimization-aiter-backend-selection>`.

.. note::

   When ``VLLM_ROCM_USE_AITER=1``, most AITER component flags (``LINEAR``,
   ``MOE``, ``RMSNORM``, ``MLA``, ``MHA``, ``FP8BMM``) automatically default to
   ``True``. You typically only need to set the master switch
   ``VLLM_ROCM_USE_AITER=1`` to enable all optimizations. ROCm provides a
   prebuilt optimized Docker image for validating the performance of LLM
   inference with vLLM on MI300X Series GPUs. The Docker image includes ROCm,
   vLLM, and PyTorch. For more information, see :doc:`/ai-inference/vllm`.

.. _vllm-optimization-aiter-moe-requirements:
.. _vllm-optimization-aiter-mla-requirements:
.. _vllm-optimization-aiter-mla-sparse-requirements:
.. _vllm-optimization-aiter-backend-selection:

Attention backend selection with AITER
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Most models work out of the box with ``VLLM_ROCM_USE_AITER=1`` — vLLM auto-selects
the optimal backend. Use ``--attention-backend`` to override the auto-selected backend.

.. code-block:: bash

   export VLLM_ROCM_USE_AITER=1
   vllm serve <your-model> --tensor-parallel-size <tp>

.. note::
   Always set ``VLLM_ROCM_USE_AITER=1`` even when using ``--attention-backend`` explicitly.
   ``--attention-backend`` only overrides the attention kernel; ``VLLM_ROCM_USE_AITER=1``
   is still required to enable AITER for GEMM, RMSNorm, and MoE kernels.
   The Radeon/fallback backends (``ROCM_ATTN``, ``TRITON_MLA``) are the exception —
   they do not use AITER and do not require the env var.

The table below shows which backend is selected per model type and how to tune it.

.. list-table::
   :header-rows: 1
   :widths: 15 18 35 32

   * - Model type
     - Backend
     - How to enable
     - Tuning tips

   * - **MHA models** (Llama, Mistral, Qwen, Mixtral, MiniMax-M2.5)
     - **ROCM_AITER_FA** (recommended, auto-selected)
     - ``VLLM_ROCM_USE_AITER=1`` (auto-selected). To override: ``VLLM_ROCM_USE_AITER=1 --attention-backend ROCM_AITER_FA``. Add ``VLLM_ROCM_SHUFFLE_KV_CACHE_LAYOUT=1`` for shuffled KV cache.
     - **2.7–4.4x TPS** over legacy ``ROCM_ATTN``. Set ``VLLM_ROCM_SHUFFLE_KV_CACHE_LAYOUT=1`` for **15–20% decode improvement** at high concurrency. Low TTFT: ``--max-num-batched-tokens`` ≤ 8k–16k. High throughput: ≥ 32k with ``cudagraph_mode=FULL``.

   * - **MLA models** (DeepSeek-V3/R1/V2, Kimi-K2.5, Mistral-Large-3-675B)
     - **ROCM_AITER_MLA** (recommended, auto-selected)
     - ``VLLM_ROCM_USE_AITER=1`` (auto-selected). To override: ``VLLM_ROCM_USE_AITER=1 --attention-backend ROCM_AITER_MLA``. ``--block-size 1`` is no longer mandatory (vLLM ≥0.14); still recommended for prefix-caching workloads.
     - **1.2–1.5x higher TPS** over ``TRITON_MLA``. Supports uniform-batch CUDA graphs and MTP. On MI300X/MI325X (gfx942), ``ROCM_AITER_TRITON_MLA`` may show 2–3% higher TPS. On MI355X (gfx950), ``ROCM_AITER_MLA`` is preferred (uses AITER assembly MHA for prefill).

   * - **DSA models** (DeepSeek-V3.2, GLM-5)
     - **ROCM_AITER_MLA_SPARSE** (auto-selected)
     - ``VLLM_ROCM_USE_AITER=1`` — auto-detected from ``index_topk`` in model config. Requires ``--block-size 1``.
     - Instinct MI300X/MI325X/MI350X/MI355X only.

   * - **gpt-oss models** (gpt-oss-120b/20b)
     - **ROCM_AITER_UNIFIED_ATTN**
     - ``VLLM_ROCM_USE_AITER=1 --attention-backend ROCM_AITER_UNIFIED_ATTN``
     -

   * - **Radeon / fallback**
     - **ROCM_ATTN** (MHA) or **TRITON_MLA** (MLA)
     - ``--attention-backend ROCM_ATTN`` or ``TRITON_MLA``
     - ``ROCM_ATTN`` is preferred over ``TRITON_ATTN`` — it uses a custom HIP paged-attention kernel for decode when the model's KV head size is supported, and falls back to Triton only when not. If ``ROCM_ATTN`` is slow for your model (unsupported head size triggers Triton decode), try ``TRITON_ATTN``. Both work on Radeon GPUs.

.. note::
   **MoE models** (Mixtral, Llama-4-Scout/Maverick, DeepSeek-V2/V3/R1, Kimi-K2.5, MiniMax-M2.5, GLM-5, Qwen-MoE): AITER MoE kernels activate automatically with ``VLLM_ROCM_USE_AITER=1`` — no extra attention backend flags needed. If you hit ``RuntimeError: wrong! device_gemm ...``, set ``AITER_ONLINE_TUNE=1`` and retry. Only disable MoE kernels (``VLLM_ROCM_USE_AITER_MOE=0``) if that also fails.

Once AITER is configured, see `Parallelism strategies (run vLLM on multiple GPUs)`_ for TP/DP/EP choices — especially for MLA and MoE models where the wrong strategy wastes memory or throughput.

**Quick start examples**:

.. code-block:: bash

   # DSA model (DeepSeek-V3.2) — backend auto-selected from model config
   VLLM_ROCM_USE_AITER=1 vllm serve deepseek-ai/DeepSeek-V3.2 \
       --block-size 1 \
       --tensor-parallel-size 8

   # Explicitly select a backend for MLA models
   VLLM_ROCM_USE_AITER=1 vllm serve deepseek-ai/DeepSeek-R1-0528 \
       --tensor-parallel-size 8 \
       --attention-backend ROCM_AITER_MLA

   # MHA model with shuffled KV cache layout for high concurrency
   VLLM_ROCM_USE_AITER=1 VLLM_ROCM_SHUFFLE_KV_CACHE_LAYOUT=1 \
   vllm serve meta-llama/Llama-3.3-70B-Instruct \
       --attention-backend ROCM_AITER_FA

**How to verify which backend is active**

Check vLLM's startup logs to confirm which attention backend is being used:

.. code-block:: bash

   # Start vLLM and check logs
   VLLM_ROCM_USE_AITER=1 vllm serve meta-llama/Llama-3.3-70B-Instruct 2>&1 | grep -i "using.*backend"

Look for ``Using <backend_name> backend.`` in the startup output — for example,
``Using ROCM_AITER_FA backend.``

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
   * Supports GPT-OSS

2. **AITER Triton Unified Attention** (advanced, requires manual configuration)

   * The AMD optimized unified Triton kernel
   * Enable with ``VLLM_ROCM_USE_AITER=1``, ``VLLM_ROCM_USE_AITER_MHA=0``, and ``VLLM_ROCM_USE_AITER_UNIFIED_ATTENTION=1``.
   * Only useful for specific workloads. Most users should use AITER MHA instead.
   * Recommended this backend when running GPT-OSS.

3. **AITER Triton Prefill–Decode Attention** (hybrid, Instinct MI300X-optimized)

   * Enable with ``VLLM_V1_USE_PREFILL_DECODE_ATTENTION=1``
   * Uses separate kernels for prefill and decode phases:

     * **Prefill**: ``context_attention_fwd`` Triton kernel
     * **Primary decode**: ``torch.ops._rocm_C.paged_attention`` (custom ROCm kernel optimized for head sizes 64/128, block sizes 16/32, GQA 1–16, context ≤131k; sliding window not supported)
     * **Fallback decode**: ``kernel_paged_attention_2d`` Triton kernel when shapes don't meet primary decode requirements

   * Usually better compared to unified Triton kernels
   * Performance vs AITER MHA varies: AITER MHA is typically faster overall, but Prefill-Decode split may win in short input scenarios
   * The custom paged attention decode kernel is controlled by ``VLLM_ROCM_CUSTOM_PAGED_ATTN`` (default **True**)

4. **AITER Multi-Head Attention (MHA)** (default when AITER is **on**)

   * Controlled by ``VLLM_ROCM_USE_AITER_MHA`` (**1** = enabled)
   * Best all-around performance for standard transformer models
   * Automatically selected when ``VLLM_ROCM_USE_AITER=1`` and model is not MLA

5. **vLLM Triton Multi-head Latent Attention (MLA)** (for DeepSeek-V3/R1/V2)

   * Automatically selected when ``VLLM_ROCM_USE_AITER=0`` (or unset)

6. **AITER Multi-head Latent Attention (MLA)** (for DeepSeek-V3/R1/V2)

   * Controlled by ``VLLM_ROCM_USE_AITER_MLA`` (``1`` = enabled)
   * Required for optimal performance on MLA architecture models
   * Automatically selected when ``VLLM_ROCM_USE_AITER=1`` and model uses MLA
   * Requires ``--block-size 1``

Quick Reduce (large all-reduces on ROCm)
========================================

**Quick Reduce** is an alternative to RCCL/custom all-reduce for **large** inputs (MI300-class GPUs).
It supports FP16/BF16 as well as symmetric INT8/INT6/INT4 quantized all-reduce (group size 32).

.. warning::

   Quantization can affect accuracy. Validate quality before deploying.

Control via:

* ``VLLM_ROCM_QUICK_REDUCE_QUANTIZATION`` ∈ ``["NONE","FP","INT8","INT6","INT4"]`` (default ``NONE``).
* ``VLLM_ROCM_QUICK_REDUCE_CAST_BF16_TO_FP16``: cast BF16 input to FP16 (``1`` by default for performance).
* ``VLLM_ROCM_QUICK_REDUCE_MAX_SIZE_BYTES_MB``: cap the preset buffer (default ``NONE`` ≈ ``2048`` MB).

Quick Reduce tends to help **throughput** at higher TP counts (for example, 4–8) with many concurrent requests.

Parallelism strategies (run vLLM on multiple GPUs)
==================================================

vLLM supports the following parallelism strategies:

1. Tensor parallelism
2. Pipeline parallelism
3. Data parallelism
4. Expert parallelism

For more details, see `Parallelism and scaling <https://docs.vllm.ai/en/stable/serving/parallelism_scaling.html>`_.

**Quick-reference decision table:**

.. list-table::
   :header-rows: 1
   :widths: 30 35 35

   * - Model type
     - Low concurrency (≤128 requests)
     - High concurrency (≥512 requests)

   * - **Dense** (for example, Llama, Qwen-dense, Mistral-dense)
     - TP only
     - TP + independent DP replicas (your own load balancer)

   * - **MoE, standard density ≥3%** (for example, Qwen3-235B-A22B, DeepSeek-V3/R1)
     - TP + EP
     - DP + EP

   * - **MoE, ultra-sparse <1%** (for example, Llama-4-Maverick at 0.78%)
     - TP only — **no EP** (AllToAll overhead exceeds benefit)
     - DP only — **no EP**

   * - **MLA models** (for example, DeepSeek-V2/V3/R1, Kimi-K2.5, Mistral-Large-3-675B)
     - TP + EP
     - **DP + EP** — TP alone duplicates the full KV cache on every GPU; use DP Attention to partition it

EP = ``--enable-expert-parallel``. DP = ``--data-parallel-size N``.
See `Data Parallel Attention (advanced)`_ for the MLA memory explanation and `Expert parallelism`_ for EP details.

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

.. note::
   **MLA models (DeepSeek, Kimi-K2.5, Mistral-Large-3-675B):** TP alone replicates the full KV cache on every GPU, which wastes memory at high concurrency. See `Data Parallel Attention (advanced)`_ for the DP+EP configuration that partitions the KV cache instead.

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
   **ROCm best practice**: On Instinct MI300X/MI325X/MI350X/MI355X, prefer staying within a single XGMI island (≤8 GPUs) using TP only. Use PP when scaling beyond eight GPUs or across nodes.

.. _data-parallelism-section:

Data parallelism
^^^^^^^^^^^^^^^^

Data parallelism replicates model weights across separate instances/GPUs to process independent batches of requests. This approach increases throughput by distributing the workload across multiple replicas.

**Use data parallelism when:**

* Model fits on one GPU, but you need higher request throughput
* Scaling across multiple nodes horizontally
* Combining with tensor parallelism (for example, DP=2 + TP=4 = 8 GPUs total)

**Quick start - single-node:**

.. code-block:: bash

   # Model fit in 1 GPU. Creates 2 model replicas (requires 2 GPUs)
   VLLM_ALL2ALL_BACKEND="allgather_reducescatter" vllm serve /path/to/model \
       --data-parallel-size 2 \
       --disable-nccl-for-dp-synchronization

.. tip::
   For ROCm, currently use ``VLLM_ALL2ALL_BACKEND="allgather_reducescatter"`` and ``--disable-nccl-for-dp-synchronization`` with data parallelism.

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

For MLA models (DeepSeek V2/V3/R1, Kimi-K2.5), **DP+EP is the recommended configuration at high concurrency** (≥512 concurrent requests). Unlike traditional DP which replicates model weights, Data Parallel Attention uses inter-GPU AllToAll communication to partition KV cache across GPUs, avoiding the KV cache duplication that occurs with tensor parallelism.

* At **≤128 concurrent requests**, TP=8 provides 40–86% higher throughput
* At **≥512 concurrent requests**, DP=8+EP provides 16–47% higher throughput
* Crossover typically occurs around **256–512 concurrent requests**

.. code-block:: bash

   # DeepSeek-R1 with DP attention and expert parallelism (high concurrency)
   VLLM_ALL2ALL_BACKEND="allgather_reducescatter" vllm serve deepseek-ai/DeepSeek-R1 \
       --data-parallel-size 8 \
       --enable-expert-parallel \
       --disable-nccl-for-dp-synchronization

For more technical details, see `vLLM RFC #16037 <https://github.com/vllm-project/vllm/issues/16037>`_ and the `vLLM MoE Playbook <https://rocm.blogs.amd.com/software-tools-optimization/vllm-moe-guide/README.html>`_.

Expert parallelism
^^^^^^^^^^^^^^^^^^

Expert parallelism (EP) distributes expert layers of Mixture-of-Experts (MoE) models across multiple GPUs,
where tokens are routed to the GPUs holding the experts they need.

**When to use EP:**

.. list-table::
   :header-rows: 1
   :widths: 30 35 35

   * - Scenario
     - Recommended config
     - Rationale

   * - **Low concurrency** (≤128 requests)
     - TP=8 (EP optional)
     - 40–86% higher throughput than DP at low concurrency.

   * - **High concurrency** (≥512 requests)
     - DP=8 + EP
     - 16–47% higher throughput at scale (for example, 7,114 TPS for DeepSeek-R1 at 1024 concurrent requests).

   * - **MLA/MQA models** (DeepSeek-V2/V3/R1, Kimi-K2.5)
     - DP + EP
     - Avoids KV cache duplication across TP ranks. Mandatory for optimal memory at high concurrency.

   * - **Ultra-sparse MoE** (<1% activation density, for example, Llama-4-Maverick)
     - DP or TP **without** EP
     - EP adds AllToAll overhead that exceeds the benefit — EP is 7–12% *slower* for these models.

   * - **Standard MoE** (≥3% activation density, for example, DeepSeek-R1, Qwen3-235B)
     - EP flag
     - Improves expert routing efficiency.

**Basic usage:**

.. code-block:: bash

   # DP + EP for MLA+MoE models (DeepSeek-R1, high concurrency)
   VLLM_ALL2ALL_BACKEND="allgather_reducescatter" vllm serve deepseek-ai/DeepSeek-R1 \
       --data-parallel-size 8 \
       --enable-expert-parallel \
       --disable-nccl-for-dp-synchronization

   # TP + EP (low concurrency, non-MLA models)
   vllm serve deepseek-ai/DeepSeek-R1 \
       --tensor-parallel-size 8 \
       --enable-expert-parallel

**Combining with Tensor Parallelism:**

When EP is enabled alongside tensor parallelism:

* Fused MoE layers use expert parallelism
* Non-fused MoE layers use tensor parallelism

Multimodal model optimization (vision-language)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For multimodal models (Qwen3-VL, InternVL, step3), use batch-level data parallelism
for the vision encoder instead of the default tensor parallelism:

.. code-block:: bash

   vllm serve Qwen/Qwen3-VL-235B-A22B-Instruct \
       --tensor-parallel-size 8 \
       --mm-encoder-tp-mode data \
       --enable-expert-parallel \
       --max-model-len 32768

``--mm-encoder-tp-mode data`` replaces per-layer all-reduce synchronization (58–126 ops
in TP mode) with a single all-gather after encoding, yielding **10–45% throughput
improvement** with negligible memory overhead (0.2–2.3% model size increase).

**When it helps most:**

* High-resolution images (1024×1024 px): **+16% average** throughput
* 1–3 images per request: **+13–16%** throughput
* Deep vision encoders (for example, InternVL 45 blocks, step3 63 blocks)

**When to skip it:**

* Very small vision encoders (<1% of total model parameters)
* 10+ small images per request (diminishing returns)
* Memory-constrained deployments (encoder weights are replicated per GPU)

For more details, see the `vLLM Multimodal DP blog post <https://rocm.blogs.amd.com/software-tools-optimization/vllm-dp-vision/README.html>`_.

Throughput benchmarking
=======================

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
=============================

To maximize **per-node throughput**, run as many vLLM instances as model memory allows,
balancing KV-cache capacity.

* **HBM capacities**: MI300X = 192 GB HBM3; MI325X = 256 GB HBM3E; MI350X/MI355X = 288 GB HBM3E.

* Up to **eight** single-GPU vLLM instances can run in parallel on an 8×GPU node (one per GPU):

  .. code-block:: bash

      for i in $(seq 0 7); do
         CUDA_VISIBLE_DEVICES="$i" vllm bench throughput
         -tp 1 --model /path/to/model
         --dataset /path/to/ShareGPT_V3_unfiltered_cleaned_split.json &
      done

Total throughput from **N** single-GPU instances usually exceeds one instance stretched across **N** GPUs (``-tp N``).

**Model coverage**: Llama 2 (7B/13B/70B), Llama 3 (8B/70B), Qwen2 (7B/72B), Mixtral-8x7B/8x22B, and others Llama2‑70B
and Llama3‑70B can fit a single MI300X/MI325X/MI350X/MI355X; Llama3.1‑405B fits on a single 8×MI300X/MI325X/MI350X/MI355X node.

Configure the gpu-memory-utilization parameter
==================================================

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
=====================

Selected arguments that often help on ROCm. See `Engine Arguments
<https://docs.vllm.ai/en/stable/configuration/engine_args.html>`__ in the vLLM
documentation for the full list.

Configure --max-num-seqs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The default value is **1024** in vLLM V1 (increased from **256** in V0). This flag controls the maximum number of sequences processed per batch, directly affecting concurrency and memory usage.

* **To increase throughput**: Raise to **2048** or **4096** if memory allows, enabling more sequences per iteration.
* **To reduce memory usage**: Lower to **256** or **128** for large models or long-context generation. For example, set ``--max-num-seqs 128`` to reduce concurrency and lower memory requirements.

In vLLM V1, KV-cache token requirements are computed as ``max-num-seqs * max-model-len``.

Example usage:

.. code-block:: bash

   vllm serve <model> --max-num-seqs 128 --max-model-len 8192

Configure --max-num-batched-tokens
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Chunked prefill is enabled by default** in vLLM V1.

* Lower values improve **ITL** (less prefill interrupting decode).
* Higher values improve **TTFT** (more prefill per batch).

Defaults: **8192** for online serving, **16384** for offline. However, optimal values vary significantly by model size. Smaller models can efficiently handle larger batch sizes. Setting it near ``--max-model-len`` mimics V0 behavior and often maximizes throughput.

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
   * - ``TRITON_ATTN``
     - Full support (prefill + decode)
   * - ``ROCM_ATTN``, ``ROCM_AITER_UNIFIED_ATTN``
     - Full support (prefill + decode)
   * - ``ROCM_AITER_FA``, ``ROCM_AITER_MLA``, ``ROCM_AITER_TRITON_MLA``
     - Uniform batches only
   * - ``ROCM_AITER_MLA_SPARSE``
     - Uniform single-token decode only
   * - ``TRITON_MLA``
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
====================

vLLM supports FP4/FP8 (4-bit/8-bit floating point) weight and activation quantization using hardware acceleration on the Instinct MI300X and MI355X.
Quantization of models with FP4/FP8 allows for a **2x-4x** reduction in model memory requirements and up to a **1.6x**
improvement in throughput with minimal impact on accuracy.

vLLM ROCm supports a variety of quantization demands:

* On-the-fly quantization

* Pre-quantized model through Quark and llm-compressor

Supported quantization methods
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

vLLM on ROCm supports the following quantization methods for the AMD Instinct MI300 series and Instinct MI350 series GPUs:

.. list-table::
   :header-rows: 1
   :widths: 20 15 15 20 30

   * - Method
     - Precision
     - ROCm support
     - Memory reduction
     - Best use case
   * - **FP8** (W8A8)
     - 8-bit float
     - Excellent
     - 2× (50%)
     - Production, balanced speed/accuracy
   * - **PTPC-FP8**
     - 8-bit float
     - Excellent
     - 2× (50%)
     - High throughput, better than ``FP8``
   * - **AWQ**
     - 4-bit int (W4A16)
     - Good
     - 4× (75%)
     - Large models, memory-constrained
   * - **GPTQ**
     - 4-bit/8-bit int
     - Good
     - 2-4× (50-75%)
     - Pre-quantized models available
   * - **FP8 KV-cache**
     - 8-bit float
     - Excellent
     - KV cache: 50%
     - All inference workloads
   * - **Quark (AMD)**
     - ``FP8``/``MXFP4``
     - Optimized
     - 2-4× (50-75%)
     - AMD pre-quantized models
   * - **compressed-tensors**
     - W8A8 ``INT8``/``FP8``
     - Good
     - 2× (50%)
     - LLM Compressor models

**ROCm support key:**

- Excellent: Fully supported with optimized kernels
- Good: Supported, might not have AMD-optimized kernels
- Optimized: AMD-specific optimizations available

Using Pre-quantized Models
^^^^^^^^^^^^^^^^^^^^^^^^^^^

AMD provides pre-quantized models optimized for ROCm. These models are ready to use with vLLM.

**AMD Quark-quantized models**:

Available on `Hugging Face <https://huggingface.co/models?other=quark>`_:

* `Llama‑3.1‑8B‑Instruct‑FP8‑KV <https://huggingface.co/amd/Llama-3.1-8B-Instruct-FP8-KV>`__ (FP8 W8A8)
* `Llama‑3.1‑70B‑Instruct‑FP8‑KV <https://huggingface.co/amd/Llama-3.1-70B-Instruct-FP8-KV>`__ (FP8 W8A8)
* `Llama‑3.1‑405B‑Instruct‑FP8‑KV <https://huggingface.co/amd/Llama-3.1-405B-Instruct-FP8-KV>`__ (FP8 W8A8)
* `Mixtral‑8x7B‑Instruct‑v0.1‑FP8‑KV <https://huggingface.co/amd/Mixtral-8x7B-Instruct-v0.1-FP8-KV>`__ (FP8 W8A8)
* `Mixtral‑8x22B‑Instruct‑v0.1‑FP8‑KV <https://huggingface.co/amd/Mixtral-8x22B-Instruct-v0.1-FP8-KV>`__ (FP8 W8A8)
* `Llama-3.3-70B-Instruct-MXFP4-Preview <https://huggingface.co/amd/Llama-3.3-70B-Instruct-MXFP4-Preview>`__ (MXFP4 for MI350/MI355)
* `Llama-3.1-405B-Instruct-MXFP4-Preview <https://huggingface.co/amd/Llama-3.1-405B-Instruct-MXFP4-Preview>`__ (MXFP4 for MI350/MI355)
* `DeepSeek-R1-0528-MXFP4-Preview <https://huggingface.co/amd/DeepSeek-R1-0528-MXFP4-Preview>`__ (MXFP4 for MI350/MI355)

**Quick start**:

.. code-block:: bash

   # FP8 W8A8 Quark model
   vllm serve amd/Llama-3.1-8B-Instruct-FP8-KV \
      --dtype auto

   # MXFP4 Quark model for MI350/MI355
   vllm serve amd/Llama-3.3-70B-Instruct-MXFP4-Preview \
      --dtype auto \
      --tensor-parallel-size 1

**Other pre-quantized models**:

- AWQ models: `Hugging Face awq flag <https://huggingface.co/models?other=awq>`_
- GPTQ models: `Hugging Face gptq flag <https://huggingface.co/models?other=gptq>`_
- LLM Compressor models: `Hugging Face compressed-tensors flag <https://huggingface.co/models?other=compressed-tensors>`_

On-the-fly quantization
^^^^^^^^^^^^^^^^^^^^^^^^

For models without pre-quantization, vLLM can quantize ``FP16``/``BF16`` models at server startup.

**Supported methods**:

- ``fp8``: Per-tensor ``FP8`` weight and activation quantization
- ``ptpc_fp8``: Per-token-activation per-channel-weight ``FP8`` (better accuracy same ``FP8`` speed). See `PTPC-FP8 on ROCm blog post <https://blog.vllm.ai/2025/02/24/ptpc-fp8-rocm.html>`_ for details

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

.. note::

   On-the-fly quantization adds two to five minutes of startup time but eliminates pre-quantization. For production with frequent restarts, use pre-quantized models.

GPTQ
^^^^

GPTQ (4-bit/8-bit weight quantization) is fully supported on ROCm via HIP-compiled kernels.
Pre-quantized GPTQ models from Hugging Face work out of the box. For better throughput on AMD Instinct GPUs,
consider **AWQ with Triton kernels** or **FP8 quantization** instead.

.. code-block:: bash

   vllm serve RedHatAI/Meta-Llama-3.1-70B-Instruct-quantized.w4a16 \
      --quantization gptq \
      --dtype auto \
      --tensor-parallel-size 1

AWQ (Activation-aware Weight Quantization)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

AWQ (Activation-aware Weight Quantization) is a 4-bit weight quantization technique that provides excellent
model compression with minimal accuracy loss (<1%). ROCm supports AWQ quantization on the AMD Instinct MI300 series and
MI350 series GPUs with vLLM.

**Using pre-quantized AWQ models:**

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
  the **activation dtype** (``FP16``/``BF16`` for computations), not the weight dtype. AWQ weights remain as INT4
  (4-bit integers) as specified in the model's quantization config, but are dequantized to ``FP16``/``BF16`` during
  matrix multiplication operations.
* **Group size:** 128 is recommended for optimal performance/accuracy balance
* **Model compatibility:** AWQ is primarily tested on Llama, Mistral, and Qwen model families

Quark (AMD quantization toolkit)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

AMD Quark is the AMD quantization toolkit optimized for ROCm. It supports ``FP8 W8A8``, ``MXFP4``, ``W8A8 INT8``, and
other quantization formats with native vLLM integration. The quantization format will automatically be inferred
from the model config file, so you can omit ``--quantization quark``.

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

**Key features:**

- **FP8 models**: ~50% memory reduction, 2× compression
- **MXFP4 models**: ~75% memory reduction, 4× compression
- **Embedded scales**: Quark FP8-KV models include pre-calibrated KV-cache scales
- **Hardware optimized**: Leverages the AMD Instinct MI300 series ``FP8`` acceleration

For creating your own Quark-quantized models, see `Quark Documentation <https://quark.docs.amd.com/latest/>`_.

FP8 kv-cache dtype
^^^^^^^^^^^^^^^^^^^^

FP8 KV-cache quantization reduces memory footprint by approximately 50%, enabling longer context lengths
or higher concurrency. ROCm supports FP8 KV-cache with both ``fp8_e4m3`` and ``fp8_e5m2`` formats on
AMD Instinct MI300 series and other CDNA™ GPUs.

Use ``--kv-cache-dtype fp8`` to enable ``FP8`` KV-cache quantization. For best accuracy, use calibrated
scaling factors generated via `LLM Compressor <https://github.com/vllm-project/llm-compressor>`_.
Without calibration, scales are calculated dynamically (``--calculate-kv-scales``) with minimal
accuracy impact.


**Quick start (dynamic scaling)**:

.. code-block:: bash

   # vLLM serve with dynamic FP8 KV-cache
   vllm serve meta-llama/Llama-3.1-8B-Instruct \
      --kv-cache-dtype fp8 \
      --calculate-kv-scales \
      --gpu-memory-utilization 0.90

**Calibrated scaling (advanced)**:

For optimal accuracy, pre-calibrate KV-cache scales using representative data. The calibration process:

#. Runs the model on calibration data (512+ samples recommended)
#. Computes optimal ``FP8`` quantization scales for key/value cache tensors
#. Embeds these scales into the saved model as additional parameters
#. vLLM loads the model and uses the embedded scales automatically when ``--kv-cache-dtype fp8`` is specified

The quantized model can be used like any other model. The embedded scales are stored as part of the model weights.

**Using pre-calibrated models:**

AMD provides ready-to-use models with pre-calibrated ``FP8`` KV cache scales:

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

**Format options**:

- ``fp8`` or ``fp8_e4m3``: Higher precision (default, recommended)
- ``fp8_e5m2``: Larger dynamic range, slightly lower precision

Speculative decoding (experimental)
===================================

Recent vLLM versions add support for speculative decoding backends (for example, Eagle‑v3). Evaluate for your model and latency/throughput goals.
Speculative decoding is a technique to reduce latency when max number of concurrency is low.
Depending on the methods, the effective concurrency varies, for example, from 16 to 64.

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


.. important::

   It has been observed that more ``num_speculative_tokens`` causes less
   acceptance rate of draft model tokens and a decline in throughput. As a
   workaround, set ``num_speculative_tokens`` to <= 2.


Multi-node checklist and troubleshooting
========================================

1. Use ``--distributed-executor-backend ray`` across nodes to manage HIP-visible ranks and RCCL communicators. (``ray`` is the default for multi-node. Explicitly setting this flag is optional.)
2. Ensure ``/dev/shm`` is shared across ranks (Docker ``--shm-size``, Kubernetes ``emptyDir``), as RCCL uses shared memory for rendezvous.
3. For GPUDirect RDMA, set ``RCCL_NET_GDR_LEVEL=2`` and verify links (``ibstat``). Requires supported NICs (for example, ConnectX‑6+).
4. Collect RCCL logs: ``RCCL_DEBUG=INFO`` and optionally ``RCCL_DEBUG_SUBSYS=INIT,GRAPH`` for init/graph stalls.

Deprecated terms
================

* **Prefill-Decode attention** has been renamed to **ROCM_ATTN** (ROCm attention). Use ``--attention-backend ROCM_ATTN`` to select this backend.

Further reading
===============

* :doc:`workload-optimization`
* :doc:`/ai-inference/vllm`
