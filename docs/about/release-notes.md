# ROCm Core SDK {{ ROCM_VERSION }} release notes

ROCm Core SDK {{ ROCM_VERSION }} transitions ROCm to [TheRock](https://github.com/ROCm/TheRock), a build and release system that introduces a modular architecture to improve flexibility, maintainability, and alignment with community use cases:

* **Leaner core**: The Core SDK focuses on essential runtime and development components.
* **Use case-specific expansions**: Optional domain-specific SDKs for AI, data science, and HPC.
* **Modular installation**: Install only the components required for your workflow.

This approach streamlines installation, reduces footprint, and accelerates innovation through independently released packages. To learn more, see the [transition guide](/about/transition-guide-TheRock).

(preview-stream-note)=
:::{note}
ROCm {{ ROCM_VERSION }} follows the [versioning discontinuity that began with the 7.9.0 preview](https://rocm.docs.amd.com/en/7.9.0-preview/about/release-notes.html#preview-stream-note) release.
:::

## Release highlights

This release focuses on AI inference, distributed workloads, and profiling across AMD Instinct™, Radeon™, and Ryzen™ AI platforms. Highlights include inference-ready vLLM images and packages, ROCprofiler-SDK adoption across AI profiling workflows, expanded system telemetry and validation coverage, and updates to math, sparse, and communication libraries.

### Platform and hardware support

This release expands GPU, operating system, virtualization, and partitioning support.

#### Expanded AMD GPU support

ROCm 7.14.0 adds support for the following AMD APUs:

* [AMD Ryzen AI MAX+ PRO 495 (gfx1151)](https://www.amd.com/en/products/processors/laptop/ryzen-pro/ai-max-pro-400-series/amd-ryzen-ai-max-plus-pro-495.html)
* [AMD Ryzen AI MAX PRO 490 (gfx1151)](https://www.amd.com/en/products/processors/laptop/ryzen-pro/ai-max-pro-400-series/amd-ryzen-ai-max-pro-490.html)
* [AMD Ryzen AI MAX PRO 485 (gfx1151)](https://www.amd.com/en/products/processors/laptop/ryzen-pro/ai-max-pro-400-series/amd-ryzen-ai-max-pro-485.html)
* [AMD Ryzen AI 5 435 (gfx1153)](https://www.amd.com/en/products/processors/laptop/ryzen/ai-400-series/amd-ryzen-ai-5-435.html)
* [AMD Ryzen AI 5 430 (gfx1153)](https://www.amd.com/en/products/processors/laptop/ryzen/ai-400-series/amd-ryzen-ai-5-430.html)
* [AMD Ryzen AI 5 PRO 435 (gfx1153)](https://www.amd.com/en/products/processors/laptop/ryzen-pro/ai-400-series/amd-ryzen-ai-5-pro-435.html)
* [AMD Ryzen AI 7 445 (gfx1153)](https://www.amd.com/en/products/processors/laptop/ryzen/ai-400-series/amd-ryzen-ai-7-445.html)

For the complete list of supported AMD hardware, see [AMD hardware support](#amd-hardware-support).

#### Expanded operating system support

ROCm 7.14.0 adds support for RHEL 10.2 and RHEL 9.8 on AMD Instinct and Radeon GPUs. RHEL 10.2 replaces RHEL 10.1 as the validated RHEL 10 release; RHEL 9.8 replaces RHEL 9.7 as the validated RHEL 9 release.

SUSE Linux Enterprise Server (SLES) 15 SP7, SLES 16, and Debian 13 are now supported on AMD Instinct MI350P.

For the full list of supported Linux distributions, see [Operating system support](#operating-system-support).

#### Expanded GPU virtualization support for Radeon GPUs

ROCm 7.14.0 adds support for the following virtualization configurations on AMD Radeon GPUs.

* On Radeon AI PRO R9700S: KVM Passthrough with Ubuntu 24.04 host OS and Ubuntu 24.04 guest OS.

* On Radeon PRO V710: KVM SR-IOV with Ubuntu 24.04 host OS and Ubuntu 24.04 guest OS.

Supported Single Root I/O Virtualization (SR-IOV) configurations require the [AMD GPU Virtualization Driver (GIM) 9.1.0.K](https://github.com/amd/MxGPU-Virtualization/releases/tag/9.1.0.K). For details, see [GPU virtualization support](#gpu-virtualization-support).

#### Expanded Instinct GPU partitioning support

ROCm 7.14.0 has enabled and optimized multi-VF partition modes for the following GPU partitioning configurations in SR-IOV deployments:

On MI355X and MI350X:

DPX compute partition mode with NPS2 memory partitioning.

CPX compute partition mode with NPS2 memory partitioning.

For details, see [GPU partitioning support](#gpu-partitioning-support).

### AI inference and frameworks

This release enables support for the following frameworks:

* PyTorch 2.12.0
* JAX 0.10.0
* vLLM 0.23.0
* SGLang 0.5.13
* TensorFlow 2.21

The updated framework support replaces the previous PyTorch 2.9.1, JAX 0.8.2, vLLM 0.19.1, and SGLang 0.5.9 support.

For details, see [AI ecosystem support](#ai-ecosystem-support).

### Developer tools, profiling, and validation

This release improves ROCm developer workflows with new HIP APIs, expanded profiling and tracing capabilities, and broader telemetry coverage.

#### HIP feature highlights

The following are notable enhancements to HIP:

* **HIP execution context support**: HIP now supports Execution Context APIs, enabling GPU compute resource partitioning and lightweight execution-context management on a single device. These APIs allow you to query and partition device resources (primarily CU count for HIP runtime), create execution contexts on resource subsets, and create streams and events scoped to those contexts. For more information, see [Execution Context Management](https://rocm.docs.amd.com/projects/HIP/en/latest/reference/hip_runtime_api/modules/execution_context_management.html).

* **HIP API additions for CUDA parity**:

  * **Batch memory management**: New batch asynchronous memory management APIs let applications discard (`hipMemDiscardBatchAsync`), prefetch (`hipMemPrefetchBatchAsync`), or combine both operations (`hipMemDiscardAndPrefetchBatchAsync`) across multiple memory ranges in a single call, reducing API call overhead. Both HIP runtime and HIP driver variants are available.

  * **Library management**: New library management APIs return the device pointer and size of a device global (`hipLibraryGetGlobal`) and the host pointer and size of a managed variable (`hipLibraryGetManaged`) defined in a `hipLibrary_t`, improving parity with CUDA library APIs.

* **Faster HIP graph replay for asynchronous memory allocations**: HIP graph replay now reduces overhead for graphs that interleave asynchronous memory allocations with compute. Allocation nodes no longer block during replay. Physical memory is reused across nodes instead of being mapped and unmapped on each launch, eliminating the gaps between kernels this pattern previously caused. For background on HIP graphs, see [Graph Management](https://rocm.docs.amd.com/projects/HIP/en/latest/reference/hip_runtime_api/modules/graph_management.html).

For more information, see the [HIP section](#hip-7-14) in the ROCm component changelogs.

#### ROCprofiler-SDK feature highlights

The following are notable enhancements to ROCprofiler-SDK:

##### ROCprofiler-SDK integration with PyTorch Profiler

Starting with PyTorch 2.12, `rocprofiler-sdk` is used as the ROCm profiling backend for PyTorch Profiler on supported ROCm configurations, replacing the legacy `roctracer`-based profiling path. This enables PyTorch users to collect GPU activity traces through the `rocprofiler-sdk` infrastructure and provides a stronger foundation for correctness, stability, and future profiling capabilities. The integration also positions PyTorch Profiler to benefit from additional `rocprofiler-sdk` capabilities as framework-level support continues to evolve.

##### ROCprofiler-SDK beta support for Streaming Performance Monitors

`rocprofiler-sdk` and `rocprofv3` add beta support for Streaming Performance Monitors (SPM), enabling selected hardware counters to be sampled over time while workloads execute. Unlike traditional counter collection, which captures a single aggregated value per kernel dispatch, SPM provides time-resolved hardware counter data. This is useful for analyzing long-running workloads and training jobs where temporal behavior matters as much as aggregate metrics. ROCpd support is planned for a future release.

In ROCm 7.14.0, SPM support is available through the `rocprofiler-sdk` API and `rocprofv3`. To enable SPM in `rocprofv3`, use the `--spm-beta-enabled` flag or set the `ROCPROFILER_SPM_BETA_ENABLED` environment variable. For API-based usage, set `ROCPROFILER_SPM_BETA_ENABLED`.

Supported hardware: AMD Instinct MI300X, MI325X, MI350X, and MI355X GPUs.

For more information, see the [SPM API reference guide](https://rocm.docs.amd.com/projects/rocprofiler-sdk/en/latest/api-reference/spm.html) and the [SPM usage guide](https://rocm.docs.amd.com/projects/rocprofiler-sdk/en/latest/how-to/using-spm.html) for `rocprofv3`.

:::{warning}
SPM is a beta capability under active development and may affect system stability, including unexpected reboots. Do not use in production environments. See [ROCm known issues](#rocprofiler-spm-sessions-can-remain-in-a-stale-state-after-abrupt-termination) for current limitations.
:::

##### Selective ROCTx region profiling with counter collection

`rocprofiler-sdk` and `rocprofv3` include support for profiling selected ROCTx regions, allowing users to focus profiling on specific application phases instead of collecting data for the entire workload. By inserting `roctxProfilerPause` and `roctxProfilerResume` markers in application code and using the `--selected-regions` option, only the GPU activity within the marked regions is captured. This helps reduce profiling noise and output size while making it easier to isolate performance behavior in targeted code paths. This is particularly useful for long-running workloads where full-execution traces are impractical.

Counter collection for selected regions is available in ROCm 7.14.0. For details on `--selected-regions`, including usage with RCCL collectives and ROCTx markers, see [Using ROCprofiler-SDK ROCTx](https://rocm.docs.amd.com/projects/rocprofiler-sdk/en/latest/how-to/using-rocprofiler-sdk-roctx.html).

##### Improved attach and re-attach profiling workflows

`rocprofiler-sdk` and `rocprofv3` improve attach-based profiling workflows, allowing the profiler to connect to already-running GPU applications without requiring a restart. This supports production-style and long-running workloads where starting the application under the profiler is not always practical. Overall reliability and stability are also improved. Repeated attach and re-attach sessions now generate separate output files, making it easier to manage results from iterative profiling sessions. For details, see [Dynamic process attachment using rocprofv3](https://rocm.docs.amd.com/projects/rocprofiler-sdk/en/latest/how-to/using-rocprofv3-process-attachment.html).

##### Reduced profiling overhead for counter collection

`rocprofiler-sdk` reduces profiling overhead in ROCm 7.14.0, including customer-driven improvements for `rocprofv3` and SDK-based profiling paths. These changes make profiling more practical for performance-sensitive workflows and produce more representative trace data.

##### ROCprof Trace Decoder decoupled from the ROCprofiler-SDK API

`rocprof-trace-decoder` now has an independent public API, separate from the core `rocprofiler-sdk` API. The SQTT decoding API has moved into `rocprof-trace-decoder`; use the decoder's public API directly rather than `rocprofiler-sdk` for SQTT decoding. Previously, `rocprof-trace-decoder` was an internal plugin within `rocprofiler-sdk`, tightly coupling the two. The independent API can be versioned separately, allowing tools such as `rocpd` to consume the decoder without depending on the full SDK runtime. The `rocprofv3` end-user experience is unchanged.

##### Quality and stability improvements

This release includes a range of quality and stability improvements across `rocprofiler-sdk` and `rocprofv3`. These include corrections to hardware counter reporting on specific GPU architectures, improvements to trace output accuracy, build fixes on newer GPU targets, expanded platform coverage in `aqlprofile`, and strengthened build and test support in TheRock CI. These changes improve the robustness and correctness of the profiling stack across supported hardware configurations.

##### Queue interposition as a lighter alternative to queue interception

`rocprofiler-sdk` introduces queue interposition, a mechanism that virtualizes HSA queue write-pointer operations without modifying the ROCR-Runtime or requiring full queue interception. For workloads that do not use dispatch counter collection, dispatch thread trace, or PC sampling, `rocprofiler-sdk` now defaults to this lighter interposition path, which reduces profiling overhead and improves overall stability. The legacy queue interception path remains in use when any of those features are active. The default behavior can be controlled via the `ROCPROFILER_QUEUE_INTERPOSITION` environment variable.

##### ROCprof Compute Viewer 0.2.0 release

ROCprof Compute Viewer (RCV) 0.2.0 adds the ability to open raw `.att` and `.out` thread trace directories directly without a JSON conversion step, and introduces a Flamegraph view with per-CU and SIMD source and ISA stack rollups replacing the previous Explorer view. This release also adds hidden latency analysis for gfx10+ and Navi thread traces, SQTT instrumentation marker visualization, and a heuristic GPU Utilization derived counter, alongside fixes for scaling issues, Global View misalignments, and real-time alignment for both JSON and raw `.att` inputs. Installers are available for Windows (`.exe`) and macOS ARM64 (`.sh`), with GitHub Actions CI and release workflows now in place.

#### ROCm Compute Profiler feature highlights

The following are notable enhancements to the ROCm Compute Profiler (rocprofiler-compute):

* **PyTorch operator statistics (experimental)**: The PyTorch tracing (`--torch-trace`) now includes a per-operator statistics summary table, making it easier to spot hot operators and per-dispatch variance. The trace now also captures backward-pass and nested operators that were previously missed or misattributed.
* **Faster analysis**: Analyze mode now processes profiling data more efficiently, reducing analysis time and memory usage on large workloads.

* **Improved metric averaging accuracy**: Metric values across multiple kernel dispatches are now correctly weighted-averaged, eliminating errors that occurred when aggregating metrics with varying values across individual dispatches.

* **pip installation support**: ROCm Compute Profiler is now available as a pip-installable Python package. A new `rocm-profiler` wheel on the ROCm Python package index lets you install ROCm Compute Profiler into a custom Python environment without building ROCm from source. The wheel package installs both ROCm Compute Profiler and ROCm Systems Profiler binaries. For installation instructions, see [Install ROCm Compute Profiler](https://rocm.docs.amd.com/projects/rocprofiler-compute/en/latest/install/core-install.html).

For more information, see the [ROCm Compute Profiler section](#rocm-compute-profiler-3-7-0) in the ROCm component changelogs.

#### ROCm Systems Profiler feature highlights

The following are notable enhancements to ROCm Systems Profiler:

* **GPU hardware counter sampling**: ROCm Systems Profiler now supports periodic sampling of Performance Metric Counters (PMCs). This lets you collect performance metrics at regular time intervals without serializing kernel dispatches, enabling profiling with significantly reduced overhead. For details, see the GPU metrics section in [Configuring runtime options](https://rocm.docs.amd.com/projects/rocprofiler-systems/en/latest/how-to/configuring-runtime-options.html).

* **Unified memory profiling**: ROCm Systems Profiler now adds unified memory profiling with statistics on page migrations and page faults through a dedicated report section. The report displays aggregated transfer counts, sizes, and timing to help you identify performance bottlenecks caused by host-device memory migrations and page faults. Page table events are collected through ROCprofiler-SDK using the Kernel Fusion Driver (KFD) events API, replacing the previous page-migration API, with page migration and page fault events exposed directly in the profiler output. For details, see [Unified memory profiling](https://rocm.docs.amd.com/projects/rocprofiler-systems/en/latest/how-to/unified-memory-profiling.html).

* **SDMA engine activity profiling**: ROCm Systems Profiler can now collect System Direct Memory Access (SDMA) engine activity through AMD SMI, reporting per-process DMA usage to expose data-movement bottlenecks across GPU interconnects in multi-GPU workloads. This metric is opt-in and requires AMDGPU driver version 6.19.14 or later.

* **Selective MPI rank profiling**: In MPI jobs, you can now restrict profile and trace output to a chosen subset of ranks, while unselected ranks run undisturbed. This cuts data volume and speeds up post-run analysis, and works across MPI implementations such as MPICH and Open MPI, including heterogeneous and multi-node environments. For details, see the rank filtering section in [Communication runtime profiling](https://rocm.docs.amd.com/projects/rocprofiler-systems/en/latest/how-to/communication-runtime-profiling.html).

* **MPI rank console log control**: You can now limit console output to a specified subset of ranks while profiling and tracing continue on every rank. This reduces console log noise in large multi-rank runs without sacrificing collection coverage. Existing behavior is preserved when no rank-selection option is set.

* **Selective ROCTx region profiling**: When your application is instrumented with ROCTx region push and pop APIs, you can now include or exclude specific named regions to scope collection to the code paths you're investigating.

* **pip installation support**: ROCm Systems Profiler is now available as a pip-installable Python package, letting you install and use the profiler in custom Python environments without rebuilding from source. The package supports multiple Python versions and provides the same functionality as traditional distributions, reducing setup time and complexity. For installation instructions, see [Install ROCm Systems Profiler](https://rocm.docs.amd.com/projects/rocprofiler-systems/en/latest/install/install.html).

For more information, see the [ROCm Systems Profiler section](#rocm-systems-profiler-1-7-0) in the ROCm component changelogs.

#### AMD SMI feature highlights

The following are notable enhancements to AMD SMI:

* **Per-partition GPU metrics**: AMD SMI now reports temperature, clock, and usage at the partition level through the new `amd-smi metric --partition` flag, giving partition-level observability where previously only socket-level metrics were available. For CLI usage, see [AMD SMI CLI tool](https://rocm.docs.amd.com/projects/amdsmi/en/latest/how-to/amdsmi-cli-tool.html); for partitioning concepts, see [GPU partitioning](https://rocm.docs.amd.com/projects/amdsmi/en/latest/conceptual/partition.html).

* **Compute partition memory allocation mode**: AMD SMI now controls memory allocation behavior at the compute partition level through the new `amd-smi set --compute-partition-mem-alloc-mode` command. The current mode is visible in `amd-smi static --partition` output, and new C and Python APIs expose the same controls programmatically.

* **APU CLI metrics**: AMD SMI now surfaces APU-specific data through the existing `amd-smi metric` flags when APU metrics are available. `amd-smi monitor` adds temperature and clock fallbacks when standard discrete GPU sensors report N/A.

* **APU VRAM carve-out and GTT tuning**: AMD SMI now tunes APU memory from the command line, consolidating the get and set controls previously handled by the standalone `amd-ttm` tool and adding VRAM carve-out configuration. Carve-out and GTT changes take effect after the next reboot, and AMD SMI rebuilds the initramfs automatically so the new configuration is applied at boot. For details, see the memory tuning section in [AMD SMI CLI tool](https://rocm.docs.amd.com/projects/amdsmi/en/latest/how-to/amdsmi-cli-tool.html).

* **PID-grouped process listing**: AMD SMI now groups multi-GPU process output by PID with `amd-smi process --sort-by-pid` and `amd-smi monitor --sort-by-pid`, merging each process's per-GPU usage into a single row. A new C and Python API, `amdsmi_get_gpu_process_list_by_pid()`, exposes the same data programmatically.

* **Fabric clock (FCLK) capping on MI300A**: You can now cap the maximum fabric clock (FCLK) on AMD Instinct MI300A APUs to steer power, using the new `fclk` clock type for `amd-smi set --clk-limit`. Only a maximum limit is supported.

* **Go bindings for CPU telemetry**: AMD SMI now exposes EPYC System Management Interface (ESMI) CPU functionality through its Go bindings, so Go applications can query CPU telemetry in-process without invoking external binaries or embedding C or Python runtimes. This simplifies integrating AMD CPU observability into Go-based control planes. For details, see [AMD SMI Go interface](https://rocm.docs.amd.com/projects/amdsmi/en/latest/how-to/amdsmi-go-lib.html).

For more information, see the [AMD SMI section](#amd-smi-26-5-0) in the ROCm component changelogs.

#### RDC expands telemetry coverage for DME parity

ROCm Data Center (RDC) adds 59 telemetry fields, bringing its metric coverage near parity with the Device Metrics Exporter (DME). New fields cover energy, temperature, clocks, memory, PCIe, engine activity, error correction code (ECC), and health and throttle metrics. Some metrics require recent driver and hardware support. For the available field groups and how to monitor them, see [Using RDC features](https://rocm.docs.amd.com/projects/rdc/en/latest/how-to/using_RDC_features.html).

For more information, see the [RDC section](#rdc-1-3-1) in the ROCm component changelogs.

#### ROCm Bandwidth Test (RBT) reaches end-of-life

ROCm Bandwidth Test (RBT) is deprecated and reaches end-of-life with the TheRock-based ROCm 7.14.0 release. Active development has ceased, and no further feature enhancements or fixes are planned. For equivalent and expanded functionality, transition to [TransferBench](https://rocm.docs.amd.com/projects/TransferBench/en/latest/) and the [ROCm Validation Suite (RVS)](https://rocm.docs.amd.com/projects/ROCmValidationSuite/en/latest/).

For more details, refer to the [ROCm Bandwidth Test](https://rocm.docs.amd.com/projects/rocm_bandwidth_test/en/latest/) documentation.

### Libraries

This release updates ROCm math, sparse compute, and communication libraries with additional routines, expanded datatype support, and performance improvements. It also adds the hipFile storage library.

#### hipFile direct storage I/O support

hipFile is now included in the ROCm Core SDK, enabling direct data transfers between storage and GPU memory as part of AMD Infinity Storage. hipFile enables storage-intensive workloads to bypass host-side copies, reducing latency and command overhead for high-throughput GPU I/O.

hipFile is supported on Linux with AMD Instinct GPUs. See the [ROCm hipFile examples](https://github.com/ROCm/rocm-examples/tree/release/therock-7.14/Systems/hipFile) and the [hipFile documentation](https://rocm.docs.amd.com/projects/hipFile/en/latest/) to get started.

#### Per-matrix bias support in hipBLASLt batched GEMM

hipBLASLt now supports applying a unique bias vector to each matrix in a strided batched GEMM. Set the new `HIPBLASLT_MATMUL_DESC_BIAS_BATCH_STRIDE` matmul descriptor attribute to specify the stride between consecutive bias vectors in device memory when `HIPBLASLT_EPILOGUE_BIAS` is set in the epilogue. A stride of 0 (the default) preserves the previous behavior of broadcasting a single bias vector to all matrices in the batch.

For more information, see the [hipBLASLt documentation](https://rocm.docs.amd.com/projects/hipBLASLt/en/latest/index.html).

#### Per-batch scalar coefficients for Level 2 batched BLAS

rocBLAS and hipBLAS now support per-batch scalar coefficients for Level 2 batched and strided-batched routines in device pointer mode. Each batch index uses its own device-resident scalar rather than a single value shared across the entire batch:

* **GEMV**: per-batch alpha and beta.
* **GER, GERU, and GERC**: per-batch alpha.

S, D, C, and Z precision variants are available for all routines.

For more information, see the [rocBLAS section](#rocblas-5-5-0) and [hipBLAS section](#hipblas-3-5-0) in the ROCm component changelogs.

#### Per-batch alpha for axpy_batched and axpy_strided_batched

rocBLAS adds per-batch alpha support for `axpy_batched`, `axpy_strided_batched`, and their `_ex` variants via `rocblas_set_batch_alpha_stride` in device pointer mode.

For more information, see the [rocBLAS section](#rocblas-5-5-0) in the ROCm component changelogs.

#### hipSPARSE feature highlights

The following are notable enhancements to hipSPARSE:

* **BSR format support in hipSPARSE generic routines**: hipSPARSE adds Block Sparse Row (BSR) format support to its generic sparse compute routines: `hipsparseSpMM` (sparse matrix-matrix multiplication) and `hipsparseSpMV` (sparse matrix-vector multiplication). Two new descriptor functions, `hipsparseCreateBsr` and `hipsparseCreateConstBsr`, let you construct BSR-format sparse matrices for use with the generic API. This brings hipSPARSE to parity with the equivalent NVIDIA cuSPARSE routines, where BSR was previously available only through the rocSPARSE API.

* **Legacy SpGEAM routines deprecated**: The legacy hipSPARSE `csrgeam` routines (`hipsparseXcsrgeamNnz`, `hipsparseScsrgeam`, `hipsparseDcsrgeam`, `hipsparseCcsrgeam`, and `hipsparseZcsrgeam`) are deprecated and will be removed in a future release. Use the `csrgeam2` routines instead: `hipsparseScsrgeam2_bufferSizeExt`, `hipsparseDcsrgeam2_bufferSizeExt`, `hipsparseCcsrgeam2_bufferSizeExt`, `hipsparseZcsrgeam2_bufferSizeExt`, `hipsparseXcsrgeam2Nnz`, `hipsparseScsrgeam2`, `hipsparseDcsrgeam2`, `hipsparseCcsrgeam2`, and `hipsparseZcsrgeam2`.

#### rocSPARSE feature highlights

The following are notable enhancements to rocSPARSE:

* **Incomplete LDLᵀ factorization**: rocSPARSE adds the `rocsparse_spildlt0` routine, which computes an incomplete LDLᵀ factorization with zero fill-in (ILDLT(0)) for symmetric real or Hermitian complex sparse matrices in CSR format. The routine supports strided batched computation for factoring multiple matrices in a single call, a common building block for preconditioning iterative sparse solvers.

* **`rocsparse_indextype_u16` index type deprecated**: The `rocsparse_indextype_u16` field of the `rocsparse_indextype` enum is deprecated in this release. Code using `rocsparse_indextype_u16` now produces deprecation warnings at compile time. Migrate to `rocsparse_indextype_i32` or `rocsparse_indextype_i64`; `rocsparse_indextype_u16` will be removed in a future release.

#### RCCL feature highlights

The following are notable enhancements to RCCL:

* **Hierarchical AllGather**: RCCL adds a hierarchical AllGather algorithm for large multi-node jobs by separating inter-node from intra-node communication, relieving the concurrency pressure that constrains the existing ring and direct algorithms across many GPUs. On AMD Instinct MI350X GPUs, hierarchical AllGather is enabled by default for multi-node configurations. To disable it, set `RCCL_HIERARCHICAL_ALLGATHER=0`.

* **Direct reduce-scatter**: RCCL adds a direct reduce-scatter algorithm for small-to-medium message sizes on AMD Instinct MI350X GPUs, as an alternative to the existing ring-based implementation. RCCL selects it automatically for multi-node reduce-scatter operations within a configurable message-size threshold.

* **Copy Engine collectives (Preview)**: RCCL now offloads collective data movement to the GPU copy engine on AMD Instinct MI355X GPUs through new Copy Engine collectives. This frees compute units during communication-bound collectives, so compute and communication can overlap. RCCL uses a batched copy path when available, falls back to multi-stream or single-stream transfers otherwise, and preserves correct behavior during HIP graph capture.

For more information, see the [RCCL section](#rccl-2-30-4) in the ROCm component changelogs.

(release-supported-hw)=

## AMD hardware support

The following table lists supported AMD Instinct GPUs, Radeon GPUs, and Ryzen APUs. Each supported device is listed with its corresponding GPU microarchitecture and LLVM target.

:::{note}

If your GPU is not listed, it might be community-enabled through TheRock nightly builds. For more information, see [TheRock supported GPUs](https://github.com/ROCm/TheRock/blob/main/SUPPORTED_GPUS.md). For installation guidance, see [TheRock releases](https://github.com/ROCm/TheRock/blob/main/RELEASES.md).
:::

```{include} ./include/hardware-support-table.md
:parser: myst
```

(release-supported-os)=

## Operating system support

ROCm supports the following Linux distributions and Microsoft Windows versions. If you're running ROCm on Linux, ensure your system is using a supported kernel version.

:::{important}
The following table is a general overview of supported operating systems. Actual support might vary by AMD GPU or APU. Use the {doc}`Compatibility matrix </compatibility/compatibility-matrix>` to verify support for your specific setup before installation.
:::

```{include} ./include/os-support-table.md
:parser: myst
```

## Installation updates

ROCm 7.14.0 introduces several improvements to the Runfile Installer:

### Multi-architecture GPU support

The installer provides multi-architecture support, allowing you to install ROCm components for one or more GPU architectures. This is particularly useful for heterogeneous GPU environments or when deploying across multiple systems with different GPU types.

* Install single or multiple GPU architectures in one installation.
* Autodetect GPU and install matching architecture.
* Query available and installed architectures.
* Selectively uninstall specific architectures while keeping others.

### Flexible component selection

Choose exactly which ROCm components to install, reducing installation time and disk space requirements:

* **core**: Essential runtime libraries and tools (default)
* **core-dev**: Development headers and files
* **dev-tools**: Debugging and profiling utilities
* **core-sdk**: Comprehensive SDK with libraries and development tools
* **opencl**: OpenCL runtime support

### Graphics support

Optional graphics support for Mesa and OpenGL workloads is now available. When enabled, the installer includes the `amdgpu-lib` package for graphics capabilities.

### Build and manifest information

* Display TheRock build information including commit hash, GitHub run ID, and build date
* View complete manifest of all components and their versions included in the installer
* Query components by specific GPU architecture

### Universal installer

A single installer file now supports all Linux distributions, eliminating the need to download distribution-specific builds.

(release-supported-fw)=

## Kernel driver and firmware bundle support

ROCm requires a coordinated stack of compatible firmware, driver, and user-space components. Maintaining version alignment between these layers ensures correct GPU operation and performance, especially for AMD data center products. While AMD publishes the AMD GPU driver and ROCm user space components, your server OEM (original equipment manufacturer) or infrastructure provider distributes the firmware packages. AMD supplies those firmware images (platform level data model (PLDM) bundles), which the OEM integrates and distributes.

```{include} ./include/driver-firmware-support-table.md
:parser: myst
```

(release-virtualization-support)=

## GPU virtualization support

AMD Instinct data center GPUs support virtualization in the following configurations. Supported SR-IOV configurations require the AMD GPU Virtualization Driver (GIM) 9.1.0.K—see the [AMD Instinct Virtualization Driver documentation](https://instinct.docs.amd.com/projects/virt-drv/en/mainline-9.1.0.k/) for more information.

```{include} ./include/virtualization-support-table.md
:parser: myst
```

(release-gpu-partitioning-support)=

## GPU partitioning support

```{include} ./include/partitioning-support-table.md
:parser: myst
```

See the [AMD GPU partitioning](https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/gpu-partitioning/index.html) topic in the AMD GPU Driver documentation to learn more.

(release-ai-ecosystem)=

## AI ecosystem support

ROCm 7.14.0 provides optimized support for popular deep learning frameworks and AI inference engines. The following table lists supported frameworks and libraries, their compatible operating systems, and validated versions.

:::{important}
The following table is a general overview of supported frameworks and AI inference engines. Actual support might vary by AMD GPU or APU. Use the {doc}`Compatibility matrix </compatibility/compatibility-matrix>` to verify support for your specific setup.
:::

```{include} ./include/ai-ecosystem-support-table.html
:parser: myst
```

(release-components)=

## ROCm Core SDK components

The following table lists core tools and libraries included in the ROCm 7.14.0 release.

:::{important}
The following table is a general overview of ROCm Core SDK components. Actual support for these libraries and tools can vary by GPU and OS. Use the {doc}`Compatibility matrix </compatibility/compatibility-matrix>` to verify support for your specific setup.
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

### PyTorch might display a warning when libnuma is not installed

PyTorch might display a warning when importing on Linux if the system libnuma package is not installed on some Radeon graphics products, such as Radeon AI PRO R9600D. As a workaround, install the system libnuma package or configure the library path to use the ROCm-bundled NUMA libraries. See [GitHub issue #6485](https://github.com/ROCm/ROCm/issues/6485).

### Significantly longer LLM warmup times on some Radeon GPUs

Significantly longer warmup times might be observed in some large language model inference workloads on AMD Radeon GPUs using vLLM versions v0.21.0 through v0.25.0. As a workaround, use a vLLM release earlier than v0.21.0 or upgrade to vLLM v0.26.0 or later, which includes a fix for this issue. See [GitHub issue #6486](https://github.com/ROCm/ROCm/issues/6486).

### SGLang default settings and some models might cause failures on Radeon GPUs

ROCm 7.14 introduces initial SGLang support for AMD Radeon GPUs. Radeon GPU users should disable AITER and unset `SGLANG_ROCM_FUSED_DECODE_MLA`, as both are enabled by default in the SGLang Docker image and might cause some workloads to fail:

```bash
export SGLANG_USE_AITER=false
export SGLANG_ROCM_FUSED_DECODE_MLA=false
```

Additionally, some models might not function correctly on Radeon GPUs, including certain Mixture-of-Experts (MoE) models (such as GPT-OSS-20B and MiniMax-M2.7) and Qwen3-ASR models. Users experiencing these issues are recommended to use the latest upstream SGLang versions, which will include the necessary fixes once they are merged. See the [SGLang environment variables reference](https://docs.sglang.io/docs/references/environment_variables#environment-variables) for more details. See [GitHub issue #6487](https://github.com/ROCm/ROCm/issues/6487).

### Lower-than-expected LLM inference performance on RDNA3 Radeon GPUs and Ryzen AI MAX / MAX+ Series Processors

Lower-than-expected performance might be observed in some large language model inference workloads, including vLLM FP16 decode workloads with batch sizes of 8 or greater, on AMD Radeon RX 7900 Series Graphics, AMD Radeon RX 7800 XT Graphics, and AMD Ryzen AI MAX / MAX+ Series Processors when using PyTorch versions earlier than 2.14. As a workaround, set the `TORCH_BLAS_PREFER_HIPBLASLT=1` environment variable to use the hipBLASLt backend. This setting becomes the default for these architectures in PyTorch 2.14. See [GitHub issue #6488](https://github.com/ROCm/ROCm/issues/6488).

### ROCprofiler-SDK SPM sessions can remain in a stale state after abrupt termination

If a Streaming Performance Monitors (SPM) session is terminated abruptly (for example, with `Ctrl+C`), KFD-side SPM resources might not be released cleanly. When this happens, the KFD-side SPM resources can remain in a stale state, which might cause subsequent SPM profiling sessions to hang or fail to start with the error `Unable to acquire KFD thread: 4096`. To recover, if the profiling process is still running, terminate it manually. If the error persists, a system reboot is currently required to restore the GPU to a usable state for SPM profiling. This issue is under active investigation for a fix. See [GitHub issue #6489](https://github.com/ROCm/ROCm/issues/6489).

### ROCm Compute Profiler might report inflated Avg values with per_kernel normalization

When using ROCm Compute Profiler with `per_kernel` normalization, the reported Avg value for certain normalized metrics might be incorrectly inflated and can exceed the corresponding Min and Max values. This issue affects analysis results only. As a workaround, use an alternative normalization unit (`-n`/`--normal-unit`) until a fix is available. See [GitHub issue #6490](https://github.com/ROCm/ROCm/issues/6490).

### rocALUTION and hipTensor are not included in the HPC Expansion tarball

The `amdrocm-hpc` meta-package installs rocALUTION and hipTensor, but there is no dedicated HPC Expansion tarball for tarball-based installations. The standard ROCm tarballs include both libraries. See [GitHub issue #6491](https://github.com/ROCm/ROCm/issues/6491).

### HIP SPIR-V kernels might segfault on first launch

HIP kernels compiled with the SPIR-V target (`--offload-arch=amdgcnspirv`) might segfault on first kernel launch at `hipLaunchKernel`. The failure affects both library-level workloads such as rocBLAS and standalone HIP applications built against the SPIR-V offload bundle. Applications compiled for a native GPU architecture target are not affected. As a workaround, compile using a direct GPU architecture target instead of `--offload-arch=amdgcnspirv`. See [GitHub issue #6492](https://github.com/ROCm/ROCm/issues/6492).

### RCCL might show degraded performance on multi-node configurations

RCCL operations with message sizes in the 64 MB to 512 MB range might show suboptimal performance on multi-node configurations. This might severely impact production workloads. Llama 3 405B is a known affected workload; additional workloads might also be affected. As a workaround, disable the fault injection path in the RCCL CMake file:

```cmake
option(FAULT_INJECTION         "Enable fault injection"           OFF)
```

Alternatively, add the following CMake flag during compilation:

```text
-DFAULT_INJECTION=OFF
```

See [GitHub issue #6493](https://github.com/ROCm/ROCm/issues/6493).

### AMD SMI NIC telemetry supports Pollara 400 adapters only

In ROCm 7.14.0, AMD SMI NIC telemetry only supports AMD AI NIC Pollara 400 adapters. Broadcom NIC support is planned for a future release. See [GitHub issue #6497](https://github.com/ROCm/ROCm/issues/6497).

## ROCm resolved issues

The following notable issues have been fixed in ROCm 7.14.0.

### ROCm Compute Profiler failed when profiling bash scripts or commands

Previously, running a bash script or command as a target for ROCm Compute Profiler failed because bash overwrote the required environment variables.

### LLVM-based compilers failed when compiling half-precision vector operations

Previously, LLVM-based compilers failed, returning the `Failed to find subregs!` error message in `SIInstrInfo::copyPhysReg`, when compiling half-precision vector operations with optimization enabled at levels `-O1` to `-O3`.

### hipBLAS test suites returned non-zero exit codes on Windows

Previously, when using hipBLAS on Windows, the test suites returned non-zero exit codes even when all mathematical correctness tests passed, blocking automated testing workflows.

### Illegal memory address error when using placement new with device function returns

Previously, HIP kernels that used placement new to construct objects in `hipMalloc`-allocated device memory crashed with a `hipErrorIllegalAddress` error when a `__device__` function return value was passed as the constructor argument for non-trivially copyable types.

### GPU kernels failed to launch in ASan builds with large thread counts

Previously, when building GPU libraries with ASan enabled, kernels configured with large thread counts failed to launch with an `HSA_STATUS_ERROR_INVALID_ISA` error.

### ASan prevented multi-architecture HIP binary builds from launching

Previously, HIP applications built with ASan enabled and targeting multiple GPU architectures failed to launch with `RuntimeError: .hipFatBinSegment size N is not a multiple of wrapper size (24)` and `RuntimeError: Unexpected magic 0x00000000 at wrapper i` error messages.

### ROCm Systems Profiler overwrote ROCPD output after process re-attachment

Previously, when using `rocprof-sys-attach` to re-attach to a previously profiled process, the ROCPD output database files (`.db`) were written to the initial session's output directory instead of a new timestamped directory.

### hipCUB DeviceMerge large-size stress test failed with out-of-memory error on gfx1150

Previously, on gfx1150 APUs, the hipCUB DeviceMerge large-size stress test (`MergeLargeSizeIterators`) failed with an out-of-memory error when running ROCm 7.12.0. Standard DeviceMerge test cases were not affected.

### HIP kernel launch limit caused failures for some models

Previously, with PyTorch 2.10, some models hit the HIP kernel launch limit of 2³² kernel launches within a single process, causing HIP kernel launch errors. One known affected model was `black-forest-labs/flux`.

### Non-deterministic GPU memory faults when passing large data structures on MI300X

Previously, applications running on AMD Instinct MI300X GPUs that passed large, complex data structures between device functions using scratch memory encountered non-deterministic GPU memory access faults and became unresponsive when compiler optimizations minimized the number of copy operations.

## ROCm upcoming changes

Future releases will add support for:

* Additional ROCm Core SDK components.

* Domain-specific expansion toolkits (data science, life sciences, finance, simulation, and other HPC domains).

* More AMD hardware support.

(amd-smi-deprecations)=
### AMD SMI deprecations

The AMD SMI library will deprecate the following APIs. Certain APIs will be
deprecated with or without a replacement; see the following tables for details.
We suggest updating your code to use the replacement identifiers before the
targeted removal releases.

#### Planned removal in the next major release

The following APIs, defines, enums, and struct fields are deprecated and
scheduled for removal in the next major release.

##### APIs

| Deprecated | Replacement |
|---|---|
| `amdsmi_get_cpusocket_handles()` | No replacement; functionality removed |
| `amdsmi_get_gpu_vram_vendor()` | `amdsmi_get_gpu_vram_info()` |
| `amdsmi_gpu_driver_reload()` | No replacement; functionality removed |
| `amdsmi_get_xgmi_plpd()` | Python: use the `policy` attribute instead of `plpds` |
| `amdsmi_set_gpu_clk_range()` | `amdsmi_set_gpu_clk_limit()` |

##### Types

| Deprecated | Replacement |
|---|---|
| `amdsmi_fabric_info_ver_t` | Moved inside `amdsmi_fabric_info_t` |
| `amdsmi_nic_fw_t` | `amdsmi_nic_fw_entry_t` |

##### Defines and enums

| Deprecated | Replacement |
|---|---|
| `MAX_NUMBER_OF_AFIDS_PER_RECORD` | `AMDSMI_MAX_NUMBER_OF_AFIDS_PER_RECORD` |
| `MAX_SVI3_RAIL_INDEX` | `AMDSMI_MAX_SVI3_RAIL_INDEX` |
| `MAX_SVI3_RAIL_SELECTION` | `AMDSMI_MAX_SVI3_RAIL_SELECTION` |
| `POWER_EFFICIENCY_MODE_4` | `AMDSMI_POWER_EFFICIENCY_MODE_4` |
| `POWER_EFFICIENCY_MODE_5` | `AMDSMI_POWER_EFFICIENCY_MODE_5` |
| `CENTRIGRADE_TO_MILLI_CENTIGRADE` | No replacement; constant removed |
| `_AMDSMI_MAX_STRING_LENGTH` | No replacement; private symbol, do not use |
| `_AMDSMI_STRING_LENGTH` | No replacement; private symbol, do not use |

##### `amdsmi_gpu_metrics_t` field type widening

The following fields in `amdsmi_gpu_metrics_t` will change from `uint32_t` to `uint64_t` to support next generation AMD Instinct counter ranges:

* `gfx_activity_acc`
* `mem_activity_acc`
* `pcie_nak_sent_count_acc`
* `pcie_nak_rcvd_count_acc`
* `pcie_lc_perf_other_end_recovery`

Recompile any code that reads these fields. Any assignments into fixed-width 32-bit variables must be updated to use 64-bit types.

#### Future deprecation notice: planned removal after the next major release

The following APIs, types, and enums are deprecated and will be removed sometime **after** the next major release.

##### APIs

| Deprecated | Replacement |
|---|---|
| `amdsmi_get_gpu_compute_partition_mem_alloc_mode()` | `amdsmi_get_gpu_accelerator_partition_mem_alloc_mode()` |
| `amdsmi_set_gpu_compute_partition_mem_alloc_mode()` | `amdsmi_set_gpu_accelerator_partition_mem_alloc_mode()` |
| `amdsmi_get_gpu_compute_partition()` | `amdsmi_get_gpu_accelerator_partition_profile()` |
| `amdsmi_set_gpu_compute_partition()` | `amdsmi_set_gpu_accelerator_partition_profile()` |
| `amdsmi_set_gpu_memory_partition()` | `amdsmi_set_gpu_memory_partition_mode()` |

##### Types

* `amdsmi_compute_partition_type_t`
* `amdsmi_compute_partition_mem_alloc_mode_t`

##### Enums

| Deprecated | Replacement |
|---|---|
| `CLK_LIMIT_MIN` | `AMDSMI_CLK_LIMIT_MIN` |
| `CLK_LIMIT_MAX` | `AMDSMI_CLK_LIMIT_MAX` |
| `AGG_BW0` | `AMDSMI_AGG_BW0` |
| `RD_BW0` | `AMDSMI_RD_BW0` |
| `WR_BW0` | `AMDSMI_WR_BW0` |
