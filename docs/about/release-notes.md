# ROCm Core SDK {{ ROCM_VERSION }} release notes

ROCm Core SDK {{ ROCM_VERSION }} is the latest production release stream incrementally built upon the previous preview and production release stream, advancing the transition to the new
[TheRock](https://github.com/rocm/therock) build and release system. To learn
more, see the [transition guide](/about/transition-guide-TheRock).

(preview-stream-note)=
:::{important}
ROCm {{ ROCM_VERSION }} follows the
<a href="https://rocm.docs.amd.com/en/7.9.0-preview/about/release-notes.html#preview-stream-note"
target="_blank">versioning discontinuity that began with the 7.9.0 preview release</a>
and remains separate from the 7.0 to 7.2 production releases. For the latest
preview stream release, see the
<a href="https://rocm.docs.amd.com/en/7.13.0-preview/index.html">ROCm documentation</a>.

Parallel release streams -- preview and production -- were maintained to provided the
users with ample time to evaluate and adopt the new build system and dependency
changes. The technology preview stream is now replaced by the current production stream.

For previous preview releases, see the
<a target="_blank" href="https://rocm.docs.amd.com/en/7.13.0-preview/release/versions.html">release history</a>.
:::

## Release highlights

ROCm Core SDK {{ ROCM_VERSION }} with TheRock builds upon the [7.13.0 preview
release](https://rocm.docs.amd.com/en/7.13.0-preview/about/release-notes.html).

This release expands support for AI inference, distributed workloads, and
profiling workflows across AMD Instinct™, Radeon™, and Ryzen™ AI platforms.
ROCm 7.14.0 adds inference-ready vLLM containers, expands GPU virtualization
and partitioning support, introduces new profiling and tracing capabilities,
and improves AI kernel, sparse math, and communication libraries.

### Platform and hardware support

This release expands GPU, operating system, virtualization, and partitioning support.

#### Expanded AMD GPU support

AMD GPUs and APUs support remains unchanged from the previous [ROCm 7.13.0 preview](https://rocm.docs.amd.com/en/7.13.0-preview/about/release-notes.html#expanded-amd-gpu-support) release.

For the complete list of supported AMD hardware, see [AMD hardware support](#amd-hardware-support).

#### Expanded Ubuntu support

Ubuntu support remains unchanged from the previous [ROCm 7.13.0 preview](https://rocm.docs.amd.com/en/7.13.0-preview/about/release-notes.html#expanded-ubuntu-support) release.

For the full list of supported Linux distributions, see [Operating system support](#operating-system-support).

#### Expanded GPU virtualization support for Instinct GPUs

GPU virtualization configurations supported on AMD Instinct GPUs remains unchanged from the previous [ROCm 7.13.0 preview](https://rocm.docs.amd.com/en/7.13.0-preview/about/release-notes.html#expanded-gpu-virtualization-support-for-instinct-gpus) release.

Supported SR-IOV configurations require the [GIM Driver
9.0.0K](https://github.com/amd/MxGPU-Virtualization/releases/tag/9.0.0.K). For
details, see [GPU virtualization support](#gpu-virtualization-support).

#### Expanded Instinct GPU partitioning support

GPU partitioning configurations in bare metal deployments remains unchanged from the previous [ROCm 7.13.0 preview](https://rocm.docs.amd.com/en/7.13.0-preview/about/release-notes.html#expanded-instinct-gpu-partitioning-support) release.

For details, see [GPU partitioning support](#gpu-partitioning-support).

### ROCm support for WSL2 (initial launch)

You can now run ROCm workloads on Windows through Windows Subsystem for Linux 2 (WSL2), available as initial support in ROCm 7.14. The ROCr Runtime automatically detects a WSL2 environment by checking for the `/dev/dxg` device and loads the corresponding driver interface, so no manual configuration is required in the common case. To disable auto-detection, set the `HSA_ENABLE_DXG_DETECTION` environment variable to `0` (by default, it is `1`). For details, see the ROCr environment variables reference.

This initial launch targets Ubuntu through `.deb` packages and Python wheels; RPM packages are not in scope. AMD SMI, profiling, and debugging are not supported in WSL2 at launch.

### AMD Infinity Storage direct I/O for finer-than-4 KB alignments

AMD Infinity Storage now uses direct GPU-to-storage I/O for files with alignment requirements finer than 4 KB. hipFile reads each file's reported memory and offset alignment requirements (using statx) and takes the direct path whenever the I/O meets those requirements, avoiding the extra host-side copy. This delivers higher throughput, lower latency, and more fine-grained support for very small I/O operations, reducing command overhead.

### AI inference and frameworks

This release adds inference-ready container images and improves multi-node communication for distributed workloads.

#### vLLM 0.2x.0 Docker images and pip packages

With ROCm 7.14.0, Docker images for running vLLM inference workloads are
available. Images include vLLM 0.2x.0, PyTorch 2.11, and Python 3.14 on Ubuntu 24.04.

Architecture-specific images are available for:

* AMD Instinct GPUs: gfx942 (MI325X, MI300X, MI300A) and gfx950 (MI355X, MI350X, MI350P)
* AMD Radeon GPUs: gfx1100, gfx1101, gfx1102, gfx1200, gfx1201
* AMD Ryzen AI APUs: gfx1150, gfx1151, gfx1152

See [](../ai-inference/vllm) to get started.

### Developer tools and profiling

This release adds new profiling capabilities, extends HIP API support, a.

#### HIP feature highlights

The following are notable enhancements to HIP:

* **HIP green context support**: HIP now supports green contexts in parity with CUDA Green Contexts, for GPU compute resource partitioning and lightweight execution context management within a single device. You can query and split device resources, create green contexts on resource subsets, and create streams and events scoped to those contexts. 

* **HIP CUDA parity API additions**: 

    * Batch memory management: New batch asynchronous memory management APIs let applications discard (`hipMemDiscardBatchAsync`), prefetch (`hipMemPrefetchBatchAsync`), or combine both operations (`hipMemDiscardAndPrefetchBatchAsync`) across multiple memory ranges in a single call, reducing API call overhead. Both HIP runtime and HIP driver variants are available.
    
    * Library management: New library management APIs return the device pointer and size of a device global (`hipLibraryGetGlobal`) and the host pointer and size of a managed variable (`hipLibraryGetManaged`) defined in a `hipLibrary_t`, improving parity with CUDA library APIs.

* **Faster HIP graph replay for asynchronous memory allocations**: HIP graph replay now reduces overhead for graphs that interleave asynchronous memory allocations with compute. Allocation nodes no longer block during replay — physical memory is reused across nodes instead of being mapped and unmapped on each launch, eliminating the gaps between kernels this pattern previously caused.

* **HIP VMM support for non-Host Transparent fabric handles**: HIP Virtual Memory Management (VMM) APIs now support non-Host Transparent (nHT) fabric handles, enabling efficient cross-device memory sharing over Infinity Fabric over Ethernet (IFoE). Peer devices can access shared memory without host staging, reducing data movement overhead for multi-GPU and distributed workloads.

#### AMD SMI feature highlights

The following are notable enhancements to AMD SMI:

* **Fabric telemetry for IFoE**: AMD SMI now monitors Infinity Fabric over Ethernet (IFoE) fabric links. The new `amd-smi` fabric command reports fabric topology and link information, and new C and Python APIs expose the same telemetry.

* **APU VRAM carveout and GTT tuning**: AMD SMI now tunes APU memory from the command line, consolidating the get and set controls previously handled by the standalone amd-ttm tool and adding VRAM carveout configuration. 

    * VRAM carveout: `amd-smi static --mem-carveout` lists the available carveout options, and `amd-smi set --mem-carveout` changes the VRAM carveout on APUs.

    * GTT tuning: `amd-smi set --gtt` and `amd-smi reset --gtt` adjust the system-wide GTT size. `amd-smi node --gtt` shows the active value and any pending value that applies after the next reboot.

Carveout and GTT changes take effect after the next reboot, and AMD SMI rebuilds the initramfs automatically so the new configuration is applied at boot. 

* **Fabric clock (FCLK) capping on MI300A**: You can now cap the maximum fabric clock (FCLK) on AMD Instinct MI300A GPUs to steer power, using the new fclk clock type for `amd-smi set --clk-limit`. Only a maximum limit is supported.

* **Go bindings for CPU telemetry**: AMD SMI now exposes ESMI CPU functionality through its Go bindings, so Go applications can query CPU telemetry in-process without invoking external binaries or embedding C or Python runtimes. This simplifies integrating AMD CPU observability into Go-based control planes.

For more information, see the AMD SMI section in the [ROCm component changelogs](#rocm-component-changelogs).

#### ROCprofiler-SDK feature highlights

The following are notable enhancements to the ROCprofiler-SDK:

* **PyTorch Profiler backend migrates to ROCprofiler-SDK**: PyTorch Profiler, through Kineto, now uses ROCprofiler-SDK as its default profiling backend in PyTorch 2.12 and later, replacing the deprecated ROCTracer integration. This migration improves trace completeness by addressing missing kernels under load and trace data loss during shutdown, while eliminating the runtime dependency on ROCTracer.

* **Proton profiling backend migrates to ROCprofiler-SDK**: Proton, Triton's low-overhead kernel-level profiler, now uses ROCprofiler-SDK as its backend, replacing the deprecated ROCTracer integration. This gives Triton users access to ROCprofiler-SDK profiling capabilities:

    * Kernel dispatch tracing: Capture kernel launches, including when HIP graphs are enabled.

    * PC sampling: Collect program counter samples on supported hardware for fine-grained, instruction-level performance analysis.

    * Late-start profiling: Retroactively intercept existing HIP and HSA queues, enabling profiling in Python-based AI stacks (Triton, PyTorch, vLLM) that initialize HIP and launch GPU work before Proton is imported.

* **ROCTx resume and pause profiling control**: ROCprofiler-SDK adds the `--selected-regions` option to `rocprofv3`, letting you confine profiling to the code regions you annotate with `roctxProfilerResume()` and `roctxProfilerPause()`. With this option set, profiling starts disabled and collects data only inside the marked regions, reducing output size.

All profiling data respects the region: kernel traces, API traces, memory copy traces, and counter collection are captured only within resumed regions, not just marker traces.

* **Streaming Performance Monitor (SPM) support in ROCprofiler-SDK (beta)**: ROCprofiler-SDK adds support for the Streaming Performance Monitor (SPM), which streams GPU hardware performance counters continuously at a configurable sampling rate. Instead of aggregating counters per kernel dispatch, SPM produces time-resolved counter values alongside kernel dispatch information, giving you visibility into how GPU behavior changes over the course of a workload.

SPM is available through a new experimental API and through `rocprofv3`. As a beta feature, it must be explicitly enabled. For the full set of API and CLI options, see the ROCprofiler-SDK section in the [ROCm component changelogs](#rocm-component-changelogs).

#### ROCm Compute Profiler feature highlights

The following are notable enhancements to the ROCm Compute Profiler (rocprofiler-compute).

* **pip installation support**: ROCm Compute Profiler is now pip-installable. A new `rocm-profiler` wheel on the ROCm Python package index lets you install ROCm Compute Profiler into a custom Python environment without building ROCm from source. The wheel packages installs both ROCm Compute Profiler and ROCm Systems Profiler binaries.

* **PyTorch operator statistics table (experimental)**: PyTorch tracing `--torch-trace` in ROCm Compute Profiler now includes a per-operator statistics summary table, making it easier to spot hot operators and per-dispatch variance. The trace now also captures backward-pass and nested operators that were previously missed or misattributed.

* **ISA collection for PC sampling (experimental)**: ROCm Compute Profiler now collects per-kernel Instruction Set Architecture (ISA) during profiling, providing the foundation for instruction-level analysis with PC sampling. In the analyze phase, you can preview ISA per kernel from the CLI and view a PC sampling summary. CSV and database export for ISA data are planned for a future release.

#### ROCm Systems Profiler feature highlights

The following are notable enhancements to the ROCm Systems Profiler (rocprofiler-systems).

* **GPU hardware counter sampling**: ROCm Systems Profiler now samples GPU hardware Performance Metric Counters (PMC) at a user-defined interval through ROCprofiler-SDK, decoupling counter collection from kernel dispatch. This lets you profile long-running workloads with lower overhead and less measurement distortion.

* **Unified memory profiling**: Managed (unified) memory activity across host-to-device and device-to-host transfers is now detected and aggregated, with a dedicated summary section in the CLI and GUI that reports per-transfer counts, sizes, and timing. This helps you diagnose the migrations and page faults that affect performance and measure the impact of XNACK.

* **KFD page table event tracing**: Kernel Fusion Driver (KFD) page table events are now traced through the ROCprofiler-SDK KFD events API, replacing the previous page-migration API integration, with page migration and page fault events exposed directly in the profiler output. This keeps page-movement visibility on the actively supported profiling API for workloads that depend on fine-grained memory management.

* **pip installation support**: ROCm Systems Profiler and its components, including `rocpd`, are now distributed as pip-installable packages that work across multiple Python versions, with functional parity. A new `rocm-profiler` wheel on the ROCm Python package index lets you install ROCm Systems Profiler into a custom Python environment without building ROCm from source. The wheel packages installs both ROCm Compute Profiler and ROCm Systems Profiler binaries.

* **Selective MPI rank profiling**: In MPI jobs, you can now restrict profile and trace output to a chosen subset of ranks, while unselected ranks run undisturbed. This cuts data volume and speeds up post-run analysis, and works across MPI implementations such as MPICH and OpenMPI, including heterogeneous and multi-node environments.

* **MPI rank console log control**: You can now limit console output to a specified subset of ranks while profiling and tracing continue on every rank. This reduces console log noise in large multi-rank runs without sacrificing collection coverage. Existing behavior is preserved when no rank-selection option is set.

* **ROCTx region selective profiling**: When your application is instrumented with ROCTx region push and pop APIs, you can now include or exclude specific named regions to scope collection to the code paths you're investigating. This shrinks trace and profile volume and speeds up profiling on large applications.

* **AI NIC performance profiling**: Additional AI NIC performance metrics for Pensando AI NICs are now collected through AMD SMI, including local ACK timeout errors (an approximation of Remote Direct Memory Access (RDMA) round-trip time) and packet sequence errors. This helps you spot RDMA latency and packet loss in distributed, multi-node workloads.

For more information, see the ROCm Systems Profiler section in the [ROCm component changelogs](#rocm-component-changelogs).

### Libraries

This release adds new routines, data type support, and performance improvements across ROCm math and AI libraries.

#### Per-matrix bias support in hipBLASLt batched GEMM

You can now apply a unique bias vector to each matrix in a strided batched GEMM with hipBLASLt. Set the new `HIPBLASLT_MATMUL_DESC_BIAS_BATCH_STRIDE` matmul descriptor attribute to specify the stride between consecutive bias vectors in device memory when `HIPBLASLT_EPILOGUE_BIAS` is set in the epilogue. A stride of 0 (the default) preserves the previous behavior of broadcasting a single bias vector to all matrices in the batch.

For more information, see the [hipBLASLt documentation](https://rocm.docs.amd.com/projects/hipBLASLt/en/develop/index.html).

#### RCCL feature highlights

* **Hierarchical AllGather**: RCCL adds a hierarchical AllGather algorithm that improves scale-out performance for large multi-node jobs by separating inter-node from intra-node communication, relieving the concurrency pressure that constrains the existing ring and direct algorithms across many GPUs. On AMD Instinct MI350 Series GPUs, hierarchical AllGather is enabled by default starting from 8 nodes. To disable it, set the environment variable `RCCL_HIERARCHICAL_ALLGATHER=0`.

* **Direct reduce-scatter**: RCCL adds a direct reduce-scatter algorithm that lowers latency for small to medium message sizes on AMD Instinct MI350 Series GPUs, as an alternative to the existing ring-based implementation. RCCL selects it automatically for multi-node reduce-scatter operations within a configurable message-size threshold.

* **Copy Engine collectives (Preview)**: RCCL now offloads collective data movement to the GPU copy engine on AMD Instinct MI355X GPUs through new Copy Engine collectives. This frees compute units during communication-bound collectives, so compute and communication can overlap. RCCL uses a batched copy path when available, falls back to multi-stream or single-stream transfers otherwise, and preserves correct behavior during HIP graph capture.

#### RDC adds telemetry fields for Device Metrics Exporter parity

ROCm Data Center (RDC) tool adds 59 telemetry fields, bringing its metric coverage to near parity with the Device Metrics Exporter (DME). New fields span energy, junction temperature, clock ranges, memory and PCIe details, per-engine activity, ECC deferred-error counts, and violation and throttle health metrics, letting telemetry consumers read them directly through RDC. Some of the newest health metrics require recent driver and hardware support and report as unsupported on older platforms. An automated check keeps RDC's coverage aligned with DME as new metrics are added.

For more information, see the RDC section in the ROCm component changelogs.

#### Per-batch scalar coefficients for batched Level 2 BLAS

rocBLAS and hipBLAS now support per-batch scalar coefficients for Level 2 batched and strided-batched routines: GEMV (`alpha` and `beta`) and the GER family — GER, GERU, and GERC (`alpha`). In device pointer mode, each batch index uses its own device-resident scalar instead of one shared across the whole batch. rocBLAS exposes this through `rocblas_set_batch_alpha_stride` (with the beta equivalent for GEMV); hipBLAS adds the matching `hipblasSetBatchAlphaStride` and `hipblasSetBatchBetaStride` APIs and routes them to rocBLAS. S, D, C, and Z precisions are available. For more information, see the rocBLAS section in the [ROCm component changelogs](#rocm-component-changelogs).

#### BSR format support in hipSPARSE generic routines

You can now use Block Sparse Row (BSR) format matrices with the hipSPARSE generic sparse compute routines ``hipsparseSpMM`` (sparse matrix-matrix multiplication) and ``hipsparseSpMV`` (sparse matrix-vector multiplication). Two new descriptor functions, ``hipsparseCreateBsr`` and ``hipsparseCreateConstBsr``, let you construct BSR-format sparse matrices for use with the generic API. This brings hipSPARSE to parity with the equivalent cuSPARSE routines in CUDA, where BSR was previously available only through the rocSPARSE API.

#### hipSPARSE legacy SpGEAM routines are deprecated

The legacy hipSPARSE csrgeam routines — ``hipsparseXcsrgeamNnz``, ``hipsparseScsrgeam``, ``hipsparseDcsrgeam``, ``hipsparseCcsrgeam``, and ``hipsparseZcsrgeam`` are deprecated and will be removed in a future release. Use the following csrgeam2 routines instead:
* ``hipsparseScsrgeam2_bufferSizeExt``
* ``hipsparseDcsrgeam2_bufferSizeExt``
* ``hipsparseCcsrgeam2_bufferSizeExt``
* ``hipsparseZcsrgeam2_bufferSizeExt``
* ``hipsparseXcsrgeam2Nnz``
* ``hipsparseScsrgeam2``
* ``hipsparseDcsrgeam2``
* ``hipsparseCcsrgeam2``
* ``hipsparseZcsrgeam2``

#### rocSPARSE legacy index type deprecation

The `rocsparse_indextype_u16` field of the `rocsparse_indextype` enum is now deprecated and will be removed in a future release. Code using `rocsparse_indextype_u16` now produces deprecation warnings at compile time. Migrate to `rocsparse_indextype_i32` or `rocsparse_indextype_i64`.

(release-supported-hw)=

## AMD hardware support

The following table lists supported AMD Instinct GPUs, Radeon GPUs, and Ryzen
APUs. Each supported device is listed with its corresponding GPU
microarchitecture and LLVM target.

:::{note}

If your GPU is not listed, it might be community-enabled through TheRock
nightly builds. For more information, see [TheRock supported
GPUs](https://github.com/ROCm/TheRock/blob/main/SUPPORTED_GPUS.md). For
installation guidance, see [TheRock
releases](https://github.com/ROCm/TheRock/blob/main/RELEASES.md).
:::

```{include} ./include/hardware-support-table.md
:parser: myst
```

(release-supported-os)=

## Operating system support

ROCm supports the following Linux distribution and Microsoft Windows versions.
If you're running ROCm on Linux, ensure your system is using a supported kernel
version.

:::{important}
The following table is a general overview of supported OSes. Actual support
might vary by AMD GPU or APU. Use the {doc}`Compatibility matrix
</compatibility/compatibility-matrix>` to verify support for your specific
setup before installation.
:::

```{include} ./include/os-support-table.md
:parser: myst
```

## Installation updates

ROCm 7.14.0 introduces several improvements to the Runfile Installer:

[Placeholder]

(release-supported-fw)=

## Kernel driver and firmware bundle support

ROCm requires a coordinated stack of compatible firmware, driver, and user
space components. Maintaining version alignment between these layers ensures
correct GPU operation and performance, especially for AMD data center products.
While AMD publishes the AMD GPU driver and ROCm user space components, your
server OEM (original equipment manufacturer) or infrastructure provider
distributes the firmware packages. AMD supplies those firmware images (PLDM
bundles), which the OEM integrates and distributes.

```{include} ./include/driver-firmware-support-table.md
:parser: myst
```

(release-virtualization-support)=

## GPU virtualization support

AMD Instinct data center GPUs support virtualization in the following
configurations. Supported SR-IOV configurations require the AMD GPU
Virtualization Driver (GIM) 9.0.0K -- see the [AMD Instinct Virtualization
Driver
documentation](https://instinct.docs.amd.com/projects/virt-drv/en/mainline-9.0.0.k/)
for more information.

```{include} ./include/virtualization-support-table.html
:parser: myst
```

(release-gpu-partitioning-support)=

## GPU partitioning support

```{include} ./include/partitioning-support-table.md
:parser: myst
```

See the [AMD GPU partitioning](https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/gpu-partitioning/index.html)
topic in the AMD GPU Driver documentation to learn more.

(release-ai-ecosystem)=

## AI ecosystem support

ROCm 7.14.0 provides optimized support for popular deep learning frameworks and
AI inference engines. The following table lists supported frameworks and
libraries, their compatible operating systems, and validated versions.

```{include} ./include/ai-ecosystem-support-table.html
:parser: myst
```

(release-components)=

## ROCm Core SDK components

The following table lists core tools and libraries included in the ROCm 7.14.0
release.

:::{important}
The following table is a general overview of ROCm Core SDK components. Actual
support for these libraries and tools can vary by GPU and OS. Use the
{doc}`Compatibility matrix </compatibility/compatibility-matrix>` to verify
support for your specific setup.
:::

```{include} ./include/core-sdk-components-table.html
:parser: myst
```

### ROCm component changelogs

The following sections describe key changes to ROCm Core SDK components.

```{include} ./include/core-sdk-components-aggregated-changelog.md
:parser: myst
```

## ROCm known issues

ROCm known issues are noted on {fab}`github` [GitHub](https://github.com/ROCm/ROCm/labels/Verified%20Issue). These issues will be fixed in a future ROCm release. For known issues related to individual components, review the [ROCm component changelogs](#rocm-component-changelogs).

## ROCm upcoming changes

Future releases will add support for:

* Additional ROCm Core SDK components

* Domain-specific expansion toolkits (data science, life science, finance,
  simulation, and other HPC domains)

* More AMD hardware support
