# ROCm Core SDK {{ ROCM_VERSION }} release notes

ROCm Core SDK {{ ROCM_VERSION }} continues the technology preview release stream
that began with ROCm 7.9.0, advancing the transition to the new
[TheRock](https://github.com/rocm/therock) build and release system. To learn
more, see the [transition guide](/about/transition-guide-TheRock).

(preview-stream-note)=
:::{important}
ROCm {{ ROCM_VERSION }} follows the
<a href="https://rocm.docs.amd.com/en/7.9.0-preview/about/release-notes.html#preview-stream-note"
target="_blank">versioning discontinuity that began with the 7.9.0 preview release</a>
and remains separate from the 7.0 to 7.2 production releases. For the latest
production stream release, see the
<a href="https://rocm.docs.amd.com/en/latest/">ROCm documentation</a>.

Maintaining parallel release streams -- preview and production -- gives
users ample time to evaluate and adopt the new build system and dependency
changes. The technology preview stream is planned to continue through
mid-2026, after which it will replace the current production stream.

For previous preview releases, see the
<a target="_blank" href="https://rocm.docs.amd.com/en/7.12.0-preview/release/versions.html">release history</a>.
:::

## Release highlights

ROCm Core SDK {{ ROCM_VERSION }} with TheRock builds upon the [7.12.0 preview
release](https://rocm.docs.amd.com/en/7.12.0-preview/about/release-notes.html).

This release expands support for AI inference, distributed workloads, and
profiling workflows across AMD Instinct™, Radeon™, and Ryzen™ AI platforms.
ROCm 7.13.0 adds inference-ready vLLM containers, expands GPU virtualization
and partitioning support, introduces new profiling and tracing capabilities,
and improves AI kernel, sparse math, and communication libraries.

### Platform and hardware support

This release expands GPU, operating system, virtualization, and partitioning support.

#### Expanded AMD GPU support

ROCm 7.13.0 adds support for the following AMD GPUs and APUs:

* AMD Instinct MI350P (gfx950)
* AMD Radeon AI PRO R9700S (gfx1201)
* AMD Radeon PRO W6800 (gfx1030)
* AMD Radeon PRO V620 (gfx1030)
* AMD Ryzen AI 7 PRO 360 (gfx1152)
* AMD Ryzen AI 7 PRO 350 (gfx1152)
* AMD Ryzen AI 5 PRO 340 (gfx1152)
* AMD Ryzen AI 7 350 (gfx1152)
* AMD Ryzen AI 7 345 (gfx1152)
* AMD Ryzen AI 5 340 (gfx1152)
* AMD Ryzen AI 5 330 (gfx1152)

For the complete list of supported AMD hardware, see [AMD hardware support](#amd-hardware-support).

#### Expanded Ubuntu support

ROCm 7.13.0 adds support for Ubuntu 26.04 on Instinct, Radeon, and Ryzen
devices.

24.04.4 is now the validated Ubuntu 24 release instead of Ubuntu 24.04.3.

For the full list of supported Linux distributions, see [Operating system support](#operating-system-support).

#### Expanded GPU virtualization support for Instinct GPUs

ROCm 7.13.0 adds support for the following virtualization configurations on AMD Instinct GPUs.

* On MI355X: VMware ESXi 9.1 with Ubuntu 24.04 guest OS.

* On MI300X: KVM SR-IOV with Ubuntu 24.04 host OS and Ubuntu 24.04 guest OS.

* On MI210:

  * KVM passthrough with RHEL 9.4 host OS and Ubuntu 22.04 guest OS.

  * KVM SR-IOV with RHEL 9.4 host OS and Ubuntu 22.04 guest OS.

  * KVM SR-IOV with RHEL 9.4 host OS and RHEL 9.4 guest OS.

Supported SR-IOV configurations require the [GIM Driver
9.0.0K](https://github.com/amd/MxGPU-Virtualization/releases/tag/9.0.0.K). For
details, see [GPU virtualization support](#gpu-virtualization-support).

#### Expanded Instinct GPU partitioning support

ROCm 7.13.0 enables the following GPU partitioning configurations in bare metal deployments:

* On MI355X and MI350X: QPX compute partitioning with NPS 2 memory partitioning

* On MI350P: CPX compute partitioning with NPS 1 memory partitioning

For details, see [GPU partitioning support](#gpu-partitioning-support).

### AI inference and frameworks

This release adds inference-ready container images and improves multi-node communication for distributed workloads.

#### vLLM 0.19.1 Docker images and pip packages

With ROCm 7.13.0, Docker images for running vLLM inference workloads are
available. Images include vLLM 0.19.1, PyTorch 2.10, and Python 3.13 on Ubuntu 24.04.

Architecture-specific images are available for:

* AMD Instinct GPUs: gfx942 (MI325X, MI300X, MI300A) and gfx950 (MI355X, MI350X, MI350P)
* AMD Radeon GPUs: gfx1100, gfx1101, gfx1102, gfx1200, gfx1201
* AMD Ryzen AI APUs: gfx1150, gfx1151, gfx1152

See [](../ai-inference/vllm) to get started.

#### RCCL multi-node optimization for AMD Ryzen AI Max 300 series

RCCL improves multi-node clustering performance on systems with AMD Ryzen AI
Max 300 series connected over Ethernet. Building on the initial
multi-node enablement in ROCm 7.12.0, this release optimizes collective
communication for distributed AI inference workloads using tensor parallelism
(TP) and expert parallelism (EP) across up to 4 Ethernet-connected nodes.

#### RCCL GDA-based alltoall via rocSHMEM integration (experimental)

RCCL adds experimental support for GPU Direct Async (GDA)-based alltoall and
alltoallv collective operations through rocSHMEM integration. When enabled,
RCCL invokes rocSHMEM operations that use GDA to reduce latency for small
message alltoall patterns.

This feature requires building RCCL with the `--rocshmem` flag and setting
`RCCL_ROCSHMEM_ENABLE=1` at runtime. GDA support currently requires Broadcom
NICs with GDA capability.

### Developer tools and profiling

This release adds new profiling capabilities, introduces the open-source ROCprof Trace Decoder, and extends HIP programming APIs.

#### ROCprof Trace Decoder open source release

ROCprof Trace Decoder, previously delivered as a closed-source
component within ROCprofiler-SDK, is now available as the open-source
rocprof-trace-decoder library. The decoder converts raw SQTT data from AMD GPUs
into structured execution traces for performance analysis and debugging. It
supports a wide range of AMD GPUs spanning Instinct, Radeon, and Ryzen
architectures, with unit and integration tests across all supported hardware.
See [AMD hardware support](#amd-hardware-support) for the complete list.

<!-- For more information, see [ROCprof Trace Decoder and thread trace APIs](https://rocm.docs.amd.com/projects/rocprofiler-sdk/en/docs-7.13.0/api-reference/thread_trace.html) and [Using thread trace](https://rocm.docs.amd.com/projects/rocprofiler-sdk/en/docs-7.13.0/how-to/using-thread-trace.html) in the ROCprofiler-SDK documentation. -->

#### HIP cooperative groups reduce operations

HIP adds `cooperative_groups::reduce()` for performing reduction operations
across `thread_block_tile` and `coalesced_threads` groups. The implementation
is based on `__reduce_*_sync` operations, and the
`HIP_ENABLE_EXTRA_WARP_SYNC_TYPES` macro might be required to enable some
optimizations.

Additionally, `__reduce_and_sync()`, `__reduce_or_sync()`, and
`__reduce_xor_sync()` now provide consistent behavior for all mask values. All
masks now emit bitwise instructions, aligning behavior with NVIDIA CUDA. This
is a change from previous versions, where some masks were translated to bitwise
operations, and others were not.

#### ROCm Compute Profiler feature highlights

The following are notable enhancements to the ROCm Compute Profiler
(rocprofiler-compute).

* **RDNA 3.5 support:** ROCm Compute Profiler now supports GPU performance
  profiling and analysis on AMD Ryzen AI Max 300 series processors.
  <!-- An [RDNA 3 -->
  <!-- section](https://rocm.docs.amd.com/projects/rocprofiler-compute/en/docs-7.13.0/conceptual/rdna/rdna-performance-model.html) -->
  <!-- has been added to the performance model documentation explaining the supported -->
  <!-- performance metrics for AMD Ryzen AI Max 300 series processors. A new memory -->
  <!-- chart visualization accommodates the architectural differences between -->
  <!-- RDNA 3.5 and CDNA GPUs. Roofline is not yet supported for AMD Ryzen AI -->
  <!-- Max 300 series processors. -->

* **Removed dependency requirements for profiling:** Building ROCm Compute
  Profiler and using profile mode no longer requires installing Python
  dependencies from the `requirements.txt` file. Analysis mode still requires
  Python dependencies.

  This change moves several operations from profile mode to analysis mode,
  including roofline HTML generation, roofline-related options
  (`--sort`, `--mem-level`, `--roofline-data-type`), and creation of the
  combined `pmc_perf.csv` file. Profile mode now only runs the roofline
  empirical benchmark, creates a `roofline.csv` file, and creates per-replay
  CSV files without merging them.

#### ROCm Systems Profiler feature highlights

The following are notable enhancements to the ROCm Systems Profiler
(rocprofiler-systems).

* **Pause and resume profiling:** ROCm Systems Profiler now supports pausing
  and resuming profiling at runtime through the `roctxProfilerPause` and
  `roctxProfilerResume` APIs. This allows you to capture profiling data only
  during specific execution phases, reducing overhead and minimizing output size
  for long-running workloads.
  <!--   For more information, see [Configuring runtime -->
  <!-- options](https://rocm.docs.amd.com/projects/rocprofiler-systems/en/docs-7.13.0/how-to/configuring-runtime-options.html) -->
  <!-- in the ROCm Systems Profiler documentation. -->

* **Selective region tracing:** You can now restrict tracing to defined regions
  of interest using the `ROCPROFSYS_SELECTED_REGIONS` environment variable,
  reducing noise and limiting data collection to relevant workload segments.
  <!-- For more -->
  <!-- information, see -->
  <!-- [ROCPROFSYS_SELECTED_REGIONS](https://rocm.docs.amd.com/projects/rocprofiler-systems/en/docs-7.13.0/how-to/configuring-runtime-options.html#rocprofsys-selected-regions) -->
  <!-- in the ROCm Systems Profiler documentation. -->

* **KFD event tracing:** Kernel Fusion Driver (KFD) event tracing is now
  available for GPU memory management analysis, including page faults, page
  migrations, queue evictions, GPU unmap events, and dropped events. Requires
  an XNACK-capable GPU and ROCprofiler-SDK 1.2.1 or later.
  <!-- For more -->
  <!-- information, see [Configuring runtime -->
  <!-- options](https://rocm.docs.amd.com/projects/rocprofiler-systems/en/docs-7.13.0/how-to/configuring-runtime-options.html#exploring-gpu-metrics) -->
  <!-- in the ROCm Systems Profiler documentation. -->

* **MPI file-output filtering:** You can now filter profiler output files based
  on MPI rank using the `--rank-filter-output` CLI option or the
  `ROCPROFSYS_RANK_FILTER_OUTPUT` configuration setting, suppressing output
  from all other ranks. An optional `--rank-filter-id` option
  (`ROCPROFSYS_RANK_FILTER_ID`) allows specifying a custom environment variable
  for rank identification.
  <!--   For more information, see [Selective rank -->
  <!-- profiling](https://rocm.docs.amd.com/projects/rocprofiler-systems/en/docs-7.13.0/how-to/communication-runtime-profiling.html#selective-rank-profiling) -->
  <!-- in the ROCm Systems Profiler documentation. -->

* **JSON-based profiling presets and domain flags:** You can now configure
  common profiling workflows using JSON-based presets and a single
  `--preset=<name>` flag instead of manually setting multiple `ROCPROFSYS_*`
  environment variables. Eleven built-in presets cover common profiling scenarios, including GPU
  tracing, HPC workloads, and API-level analysis. Composable domain flags
  (`--gpu`, `--rocm`, `--cpu`, `--parallel`) and a topic-based
  `--help=<topic>` system further simplify configuration and discoverability.
  <!-- For more information, see [Using preset profiles and domain -->
  <!-- flags](https://rocm.docs.amd.com/projects/rocprofiler-systems/en/docs-7.13.0/how-to/using-preset-profiles.html) -->
  <!-- in the ROCm Systems Profiler documentation. -->

#### AMD SMI feature highlights

* **APU metrics and memory tuning**: New APU telemetry provides per-core
  temperature, power, clock, voltage, current, and throttle monitoring, with
  additional support for IPU activity and DRAM bandwidth metrics. New VRAM
  carveout and GTT tuning controls enable configurable memory allocation on
  supported APU platforms.

* **Per-component GPU temperature and clock monitoring**: GPU metrics table
  version 1.9 adds HBM stack temperatures, per-die temperature monitoring, and
  per-die memory and SOC clock reporting for data center deployments.

* **CPU power APIs report in milliwatts (breaking change)**: CPU power APIs now
  return values in milliwatts (mW) instead of watts. Python bindings now return
  numeric integer values instead of formatted strings. Existing applications
  that parse previous string-based outputs must be updated.

For more information, see the AMD SMI section in the [ROCm component changelogs](#rocm-component-changelogs).

### Libraries

This release adds new routines, data type support, and performance improvements across ROCm math and AI libraries.

#### Composable Kernel adds quantization and attention kernel capabilities

Composable Kernel adds several capabilities for AI and large language model
workloads:

* **Microscaling (MX) FP8/FP4 support:** Mixed data type support for MX FP8 and
  FP4 in GEMM and Flash Multi-Head Attention (FMHA) forward kernels on AMD
  Instinct MI350 Series GPUs.

* **FP8 quantization for FMHA:** FMHA forward kernels now support multiple FP8
  quantization modes, including dynamic tensor-wise quantization, block scale
  quantization, per-tensor quantization, and FP8 KV cache support for batch
  prefill.

* **StreamingLLM and long-context inference:** Sink token support for FMHA
  forward enables StreamingLLM-style long-context inference.

* **Batch prefill enhancements:** FMHA batch prefill kernels now support
  multiple KV cache layouts, flexible page sizes, and configurable lookup table
  configurations.

* **RDNA 3 FMHA support:** Flash Attention kernels are now available on RDNA 3
  architectures.

* **SageAttention v2 forward kernel:** Multi-granularity quantization for Q, K,
  and V tensors with FP8, INT8, and INT4 data types and per-tensor, per-block,
  per-warp, and per-thread scale granularities on AMD Instinct MI300 Series and
  MI350 Series GPUs.

#### General Batched GEMM support in hipBLASLt

hipBLASLt adds native support for General Batched GEMM, where all matrices in
a batch share the same problem dimensions but can have independent leading
dimensions and strides. This replaces the previous implementation through the
`hipblaslt_ext` Grouped GEMM APIs, which had known limitations.

The new implementation includes support for Global Split-U (GSU) to improve
performance at large problem sizes. General Batched GEMM is important for
inference workloads that dispatch batches of same-shape GEMM operations.

<!-- For more information, see the [hipBLASLt -->
<!-- documentation](https://rocm.docs.amd.com/projects/hipBLASLt/en/docs-7.13.0/index.html). -->

#### rocSOLVER adds new solver routines and matrix analysis functions

rocSOLVER adds the following new routines, all with 64-bit index support:

* **GETRS_NPVT:** Solution of linear systems using LU factorization without
  pivoting. Batched and strided-batched variants are available.

* **SYTRS:** Solution of linear systems for symmetric matrices. Batched and
  strided-batched variants are available.

Additionally, POTF2 and downstream POTRF Cholesky factorization performance
have been improved.
<!-- For more information, see the [rocSOLVER -->
<!-- documentation](https://rocm.docs.amd.com/projects/rocSOLVER/en/docs-7.13.0/index.html). -->

#### rocSPARSE adds sparse factorization routines

rocSPARSE adds new generic API routines for sparse incomplete factorization and
triangular solve:

* `rocsparse_spic0` and `rocsparse_spilu0`: Generic incomplete Cholesky (IC0)
  and incomplete LU (ILU0) factorization routines with strided-batched
  computation support.

* `rocsparse_sptrsv`: Extended with strided-batched computation support and
  singularity detection through the new `rocsparse_singularity` enumeration.

Performance of tridiagonal solvers `rocsparse_Xgtsv_no_pivot` and
`rocsparse_Xgtsv_no_pivot_strided_batch` has been improved.
<!-- For more -->
<!-- information, see the [rocSPARSE -->
<!-- documentation](https://rocm.docs.amd.com/projects/rocSPARSE/en/docs-7.13.0/index.html). -->

#### Added rocDecode and rocJPEG libraries to the ROCm Core SDK

rocDecode provides hardware-accelerated video decoding for H.264, H.265/HEVC,
AV1, and VP9 codecs, while rocJPEG provides hardware-accelerated JPEG decoding
on AMD GPUs. Together, they enable
efficient GPU-based media processing pipelines for data-intensive workloads
such as AI training.

Both libraries are supported on Linux on AMD Instinct, Radeon, and Ryzen AI. See
the projects in [ROCm/rocm-systems](https://github.com/ROCm/rocm-systems) for
more information.

#### Added ROCm Data Center Tool to the ROCm Core SDK

ROCm Data Center Tool (RDC) provides telemetry collection, health monitoring,
and job-level GPU statistics for data center deployments with AMD Instinct
accelerators. RDC enables system administrators and cluster managers to monitor
GPU health, collect telemetry data, and track per-job GPU usage across
multi-node environments.

RDC is supported on Linux with AMD Instinct GPUs.
<!-- See the -->
<!-- [RDC documentation](https://rocm.docs.amd.com/projects/rdc/en/docs-7.13.0/index.html) -->
<!-- for more information. -->

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

ROCm 7.13.0 introduces several improvements to the Runfile Installer:

* Performance improvements for installing and uninstalling gfx architectures.
* ROCm component tests are now included.
* Support for prerequisite OEM kernel installation as part of the dependency install on Ryzen systems. You no longer need to install it manually.
* Auto-detection of the GPU when using the GUI or when the `gfx=` argument is not provided on the command line. If the installer cannot detect the GPU, you must specify the gfx architecture using the GUI or the `gfx=` argument.

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

The following compute partition and NUMA-per-socket (NPS) configurations are
available on AMD Instinct GPUs in bare metal deployments.

```{include} ./include/partitioning-support-table.html
:parser: myst
```

See the [AMD GPU partitioning](https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/gpu-partitioning/index.html)
topic in the AMD GPU Driver documentation to learn more.

(release-ai-ecosystem)=

## AI ecosystem support

ROCm 7.13.0 provides optimized support for popular deep learning frameworks and
AI inference engines. The following table lists supported frameworks and
libraries, their compatible operating systems, and validated versions.

```{include} ./include/ai-ecosystem-support-table.html
:parser: myst
```

(release-components)=

## ROCm Core SDK components

The following table lists core tools and libraries included in the ROCm 7.13.0
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

### ROCm Compute Profiler might fail when profiling bash script or command

Running a bash script or command as a target for ROCm Compute Profiler might fail because bash overwrites the required environment variables. As a workaround, use `--no-native-tool` option in the profile mode. Note that this will disable iteration multiplexing.

### hipFFT and rocFFT callback examples fail to build on Windows

The hipFFT and rocFFT callback examples in [rocm-examples](https://github.com/rocm/rocm-examples) fail to build on a Windows operating system due to a linker error. CMake configuration and HIP object compilation will complete successfully, but the final link step fails with `clang: error: invalid linker name in argument '-fuse-ld=lld-link'` This issue affects all Windows configurations using Relocatable Device Code (RDC) mode. Linux builds are not affected. As a workaround, skip the hipFFT and rocFFT callback examples on Windows, and refer to the Linux builds or [callback](https://github.com/ROCm/rocm-examples/tree/amd-staging/Libraries/rocFFT/callback/) functionality documentation.

### QMCPACK might become unresponsive during DMC simulation on AMD Instinct MI300A GPUs

QMCPACK might become unresponsive when running Diffusion Monte Carlo (DMC) simulations with certain inputs on AMD Instinct MI300A GPUs. The application stops making progress after initialization and must be terminated manually.

### Resource-intensive workloads might result in GPU memory faults

Applications that pass large, complex data structures between device functions using scratch memory, and particularly rely on compiler optimization to minimize the number of copy operations, might encounter GPU memory access faults and become unresponsive.

### Increased binary size for multi-target GPU builds

Applications targeting multiple AMD GPU architectures might observe significantly larger binary sizes. Multi-target builds can produce binaries up to 54 percent larger. Single-target builds add approximately 8 MB of additional size per GPU target. As a workaround, reduce the number of GPU targets in multi-target builds, or strip the resource-usage symbols from release binaries.

### HIP cooperative groups might fail when compiled using the SPIR-V path

HIP applications that use cooperative groups might fail at kernel launch when compiled with `--offload-arch=amdgcnspirv`. The application fails at runtime with `LLVM ERROR: Cannot select: intrinsic %llvm.amdgcn.s.wait.asynccnt` error message. This
affects all GPU architectures when using the SPIR-V compilation path. As a workaround, compile using a direct GPU architecture target (for example, `--offload-arch=gfx942`) instead of `--offload-arch=amdgcnspirv`.

### Illegal memory address error when using placement new with device function returns

HIP kernels that use the placement new operators to construct objects in the `hipMalloc` device memory might crash with `hipErrorIllegalAddress` error message when you pass a `__device__` function return value as the constructor argument. This only affects non-trivially-copyable types (for example, types with user-defined or deleted copy/move constructors). Trivially-copyable types are not affected. As a workaround, assign the device function return value to a local variable before passing it to placement new.

### LLVM-based compilers might fail when compiling half-precision vector operations

LLVM-based compilers might fail, returning `Failed to find subregs!` error message in `SIInstrInfo::copyPhysReg`, when compiling half-precision vector operations with optimization enabled. The issue was observed at optimization levels `-O1` to `-O3`.

### hipBLAS test suites failure on Windows

When using hipBLAS on Windows, the test suites might return non-zero exit codes, even when all mathematical correctness tests pass. This issue can affect CI/CD pipeline validation and block automated testing workflows on Windows systems, because the test framework might fail to detect successful test completion.

### ROCm Systems Profiler overwrites ROCPD output after process re-attachment

When you use `rocprof-sys-attach` to re-attach to a previously profiled process, the `ROCPD` output database files (.db) are written to the initial session's output directory instead of a new timestamped directory. This makes it difficult to distinguish profiling data between sessions. Perfetto trace files are not affected. As a workaround, back up your output directory before re-attaching to a previously profiled process.

### Missing dependencies when installing ROCm Core SDK

Installing the ROCm Core SDK using `amdrocm-core-sdk` or `amdrocm-core-dev/devel` might succeed, but some dependencies from the dev/devel meta packages might not be installed. As a workaround, install the dev packages manually:

```bash
sudo apt install amdrocm-*
```

### Issues related to AddressSanitizer

Multiple issues associated with AddressSanitizer (ASAN) `-fsanitize=address` being enabled have been observed including:

#### ASAN reports false errors for GPU kernels using shared memory

When you compile GPU kernels with ASAN enabled, kernels that use `__shared__` memory might produce false heap-buffer-overflow errors or GPU memory faults. As a workaround, disable ASAN by removing `-fsanitize=address` setting for affected kernels.

#### GPU kernels fail to launch in ASAN builds with large thread counts

When you build GPU libraries with ASAN enabled, kernels configured with large thread counts might fail to launch with `HSA_STATUS_ERROR_INVALID_ISA` error. As a workaround, reduce the thread block sizes to 256 threads or fewer for ASAN builds. The issue is currently under investigation.

#### ASAN breaks multi-architecture HIP binary builds

HIP applications built with ASAN enabled, targeting multiple GPU architectures, might fail to launch with `RuntimeError: .hipFatBinSegment size N is not a multiple of wrapper size (24)` and `RuntimeError: Unexpected magic 0x00000000 at wrapper i` error messages. Single-architecture builds are not affected. As a workaround, build single-architecture binaries using `--offload-arch` targeting only one GPU architecture, or disable ASAN by removing `-fsanitize=address` for HIP compilation.

#### ASAN produces incorrect results with ternary operators on struct kernel arguments

When you compile GPU kernels with ASAN enabled, ternary operators with struct kernel arguments might produce incorrect results. This can mask real bugs and produce false-positive results during memory-safety validation. The issue doesn't occur when the kernel arguments are first copied to local variables, or when compiled without ASAN. As a workaround, copy kernel arguments to local variables before using them in ternary expressions:

```cpp
auto local_arg = kernel_arg;
result = condition ? local_arg : other_arg;
```

Alternatively, disable ASAN by removing `-fsanitize=address`  when compiling GPU kernels.

## ROCm resolved issues

The following notable issues have been fixed in ROCm 7.13.0.

### Multi-ROCm installation failed on RPM-based distributions

Previously, installing multiple ROCm versions side by side on RPM-based distributions (RHEL and SLES) failed due to `.build-id` file conflicts between versioned packages.

### vLLM server failed to launch in ROCm Docker images

Previously, the vLLM server failed to start in ROCm 7.12.0 Docker images with an `ImportError` for `librocm_smi64.so.1` due to missing library path configuration.

### vLLM server failed to launch with tensor parallelism

Previously, the vLLM server failed to start with an invalid device pointer error when launching models with tensor parallelism set to 8 on AMD Instinct MI300 and MI355X GPUs.

### PyTorch DDP Gloo backend test failed on AMD GPUs

Previously, the PyTorch Distributed Data Parallel (DDP) test `test_ddp_apply_optim_in_backward_grad_as_bucket_view_false` failed when using the Gloo backend.

### rocWMMA header produced unknown type errors in HIP RTC

Previously, HIP RTC programs that included the `rocwmma/rocwmma.hpp` header failed to compile with unknown type name errors.

## ROCm upcoming changes

Future releases will add support for:

* Additional ROCm Core SDK components

* Domain-specific expansion toolkits (data science, life science, finance,
  simulation, and other HPC domains)

* More AMD hardware support
