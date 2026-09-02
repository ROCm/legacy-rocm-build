# ROCm Core SDK {{ ROCM_VERSION }} release notes

These release notes describe notable changes since the previous ROCm release.

- [Release highlights](#release-highlights)
- [AMD hardware support](#amd-hardware-support)
- [Operating system support](#operating-system-support)
- [Installation updates](#installation-updates)
- [Kernel driver and firmware bundle support](#kernel-driver-and-firmware-bundle-support)
- [GPU virtualization support](#gpu-virtualization-support)
- [GPU partitioning support](#gpu-partitioning-support)
- [AI ecosystem support](#ai-ecosystem-support)
- [ROCm Core SDK components](#rocm-core-sdk-components)
- [ROCm breaking changes](#rocm-breaking-changes)
- [ROCm known issues](#rocm-known-issues)
- [ROCm resolved issues](#rocm-resolved-issues)
- [ROCm upcoming changes](#rocm-upcoming-changes)

```{note}
Since ROCm 7.14, ROCm uses [TheRock](https://github.com/ROCm/TheRock) as its build and release system. For more information, see the [transition guide](/about/transition-guide-TheRock).
```

## Release highlights

This release focuses on AI inference, developer tooling, and profiling across AMD Instinct™, Radeon™, and Ryzen™ AI platforms. Highlights include expanded framework support for AI inference, new HIP APIs and performance improvements, ROCprofiler-SDK adoption across AI profiling workflows, and updates to math, sparse, and communication libraries.

### Platform and hardware support

This release expands GPU, operating system, virtualization, and partitioning support.

#### Expanded AMD GPU support

ROCm 10.0.0 adds support for the following AMD Radeon GPUs:
* [AMD Radeon RX 9050 (gfx1200)](https://www.amd.com/en/products/graphics/desktops/radeon/9000-series/amd-radeon-rx-9050.html)
* [AMD Radeon RX 9050 (4GB) (gfx1200)](https://www.amd.com/en/products/graphics/desktops/radeon/9000-series/amd-radeon-rx-9050-4gb.html)

For the complete list of supported AMD hardware, see [AMD hardware support](#amd-hardware-support).

#### Operating system support update

Operating system support remains unchanged in this release.

For the full list of supported Linux distributions, see [Operating system support](#operating-system-support).

#### Expanded GPU virtualization support for Instinct GPUs

ROCm 10.0.0 adds support for the following virtualization configurations on AMD Instinct GPUs:

* On AMD Instinct MI355X and MI350X:
  * Passthrough Ubuntu 22.04 host OS with Ubuntu 22.04 guest OS.
* On AMD Instinct MI350P:
  * Passthrough ESXi 9.1 with Ubuntu 24.04 guest OS.
* On AMD Instinct MI325X:
  * Passthrough Ubuntu 24.04 host OS with Ubuntu 24.04 guest OS.
  * Passthrough Ubuntu 22.04 host OS with Ubuntu 22.04 guest OS.
  * Passthrough Ubuntu 24.04 host OS with RHEL 9.4 guest OS.
  * Passthrough RHEL 9.4 host OS with RHEL 9.4 guest OS.
  * KVM SR-IOV RHEL 10.2 host OS with RHEL 10.2 guest OS.
* On AMD Instinct MI300X:
  * Passthrough Ubuntu 24.04 host OS with Ubuntu 24.04 guest OS.
  * Passthrough Ubuntu 24.04 host OS with RHEL 9.4 guest OS.
  * Passthrough RHEL 9.4 host OS with RHEL 9.4 guest OS.
  * Passthrough ESXi 8 U3 with Ubuntu 24.04 and Ubuntu 22.04 guest OS.
  * KVM SR-IOV RHEL 10.2 host OS with RHEL 10.2 guest OS.
* On AMD Instinct MI210:
  * Passthrough Ubuntu 24.04 host OS with Ubuntu 24.04 guest OS.
  * Passthrough Ubuntu 22.04 host OS with Ubuntu 22.04 guest OS.

Supported Single Root I/O Virtualization (SR-IOV) configurations require the [AMD GPU Virtualization Driver (GIM) 9.2.0.K](https://github.com/amd/MxGPU-Virtualization/releases/tag/9.2.0.K). For details, see [GPU virtualization support](#gpu-virtualization-support).

#### GPU partitioning support update

GPU partitioning support remains unchanged in this release. For details, see [GPU partitioning support](#gpu-partitioning-support).

### AI inference and frameworks

This release enables support for the following frameworks:

* PyTorch 2.13.0
* JAX 0.11.0
* JAX 0.10.2
* vLLM 0.27.0
* SGLang 0.5.15
* TensorFlow 2.21
* MIGraphX 2.17
* ONNX Runtime 1.27.0

The updated framework support replaces the previous PyTorch 2.10.0, JAX 0.9.1, vLLM 0.23.0, SGLang 0.5.13, MIGraphX 2.16, and ONNX Runtime 1.23.2 support.

For details, see [AI ecosystem support](#ai-ecosystem-support).

### Developer tools and profiling

This release improves ROCm developer workflows with new HIP APIs, expanded profiling and tracing capabilities, and broader telemetry coverage.

#### HIP feature highlights

The following are notable enhancements to HIP:

##### Improved HIP performance

Improved `hipEventRecord` performance by using the `hipEventDisableTiming` flag to avoid unnecessary profiling when timing information is not required. Event operations are now coalesced to eliminate redundant barrier submissions, reducing runtime overhead and improving execution efficiency.

##### HIP cooperative groups exclusive and inclusive scan support

HIP `cooperative_groups` library adds [cooperative_groups::inclusive_scan](https://rocm.docs.amd.com/projects/HIP/en/latest/how-to/hip_runtime_api/cooperative_groups.html#inclusive-scan) and [cooperative_groups::exclusive_scan](https://rocm.docs.amd.com/projects/HIP/en/latest/how-to/hip_runtime_api/cooperative_groups.html#exclusive-scan) scan APIs in parity with CUDA. Both accept any cooperative group type and an optional custom binary operator, defaulting to summation when none is given.

##### ROCr Runtime core dump support with attached debuggers

The ROCr Runtime now generates a valid GPU core dump even when a debugger such as [ROCm Debugger (ROCgdb)](https://rocm.docs.amd.com/projects/ROCgdb/en/latest/index.html) or [ROCR Debug Agent](https://rocm.docs.amd.com/projects/rocr_debug_agent/en/latest/index.html) is already attached to the process. The runtime now captures the triggering GPU exception from its own internal state, so debugging sessions and core dump collection no longer need to be mutually exclusive.

##### HIP API addition for CUDA parity

HIP adds `hipMemGetDefaultMemPool`, which returns the default memory pool for a given memory location and allocation type.

For more information, see the [HIP section](#hip-10-0-0) in the ROCm component changelogs.

#### ROCprofiler-SDK feature highlights

The following are notable enhancements to ROCprofiler-SDK:

##### Expanded tracing domains

ROCprofiler-SDK and `rocprofv3` add three new first-class tracing domains:

* **rocSHMEM API tracing:** Host-stream APIs, including `rocshmem_putmem_on_stream`, `rocshmem_getmem_on_stream`, and `rocshmem_alltoallmem_on_stream` are now intercepted and emitted as per-call trace records. These records appear inline with HIP, HSA, RCCL, and other runtime traces, enabling you to see rocSHMEM communication activity in the same timeline as GPU compute and understand its contribution to overall application performance. Enable with the `--rocshmem-trace` flag (or `ROCPROF_ROCSHMEM_API_TRACE` environment variable).

* **hipFile tracing support:** hipFile API calls are intercepted via dispatch-table wrapping and emitted as per-call trace records alongside HIP, HSA, and other runtime activity. This allows you to see file I/O operations in the same profiling timeline as GPU kernels and memory copies, making it straightforward to quantify storage overhead and its impact on end-to-end application performance. Enable with the `--hipfile-trace` flag (or `ROCPROF_HIPFILE_API_TRACE` environment variable).

* **OpenMP (OMPT) tracing:** `rocprofv3` exposes OpenMP Tools (OMPT) tracing as a first-class command-line flag. The `--ompt-trace` option accepts a bare Boolean or a space-separated category list (for example `--ompt-trace parallel task target sync`), following the same style as `--pmc` and `--output-format`. ROCprofiler-SDK has supported the OMPT callback layer since an earlier release; this change makes it accessible without writing a custom tool.

All records from these tracing domains are output in JSON (hipFile, rocSHMEM) and rocpd (hipFile, rocSHMEM, OpenMP) formats. The rocpd output can then be converted to CSV, Perfetto, and OTF2 using post-processing conversion scripts.

##### Enhanced graph and profiling output

* **HIP Graph per-node attribution:** ROCprofiler-SDK and `rocprofv3` now add full per-graph-node attribution for HIP graph kernels and memory copies. Each dispatch record produced by a graph launch is tagged with the identity of the graph and the specific node within it that produced it. This allows profiling tools to group dispatches by source node across many launches, compute per-node timing and counter aggregates, and correlate graph-level summary records with their individual dispatch records. Enable with the `--hip-graph-trace` flag, automatically included in `--hip-trace` or `--hip-runtime-trace`.

* **SPM ROCpd output support:** ROCprofiler-SDK extends the rocpd output format to include Streaming Performance Monitor (SPM) counter data. SPM records are stored as `rocpd_track` rows with a `"SPM"` label, with counter values grouped by timestamp into `rocpd_sample` rows and per-dimension data in `rocpd_pmc_event` rows. The rocpd schema is updated to include `sample_id`, `xcc`, `shader_engine`, and `instance` columns. SPM data can now be consumed by any tool that reads the rocpd database, or converted to other output formats such as Perfetto. Known Issue: SPM sessions can remain in a stale state after abrupt termination. See [GitHub issue #6489](https://github.com/ROCm/ROCm/issues/6489) for details.

##### Improved attach capabilities

* **Live Attach with Advanced Thread Trace (ATT) support:** ROCprofiler-SDK extends the live attach workflow to include Advanced Thread Trace (ATT). When `rocprofv3` attaches to a running process, it now registers for code-object iteration and creation callbacks so that thread trace can operate correctly on code objects that were loaded before the attach occurred. This makes ATT available for already-running production workloads without requiring an application restart.

* **Container-aware rocattach symbol resolution:** `rocprofv3` improves attach support when the target process is running inside a container. ROCprofiler-SDK now resolves attach entry points directly from the target process mapped ELF, and validates tool paths from the target's perspective before injection. This allows attaching from a host to a containerized process without manually copying .so files. Previously, `rocattach` calculated symbol offsets from the host's `librocprofiler-register.so` and applied them to the target's mapping, which failed when the host and container libraries differ in ELF layout or path.

* **Python API for rocprof-trace-decoder:** `rocprof-trace-decoder` now ships a Python API that allows you to decode Advanced Thread Trace (ATT) / SQTT data directly from Python without writing a C++ consumer. The API wraps the decoder library and exposes thread trace decoding as a first-class Python interface, with samples included to demonstrate common workflows. Integration tests for the decoder have been migrated to Python, simplifying test authoring and making it easier for downstream tools to validate their trace-decoding pipelines. This is particularly useful for analysis scripts, Jupyter notebooks, and custom profiling tools that need to process ATT output programmatically.

* **SQTT quick scan support for thread trace path (Experimental):** ROCprofiler-SDK introduces an experimental SQTT quick scan mode for thread trace, accessible through a new CMake flag. The quick scan path collects thread trace data without packet insertion or HSA signal manipulation, removing the queue interception overhead that the standard ATT path requires. Individual kernels can be traced without serialization, and the approach is independent of the ROCm runtime version. This is an experimental feature intended to validate the new collection path and pave the way for out-of-process thread trace and long-kernel tracing in future releases.

##### Build and dependency improvements

ROCprofiler-SDK no longer depends on `libatomic`. The library was previously linked unconditionally through the `rocprofiler-sdk-atomic` interface target, causing link failures on toolchains and container images where `libatomic1` is not installed. The single `std::atomic` use that required the library has been replaced with explicit memory-ordering synchronization, removing the dependency without changing behavior.

##### Quality and stability improvements

This release includes a range of quality and stability improvements across ROCprofiler-SDK and `rocprofv3`:

* **Thread trace stall issue fixed:** Resolved a GPU stall that occurred when device thread trace was started before `hsa_init()`.
* **Counter collection stall issue fixed:** Corrected an `InterceptQueue` ordering bug that caused counter-collection sessions to stall, and fixed an out-of-bounds write in `Submit()`.
* **Thread trace autoflush disabled:** Disabled autoflush in thread trace to prevent premature buffer flushes that caused incomplete or corrupted traces.
* **roctxMark kernel rename issue fixed:** `roctxMark` calls no longer propagate as kernel rename labels, fixing spurious kernel name changes in traces that contained ROCTx markers.
* **Queue interposition bypass:** Idle inline queues with no active profiling consumers now bypass interposition entirely, reducing overhead for applications that create queues but do not immediately dispatch work.
* **AQLprofile gfx11xx counter issue fixed:** Corrected SQ aliasing on harvested WGPs and multi-counter desync on gfx11xx targets. Also fixed the `GcEaSeCounterBlockMaxEvent` value in AQLprofile.
* **PC sampling service check:** Added a guard to prevent double-initialization of the PC sampling service.
* **Attach output flush:** `rocprofv3` attach sessions now correctly block until all buffered output is flushed before exiting.
* **Code object callback ordering:** Corrected the ordering of code object callbacks during attach to prevent race conditions with tools that depend on ordered delivery.
* **DWARF parsing:** DWARF information is now parsed lazily, reducing startup overhead for attach and tracing sessions on large binaries.
* **Build and CI improvements:** Fixed `fmt/format.h` include path, `fpic` flag for samples, OMP lookup in CI, and clang-tidy quickscan enablement.

#### ROCm Compute Profiler feature highlights

The following are notable enhancements to the ROCm Compute Profiler (rocprofiler-compute):

##### Triton operator tracing (experimental)

Operator tracing now covers Triton and `torch.compile` kernels in addition to PyTorch, and a single option traces every supported machine learning framework in one run. For details, see [Triton trace](https://rocm.docs.amd.com/projects/rocprofiler-compute/en/docs-10.0.0/how-to/profile/mode.html#triton-trace), [ML API trace](https://rocm.docs.amd.com/projects/rocprofiler-compute/en/docs-10.0.0/how-to/profile/mode.html#ml-api-trace), and [Operator filtering](https://rocm.docs.amd.com/projects/rocprofiler-compute/en/docs-10.0.0/how-to/analyze/cli.html#operator-filtering).

##### Improved roofline support on gfx1150 (Strix Point), gfx1151 (Strix Halo and Gorgon Halo), and gfx1152 (Krackan Point)

Roofline benchmarking and analysis on these GPUs now report the correct set of supported precisions, so `--roofline-data-type` no longer offers precisions that cannot be measured. Machine specification reporting for APUs is corrected as well. Roofline benchmarking on gfx1153 is not yet supported. For details, see [Standalone roofline](https://rocm.docs.amd.com/projects/rocprofiler-compute/en/docs-10.0.0/how-to/profile/mode.html#standalone-roofline) and [Roofline HTML generation](https://rocm.docs.amd.com/projects/rocprofiler-compute/en/docs-10.0.0/how-to/analyze/cli.html#roofline-html-generation).

For more information, see the [ROCm Compute Profiler section](#rocm-compute-profiler-3-8-0) in the ROCm component changelogs.

#### ROCm Systems Profiler feature highlights

The following are notable enhancements to ROCm Systems Profiler:

##### hipFILE (GPU-direct storage) API tracing

ROCm Systems Profiler can now trace hipFile GPU-direct storage API calls, giving you visibility into storage I/O paths that move data directly between storage and GPU memory. Enable it by adding `hipfile_api` (shorthand: `hipfile`) to `ROCPROFSYS_ROCM_DOMAINS`. This capability requires ROCprofiler-SDK 1.3.5 or later. For details, see the ROCm domains section in [Configuring runtime options](https://rocm.docs.amd.com/projects/rocprofiler-systems/en/docs-10.0.0/how-to/configuring-runtime-options.html#configuring-runtime-options).

##### rocSHMEM host-stream API tracing

ROCm Systems Profiler now captures the nine host-stream rocSHMEM API calls (`putmem_on_stream`, `getmem_on_stream`, `putmem_signal_on_stream`, `signal_wait_until_on_stream`, `broadcastmem_on_stream`, `alltoallmem_on_stream`, `barrier_all_on_stream`, `sync_all_on_stream`, and `quiet_on_stream`) as `rocm_rocshmem_api` spans in both Perfetto traces and rocpd databases. Enable it with `ROCPROFSYS_ROCM_DOMAINS=rocshmem_api`. This capability requires ROCprofiler-SDK 1.3.5 or later and rocSHMEM 3.6.0 or later (included in ROCm 10.0.0). Since rocSHMEM 3.6.0 enables USE_ROCPROFILER_REGISTER by default, package installations include this support automatically. A rocshmem example demonstrating two-PE usage of all nine APIs is included under examples/rocshmem. For details, see the ROCm domains section in [Configuring runtime options](https://rocm.docs.amd.com/projects/rocprofiler-systems/en/docs-10.0.0/how-to/configuring-runtime-options.html#configuring-runtime-options).


##### Finer-grained instrumentation control

The `rocprof-sys-instrument` tool adds several options to reduce instrumentation overhead and scope collection more precisely. The `--exe-only` flag excludes every shared library from instrumentation, leaving only the main executable. The `--exclude-internal-lib-paths` flag excludes every on-disk path that matches an internal library's filename, rather than only the path linked at startup. The `--max-library-functions` option skips shared libraries whose procedure count exceeds a specified threshold, keeping overhead manageable; the target executable is never gated by this threshold, and the check is bypassed for modules and functions selected through the include/restrict regexes (`--module-include/-MI`, `--module-restrict/-MR`, `--function-include/-I`, and `--function-restrict/-R`). For details, see [Binary instrumentation](https://rocm.docs.amd.com/projects/rocprofiler-systems/en/latest/how-to/instrumenting-rewriting-binary-application.html#instrumenting-and-rewriting-a-binary-application).

##### New profiler-hub writer backend

ROCm Systems Profiler introduces the new profiler-hub writer backend for trace persistence, which replaces the existing SQLite3/rocpd backend for writing trace data.

##### AI-NIC telemetry sampling

ROCm Systems Profiler now supports periodic sampling of AI NIC (RDMA) network metrics, including unicast byte/packet counts, congestion notifications, and packet-sequence error counters. Select interfaces with the `--ai-nics` flag on `rocprof-sys-run` or `rocprof-sys-sample` (or via `ROCPROFSYS_SAMPLING_AINICS`), and view the results as Perfetto or rocpd tracks alongside your existing CPU/GPU sampling data. See the [Network performance profiling](https://rocm.docs.amd.com/projects/rocprofiler-systems/en/latest/how-to/nic-profiling.html) how-to for setup, configuration, and visualization details.

For more information, see the [ROCm Systems Profiler section](#rocm-systems-profiler-1-8-0) in the ROCm component changelogs.

### Libraries

This release introduces new algorithms and optimizations across the math, sparse, and primitives libraries. Updates to hipFile improve I/O performance for NVMe-backed storage.

#### Composable Kernel improves a8w8 GEMM performance

Composable Kernel improves a8w8 GEMM performance on AMD Instinct MI355X GPUs, delivering measurable throughput gains over the prior AITER implementation for FP8 and int8 GEMM problem shapes used in long-sequence inference workloads (sequence lengths from 6K to 1M tokens). The optimizations are built on CK Tile and are accessible through the AITER GEMM interface.

#### rocFFT supports multi-GPU RCCL backend

rocFFT adds an optional RCCL backend for single-node, multi-GPU FFT communication within a single process, enabled via the `-DROCFFT_RCCL_ENABLE=ON` CMake build option. RCCL's GPU topology-awareness targets help improve communication performance over rocFFT's existing memory-copy-based transport in this configuration.

#### Symmetric memory support updated in RCCL

RCCL extends its symmetric memory support with a new Reduce-Scatter kernel and expanded memory registration options for collective operations. This implementation enables:

- **Reduce-Scatter symmetric kernel:** RCCL adds a symmetric-memory kernel for Reduce-Scatter on AMD Instinct MI300 Series and MI350 Series GPUs, extending symmetric-memory execution to a collective that previously required the default communication path. The kernel also adds support for the AVG reduction operation.

- **GPU-only multi-segment registration:** Symmetric memory windows can register multi-segment GPU memory ranges without host involvement, currently supported for single-node configurations.

- **Elastic buffers:** Symmetric memory collectives support tensors residing in either device or host memory, currently supported for single-node configurations.

#### hipSPARSE and rocSPARSE feature highlights

The following are notable enhancements to hipSPARSE and rocSPARSE:

##### rocSPARSE and hipSPARSE add Blocked ELL format support

rocSPARSE and hipSPARSE now support Blocked ELL format in their dense-to-sparse conversion routines, `rocsparse_dense_to_sparse` and `hipsparseDenseToSparse`. Each library adds a companion pointer-setter function, `rocsparse_bell_set_pointers` and `hipsparseBlockedEllSetPointers` respectively, to configure the Blocked ELL array pointers.

##### CSC format support for sparse triangular solves in rocSPARSE and hipSPARSE

rocSPARSE and hipSPARSE sparse triangular solve routines now accept matrices in Compressed Sparse Column (CSC) format directly, removing the need to convert to Compressed Sparse Row (CSR) first. CSC support extends to `rocsparse_spsv/rocsparse_sptrsv` and `rocsparse_spsm/rocsparse_sptrsm` in rocSPARSE, and to `hipsparseSpSV` and `hipsparseSpS` in hipSPARSE.

##### hipSPARSE adds the SpMV nnz-split algorithm

hipSPARSE adds the `HIPSPARSE_SPMV_CSR_ALG3` algorithm to `hipsparseSpMV`, exposing the rocSPARSE's analysis-free `nnz-split` CSR algorithm (`rocsparse_spmv_alg_csr_nnzsplit`) for sparse matrix-vector multiplication. The algorithm distributes work across threads based on the number of non-zero entries per row and requires no preliminary analysis step before execution.

##### rocSPARSE improves default SpMM algorithm selection

rocSPARSE's default `rocsparse_spmm` algorithm now switches to a nnz-split kernel for strongly skewed CSR/CSC matrices (a single long row or column). This avoids the throughput loss the previous row-split default caused on such matrices. Non-skewed matrices and explicitly chosen algorithms are unaffected.

##### rocSPARSE removes rocsparse_indextype_u16 index type

The `rocsparse_indextype_u16` field of the `rocsparse_indextype` enumerator is now removed; and only `rocsparse_indextype_i32` and `rocsparse_indextype_i64` remain. `rocsparse_indextype_u16` was deprecated in ROCm 7.14.0; code that still references it will now fail to compile.

#### rocPRIM adds parallel top-K algorithms

rocPRIM adds `rocprim::device_topk` and `rocprim::device_segmented_topk`, parallel device-level algorithms that find the largest or smallest K elements from an input array or from segmented groups, respectively. To enable this feature, add the `-DROCPRIM_ENABLE_TOPK=ON` CMake build option. The default variant is hipGraph-compatible; a stable-ordering variant is also available for callers that need guaranteed ordering.

#### hipFile fastpath I/O support for LVM volumes

hipFile now supports fastpath I/O to files on Logical Volume Manager (LVM) volumes backed by NVMe devices, resolving a previous ENODEV error caused by the underlying PCI device not being resolvable through the volume manager.

#### AMD SMI feature highlights

The following are notable changes to AMD SMI:

##### AMD SMI VCN busy metric on Radeon RX GPUs

AMD SMI now correctly reports the VCN busy percentage for Radeon RX GPUs in the `amd-smi metric --usage` output. On affected devices where GPU metrics lacked VCN activity data, the value previously displayed as `N/A`. AMD SMI now reads the metric from the available sysfs source and reports it correctly.

##### AMD SMI API removals

The AMD SMI library has removed several APIs, types, defines, and enums, and changed the Application Binary Interface (ABI) of `amdsmi_gpu_metrics_t` in this release. For details, see [AMD SMI API and ABI changes](#amd-smi-breaking-changes).

(release-supported-hw)=

## AMD hardware support

The following table lists supported AMD Instinct GPUs, Radeon GPUs, and Ryzen APUs. Each supported device is listed with its corresponding GPU microarchitecture and LLVM target.

:::{note}

If your GPU is not listed, it might be community-enabled through TheRock nightly builds. For more information, see [TheRock supported GPUs](https://github.com/ROCm/TheRock/blob/main/SUPPORTED_GPUS.md). For installation guidance, see [TheRock releases](https://github.com/ROCm/TheRock/blob/main/RELEASES.md).
:::

```{datatemplate:yaml} /data/gpus.yaml
:template: hardware-support-table.md.jinja
```

(release-supported-os)=

## Operating system support

ROCm supports the following Linux distributions and Microsoft Windows versions. If you're running ROCm on Linux, ensure your system is using a supported kernel version.

:::{important}
The following table is a general overview of supported operating systems. Actual support might vary by AMD GPU or APU. Use the {doc}`Compatibility matrix </compatibility/compatibility-matrix>` to verify support for your specific setup before installation.
:::

```{datatemplate:yaml} /data/os-support.yaml
:template: os-support-table.md.jinja
```

## Installation updates

ROCm 10.0.0 adds support for new GPUs and APUs and fixes minor issues in the Runfile Installer.

(release-supported-fw)=

## Kernel driver and firmware bundle support

ROCm requires a coordinated stack of compatible firmware, driver, and user-space components. Maintaining version alignment between these layers ensures correct GPU operation and performance, especially for AMD data center products. While AMD publishes the AMD GPU driver and ROCm user space components, your server OEM (original equipment manufacturer) or infrastructure provider distributes the firmware packages. AMD supplies those firmware images (platform level data model (PLDM) bundles), which the OEM integrates and distributes.

```{datatemplate:yaml} /data/driver-firmware-support.yaml
:template: driver-firmware-support-table.md.jinja
```

(release-virtualization-support)=

## GPU virtualization support

AMD Instinct data center GPUs support virtualization in the following configurations. Supported SR-IOV configurations require the AMD GPU Virtualization Driver (GIM) 9.2.0.K—see the [AMD Instinct Virtualization Driver documentation](https://instinct.docs.amd.com/projects/virt-drv/en/mainline-9.2.0.k/) for more information.

```{datatemplate:yaml} /data/virtualization-support.yaml
:template: virtualization-support-table.md.jinja
```

(release-gpu-partitioning-support)=

## GPU partitioning support

```{datatemplate:yaml} /data/partitioning-support.yaml
:template: partitioning-support-table.md.jinja
```

See the [AMD GPU partitioning](https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/gpu-partitioning/index.html) topic in the AMD GPU Driver documentation to learn more.

(release-ai-ecosystem)=

## AI ecosystem support

ROCm 10.0.0 provides optimized support for popular deep learning frameworks and AI inference engines. The following table lists supported frameworks and libraries, their compatible operating systems, and validated versions.

:::{important}
The following table is a general overview of supported frameworks and AI inference engines. Actual support might vary by AMD GPU or APU. Use the {doc}`Compatibility matrix </compatibility/compatibility-matrix>` to verify support for your specific setup.
:::

```{include} ./include/ai-ecosystem-support-table.html
:parser: myst
```

(release-components)=

## ROCm Core SDK components

The following table lists core tools and libraries included in the ROCm 10.0.0 release.

:::{important}
The following table is a general overview of ROCm Core SDK components. Actual support for these libraries and tools can vary by GPU and OS. Use the {doc}`Compatibility matrix </compatibility/compatibility-matrix>` to verify support for your specific setup.
:::

```{datatemplate:yaml} /data/components-current.yaml
:template: core-sdk-components-table.html.jinja
```

### ROCm component changelogs

The following sections describe key changes to ROCm Core SDK components.

```{note}
For a historical overview of ROCm component updates, see the {doc}`ROCm consolidated changelog </release/changelog>`.
```

```{include} ./include/core-sdk-components-aggregated-changelog.md
:parser: myst
```

## ROCm breaking changes

(amd-smi-breaking-changes)=
### AMD SMI API and ABI changes

The AMD SMI library introduced the following breaking changes in the 10.0.0 release: API-incompatible changes, which require source code changes before your code will compile, and ABI-incompatible changes, which require recompilation even if your code doesn't change. It also deprecated several APIs and enums that remain functional in ROCm 10.0 but are scheduled for removal in a future release.

#### ABI-incompatible changes

##### Library SONAME

| Change | Impact |
|---|---|
| The library major version is now 27.0.0, so the shared library SONAME is `libamd_smi.so.27` | Consumers linked against `libamd_smi.so.26` must relink. No source changes are required beyond the API changes listed on this page |

##### `amdsmi_gpu_metrics_t` field type widening

The following fields in `amdsmi_gpu_metrics_t` changed from `uint32_t` to `uint64_t` to support next generation AMD Instinct counter ranges:

* `gfx_activity_acc`
* `mem_activity_acc`
* `pcie_nak_sent_count_acc`
* `pcie_nak_rcvd_count_acc`
* `pcie_lc_perf_other_end_recovery`

Recompile any code that reads these fields. Any assignments into fixed-width 32-bit variables must be updated to use 64-bit types.

#### API-incompatible changes

The AMD SMI library removed or changed the following APIs, types, and defines in this release. Certain items have been removed with or without a replacement; see the following tables for details.

##### Removed APIs

| Removed | Replacement |
|---|---|
| `amdsmi_gpu_driver_reload()` | No replacement. Reload the driver out of band with `sudo modprobe -r amdgpu && sudo modprobe amdgpu` to apply memory partition changes |
| `amdsmi_set_gpu_clk_range()` | `amdsmi_set_gpu_clk_limit()` |
| `amdsmi_get_cpusocket_handles()` (Python interface only) | `amdsmi_get_cpu_handles()` |

##### Removed Python output fields

| Removed | Replacement |
|---|---|
| `plpds` key in the `amdsmi_get_xgmi_plpd()` return dictionary | `policies` key, which holds the same value |

##### Changed signatures

| API | Change |
|---|---|
| `amdsmi_fabric_telem_id_to_string()` | Returns `amdsmi_status_t` and writes the name through a `const char**` out-parameter, instead of returning `const char*` directly |

##### Types

| Removed | Replacement |
|---|---|
| `amdsmi_fabric_info_ver_t` | Moved inside `amdsmi_fabric_info_t` |
| `amdsmi_nic_fw_t` | `amdsmi_nic_fw_entry_t` |

##### Renamed defines

Public preprocessor macros in `amdsmi.h` are now prefixed with `AMDSMI_`. The Python interface
constant `MAX_NUMBER_OF_AFIDS_PER_RECORD` is renamed to match.

| Old name | New name |
|---|---|
| `MAX_NUMBER_OF_AFIDS_PER_RECORD` | `AMDSMI_MAX_NUMBER_OF_AFIDS_PER_RECORD` |
| `MAX_SVI3_RAIL_INDEX` | `AMDSMI_MAX_SVI3_RAIL_INDEX` |
| `MAX_SVI3_RAIL_SELECTION` | `AMDSMI_MAX_SVI3_RAIL_SELECTION` |
| `POWER_EFFICIENCY_MODE_4` | `AMDSMI_POWER_EFFICIENCY_MODE_4` |
| `POWER_EFFICIENCY_MODE_5` | `AMDSMI_POWER_EFFICIENCY_MODE_5` |

##### Removed defines

These macros were unreferenced by any API or structure and have no replacement.

| Removed |
|---|
| `AMDSMI_DFC_FW_NUMBER_OF_ENTRIES` |
| `AMDSMI_MAX_BLACK_LIST_ELEMENTS` |
| `AMDSMI_MAX_DRIVER_NUM` |
| `AMDSMI_MAX_ERR_RECORDS` |
| `AMDSMI_MAX_PROFILE_COUNT` |
| `AMDSMI_MAX_TA_WHITE_LIST_ELEMENTS` |
| `AMDSMI_MAX_VF_COUNT` |
| `AMDSMI_MAX_WHITE_LIST_ELEMENTS` |
| `AMDSMI_PF_INDEX` |
| `CENTRIGRADE_TO_MILLI_CENTIGRADE` |

#### AMD SMI deprecations

These APIs and enums are still present in ROCm 10.0 and are slated for removal in a future release. The Python bindings emit a `DeprecationWarning` where applicable.

##### Deprecated APIs

| Deprecated | Replacement |
|---|---|
| `amdsmi_get_gpu_vram_vendor()` | `amdsmi_get_gpu_vram_info()`; read the `vram_vendor` field |
| `amdsmi_get_gpu_compute_partition()` | `amdsmi_get_gpu_accelerator_partition_profile()` |
| `amdsmi_set_gpu_compute_partition()` | `amdsmi_set_gpu_accelerator_partition_profile()` |
| `amdsmi_get_gpu_compute_partition_mem_alloc_mode()` | `amdsmi_get_gpu_accelerator_partition_mem_alloc_mode()` |
| `amdsmi_set_gpu_compute_partition_mem_alloc_mode()` | `amdsmi_set_gpu_accelerator_partition_mem_alloc_mode()` |
| `amdsmi_set_gpu_memory_partition()` | `amdsmi_set_gpu_memory_partition_mode()` |
| `amdsmi_get_gpu_device_bdf_bdf()` (Python interface only) | `amdsmi_get_gpu_device_bdf()`; format the returned BDF string |

##### Deprecated enums and enumerators

The old names are retained as aliases with unchanged values and are slated for removal in a future
release.

| Deprecated | Replacement |
|---|---|
| `AMDSMI_FABRIC_TYPE_UALLINK` | `AMDSMI_FABRIC_TYPE_UALINK` |
| `AMDSMI_FABRIC_TELEMETRY_CATEGORY_UNKNOWN` | `AMDSMI_FABRIC_TELEMETRY_CATEGORY_INVALID` |
| `CLK_LIMIT_MIN`, `CLK_LIMIT_MAX` | `AMDSMI_CLK_LIMIT_MIN`, `AMDSMI_CLK_LIMIT_MAX` |
| `AGG_BW0`, `RD_BW0`, `WR_BW0` | `AMDSMI_AGG_BW0`, `AMDSMI_RD_BW0`, `AMDSMI_WR_BW0` |
| `amdsmi_compute_partition_type_t` | `amdsmi_accelerator_partition_type_t` |
| `amdsmi_compute_partition_mem_alloc_mode_t` | `amdsmi_accelerator_partition_mem_alloc_mode_t` |

## ROCm known issues

ROCm known issues are noted on {fab}`github` [GitHub](https://github.com/ROCm/ROCm/labels/Verified%20Issue). These issues will be fixed in a future ROCm release. For known issues related to individual components, review the [ROCm component changelogs](#rocm-component-changelogs).

### HuggingFace model training throughput might regress on AMD Instinct MI350X

HuggingFace model training workloads might see 9–25% lower training throughput on AMD Instinct MI350X (gfx950) GPUs, including BART, GPT-2, DiT (Diffusion Transformers), BERT, Llama 2 70B Chat, and RoBERTa-large. This occurs because AOTriton 0.13b selects a suboptimal flash-attention backward kernel instead of the faster 3-kernel split used in AOTriton 0.11.2b. As a workaround, rebuild PyTorch and pin AOTriton to version 0.11.2b. See [GitHub issue #7696](https://github.com/ROCm/TheRock/issues/7696).

### JAX BERT FP16 training might encounter a segmentation fault on some Radeon GPUs

JAX BERT FP16 training workloads might encounter a segmentation fault on some AMD Radeon graphics products, such as the Radeon PRO W7900, causing training to terminate unexpectedly. As a workaround, disable XLA GPU command buffers by setting the `XLA_FLAGS="--xla_gpu_enable_command_buffer="` environment variable before launching the workload. See [GitHub issue #7697](https://github.com/ROCm/TheRock/issues/7697).

### PyTorch training and fine-tuning workloads might experience GPU resets or crashes on some Radeon GPUs

PyTorch training and fine-tuning workloads using Llama-Factory or Unsloth might experience GPU resets or application crashes on some AMD Radeon graphics products, such as the Radeon RX 9070 Series and Radeon AI PRO R9700. As a workaround, set the `TORCH_BLAS_PREFER_HIPBLASLT=0` environment variable to disable hipBLASLt for training and fine-tuning workloads. This workaround might result in performance degradation. See [GitHub issue #7699](https://github.com/ROCm/TheRock/issues/7699).

### SGLang inference might fail with the default AITER attention backend on some Radeon GPUs

SGLang inference workloads using the default AITER attention backend might fail on some AMD Radeon graphics products, such as the Radeon PRO W7900, Radeon AI PRO R9700, and Radeon RX 9070 XT. As a workaround, configure SGLang to use the Triton attention backend (`--attention-backend triton`) or disable AITER:

```bash
export SGLANG_USE_AITER=0
export SGLANG_USE_AITER_AR=0
```

See [GitHub issue #7700](https://github.com/ROCm/TheRock/issues/7700).

### TensorFlow ROCm v2.21 might fail to start with a libhipsparse ImportError on some Radeon GPUs

TensorFlow ROCm v2.21 workloads might fail to start with an `ImportError: libhipsparse.so.4` on some AMD Radeon graphics products, such as Radeon AI PRO R9700, when ROCm is installed using pip packages. As a workaround, add `$(hipconfig -R)/lib` and `$(hipconfig -R)/lib/rocm_sysdeps/lib` to `LD_LIBRARY_PATH` before launching TensorFlow. See [GitHub issue #7701](https://github.com/ROCm/TheRock/issues/7701).

### vLLM or ComfyUI workloads might crash on some Ryzen AI systems

Intermittent segmentation faults or GPU hangs might be observed when running some vLLM or ComfyUI workloads on Ryzen AI systems using gfx1103 (RDNA3) GPUs. See [GitHub issue #7702](https://github.com/ROCm/TheRock/issues/7702).

### Inaccurate output when running certain LLM models on AMD Radeon RX 9050 (8GB) GPUs

Certain large language models (LLMs) might produce inaccurate output on [AMD Radeon RX 9050](https://www.amd.com/en/products/graphics/desktops/radeon/9000-series/amd-radeon-rx-9050.html) (8GB) GPUs .The issue has been observed across multiple LLMs. The issue is not observed on [AMD Radeon RX 9050 (4GB)](https://www.amd.com/en/products/graphics/desktops/radeon/9000-series/amd-radeon-rx-9050-4gb.html) GPUs, the 4 GB memory variant of the same GPU.

### ComfyUI might crash or trigger a TDR on some AMD Ryzen AI processors when dynamic VRAM is enabled

ComfyUI workloads on Windows with ROCm 10 might encounter an access violation error or a timeout detection and
recovery (TDR) event on some AMD Ryzen AI processors, such as the [AMD Ryzen AI Max+ PRO 395](https://www.amd.com/en/products/processors/laptop/ryzen-pro/ai-max-pro-300-series/amd-ryzen-ai-max-plus-pro-395.html), causing the application to crash. This occurs because a recent ComfyUI update enabled dynamic VRAM by default, which triggers an access violation tied to the AIMDO component when loading most models (Z-Image is unaffected, as it doesn't use AIMDO). As a workaround, add the `--disable-dynamic-vram` flag to the ComfyUI launch command.

###  PyTorch training with Apex FusedLayerNorm might see a slow first iteration on certain AMD Instinct GPUs

PyTorch training workloads that use the Apex `FusedLayerNorm` extension, such as Megatron-BERT, might experience a significantly slower first training iteration. The issue has been observed on AMD Instinct MI300X, MI350X, and MI355X GPUs starting with ROCm 7.2.1 and later. This issue occurs because Apex's native extensions are no longer precompiled into the container image at build time; instead, lazy-loading JIT stubs trigger `hipcc` compilation the first time `FusedLayerNorm` is used, adding up to ~18 seconds of one-time compilation overhead. Steady-state kernel execution performance is unaffected once compilation completes. As a workaround, precompile the Apex native extensions when building the container image (rather than relying on the lazy JIT `op_builder` stubs) so the compilation cost is paid at build time instead of at the first use.

## ROCm resolved issues

The following notable issues have been fixed in ROCm 10.0.0.

### ASAN produced incorrect results with ternary operators on struct kernel arguments

Previously, when compiling GPU kernels with ASAN enabled, ternary operators with struct kernel arguments could produce incorrect results, masking real bugs and producing false-positive results during memory-safety validation.

### GPU kernels failed to launch in ASAN builds with large thread counts

Previously, when building GPU libraries with ASAN enabled, kernels configured with large thread counts could fail to launch, returning the `HSA_STATUS_ERROR_INVALID_ISA` error.

### Multi-target GPU builds produced larger binary sizes

Previously, applications targeting multiple AMD GPU architectures could produce significantly larger binaries. Multi-target builds could increase binary size by up to 54%, and single-target builds added approximately 8 MB per GPU target.

### HIP applications stalls on Windows during high-volume memory pool allocation and deallocation

Previously, HIP applications on Windows that performed many memory pool allocation and deallocation cycles could stall indefinitely while waiting for a memory-mapping operation to complete on the GPU. This was most commonly observed while running the rocBLAS test suite on Windows.

## ROCm upcoming changes

Future releases will add support for:

* Additional ROCm Core SDK components.

* Domain-specific expansion toolkits (data science, life sciences, finance, simulation, and other HPC domains).

* More AMD hardware support.

