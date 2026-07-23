#### **AMD SMI** (26.5.0)

##### Added

- NIC processor discovery and information API surface.
  - New C APIs: `amdsmi_get_nic_processor_handles()`, `amdsmi_get_nic_device_bdf()`, `amdsmi_get_nic_fw_info()`, `amdsmi_get_nic_port_statistics()`, and `amdsmi_get_nic_vendor_statistics()`.
  - `amdsmi_get_nic_processor_handles()` enumerates NIC processors by socket; the BDF, firmware, and port/vendor statistics getters are reserved and currently return `AMDSMI_STATUS_NOT_YET_IMPLEMENTED`.

- Exposed APU metrics through the CLI and Python interface.
  - `amd-smi metric` now surfaces APU-specific data under `--usage`, `--power`, `--clock`, `--temperature`, `--fan`, `--voltage`, and `--throttle` when APU metrics are available.
  - `amd-smi monitor` provides APU temperature and clock fallbacks when standard dGPU sensors report N/A.
  - On APU systems, the `--pcie`, `--ecc-blocks`, `--voltage-curve`, `--overdrive`, `--xgmi-err`, and `--energy` sections are not applicable and are omitted.

- The `--partition` flag to `amd-smi metric` for partition-scoped metrics.
  - The `-X`/`--partition` flag switches the temperature, clock, and usage categories to partition-level data sources; throttle metrics are already partition-aware.
  - Reuses the existing temperature/clock/usage section schema and adds partition-only AID/XCP/MID entries within it; socket-only fields with no partition equivalent report `N/A`.
  - When `--partition` is set with `--temperature`: adds MID and per-XCP/XCD temperatures.
  - When `--partition` is set with `--clock`: sources GFX/VCLK/DCLK/SOCCLK from partition metrics and adds per-AID and per-XCP clock entries with their limits.
  - When `--partition` is set with `--usage`: reports per-XCP GFX/JPEG/VCN activity.

- `--folder` support to `amd-smi ras --afid`.
  - `amd-smi ras --afid --folder <DIR>` decodes every `*.cper` in a directory and prints a `file_name | list of afids` table (or a JSON array under `--json`).
  - Records with no AFIDs show `-`; files that cannot be parsed show `decode failed`.

- Wrapped ESMI functions in `amdsmi_go_shim`.
  - Go callers can now access ESMI CPU functionality through the existing `amdsmi_go_shim` interface.

- GPU partitioning conceptual guide and usage examples.
  - New guide at `docs/conceptual/partition.md` covering accelerator partition modes (SPX/DPX/TPX/QPX/CPX), memory partition modes (NPS1/NPS2/NPS4/NPS8), API generations, device enumeration after partition, and BDF encoding.
  - New C++ example: `example/amd_smi_partition_example.cc`.
  - New Python example: `example/amd_smi_partition_example.py`.

- An alias for `amd-smi set -C/--compute-partition` as `amd-smi set --accelerator-partition`.
  - Compute and accelerator partitions are fundamentally the same, so users can now use `--accelerator-partition` to set the compute/accelerator partition.

- Input validation for CPU `set` commands.
  - Out-of-range values are now rejected with a clear error showing the valid range:
    - `--cpu-xgmi-link-width` (0-1)
    - `--cpu-gmi3-link-width` (0-2)
    - `--cpu-lclk-dpm-level` (0-3)
    - `--cpu-disable-apb` (0-3)
  - `--cpu-pwr-limit` values above the socket maximum are now reduced to the maximum and applied, with a warning.

- A compute partition memory allocation mode API.
  - New `amd-smi static --partition` output includes `COMPUTE_PARTITION_MEM_ALLOC_MODE` field.
  - New `amd-smi set --compute-partition-mem-alloc-mode [CAPPING|ALL]` to control memory allocation mode (requires sudo).
  - New APIs: `amdsmi_get_gpu_compute_partition_mem_alloc_mode()`, `amdsmi_set_gpu_compute_partition_mem_alloc_mode()`.
  - New enum: `amdsmi_compute_partition_mem_alloc_mode_t` (`AMDSMI_COMPUTE_PARTITION_MEM_ALLOC_CAPPING`, `AMDSMI_COMPUTE_PARTITION_MEM_ALLOC_ALL`).
  - Reads/writes sysfs: `/sys/class/drm/cardN/device/compute_partition_mem_alloc_mode`.

- `AMDSMI_LINK_TYPE_NUMA` and `AMDSMI_LINK_TYPE_XNUMA` to `amdsmi_link_type_t`.
  - Represent NIC-to-GPU links that cross different PCIe switches on the same CPU (NUMA) or across CPUs (XNUMA).

- PID-grouped process listing across GPUs.
  - `amd-smi process --sort-by-pid` and `amd-smi monitor --sort-by-pid` group output by PID, merging each PID's per-GPU usage into one row.
  - New C and Python API `amdsmi_get_gpu_process_list_by_pid()`.

##### Changed

- Normalized JSON/CSV key casing in `amd-smi metric` clock and temperature sections.
  - The `uclk_aid`, `socclks_mid`, and temperature `xcd` keys are now lowercase (`aid_<N>`, `mid_<N>`, `xcp_<N>`) in JSON and CSV output, matching the existing `xcp_<N>` usage keys; they were previously uppercase (`AID_<N>`, `MID_<N>`, `XCP_<N>`).
  - Human-readable output is unchanged, since it uppercases all keys.

- Normalized JSON/CSV key casing in the `amd-smi topology` NIC-GPU access table.
  - The per-GPU columns are now lowercase (`gpu_<N>` for the BDF header row, `gpu_<N>_topo` for each NIC's status row) in JSON and CSV output, matching the existing `gpu_<N>` keys in the GPU-to-GPU access matrix; they were previously uppercase (`GPU<N>`, `GPU<N>_Topo`).
  - Human-readable output is unchanged, since it uppercases all keys.

- Renamed "AINIC version" to "ionic version" in `amd-smi version` output.
  - The label now correctly reflects that it shows the ionic kernel driver version.

##### Removed

- Removed the non-functional `--decode` flag from `amd-smi ras`. Out-of-band CPER decoding is available via `amd-smi ras --afid --cper-file <path>` or `--afid --folder <DIR>`.

- Removed the unused `amdsmi_nic_link_type_t` enum from the public header. No API or struct referenced it; NIC link types are reported through `amdsmi_link_type_t`, which gains `AMDSMI_LINK_TYPE_NUMA` and `AMDSMI_LINK_TYPE_XNUMA` in this release.

##### Optimized

- Improved Python test runner behavior:
  - Added `-l`/`--list` flag to list all available tests and exit without running them.
  - Added shadow detection: if `amdsmi` loads from a path other than the resolved expected path (`AMDSMI_PATH`, `ROCM_HOME`, `ROCM_PATH`, or `/opt/rocm` default), tests exit early with a clear error message and remediation steps.
  - Non-root invocations now exit with code 1 immediately with a clear message instead of failing mid-test.

##### Resolved Issues

- `amd-smi set --power-cap` rejecting the minimum allowed value.
  - The lower bound is now inclusive, so setting the power cap to the exact minimum of the reported range (for example, `210` when the range is 210-300W) succeeds instead of failing validation, matching the inclusive range shown in the error message.

- Corrected invalid AMD SMI status-code names in exception messages and documentation.
  - Some `AmdSmiLibraryException` messages and API documentation entries were misspelled; they now use the correct `AMDSMI_STATUS_*` names.

- A crash in `amdsmi_get_gpu_vram_vendor()` and made `amdsmi_get_gpu_vram_info()` resilient to DRM failures.
  - `amdsmi_get_gpu_vram_vendor()` now validates the output buffer and only writes it on success, fixing a null-pointer dereference on the not-supported path.
  - `amdsmi_get_gpu_vram_info()` now reads the VRAM vendor from sysfs first and treats the DRM ioctl (VRAM type/bit width/bandwidth) as best effort, so the vendor is still returned when the DRM path is unavailable.

- AMD GPU manufacturer name display in `amd-smi static --board`.
  - The CLI now displays the canonical vendor name `Advanced Micro Devices, Inc. [AMD/ATI]` when the board manufacturer name is reported as the raw AMD PCI vendor ID (`0x1002`) because the host `pci.ids` lookup is unavailable. The C and Python APIs continue to return the raw value unchanged.
  - Standardized the hardcoded AMD vendor string on the canonical `pci.ids` spelling (with the comma) so `VENDOR_NAME` and `MANUFACTURER_NAME` are consistent with `lspci`.

- `amd-smi ras --cper` / `amdsmi_get_gpu_cper_entries()` crash (`free(): invalid pointer` / `SIGABRT`) when `libamd_smi.so` is `LD_PRELOAD`-ed under a host with a different libstdc++ (for example, device-metrics-exporter / `gpuagent`).

- `amd-smi ras --cper` failing with `AMDSMI_STATUS_FILE_ERROR` on an empty CPER ring. An empty ring (no RAS records) now reports no CPER records; `amdsmi_get_gpu_cper_entries()` returns `AMDSMI_STATUS_SUCCESS` with `entry_count == 0`.

- `amdsmi_init()` aborting entirely when CPU/ESMI initialization fails.
  - `populate_amd_cpus()` treated an `esmi_init()` failure (non-AMD CPU, missing/unsupported energy or HSMP driver, or a CPU/SMU in a bad state) as fatal, causing all of `amdsmi_init()` to fail so GPU and NIC functionality became unusable. ESMI/CPU discovery is now non-fatal and is skipped on failure, mirroring the NIC discovery paths.
  - Removed an incorrect `static_cast<amdsmi_status_t>(esmi_init())` that conflated the unrelated `esmi_status_t` and `amdsmi_status_t` enums.
  - Added checks for the previously ignored return values of `get_nr_cpu_sockets()`, `get_nr_cpu_cores()`, and `get_nr_threads_per_core()`, plus a guard against a divide-by-zero when a misbehaving driver reports zero sockets or threads.

- `amd-smi static` hanging indefinitely on gfx1153 and gfx950.
  - Added a 60-second timeout to `amdsmi_init()` in the CLI so the process exits with a clear error message instead of hanging when the GPU driver is unresponsive.
  - Added `O_NONBLOCK` to DRM device open during initialization so `open()` returns immediately if the device is wedged.

- `amd-smi ras --afid --cper-file <file>` not showing AFIDs for correctable errors.
  - `aca_decode_corrected_error` was receiving the count of `uint32_t` elements where `decode_afid` expected the count of `uint64_t` elements, causing `decode_error_info` to return `NULL` for all non-standard section types.

- `amd-smi ras --cper --json` producing invalid JSON.
  - Multi-GPU runs emitted a separate JSON array per GPU instead of a single unified array, and `--follow` mode printed an empty `[]` every iteration when no new entries existed. Both are now consolidated into a single JSON document.

- Exposed `amdsmi_get_afids_from_cper` in the Python package.
  - The CPER AFID API was implemented but missing from `py-interface/__init__.py`, making it unavailable to Python callers using `from amdsmi import ...`.

- Python unittest scripts now append a GTest-style summary after test output.
  - All `*_test.py` and `unit_tests.py` scripts print a colored `[PASSED]`/`[SKIPPED]`/`[FAILED]` block after the standard unittest output. Colors are automatically suppressed when output is not a TTY (for example, file redirection, CI log capture).

- Corrected the documented unit of `amdsmi_frequencies_t::frequency`.
  - The struct comment claimed frequencies were in MHz, but `amdsmi_get_clk_freq()` returns them in Hz. The comment now reads "List of frequencies in Hz".
  - Also removed the incorrect "in MHz" note from the `current` field, which is a frequency index, not a frequency value.
  - Updated the Python API reference to state the unit is Hz.

- Fabric telemetry APIs returning the wrong status on non-IFoE systems.
  - `amdsmi_alloc_fabric_telemetry()`, `amdsmi_get_fabric_telemetry_data()`, and `amdsmi_free_fabric_telemetry()` now return `AMDSMI_STATUS_NOT_SUPPORTED` on systems without fabric hardware, consistent with `amdsmi_get_gpu_fabric_info()`.

- `amd-smi static --clock` CSV and human-readable formatting to output frequency levels as strings instead of dictionary objects.

##### Upcoming changes

- `amdsmi_get_gpu_vram_vendor()` is deprecated in favor of `amdsmi_get_gpu_vram_info()` and will be removed in a future ROCm release. It now emits a `DeprecationWarning` from the Python interface and functions as a wrapper of `amdsmi_get_gpu_vram_info()`.

- See {ref}`AMD SMI deprecations <amd-smi-deprecations>`.

#### **HIP** (7.14)

##### Added

- New HIP APIs:
  - Execution Context Management: Support for the following APIs for parity with corresponding CUDA APIs:
    - `hipDeviceGetDevResource` returns the device resource of a given type for a device.
    - `hipDevSmResourceSplitByCount` splits SM resources into groups with at least a minimum SM count.
    - `hipDevSmResourceSplit` splits SM resources into groups with configurable per-group parameters.
    - `hipDevResourceGenerateDesc` generates a resource descriptor from one or more device resources.
    - `hipGreenCtxCreate` creates a green context from a resource descriptor.
    - `hipExecutionCtxDestroy` destroys an execution context.
    - `hipDeviceGetExecutionCtx` returns the default execution context for a device.
    - `hipExecutionCtxStreamCreate` creates a stream on an execution context with specified flags and priority.
    - `hipExecutionCtxGetDevResource` returns the device resource of a given type for an execution context.
    - `hipExecutionCtxGetDevice` returns the device associated with an execution context.
    - `hipExecutionCtxGetId` returns a unique identifier for an execution context.
    - `hipStreamGetDevResource` returns the device resource of a given type for a stream.
    - `hipExecutionCtxRecordEvent` records an event on an execution context.
    - `hipExecutionCtxSynchronize` blocks until all work on an execution context has completed.
    - `hipExecutionCtxWaitEvent` makes an execution context wait on an event.
  - Module Management: Support for the following APIs for parity with corresponding CUDA APIs:
    - `hipLibraryGetGlobal` returns the device pointer and size of a `__device__` global defined in a `hipLibrary_t`. Mirrors `cudaLibraryGetGlobal` / `cuLibraryGetGlobal`.
    - `hipLibraryGetManaged` returns the host pointer and size of a `__managed__` variable defined in a `hipLibrary_t`. Mirrors `cudaLibraryGetManaged` / `cuLibraryGetManaged`.
  - Memory Management: Support for the following APIs for parity with corresponding CUDA APIs:
    - `hipMemDiscardBatchAsync` discards a batch of memory ranges asynchronously, allowing the runtime to reclaim resources. Mirrors `cudaMemDiscardBatchAsync`.
    - `hipDrvMemDiscardBatchAsync` driver API variant of `hipMemDiscardBatchAsync`, using `hipDeviceptr_t` pointers. Mirrors `cuMemDiscardBatchAsync`.
    - `hipMemDiscardAndPrefetchBatchAsync` combines discard and prefetch in a single call, enabling the runtime to optimize data movement. Mirrors `cudaMemDiscardAndPrefetchBatchAsync`.
    - `hipDrvMemDiscardAndPrefetchBatchAsync` driver API variant of `hipMemDiscardAndPrefetchBatchAsync`, using `hipDeviceptr_t` pointers. Mirrors `cuMemDiscardAndPrefetchBatchAsync`.

- Support for non-Host Transparent (nHT) fabric handles in HIP Virtual Memory Management (VMM) APIs, enabling efficient cross-device memory sharing over IFoE (Infinity Fabric over Ethernet). This allows peer devices to directly access shared memory without host staging, reducing data movement overhead and improving performance for multi-GPU and distributed workloads.
- Introduced an exported no-op function `__hipOnError(void *err_info)`, invoked from `HIP_UPDATE_ERROR_STATE` when an API returns a non-success status, enabling debuggers to set breakpoints on a stable symbol. The symbol is exported on ELF (Executable and Linkable Format) platforms via a version script and on Windows via `amdhip.def`. The `err_info` parameter is a pointer to a struct containing the error code, name, and descriptive string.

##### Optimized

- Enhanced HIP graph replay performance for asynchronous memory allocations. HIP graph replay now reduces overhead for graphs that interleave asynchronous memory allocations with compute. Allocation nodes no longer block during replay — physical memory is reused across nodes instead of being mapped and unmapped on each launch, eliminating the gaps between kernels this pattern previously caused.
- Enhanced debug information for illegal memory access errors. In multi-node and multi-GPU environments, it can be difficult to identify the source of a fault. The HIP runtime now includes the hostname, GPU index, and kernel name in GPU fault error messages, improving issue identification and debugging.

##### Resolved issues

- Resolved an issue where graph allocations that escape their originating graph (that is, allocation nodes without a corresponding free node) failed to remain valid after the graph and its executable
  instance were destroyed. Allocations created via stream capture were not properly tracked and were incorrectly classified as reusable, leading to premature unmapping during `hipGraphExecDestroy` and resulting in memory faults on subsequent access.
- Resolved an issue where an error propagated from the `hipModuleGetFunction` API, causing behavior inconsistent with the corresponding CUDA API. The HIP runtime now suppresses this propagated error to align with expected behavior.
- Resolved an issue where a stream entering an invalid state during capture could not recover, even after calling `hipStreamEndCapture`. The stream failed to return to a clean (None) state,
  and subsequent calls to `hipStreamIsCapturing` continued to report an invalidated state, preventing reuse. This behavior is now aligned with CUDA semantics.
- Resolved a race condition in HIP graph nodes. The HIP runtime now correctly manages graph node IDs within each `GraphNode` constructor to ensure thread safety.
  This prevents duplicate ID assignment when multiple threads concurrently construct graph nodes (for example, during XLA command-buffer fusion).
  As a result, nodes are no longer silently dropped from dispatched packets, eliminating uninitialized output buffers and preventing out-of-bounds or corrupted values.
- Segmentation fault in the `hipMemRetainAllocationHandle` API when a pointer allocated with `hipMalloc` was passed. The HIP runtime now validates non-VMM allocations and returns an appropriate error instead.
- Resolved an issue where `__managed__` global variables were misclassified by the `hipPointerGetAttributes` API both before and after kernel access. This behavior has been corrected to align with CUDA semantics.
- Resolved an issue in the classic graph execution path (RunOneNode and RunNodes) where missing synchronization for child graph nodes caused data races and incorrect results when executing graphs with child nodes under multi-stream parallelism.
  The HIP runtime now properly synchronizes child graph nodes within the execution path.
- Issue in `hipGraphMemsetNode` that caused incorrect validation for flat allocations. For 2D `memsets`, the `userData` `width/height/depth` extents are only initialized by `hipMallocPitch` and `hipMalloc3D`;
  allocations from `hipMalloc` leave these fields unset, leading to spurious validation failures. The HIP runtime now skips `userData`-based checks when extents are zero and relies on `ihipMemset3D_validate`
  for accurate size validation. Additionally, the exec flag is propagated through `ihipGraphNodeSetParams` to ensure executable graph updates use the correct validation path.
- Deadlock caused by `hipMemMap` and `hipMemUnmap` operations on the null stream that could lead to hangs. The HIP runtime now implements proper synchronization to all devices with access to a mapped pointer before unmapping it.
- Resolved an issue where streams created within an execution context remained usable after the context was destroyed, which did not align with CUDA behavior. The HIP runtime now flags such streams as detached when their execution context is destroyed and returns `hipErrorStreamDetached` if they are subsequently used.

##### Known issues

- Kernels using `cooperative_groups::reduce()` with block dimensions whose .y or .z component is different from 1 may produce incorrect results or fail to launch.

#### **hipBLAS** (3.5.0)

##### Added

- The following APIs have been added:
  - `hipblasSetBatchAlphaStride()`
  - `hipblasGetBatchAlphaStride()`
  - `hipblasSetBatchBetaStride()`
  - `hipblasGetBatchBetaStride()`
  - `hipblasGetVersion()`
  - `hipblasGetProperty()`

##### Resolved issues

- Guarded x86-specific code and compiler options.

#### **hipBLASLt** (1.4.1)

##### Added

- Introduced a new API: `hipBLASLt-ext::isSolutionSupported()`. This API is used by the new hipBLASLt integration from rocBLAS to check if a given solution is supported for a specific GPU and problem type.

#### **hipCUB** (4.5.0)

##### Added

- Support for the gfx1250 architecture.

##### Upcoming changes

- CCCL 2.8.x compatibility is deprecated. hipCUB and rocThrust will be brought forward to CCCL 3.0.x compatibility in an upcoming release.

#### **hipFFT** (1.0.24)

##### Added

- Support for the gfx1250 architecture.

#### **hipRAND** (3.4.0)

##### Added

- Support for the gfx1250 architecture.

#### **hipSOLVER** (3.5.0)

##### Changed

- Minor internal changes.

#### **hipSPARSE** (4.6.0)

##### Added

- `hipsparseCreateBsr` and `hipsparseCreateConstBsr` to enable BSR format support in generic routines.
- BSR format support to `hipsparseSpMV` and `hipsparseSpMM`.

##### Resolved issues

- Issue where calling `hipsparseSpMV` multiple times with different `hipsparseOperation_t`, `hipsparseSpMVAlg_t`, or compute-datatypes using the same sparse matrix descriptor resulted in errors.

##### Upcoming changes

- The routines `hipsparseXcsrgeamNnz`, `hipsparseScsrgeam`, `hipsparseDcsrgeam`, `hipsparseCcsrgeam`, and `hipsparseZcsrgeam` have been deprecated and will be removed in a future release. Use `hipsparseScsrgeam2_bufferSizeExt`, `hipsparseDcsrgeam2_bufferSizeExt`, `hipsparseCcsrgeam2_bufferSizeExt`, `hipsparseZcsrgeam2_bufferSizeExt`, `hipsparseXcsrgeam2Nnz`, `hipsparseScsrgeam2`, `hipsparseDcsrgeam2`, `hipsparseCcsrgeam2`, and `hipsparseZcsrgeam2` instead.

#### **hipSPARSELt** (0.2.9)

##### Added

- Support for the following data type combinations for the LLVM target gfx942:
  - FP8_FNUZ(E4M3_FNUZ) inputs, F32 output, and F32 Matrix Core accumulation.
  - BF8_FNUZ(E5M2_FNUZ) inputs, F32 output, and F32 Matrix Core accumulation.

#### **MIOpen** (3.5.2)

##### Changed

- [Conv] Naive convolution solvers are now skipped by default during find when any non-naive solver succeeds across any algorithm. Set `MIOPEN_NAIVE_DISABLE_IF_ALT=0` to restore the previous behavior.

##### Resolved Issues

- [RNN] RNN workspace tensor descriptor integer overflow.
- [Conv] Enabled grouped Composable Kernel (CK) xdlops fwd, bwd, and wrw convolution (2D and 3D) for tensors whose strides exceed the int32 range.
- [Conv] `miopenStatusInternalError` thrown by Find on depthwise NHWC grouped convolutions under `MIOPEN_FIND_MODE=NORMAL`.

#### **RCCL** (2.30.4)

##### Added

- Compatibility with NCCL 2.30.4, NCCL 2.29.7, and NCCL 2.28.9
- Proxytrace profiler plugin and core proxy-diagnostics hooks (`RCCL_PROXYTRACE`).
- `ncclBarrierSession` LSA validation for barrier sessions.
- Symmetric-memory ReduceScatter kernel (`RailA2A_LsaLD`) on gfx942/gfx950.
- Bias (accumulation) `AllReduce` on gfx1250.
- Optimized scale-up `ReduceScatter`, `AllGather`, and `AllToAll` kernels.
- ROCprofiler-SDK coverage for `ncclCommGrow` and `ncclCommGetUniqueId`.
- Auto-enabled P2P batching for gfx950 in combination with non-AINIC NICs.
- Display HIP/ROCm runtime versions in `NCCL_DEBUG` output.
- Detect ROCm version via core symlink for multi-architecture installs.
- Skip DDA IPC initialization for directMode and MNNVL topologies.
- Load versioned `libamd_smi` SONAME instead of an unversioned symlink.
- Pythonic API bindings under `bindings/nccl4py/` (RCCL fork of NVIDIA `nccl4py` v0.2.0). Provides Python access to RCCL collectives via Cython bindings, an on-disk `cuda.core` HIP shim for ROCm hosts without `cuda-bindings` / `cuda-core`, and RCCL-only collective wrappers (`ncclAllReduceWithBias`, `ncclAllToAllv`).
- RCCL examples to the repository.
- `RCCL host API` pull-in from NCCL 2.30.

##### Changed

- Enabled WarpSpeed auto mode for grow communicators.
- Refactored AllGather algorithm selection; hierarchical AllGather now enabled by default for multi-node.
- Swapped legacy `net_ib` with the `net_ib` implementation from NCCL 2.29.
- Skip per-warp channel LDS copy when `warpComm` is disabled.
- Hardened proxy RPC setup against malformed peer input.
- Changed the bootstrap AllGather to use the bidirectional ring (N/2 steps) by default on the socket OOB path. `NCCL_BOOTSTRAP_BIDIR_ALLGATHER` now defaults to `1`; set it to `0` to fall back to the unidirectional ring. The net OOB path (`NCCL_OOB_NET_ENABLE`) and its bidirectional variant (`NCCL_BOOTSTRAP_BIDIR_NET`) remain off by default.
- `NCCL_PXN_C2C` is kept default-off (`0`); upstream NCCL defaults it to `1` since 2.28. The C2C PXN routing path is currently not applicable on AMD hardware.

##### Removed

- Removed NPKit profiling support (build option ``ENABLE_NPKIT``, headers, device and proxy instrumentation, install script flag ``--npkit-enable``, and related documentation and tooling). Use the profiler plugin API for profiling instead.
- Removed Kernel COLLTRACE support, including the `COLLTRACE` build option, device-side collective trace buffers, debug kernel variants, and related install/CI wiring. The host latency profiler is unchanged.
- Removed legacy `ENABLE_PROFILING` device profiling support and the `PROFILE` build option. Use the profiler plugin API instead.

##### Optimized

- Tuned symmetric memory kernels.
- Parallelized communicator destruction across child processes to reduce teardown latency.

##### Resolved issues

- `ncclCommGrow` channel-count divergence causing incorrect collective routing.
- A `ncclCommGrow` hang when growing to an 8-rank single-node communicator.
- Symmetric LDS under-reservation in legacy (non-device-linker) builds.
- LL128 protocol correctness for gfx1250.
- XGMI topology mapping for multi-system (NPS) nodes.
- gfx950 collective hang caused by a tuner race condition.
- `net_ib_cast`: gate CTS offload path on per-connection state.
- `net_ib`: avoid flagging a non-fatal Isend CTS no-match as a fatal error.
- Acquire-tail polling for gfx950 P2P host staging.
- LDS overflow in device-linker builds.
- Symmetric memory correctness issues.
- `ncclCommFree` to free symmetric window objects automatically (NCCL 2.29.7 defect).
- DDA IPC initialization skip on architectures that do not run DDA.
- Static build (`BUILD_SHARED_LIBS=OFF`) failing with `install(EXPORT "rccl-targets" ...)` error when `fmt` is fetched via `FetchContent`. The `fmt-header-only` target is now scoped to the build interface and excluded from RCCL's exported usage requirements.
- Proxy channel staging buffers ignoring the new GDR mode selection on HIP < 7.12 builds. The legacy `#else` branch in `sendProxyConnect` / `recvProxyConnect` now honors `resources->useDmaBuf`, so peermem-equipped hosts on older HIP no longer fall through to `hsa_amd_portable_export_dmabuf` when peermem was selected in `*ProxySetup`. Workaround for affected RCCL builds: `NCCL_DMABUF_ENABLE=0`.
- RCCL initialization failing (`Failed to find ROCm runtime library`) on runtime-only ROCm trees that ship no unversioned `libhsa-runtime64.so` developer symlink (e.g. TheRock multi-arch pip-wheel `/opt/rocm-less` deployments). RCCL no longer `dlopen`s the HSA runtime by name; instead it directly links `hsa-runtime64::hsa-runtime64` (already a hard transitive dependency via the HIP runtime) and binds `hsa_init`, `hsa_system_get_info`, `hsa_status_string`, and `hsa_amd_portable_export_dmabuf` to those symbols. The linker records `DT_NEEDED libhsa-runtime64.so.1` and resolves it through librccl's existing RPATH, removing the SONAME version-string fragility and load-scope (`RTLD_LOCAL`) issues. The `RCCL_ROCR_PATH` override is no longer needed and has been removed.

##### Known issues

- Elastic-buffer support for GIN (multi-segment symmetric memory windows backed by a mix of device and CPU/`HOST_NUMA` memory, exposed through `NCCL_ELASTIC_BUFFER_REGISTER` and `NCCL_SYM_REUSE_SYSMEM_HANDLES`) was newly synced from upstream and compiles on ROCm, but is unverified on AMD hardware.

#### **RDC** (1.3.1)

##### Added

- 59 new telemetry fields to close the gap with Device Metrics Exporter (DME).
  - Energy: `RDC_FI_GPU_ENERGY` — total energy consumed via `amdsmi_get_energy_count()`.
  - Temperature: `RDC_FI_GPU_JUNCTION_TEMP` — dedicated junction/hotspot temperature field.
  - Clock ranges: `RDC_FI_GPU_CLOCK_MIN`, `RDC_FI_GPU_CLOCK_MAX` — min/max GPU clock frequencies. Additional clock types: `RDC_FI_SOC_CLOCK`, `RDC_FI_VCLK0`, `RDC_FI_DCLK0`.
  - Memory: `RDC_FI_GPU_MEMORY_FREE` (free VRAM), visible VRAM (`RDC_FI_GPU_VIS_VRAM_TOTAL/USED/FREE`), GTT memory (`RDC_FI_GPU_GTT_TOTAL/USED/FREE`).
  - PCIe: `RDC_FI_PCIE_SPEED`, `RDC_FI_PCIE_MAX_SPEED`, `RDC_FI_PCIE_REPLAY_ROLLOVER`, `RDC_FI_PCIE_BANDWIDTH_BIDIR` with sentinel value handling for APU platforms.
  - Instantaneous activity: `RDC_FI_GPU_GFX_BUSY_INST`, `RDC_FI_GPU_VCN_BUSY_INST`, `RDC_FI_GPU_JPEG_BUSY_INST` from `gpu_metrics.xcp_stats`.
  - ECC deferred errors: 19 per-block deferred error fields (`RDC_FI_ECC_*_DE`) plus `RDC_FI_ECC_DEFERRED_TOTAL`, reading `deferred_count` from `amdsmi_error_count_t`.
  - Violation/throttle metrics: 19 new `RDC_HEALTH_*` fields covering accumulated counts and percentages for processor hot, PPT power, socket/VR/HBM thermal, gfx clock host limits, and low utilization violations via `amdsmi_get_violation_status()`. Driver 1.8 XCP/XCC fields return NOT_SUPPORTED on older platforms.

- An automated DME-RDC metric sync check.
  - New script `tools/dme_rdc_metric_sync_check.py` parses DME's protobuf metric definitions and compares against RDC field enums via a curated mapping file (`tools/dme_rdc_metric_mapping.json`).
  - New GitHub Action (`.github/workflows/rdc-dme-sync-check.yml`) runs weekly and on PRs touching metric definitions. Automatically creates GitHub issues when DME adds metrics not yet tracked in RDC.

##### Changed

- Bumped gRPC from 1.67.1 to 1.78.1. See [ROCm/TheRock#4172](https://github.com/ROCm/TheRock/pull/4172).

##### Removed

- Removed RVS integration. [RVS](https://github.com/ROCm/ROCmValidationSuite) is built independently of RDC and TheRock, so its integration has been disabled.
  - `BUILD_RVS` now defaults to `OFF` (#7116).

##### Resolved Issues

- The `Failed to insert module: N3amd3rdc10RdcRVSLibE` error.

#### **rocBLAS** (5.5.0)

##### Added

- Per-batch `alpha`/`beta` support for Level 2 batched and strided-batched `gemv` via `rocblas_set_batch_alpha_stride` and `rocblas_set_batch_beta_stride` (device pointer mode).
- Per-batch `alpha` support for Level 2 batched and strided-batched `ger`, `geru`, and `gerc` via `rocblas_set_batch_alpha_stride` (device pointer mode).
- Per-batch `alpha` (scalar vector) API support for `axpy_batched`, `axpy_strided_batched`, and their `_ex` forms through `rocblas_set_batch_alpha_stride` when `rocblas_handle` is in `rocblas_pointer_mode_device`.
- Support custom build with CMake arguments `GPU_TARGET=amdgcnspirv` when using `BUILD_WITH_TENSILE=OFF`.

##### Resolved issues

- Incorrect results on gfx12 in `trsv`, `asum`, and `nrm2` with large `batch_count` exceeding 65536.
- `gemm` with very large `K` or inner product leading dimension for which element byte offset overflowed `int32`.
- `install.sh/rmake.py` builds when `CMAKE_GENERATOR=Ninja` is set.

#### **rocFFT** (1.0.38)

##### Added

- Generalized multi-device computations for transforms such that each length dimension is fully covered either in all the input field's bricks or in all the output field's bricks, regardless of the type and placement of the transform. Specifically for real transforms, the innermost length dimension must be fully covered in all the input (respectively, output) field's bricks for real forward (respectively, inverse) transforms.
- Support for the gfx1250 architecture.

##### Optimized

- Improved performance of even-length real transforms with real lengths between 512 and 8192, extending to larger lengths (up to around 32768) on devices with more LDS.

##### Changed

- Modified the `rocfft_plan_get_work_buffer_size` and `rocfft_execution_info_set_work_buffer` functions to get and set work memory for the current HIP device.
  - Multi-device transforms can require work memory on any of the devices used for input or output bricks, and the current device set at plan creation. Users should loop over the set of devices used by the input/output of the transform and check the work memory requirements for each device.

##### Resolved issues

- Possible incorrect results for multi-dimensional real transforms with small lengths (for example, smaller than 128) along the two fastest-varying dimensions.

#### **ROCgdb** (16.3)

##### Added

- Improved core dumping speed for AMD GPU programs with the `gcore` command,
  particularly for kernels that use small amounts of VRAM.
- A new `catch hiperr` command that stops the inferior when a HIP API
  call returns an error. The convenience variable `$_hiperr` holds
  the error code at the catchpoint.

#### **rocJPEG** (1.6.0)

##### Added

- A logging mechanism for core APIs that can be controlled by setting the `ROCJPEG_LOG_LEVEL` environment variable.

#### **ROCm Compute Profiler** (3.7.0)

##### Added

- `--bench-only` profile mode option to run the roofline microbenchmark standalone (without profiling an application or collecting performance counters). No application run is required. Useful for regenerating `roofline.csv` in an existing workload directory or running the microbenchmark on systems where only HIP is available but ROCprofiler-SDK is not.

- LDS arithmetic intensity as a roofline plot point and analysis database field.

- Backward compatibility for live attach mode to work with older ROCm 7.x.x releases.

- Support for GPU metrics on gfx1150 and gfx1152 hardware.

- Roofline benchmarking support for gfx1150 and gfx1152 hardware.

- Operator statistics and per-operator summary table in the analysis output of torch operator profiling, including the following statistics for every torch operator and its children:
  - Number of invocations.
  - Number of kernel dispatches.
  - Min/Max/Mean and Total duration of kernel dispatches.

##### Changed

- Moved `--gui` and `--tui` analyze options to experimental status. These features now require the `--experimental` flag to be enabled (for example, `rocprof-compute analyze --experimental --gui`).

- `--output-format csv` in analyze mode now uses the database analysis workflow and produces one CSV per analysis view. Requires `--format-rocprof-output rocpd` and no longer prints the report to the terminal (matching `db` format).

- Changed ratio metric aggregation from `AVG(A/B)` (arithmetic mean of per-dispatch ratios) to `SUM(A)/SUM(B)` (ratio of totals) across all analysis YAML configurations and all GPU architectures. `SUM(A)/SUM(B)` is a weighted average where each dispatch contributes proportionally to its denominator magnitude (duration, access count, cycle count). Single-dispatch workloads are unaffected (mathematically identical). Multi-dispatch workloads with different kernels or varying durations will see corrected values.

- `--torch-trace` now captures backward-pass and nested operators that were previously missed or misattributed. The first run builds and caches a helper under `~/.cache/rocprofiler-compute/`, so it takes longer than later runs.

- Profile workload output folder name for Strix Halo series (gfx1151) changed from `strix_halo` to `rdna35_halo`.

- Unified accumulator handling across profile and analyze so each `_ACCUM`-suffixed counter is preserved instead of collapsing to `SQ_ACCUM_PREV_HIRES`.

- Reworded the N/A metric-evaluation warning to "divide-by-zero or empty counter data" (the prior "missing counter data" message could only fire for non-missing causes).

- PC sampling in profile mode now opts in via the `--experimental --pc-sampling` option. Explicit `-b 21` / `--block 21` is no longer accepted on its own.

- PC sampling profiling now emits only `ps_file_results.json`. The per-sample, kernel-trace, and agent-info CSV artifacts are no longer produced or consumed by analysis.

- PC sampling analysis without `-k` now shows the full per-instruction table across all kernels (with a `Kernel_Name` column), identical in schema to the single-kernel view, instead of a collapsed source-line summary.

- `--pc-sampling-interval` now defaults to a method-appropriate value (512 microseconds for `host_trap`, 1048576 cycles for `stochastic`). Stochastic intervals are validated to be a power of 2 and at least 65536; previously invalid values were passed through silently.

##### Removed

- `--path` and `--subpath` options have been removed from profile mode. Use `--output-directory` instead.

- Removed redundant `if (X != 0) else None` divide-by-zero guards from metric equations across all analysis YAML configurations. Division by zero is already handled by the metric evaluation engine, which returns `"N/A"` for `inf` and `NaN` results.

##### Optimized

- Flattened the analyze-mode PMC dataframe to a single-index frame.

- Eliminated "missing counter" warnings during analyze when profile-mode `-b` was used. Analyze now skips metrics outside the selected blocks.

##### Resolved issues

- Roofline panel L1/L2 bandwidth and arithmetic intensity on gfx942 and gfx950 now use the correct 128B cache line, matching the values reported in the Speed-of-Light and vL1D/L2 cache panels for the same run. Bandwidth values on these architectures are 2x and AI values are 0.5x compared to prior releases.

- "ROCPROF_OUTPUT_PATH environment variable must be set" crash that aborted profiling when `ROCPROF_OUTPUT_PATH` was unset or empty (observed when profiling shell-script targets such as `rocprof-compute profile -o /tmp/out -- bash run.sh`). The collector now silently falls back to a documented default instead of aborting.

- `inf` display for metrics with zero-denominator counters (e.g., L2-Fabric Write Latency when no write requests are issued). The metric evaluation path now catches `inf` scalar results and returns `"N/A"`, consistent with existing `NaN` handling.

- Kernels with missing counter data after iteration multiplexing imputation are now excluded from metrics calculations. A warning at analysis time lists the affected kernels. Their execution times remain visible in Top Stats.

- Empirical roofline benchmark to correctly produce double the Matrix BF16 Gflop/s on gfx90a (AMD Instinct MI200 Series) GPUs.

- PC sampling collection now runs when requested via the `pc_sampling` block alias (`--block pc_sampling`), instead of being silently skipped.

##### Upcoming changes

- Roofline support for RDNA3.5 gfx115x devices.

##### Known issues

- On gfx1151, `TCP_REQ_sum` is zero in single-pass counter collection, so the related `GL0` metrics always reports zero. This will be fixed in a future release.

- On gfx1151, `$max_mclk` is not automatically populated in sysinfo, so the related bandwidth metrics may be incorrect. Use `amd-smi` to obtain the maximum memory clock and provide it via `--specs-correction`.

- In analyze mode, `--nodes` is not suitable for multi-rank analysis. Use `--path` with the rank-specific path (for example, `--path workload/1`) instead of `--path workload --nodes 1`.

#### **ROCm Systems Profiler** (1.7.0)

##### Added

- `--output-format` flag for `rocprof-sys-run` and `rocprof-sys-sample` to select
  output format(s) in a single, intuitive option: `proto` (Perfetto), `rocpd`
  (RocPD database), and `json` / `text` (Timemory profile; `txt` aliases `text`).
  Tokens are space- or comma-separated and authoritative — only the listed
  formats are produced. The existing `--trace`, `--profile`, `--flat-profile`,
  and `--profile-format` flags and their environment variables remain available,
  but cannot be combined with `--output-format` on the same command line.

- Unified-memory profiling reports (`unified_memory.txt` and
  `unified_memory.json`) summarizing KFD page fault and page migration events,
  including per-GPU counts, trigger breakdown (`gpu_page_fault`,
  `cpu_page_fault`, `prefetch`), and Host-to-Device/Device-to-Host migration
  bandwidth. Enable with `ROCPROFSYS_USE_UNIFIED_MEMORY_PROFILING=ON`; requires
  `HSA_XNACK=1` on an XNACK-capable AMD GPU and ROCm 7.13 or later. For standalone ROCprofiler-SDK installations, ROCprofiler-SDK 1.2.2 or later. The required KFD tracing domains are enabled automatically.

- Dedicated `ROCPROFSYS_UNIFIED_MEMORY_OUTPUT_PATH` setting for routing
  unified-memory profiling reports to an explicit output directory.

- MPI-rank-based console output filtering features controlled with CLI arguments:
  `--rank-filter-logs` and `--rank-filter-id`.

- GPU Hardware Performance Counter (PMC) sampling via the ROCprofiler-SDK device
  counting service. Periodic per-GPU hardware counters are collected alongside
  existing PMC sources and exposed in both Perfetto and RocPD outputs. Specify
  counters with `ROCPROFSYS_GPU_PERF_COUNTERS` (comma-separated; suffix
  `:device=N` to target a specific GPU). Requires ROCprofiler-SDK 0.6.0 or
  later (ROCm 6.4.0+).

- GPU graphics and memory clock frequency metrics (`gfx_clock`, `mem_clock`) via
  AMD SMI, exposing `current_gfxclk` and `current_uclk` in MHz as PMC samples.
  Configure via `ROCPROFSYS_AMD_SMI_METRICS=gfx_clock,mem_clock`.
- Progress bars during trace cache post-processing: perfetto generation
  (`sequential dispatch`) shows one bar per buffered_storage file in turn; rocpd
  generation (`multithreaded dispatch`) shows a single aggregate bar accumulating
  updates from all worker threads.
- Per-stream Perfetto tracks (`HIP Activity Stream {N}`) for kernel dispatch,
  scratch memory, and memory copy events in the trace-cache path, matching the
  buffered tracing behavior. Controlled via `ROCPROFSYS_ROCM_GROUP_BY_QUEUE`
  (default: `false` — group by HIP stream).
- `--list-domains` and `--list-operations <domain>` to `rocprof-sys-avail`.
  These new options allow the user to query more information about available
  ROCm domains (used in `ROCPROFSYS_ROCM_DOMAINS`) and their operations.
- `rocprofsys_push_trace_with_args`, a public API for pushing a user trace region
  with a pre-serialized argument string attached. The arguments are recorded in cached
  tracing mode (the default); in legacy tracing (`ROCPROFSYS_TRACE_CACHED=OFF`) they are
  ignored.

##### Changed

- Split PMC AMD SMI, ROCprofiler-SDK, and procfs wrappers into standalone
  internal backend targets under `source/lib/backends`, replacing the old
  PMC `drivers` layout.
- Removed Boost as a Dyninst dependency by replacing Boost usage with in-tree
  `dyncompat` shims and C++17 standard library equivalents; Bundled Dyninst now
  requires GCC ≥ 10.
- The `trace-openmp` configuration preset no longer includes `HSA_API`,
  by default.
- `rocprof-sys-sample` — Aligned flags with `rocprof-sys-run`. Renamed `--freq`,
  `--cputime` and `--realtime` to `--sampling-freq`, `--sampling-cputime` and
  `--sampling-realtime`, respectively. Old flags are still handled as a part of
  backward compatibility.
- Allowed presets to use `--gpus`/`--cpu`/`--ai-nics` flags without
  `--device`/`--host` flags.
- Minimum required C++ standard raised from C++17 to C++20. timemory now builds
  against the `rocprofiler-systems-cppstd20` branch and spdlog was bumped to
  v1.17.0 (bundled fmt v12).
- Supported environment variables for rank detection: removed `MPI_RANK` and
  `MPI_LOCALRANKID`, added `PMI_RANK` and `SLURM_PROCID`.

##### Resolved issues

- An issue affecting the ElfUtils build on GCC 15.
- Output directory of `rocpd` files was not unique when re-attaching to the same process
  with `rocprof-sys-attach`. Now, each session will have a unique output folder.
- CPU-related counters (like CPU frequency) were missing from `rocpd` output.
- The "group-by-queue" option was not handled correctly in the Perfetto generator.
- The visualization of GPU counters made it look like there was activity
  between kernel dispatches.
- A hang due to mismatched versions of `binutils` between system and bundled
  versions. Ensure that the vendored version of `binutils`'s symbols are hidden.
- The ASAN build on TheRock.
- An issue that could cause certain events to appear in trace, when they should
  have been excluded due to roctx region filtering.
- A CMake issue that caused the wrong version of `elfutils` to be linked when
  building for TheRock. The system version of `elfutils` was used, rather than
  the vendored version causing package install failures.
- Documentation and internal config handling that referenced the non-existent
  `ROCPROFSYS_USE_TRACE`. The Perfetto tracing backend is controlled by
  `ROCPROFSYS_TRACE`; setting `ROCPROFSYS_USE_TRACE` had no effect.
- A pre-main `rocprof-sys-run` `SIGSEGV` in `rocprofiler_configure()` when
  profiling OpenMPI GPU-aware MPI workloads.

##### Known issues

- A push/pop trace count imbalance can occur for workloads that instrument runtime
  internals such as OMPT. When pushes exceed pops, rocprof-sys completes
  finalization, emits a warning, and omits any still-open trace regions from the
  generated trace output.

#### **rocPRIM** (4.5.0)

##### Added

- `generate_resource_spec.cpp` to the test directory, built as a new target by CMake. It generates the resource spec file required by CTest when running tests in parallel.
- Support for the gfx1250 architecture.
- A parallel `device_topk`, which finds the largest/smallest K elements from an input array of keys.

##### Changed

- Updated the documentation on how to run rocPrim tests on multiple GPUs in parallel.

##### Removed

- Removed the `GenerateResourceSpec.cmake` script - it is replaced by the added `generate_resource_spec.cpp` code above.

#### **ROCprofiler-SDK** (1.3.2)

##### Added

**API:**

- Streaming Performance Monitor (SPM) counter collection support (beta):
  - New experimental API in `rocprofiler-sdk/experimental/spm.h`.
  - GPU-timestamped counter values alongside kernel dispatch information.
- `spm_support` along with reserved padding to `rocprofiler_counter_info_v1_t`.

**rocprofv3 (CLI):**

- SPM counter collection support in `rocprofv3` (beta):
  - `--spm <counter>` flag to specify counters for SPM collection.
  - `--spm-sample-interval` and `--spm-sample-interval-unit` parameters to configure sampling rate.
  - `--spm-beta-enabled` flag or the `ROCPROFILER_SPM_BETA_ENABLED` environment variable to opt in to the beta SPM feature via `rocprofv3`. For API-based usage, set `ROCPROFILER_SPM_BETA_ENABLED`.
  - `--spm-config` option in `rocprofv3-avail` to list available SPM configurations.
- JSON and rocpd output format support for SPM.

**Documentation:**

- [SPM API reference guide](https://rocm.docs.amd.com/projects/rocprofiler-sdk/en/docs-7.14.0/api-reference/spm.html).
- [SPM usage guide for rocprofv3](https://rocm.docs.amd.com/projects/rocprofiler-sdk/en/docs-7.14.0/how-to/using-spm.html).
- `--spm-config` documentation to [`rocprofv3-avail` usage guide](https://rocm.docs.amd.com/projects/rocprofiler-sdk/en/develop/how-to/using-rocprofv3-avail.html).

##### Changed

- Bumped rocpd schema to version 3.0.1 which supports NIC agent types.

#### **rocRAND** (4.5.0)

##### Added

- Support for the gfx1250 architecture.

#### **rocSHMEM** (3.5.0)

##### Added

- New APIs:
  - `rocshmem_align`
  - `rocshmem_calloc`
  - `rocshmem_buffer_unregister_all`
  - `rocshmem_buffer_register/unregister` for GDA backend
  - `rocshmem_reduce_on_stream`
  - `rocshmem_team_split_2D`
- Tile-granular RMA operations for the IPC backend.
- Host-initiated RMA operations in the IPC backend for the non-MPI bootstrapping path.
- Team creation using non-contiguous parent teams in the IPC backend.
- Python bindings for memory-management APIs.
- Python bindings coverage for team APIs.
- Support for GPU-initiated operations using the SDMA engines.
- ASAN build support.

##### Changed

- Changed default `ROCSHMEM_DEBUG_LEVEL` from `WARN` to `ERROR`.
- Performance optimizations:
  - Separated put/get memcpy primitives to apply correct cache coherence semantics and fences.
  - Use constmem for backend variables and provider muxing.
  - Updated O(1) IPC availability check using pattern detection.

#### **rocSOLVER** (3.35.0)

##### Added

- Support for the gfx1250 architecture.

##### Optimized

- Refined `potf2_run_small` dispatch by `BS2` to avoid over-generating specialized kernels while preserving runtime bounds checks on `nb`.

##### Resolved issues

- An out-of-bounds read in `bdsqr_lower2upper`.
- An invalid kernel launch in the small-matrix LU factorization (GETF2/GETRF) for large batch counts.
- A synchronization issue in GETRI and TRTRI on wave 32 architectures.

#### **rocSPARSE** (4.7.0)

##### Added

- `rocsparse_spildlt0` routine for incomplete LDL' factorization with zero fill-in (ILDLT(0)) for symmetric (real) or Hermitian (complex) sparse matrices in CSR format, with strided batched computations enabled.

##### Upcoming changes

- Deprecated the `rocsparse_indextype_u16` index type. It is no longer supported and will be removed in a future release. Use `rocsparse_indextype_i32` or `rocsparse_indextype_i64` instead.

#### **rocThrust** (4.5.0)

##### Added

- Support for the gfx1250 architecture.
- One-time runtime warning for hipstdpar algorithms running on GPUs that support xnack when `__HIPSTDPAR_INTERPOSE_ALLOC__` or `__HIPSTDPAR_INTERPOSE_ALLOC_V1__` are not enabled and xnack is off.

##### Upcoming changes

- CCCL 2.8.x compatibility is deprecated. hipCUB and rocThrust will be brought forward to CCCL 3.0.x compatibility in an upcoming version.

#### **rocWMMA** (2.2.1)

##### Added

- Support for the gfx1250 architecture.

