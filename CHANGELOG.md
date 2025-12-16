# ROCm consolidated changelog

This page is a historical overview of changes made to ROCm components. This
consolidated changelog documents key modifications and improvements across
different versions of the ROCm software stack and its components.

## ROCm 7.1.1

See the [ROCm 7.1.1 release notes](https://rocm.docs.amd.com/en/docs-7.1.1/about/release-notes.html#rocm-7-1-1-release-notes)
for a complete overview of this release.

### **AMD SMI** (26.2.0)

#### Added

- Caching for repeated ASIC information calls.  
  - The cache added to `amdsmi_get_gpu_asic_info` improves performance by avoiding redundant hardware queries.
  - The cache stores ASIC info for each GPU device with a configurable duration, defaulting to 10 seconds. Use the `AMDSMI_ASIC_INFO_CACHE_MS` environment variable for cache duration configuration for `amdsmi_get_gpu_asic_info` API calls.

- Support for GPU partition metrics.
  - Provides support for `xcp_metrics` v1.0 and extends support for v1.1 (dynamic metrics).
  - Added `amdsmi_get_gpu_partition_metrics_info`, which provides per XCP (partition) metrics.

- Support for displaying newer VRAM memory types in `amd-smi static --vram`.
  - The `amdsmi_get_gpu_vram_info()` API now supports detecting DDR5, LPDDR4, LPDDR5, and HBM3E memory types.

#### Changed

- Updated `amd-smi static --numa` socket affinity data structure. It now displays CPU affinity information in both hexadecimal bitmask format and expanded CPU core ranges, replacing the previous simplified socket enumeration approach.

#### Resolved issues

- Fixed incorrect topology weight calculations.  
  - Out-of-bound writes caused corruption in the weights field.

- Fixed `amd-smi event` not respecting the Linux timeout command.  

- Fixed an issue where `amdsmi_get_power_info` returned `AMDSMI_STATUS_API_FAILED`.  
  - VMs were incorrectly reporting `AMDSMI_STATUS_API_FAILED` when unable to get the power cap within the `amdsmi_get_power_info`.
  - The API now returns `N/A` or `UINT_MAX` for values that can't be retrieved, instead of failing.

- Fixed output for `amd-smi xgmi -l --json`.

```{note}
See the full [AMD SMI changelog](https://github.com/ROCm/amdsmi/blob/release/rocm-rel-7.1/CHANGELOG.md#amd_smi_lib-for-rocm-711) for details, examples, and in-depth descriptions.
```

### **Composable Kernel** (1.1.0)

#### Upcoming changes

* Composable Kernel will adopt C++20 features in an upcoming ROCm release, updating the minimum compiler requirement to C++20. Ensure that your development environment meets this requirement to facilitate a seamless transition.
  
### **HIP** (7.1.1)

#### Added

* Support for the flag `hipHostRegisterIoMemory` in `hipHostRegister`, used to register I/O memory with HIP runtime so the GPU can access it.

#### Resolved issues

* Incorrect Compute Unit (CU) mask in logging. HIP runtime now correctly sets the field width for the output print operation. When logging is enabled via the environment variable `AMD_LOG_LEVEL`, the runtime logs the accurate CU mask.
* A segmentation fault occurred when the dynamic queue management mechanism was enabled. HIP runtime now ensures GPU queues aren't `NULL` during marker submission, preventing crashes and improving robustness.
* An error encountered on HIP tear-down after device reset in certain applications due to accessing stale memory objects. HIP runtime now properly releases memory associated with host calls, ensuring reliable device resets.
* A race condition occurred in certain graph-related applications when pending asynchronous signal handlers referenced device memory that had already been released, leading to memory corruption. HIP runtime now uses a reference counting strategy to manage access to device objects in asynchronous event handlers, ensuring safe and reliable memory usage.

### **MIGraphX** (2.14.0)

#### Resolved issues

* Fixed an error that resulted when running `make check` on systems running on a gfx1201 GPU.

### **RCCL** (2.27.7)

#### Resolved issues

* Fixed a single-node data corruption issue in MSCCL on the AMD Instinct MI350X and MI355X GPUs for the LL protocol. This previously affected about two percent of the runs for single-node `AllReduce` with inputs smaller than 512 KiB.

### **rocBLAS** (5.1.1)

#### Changed
  * By default, rocBLAS will not use stream order allocation for its internal workspace. To enable this behavior, set the `ROCBLAS_STREAM_ORDER_ALLOC` environment variable.

### **ROCm Bandwidth Test** (2.6.0)

#### Resolved issues

- Test failure with error message `Cannot make canonical path`.
- Healthcheck test failure with seg fault on gfx942.
- Segmentation fault observed in `schmoo` and `one2all` when executed on `sgpu` setup.

#### Known issues

- `rocm-bandwidth-test` folder fails to be removed after driver uninstallation:
    * After running `amdgpu-uninstall`, the `rocm-bandwidth-test` folder and package are still present.
    * Workaround: Remove the package manually using: 
    ```
    sudo apt-get remove -y rocm-bandwidth-test
    ```

### **ROCm Compute Profiler** (3.3.1)

#### Added

* Support for PC sampling of multi-kernel applications.
  * PC Sampling output instructions are displayed with the name of the kernel to which the individual instruction belongs.
  * Single kernel selection is supported so that the PC samples of the selected kernel can be displayed.

#### Changed

* Roofline analysis now runs on GPU 0 by default instead of all GPUs.

#### Optimized

* Improved roofline benchmarking by updating the `flops_benchmark` calculation.

* Improved standalone roofline plots in profile mode (PDF output) and analyze mode (CLI and GUI visual plots):
  * Fixed the peak MFMA/VALU lines being cut off.
  * Cleaned up the overlapping roofline numeric values by moving them into the side legend.
  * Added AI points chart with respective values, cache level, and compute/memory bound status.
  * Added full kernel names to the symbol chart.

#### Resolved issues

* Resolved existing issues to improve stability.

### **ROCm Systems Profiler** (1.2.1)

#### Resolved issues

- Fixed an issue of OpenMP Tools (OMPT) events, GPU performance counters, VA-API, MPI, and host events failing to be collected in the `rocpd` output.

### **ROCm Validation Suite** (1.3.0)

#### Added

* Support for different test levels with `-r` option for AMD Instinct MI3XXx GPUs.
* Set compute type for DGEMM operations on AMD Instinct MI350X and MI355X GPUs.

### **rocSHMEM** (3.1.0)

#### Added

* Allowed IPC, RO, and GDA backends to be selected at runtime.
* GDA conduit for different NIC vendors:
   * Broadcom BNXT\_RE (Thor 2)
   * Mellanox MLX5 (IB and RoCE ConnectX-7)
* New APIs:
   * `rocshmem_get_device_ctx`

#### Changed

* The following APIs have been deprecated:
  * `rocshmem_wg_init`
  * `rocshmem_wg_finalize`
  * `rocshmem_wg_init_thread`

* `rocshmem_ptr`  can now return non-null pointer to a shared memory region when the IPC transport is available to reach that region. Previously, it would return a null pointer.
* `ROCSHMEM_RO_DISABLE_IPC` is renamed to `ROCSHMEM_DISABLE_MIXED_IPC`. 
    - This environment variable wasn't documented in earlier releases. It's now documented.

#### Removed

* rocSHMEM no longer requires rocPRIM and rocThrust as dependencies.
* Removed MPI compile-time dependency.

#### Known issues

* Only a subset of rocSHMEM APIs are implemented for the GDA conduit.

### **rocWMMA** (2.1.0)

#### Added

* More unit tests to increase the code coverage.

#### Changed

* Increased compile timeout and improved visualization in `math-ci`.

#### Removed

* Absolute paths from the `RPATH` of sample and test binary files.

#### Resolved issues

* Fixed issues caused by HIP changes:
    * Removed the `.data` member from `HIP_vector_type`.
    * Broadcast constructor now only writes to the first vector element.
* Fixed a bug related to `int32_t` usage in `hipRTC_gemm` for gfx942, caused by breaking changes in HIP.
* Replaced `#pragma unroll` with `static for` to fix a bug caused by the upgraded compiler which no longer supports using `#pragma unroll` with template parameter indices.
* Corrected test predicates for `BLK` and `VW` cooperative kernels.
* Modified `compute_utils.sh` in `build-infra` to ensure rocWMMA is built with gfx1151 target for ROCm 7.0 and beyond.

## ROCm 7.1.0

See the [ROCm 7.1.0 release notes](https://rocm.docs.amd.com/en/docs-7.1.0/about/release-notes.html#rocm-7-1-0-release-notes)
for a complete overview of this release.

### **AMD SMI** (26.1.0)

#### Added

* `GPU LINK PORT STATUS` table to `amd-smi xgmi` command. The `amd-smi xgmi -s` or `amd-smi xgmi --source-status` will now show the `GPU LINK PORT STATUS` table.  

* `amdsmi_get_gpu_revision()` to Python API. This function retrieves the GPU revision ID. Available in `amdsmi_interface.py` as `amdsmi_get_gpu_revision()`.

* Gpuboard and baseboard temperatures to `amd-smi metric` command.

#### Changed

* Struct `amdsmi_topology_nearest_t` member `processor_list`. Member size changed, processor_list[AMDSMI_MAX_DEVICES * AMDSMI_MAX_NUM_XCP].

* `amd-smi reset --profile` behavior so that it won't also reset the performance level.  
  * The performance level can still be reset using `amd-smi reset --perf-determinism`.  

* Setting power cap is now available in Linux Guest. You can now use `amd-smi set --power-cap` as usual in Linux Guest systems too.

* Changed `amd-smi static --vbios` to `amd-smi static --ifwi`.  
  * VBIOS naming is replaced with IFWI (Integrated Firmware Image) for improved clarity and consistency.
  * AMD Instinct MI300 Series GPUs (and later) now use a new version format with enhanced build information.
  * Legacy command `amd-smi static --vbios` remains functional for backward compatibility, but displays updated IFWI heading.
  * The Python, C, and Rust API for `amdsmi_get_gpu_vbios_version()` will now have a new field called `boot_firmware`, which will return the legacy vbios version number that is also known as the Unified BootLoader (UBL) version.

#### Optimized

* Optimized the way `amd-smi process` validates, which processes are running on a GPU. 

#### Resolved issues

* Fixed a CPER record count mismatch issue when using the `amd-smi ras --cper --file-limit`. Updated the deletion calculation to use `files_to_delete = len(folder_files) - file_limit` for exact file count management.

* Fixed the event monitoring segfaults causing RDC to crash. Added the mutex locking around access to device event notification file pointer.

* Fixed an issue where using `amd-smi ras --folder <folder_name>` was forcing the created folder's name to be lowercase. This fix also makes all string input options case-insensitive.

* Fixed certain output in `amd-smi monitor` when GPUs are partitioned. It fixes the issue with amd-smi monitor such as: `amd-smi monitor -Vqt`, `amd-smi monitor -g 0 -Vqt -w 1`, and `amd-smi monitor -Vqt --file /tmp/test1`. These commands will now be able to display as normal in partitioned GPU scenarios.

```{note}
See the full [AMD SMI changelog](https://github.com/ROCm/amdsmi/blob/release/rocm-rel-7.1/CHANGELOG.md#amd_smi_lib-for-rocm-710) for details, examples, and in-depth descriptions.
```

### **Composable Kernel** (1.1.0)

#### Added
 
* Support for hdim as a multiple of 32 for FMHA (fwd/fwd_splitkv/bwd).
* Support for elementwise kernel.
 
#### Upcoming changes
 
* Non-grouped convolutions are deprecated. Their functionality is supported by grouped convolution.

### **HIP** (7.1.0)

#### Added

* New HIP APIs
    - `hipModuleGetFunctionCount` returns the number of functions within a module
    - `hipMemsetD2D8` sets 2D memory range with specified 8-bit values
    - `hipMemsetD2D8Async` asynchronously sets 2D memory range with specified 8-bit values
    - `hipMemsetD2D16` sets 2D memory range with specified 16-bit values
    - `hipMemsetD2D16Async` asynchronously sets 2D memory range with specified 16-bit values
    - `hipMemsetD2D32` sets 2D memory range with specified 32-bit values
    - `hipMemsetD2D32Async` asynchronously sets 2D memory range with specified 32-bit values
    - `hipStreamSetAttribute` sets attributes such as synchronization policy for a given stream
    - `hipStreamGetAttribute` returns attributes such as priority for a given stream
    - `hipModuleLoadFatBinary`  loads fatbin binary to a module
    - `hipMemcpyBatchAsync` asynchronously performs a batch copy of 1D or 2D memory
    - `hipMemcpy3DBatchAsync` asynchronously performs a batch copy of 3D memory
    - `hipMemcpy3DPeer` copies memory between devices
    - `hipMemcpy3DPeerAsync` asynchronously copies memory between devices
    - `hipMemsetD2D32Async` asynchronously sets 2D memory range with specified 32-bit values
    - `hipMemPrefetchAsync_v2`  prefetches memory to the specified location
    - `hipMemAdvise_v2`         advises about the usage of a given memory range
    - `hipGetDriverEntryPoint ` gets function pointer of a HIP API.
    - `hipSetValidDevices`      sets a default list of devices that can be used by HIP
    - `hipStreamGetId`          queries the id of a stream
* Support for nested tile partitioning within cooperative groups, matching CUDA functionality.

#### Optimized

* Improved HIP module loading latency.
* Optimized kernel metadata retrieval during module post-load.
* Optimized doorbell ring in HIP runtime for the following performance improvements:
    - Makes efficient packet batching for HIP graph launch
    - Dynamic packet copying based on a defined maximum threshold or power-of-2 staggered copy pattern
    - If timestamps are not collected for a signal for reuse, it creates a new signal. This can potentially increase the signal footprint if the handler doesn't run fast enough

#### Resolved issues

* A segmentation fault occurred in the application when capturing the same HIP graph from multiple streams with cross-stream dependencies.  The HIP runtime has fixed an issue where a forked stream joined to a parent stream that was not originally created with the API `hipStreamBeginCapture`.
* Different behavior of en-queuing command on a legacy stream during stream capture on AMD ROCM platform, compared with CUDA. HIP runtime now returns an error in this specific situation to match CUDA behavior.
* Failure of memory access fault occurred in rocm-examples test suite. When Heterogeneous Memory Management (HMM) is not supported in the driver, `hipMallocManaged` will only allocate system memory in HIP runtime.

#### Known issues

* SPIR-V-enabled applications might encounter a segmentation fault. The problem doesn't exist when SPIR-V is disabled. The issue will be fixed in the next ROCm release. 

### **hipBLAS** (3.1.0)

#### Added

* `--clients-only` build option to only build clients against a prebuilt library.
* gfx1150, gfx1151, gfx1200, and gfx1201 support enabled.
* FORTRAN enabled for the Microsoft Windows build and tests.
* Additional reference library fallback options added.

#### Changed

* Improved the build time for clients by removing `clients_common.cpp` from the hipblas-test build.

### **hipBLASLt** (1.1.0)

#### Added

* Fused Clamp GEMM for ``HIPBLASLT_EPILOGUE_CLAMP_EXT`` and ``HIPBLASLT_EPILOGUE_CLAMP_BIAS_EXT``. This feature requires the minimum (``HIPBLASLT_MATMUL_DESC_EPILOGUE_ACT_ARG0_EXT``) and maximum (``HIPBLASLT_MATMUL_DESC_EPILOGUE_ACT_ARG1_EXT``) to be set.
* Support for ReLU/Clamp activation functions with auxiliary output for the `FP16` and `BF16` data types for gfx942 to capture intermediate results. This feature is enabled for ``HIPBLASLT_EPILOGUE_RELU_AUX``, ``HIPBLASLT_EPILOGUE_RELU_AUX_BIAS``, ``HIPBLASLT_EPILOGUE_CLAMP_AUX_EXT``, and ``HIPBLASLT_EPILOGUE_CLAMP_AUX_BIAS_EXT``.
* Support for `HIPBLAS_COMPUTE_32F_FAST_16BF` for FP32 data type for gfx950 only.
* CPP extension APIs ``setMaxWorkspaceBytes`` and ``getMaxWorkspaceBytes``.
* Feature to print logs (using ``HIPBLASLT_LOG_MASK=32``) for Grouped GEMM.
* Support for swizzleA by using the hipblaslt-ext cpp API.
* Support for hipBLASLt extop for gfx11XX and gfx12XX.

#### Changed

* ``hipblasLtMatmul()`` now returns an error when the workspace size is insufficient, rather than causing a segmentation fault.

#### Optimized

* `TF32` kernel optimization for the AMD Instinct MI355X GPU to enhance training and inference efficiency.

#### Resolved issues

* Fixed incorrect results when using ldd and ldc dimension parameters with some solutions.

### **hipCUB** (4.1.0)

#### Added

* Exposed Thread-level reduction API `hipcub::ThreadReduce`.
* `::hipcub::extents`, with limited parity to C++23's `std::extents`. Only `static extents` is supported; `dynamic extents` is not. Helper structs have been created to perform computations on `::hipcub::extents` only when the backend is rocPRIM. For the CUDA backend, similar functionality exists.
* `projects/hipcub/hipcub/include/hipcub/backend/rocprim/util_mdspan.hpp` to support `::hipcub::extents`.
* `::hipcub::ForEachInExtents` API.
* `hipcub::DeviceTransform::Transform` and `hipcub::DeviceTransform::TransformStableArgumentAddresses`.
* hipCUB and its dependency rocPRIM have been moved into the new `rocm-libraries` [monorepo repository](https://github.com/ROCm/rocm-libraries). This repository contains a number of ROCm libraries that are frequently used together.
  * The repository migration requires a few changes to the way that hipCUB fetches library dependencies.
  * CMake build option `ROCPRIM_FETCH_METHOD` may be set to one of the following:
    * `PACKAGE` - (default) searches for a preinstalled packaged version of the dependency. If it is not found, the build will fall back using option `DOWNLOAD`, below.
    * `DOWNLOAD` - downloads the dependency from the rocm-libraries repository. If git >= 2.25 is present, this option uses a sparse checkout that avoids downloading more than it needs to. If not, the whole monorepo is downloaded (this may take some time).
    * `MONOREPO` - this option is intended to be used if you are building hipCUB from within a copy of the rocm-libraries repository that you have cloned (and therefore already contains rocPRIM). When selected, the build will try find the dependency in the local repository tree. If it cannot be found, the build will attempt to use git to perform a sparse-checkout of rocPRIM. If that also fails, it will fall back to using the `DOWNLOAD` option described above.

* A new CMake option `-DUSE_SYSTEM_LIB` to allow tests to be built from installed `hipCUB` provided by the system.

#### Changed

* Changed include headers to avoid relative includes that have slipped in.
* Changed `CUDA_STANDARD` for tests in `test/hipcub`, due to C++17 APIs such as `std::exclusive_scan` is used in some tests. Still use `CUDA_STANDARD 14` for `test/extra`.
* Changed `CCCL_MINIMUM_VERSION` to `2.8.2` to align with CUB.
* Changed `cmake_minimum_required` from `3.16` to `3.18`, in order to support `CUDA_STANDARD 17` as a valid value.
* Add support for large num_items `DeviceScan`, `DevicePartition` and `Reduce::{ArgMin, ArgMax}`.
* Added tests for large num_items.
* The previous dependency-related build option `DEPENDENCIES_FORCE_DOWNLOAD` has been renamed `EXTERNAL_DEPS_FORCE_DOWNLOAD` to differentiate it from the new rocPRIM dependency option described above. Its behavior remains the same - it forces non-ROCm dependencies (Google Benchmark and Google Test) to be downloaded rather than searching for installed packages. This option defaults to `OFF`.

#### Removed

* Removed `TexRefInputIterator`, which was removed from CUB after CCCL's 2.6.0 release. This API should have already been removed, but somehow it remained and was not tested.
* Deprecated `hipcub::ConstantInputIterator`, use `rocprim::constant_iterator` or `rocthrust::constant_iterator` instead.
* Deprecated `hipcub::CountingInputIterator`, use `rocprim::counting_iterator` or `rocthrust::counting_iterator` instead.
* Deprecated `hipcub::DiscardOutputIterator`, use `rocprim::discard_iterator` or `rocthrust::discard_iterator` instead.
* Deprecated `hipcub::TransformInputIterator`, use `rocprim::transform_iterator` or `rocthrust::transform_iterator` instead.
* Deprecated `hipcub::AliasTemporaries`, which is considered to be an internal API. Moved to the detail namespace.
* Deprecated almost all functions in `projects/hipcub/hipcub/include/hipcub/backend/rocprim/util_ptx.hpp`.
* Deprecated hipCUB macros: `HIPCUB_MAX`, `HIPCUB_MIN`, `HIPCUB_QUOTIENT_FLOOR`, `HIPCUB_QUOTIENT_CEILING`, `HIPCUB_ROUND_UP_NEAREST` and `HIPCUB_ROUND_DOWN_NEAREST`.

#### Known issues

* The `__half` template specializations of Simd operators are currently disabled due to possible build issues with PyTorch.

### **hipFFT** (1.0.21)

#### Added

* Improved test coverage of multi-stream plans, user-specified work areas, and default stride calculation.
* Experimental introduction of hipFFTW library, interfacing rocFFT on AMD platforms using the same symbols as FFTW3 (with partial support).

### **hipfort** (0.7.1)

#### Added

* Support for building with CMake 4.0.

#### Resolved issues

* Fixed a potential integer overflow issue in `hipMalloc` interfaces.

### **hipRAND** (3.1.0)

#### Resolved issues

* Updated error handling for several hipRAND unit tests to accommodate the new `hipGetLastError` behavior that was introduced in ROCm 7.0.0. As of ROCm 7.0.0, the internal error state is cleared on each call to `hipGetLastError` rather than on every HIP API call.

### **hipSOLVER** (3.1.0)

#### Added

* Extended test suites for `hipsolverDn` compatibility functions.

#### Changed

* Changed code coverage to use `llvm-cov` instead of `gcov`.

### **hipSPARSE** (4.1.0)

#### Added

* Brain half float mixed precision for the following routines:
    * `hipsparseAxpby` where X and Y use bfloat16 and result and the compute type use float.
    * `hipsparseSpVV` where X and Y use bfloat16 and result and the compute type use float.
    * `hipsparseSpMV` where A and X use bfloat16 and Y and the compute type use float.
    * `hipsparseSpMM` where A and B use bfloat16 and C and the compute type use float.
    * `hipsparseSDDMM` where A and B use bfloat16 and C and the compute type use float.
    * `hipsparseSDDMM` where A and B and C use bfloat16 and the compute type use float.
* Half float mixed precision to `hipsparseSDDMM` where A and B and C use float16 and the compute type use float.
* Brain half float uniform precision to `hipsparseScatter` and `hipsparseGather` routines.
* Documentation for installing and building hipSPARSE on Microsoft Windows.

### **hipSPARSELt** (0.2.5)

#### Changed

* Changed the behavior of the Relu activation.

#### Optimized

* Provided more kernels for the `FP16` and `BF16` data types.

### **MIGraphX** (2.14.0)

#### Added

* Python 3.13 support.
* PyTorch wheels to the Dockerfile.
* Python API for returning serialized bytes.
* `fixed_pad` operator for padding dynamic shapes to the maximum static shape.
* Matcher to upcast base `Softmax` operations.
* Support for the `convolution_backwards` operator through rocMLIR.
* `LSE` output to attention fusion.
* Flags to `EnableControlFlowGuard` due to BinSkim errors.
* New environment variable documentation and reorganized structure.
* `stash_type` attribute for `LayerNorm` and expanded test coverage.
* Operator builders (phase 2).
* `MIGRAPHX_GPU_HIP_FLAGS` to allow extra HIP compile flags.

#### Changed

* Updated C API to include `current()` caller information in error reporting.
* Updated documentation dependencies:
  * **rocm-docs-core** bumped from 1.21.1 → 1.25.0 across releases.
  * **Doxygen** updated to 1.14.0.
  * **urllib3** updated from 2.2.2 → 2.5.0.
* Updated `src/CMakeLists.txt` to support `msgpack` 6.x (`msgpack-cxx`).
* Updated model zoo test generator to fix test issues and add summary logging.
* Updated `rocMLIR` and `ONNXRuntime` mainline references across commits.
* Updated module sorting algorithm for improved reliability.
* Restricted FP8 quantization to `dot` and `convolution` operators.
* Moved ONNX Runtime launcher script into MIGraphX and updated build scripts.
* Simplified ONNX `Resize` operator parser for correctness and maintainability.
* Updated `any_ptr` assertion to avoid failure on default HIP stream.
* Print kernel and module information on compile failure.

#### Removed

* Removed Perl dependency from SLES builds.
* Removed redundant includes and unused internal dependencies.

#### Optimized

* Reduced nested visits in reference operators to improve compile time.
* Avoided dynamic memory allocation during kernel launches.
* Removed redundant NOP instructions for GFX11/12 platforms.
* Improved `Graphviz` output (node color and layout updates).
* Optimized interdependency checking during compilation.
* Skip hipBLASLt solutions that require a workspace size larger than 128 MB for efficient memory utilization.

#### Resolved issues

* Error in `MIGRAPHX_GPU_COMPILE_PARALLEL` documentation (#4337).
* rocMLIR `rewrite_reduce` issue (#4218).
* Bug with `invert_permutation` on GPU (#4194).
* Compile error when `MIOPEN` is disabled (missing `std` includes) (#4281).
* ONNX `Resize` parsing when input and output shapes are identical (#4133, #4161).
* Issue with MHA in attention refactor (#4152).
* Synchronization issue from upstream ONNX Runtime (#4189).
* Spelling error in “Contiguous” (#4287).
* Tidy complaint about duplicate header (#4245).
* `reshape`, `transpose`, and `broadcast` rewrites between pointwise and reduce operators (#3978).
* Extraneous include file in HIPRTC-based compilation (#4130).
* CI Perl dependency issue for SLES builds (#4254).
* Compiler warnings for ROCm 7.0 of ``error: unknown warning option '-Wnrvo'``(#4192).

### **MIOpen** (3.5.1)

#### Added

* Added a new trust verify find mode.
* Ported Op4dTensorLite kernel from OpenCL to HIP.
* Implemented a generic HIP kernel for backward layer normalization.

#### Changed

* Kernel DBs moved from Git LFS to DVC (Data Version Control).

#### Optimized

* [Conv] Enabled Composable Kernel (CK) implicit gemms on gfx950.

#### Resolved issues

* [BatchNorm] Fixed a bug for the NHWC layout when a variant was not applicable.
* Fixed a bug that caused a zero-size LDS array to be defined on Navi.

### **MIVisionX** (3.4.0)

#### Added

* VX_RPP - Update blur
* HIP - HIP_CHECK for hipLaunchKernelGGL for gated launch

#### Changed

* AMD Custom V1.1.0 - OpenMP updates
* HALF - Fix half.hpp path updates

#### Resolved issues

* AMD Custom - dependency linking errors resolved
* VX_RPP - Fix memory leak
* Packaging - Remove Meta Package dependency for HIP

#### Known issues

* Installation on RedHat/SLES requires the manual installation of the `FFMPEG` &amp; `OpenCV` dev packages.

#### Upcoming changes

* VX_AMD_MEDIA - rocDecode support for hardware decode

### **RCCL** (2.27.7)

#### Added

* `RCCL_P2P_BATCH_THRESHOLD` to set the message size limit for batching P2P operations. This mainly affects small message performance for alltoall at a large scale but also applies to alltoallv.
* `RCCL_P2P_BATCH_ENABLE` to enable batching P2P operations to receive performance gains for smaller messages up to 4MB for alltoall when the workload requires it. This is to avoid performance dips for larger messages.

#### Changed

* The MSCCL++ feature is now disabled by default. The `--disable-mscclpp` build flag is replaced with `--enable-mscclpp` in the `rccl/install.sh` script.
* Compatibility with NCCL 2.27.7.

#### Optimized
* Enabled and optimized batched P2P operations to improve small message performance for `AllToAll` and `AllGather`.
* Optimized channel count selection to improve efficiency for small-to-medium message sizes in `ReduceScatter`.
* Changed code inlining to improve latency for small message sizes for `AllReduce`, `AllGather`, and `ReduceScatter`.

#### Known issues

* Symmetric memory kernels are currently disabled due to ongoing CUMEM enablement work.
* When running this version of RCCL using ROCm versions earlier than 6.4.0, the user must set the environment flag `HSA_NO_SCRATCH_RECLAIM=1`.

### **rocAL** (2.4.0)

#### Added
* JAX iterator support in rocAL
* rocJPEG - Fused Crop decoding support

#### Changed
* CropResize - updates and fixes
* Packaging - Remove Meta Package dependency for HIP

#### Resolved issues
* OpenMP - dependency linking errors resolved.
* Bugfix - memory leaks in rocAL.

#### Known issues
* Package installation on SLES requires manually installing `TurboJPEG`.
* Package installation on RedHat and SLES requires manually installing the `FFMPEG Dev` package.

### **rocALUTION** (4.0.1)

#### Added

* Support for gfx950.

#### Changed

* Updated the default build standard to C++17 when compiling rocALUTION from source (previously C++14).

#### Optimized

* Improved and expanded user documentation.

#### Resolved issues

* Fixed a bug in the GPU hashing algorithm that occurred when not compiling with -O2/-O3.
* Fixed an issue with the SPAI preconditioner when using complex numbers.

### **rocBLAS** (5.1.0)

#### Added

* Sample for clients using OpenMP threads calling rocBLAS functions.
* gfx1150 and gfx1151 enabled.

#### Changed

* By default, the Tensile build is no longer based on `tensile_tag.txt` but uses the same commit from shared/tensile in the rocm-libraries repository. The rmake or install `-t` option can build from another local path with a different commit.

#### Optimized

* Improved the performance of Level 2 gemv transposed (`TransA != N`) for the problem sizes where `m` is small and `n` is large on gfx90a and gfx942.

### **ROCdbgapi** (0.77.4)

#### Added

* gfx1150 and gfx1151 enabled.

### **rocDecode** (1.4.0)

#### Added

* AV1 12-bit decode support on VA-API version 1.23.0 and later.
* rocdecode-host V1.0.0 library for software decode
* FFmpeg version support for 5.1 and 6.1
* Find package - rocdecode-host

#### Resolved issues

* rocdecode-host - failure to build debuginfo packages without FFmpeg resolved.
* Fix a memory leak for rocDecodeNegativeTests

#### Changed

* HIP meta package changed - Use hip-dev/devel to bring required hip dev deps
* rocdecode host - linking updates to rocdecode-host library

### **rocFFT** (1.0.35)

#### Optimized

* Implemented single-kernel plans for some 2D problem sizes, on devices with at least 160KiB of LDS.
* Improved performance of unit-strided, complex-interleaved, forward/inverse FFTs for lengths: (64,64,128), (64,64,52), (60,60,60)
, (32,32,128), (32,32,64), (64,32,128)
* Improved performance of 3D MPI pencil decompositions by using sub-communicators for global transpose operations.

### **rocJPEG** (1.2.0)

#### Changed
* HIP meta package has been changed. Use `hip-dev/devel` to bring required hip dev deps.

#### Resolved issues
* Fixed an issue where extra padding was incorrectly included when saving decoded JPEG images to files.
* Resolved a memory leak in the jpegDecode application.

### **ROCm Compute Profiler** (3.3.0)

#### Added
* Dynamic process attachment feature that allows coupling with a workload process, without controlling its start or end.
  * Use '--attach-pid' to specify the target process ID.
  * Use '--attach-duration-msec' to specify time duration.
* `rocpd` choice for `--format-rocprof-output` option in profile mode.
* `--retain-rocpd-output` option in profile mode to save large raw rocpd databases in workload directory.
* Feature to show description of metrics during analysis.
  * Use `--include-cols Description` to show the Description column, which is excluded by default from the
  ROCm Compute Profiler CLI output.
* `--set` filtering option in profile mode to enable single-pass counter collection for predefined subsets of metrics.
* `--list-sets` filtering option in profile mode to list the sets available for single pass counter collection.
* Missing counters based on register specification which enables missing metrics.
  * Enabled `SQC_DCACHE_INFLIGHT_LEVEL` counter and associated metrics.
  * Enabled `TCP_TCP_LATENCY` counter and associated counter for all GPUs except MI300.
* Interactive metric descriptions in TUI analyze mode.
  * You can now left click on any metric cell to view detailed descriptions in the dedicated `METRIC DESCRIPTION` tab.
* Support for analysis report output as a SQLite database using ``--output-format db`` analysis mode option.
* `Compute Throughput` panel to TUI's `High Level Analysis` category with the following metrics: VALU FLOPs, VALU IOPs, MFMA FLOPs (F8), MFMA FLOPs (BF16), MFMA FLOPs (F16), MFMA FLOPs (F32), MFMA FLOPs (F64), MFMA FLOPs (F6F4) (in gfx950), MFMA IOPs (Int8), SALU Utilization, VALU Utilization, MFMA Utilization, VMEM Utilization, Branch Utilization, IPC

* `Memory Throughput` panel to TUI's `High Level Analysis` category with the following metrics: vL1D Cache BW, vL1D Cache Utilization, Theoretical LDS Bandwidth, LDS Utilization, L2 Cache BW, L2 Cache Utilization, L2-Fabric Read BW, L2-Fabric Write BW, sL1D Cache BW, L1I BW, Address Processing Unit Busy, Data-Return Busy, L1I-L2 Bandwidth, sL1D-L2 BW
* Roofline support for Debian 12 and Azure Linux 3.0.
* Notice for change in default output format to `rocpd` in a future release
  * This is displayed when `--format-rocprof-output rocpd` is not used in profile mode

#### Changed

* In the memory chart, long string of numbers are now displayed as scientific notation. It also solves the issue of overflow of displaying long number
* When `--format-rocprof-output rocpd` is used, only `pmc_perf.csv` will be written to workload directory instead of multiple CSV files.
* CLI analysis mode baseline comparison will now only compare common metrics across workloads and will not show the Metric ID.
  * Removed metrics from analysis configuration files which are explicitly marked as empty or None.
* Changed the basic (default) view of TUI from aggregated analysis data to individual kernel analysis data.
* Updated `Unit` of the following `Bandwidth` related metrics to `Gbps` instead of `Bytes per Normalization Unit`:
  * Theoretical Bandwidth (section 1202)
  * L1I-L2 Bandwidth (section 1303)
  * sL1D-L2 BW (section 1403)
  * Cache BW (section 1603)
  * L1-L2 BW (section 1603)
  * Read BW (section 1702)
  * Write and Atomic BW (section 1702)
  * Bandwidth (section 1703)
  * Atomic/Read/Write Bandwidth (section 1703)
  * Atomic/Read/Write Bandwidth - (HBM/PCIe/Infinity Fabric) (section 1706)
* Updated the metric name for the following `Bandwidth` related metrics whose `Unit` is `Percent` by adding `Utilization`:
  * Theoretical Bandwidth Utilization (section 1201)
  * L1I-L2 Bandwidth Utilization (section 1301)
  * Bandwidth Utilization (section 1301)
  * Bandwidth Utilization (section 1401)
  * sL1D-L2 BW Utilization (section 1401)
  * Bandwidth Utilization (section 1601)
* Updated `System Speed-of-Light` panel to `GPU Speed-of-Light` in TUI for the following metrics:
  * Theoretical LDS Bandwidth
  * vL1D Cache BW
  * L2 Cache BW
  * L2-Fabric Read BW
  * L2-Fabric Write BW
  * Kernel Time
  * Kernel Time (Cycles)
  * SIMD Utilization
  * Clock Rate
* Analysis output:
  * Replaced `-o / --output` analyze mode option with `--output-format` and `--output-name`.
    * Use ``--output-format`` analysis mode option to select the output format of the analysis report.
    * Use ``--output-name`` analysis mode option to override the default file/folder name.
  * Replaced `--save-dfs` analyze mode option with `--output-format csv`.
* Command-line options:
  * `--list-metrics` and `--config-dir` options moved to general command-line options.
  * `--list-metrics` option cannot be used without GPU architecture argument.
  * `--list-metrics` option do not show number of L2 channels.
  * `--list-available-metrics` profile mode option to display the metrics available for profiling in current GPU.
  * `--list-available-metrics` analyze mode option to display the metrics available for analysis.
  * `--block` option cannot be used with `--list-metrics` and `--list-available-metrics`options.
* Default `rocprof` interface changed from `rocprofv3` to `rocprofiler-sdk`
  * Use ROCPROF=rocprofv3 to use rocprofv3 interface
* Updated metric names for better alignment between analysis configuration and documentation.

#### Removed

* Usage of `rocm-smi` in favor of `amd-smi`.
* Hardware IP block-based filtering has been removed in favor of analysis report block-based filtering.
* Aggregated analysis view from TUI analyze mode.

#### Optimized

* Improved `--time-unit` option in analyze mode to apply time unit conversion across all analysis sections, not just kernel top stats.
* Improved logic to obtain rocprof-supported counters, which prevents unnecessary warnings.
* Improved post-analysis runtime performance by caching and multi-processing.
* Improve analysis block based filtering to accept metric ID level filtering.
  * This can be used to collect individual metrics from various sections of the analysis config.

#### Resolved issues

* Fixed an issue of not detecting the memory clock when using `amd-smi`.
* Fixed standalone GUI crashing.
* Fixed L2 read/write/atomic bandwidths on AMD Instinct MI350 Series GPUs.
* Fixed an issue where accumulation counters could not be collected on AMD Instinct MI100.
* Fixed an issue of kernel filtering not working in the roofline chart.

#### Known issues

* MI300A/X L2-Fabric 64B read counter may display negative values - The rocprof-compute metric 17.6.1 (Read 64B) can report negative values due to incorrect calculation when TCC_BUBBLE_sum + TCC_EA0_RDREQ_32B_sum exceeds TCC_EA0_RDREQ_sum.
  * A workaround has been implemented using max(0, calculated_value) to prevent negative display values while the root cause is under investigation.
* The profile mode crashes when `--format-rocprof-output json` is selected.
    * As a workaround, this option should either not be provided or should be set to `csv` instead of `json`. This issue does not affect the profiling results since both `csv` and `json` output formats lead to the same profiling data.  

### **ROCm Data Center Tool** (1.2.0)

#### Added

- CPU monitoring support with 30+ CPU field definitions through AMD SMI integration.
- CPU partition format support (c0.0, c1.0) for monitoring AMD EPYC processors.
- Mixed GPU/CPU monitoring in single `rdci dmon` command.

#### Optimized

- Improved profiler metrics path detection for counter definitions.

#### Resolved issues

- Group management issues with listing created/non-created groups.
- ECC_UNCORRECT field behavior.

### **ROCm Debugger (ROCgdb)** (16.3)

#### Added

* gfx1150 and gfx1151 support enabled.

### **ROCm Systems Profiler** (1.2.0)

#### Added

- ``ROCPROFSYS_ROCM_GROUP_BY_QUEUE`` configuration setting to allow grouping of events by hardware queue, instead of the default grouping.
- Support for `rocpd` database output with the `ROCPROFSYS_USE_ROCPD` configuration setting.
- Support for profiling PyTorch workloads using the `rocpd` output database.
- Support for tracing OpenMP API in Fortran applications.
- An error warning is triggered if the profiler application fails because SELinux enforcement is enabled. The warning includes steps to disable SELinux enforcement.

#### Changed

- Updated the grouping of "kernel dispatch" and "memory copy" events in Perfetto traces. They are now grouped together by HIP Stream rather than separately and by hardware queue.
- Updated PAPI module to v7.2.0b2.
- ROCprofiler-SDK is now used for tracing OMPT API calls.

#### Known issues

* Profiling PyTorch and other AI workloads might fail because it is unable to find the libraries in the default linker path. As a workaround, you need to explicitly add the library path to ``LD_LIBRARY_PATH``. For example, when using PyTorch with Python 3.10, add the following to the environment:

```
export LD_LIBRARY_PATH=:/opt/venv/lib/python3.10/site-packages/torch/lib:$LD_LIBRARY_PATH
```

### **rocPRIM** (4.1.0)

#### Added

* `get_sreg_lanemask_lt`, `get_sreg_lanemask_le`, `get_sreg_lanemask_gt` and `get_sreg_lanemask_ge`.
* `rocprim::transform_output_iterator` and `rocprim::make_transform_output_iterator`.
* Experimental support for SPIR-V, to use the correct tuned config for part of the appliable algorithms.
* A new cmake option, `BUILD_OFFLOAD_COMPRESS`. When rocPRIM is build with this option enabled, the `--offload-compress` switch is passed to the compiler. This causes the compiler to compress the binary that it generates. Compression can be useful in cases where you are compiling for a large number of targets, since this often results in a large binary. Without compression, in some cases, the generated binary may become so large symbols are placed out of range, resulting in linking errors. The new `BUILD_OFFLOAD_COMPRESS` option is set to `ON` by default.
* A new CMake option `-DUSE_SYSTEM_LIB` to allow tests to be built from `ROCm` libraries provided by the system.
* `rocprim::apply` which applies a function to a `rocprim::tuple`.

#### Changed

* Changed tests to support `ptr-to-const` output in `/test/rocprim/test_device_batch_memcpy.cpp`.

#### Optimized

* Improved performance of many algorithms by updating their tuned configs.
  * 891 specializations have been improved.
  * 399 specializations have been added.

#### Resolved issues

* Fixed `device_select`, `device_merge`, and `device_merge_sort` not allocating the correct amount of virtual shared memory on the host.
* Fixed the `-&gt;` operator for the `transform_iterator`, the `texture_cache_iterator`, and the `arg_index_iterator`, by now returning a proxy pointer.
  * The `arg_index_iterator` also now only returns the internal iterator for the `-&gt;`.

#### Upcoming changes

* Deprecated the `-&gt;` operator for the `zip_iterator`.

### **ROCProfiler** (2.0.0)

#### Removed

* `rocprofv2` doesn't support gfx12XX Series GPUs. For gfx12XX Series GPUs, use `rocprofv3` tool.

### **ROCprofiler-SDK** (1.0.0)

#### Added
* Dynamic process attachment- ROCprofiler-SDK and `rocprofv3` now facilitate dynamic profiling of a running GPU application by attaching to its process ID (PID), rather than launching the application through the profiler itself.
* Scratch-memory trace information to the Perfetto output in `rocprofv3`.
* New capabilities to the thread trace support in `rocprofv3`:
    * Real-time clock support for thread trace alignment on gfx9XX architecture. This enables high-resolution clock computation and better synchronization across shader engines. 
    * `MultiKernelDispatch` thread trace support is now available across all ASICs.
* Documentation for dynamic process attachment.
* Documentation for `rocpd` summaries.

#### Optimized
* Improved the stability and robustness of the `rocpd` output.

### **rocPyDecode** (0.7.0)

#### Added
* rocPyJpegPerfSample - samples for JPEG decode

#### Changed
* Package - rocjpeg set as required dependency.
* rocDecode host - rocdecode host linking updates

#### Resolved issues
* rocJPEG Bindings - bug fixes
* Test package - find dependencies updated

### **rocRAND** (4.1.0)

#### Changed

* Changed the `USE_DEVICE_DISPATCH` flag so it can turn device dispatch off by setting it to zero. Device dispatch should be turned off when building for SPIRV.

#### Resolved issues

* Updated error handling for several rocRAND unit tests to accommodate the new `hipGetLastError` behavior that was introduced in ROCm 7.0.
As of ROCm 7.0, the internal error state is cleared on each call to `hipGetLastError` rather than on every HIP API call.

### **rocSOLVER** (3.31.0)

#### Optimized

Improved the performance of:

* LARF, LARFT, GEQR2, and downstream functions such as GEQRF.
* STEDC and divide and conquer Eigensolvers.

### **rocSPARSE** (4.1.0)

#### Added

* Brain half float mixed precision for the following routines:
   * `rocsparse_axpby` where X and Y use bfloat16 and result and the compute type use float.
   * `rocsparse_spvv` where X and Y use bfloat16 and result and the compute type use float.
   * `rocsparse_spmv` where A and X use bfloat16 and Y and the compute type use float.
   * `rocsparse_spmm` where A and B use bfloat16 and C and the compute type use float.
   * `rocsparse_sddmm` where A and B use bfloat16 and C and the compute type use float.
   * `rocsparse_sddmm` where A and B and C use bfloat16 and the compute type use float.
* Half float mixed precision to `rocsparse_sddmm` where A and B and C use float16 and the compute type use float.
* Brain half float uniform precision to `rocsparse_scatter` and `rocsparse_gather` routines.

#### Optimized

* Improved the user documentation.

#### Upcoming changes

* Deprecate trace, debug, and bench logging using the environment variable `ROCSPARSE_LAYER`.

### **rocThrust** (4.1.0)

#### Added

* A new CMake option `-DSQLITE_USE_SYSTEM_PACKAGE` to allow SQLite to be provided by the system.
* Introduced `libhipcxx` as a soft dependency. When `libhipcxx` can be included, rocThrust can use structs and methods defined in `libhipcxx`. This allows for a more complete behavior parity with CCCL and mirrors CCCL's thrust own dependency on `libcudacxx`.
* Added a new CMake option `-DUSE_SYSTEM_LIB` to allow tests to be built from `ROCm` libraries provided by the system.

#### Changed

* The previously hidden cmake build option `FORCE_DEPENDENCIES_DOWNLOAD` has been unhidden and renamed `EXTERNAL_DEPS_FORCE_DOWNLOAD` to differentiate it from the new rocPRIM and rocRAND dependency options described above. Its behavior remains the same - it forces non-ROCm dependencies (Google Benchmark, Google Test, and SQLite) to be downloaded instead of searching for existing installed packages. This option defaults to `OFF`.

#### Removed

* The previous dependency-related build options `DOWNLOAD_ROCPRIM` and `DOWNLOAD_ROCRAND` have been removed. Use `ROCPRIM_FETCH_METHOD=DOWNLOAD` and `ROCRAND_FETCH_METHOD=DOWNLOAD` instead.

#### Known issues

* `event` test is failing on CI and local runs on MI300, MI250 and MI210.

* rocThrust, as well as its dependencies rocPRIM and rocRAND have been moved into the new `rocm-libraries` monorepo repository (https://github.com/ROCm/rocm-libraries). This repository contains several ROCm libraries that are frequently used together.
  * The repository migration requires a few changes to the way that rocThrust's ROCm library dependencies are fetched.
  * There are new cmake options for obtaining rocPRIM and (optionally, if BUILD_BENCHMARKS is enabled) rocRAND.
  * cmake build options `ROCPRIM_FETCH_METHOD` and `ROCRAND_FETCH_METHOD` may be set to one of the following:
    * `PACKAGE` - (default) searches for a preinstalled packaged version of the dependency. If it's not found, the build will fall back using option `DOWNLOAD`, described below.
    * `DOWNLOAD` - downloads the dependency from the rocm-libraries repository. If git >= 2.25 is present, this option uses a sparse checkout that avoids downloading more than it needs to. If not, the whole monorepo is downloaded (this may take some time).
    * `MONOREPO` - this option is intended to be used if you are building rocThrust from within a copy of the rocm-libraries repository that you have cloned (and therefore already contains the dependencies rocPRIM and rocRAND). When selected, the build will try to find the dependency in the local repository tree. If it can't be found, the build will attempt to add it to the local tree using a sparse-checkout. If that also fails, it will fall back to using the `DOWNLOAD` option.

### **RPP** (2.1.0)

#### Added

* Solarize augmentation for HOST and HIP.
* Hue and Saturation adjustment augmentations for HOST and HIP.
* Find RPP - cmake module.
* Posterize augmentation for HOST and HIP.

#### Changed

* HALF - Fix `half.hpp` path updates.
* Box filter - padding updates.

#### Removed

* Packaging - Removed Meta Package dependency for HIP.
* SLES 15 SP6 support.

#### Resolved issues

* Test Suite - Fixes for accuracy.
* HIP Backend - Check return status warning fixes.
* Bug fix - HIP vector types init.

## ROCm 7.0.2

See the [ROCm 7.0.2 release notes](https://rocm.docs.amd.com/en/docs-7.0.2/about/release-notes.html#rocm-7-0-2-release-notes)
for a complete overview of this release.

### **AMD SMI** (26.0.2)

#### Added

* Added `bad_page_threshold_exceeded` field to `amd-smi static --ras`, which compares retired pages count against bad page threshold. This field displays `True` if retired pages exceed the threshold, `False` if within threshold, or `N/A` if threshold data is unavailable. Note that `sudo` is required to have the `bad_page_threshold_exceeded` field populated.

#### Removed

* Removed gpuboard and baseboard temperatures enums in amdsmi Python Library.
    * `AmdSmiTemperatureType` had issues with referencing the correct attribute. As such, the following duplicate enums have been removed:
        - `AmdSmiTemperatureType.GPUBOARD_NODE_FIRST`
        - `AmdSmiTemperatureType.GPUBOARD_VR_FIRST`
        - `AmdSmiTemperatureType.BASEBOARD_FIRST`

#### Resolved Issues

* Fixed `attribute error` in `amd-smi monitor` on Linux Guest systems, where the violations argument caused CLI to break.
* Fixed certain output in `amd-smi monitor` when GPUs are partitioned.  
  * It fixes the amd-smi monitor such as: `amd-smi monitor -Vqt`, `amd-smi monitor -g 0 -Vqt -w 1`, `amd-smi monitor -Vqt --file /tmp/test1`, etc. These commands will now be able to display as normal in partitioned GPU scenarios.

* Fixed an issue where using `amd-smi ras --folder <folder_name>` was forcing the created folder's name to be lowercase. This fix also allows all string input options to be case insensitive.

* Fixed an issue of some processes not being detected by AMD SMI despite making use of KFD resources. This fix, with the addition of KFD Fallback for process detection, ensures that all KFD processes will be detected.

* Multiple CPER issues were fixed.  
  - Issue of being unable to query for additional CPERs after 20 were generated on a single device.
  - Issue where the RAS HBM CRC read was failing due to an incorrect AFID value.
  - Issue where RAS injections were not consistently producing related CPERs.

### **HIP** (7.0.2)

#### Added

* Support for the `hipMemAllocationTypeUncached` flag, enabling developers to allocate uncached memory. This flag is now supported in the following APIs:
    - `hipMemGetAllocationGranularity` determines the recommended allocation granularity for uncached memory.
    - `hipMemCreate` allocates memory with uncached properties.

#### Resolved issues

* A compilation failure affecting applications that compile kernels using `hiprtc` with the compiler option `std=c++11`.
* A permission-related error occurred during the execution of `hipLaunchHostFunc`. This API is now supported and permitted to run during stream capture, aligning its behavior with CUDA.
* A numerical error during graph capture of kernels that rely on a remainder in `globalWorkSize`, in frameworks like MIOpen and PyTorch, where the grid size is not a multiple of the block size. To ensure correct replay behavior, HIP runtime now stores this remainder in `hip::GraphKernelNode` during `hipExtModuleLaunchKernel` capture, enabling accurate execution and preventing corruption.
* A page fault occurred during viewport rendering while running the file undo.blend in Blender. The issue was resolved by the HIP runtime, which reused the same context during image creation.
* Resolved a segmentation fault in `gpu_metrics`, which is used in threshold logic for command submission patches to GPU device(s) during CPU synchronization.

### **hipBLAS** (3.0.2)
 
#### Added
 
* Enabled support for gfx1150, gfx1151, gfx1200, and gfx1201 AMD hardware.

### **RCCL** (2.26.6)

#### Added

* Enabled double-buffering in `reduceCopyPacks` to trigger pipelining, especially to overlap bf16 arithmetic.
* Added `--force-reduce-pipeline` as an option that can be passed to the `install.sh` script. Passing this option will enable software-triggered pipelining `bfloat16` reductions (that is, `all_reduce`, `reduce_scatter`, and `reduce`).

### **rocBLAS** (5.0.2)
 
#### Added
 
* Enabled gfx1150 and gfx1151.
* The `ROCBLAS_USE_HIPBLASLT_BATCHED` variable to independently control the batched hipblaslt backend. Set `ROCBLAS_USE_HIPBLASLT_BATCHED=0` to disable batched GEMM use of the hipblaslt backend.

#### Resolved issues
 
* Set the imaginary portion of the main diagonal of the output matrix to zero in syrk and herk.

### **ROCdbgapi** (0.77.4)

#### Added

* ROCdbgapi documentation link in the README.md file.

### **ROCm Systems Profiler** (1.1.1)

#### Resolved issues

* Fixed an issue where ROC-TX ranges were displayed as two separate events instead of a single spanning event.

### **rocPRIM** (4.0.1)

#### Resolved issues

* Fixed compilation issue when using `rocprim::texture_cache_iterator`.
* Fixed a HIP version check used to determine whether `hipStreamLegacy` is supported. This resolves runtime errors that occur when `hipStreamLegacy` is used in ROCm 7.0.0 and later.

### **rocSPARSE** (4.0.3)

#### Resolved issues

* Fixed an issue causing premature deallocation of internal buffers while still in use.

### **rocSOLVER** (3.30.1)

#### Optimized

Improved the performance of:

* LARFT and downstream functions such as GEQRF and ORMTR.
* LARF and downstream functions such as GEQR2.
* ORMTR and downstream functions such as SYEVD.
* GEQR2 and downstream functions such as GEQRF.

## ROCm 7.0.1

ROCm 7.0.1 is a quality release that resolves the existing issue. There is no change in component from the previous ROCm 7.0.0 release. See the [ROCm 7.0.1 release notes](https://rocm.docs.amd.com/en/docs-7.0.1/about/release-notes.html#rocm-7-0-1-release-notes) for a complete overview of this release.

## ROCm 7.0.0

See the [ROCm 7.0.0 release notes](https://rocm.docs.amd.com/en/docs-7.0.0/about/release-notes.html#rocm-7-0-0-release-notes)
for a complete overview of this release.

### **AMD SMI** (26.0.0)

#### Added

* Ability to restart the AMD GPU driver from the CLI and API.
  - `amdsmi_gpu_driver_reload()` API and `amd-smi reset --reload-driver` or `amd-smi reset -r` CLI options.
  - Driver reload functionality is now separated from memory partition
    functions; memory partition change requests should now be followed by a driver reload.
  - Driver reload requires all GPU activity on all devices to be stopped.

* Default command:

  A default view has been added. The default view provides a snapshot of commonly requested information such as bdf, current partition mode, version information, and more. Users can access that information by simply typing `amd-smi` with no additional commands or arguments. Users may also obtain this information through alternate output formats such as json or csv by using the default command with the respective output format: `amd-smi default --json` or `amd-smi default --csv`.

* Support for GPU metrics 1.8:
  - Added new fields for `amdsmi_gpu_xcp_metrics_t` including:
    - Metrics to allow new calculations for violation status:
      - Per XCP metrics `gfx_below_host_limit_ppt_acc[XCP][MAX_XCC]` - GFX Clock Host limit Package Power Tracking violation counts
      - Per XCP metrics `gfx_below_host_limit_thm_acc[XCP][MAX_XCC]` - GFX Clock Host limit Thermal (TVIOL) violation counts
      - Per XCP metrics `gfx_low_utilization_acc[XCP][MAX_XCC]` - violation counts for how did low utilization caused the GPU to be below application clocks.
      - Per XCP metrics `gfx_below_host_limit_total_acc[XCP][MAX_XCC]`- violation counts for how long GPU was held below application clocks any limiter (see above new violation metrics).
  - Increased available JPEG engines to 40. Current ASICs might not support all 40. These are indicated as `UINT16_MAX` or `N/A` in CLI.

* Bad page threshold count.
  - Added `amdsmi_get_gpu_bad_page_threshold` to Python API and CLI; root/sudo permissions are required to display the count.

* CPU model name for RDC.
  - Added new C and Python API `amdsmi_get_cpu_model_name`.
  - Not sourced from esmi library.

* New API `amdsmi_get_cpu_affinity_with_scope()`.

* `socket power` to `amdsmi_get_power_info`
  - Previously, the C API had the value in the `amdsmi_power_info` structure, but was unused.
  - The value is representative of the socket's power agnostic of the the GPU version.

* New event notification types to `amdsmi_evt_notification_type_t`.
  The following values were added to the `amdsmi_evt_notification_type_t` enum:
  - `AMDSMI_EVT_NOTIF_EVENT_MIGRATE_START`
  - `AMDSMI_EVT_NOTIF_EVENT_MIGRATE_END`
  - `AMDSMI_EVT_NOTIF_EVENT_PAGE_FAULT_START`
  - `AMDSMI_EVT_NOTIF_EVENT_PAGE_FAULT_END`
  - `AMDSMI_EVT_NOTIF_EVENT_QUEUE_EVICTION`
  - `AMDSMI_EVT_NOTIF_EVENT_QUEUE_RESTORE`
  - `AMDSMI_EVT_NOTIF_EVENT_UNMAP_FROM_GPU`
  - `AMDSMI_EVT_NOTIF_PROCESS_START`
  - `AMDSMI_EVT_NOTIF_PROCESS_END`

- Power cap to `amd-smi monitor`.
  - `amd-smi monitor -p` will display the power cap along with power.

#### Changed

* Separated driver reload functionality from `amdsmi_set_gpu_memory_partition()` and
  `amdsmi_set_gpu_memory_partition_mode()` APIs -- and from the CLI `amd-smi set -M <NPS mode>`.

* Disabled `amd-smi monitor --violation` on guests. Modified `amd-smi metric -T/--throttle` to alias to `amd-smi metric -v/--violation`.

* Updated `amdsmi_get_clock_info` in `amdsmi_interface.py`.
  - The `clk_deep_sleep` field now returns the sleep integer value.

* The `amd-smi topology` command has been enabled for guest environments.
  - This includes full functionality so users can use the command just as they would in bare metal environments.

* Expanded violation status tracking for GPU metrics 1.8.
  - The driver will no longer be supporting existing single-value GFX clock below host limit fields (`acc_gfx_clk_below_host_limit`, `per_gfx_clk_below_host_limit`, `active_gfx_clk_below_host_limit`), they are now changed in favor of new per-XCP/XCC arrays.
  - Added new fields to `amdsmi_violation_status_t` and related interfaces for enhanced violation breakdown:
    - Per-XCP/XCC accumulators and status for:
      - GFX clock below host limit (power, thermal, and total)
      - Low utilization
    - Added 2D arrays to track per-XCP/XCC accumulators, percentage, and active status:
      - `acc_gfx_clk_below_host_limit_pwr`, `acc_gfx_clk_below_host_limit_thm`, `acc_gfx_clk_below_host_limit_total`
      - `per_gfx_clk_below_host_limit_pwr`, `per_gfx_clk_below_host_limit_thm`, `per_gfx_clk_below_host_limit_total`
      - `active_gfx_clk_below_host_limit_pwr`, `active_gfx_clk_below_host_limit_thm`, `active_gfx_clk_below_host_limit_total`
      - `acc_low_utilization`, `per_low_utilization`, `active_low_utilization`
  - Python API and CLI now report these expanded fields.

* The char arrays in the following structures have been changed.
  - `amdsmi_vbios_info_t` member `build_date` changed from `AMDSMI_MAX_DATE_LENGTH` to `AMDSMI_MAX_STRING_LENGTH`.
  - `amdsmi_dpm_policy_entry_t` member `policy_description` changed from `AMDSMI_MAX_NAME` to `AMDSMI_MAX_STRING_LENGTH`.
  - `amdsmi_name_value_t` member `name` changed from `AMDSMI_MAX_NAME` to `AMDSMI_MAX_STRING_LENGTH`.

* For backwards compatibility, updated `amdsmi_bdf_t` union to have an identical unnamed struct.

* Updated `amdsmi_get_temp_metric` and `amdsmi_temperature_type_t` with new values.
  - Added new values to `amdsmi_temperature_type_t` representing various baseboard and GPU board temperature measures.
  - Updated `amdsmi_get_temp_metric` API to be able to take in and return the respective values for the new temperature types.

#### Removed

- Unnecessary API, `amdsmi_free_name_value_pairs()`
  - This API is only used internally to free up memory from the Python interface and does not need to be
    exposed to the user.

- Unused definitions:
  - `AMDSMI_MAX_NAME`, `AMDSMI_256_LENGTH`, `AMDSMI_MAX_DATE_LENGTH`, `MAX_AMDSMI_NAME_LENGTH`, `AMDSMI_LIB_VERSION_YEAR`,
   `AMDSMI_DEFAULT_VARIANT`, `AMDSMI_MAX_NUM_POWER_PROFILES`, `AMDSMI_MAX_DRIVER_VERSION_LENGTH`.

- Unused member `year` in struct `amdsmi_version_t`.

- `amdsmi_io_link_type_t` has been replaced with `amdsmi_link_type_t`.
  - `amdsmi_io_link_type_t` is no longer needed as `amdsmi_link_type_t` is sufficient.
  - `amdsmi_link_type_t` enum has changed; primarily, the ordering of the PCI and XGMI types.
  - This change will also affect `amdsmi_link_metrics_t`, where the link_type field changes from `amdsmi_io_link_type_t` to `amdsmi_link_type_t`.

- `amdsmi_get_power_info_v2()`.
  - The ``amdsmi_get_power_info()`` has been unified and the v2 function is no longer needed or used.

- `AMDSMI_EVT_NOTIF_RING_HANG` event notification type in `amdsmi_evt_notification_type_t`.

- The `amdsmi_get_gpu_vram_info` now provides vendor names as a string.
  - `amdsmi_vram_vendor_type_t` enum structure is removed.
  - `amdsmi_vram_info_t` member named `amdsmi_vram_vendor_type_t` is changed to a character string.
  - `amdsmi_get_gpu_vram_info` now no longer requires decoding the vendor name as an enum.

- Backwards compatibility for `amdsmi_get_gpu_metrics_info()`'s,`jpeg_activity`and `vcn_activity` fields. Alternatively use `xcp_stats.jpeg_busy` or `xcp_stats.vcn_busy`. 
  - Backwards compatibility is removed for `jpeg_activity` and `vcn_activity` fields, if the `jpeg_busy` or `vcn_busy` field is available.
  - Providing both `vcn_activity`/`jpeg_activity` and XCP (partition) stats `vcn_busy`/`jpeg_busy` caused confusion about which field to use. By removing backward compatibility, it is easier to identify the relevant field.
  - The `jpeg_busy` field increased in size (for supported ASICs), making backward compatibility unable to fully copy the structure into `jpeg_activity`.

#### Optimized

- Reduced ``amd-smi`` CLI API calls needed to be called before reading or (re)setting GPU features. This
  improves overall runtime performance of the CLI.

- Removed partition information from the default `amd-smi static` CLI command.
  - Users can still retrieve the same data by calling `amd-smi`, `amd-smi static -p`, or `amd-smi partition -c -m`/`sudo amd-smi partition -a`.
  - Reading `current_compute_partition` may momentarily wake the GPU up. This is due to reading XCD registers, which is expected behavior. Changing partitions is not a trivial operation, `current_compute_partition` SYSFS controls this action.

- Optimized CLI command `amd-smi topology` in partition mode.
  - Reduced the number of `amdsmi_topo_get_p2p_status` API calls to one fourth.

#### Resolved issues

- Removed duplicated GPU IDs when receiving events using the `amd-smi event` command.

- Fixed `amd-smi monitor` decoder utilization (`DEC%`) not showing up on MI300 Series ASICs.

#### Known issues

- `amd-smi monitor` on Linux Guest systems triggers an attribute error.

### **Composable Kernel** (1.1.0) 

#### Added

* Support for `BF16`, `F32`, and `F16` for 2D and 3D NGCHW grouped convolution backward data.
* Fully asynchronous HOST (CPU) arguments copy flow for CK grouped GEMM kernels.
* Support GKCYX for layout for grouped convolution forward (NGCHW/GKCYX/NGKHW, number of instances in instance factory for NGCHW/GKYXC/NGKHW has been reduced).
* Support for GKCYX layout for grouped convolution forward (NGCHW/GKCYX/NGKHW).
* Support for GKCYX layout for grouped convolution backward weight (NGCHW/GKCYX/NGKHW).
* Support for GKCYX layout for grouped convolution backward data (NGCHW/GKCYX/NGKHW).
* Support for Stream-K version of mixed `FP8` / `BF16` GEMM.
* Support for Multiple D GEMM.
* GEMM pipeline for microscaling (MX) `FP8` / `FP6` / `FP4` data types.
* Support for `FP16` 2:4 structured sparsity to universal GEMM.
* Support for Split K for grouped convolution backward data.
* Logit soft-capping support for fMHA forward kernels.
* Support for hdim as a multiple of 32 for FMHA (fwd/fwd_splitkv).
* Benchmarking support for tile engine GEMM.
* Ping-pong scheduler support for GEMM operation along the K dimension.
* Rotating buffer feature for CK_Tile GEMM.
* `int8` support for CK_TILE GEMM.
* Vectorize Transpose optimization for CK Tile.
* Asynchronous copy for gfx950.

#### Changed

* Replaced the raw buffer load/store intrinsics with Clang20 built-ins.
* DL and DPP kernels are now enabled by default.
* Number of instances in instance factory for grouped convolution forward NGCHW/GKYXC/NGKHW has been reduced.
* Number of instances in instance factory for grouped convolution backward weight NGCHW/GKYXC/NGKHW has been reduced.
* Number of instances in instance factory for grouped convolution backward data NGCHW/GKYXC/NGKHW has been reduced.

#### Removed

* Removed support for gfx940 and gfx941 targets.

#### Optimized

* Optimized the GEMM multiply preshuffle and lds bypass with Pack of KGroup and better instruction layout.

### **HIP** 7.0.0

#### Added

* New HIP APIs
    - `hipLaunchKernelEx`  dispatches the provided kernel with the given launch configuration and forwards the kernel arguments.
    - `hipLaunchKernelExC`  launches a HIP kernel using a generic function pointer and the specified configuration.
    - `hipDrvLaunchKernelEx`  dispatches the device kernel represented by a HIP function object.
    - `hipMemGetHandleForAddressRange`  gets a handle for the address range requested.
    - `__reduce_add_sync`, `__reduce_min_sync`, and `__reduce_max_sync` functions added for aritimetic reduction across lanes of a warp, and `__reduce_and_sync`, `__reduce_or_sync`, and `__reduce_xor_sync` 
functions added for logical reduction. For details, see [Warp cross-lane functions](https://rocm.docs.amd.com/projects/HIP/en/latest/how-to/hip_cpp_language_extensions.html#warp-cross-lane-functions).
* New support for Open Compute Project (OCP) floating-point `FP4`/`FP6`/`FP8` as follows. For details, see [Low precision floating point document](https://rocm.docs.amd.com/projects/HIP/en/latest/reference/low_fp_types.html).
    - Data types for `FP4`/`FP6`/`FP8`.
    - HIP APIs for `FP4`/`FP6`/`FP8`, which are compatible with corresponding CUDA APIs.
    - HIP Extensions APIs for microscaling formats, which are supported on AMD GPUs.
* New `wptr` and `rptr` values in `ClPrint`, for better logging in dispatch barrier methods.
* The `_sync()` version of crosslane builtins such as `shfl_sync()` are enabled by default. These can be disabled by setting the preprocessor macro `HIP_DISABLE_WARP_SYNC_BUILTINS`.
* Added `constexpr` operators for `fp16`/`bf16`.
* Added warp level primitives: `__syncwarp` and reduce intrinsics (e.g. `__reduce_add_sync()`).
* Support for the flags in APIs as following, now allows uncached memory allocation.
    - `hipExtHostRegisterUncached`, used in `hipHostRegister`.
    - `hipHostMallocUncached` and `hipHostAllocUncached`, used in `hipHostMalloc` and `hipHostAlloc`.
* `num_threads`  total number of threads in the group. The legacy API size is alias.
* Added PCI CHIP ID information as the device attribute.
* Added new tests applications for OCP data types `FP4`/`FP6`/`FP8`.
* A new attribute in HIP runtime was implemented which exposes a new device capability of how many compute dies (chiplets, xcc) are available on a given GPU. Developers can get this attribute via the API `hipDeviceGetAttribute`, to make use of the best cache locality in a kernel, and optimize the Kernel launch grid layout, for performance improvement.

#### Changed
* Some unsupported GPUs such as gfx9, gfx8 and gfx7 are deprecated on Microsoft Windows.
* Removal of beta warnings in HIP Graph APIs. All Beta warnings in usage of HIP Graph APIs are removed, they are now officially and fully supported.
* `warpSize` has changed. 
In order to match the CUDA specification, the `warpSize` variable is no longer `constexpr`. In general, this should be a transparent change; however, if an application was using `warpSize` as a compile-time constant, it will have to be updated to handle the new definition. For more information, see the discussion of `warpSize` within the [HIP C++ language extensions](https://rocm.docs.amd.com/projects/HIP/en/latest/how-to/hip_cpp_language_extensions.html#warpsize).
* Behavior changes
    - `hipGetLastError`  now returns the error code which is the last actual error caught in the current thread during the application execution.
    - Cooperative groups  in `hipLaunchCooperativeKernelMultiDevice` and `hipLaunchCooperativeKernel` functions, additional input parameter validation checks are added.
    - `hipPointerGetAttributes` returns `hipSuccess` instead of an error with invalid value `hipErrorInvalidValue`, in case `NULL` host or attribute pointer is passed as input parameter. It now matches the functionality of `cudaPointerGetAttributes` which changed with CUDA 11 and above releases.
    - `hipFree` previously there was an implicit wait which was applicable for all memory allocations, for synchronization purpose. This wait is now disabled for allocations made with `hipMallocAsync` and `hipMallocFromPoolAsync`, to match the behavior of CUDA API `cudaFree`.
    - `hipFreeAsync` now returns `hipSuccess` when the input pointer is NULL, instead of ` hipErrorInvalidValue` , to be consistent with `hipFree`.
    - Exceptions occurring during a kernel execution will not abort the process anymore but will return an error unless core dump is enabled.
* Changes in hipRTC.
    - Removal of `hipRTC` symbols from HIP Runtime Library.
    Any application using `hipRTC` APIs should link explicitly with the `hipRTC` library. This makes the usage of `hipRTC` library on Linux the same as on Windows and matches the behavior of CUDA `nvRTC`.
    - `hipRTC` compilation
    The device code compilation now uses namespace `__hip_internal`, instead of the standard headers `std`, to avoid namespace collision.
    - Changes of datatypes from `hipRTC`.
    Datatype definitions such as `int64_t`, `uint64_t`, `int32_t`, and `uint32_t`, etc. are removed to avoid any potential conflicts in some applications. HIP now uses internal datatypes instead, prefixed with `__hip`, for example, `__hip_int64_t`.
* HIP header clean up
    - Usage of STD headers, HIP header files only include necessary STL headers.
    - Deprecated structure `HIP_MEMSET_NODE_PARAMS` is removed. Developers can use the definition `hipMemsetParams` instead.
* API signature/struct changes
    - API signatures are adjusted in some APIs to match corresponding CUDA APIs. Impacted APIs are as folloing:
      * `hiprtcCreateProgram`
      * `hiprtcCompileProgram`
      * `hipMemcpyHtoD`
      * `hipCtxGetApiVersion`
    - HIP struct change in `hipMemsetParams`, it is updated and compatible with CUDA.
    - HIP vector constructor change in `hipComplex` initialization now generates correct values. The affected constructors will be small vector types such as `float2`, `int4`, etc.
* Stream Capture updates
    - Restricted stream capture mode, it is made in HIP APIs via adding the macro `CHECK_STREAM_CAPTURE_SUPPORTED ()`.
In the previous HIP enumeration `hipStreamCaptureMode`, three capture modes were defined. With checking in the macro, the only supported stream capture mode is now `hipStreamCaptureModeRelaxed`. The rest are not supported, and the macro will return `hipErrorStreamCaptureUnsupported`. This update involves the following APIs, which is allowed only in relaxed stream capture mode:
      * `hipMallocManaged`
      * `hipMemAdvise`
    - Checks stream capture mode, the following APIs check the stream capture mode and return error codes to match the behavior of CUDA.
      * `hipLaunchCooperativeKernelMultiDevice`
      * `hipEventQuery`
      * `hipStreamAddCallback`
    - Returns error during stream capture. The following HIP APIs now returns specific error `hipErrorStreamCaptureUnsupported` on the AMD platform, but not always `hipSuccess`, to match behavior with CUDA:
      * `hipDeviceSetMemPool`
      * `hipMemPoolCreate`
      * `hipMemPoolDestroy`
      * `hipDeviceSetSharedMemConfig`
      * `hipDeviceSetCacheConfig`
      * `hipMemcpyWithStream`
* Error code update
Returned error/value codes are updated in the following HIP APIs to match the corresponding CUDA APIs.
    - Module Management Related APIs:
      * `hipModuleLaunchKernel`
      * `hipExtModuleLaunchKernel`
      * `hipExtLaunchKernel`
      * `hipDrvLaunchKernelEx`
      * `hipLaunchKernel`
      * `hipLaunchKernelExC`
      * `hipModuleLaunchCooperativeKernel`
      * `hipModuleLoad`
    - Texture Management Related APIs:
The following APIs update the return codes to match the behavior with CUDA:
      * `hipTexObjectCreate`, supports zero width and height for 2D image. If either is zero, will not return `false`.
      * `hipBindTexture2D`, adds extra check, if pointer for texture reference or device is NULL, returns `hipErrorNotFound`.
      * `hipBindTextureToArray`, if any NULL pointer is input for texture object, resource descriptor, or texture descriptor, returns error `hipErrorInvalidChannelDescriptor`, instead of `hipErrorInvalidValue`.
      * `hipGetTextureAlignmentOffset`, adds a return code `hipErrorInvalidTexture` when the texture reference pointer is NULL.
    - Cooperative Group Related APIs, more calidations are added in the following API implementation:
      * `hipLaunchCooperativeKernelMultiDevice`
      * `hipLaunchCooperativeKernel`
* Invalid stream input parameter handling
In order to match the CUDA runtime behavior more closely, HIP APIs with streams passed as input parameters no longer check the stream validity. Previously, the HIP runtime returned an error code `hipErrorContextIsDestroyed` if the stream was invalid. In CUDA version 12 and later, the equivalent behavior is to raise a segmentation fault. HIP runtime now matches the CUDA by causing a segmentation fault. The list of APIs impacted by this change are as follows:
    - Stream Management Related APIs
      * `hipStreamGetCaptureInfo`
      * `hipStreamGetPriority`
      * `hipStreamGetFlags`
      * `hipStreamDestroy`
      * `hipStreamAddCallback`
      * `hipStreamQuery`
      * `hipLaunchHostFunc`
    - Graph Management Related APIs
      * `hipGraphUpload`
      * `hipGraphLaunch`
      * `hipStreamBeginCaptureToGraph`
      * `hipStreamBeginCapture`
      * `hipStreamIsCapturing`
      * `hipStreamGetCaptureInfo`
      * `hipGraphInstantiateWithParams`
    - Memory Management Related APIs
      * `hipMemcpyPeerAsync`
      * `hipMemcpy2DValidateParams`
      * `hipMallocFromPoolAsync`
      * `hipFreeAsync`
      * `hipMallocAsync`
      * `hipMemcpyAsync`
      * `hipMemcpyToSymbolAsync`
      * `hipStreamAttachMemAsync`
      * `hipMemPrefetchAsync`
      * `hipDrvMemcpy3D`
      * `hipDrvMemcpy3DAsync`
      * `hipDrvMemcpy2DUnaligned`
      * `hipMemcpyParam2D`
      * `hipMemcpyParam2DAsync`
      * `hipMemcpy2DArrayToArray`
      * `hipMemcpy2D`
      * `hipMemcpy2DAsync`
      * `hipDrvMemcpy2DUnaligned`
      * `hipMemcpy3D`
    - Event Management Related APIs
      * `hipEventRecord`
      * `hipEventRecordWithFlags`

#### Optimized

HIP runtime has the following functional improvements which improves runtime performance and user experience:

* Reduced usage of the lock scope in events and kernel handling.
    - Switches to `shared_mutex` for event validation, uses `std::unique_lock` in HIP runtime to create/destroy event, instead of `scopedLock`.
    - Reduces the `scopedLock` in handling of kernel execution. HIP runtime now calls `scopedLock` during kernel binary creation/initialization, doesn't call it again during kernel vector iteration before launch.
* Implementation of unifying managed buffer and kernel argument buffer so HIP runtime doesn't need to create/load a separate kernel argument buffer.
* Refactored memory validation, creates a unique function to validate a variety of memory copy operations.
* Improved kernel logging using demangling shader names.
* Advanced support for SPIRV, now kernel compilation caching is enabled by default. This feature is controlled by the environment variable `AMD_COMGR_CACHE`, for details, see [hip_rtc document](https://rocm.docs.amd.com/projects/HIP/en/latest/how-to/hip_rtc.html).
* Programmatic support for scratch limits on the AMD Instinct MI300 and MI350 Series up GPU devices. More enumeration values were added in `hipLimit_t` as following:
   - `hipExtLimitScratchMin`, minimum allowed value in bytes for scratch limit on the device.
   - `hipExtLimitScratchMax`, maximum allowed value in bytes for scratch limit on the device.
   - `hipExtLimitScratchCurrent`, current scratch limit threshold in bytes on the device. Must be between the value `hipExtLimitScratchMin` and `hipExtLimitScratchMax`.
 Developers can now use the environment variable `HSA_SCRATCH_SINGLE_LIMIT_ASYNC` to change the default allocation size with expected scratch limit in ROCR runtime. On top of it, this value can also be overwritten programmatically in the application using the HIP API `hipDeviceSetLimit(hipExtLimitScratchCurrent, value)` to reset the scratch limit value.
* HIP runtime now enables peer-to-peer (P2P) memory copies to utilize all available SDMA engines, rather than being limited to a single engine. It also selects the best engine first to give optimal bandwidth.
* Improved launch latency for `D2D` copies and `memset` on MI300 Series.
* Introduced a threshold to handle the command submission patch to the GPU device(s), considering the synchronization with CPU, for performance improvement.

#### Resolved issues

* Error of "unable to find modules" in HIP clean up for code object module.
* The issue of incorrect return error `hipErrorNoDevice`, when a crash occurred on GPU device due to illegal operation or memory violation. HIP runtime now handles the failure on the GPU side properly and reports the precise error code based on the last error seen on the GPU.
* Failures in some framework test applications, HIP runtime fixed the bug in retrieving a memory object from the IPC memory handle.
* A crash in TensorFlow related application. HIP runtime now combines multiple definitions of `callbackQueue` into a single function, in case of an exception, passes its handler to the application and provides corresponding error code.
* Fixed issue of handling the kernel parameters for the graph launch.
* Failures in roc-obj tools. HIP runtime now makes `DEPRECATED` message in roc-obj tools as `STDERR`.
* Support of `hipDeviceMallocContiguous` flags in `hipExtMallocWithFlags()`. It now enables `HSA_AMD_MEMORY_POOL_CONTIGUOUS_FLAG` in the memory pool allocation on GPU device.
* Compilation failure, HIP runtime refactored the vector type alignment with `__hip_vec_align_v`.
* A numerical error/corruption found in Pytorch  during graph replay. HIP runtime fixed the input sizes of kernel launch dimensions in hipExtModuleLaunchKernel for the execution of hipGraph capture.
* A crash during kernel execution in a customer application. The structure of kernel arguments was updated via adding the size of kernel arguments, and HIP runtime does validation before launch kernel with the structured arguments.
* Compilation error when using bfloat16 functions. HIP runtime removed the anonymous namespace from FP16 functions to resolve this issue.

#### Known issues

* `hipLaunchHostFunc` returns an error during stream capture. Any application using `hipLaunchHostFunc` might fail to capture graphs during stream capture, instead, it returns `hipErrorStreamCaptureUnsupported`.
* Compilation failure in kernels via hiprtc when using option `std=c++11`.

### **hipBLAS** (3.0.0)

#### Added

* Added the `hipblasSetWorkspace()` API.
* Support for codecoverage tests.
  
#### Changed

* HIPBLAS_V2 API is the only available API using the `hipComplex` and `hipDatatype` types.
* Documentation updates.
* Verbose compilation for `hipblas.cpp`.

#### Removed

* `hipblasDatatype_t` type.
* `hipComplex` and `hipDoubleComplex` types.
* Support code for non-production gfx targets.

#### Resolved issues

* The build time `CMake` configuration for the dependency on `hipBLAS-common` is fixed.
* Compiler warnings for unhandled enumerations have been resolved.

### **hipBLASLt** (1.0.0)

#### Added

* Stream-K GEMM support has been enabled for the `FP32`, `FP16`, `BF16`, `FP8`, and `BF8` data types on the Instinct MI300A APU. To activate this feature, set the `TENSILE_SOLUTION_SELECTION_METHOD` environment variable to `2`, for example, `export TENSILE_SOLUTION_SELECTION_METHOD=2`.
* Fused Swish/SiLU GEMM (enabled by ``HIPBLASLT_EPILOGUE_SWISH_EXT`` and ``HIPBLASLT_EPILOGUE_SWISH_BIAS_EXT``).
* Support for ``HIPBLASLT_EPILOGUE_GELU_AUX_BIAS`` for gfx942.
* `HIPBLASLT_TUNING_USER_MAX_WORKSPACE` to constrain the maximum workspace size for user offline tuning.
* ``HIPBLASLT_ORDER_COL16_4R16`` and ``HIPBLASLT_ORDER_COL16_4R8`` to ``hipblasLtOrder_t`` to support `FP16`/`BF16` swizzle GEMM and `FP8` / `BF8` swizzle GEMM respectively.
* TF32 emulation on gfx950.
* Support for `FP6`, `BF6`, and `FP4` on gfx950.
* Support for block scaling by setting `HIPBLASLT_MATMUL_DESC_A_SCALE_MODE` and `HIPBLASLT_MATMUL_DESC_B_SCALE_MODE` to `HIPBLASLT_MATMUL_MATRIX_SCALE_VEC32_UE8M0`.

#### Changed

* The non-V2 APIs (``GemmPreference``, ``GemmProblemType``, ``GemmEpilogue``, ``GemmTuning``, ``GemmInputs``) in the cpp header are now the same as the V2 APIs (``GemmPreferenceV2``, ``GemmProblemTypeV2``, ``GemmEpilogueV2``, ``GemmTuningV2``, ``GemmInputsV2``). The original non-V2 APIs are removed.

#### Removed

* ``HIPBLASLT_MATMUL_DESC_A_SCALE_POINTER_VEC_EXT`` and ``HIPBLASLT_MATMUL_DESC_B_SCALE_POINTER_VEC_EXT`` are removed. Use the ``HIPBLASLT_MATMUL_DESC_A_SCALE_MODE`` and ``HIPBLASLT_MATMUL_DESC_B_SCALE_MODE`` attributes to set scalar (``HIPBLASLT_MATMUL_MATRIX_SCALE_SCALAR_32F``) or vector (``HIPBLASLT_MATMUL_MATRIX_SCALE_OUTER_VEC_32F``) attributes.
* The `hipblasltExtAMaxWithScale` API is removed.

#### Optimized

* Improved performance for 8-bit (`FP8` / `BF8` / `I8`) NN/NT cases by adding ``s_delay_alu`` to reduce stalls from dependent ALU operations on gfx12+.
* Improved performance for 8-bit and 16-bit (`FP16` / `BF16`) TN cases by enabling software dependency checks (Expert Scheduling Mode) under certain restrictions to reduce redundant hardware dependency checks on gfx12+.
* Improved performance for 8-bit, 16-bit, and 32-bit batched GEMM with a better heuristic search algorithm for gfx942.

#### Upcoming changes

* V2 APIs (``GemmPreferenceV2``, ``GemmProblemTypeV2``, ``GemmEpilogueV2``, ``GemmTuningV2``, ``GemmInputsV2``) are deprecated.

### **hipCUB** (4.0.0)

#### Added

* A new cmake option, `BUILD_OFFLOAD_COMPRESS`. When hipCUB is built with this option enabled, the `--offload-compress` switch is passed to the compiler. This causes the compiler to compress the binary that it generates. Compression can be useful in cases where you are compiling for a large number of targets, since this often results in a large binary. Without compression, in some cases, the generated binary may become so large that symbols are placed out of range, resulting in linking errors. The new `BUILD_OFFLOAD_COMPRESS` option is set to `ON` by default.
* Single pass operators in `agent/single_pass_scan_operators.hpp` which contains the following API:
  * `BlockScanRunningPrefixOp`
  * `ScanTileStatus`
  * `ScanTileState`
  * `ReduceByKeyScanTileState`
  * `TilePrefixCallbackOp`
* Support for gfx950.
* An overload of `BlockScan::InclusiveScan` that accepts an initial value to seed the scan.
* An overload of `WarpScan::InclusiveScan` that accepts an initial value to seed the scan.
* `UnrolledThreadLoad`, `UnrolledCopy`, and `ThreadLoadVolatilePointer` were added to align hipCUB with CUB.
* `ThreadStoreVolatilePtr` and the `IterateThreadStore` struct were added to align hipCUB with CUB.
* `hipcub::InclusiveScanInit` for CUB parity.

#### Changed

* The CUDA backend now requires CUB, Thrust, and libcu++ 2.7.0. If they aren't found, they will be downloaded from the CUDA CCCL repository.
* Updated `thread_load` and `thread_store` to align hipCUB with CUB.
* All kernels now have hidden symbol visibility. All symbols now have inline namespaces that include the library version, (for example, `hipcub::HIPCUB_300400_NS::symbol` instead of `hipcub::symbol`), letting the user link multiple libraries built with different versions of hipCUB.
* Modified the broadcast kernel in warp scan benchmarks. The reported performance may be different to previous versions.
* The `hipcub::detail::accumulator_t` in rocPRIM backend has been changed to utilise `rocprim::accumulator_t`.
* The usage of `rocprim::invoke_result_binary_op_t` has been replaced with `rocprim::accumulator_t`.

#### Removed

* The AMD GPU targets `gfx803` and `gfx900` are no longer built by default. If you want to build for these architectures, specify them explicitly in the `AMDGPU_TARGETS` cmake option.
* Deprecated `hipcub::AsmThreadLoad` is removed, use `hipcub::ThreadLoad` instead.
* Deprecated `hipcub::AsmThreadStore` is removed, use `hipcub::ThreadStore` instead.
* Deprecated `BlockAdjacentDifference::FlagHeads`, `BlockAdjacentDifference::FlagTails` and `BlockAdjacentDifference::FlagHeadsAndTails` have been removed.
* This release removes support for custom builds on gfx940 and gfx941.
* Removed C++14 support. Only C++17 is supported.

#### Resolved issues

* Fixed an issue where `Sort(keys, compare_op, valid_items, oob_default)` in `block_merge_sort.hpp` would not fill in elements that are out of range (items after `valid_items`) with `oob_default`.
* Fixed an issue where `ScatterToStripedFlagged` in `block_exhange.hpp` was calling the wrong function.

#### Known issues

* `BlockAdjacentDifference::FlagHeads`, `BlockAdjacentDifference::FlagTails` and `BlockAdjacentDifference::FlagHeadsAndTails` have been removed from hipCUB's CUB backend. They were already deprecated as of version 2.12.0 of hipCUB and they were removed from CCCL (CUB) as of CCCL's 2.6.0 release.
* `BlockScan::InclusiveScan` for the CUDA backend does not compute the block aggregate correctly when passing an initial value parameter. This behavior is not matched by the AMD backend.

#### Upcoming changes

* `BlockAdjacentDifference::FlagHeads`, `BlockAdjacentDifference::FlagTails` and `BlockAdjacentDifference::FlagHeadsAndTails` were deprecated as of version 2.12.0 of hipCUB, and will be removed from the rocPRIM backend in a future release for the next ROCm major version (ROCm 7.0.0).

### **hipFFT** (1.0.20)

#### Added

* Support for gfx950.

#### Removed

* Removed hipfft-rider legacy compatibility from clients.
* Removed support for the gfx940 and gfx941 targets from the client programs.
* Removed backward compatibility symlink for include directories.

### **hipfort** (0.7.0)

#### Added

* Documentation clarifying how hipfort is built for the CUDA platform.

#### Changed

* Updated and reorganized documentation for clarity and consistency.

### **HIPIFY** (20.0.0)

#### Added

* CUDA 12.9.1 support.
* cuDNN 9.11.0 support.
* cuTENSOR 2.2.0.0 support.
* LLVM 20.1.8 support.

#### Resolved issues

* `hipDNN` support is removed by default.
* [#1859](https://github.com/ROCm/HIPIFY/issues/1859)[hipify-perl] Fix warnings on unsupported Driver or Runtime APIs which were erroneously not reported.
* [#1930](https://github.com/ROCm/HIPIFY/issues/1930) Revise `JIT API`.
* [#1962](https://github.com/ROCm/HIPIFY/issues/1962) Support for cuda-samples helper headers.
* [#2035](https://github.com/ROCm/HIPIFY/issues/2035) Removed `const_cast<const char**>;` in `hiprtcCreateProgram` and `hiprtcCompileProgram`.

### **hipRAND** (3.0.0)

#### Added

* Support for gfx950.

#### Changed

* Deprecated the hipRAND Fortran API in favor of hipfort.
  
#### Removed
  
* Removed C++14 support, so only C++17 is supported.

### **hipSOLVER** (3.0.0)

#### Added

* Added compatibility-only functions:
  * csrlsvqr
    * `hipsolverSpCcsrlsvqr`, `hipsolverSpZcsrlsvqr`

#### Resolved issues
  
* Corrected the value of `lwork` returned by various `bufferSize` functions to be consistent with CUDA cuSOLVER. The following functions now return `lwork` so that the workspace size (in bytes) is `sizeof(T) * lwork`, rather than `lwork`. To restore the original behavior, set the environment variable `HIPSOLVER_BUFFERSIZE_RETURN_BYTES`.
  * `hipsolverXorgbr_bufferSize`, `hipsolverXorgqr_bufferSize`, `hipsolverXorgtr_bufferSize`, `hipsolverXormqr_bufferSize`, `hipsolverXormtr_bufferSize`, `hipsolverXgesvd_bufferSize`, `hipsolverXgesvdj_bufferSize`, `hipsolverXgesvdBatched_bufferSize`, `hipsolverXgesvdaStridedBatched_bufferSize`, `hipsolverXsyevd_bufferSize`, `hipsolverXsyevdx_bufferSize`, `hipsolverXsyevj_bufferSize`, `hipsolverXsyevjBatched_bufferSize`, `hipsolverXsygvd_bufferSize`, `hipsolverXsygvdx_bufferSize`, `hipsolverXsygvj_bufferSize`, `hipsolverXsytrd_bufferSize`, `hipsolverXsytrf_bufferSize`.

### **hipSPARSE** (4.0.1)

#### Added

* `int8`, `int32`, and `float16` data types to `hipDataTypeToHCCDataType` so that sparse matrix descriptors can be used with them.
* Half float mixed precision to `hipsparseAxpby` where X and Y use `float16` and the result and compute type use `float`.
* Half float mixed precision to `hipsparseSpVV` where X and Y use `float16` and the result and compute type use `float`.
* Half float mixed precision to `hipsparseSpMM` where A and B use `float16` and C and the compute type use `float`.
* Half float mixed precision to `hipsparseSDDMM` where A and B use `float16` and C and the compute type use `float`.
* Half float uniform precision to the `hipsparseScatter` and `hipsparseGather` routines.
* Half float uniform precision to the `hipsparseSDDMM` routine.
* `int8` precision to the `hipsparseCsr2cscEx2` routine.
* The `almalinux` operating system name to correct the GFortran dependency.

#### Changed

* Switched to defaulting to C++17 when building hipSPARSE from source. Previously hipSPARSE was using C++14 by default.
  
#### Resolved issues

* Fixed a compilation [issue](https://github.com/ROCm/hipSPARSE/issues/555) related to using `std::filesystem` and C++14.
* Fixed an issue where the clients-common package was empty by moving the `hipsparse_clientmatrices.cmake` and `hipsparse_mtx2csr` files to it.

#### Known issues
  
* In `hipsparseSpSM_solve()`, the external buffer is passed as a parameter. This does not match the CUDA cuSPARSE API. This extra external buffer parameter will be removed in a future release. For now, this extra parameter can be ignored and nullptr passed in because it is unused internally.

### **hipSPARSELt** (0.2.4)

#### Added

* Support for the LLVM target gfx950.
* Support for the following data type combinations for the LLVM target gfx950:
  * `FP8`(E4M3) inputs, `F32` output, and `F32` Matrix Core accumulation.
  * `BF8`(E5M2) inputs, `F32` output, and `F32` Matrix Core accumulation.
* Support for ROC-TX if `HIPSPARSELT_ENABLE_MARKER=1` is set.
* Support for the cuSPARSELt v0.6.3 backend.

#### Removed
  
* Support for LLVM targets gfx940 and gfx941 has been removed.
* `hipsparseLtDatatype_t` has been removed.
  
#### Optimized

* Improved the library loading time.
* Provided more kernels for the `FP16` data type.

### **hipTensor** (2.0.0)

#### Added

* Element-wise binary operation support.
* Element-wise trinary operation support.
* Support for GPU target gfx950.
* Dynamic unary and binary operator support for element-wise operations and permutation.
* CMake check for `f8` datatype availability.
* `hiptensorDestroyOperationDescriptor` to free all resources related to the provided descriptor.
* `hiptensorOperationDescriptorSetAttribute` to set attribute of a `hiptensorOperationDescriptor_t` object.
* `hiptensorOperationDescriptorGetAttribute` to retrieve an attribute of the provided `hiptensorOperationDescriptor_t` object.
* `hiptensorCreatePlanPreference` to allocate the `hiptensorPlanPreference_t` and enabled users to limit the applicable kernels for a given plan or operation.
* `hiptensorDestroyPlanPreference` to free all resources related to the provided preference.
* `hiptensorPlanPreferenceSetAttribute` to set attribute of a `hiptensorPlanPreference_t` object.
* `hiptensorPlanGetAttribute` to retrieve information about an already-created plan.
* `hiptensorEstimateWorkspaceSize` to determine the required workspace size for the given operation.
* `hiptensorCreatePlan` to allocate a `hiptensorPlan_t` object, select an appropriate kernel for a given operation and prepare a plan that encodes the execution.
* `hiptensorDestroyPlan` to free all resources related to the provided plan.

#### Changed

* Removed architecture support for gfx940 and gfx941.
* Generalized opaque buffer for any descriptor.
* Replaced `hipDataType` with `hiptensorDataType_t` for all supported types, for example, `HIP_R_32F` to `HIPTENSOR_R_32F`.
* Replaced `hiptensorComputeType_t` with `hiptensorComputeDescriptor_t` for all supported types.
* Replaced `hiptensorInitTensorDescriptor` with `hiptensorCreateTensorDescriptor`.
* Changed handle type and API usage from `*handle` to `handle`.
* Replaced `hiptensorContractionDescriptor_t` with `hipTensorOperationDescriptor_t`.
* Replaced `hiptensorInitContractionDescriptor` with `hiptensorCreateContraction`.
* Replaced `hiptensorContractionFind_t` with `hiptensorPlanPreference_t`.
* Replaced `hiptensorInitContractionFind` with `hiptensorCreatePlanPreference`.
* Replaced `hiptensorContractionGetWorkspaceSize` with `hiptensorEstimateWorkspaceSize`.
* Replaced `HIPTENSOR_WORKSPACE_RECOMMENDED` with `HIPTENSOR_WORKSPACE_DEFAULT`.
* Replaced `hiptensorContractionPlan_t` with `hiptensorPlan_t`.
* Replaced `hiptensorInitContractionPlan` with `hiptensorCreatePlan`.
* Replaced `hiptensorContraction` with `hiptensorContract`.
* Replaced `hiptensorPermutation` with `hiptensorPermute`.
* Replaced `hiptensorReduction` with `hiptensorReduce`.
* Replaced `hiptensorElementwiseBinary` with `hiptensorElementwiseBinaryExecute`.
* Replaced `hiptensorElementwiseTrinary` with `hiptensorElementwiseTrinaryExecute`.
* Removed function `hiptensorReductionGetWorkspaceSize`.

### **llvm-project** (20.0.0)

#### Added

* The compiler `-gsplit-dwarf` option to enable the generation of separate debug information file at compile time. When used, separate debug information files are generated for host and for each offload architecture. For additional information, see [DebugFission](https://gcc.gnu.org/wiki/DebugFission). 
* `llvm-flang`, AMD's next-generation Fortran compiler. It's a re-implementation of the Fortran frontend that can be found at `llvm/llvm-project/flang` on GitHub.
* Comgr support for an in-memory virtual file system (VFS) for storing temporary files generated during intermediate compilation steps to improve performance in the device library link step.
* Compiler support of a new target-specific builtin `__builtin_amdgcn_processor_is` for late or deferred queries of the current target processor, and  `__builtin_amdgcn_is_invocable` to determine the current target processor ability to invoke a particular builtin. 
* HIPIFY support for CUDA 12.9.1 APIs. Added support for all new device and host APIs, including FP4, FP6, and FP128, and support for the corresponding ROCm HIP equivalents.

#### Changed

* Updated clang/llvm to AMD clang version 20.0.0 (equivalent to LLVM 20.0.0 with additional out-of-tree patches).
* HIPCC Perl scripts (`hipcc.pl` and `hipconfig.pl`) have been removed from this release.

#### Optimized

* Improved compiler memory load and store instructions. 

#### Upcoming changes

* `__AMDGCN_WAVEFRONT_SIZE__` macro and HIP’s `warpSize` variable as `constexpr` are deprecated and will be disabled in a future release. Users are encouraged to update their code if needed to ensure future compatibility. For more information, see [AMDGCN_WAVEFRONT_SIZE deprecation](#amdgpu-wavefront-size-compiler-macro-deprecation).
* The `roc-obj-ls` and `roc-obj-extract` tools are  deprecated. To extract all Clang offload bundles into separate code objects use `llvm-objdump --offloading <file>`. For more information, see [Changes to ROCm Object Tooling](#changes-to-rocm-object-tooling). 

### **MIGraphX** (2.13.0)

#### Added

* Support for OCP `FP8` on AMD Instinct MI350X GPUs.
* Support for PyTorch 2.7 via Torch-MIGraphX.
* Support for the Microsoft ONNX Contrib Operators (Self) Attention, RotaryEmbedding, QuickGelu, BiasAdd, BiasSplitGelu, SkipLayerNorm.
* Support for Sigmoid and AddN TensorFlow operators.
* GroupQuery Attention support for LLMs.
* Support for edge mode in the ONNX Pad operator.
* ONNX runtime Python driver.
* FLUX e2e example.
* C++ and Python APIs to save arguments to a graph as a msgpack file, and then read the file back.
* rocMLIR fusion for kv-cache attention.
* Introduced a check for file-write errors.

#### Changed

* `quantize_bf16` for quantizing the model to `BF16` has been made visible in the MIGraphX user API.
* Print additional kernel/module information in the event of compile failure.
* Use hipBLASLt instead of rocBLAS on newer GPUs.
* 1x1 convolutions are now rewritten to GEMMs.
* `BF16::max` is now represented by its encoding rather than its expected value.
* Direct warnings now go to `cout` rather `cerr`.
* `FP8` uses hipBLASLt rather than rocBLAS.
* ONNX models are now topologically sorted when nodes are unordered.
* Improved layout of Graphviz output.
* Enhanced debugging for migraphx-driver: consumed environment variables are printed, timestamps and duration are added to the summary.
* Add a trim size flag to the verify option for migraphx-driver.
* Node names are printed to track parsing within the ONNX graph when using the `MIGRAPHX_TRACE_ONNX_PARSER` flag.
* Update accuracy checker to output test data with the `--show-test-data` flag.
* The `MIGRAPHX_TRACE_BENCHMARKING` option now allows the problem cache file to be updated after finding the best solution. 

#### Removed

* `ROCM_USE_FLOAT8` macro.
* The `BF16` GEMM test was removed for Navi21, as it is unsupported by rocBLAS and hipBLASLt on that platform.

#### Optimized

* Use common average in `compile_ops` to reduce run-to-run variations when tuning.
* Improved the performance of the TopK operator.
* Conform to a single layout (NHWC or NCHW) during compilation rather than combining two.
* Slice Channels Conv Optimization (slice output fusion).
* Horizontal fusion optimization after pointwise operations.
* Reduced the number of literals used in `GridSample` linear sampler. 
* Fuse multiple outputs for pointwise operations.
* Fuse reshapes on pointwise inputs for MLIR output fusion.
* MUL operation not folded into the GEMM when the GEMM is used more than once.
* Broadcast not fused after convolution or GEMM MLIR kernels.
* Avoid reduction fusion when operator data-types mismatch.

#### Resolved issues

* Compilation workaround ICE in clang 20 when using `views::transform`.
* Fix bug with `reshape_lazy` in MLIR.
* Quantizelinear fixed for Nearbyint operation.
* Check for empty strings in ONNX node inputs for operations like Resize.
* Parse Resize fix: only check `keep_aspect_ratio_policy` attribute for sizes input.
* Nonmaxsuppression: fixed issue where identical boxes/scores not ordered correctly.
* Fixed a bug where events were created on the wrong device in a multi-gpu scenario.
* Fixed out of order keys in value for comparisons and hashes when caching best kernels.
* Fixed Controlnet MUL types do not match error.
* Fixed check for scales if ROI input is present in Resize operation.
* Einsum: Fixed a crash on empty squeeze operations.

### **MIOpen** (3.5.0)

#### Added
  
* [Conv] Misa kernels for gfx950.
* [Conv] Enabled Split-K support for CK backward data solvers (2D).
* [Conv] Enabled CK wrw solver on gfx950 for the `BF16` data type.
* [BatchNorm] Enabled NHWC in OpenCL.
* Grouped convolution + activation fusion.
* Grouped convolution + bias + activation fusion.
* Composable Kernel (CK) can now be built inline as part of MIOpen.

#### Changed

* Changed to using the median value with outliers removed when deciding on the best solution to run.
* [Conv] Updated the igemm asm solver.

#### Optimized

* [BatchNorm] Optimized NHWC OpenCL kernels and improved heuristics.
* [RNN] Dynamic algorithm optimization.
* [Conv] Eliminated redundant clearing of output buffers.
* [RNN] Updated selection heuristics.
* Updated tuning for the AMD Instinct MI300 Series.

#### Resolved issues

* Fixed a segmentation fault when the user specified a smaller workspace than what was required.
* Fixed a layout calculation logic error that returned incorrect results and enabled less restrictive layout selection.
* Fixed memory access faults in misa kernels due to out-of-bounds memory usage.
* Fixed a performance drop on the gfx950 due to transpose kernel use.
* Fixed a memory access fault caused by not allocating enough workspace.
* Fixed a name typo that caused kernel mismatches and long startup times.

### **MIVisionX** (3.3.0)

#### Added

* Support to enable/disable BatchPD code in VX_RPP extensions by checking the RPP_LEGACY_SUPPORT flag.

#### Changed

* VX_RPP extension: Version 3.1.0 release.
* Update the parameters and kernel API of Blur, Fog, Jitter, LensCorrection, Rain, Pixelate, Vignette and ResizeCrop wrt tensor kernels replacing the legacy BatchPD API calls in VX_RPP extensions.

#### Known issues

* Installation on RHEL and SLES requires the manual installation of the `FFMPEG` and `OpenCV` dev packages.

#### Upcoming changes

* Optimized audio augmentations support for VX_RPP.

### **RCCL** (2.26.6)

#### Added

* Support for the extended fine-grained system memory pool.
* Support for gfx950.
* Support for `unroll=1` in device-code generation to improve performance.
* Set a default of 112 channels for a single node with `8 * gfx950`.
* Enabled LL128 protocol on the gfx950.
* The ability to choose the unroll factor at runtime using `RCCL_UNROLL_FACTOR`. This can be set at runtime to 1, 2, or 4. This change currently increases compilation and linking time because it triples the number of kernels generated.
* Added MSCCL support for AllGather multinode on the gfx942 and gfx950 (for instance, 16 and 32 GPUs). To enable this feature, set the environment variable `RCCL_MSCCL_FORCE_ENABLE=1`. The maximum message size for MSCCL AllGather usage is `12292 * sizeof(datatype) * nGPUs`.
* Thread thresholds for LL/LL128 are selected in Tuning Models for the AMD Instinct MI300X. This impacts the number of channels used for AllGather and ReduceScatter. The channel tuning model is bypassed if `NCCL_THREAD_THRESHOLDS`, `NCCL_MIN_NCHANNELS`, or `NCCL_MAX_NCHANNELS` are set.
* Multi-node tuning for AllGather, AllReduce, and ReduceScatter that leverages LL/LL64/LL128 protocols to use nontemporal vector load/store for tunable message size ranges.
* LL/LL128 usage ranges for AllReduce, AllGather, and ReduceScatter are part of the tuning models, which enable architecture-specific tuning in conjunction with the existing Rome Models scheme in RCCL.
* Two new APIs are exposed as part of an initiative to separate RCCL code. These APIs are `rcclGetAlgoInfo` and `rcclFuncMaxSendRecvCount`. However, user-level invocation requires that RCCL be built with `RCCL_EXPOSE_STATIC` enabled.

#### Changed

* Compatibility with NCCL 2.23.4.
* Compatibility with NCCL 2.24.3.
* Compatibility with NCCL 2.25.1.
* Compatibility with NCCL 2.26.6.

#### Optimized
* Improved the performance of the `FP8` Sum operation by upcasting to `FP16`.

#### Resolved issues

* Resolved an issue when using more than 64 channels when multiple collectives are used in the same `ncclGroup()` call.
* Fixed unit test failures in tests ending with the `ManagedMem` and `ManagedMemGraph` suffixes.
* Fixed a suboptimal algorithmic switching point for AllReduce on the AMD Instinct MI300X.
* Fixed broken functionality within the LL protocol on gfx950 by disabling inlining of LLGenericOp kernels.
* Fixed the known issue "When splitting a communicator using `ncclCommSplit` in some GPU configurations, MSCCL initialization can cause a segmentation fault" with a design change to use `comm` instead of `rank` for `mscclStatus`. The global map for `comm` to `mscclStatus` is still not thread safe but should be explicitly handled by mutexes for read-write operations. This is tested for correctness, but there is a plan to use a thread-safe map data structure in an upcoming release.

### **rocAL** (2.3.0)

#### Added
* Extended support to rocAL's video decoder to use rocDecode hardware decoder.
* Setup - installs rocdecode dev packages for Ubuntu, RedHat, and SLES.
* Setup - installs turbojpeg dev package for Ubuntu and Redhat.
* rocAL's image decoder has been extended to support the rocJPEG hardware decoder.
* Numpy reader support for reading npy files in rocAL.
* Test case for numpy reader in C++ and python tests.

#### Resolved issues
* `TurboJPEG` no longer needs to be installed manually. It is now installed by the package installer.
* Hardware decode no longer requires that ROCm be installed with the `graphics` usecase.

#### Known issues
* Package installation on SLES requires manually installing `TurboJPEG`.
* Package installation on RHEL and SLES requires manually installing the `FFMPEG Dev` package.

#### Upcoming changes

* rocJPEG support for JPEG decode.

### **rocALUTION** (4.0.0)

#### Added

* Support for gfx950.

#### Changed

* Switch to defaulting to C++17 when building rocALUTION from source. Previously rocALUTION was using C++14 by default.

#### Optimized

* Improved the user documentation.

#### Resolved issues

* Fix for GPU hashing algorithm when not compiling with -O2/O3.

### **rocBLAS** (5.0.0)

#### Added

* Support for gfx950.
* Internal API logging for `gemm` debugging using `ROCBLAS_LAYER = 8`.
* Support for the AOCL 5.0 gcc build as a client reference library.
* The use of `PkgConfig` for client reference library fallback detection.

#### Changed

* `CMAKE_CXX_COMPILER` is now passed on during compilation for a Tensile build.
* The default atomics mode is changed from `allowed` to `not allowed`.

#### Removed

* Support code for non-production gfx targets.
* `rocblas_hgemm_kernel_name`, `rocblas_sgemm_kernel_name`, and `rocblas_dgemm_kernel_name` API functions.
* The use of `warpSize` as a constexpr.
* The use of deprecated behavior of `hipPeekLastError`.
* `rocblas_float8.h` and `rocblas_hip_f8_impl.h` files.
* `rocblas_gemm_ex3`, `rocblas_gemm_batched_ex3`, and `rocblas_gemm_strided_batched_ex3` API functions.

#### Optimized

* Optimized `gemm` by using `gemv` kernels when applicable.
* Optimized `gemv` for small `m` and `n` with a large batch count on gfx942.
* Improved the performance of Level 1 `dot` for all precisions and variants when `N > 100000000` on gfx942.
* Improved the performance of Level 1 `asum` and `nrm2` for all precisions and variants on gfx942.
* Improved the performance of Level 2 `sger` (single precision) on gfx942.
* Improved the performance of Level 3 `dgmm` for all precisions and variants on gfx942.

#### Resolved issues
  
* Fixed environment variable path-based logging to append multiple handle outputs to the same file.
* Support numerics when `trsm` is running with `rocblas_status_perf_degraded`.
* Fixed the build dependency installation of `joblib` on some operating systems.
* Return `rocblas_status_internal_error` when `rocblas_[set,get]_ [matrix,vector]` is called with a host pointer in place of a device pointer.
* Reduced the default verbosity level for internal GEMM backend information.
* Updated from the deprecated rocm-cmake to ROCmCMakeBuildTools.
* Corrected AlmaLinux GFortran package dependencies.

#### Upcoming changes

* Deprecated the use of negative indices to indicate the default solution is being used for `gemm_ex` with `rocblas_gemm_algo_solution_index`.

### **ROCdbgapi** (0.77.3)

#### Added
* Support for the `gfx950` architectures.

#### Removed
* Support for the `gfx940` and `gfx941` architectures.

### **rocDecode** (1.0.0)

#### Added

* VP9 IVF container file parsing support in bitstream reader.
* CTest for VP9 decode on bitstream reader.
* HEVC/AVC/AV1/VP9 stream syntax error handling.
* HEVC stream bit depth change handling and DPB buffer size change handling through decoder reconfiguration.
* AVC stream DPB buffer size change handling through decoder reconfiguration.
* A new avcodec-based decoder built as a separate `rocdecode-host` library.

#### Changed

* rocDecode now uses the Cmake `CMAKE_PREFIX_PATH` directive.
* Changed asserts in query API calls in RocVideoDecoder utility class to error reports, to avoid hard stop during query in case error occurs and to let the caller decide actions.
* `libdrm_amdgpu` is now explicitly linked with rocdecode.

#### Removed

* `GetStream()` interface call from RocVideoDecoder utility class.

#### Optimized

* Decode session starts latency reduction.
* Bitstream type detection optimization in bitstream reader.

#### Resolved issues

* Fixed a bug in the `videoDecodePicFiles` picture files sample that can results in incorrect output frame count.
* Fixed a decoded frame output issue in video size change cases.
* Removed incorrect asserts of `bitdepth_minus_8` in `GetBitDepth()` and `num_chroma_planes` in `GetNumChromaPlanes()` API calls in the RocVideoDecoder utility class.

### **rocFFT** (1.0.34)

#### Added

* Support for gfx950.

#### Removed

* Removed ``rocfft-rider`` legacy compatibility from clients.
* Removed support for the gfx940 and gfx941 targets from the client programs.
* Removed backward compatibility symlink for include directories.

#### Optimized

* Removed unnecessary HIP event/stream allocation and synchronization during MPI transforms.
* Implemented single-precision 1D kernels for lengths:
  - 4704
  - 5488
  - 6144
  - 6561
  - 8192
* Implemented single-kernel plans for some large 1D problem sizes, on devices with at least 160KiB of LDS.

#### Resolved issues

* Fixed kernel faults on multi-device transforms that gather to a single device, when the input/output bricks are not 
  contiguous.

### **ROCgdb** (16.3)

#### Added

- Support for the `gfx950` architectures.

#### Removed

- Support for the `gfx940` and `gfx941` architectures.

### **rocJPEG** (1.1.0)

#### Added
* cmake config files.
* CTEST - New tests were introduced for JPEG batch decoding using various output formats, such as yuv_planar, y, rgb, and rgb_planar, both with and without region-of-interest (ROI).

#### Changed
* Readme - cleanup and updates to pre-reqs.
* The `decode_params` argument of the `rocJpegDecodeBatched` API is now an array of `RocJpegDecodeParams` structs representing the decode parameters for the batch of JPEG images.
* `libdrm_amdgpu` is now explicitly linked with rocjpeg.

#### Removed
* Dev Package - No longer installs pkg-config.

#### Resolved issues
* Fixed a bug that prevented copying the decoded image into the output buffer when the output buffer is larger than the input image.
* Resolved an issue with resizing the internal memory pool by utilizing the explicit constructor of the vector's type during the resizing process.
* Addressed and resolved CMake configuration warnings.

### **ROCm Bandwidth Test** (2.6.0)

#### Added

* Plugin architecture:
  * `rocm_bandwidth_test` is now the `framework` for individual `plugins` and features. The `framework` is available at: `/opt/rocm/bin/`

  * Individual `plugins`: The `plugins` (shared libraries) are available at: `/opt/rocm/lib/rocm_bandwidth_test/plugins/`

```{note}
Review the [README](https://github.com/ROCm/rocm_bandwidth_test/blob/amd-mainline/README.md) file for details about the new options and outputs.
```

#### Changed

* The `CLI` and options/parameters have changed due to the new plugin architecture, where the plugin parameters are parsed by the plugin.

#### Removed

- The old CLI, parameters, and switches.

### **ROCm Compute Profiler** (3.2.3)

#### Added

##### CDNA4 (AMD Instinct MI350/MI355) support

* Support for AMD Instinct MI350 Series GPUs with the addition of the following counters:
  * VALU co-issue (Two VALUs are issued instructions) efficiency
  * Stream Processor Instruction (SPI) Wave Occupancy
  * Scheduler-Pipe Wave Utilization
  * Scheduler FIFO Full Rate
  * CPC ADC Utilization
  * F6F4 data type metrics
  * Update formula for total FLOPs while taking into account F6F4 ops
  * LDS STORE, LDS LOAD, LDS ATOMIC instruction count metrics
  * LDS STORE, LDS LOAD, LDS ATOMIC bandwidth metrics
  * LDS FIFO full rate
  * Sequencer -> TA ADDR Stall rates
  * Sequencer -> TA CMD Stall rates
  * Sequencer -> TA DATA Stall rates
  * L1 latencies
  * L2 latencies
  * L2 to EA stalls
  * L2 to EA stalls per channel

* Roofline support for AMD Instinct MI350 Series GPUs.

##### Textual User Interface (TUI) (beta version)

* Text User Interface (TUI) support for analyze mode
  * A command line based user interface to support interactive single-run analysis.
  * To launch, use `--tui` option in analyze mode. For example, ``rocprof-compute analyze --tui``.

##### PC Sampling (beta version)

* Stochastic (hardware-based) PC sampling has been enabled for AMD Instinct MI300X Series and later GPUs.

* Host-trap PC Sampling has been enabled for AMD Instinct MI200 Series and later GPUs.

* Support for sorting of PC sampling by type: offset or count.

* PC Sampling Support on CLI and TUI analysis.

##### Roofline

* Support for Roofline plot on CLI (single run) analysis.

* `FP4` and `FP6` data types have been added for roofline profiling on AMD Instinct MI350 Series.

##### rocprofv3 support

* ``rocprofv3`` is supported as the default backend for profiling.
* Support to obtain performance information for all channels for TCC counters.
* Support for profiling on AMD Instinct MI 100 using ``rocprofv3``.
* Deprecation warning for ``rocprofv3`` interface in favor of the ROCprofiler-SDK interface, which directly accesses ``rocprofv3`` C++ tool.

##### Others

* Docker files to package the application and dependencies into a single portable and executable standalone binary file.

* Analysis report based filtering
  * ``-b`` option in profile mode now also accepts metric id(s) for analysis report based filtering.
  * ``-b`` option in profile mode also accepts hardware IP block for filtering; however, this filter support will be deprecated soon.
  * ``--list-metrics`` option added in profile mode to list possible metric id(s), similar to analyze mode.

* Support MEM chart on CLI (single run).

* ``--specs-correction`` option to provide missing system specifications for analysis.

#### Changed

* Changed the default ``rocprof`` version to ``rocprofv3``. This is used when environment variable ``ROCPROF`` is not set.
* Changed ``normal_unit`` default to ``per_kernel``.
* Decreased profiling time by not collecting unused counters in post-analysis.
* Updated Dash to >=3.0.0 (for web UI).
* Changed the condition when Roofline PDFs are generated during general profiling and ``--roof-only`` profiling (skip only when ``--no-roof`` option is present).
* Updated Roofline binaries:
  * Rebuild using latest ROCm stack.
  * Minimum OS distribution support minimum for roofline feature is now Ubuntu 22.04, RHEL 8, and SLES15 SP6.

#### Removed

* Roofline support for Ubuntu 20.04 and SLES below 15.6.
* Removed support for AMD Instinct MI50 and MI60.

#### Optimized

* ROCm Compute Profiler CLI has been improved to better display the GPU architecture analytics.

#### Resolved issues

* Fixed kernel name and kernel dispatch filtering when using ``rocprofv3``.
* Fixed an issue of TCC channel counters collection in ``rocprofv3``.
* Fixed peak FLOPS of `F8`, `I8`, `F16`, and `BF16` on AMD Instinct MI300.
* Fixed not detecting memory clock issue when using ``amd-smi``.
* Fixed standalone GUI crashing.
* Fixed L2 read/write/atomic bandwidths on AMD Instinct MI350 Series.

#### Known issues

* On AMD Instinct MI100, accumulation counters are not collected, resulting in the following metrics failing to show up in the analysis: Instruction Fetch Latency, Wavefront Occupancy, LDS Latency.
  * As a workaround, use the environment variable ``ROCPROF=rocprof``, to use ``rocprof v1`` for profiling on AMD Instinct MI100.

* GPU id filtering is not supported when using ``rocprofv3``.

* Analysis of previously collected workload data will not work due to sysinfo.csv schema change.
  * As a workaround, re-run the profiling operation for the workload and interrupt the process after 10 seconds.
  Followed by copying the ``sysinfo.csv`` file from the new data folder to the old one.
  This assumes your system specification hasn't changed since the creation of the previous workload data.

* Analysis of new workloads might require providing shader/memory clock speed using
``--specs-correction`` operation if amd-smi or rocminfo does not provide clock speeds.

* Memory chart on ROCm Compute Profiler CLI might look corrupted if the CLI width is too narrow.

* Roofline feature is currently not functional on Azure Linux 3.0 and Debian 12.

#### Upcoming changes

* ``rocprof v1/v2/v3`` interfaces will be removed in favor of the ROCprofiler-SDK interface, which directly accesses ``rocprofv3`` C++ tool. Using ``rocprof v1/v2/v3`` interfaces will trigger a deprecation warning.
  * To use ROCprofiler-SDK interface, set environment variable `ROCPROF=rocprofiler-sdk` and optionally provide profile mode option ``--rocprofiler-sdk-library-path /path/to/librocprofiler-sdk.so``. Add ``--rocprofiler-sdk-library-path`` runtime option to choose the path to ROCprofiler-SDK library to be used.
* Hardware IP block based filtering using ``-b`` option in profile mode will be removed in favor of analysis report block based filtering using ``-b`` option in profile mode.
* MongoDB database support will be removed, and a deprecation warning has been added to the application interface.
* Usage of ``rocm-smi`` is deprecated in favor of ``amd-smi``, and a deprecation warning has been added to the application interface.

### **ROCm Data Center Tool** (1.1.0)

#### Added

* More profiling and monitoring metrics, especially for AMD Instinct MI300 and newer GPUs.
* Advanced logging and debugging options, including new log levels and troubleshooting guidance.

#### Changed

* Completed migration from legacy [ROCProfiler](https://rocm.docs.amd.com/projects/rocprofiler/en/latest/) to [ROCprofiler-SDK](https://rocm.docs.amd.com/projects/rocprofiler-sdk/en/latest/).
* Reorganized the configuration files internally and improved [README/installation](https://github.com/ROCm/rdc/blob/release/rocm-rel-7.0/README.md) instructions.
* Updated metrics and monitoring support for the latest AMD data center GPUs.

#### Optimized

- Integration with [ROCprofiler-SDK](https://rocm.docs.amd.com/projects/rocprofiler-sdk/en/latest/) for performance metrics collection.
- Standalone and embedded operating modes, including streamlined authentication and configuration options.
- Support and documentation for diagnostic commands and GPU group management.
- [RVS](https://rocm.docs.amd.com/projects/ROCmValidationSuite/en/latest/) test integration and reporting.

### **ROCm SMI** (7.8.0)

#### Added

- Support for GPU metrics 1.8.  
  - Added new fields for `rsmi_gpu_metrics_t` including:  
    - Adding the following metrics to allow new calculations for violation status:
    - Per XCP metrics `gfx_below_host_limit_ppt_acc[XCP][MAX_XCC]` - GFX Clock Host limit Package Power Tracking violation counts.
    - Per XCP metrics `gfx_below_host_limit_thm_acc[XCP][MAX_XCC]` - GFX Clock Host limit Thermal (TVIOL) violation counts.
    - Per XCP metrics `gfx_low_utilization_acc[XCP][MAX_XCC]` - violation counts for how did low utilization caused the GPU to be below application clocks.
    - Per XCP metrics `gfx_below_host_limit_total_acc[XCP][MAX_XCC]`- violation counts for how long GPU was held below application clocks any limiter (see above new violation metrics).
  - Increasing available JPEG engines to 40.  
  Current ASICs may not support all 40. These will be indicated as UINT16_MAX or N/A in CLI.

#### Removed

- Removed backwards compatibility for `rsmi_dev_gpu_metrics_info_get()`'s `jpeg_activity` and `vcn_activity` fields. Alternatively use `xcp_stats.jpeg_busy` and `xcp_stats.vcn_busy`.
  - Backwards compatibility is removed for `jpeg_activity` and `vcn_activity` fields, if the `jpeg_busy` or `vcn_busy` field is available.
      - Providing both `vcn_activity`/`jpeg_activity` and XCP (partition) stats `vcn_busy`/`jpeg_busy` caused confusion for users about which field to use. By removing backward compatibility, it is easier to identify the relevant field.
      - The `jpeg_busy` field increased in size (for supported ASICs), making backward compatibility unable to fully copy the structure into `jpeg_activity`.

```{note}
See the full [ROCm SMI changelog](https://github.com/ROCm/rocm_smi_lib/blob/release/rocm-rel-7.0/CHANGELOG.md) for details, examples, and in-depth descriptions.
```

### **ROCm Systems Profiler** (1.1.0)

#### Added

- Profiling and metric collection capabilities for VCN engine activity, JPEG engine activity, and API tracing for rocDecode, rocJPEG, and VA-APIs.
- How-to document for VCN and JPEG activity sampling and tracing.
- Support for tracing Fortran applications.
- Support for tracing MPI API in Fortran.

#### Changed

- Replaced ROCm SMI backend with AMD SMI backend for collecting GPU metrics.
- ROCprofiler-SDK is now used to trace RCCL API and collect communication counters.
  - Use the setting `ROCPROFSYS_USE_RCCLP = ON` to enable profiling and tracing of RCCL application data.
- Updated the Dyninst submodule to v13.0.
- Set the default value of `ROCPROFSYS_SAMPLING_CPUS` to `none`.

#### Resolved issues

- Fixed GPU metric collection settings with `ROCPROFSYS_AMD_SMI_METRICS`.
- Fixed a build issue with CMake 4.
- Fixed incorrect kernel names shown for kernel dispatch tracks in Perfetto.
- Fixed formatting of some output logs.

### **ROCm Validation Suite** (1.2.0)

#### Added

- Support for AMD Instinct MI350X and MI355X GPUs.
- Introduced rotating buffer mechanism for GEMM operations.
- Support for read and write tests in Babel.
- Support for AMD Radeon RX9070 and RX9070GRE graphics cards.

#### Changed

- Migrated SMI API usage from `rocm-smi` to `amd-smi`.
- Updated `FP8` GEMM operations to use hipBLASLt instead of rocBLAS.

### **rocPRIM** (4.0.0)

#### Added

* Support for gfx950.
* `rocprim::accumulator_t` to ensure parity with CCCL.
* Test for `rocprim::accumulator_t`.
* `rocprim::invoke_result_r` to ensure parity with CCCL.
* Function `is_build_in` into `rocprim::traits::get`.
* Virtual shared memory as a fallback option in `rocprim::device_merge` when it exceeds shared memory capacity, similar to `rocprim::device_select`, `rocprim::device_partition`, and `rocprim::device_merge_sort`, which already include this feature.
* Initial value support to device level inclusive scans.
* New optimization to the backend for `device_transform` when the input and output are pointers.
* `LoadType` to `transform_config`, which is used for the `device_transform` when the input and output are pointers.
* `rocprim:device_transform` for n-ary transform operations API with as input `n` number of iterators inside a `rocprim::tuple`.
* `rocprim::key_value_pair::operator==`.
* The `rocprim::unrolled_copy` thread function to copy multiple items inside a thread.
* The `rocprim::unrolled_thread_load` function to load multiple items inside a thread using `rocprim::thread_load`.
* `rocprim::int128_t` and `rocprim::uint128_t` to benchmarks for improved performance evaluation on 128-bit integers.
* `rocprim::int128_t` to the supported autotuning types to improve performance for 128-bit integers.
* The `rocprim::merge_inplace` function for merging in-place.
* Initial value support for warp- and block-level inclusive scan.
* Support for building tests with device-side random data generation, making them finish faster. This requires rocRAND, and is enabled with the `WITH_ROCRAND=ON` build flag.
* Tests and documentation to `lookback_scan_state`. It is still in the `detail` namespace.

#### Changed

* Changed the parameters `long_radix_bits` and `LongRadixBits` from `segmented_radix_sort` to `radix_bits` and `RadixBits`, respectively.
* Marked the initialisation constructor of `rocprim::reverse_iterator<Iter>` `explicit`, use `rocprim::make_reverse_iterator`.
* Merged `radix_key_codec` into type_traits system.
* Renamed `type_traits_interface.hpp` to `type_traits.hpp`, rename the original `type_traits.hpp` to `type_traits_functions.hpp`.
* The default scan accumulator types for device-level scan algorithms have changed. This is a breaking change.
The previous default accumulator types could lead to situations in which unexpected overflow occurred, such as when the input or initial type was smaller than the output type. This is a complete list of affected functions and how their default accumulator types are changing:

  * `rocprim::inclusive_scan`
    * Previous default: `class AccType = typename std::iterator_traits<InputIterator>::value_type>`
    * Current default: `class AccType = rocprim::accumulator_t<BinaryFunction, typename std::iterator_traits<InputIterator>::value_type>`
  * `rocprim::deterministic_inclusive_scan`
    * Previous default: `class AccType = typename std::iterator_traits<InputIterator>::value_type>`
    * Current default: `class AccType = rocprim::accumulator_t<BinaryFunction, typename std::iterator_traits<InputIterator>::value_type>`
  * `rocprim::exclusive_scan`
    * Previous default: `class AccType = detail::input_type_t<InitValueType>>`
    * Current default: `class AccType = rocprim::accumulator_t<BinaryFunction, rocprim::detail::input_type_t<InitValueType>>`
  * `rocprim::deterministic_exclusive_scan`
    * Previous default: `class AccType = detail::input_type_t<InitValueType>>`
    * Current default: `class AccType = rocprim::accumulator_t<BinaryFunction, rocprim::detail::input_type_t<InitValueType>>`
* Undeprecated internal `detail::raw_storage`.
* A new version of `rocprim::thread_load` and `rocprim::thread_store` replaces the deprecated `rocprim::thread_load` and `rocprim::thread_store` functions. The versions avoid inline assembly where possible, and don't hinder the optimizer as much as a result.
* Renamed `rocprim::load_cs` to `rocprim::load_nontemporal` and `rocprim::store_cs` to `rocprim::store_nontemporal` to express the intent of these load and store methods better.
* All kernels now have hidden symbol visibility. All symbols now have inline namespaces that include the library version, for example, `rocprim::ROCPRIM_300400_NS::symbol` instead of `rocPRIM::symbol`, letting the user link multiple libraries built with different versions of rocPRIM.

#### Removed

* `rocprim::detail::float_bit_mask` and relative tests, use `rocprim::traits::float_bit_mask` instead.
* `rocprim::traits::is_fundamental`, use `rocprim::traits::get<T>::is_fundamental()` directly.
* The deprecated parameters `short_radix_bits` and `ShortRadixBits` from the `segmented_radix_sort` config. They were unused, it is only an API change.
* The deprecated `operator<<` from the iterators.
* The deprecated `TwiddleIn` and `TwiddleOut`. Use `radix_key_codec` instead.
* The deprecated flags API of `block_adjacent_difference`. Use `subtract_left()` or `block_discontinuity::flag_heads()` instead.
* The deprecated `to_exclusive` functions in the warp scans.
* The `rocprim::load_cs` from the `cache_load_modifier` enum. Use `rocprim::load_nontemporal` instead.
* The `rocprim::store_cs` from the `cache_store_modifier` enum. Use `rocprim::store_nontemporal` instead.
* The deprecated header file `rocprim/detail/match_result_type.hpp`. Include `rocprim/type_traits.hpp` instead. This header included:
  * `rocprim::detail::invoke_result`. Use `rocprim::invoke_result` instead.
  * `rocprim::detail::invoke_result_binary_op`. Use `rocprim::invoke_result_binary_op` instead.
  * `rocprim::detail::match_result_type`. Use `rocprim::invoke_result_binary_op_t` instead.
* The deprecated `rocprim::detail::radix_key_codec` function. Use `rocprim::radix_key_codec` instead.
* Removed `rocprim/detail/radix_sort.hpp`, functionality can now be found in `rocprim/thread/radix_key_codec.hpp`.
* Removed C++14 support. Only C++17 is supported.
* Due to the removal of `__AMDGCN_WAVEFRONT_SIZE` in the compiler, the following deprecated warp size-related symbols have been removed:
  * `rocprim::device_warp_size()`
    * For compile-time constants, this is replaced with `rocprim::arch::wavefront::min_size()` and `rocprim::arch::wavefront::max_size()`. Use this when allocating global or shared memory.
    * For run-time constants, this is replaced with `rocprim::arch::wavefront::size().`
  * `rocprim::warp_size()`
    * Use `rocprim::host_warp_size()`, `rocprim::arch::wavefront::min_size()` or `rocprim::arch::wavefront::max_size()` instead.
  * `ROCPRIM_WAVEFRONT_SIZE`
    * Use `rocprim::arch::wavefront::min_size()` or `rocprim::arch::wavefront::max_size()` instead.
  * `__AMDGCN_WAVEFRONT_SIZE`
    * This was a fallback define for the compiler's removed symbol, having the same name. 
* This release removes support for custom builds on gfx940 and gfx941.

#### Optimized

* Improved performance of `rocprim::device_select` and `rocprim::device_partition` when using multiple streams on the AMD Instinct MI300 Series.

#### Resolved issues

* Fixed an issue where `device_batch_memcpy` reported benchmarking throughput being 2x lower than it was in reality.
* Fixed an issue where `device_segmented_reduce` reported autotuning throughput being 5x lower than it was in reality.
* Fixed device radix sort not returning the correct required temporary storage when a double buffer contains `nullptr`.
* Fixed constness of equality operators (`==` and `!=`) in `rocprim::key_value_pair`.
* Fixed an issue for the comparison operators in `arg_index_iterator` and `texture_cache_iterator`, where `<` and `>` comparators were swapped.
* Fixed an issue for the `rocprim::thread_reduce` not working correctly with a prefix value.

#### Known issues

* When using `rocprim::deterministic_inclusive_scan_by_key` and `rocprim::deterministic_exclusive_scan_by_key` the intermediate values can change order on Navi3x. However, if a commutative scan operator is used then the final scan value (output array) will still always be consistent between runs.

#### Upcoming changes

* `rocprim::invoke_result_binary_op` and `rocprim::invoke_result_binary_op_t` are deprecated. Use `rocprim::accumulator_t` instead.

### **ROCprofiler-SDK** (1.0.0)

#### Added

- Support for [rocJPEG](https://rocm.docs.amd.com/projects/rocJPEG/en/latest/index.html) API Tracing.
- Support for AMD Instinct MI350X and MI355X GPUs.
- `rocprofiler_create_counter` to facilitate adding custom derived counters at runtime.
- Support in `rocprofv3` for iteration based counter multiplexing.
- Perfetto support for counter collection.
- Support for negating `rocprofv3` tracing options when using aggregate options such as `--sys-trace --hsa-trace=no`.
- `--agent-index` option in `rocprofv3` to specify the agent naming convention in the output:
  - absolute == node_id
  - relative == logical_node_id
  - type-relative == logical_node_type_id
- MI300 and MI350 stochastic (hardware-based) PC sampling support in ROCProfiler-SDK and `rocprofv3`.
- Python bindings for `rocprofiler-sdk-roctx`.
- SQLite3 output support for `rocprofv3` using `--output-format rocpd`.
- `rocprofiler-sdk-rocpd` package:
  - Public API in `include/rocprofiler-sdk-rocpd/rocpd.h`.
  - Library implementation in `librocprofiler-sdk-rocpd.so`.
  - Support for `find_package(rocprofiler-sdk-rocpd)`.
  - `rocprofiler-sdk-rocpd` DEB and RPM packages.
- `--version` option in `rocprofv3`.
- `rocpd` Python package.
- Thread trace as experimental API.
- ROCprof Trace Decoder as experimental API:
  - Requires [ROCprof Trace Decoder plugin](https://github.com/rocm/rocprof-trace-decoder).
- Thread trace option in the `rocprofv3` tool under the `--att` parameters:
  - See [using thread trace with rocprofv3](https://rocm.docs.amd.com/projects/rocprofiler-sdk/en/docs-7.0.0/how-to/using-thread-trace.html)
  - Requires [ROCprof Trace Decoder plugin](https://github.com/rocm/rocprof-trace-decoder).
- `rocpd` output format documentation:
  - Requires [ROCprof Trace Decoder plugin](https://github.com/rocm/rocprof-trace-decoder).
- Perfetto support for scratch memory.
- Support in the `rocprofv3` avail tool for command-line arguments.
- Documentation for `rocprofv3` advanced options.
- AQLprofile is now available as open source.

#### Changed

- SDK to NOT to create a background thread when every tool returns a nullptr from `rocprofiler_configure`.
- `vaddr-to-file-offset` mapping in `disassembly.hpp` to use the dedicated comgr API.
- `rocprofiler_uuid_t` ABI to hold 128 bit value.
- `rocprofv3` shorthand argument for `--collection-period` to `-P` (upper-case) while `-p` (lower-case) is reserved for later use.
- Default output format for `rocprofv3` to `rocpd` (SQLite3 database).
- `rocprofv3` avail tool to be renamed from `rocprofv3_avail` to `rocprofv3-avail` tool.
- `rocprofv3` tool to facilitate thread trace and PC sampling on the same agent.

##### Removed

* Support for compilation of gfx940 and gfx941 targets.

#### Resolved issues

- Fixed missing callbacks around internal thread creation within counter collection service.
- Fixed potential data race in the ROCprofiler-SDK double buffering scheme.
- Fixed usage of std::regex in the core ROCprofiler-SDK library that caused segfaults or exceptions when used under dual ABI.
- Fixed Perfetto counter collection by introducing accumulation per dispatch.
- Fixed code object disassembly for missing function inlining information.
- Fixed queue preemption error and `HSA_STATUS_ERROR_INVALID_PACKET_FORMAT` error for stochastic PC-sampling in MI300X, leading to stabler runs.
- Fixed the system hang issue for host-trap PC-sampling on AMD Instinct MI300X.
- Fixed `rocpd` counter collection issue when counter collection alone is enabled. `rocpd_kernel_dispatch` table is updated to be populated by counters data instead of kernel_dispatch data.
- Fixed `rocprofiler_*_id_t` structs for inconsistency related to a "null" handle:
  - The correct definition for a null handle is `.handle = 0` while some definitions previously used `UINT64_MAX`.
- Fixed kernel trace csv output generated by `rocpd`.

### **rocPyDecode** (0.6.0)

#### Added

* ``rocpyjpegdecode`` package.
* ``src/rocjpeg`` source new subfolder.
* ``samples/rocjpeg`` new subfolder.

#### Changed
* Minimum version for rocdecode and rocjpeg updated to V1.0.0.

### **rocRAND** (4.0.0)

#### Added

* Support for gfx950.
* Additional unit tests for `test_log_normal_distribution.cpp`, `test_normal_distribution.cpp`, `test_rocrand_mtgp32_prng.cpp`, `test_rocrand_scrambled_sobol32_qrng.cpp`, `test_rocrand_scrambled_sobol64_qrng.cpp`, `test_rocrand_sobol32_qrng.cpp`, `test_rocrand_sobol64_qrng.cpp`, `test_rocrand_threefry2x32_20_prng.cpp`, `test_rocrand_threefry2x64_20_prng.cpp`, `test_rocrand_threefry4x32_20_prng.cpp`, `test_rocrand_threefry4x64_20_prng.cpp`, and `test_uniform_distribution.cpp`.
* New unit tests for `include/rocrand/rocrand_discrete.h` in `test_rocrand_discrete.cpp`, `include/rocrand/rocrand_mrg31k3p.h` in `test_rocrand_mrg31k3p_prng.cpp`, `include/rocrand/rocrand_mrg32k3a.h` in `test_rocrand_mrg32k3a_prng.cpp`, and `include/rocrand/rocrand_poisson.h` in `test_rocrand_poisson.cpp`.

#### Changed

* Changed the return type for `rocrand_generate_poisson` for the `SOBOL64` and `SCRAMBLED_SOBOL64` engines.
* Changed the unnecessarily large 64-bit data type for constants used for skipping in `MRG32K3A` to the 32-bit data type.
* Updated several `gfx942` auto tuning parameters.
* Modified error handling and expanded the error information for the case of double-deallocation of the (scrambled) sobol32 and sobol64 constants and direction vectors.

#### Removed

* Removed inline assembly and the `ENABLE_INLINE_ASM` CMake option. Inline assembly was used to optimize multiplication in the Mrg32k3a and Philox 4x32-10 generators. It is no longer needed because the current HIP compiler is able to produce code with the same or better performance.
* Removed instances of the deprecated clang definition `__AMDGCN_WAVEFRONT_SIZE`.
* Removed C++14 support. Beginning with this release, only C++17 is supported.
* Directly accessing the (scrambled) sobol32 and sobol64 constants and direction vectors is no longer supported. For:
  * `h_scrambled_sobol32_constants`, use `rocrand_get_scramble_constants32` instead.
  * `h_scrambled_sobol64_constants`, use `rocrand_get_scramble_constants64` instead.
  * `rocrand_h_sobol32_direction_vectors`, use `rocrand_get_direction_vectors32` instead.
  * `rocrand_h_sobol64_direction_vectors`, use `rocrand_get_direction_vectors64` instead.
  * `rocrand_h_scrambled_sobol32_direction_vectors`, use `rocrand_get_direction_vectors32` instead.
  * `rocrand_h_scrambled_sobol64_direction_vectors`, use `rocrand_get_direction_vectors64` instead.

#### Resolved issues

* Fixed an issue where `mt19937.hpp` would cause kernel errors during auto tuning.

#### Upcoming changes

* Deprecated the rocRAND Fortran API in favor of hipfort.

### **ROCr Debug Agent** (2.1.0)

#### Added

* The `-e` and `--precise-alu-exceptions` flags to enable precise ALU exceptions reporting on supported configurations.

### **ROCr Runtime** (1.18.0)

#### Added

* New API `hsa_amd_memory_get_preferred_copy_engine` to get preferred copy engine that can be used to when calling `hsa_amd_memory_async_copy_on_engine`.
* New API `hsa_amd_portable_export_dmabuf_v2` extension of existing `hsa_amd_portable_export_dmabuf` API to support new flags parameter. This allows specifying the new `HSA_AMD_DMABUF_MAPPING_TYPE_PCIE` flag when exporting dma-bufs.
* New flag `HSA_AMD_VMEM_ADDRESS_NO_REGISTER` adds support for new `HSA_AMD_VMEM_ADDRESS_NO_REGISTER` when calling `hsa_amd_vmem_address_reserve` API. This allows virtual address range reservations for SVM allocations to be tracked when running in ASAN mode.
* New sub query `HSA_AMD_AGENT_INFO_CLOCK_COUNTERS` returns a snapshot of the underlying driver's clock counters that can be used for profiling.

### **rocSHMEM** (3.0.0)

#### Added

* Reverse Offload conduit.
* New APIs: `rocshmem_ctx_barrier`, `rocshmem_ctx_barrier_wave`, `rocshmem_ctx_barrier_wg`, `rocshmem_barrier_all`, `rocshmem_barrier_all_wave`, `rocshmem_barrier_all_wg`, `rocshmem_ctx_sync`, `rocshmem_ctx_sync_wave`, `rocshmem_ctx_sync_wg`, `rocshmem_sync_all`, `rocshmem_sync_all_wave`, `rocshmem_sync_all_wg`, `rocshmem_init_attr`, `rocshmem_get_uniqueid`, and `rocshmem_set_attr_uniqueid_args`.
* `dlmalloc` based allocator.
* XNACK support.
* Support for initialization with MPI communicators other than `MPI_COMM_WORLD`.

#### Changed

* Changed collective APIs to use `_wg` suffix rather than `_wg_` infix.

#### Resolved issues

* Resolved segfault in `rocshmem_wg_ctx_create`, now provides `nullptr` if `ctx` cannot be created.

### **rocSOLVER** (3.30.0)

#### Added

* Hybrid computation support for existing STEQR routines.

#### Optimized

* Improved the performance of BDSQR and downstream functions, such as GESVD.
* Improved the performance of STEQR and downstream functions, such as SYEV/HEEV.
* Improved the performance of LARFT and downstream functions, such as GEQR2 and GEQRF.
  
#### Resolved issues

* Fixed corner cases that can produce NaNs in SYEVD for valid input matrices.

### **rocSPARSE** (4.0.2)

#### Added

* The `SpGEAM` generic routine for computing sparse matrix addition in CSR format.
* The `v2_SpMV` generic routine for computing sparse matrix vector multiplication. As opposed to the deprecated `rocsparse_spmv` routine, this routine does not use a fallback algorithm if a non-implemented configuration is encountered and will return an error in such a case. For the deprecated `rocsparse_spmv` routine, the user can enable warning messages in situations where a fallback algorithm is used by either calling the `rocsparse_enable_debug` routine upfront or exporting the variable `ROCSPARSE_DEBUG` (with the shell command `export ROCSPARSE_DEBUG=1`).
* Half float mixed precision to `rocsparse_axpby` where X and Y use `float16` and the result and compute type use `float`.
* Half float mixed precision to `rocsparse_spvv` where X and Y use `float16` and the result and compute type use `float`.
* Half float mixed precision to `rocsparse_spmv` where A and X use `float16` and Y and the compute type use `float`.
* Half float mixed precision to `rocsparse_spmm` where A and B use `float16` and C and the compute type use `float`.
* Half float mixed precision to `rocsparse_sddmm` where A and B use `float16` and C and the compute type use `float`.
* Half float uniform precision to the `rocsparse_scatter` and `rocsparse_gather` routines.
* Half float uniform precision to the `rocsparse_sddmm` routine.
* The `rocsparse_spmv_alg_csr_rowsplit` algorithm.
* Support for gfx950.
* ROC-TX instrumentation support in rocSPARSE (not available on Windows or in the static library version on Linux).
* The `almalinux` operating system name to correct the GFortran dependency.

#### Changed

* Switch to defaulting to C++17 when building rocSPARSE from source. Previously rocSPARSE was using C++14 by default.

#### Removed

* The deprecated `rocsparse_spmv_ex` routine.
* The deprecated `rocsparse_sbsrmv_ex`, `rocsparse_dbsrmv_ex`, `rocsparse_cbsrmv_ex`, and `rocsparse_zbsrmv_ex` routines.
* The deprecated `rocsparse_sbsrmv_ex_analysis`, `rocsparse_dbsrmv_ex_analysis`, `rocsparse_cbsrmv_ex_analysis`, and `rocsparse_zbsrmv_ex_analysis` routines.

#### Optimized

* Reduced the number of template instantiations in the library to further reduce the shared library binary size and improve compile times.
* Allow SpGEMM routines to use more shared memory when available. This can speed up performance for matrices with a large number of intermediate products.
* Use of the `rocsparse_spmv_alg_csr_adaptive` or `rocsparse_spmv_alg_csr_default` algorithms in `rocsparse_spmv` to perform transposed sparse matrix multiplication (`C=alpha*A^T*x+beta*y`) resulted in unnecessary analysis on A and needless slowdown during the analysis phase. This has been improved by skipping the analysis when performing the transposed sparse matrix multiplication.
* Improved the user documentation.

#### Resolved issues
  
* Fixed an issue in the public headers where `extern "C"` was not wrapped by `#ifdef __cplusplus`, which caused failures when building C programs with rocSPARSE.
* Fixed a memory access fault in the `rocsparse_Xbsrilu0` routines.
* Fixed failures that could occur in `rocsparse_Xbsrsm_solve` or `rocsparse_spsm` with BSR format when using host pointer mode.
* Fixed ASAN compilation failures.
* Fixed a failure that occurred when using const descriptor `rocsparse_create_const_csr_descr` with the generic routine `rocsparse_sparse_to_sparse`. The issue was not observed when using non-const descriptor `rocsparse_create_csr_descr` with `rocsparse_sparse_to_sparse`.
* Fixed a memory leak in the rocSPARSE handle.

#### Upcoming changes

* Deprecated the `rocsparse_spmv` routine. Use the `rocsparse_v2_spmv` routine instead.
* Deprecated the `rocsparse_spmv_alg_csr_stream` algorithm. Use the `rocsparse_spmv_alg_csr_rowsplit` algorithm instead.
* Deprecated the `rocsparse_itilu0_alg_sync_split_fusion` algorithm. Use one of `rocsparse_itilu0_alg_async_inplace`, `rocsparse_itilu0_alg_async_split`, or `rocsparse_itilu0_alg_sync_split` instead.

### **rocThrust** (4.0.0)

#### Added

* Additional unit tests for: binary_search, complex, c99math, catrig, ccosh, cexp, clog, csin, csqrt, and ctan.
* `test_param_fixtures.hpp` to store all the parameters for typed test suites.
* `test_real_assertions.hpp` to handle unit test assertions for real numbers.
* `test_imag_assertions.hpp` to handle unit test assertions for imaginary numbers.
* `clang++` is now used to compile google benchmarks on Windows.
* Support for gfx950.
* Merged changes from upstream CCCL/thrust 2.6.0.

#### Changed

* Updated the required version of Google Benchmark from 1.8.0 to 1.9.0.
* Renamed `cpp14_required.h` to `cpp_version_check.h`.
* Refactored `test_header.hpp` into `test_param_fixtures.hpp`, `test_real_assertions.hpp`, `test_imag_assertions.hpp`, and `test_utils.hpp`. This is done to prevent unit tests from having access to modules that they're not testing. This will improve the accuracy of code coverage reports.

#### Removed

* `device_malloc_allocator.h` has been removed. This header file was unused and should not impact users.
* Removed C++14 support. Only C++17 is now supported.
* `test_header.hpp` has been removed. The `HIP_CHECK` function, as well as the `test` and `inter_run_bwr` namespaces, have been moved to `test_utils.hpp`.
* `test_assertions.hpp` has been split into `test_real_assertions.hpp` and `test_imag_assertions.hpp`.

#### Resolved issues

* Fixed an issue with internal calls to unqualified `distance()` which would be ambiguous due to the visible implementation through ADL.

#### Known issues

* The order of the values being compared by `thrust::exclusive_scan_by_key` and `thrust::inclusive_scan_by_key` can change between runs when integers are being compared. This can cause incorrect output when a non-commutative operator such as division is being used.

#### Upcoming changes

* `thrust::device_malloc_allocator` is deprecated as of this version. It will be removed in an upcoming version.

### **rocWMMA** (2.0.0)

#### Added

* Internal register layout transforms to support interleaved MMA layouts.
* Support for the gfx950 target.
* Mixed input `BF8`/`FP8` types for MMA support.
* Fragment scheduler API objects to embed thread block cooperation properties in fragments.

#### Changed

* Augmented load/store/MMA internals with static loop unrolling.
* Updated linkage of `rocwmma::synchronize_workgroup` to inline.
* rocWMMA `mma_sync` API now supports `wave tile` fragment sizes.
* rocWMMA cooperative fragments are now expressed with fragment scheduler template arguments.
* rocWMMA cooperative fragments now use the same base API as non-cooperative fragments.
* rocWMMA cooperative fragments register usage footprint has been reduced.
* rocWMMA fragments now support partial tile sizes with padding.

#### Removed

* Support for the gfx940 and gfx941 targets.
* The rocWMMA cooperative API.
* Wave count template parameters from transforms APIs.

#### Optimized

* Added internal flow control barriers to improve assembly code generation and overall performance.
* Enabled interleaved layouts by default in MMA to improve overall performance.

#### Resolved issues

* Fixed a validation issue for small precision compute types `< B32` on gfx9.
* Fixed CMake validation of compiler support for `BF8`/`FP8` types.

### **RPP** (2.0.0)

#### Added

* Bitwise NOT, Bitwise AND, and Bitwise OR augmentations on HOST (CPU) and HIP backends.
* Tensor Concat augmentation on HOST (CPU) and HIP backends.
* JPEG Compression Distortion augmentation on HIP backend. 
* `log1p`, defined as `log (1 + x)`, tensor augmentation support on HOST (CPU) and HIP backends.
* JPEG Compression Distortion augmentation on HOST (CPU) backend. 

#### Changed

* Handle creation and destruction APIs have been consolidated. Use `rppCreate()` for handle initialization and `rppDestroy()` for handle destruction.
* The `logical_operations` function category has been renamed to `bitwise_operations`.
* TurboJPEG package installation enabled for RPP Test Suite with `sudo apt-get install libturbojpeg0-dev`. Instructions have been updated in utilities/test_suite/README.md.
* The `swap_channels` augmentation has been changed to `channel_permute`. `channel_permute` now also accepts a new argument, `permutationTensor` (pointer to an unsigned int tensor), that provides the permutation order to swap the RGB channels of each input image in the batch in any order:

    `RppStatus rppt_swap_channels_host(RppPtr_t srcPtr, RpptDescPtr srcDescPtr, RppPtr_t dstPtr, RpptDescPtr dstDescPtr, rppHandle_t rppHandle);`

    changed to:

    `RppStatus rppt_channel_permute_host(RppPtr_t srcPtr, RpptDescPtr srcDescPtr, RppPtr_t dstPtr, RpptDescPtr dstDescPtr, Rpp32u *permutationTensor , rppHandle_t rppHandle);`

#### Removed

* Older versions of RPP handle creation inlcuding `rppCreateWithBatchSize()`, `rppCreateWithStream()`, and `rppCreateWithStreamAndBatchSize()`. These have been replaced with `rppCreate()`.
* Older versions of RPP handle destruction API including `rppDestroyGPU()` and `rppDestroyHost()`. These have been replaced with `rppDestroy()`.

#### Resolved issues

* Test package - Debian packages will install required dependencies.

### **Tensile** (4.44.0)

#### Added

- Support for gfx950.
- Code object compression via bundling.
- Support for non-default HIP SDK installations on Windows.
- Master solution library documentation.
- Compiler version-dependent assembler and architecture capabilities.
- Documentation from GitHub Wiki to ROCm docs.

#### Changed

- Loosened check for CLI compiler choices.
- Introduced 4-tuple targets for bundler invocations.
- Introduced PATHEXT extensions on Windows when searching for toolchain components.
- Enabled passing fully qualified paths to toolchain components.
- Enabled environment variable overrides when searching for a ROCm stack.
- Improved default toolchain configuration.
- Ignored f824 flake errors.

#### Removed

- Support for the gfx940 and gfx941 targets.
- Unused tuning files.
- Disabled tests.

#### Resolved issues

- Fixed configure time path not being invoked at build.
- Fixed find_package for msgpack to work with versions 5 and 6.
- Fixed RHEL 9 testing.
- Fixed gfx908 builds.
- Fixed the 'argument list too long' error.
- Fixed version typo in 6.3 changelog.
- Fixed improper use of aliases as nested namespace specifiers.

## ROCm 6.4.3

See the [ROCm 6.4.3 release notes](https://rocm.docs.amd.com/en/docs-6.4.3/about/release-notes.html)
for a complete overview of this release.

### **ROCm SMI** (7.7.0)

#### Added

- Support for getting the GPU Board voltage.

```{note}
See the full [ROCm SMI changelog](https://github.com/ROCm/rocm_smi_lib/blob/release/rocm-rel-6.4/CHANGELOG.md) for details, examples, and in-depth descriptions.
```

## ROCm 6.4.2

See the [ROCm 6.4.2 release notes](https://rocm.docs.amd.com/en/docs-6.4.2/about/release-notes.html)
for a complete overview of this release.

### **AMD SMI** (25.5.1)

#### Added

- Compute Unit Occupancy information per process.

- Support for getting the GPU Board voltage.

- New firmware PLDM_BUNDLE. `amd-smi firmware` can now show the PLDM Bundle on supported systems.

- `amd-smi ras --afid --cper-file <file_path>` to decode CPER records.

#### Changed

- Padded `asic_serial` in `amdsmi_get_asic_info` with 0s.

- Renamed field `COMPUTE_PARTITION` to `ACCELERATOR_PARTITION` in CLI call `amd-smi --partition`.

#### Resolved issues

- Corrected VRAM memory calculation in `amdsmi_get_gpu_process_list`. Previously, the VRAM memory usage reported by `amdsmi_get_gpu_process_list` was inaccurate and was calculated using KB instead of KiB.

```{note}
See the full [AMD SMI changelog](https://github.com/ROCm/amdsmi/blob/release/rocm-rel-6.4/CHANGELOG.md) for details, examples, and in-depth descriptions.
```

### **HIP** (6.4.2)

#### Added

* HIP API implementation for `hipEventRecordWithFlags`, records an event in the specified stream with flags.
* Support for the pointer attribute `HIP_POINTER_ATTRIBUTE_CONTEXT`.
* Support for the flags `hipEventWaitDefault` and `hipEventWaitExternal`.

#### Optimized

* Improved implementation in `hipEventSynchronize`, HIP runtime now makes internal callbacks as non-blocking operations to improve performance.

#### Resolved issues

* Issue of dependency on `libgcc-s1` during rocm-dev install on Debian Buster. HIP runtime removed this Debian package dependency, and uses `libgcc1` instead for this distros.
* Building issue for `COMGR` dynamic load on Fedora and other Distros. HIP runtime now doesn't link against `libamd_comgr.so`.
* Failure in the API `hipStreamDestroy`, when stream type is `hipStreamLegacy`. The API now returns error code `hipErrorInvalidResourceHandle` on this condition.
* Kernel launch errors, such as `shared object initialization failed`, `invalid device function` or `kernel execution failure`. HIP runtime now loads `COMGR` properly considering the file with its name and mapped image.
* Memory access fault in some applications. HIP runtime fixed offset accumulation in memory address.
* The memory leak in virtual memory management (VMM). HIP runtime now uses the size of handle for allocated memory range instead of actual size for physical memory, which fixed the issue of address clash with VMM.
* Large memory allocation issue. HIP runtime now checks GPU video RAM and system RAM properly and sets size limits during memory allocation either on the host or the GPU device.
* Support of `hipDeviceMallocContiguous` flags in `hipExtMallocWithFlags()`. It now enables `HSA_AMD_MEMORY_POOL_CONTIGUOUS_FLAG` in the memory pool allocation on GPU device.
* Radom memory segmentation fault in handling `GraphExec` object release and `hipDeviceSyncronization`. HIP runtime now uses internal device synchronize function in `__hipUnregisterFatBinary`. 

### **hipBLASLt** (0.12.1)

#### Added

* Support for gfx1151 on Linux, complementing the previous support in the HIP SDK for Windows.

### **RCCL** (2.22.3)

#### Added

* Added support for the LL128 protocol on gfx942.

### **rocBLAS** (4.4.1)

#### Resolved issues

* rocBLAS might have failed to produce correct results for cherk/zherk on gfx90a/gfx942 with problem sizes k > 500 due to the imaginary portion on the C matrix diagonal not being zeros. rocBLAS now zeros the imaginary portion.

### **ROCm Compute Profiler** (3.1.1)

#### Added

* 8-bit floating point (FP8) metrics support for AMD Instinct MI300 GPUs.
* Additional data types for roofline: FP8, FP16, BF16, FP32, FP64, I8, I32, I64 (dependent on the GPU architecture).
* Data type selection option ``--roofline-data-type / -R`` for roofline profiling. The default data type is FP32.

#### Changed

* Changed dependency from `rocm-smi` to `amd-smi`.

#### Resolved issues

* Fixed a crash related to Agent ID caused by the new format of the `rocprofv3` output CSV file.

### **ROCm Systems Profiler** (1.0.2)

#### Optimized

* Improved readability of the OpenMP target offload traces by showing on a single Perfetto track.

#### Resolved issues

* Fixed the file path to the script that merges Perfetto files from multi-process MPI runs. The script has also been renamed from `merge-multiprocess-output.sh` to `rocprof-sys-merge-output.sh`.

### **ROCm Validation Suite** (1.1.0)

#### Added

* NPS2/DPX and NPS4/CPX partition modes support for AMD Instinct MI300X.

### **rocPRIM** (3.4.1)

#### Upcoming changes

* Changes to the template parameters of warp and block algorithms will be made in an upcoming release.
* Due to an upcoming compiler change, the following symbols related to warp size have been marked as deprecated and will be removed in an upcoming major release:
    * `rocprim::device_warp_size()`. This has been replaced by `rocprim::arch::wavefront::min_size()` and `rocprim::arch::wavefront::max_size()` for compile-time constants. Use these when allocating global or shared memory. For run-time constants, use `rocprim::arch::wavefront::size()`.
  * `rocprim::warp_size()`
  * `ROCPRIM_WAVEFRONT_SIZE`

* The default scan accumulator types for device-level scan algorithms will be changed in an upcoming release, resulting in a breaking change. Previously, the default accumulator type was set to the input type for the inclusive scans and to the initial value type for the exclusive scans. This could lead to unexpected overflow if the input or initial type was smaller than the output type when the accumulator type wasn't explicitly set using the `AccType` template parameter. The new default accumulator types will be set to the type that results when the input or initial value type is applied to the scan operator.  

    The following is the complete list of affected functions and how their default accumulator types are changing:
    
    * `rocprim::inclusive_scan`
        * current default: `class AccType = typename std::iterator_traits<InputIterator>::value_type>`
        * future default: `class AccType = rocprim::invoke_result_binary_op_t<typename std::iterator_traits<InputIterator>::value_type, BinaryFunction>`
    * `rocprim::deterministic_inclusive_scan`
        * current default: `class AccType = typename std::iterator_traits<InputIterator>::value_type>`
        * future default: `class AccType = rocprim::invoke_result_binary_op_t<typename std::iterator_traits<InputIterator>::value_type, BinaryFunction>`
    * `rocprim::exclusive_scan`
        * current default: `class AccType = detail::input_type_t<InitValueType>>`
        * future default: `class AccType = rocprim::invoke_result_binary_op_t<rocprim::detail::input_type_t<InitValueType>, BinaryFunction>`
    * `rocprim::deterministic_exclusive_scan`
        * current default: `class AccType = detail::input_type_t<InitValueType>>`
        * future default: `class AccType = rocprim::invoke_result_binary_op_t<rocprim::detail::input_type_t<InitValueType>, BinaryFunction>`

* `rocprim::load_cs` and `rocprim::store_cs` are deprecated and will be removed in an upcoming release. Alternatively, you can use `rocprim::load_nontemporal` and `rocprim::store_nontemporal` to load and store values in specific conditions (like bypassing the cache) for `rocprim::thread_load` and `rocprim::thread_store`.

### **rocSHMEM** (2.0.1)

#### Resolved issues

* Incorrect output for `rocshmem_ctx_my_pe` and `rocshmem_ctx_n_pes`.
* Multi-team errors by providing team specific buffers in `rocshmem_ctx_wg_team_sync`.
* Missing implementation of `rocshmem_g` for IPC conduit.

### **rocSOLVER** (3.28.2)

#### Added

* Hybrid computation support for existing routines, such as STERF.
* SVD for general matrices based on Cuppen's Divide and Conquer algorithm:
    - GESDD (with batched and strided\_batched versions)

#### Optimized

* Reduced the device memory requirements for STEDC, SYEVD/HEEVD, and SYGVD/HEGVD.
* Improved the performance of STEDC and divide and conquer Eigensolvers.
* Improved the performance of SYTRD, the initial step of the Eigensolvers that start with the tridiagonalization of the input matrix.

## ROCm 6.4.1

See the [ROCm 6.4.1 release notes](https://rocm.docs.amd.com/en/docs-6.4.1/about/release-notes.html)
for a complete overview of this release.

### **AMD SMI** (25.4.2)

#### Added

* Dumping CPER entries from RAS tool `amdsmi_get_gpu_cper_entries()` to Python and C APIs.
  - Dumping CPER entries consist of `amdsmi_cper_hdr_t`.
  - Dumping CPER entries is also enabled in the CLI interface through `sudo amd-smi ras --cper`.
* `amdsmi_get_gpu_busy_percent` to the C API.

#### Changed

* Modified VRAM display for `amd-smi monitor -v`. 

#### Optimized

* Improved load times for CLI commands when the GPU has multiple partitions.

#### Resolved issues

* Fixed partition enumeration in `amd-smi list -e`, `amdsmi_get_gpu_enumeration_info()`, `amdsmi_enumeration_info_t`, `drm_card`, and `drm_render` fields.

#### Known issues

* When using the `--follow` flag with `amd-smi ras --cper`, CPER entries are not streamed continuously as intended. This will be fixed in an upcoming ROCm release.

> [!NOTE]
> See the full [AMD SMI changelog](https://github.com/ROCm/amdsmi/blob/release/rocm-rel-6.4/CHANGELOG.md) for details, examples, and in-depth descriptions.

### **HIP** (6.4.1)

#### Added

* New log mask enumeration `LOG_COMGR` enables logging precise code object information.

#### Changed

* HIP runtime uses device bitcode before SPIRV.
* The implementation of preventing `hipLaunchKernel` latency degradation with number of idle streams is reverted or disabled by default.

#### Optimized

* Improved kernel logging includes de-mangling shader names.
* Refined implementation in HIP APIs `hipEventRecords` and `hipStreamWaitEvent` for performance improvement.

#### Resolved issues

* Stale state during the graph capture. The return error was fixed, HIP runtime now always uses the latest dependent nodes during `hipEventRecord` capture.
* Segmentation fault during kernel execution. HIP runtime now allows maximum stack size as per ISA on the GPU device.

### **hipBLASLt** (0.12.1)

#### Resolved issues

* Fixed an accuracy issue for some solutions using an `FP32` or `TF32` data type with a TT transpose.

### **RCCL** (2.22.3)

#### Changed

* MSCCL++ is now disabled by default. To enable it, set `RCCL_MSCCLPP_ENABLE=1`.

#### Resolved issues

* Fixed an issue where early termination, in rare circumstances, could cause the application to stop responding by adding synchronization before destroying a proxy thread.
* Fixed the accuracy issue for the MSCCLPP `allreduce7` kernel in graph mode.

#### Known issues

* When splitting a communicator using `ncclCommSplit` in some GPU configurations, MSCCL initialization can cause a segmentation fault. The recommended workaround is to disable MSCCL with `export RCCL_MSCCL_ENABLE=0`.
  This issue will be fixed in a future ROCm release.

* Within the RCCL-UnitTests test suite, failures occur in tests ending with the
  `.ManagedMem` and `.ManagedMemGraph` suffixes. These failures only affect the
  test results and do not affect the RCCL component itself. This issue will be
  resolved in a future ROCm release.

### **rocALUTION** (3.2.3)

#### Added

* The `-a` option has been added to the `rmake.py` build script. This option allows you to select specific architectures when building on Microsoft Windows.

#### Resolved issues

* Fixed an issue where the `HIP_PATH` environment variable was being ignored when compiling on Microsoft Windows.

### **ROCm Data Center Tool** (0.3.0)

#### Added

- Support for GPU partitions.
- `RDC_FI_GPU_BUSY_PERCENT` metric.

#### Changed

- Updated `rdc_field` to align with `rdc_bootstrap` for current metrics.

#### Resolved issues

- Fixed [ROCProfiler](https://rocm.docs.amd.com/projects/rocprofiler/en/docs-6.4.0/index.html) eval metrics and memory leaks.

### **ROCm SMI** (7.5.0)

#### Resolved issues

- Fixed partition enumeration. It now refers to the correct DRM Render and Card paths.

> [!NOTE]
> See the full [ROCm SMI changelog](https://github.com/ROCm/rocm_smi_lib/blob/release/rocm-rel-6.4/CHANGELOG.md) for details, examples, and in-depth descriptions.

### **ROCm Systems Profiler** (1.0.1)

#### Added 

* How-to document for [network performance profiling](https://rocm.docs.amd.com/projects/rocprofiler-systems/en/latest/how-to/nic-profiling.html) for standard Network Interface Cards (NICs).

#### Resolved issues

* Fixed a build issue with Dyninst on GCC 13.

### **ROCr Runtime** (1.15.0)

#### Resolved issues

* Fixed a rare occurrence issue on AMD Instinct MI25, MI50, and MI100 GPUs, where the `SDMA` copies might start before the dependent Kernel finishes and could cause memory corruption.

## ROCm 6.4.0

See the [ROCm 6.4.0 release notes](https://rocm.docs.amd.com/en/docs-6.4.0/about/release-notes.html)
for a complete overview of this release.

### **AMD SMI** (25.3.0)

#### Added

- Added enumeration mapping `amdsmi_get_gpu_enumeration_info()` to Python and C APIs. The mapping is also enabled in the CLI interface via `amd-smi list -e`.

- Added dynamic virtualization mode detection.
  - Added new C and Python API `amdsmi_get_gpu_virtualization_mode_info`.
  - Added new C and Python enum `amdsmi_virtualization_mode_t`.

- Added TVIOL_ACTIVE to `amd-smi monitor`.

- Added support for GPU metrics 1.7 to `amdsmi_get_gpu_metrics_info()`.

- Added new API `amdsmi_get_gpu_xgmi_link_status()` and CLI `amd-smi xgmi --link-status`.

- Added fclk and socclk info to `amd-smi metric -c/--clock`.

- Added new command `amd-smi set -c/--clock-level`.

- Added new command `amd-smi static -C/--clock`.

#### Changed

- Updated AMD SMI library version number format to reflect changes in backward compatibility and offer more semantic versioning.
  - Removed year from AMD SMI library version number.
  - Version format changed from 25.3.0.0 (Year.Major.Minor.Patch) to 25.3.0 (Major.Minor.Patch).
  - Removed year in all version references.

- Added new Python dependencies: `python3-setuptools` and `python3-wheel`.

- Removed initialization requirements for `amdsmi_get_lib_version()` and added `amdsmi_get_rocm_version()` to the Python API & CLI.

- Added an additional argument `sensor_ind` to `amdsmi_get_power_info()`.
  - This change breaks previous C API calls and will require a change.
  - Python API now accepts `sensor_ind` as an optional argument. This does not impact previous usage.

- Deprecated enum `AMDSMI_NORMAL_STRING_LENGTH` in favor of `AMDSMI_MAX_STRING_LENGTH`.

- Changed to use thread local mutex by default.
  - Most `sysfs` reads do not require cross-process level mutex and writes to `sysfs` should be protected by the kernel already.
  - Users can still switch to the old behavior by setting the environment variable `AMDSMI_MUTEX_CROSS_PROCESS=1`.

- Changed `amdsmi_vram_vendor_type_t` enum names impacting the `amdsmi_vram_info_t` structure. This change also impacts the usage of the `vram_vendor` output of `amdsmi_get_gpu_vram_info()`.

- Changed the `amdsmi_nps_caps_t` struct impacting `amdsmi_memory_partition_config_t`, `amdsmi_accelerator_partition_t`, `amdsmi_accelerator_partition_profile_config_t`.
  Affected functions are:

  - `amdsmi_get_gpu_memory_partition_config()`

  - `amdsmi_get_gpu_accelerator_partition_profile()`

  - `amdsmi_get_gpu_accelerator_partition_profile_config()`

- Corrected CLI CPU argument name. `--cpu-pwr-svi-telemtry-rails` is now `--cpu-pwr-svi-telemetry-rails`.

- Added amdgpu driver version and amd_hsmp driver version to the `amd-smi version` command.

- All `amd-smi set` and `amd-smi reset` options are now mutually exclusive. You can now only use one `set` option as a time.

- Changed the name of the `power` field to `energy_accumulator` in the Python API for `amdsmi_get_energy_count()`.

- Added violation status output for Graphics Clock Below Host Limit to `amd-smi` CLI: `amdsmi_get_violation_status()`, `amd-smi metric  --throttle`, and `amd-smi monitor --violation`.
  Users can retrieve violation status through either our Python or C++ APIs. Only available for MI300 Series+ ASICs.

- Updated API `amdsmi_get_violation_status()` structure and CLI `amdsmi_violation_status_t` to include GFX Clk below host limit.

- Updated API `amdsmi_get_gpu_vram_info()` structure and CLI `amd-smi static --vram`.

#### Removed

- Removed `GFX_BUSY_ACC` from `amd-smi metric --usage` as it did not provide helpful output to users.

#### Optimized

- Added additional help information to `amd-smi set --help` command. The subcommands now detail what values are accepted as input.

- Modified `amd-smi` CLI to allow case insensitive arguments if the argument does not begin with a single dash.

- Converted `xgmi` read and write from KBs to dynamically selected readable units.

#### Resolved issues

- Fixed `amdsmi_get_gpu_asic_info` and `amd-smi static --asic` not displaying graphics version correctly for Instinct MI200 Series, Instinct MI100 Series, and RDNA3-based GPUs.

#### Known issues

- AMD SMI only reports 63 GPU devices when setting CPX on all 8 GPUs. When setting CPX as a partition mode, there is a DRM node limitation of 64.

This is a known limitation of the Linux kernel; not the driver. Other drivers, such as those using PCIe space (for example, `ast`), might occupy the necessary DRM nodes.  You can check the number of DRM nodes using `ls /sys/class/drm`.

Some workaround options are as follows:

  - Remove other devices occupying DRM nodes.

    Recommended steps for removing unnecessary drivers:

    1. Unload amdgpu - `sudo rmmod amdgpu`.

    2. Remove unnecessary driver(s) - ex. `sudo rmmod ast`.

    3. Reload amgpu - `sudo modprobe amdgpu`.

    4. Confirm `amd-smi list` reports all nodes (this can vary per MI ASIC).

  - Update your OS kernel.

  - Build and install your own kernel.

#### Upcoming changes

- The `AMDSMI_LIB_VERSION_YEAR` enum and API fields will be deprecated in a future ROCm release.

- The `pasid` field in struct `amdsmi_process_info_t` will be deprecated in a future ROCm release.

> [!NOTE]
> See the full [AMD SMI changelog](https://github.com/ROCm/amdsmi/blob/release/rocm-rel-6.4/CHANGELOG.md) for details, examples, and in-depth descriptions.

### **AMDMIGraphX** (2.12.0)

#### Added

* Support for gfx1201.
* hipBLASLt support for contiguous transpose GEMM fusion and GEMM pointwise fusions for improved performance.
* Support for hardware-specific FP8 datatypes (FP8 OCP and FP8 FNUZ).
* Support for the BF16 datatype.
* ONNX Operator Support for `com.microsoft.MultiHeadAttention`, `com.microsoft.NhwcConv`, and `com.microsoft.MatMulIntgerFloat`
* The `migraphx-driver` can now produce output for Netron.
* The `migraphx-driver` now includes a `time` parameter (similar to `perf`) that is more accurate for very fast kernels.
* An end-to-end Stable Diffusion 3 example with an option to disable T5 encoder on VRAM-limited GPUs has been added.
* Support to track broadcast axes in `shape_transform_descriptor`.
* Support for unsigned types with `rocMLIR`.
* Script to convert mxr files to ONNX models.
* The `MIGRAPHX_SET_GEMM_PROVIDER` environment variable to choose between rocBLAS and hipBLASLt. Set `MIGRAPHX_SET_GEMM_PROVIDER` to `rocblas` to use rocBLAS, or to `hipblaslt` to use hipBLASLt.

#### Changed

* Switched to using hipBLASLt instead of rocBLAS (except for gfx90a GPU architecture).
* Included the min/max/median of the `perf` run as part of the summary report.
* Enabled non-packed inputs for `rocMLIR`.
* Always output a packed type for q/dq after determining non-packed tensors were inefficient.
* Even if using NHWC, MIGraphX will always convert group convolutions to NCHW for improved performance. 
* Renamed the `layout_nhwc` to `layout_convolution` and ensured that either the weights are the same layout as the inputs or set the input and weights to NHWC.
* The minimum Cmake version is now 3.27.

#### Removed

* Removed `fp8e5m2fnuz` rocBLAS support.
* `__AMDGCN_WAVEFRONT_SIZE` has been deprecated.
* Removed a warning that printed to stdout when using FP8 types.
* Remove zero-point parameter for dequantizelinear when it is zero.

#### Optimized

* Prefill buffers when MLIR produces a multioutput buffer.
* Improved the resize operator performance, which should improve the overall performance of models that use it.
* Allowed the `reduce` operator to be split across an axis to improve fusion performance.  The `MIGRAPHX_SPLIT_REDUCE_SIZE` environment variable has been added to allow the minimum size of the reduction to be adjusted for a possible model-specific performance improvement.
* Added `MIGRAPHX_DISABLE_PASSES` environment variable for debugging.
* Added `MIGRAPHX_MLIR_DUMP` environment variable to be set to a folder where individual final rocMLIR modules can be saved for investigation.
* Improved the C++ API to allow onnxruntime access to fp8 quantization.

#### Resolved issues

* Fixed multistream execution with larger models.
* Peephole LSTM Error.
* Fixed BertSquad example that could include a broken tokenizers package.
* Fixed Attention fusion ito not error with a shape mismatch when a trailing pointwise contains a literal.
* Fixed instruction::replace() logic to handle more complex cases.
* MatMulNBits could fail with a shape error.
* Fixed an issue where some models might fail to compile with an error `flatten: Shapes are not in standard layout`.

### **Composable Kernel** (1.1.0)

#### Added

* Batched CK Tile General Matrix Multiplication (GEMM) with splitK support.
* Grouped CK Tile GEMM with splitK support.
* CK Tile GEMM compute pipeline v3.
* Universal CK Tile block GEMM with interwave and intrawave schedulers .
* BF16 and INT8 WMMA GEMMs for Navi3x and Navi4x.
* Batched GEMM with output elementwise operation optimized for gfx942.
* Interwave scheduler for CK Tile GEMM mem pipeline.
* Spatially local tile partitioner in CK Tile GEMM.
* Multiple FMHA forward splitKV optimizations for decode including new N-Warp S-Shuffle pipeline.
* General FMHA forward general optimizations including refining tensor view padding configurations.
* FMHA fwd N-Warp S-Shuffle pipeline (FMHA fwd splitKV pipeline variant) .
* FMHA fwd splitKV optimization for decode (`seqlen_q=1`).
* hdim=96 support for FMHA forward.
* Variable-length paged KV cache support for FMHA forward.
* Paged KV cache support in group mode FMHA fwd splitKV kernels.
* Grouped convolution backward weight optimized irregular vector size loads.
* NGCHW BF16 grouped convolution forward support.
* Generic support for two-stage grouped convolution backward weight.
* Dynamic elementwise operation selected in runtime for convolutions.
* CK Tile transpose operator.
* CK Tile MOE operators: fused, sorting, and smooth quant.
* OCP FP8 support for gfx12.
* Support for FP8, BF16, FP16, OCP FP8, BF8, pk_int4 data types in CK Tile GEMM.
* Support for microscaling data types: MX FP4, FP6, and FP8.
* Support for gfx1201 target.
* Support for large batch tensors in grouped convolution backward data.
* Support for grouped convolution backward weight BF16 NGCHW.
* Support for cshuffle algorithm in CK Tile GEMM epilogue .
* Backend support for PyTorch 2.6.
* Test filters to select smoke tests or regression tests.
* Error threshold calculation for CK Tile GEMM examples.

#### Changed

* Expanded code generation to support dynamic compilation using hipRTC.
* Updated attention forward qs_ks_vs pipeline to support hdim=512.

#### Removed

* Removed support for gfx40 and gfx41.

#### Optimized

* Improved accuracy of BFP16 convolution.
* Improved memory access pattern for all CK Tile GEMM layouts.
* Improved CK Tile Layernorm performance and added different quantization methods.

#### Resolved issues

* Fixed CK Tile GEMM hotloop scheduler to use proper MFMA attributes.


### **HIP** (6.4.0)

#### Added

* New HIP APIs

    - `hipDeviceGetTexture1DLinearMaxWidth`  returns the maximum width of elements in a 1D linear texture, which can be allocated on the specified device.
    - `hipStreamBatchMemOp`  enqueues an array of batch memory operations in the stream, for stream synchronization.
    - `hipGraphAddBatchMemOpNode`  creates a batch memory operation node and adds it to a graph.
    - `hipGraphBatchMemOpNodeGetParams`  returns the pointer of parameters from the batch memory operation node.
    - `hipGraphBatchMemOpNodeSetParams`  sets parameters for the batch memory operation node.
    - `hipGraphExecBatchMemOpNodeSetParams`  sets the parameters for a batch memory operation node in the given executable graph.
    - `hipLinkAddData` adds SPIR-V code object data to linker instance with options.
    - `hipLinkAddFile` adds SPIR-V code object file to linker instance with options.
    - `hipLinkCreate`  creates linker instance at runtime with options.
    - `hipLinkComplete` completes linking of program and output linker binary to use with hipModuleLoadData.
    - `hipLinkDestroy`  deletes linker instance.

#### Changed

* `roc-obj` tools is deprecated and will be removed in an upcoming release.

    - Perl package installation is not required, and users will need to install this themselves if they want to.
    - Support for ROCm Object tooling has moved into `llvm-objdump` provided by package `rocm-llvm`.

* SDMA retainer logic is removed for engine selection in operation of runtime buffer copy.

#### Optimized

* `hipGraphLaunch` parallelism is improved for complex data-parallel graphs.
* Make the round-robin queue selection in command scheduling. For multi-streams execution, HSA queue from null stream lock is freed and won't occupy the queue ID after the kernel in the stream is finished.
* The HIP runtime doesn't free bitcode object before code generation. It adds a cache, which allows compiled code objects to be reused instead of recompiling. This improves performance on multi-GPU systems.
* Runtime now uses unified copy approach:

    - Unpinned `H2D` copies are no longer blocking until the size of 1 MB.
    - Kernel copy path is enabled for unpinned `H2D`/`D2H` methods.
    - The default environment variable `GPU_FORCE_BLIT_COPY_SIZE` is set to `16`, which limits the kernel copy to sizes less than 16 KB, while copies larger than that would be handled by `SDMA` engine.
    - Blit code is refactored, and ASAN instrumentation is cleaned up.

#### Resolved issues

* Out-of-memory error on Microsoft Windows. When the user calls `hipMalloc` for device memory allocation while specifying a size larger than the available device memory, the HIP runtime fixes the error in the API implementation, allocating the available device memory plus system memory (shared virtual memory).
* Error of dependency on `libgcc-s1` during rocm-dev install on Debian Buster. HIP runtime now uses `libgcc1` for this distros.
* Stack corruption during kernel execution. HIP runtime now adds a maximum stack size limit based on the GPU device feature. 

#### Upcoming changes

The following lists the backward incompatible changes planned for upcoming major ROCm releases.

* Signature changes in APIs to correspond with NVIDIA CUDA APIs,

    - `hiprtcCreateProgram`
    - `hiprtcCompileProgram`
    - `hipCtxGetApiVersion`

* Behavior of `hipPointerGetAttributes` is changed to match corresponding CUDA API in version 11 and later releases.
* Return error/value code updates in the following hip APIs to match the corresponding CUDA APIs,

    - `hipModuleLaunchKernel`
    - `hipExtModuleLaunchKernel`
    - `hipModuleLaunchCooperativeKernel`
    - `hipGetTextureAlignmentOffset`
    - `hipTexObjectCreate`
    - `hipBindTexture2D`
    - `hipBindTextureToArray`
    - `hipModuleLoad`
    - `hipLaunchCooperativeKernelMultiDevice`
    - `hipExtLaunchCooperativeKernelMultiDevice`

* HIPRTC implementation, the compilation of `hiprtc` now uses  namespace ` __hip_internal`, instead of the standard headers `std`.
* Stream capture mode updates in the following HIP APIs. Streams can only be captured in relax mode, to match the behavior of the corresponding CUDA APIs,

   - `hipMallocManaged`
   - `hipMemAdvise`
   - `hipLaunchCooperativeKernelMultiDevice`
   - `hipDeviceSetCacheConfig`
   - `hipDeviceSetSharedMemConfig`
   - `hipMemPoolCreate`
   - `hipMemPoolDestory`
   - `hipDeviceSetMemPool`
   - `hipEventQuery`

* The implementation of `hipStreamAddCallback` is updated, to match the behavior of CUDA.
* Removal of `hiprtc` symbols from hip library.

    - `hiprtc` will be a independent library, and all symbols supported in HIP library are removed.
    - Any application using `hiprtc` APIs should link explicitly with `hiprtc` library.
    - This change makes the use of `hiprtc` library on Linux the same as on Windows, and matches the behavior of CUDA `nvrtc`.

* Removal of deprecated struct `HIP_MEMSET_NODE_PARAMS`, Developers can use definition `hipMemsetParams` instead.

### **hipBLAS** (2.4.0)

#### Changed

* Updated the build dependencies.

#### Resolved issues

* Fixed the Windows reference library interface for rocSOLVER functions for hipBLAS clients.

### **hipBLASLt** (0.12.0)

#### Added

* Support ROC-TX if `HIPBLASLT_ENABLE_MARKER=1` is set.
* Output the profile logging if `HIPBLASLT_LOG_MASK=64` is set.
* Support for the `FP16` compute type.
* Memory bandwidth information to the hipblaslt-bench output.
* Support the user offline tuning mechanism.
* More samples.

#### Changed

* Output the bench command along with the solution index if `HIPBLASLT_LOG_MASK=32` is set.

#### Optimized

* Improve the overall performance of the XF32/FP16/BF16/FP8/BF8 data types.
* Reduce the library size.

#### Resolved issues

* Fixed multi-threads bug.
* Fixed multi-streams bug.

### **hipCUB** (3.4.0)

#### Added

* Added regression tests to `rtest.py`. These tests recreate scenarios that have caused hardware problems in past emulation environments. Use `python rtest.py [--emulation|-e|--test|-t]=regression` to run these tests.
* Added extended tests to `rtest.py`. These tests are extra tests that did not fit the criteria of smoke and regression tests. These tests will take much longer than smoke and regression tests. Use `python rtest.py [--emulation|-e|--test|-t]=extended` to run these tests.
* Added `ForEach`, `ForEachN`, `ForEachCopy`, `ForEachCopyN` and `Bulk` functions to have parity with CUB.
* Added the `hipcub::CubVector` type for CUB parity.
* Added `--emulation` option for `rtest.py`
* Unit tests can be run with `[--emulation|-e|--test|-t]=<test_name>;`.
* Added `DeviceSelect::FlaggedIf` and its inplace overload.
* Added CUB macros missing from hipCUB: `HIPCUB_MAX`, `HIPCUB_MIN`, `HIPCUB_QUOTIENT_FLOOR`, `HIPCUB_QUOTIENT_CEILING`, `HIPCUB_ROUND_UP_NEAREST` and `HIPCUB_ROUND_DOWN_NEAREST`.
* Added `hipcub::AliasTemporaries` function for CUB parity.

#### Changed

* Removed usage of `std::unary_function` and `std::binary_function` in `test_hipcub_device_adjacent_difference.cpp`.
* Changed the subset of tests that are run for smoke tests such that the smoke test will complete with faster run time and never exceed 2 GB of VRAM usage. Use `python rtest.py [--emulation|-e|--test|-t]=smoke` to run these tests.
* The `rtest.py` options have changed. `rtest.py` is now run with at least either `--test|-t` or `--emulation|-e`, but not both options.
* The NVIDIA backend now requires CUB, Thrust, and libcu++ 2.5.0. If it is not found, it will be downloaded from the NVIDIA CCCL repository.
* Changed the C++ version from 14 to 17. C++14 will be deprecated in the next major release.

#### Known issues

* When building on Microsoft Windows using HIP SDK for ROCm 6.4, ``hipMalloc`` returns ``hipSuccess`` even when the size passed to it is too large and the allocation fails. Because of this, limits have been set for the maximum test case sizes for some unit tests such as HipcubDeviceRadixSort&#39;s SortKeysLargeSizes .

### **hipFFT** (1.0.18)

#### Added

* Implemented the `hipfftMpAttachComm`, `hipfftXtSetDistribution`, and `hipfftXtSetSubformatDefault` APIs to allow
  computing FFTs that are distributed between multiple MPI (Message Passing Interface) processes.  These APIs can be enabled
  with the `HIPFFT_MPI_ENABLE` CMake option, which defaults to `OFF`. The backend FFT library called by hipFFT must support MPI for these APIs to work.

  The backend FFT library called by hipFFT must support MPI for these APIs to work.

#### Changed

* Building with the address sanitizer option sets xnack+ for the relevant GPU
  architectures.
* Use the `find_package` CUDA toolkit instead of CUDA in CMake for modern CMake compatibility.
* The `AMDGPU_TARGETS` build variable should be replaced with `GPU_TARGETS`. `AMDGPU_TARGETS` is deprecated.

#### Resolved issues

* Fixed the client packages so they depend on hipRAND instead of rocRAND.

### **hipfort** (0.6.0)

#### Upcoming changes

* The hipfc compiler wrapper has been deprecated and will be removed
  in a future release. Users are encouraged to directly invoke their
  Fortran or HIP compilers as appropriate for each source file.

### **HIPIFY** (19.0.0)

#### Added
* NVIDIA CUDA 12.6.3 support
* cuDNN 9.7.0 support
* cuTENSOR 2.0.2.1 support
* LLVM 19.1.7 support
* Full support for direct hipification of `cuRAND` into `rocRAND` under the `--roc` option.
* Support for `fp8` math device/host API. For more information see [#1617](https://github.com/ROCm/HIPIFY/issues/1617) in the HIPIFY Github repository.

#### Resolved issues
* `MIOpen` support in hipify-perl under the `-miopen` option
* Use `const_cast<const char**>` for the last arguments in the `hiprtcCreateProgram` and `hiprtcCompileProgram` function calls, as in CUDA, they are of the `const char* const*` type
* Support for `fp16` device/host API. For more information see [#1769](https://github.com/ROCm/HIPIFY/issues/1769) in the HIPIFY Github repository.
* Fixed instructions on building LLVM for HIPIFY on Linux. For more information see [#1800](https://github.com/ROCm/HIPIFY/issues/1800) in the HIPIFY Github repository.

#### Known issues

* `hipify-clang` build failure against LLVM 15-18 on `Ubuntu`, `CentOS`, and `Fedora`. For more information see [#833](https://github.com/ROCm/HIPIFY/issues/833) in the HIPIFY Github repository.

### **hipRAND** (2.12.0)

#### Changed

* When building hipRAND on Windows, use `HIP_PATH` (instead of the former `HIP_DIR`) to specify the path to the HIP SDK installation.
* When building with the `rmake.py` script, `HIP_PATH` will default to `C:\hip` if it is not set.
  
#### Resolved issues

* Fixed an issue causing hipRAND build failures on Windows when the HIP SDK was installed in a location with a path that contains spaces.

### **hipSOLVER** (2.4.0)

#### Added

* The `csrlsvqr` compatibility-only functions `hipsolverSpScsrlsvqr`, `hipsolverSpDcsrlsvqr`, `hipsolverSpCcsrlsvqr`, `hipsolverSpZcsrlsvqr`

### **hipSPARSE** (3.2.0)

#### Added

* Added the `azurelinux` operating system name to correct the GFortran dependency.

#### Optimized

* Removed an unused `GTest` dependency from `hipsparse-bench`.

### **hipSPARSELt** (0.2.3)

#### Added

* Support for alpha vector scaling

#### Changed

* The check mechanism of the inputs when using alpha vector scaling

### **hipTensor** (1.5.0)

#### Added

* Added benchmarking suites for contraction, permutation, and reduction. YAML files are categorized into bench and validation folders for organization.
* Added emulation test suites for contraction, permutation, and reduction.
* Support has been added for changing the default data layout using the `HIPTENSOR_DEFAULT_STRIDES_COL_MAJOR` environment variable.

#### Changed

* `GPU_TARGETS` is now used instead of `AMDGPU_TARGETS` in `cmakelists.txt`.
* Binary sizes can be reduced on supported compilers by using the `--offload-compress` compiler flag.

#### Optimized

* Optimized the hyper-parameter selection algorithm for permutation.

#### Resolved issues

* For a CMake bug workaround, set `CMAKE_NO_BUILTIN_CHRPATH` when `BUILD_OFFLOAD_COMPRESS` is unset.

#### Upcoming changes
 
* hipTensor will enhance performance and usability while unifying the API design across all operations (elementwise, reductions, and tensor contractions), enabling consistent multi-stage execution and plan reuse. As part of this change, the API functions `hiptensorInitTensorDescriptor`, `hiptensorContractionDescriptor_t` , `hiptensorInitContractionDescriptor`, `hiptensorInitContractionFind`, `hiptensorContractionGetWorkspaceSize`, `hiptensorInitContractionPlan`, `hiptensorContraction`, `hiptensorElementwiseBinary`, `hiptensorElementwiseTrinary`, `hiptensorPermutation`, and `hiptensorReduction` will be deprecated in a future ROCm release.

### **llvm-project** (19.0.0)

#### Added

* Support for `amdgpu_max_num_work_groups` in the compiler. This attribute
  can be set by end users or library developers. It provides an upper limit
  for workgroups as described in [AMD GPU Attributes](https://clang.llvm.org/docs/AttributeReference.html#amdgpu-max-num-work-groups).
  When set, the AMDGPU target backend might produce better machine code. 

### **MIOpen** (3.4.0)

#### Added

* [Conv] Enabled tuning through the `miopenSetConvolutionFindMode` API.
* [RNN] Added the new algorithm type `miopenRNNroundedDynamic` for LSTM.
* [TunaNet] Enabled NHWC for AMD Instinct MI300.

#### Optimized

* Updated KernelTuningNet for CK solvers.

#### Resolved issues

* Fixed tuning timing results.
* Accuracy for ASM solvers.

### **MIVisionX** (3.2.0)

#### Changed

* OpenCV is now installed with the package installer on Ubuntu.
* AMD Clang is now the default CXX and C compiler.
* The version of OpenMP included in the ROCm LLVM project is now used instead of `libomp-dev/devel`.

#### Known issues

* Installation on CentOS, RedHat, and SLES requires manually installing the `FFMPEG` and `OpenCV` dev packages.
* Hardware decode requires the ROCm `graphics` use case.

#### Upcoming changes

* Optimized audio augmentations support for VX_RPP

### **rccl** (2.22.3)

#### Added

* Added the `RCCL_SOCKET_REUSEADDR` and `RCCL_SOCKET_LINGER` environment parameters.
* Setting `NCCL_DEBUG=TRACE NCCL_DEBUG_SUBSYS=VERBS` will generate traces for fifo and data `ibv_post_send` calls.
* Added the `--log-trace` flag to enable traces through the `install.sh` script (for example, `./install.sh --log-trace`).

#### Changed

* Changed compatibility to include NCCL 2.22.3.

### **rocAL** (2.2.0)

#### Changed

* AMD Clang is now the default CXX and C compiler.

#### Known issues

* The package installation requires manually installing `TurboJPEG`.
* Installation on CentOS, RedHat, and SLES requires manually installing the `FFMPEG Dev` package.
* Hardware decode requires installing ROCm with the `graphics` use case.

### **rocALUTION** (3.2.2)

#### Changed

* Improved documentation

### **rocBLAS** (4.4.0)

#### Added

* Added ROC-TX support in rocBLAS (not available on Windows or in the static library version on Linux).
* On gfx12, all functions now support full `rocblas_int` dynamic range for `batch_count`.
* Added the `--ninja` build option.
* Added support for the `GPU_TARGETS` CMake variable.

#### Changed

* The rocblas-test client removes the stress tests unless YAML-based testing or `gtest_filter` adds them.
* OpenMP default threading for rocBLAS clients is reduced to less than the logical core count.
* `gemm_ex` testing and timing reuses device memory.
* `gemm_ex` timing initializes matrices on device.

#### Optimized

* Significantly reduced workspace memory requirements for Level 1 ILP64: `iamax` and `iamin`.
* Reduced the workspace memory requirements for Level 1 ILP64: `dot`, `asum`, and `nrm2`.
* Improved the performance of Level 2 gemv for the problem sizes (`TransA == N && m > 2*n`) and (`TransA == T`).
* Improved the performance of Level 3 syrk and herk for the problem size (`k > 500 && n < 4000`).

#### Resolved issues

* gfx12: `ger`, `geam`, `geam_ex`, `dgmm`, `trmm`, `symm`, `hemm`, ILP64 `gemm`, and larger data support.
* Added a `gfortran` package dependency for Azure Linux OS.
* Resolved outdated SLES operating system package dependencies (`cxxtools` and `joblib`) in `install.sh -d`.
* Fixed code object stripping for RPM packages.

#### Upcoming changes

* CMake variable `AMDGPU_TARGETS` is deprecated. Use `GPU_TARGETS` instead.

### **ROCdbgapi** (0.77.2)

#### Added

* Support for generic code object targets:
    - `gfx9-generic`
    - `gfx9-4-generic`
    - `gfx10-1-generic`
    - `gfx10-3-generic`
    - `gfx11-generic`
    - `gfx12-generic`

#### Changed

* The name reported for detected agents is now based on the `amdgpu.ids` database provided by `libdrm`.

### **rocDecode** (0.10.0)

#### Added

* The new bitstream reader feature has been added. The bitstream reader contains built-in stream file parsers, including an elementary stream file parser and an IVF container file parser. The reader can parse AVC, HEVC, and AV1 elementary stream files, and AV1 IVF container files. Additional supported formats will be added.
* VP9 support has been added.
* More CTests have been added: VP9 test and tests on video decode raw sample.
* Two new samples, videodecoderaw and videodecodepicfiles, have been added. videodecoderaw uses the bitstream reader instead of the FFMPEG demuxer to get picture data, and videodecodepicfiles shows how to decode an elementary video stream stored in multiple files, with each file containing bitstream data of a coded picture.

#### Changed

* AMD Clang++ is now the default CXX compiler.
* Moved MD5 code out of the RocVideoDecode utility.

#### Removed

* FFMPEG executable requirement for the package.

### **rocFFT** (1.0.32)

#### Changed

* Building with the address sanitizer option sets xnack+ on the relevant GPU
  architectures and adds address-sanitizer support to runtime-compiled
  kernels.
* The `AMDGPU_TARGETS` build variable should be replaced with `GPU_TARGETS`. `AMDGPU_TARGETS` is deprecated.

#### Removed

* Ahead-of-time compiled kernels for the gfx906, gfx940, and gfx941 architectures. These architectures still work the same way, but their kernels are now compiled at runtime.
* Consumer GPU architectures from the precompiled kernel cache that ships with
  rocFFT. rocFFT continues to ship with a cache of precompiled RTC kernels for data center
  and workstation architectures. As before, user-level caches can be enabled by setting the
  environment variable `ROCFFT_RTC_CACHE_PATH` to a writeable file location.

#### Optimized

* Improved MPI transform performance by using all-to-all communication for global transpose operations.  
  Point-to-point communications are still used when all-to-all is unavailable.
* Improved the performance of unit-strided, complex interleaved, forward, and inverse length (64,64,64) FFTs.

#### Resolved issues

* Fixed incorrect results from 2-kernel 3D FFT plans that used non-default output strides. For more information, see the [rocFFT GitHub issue](https://github.com/ROCm/rocFFT/issues/507).
* Plan descriptions can now be reused with different strides for different plans. For more information, see the [rocFFT GitHub issue](https://github.com/ROCm/rocFFT/issues/504).
* Fixed client packages to depend on hipRAND instead of rocRAND.
* Fixed potential integer overflows during large MPI transforms.

### **ROCm Compute Profiler** (3.1.0)

#### Added

* Roofline support for Ubuntu 24.04.
* Experimental support `rocprofv3` (not enabled as default).

#### Resolved issues

* Fixed PoP of VALU Active Threads.
* Workaround broken mclk for old version of rocm-smi.

### **ROCgdb** (15.2)

#### Added

- Support for debugging shaders compiled for the following generic targets:
    - `gfx9-generic`
    - `gfx9-4-generic`
    - `gfx10-1-generic`
    - `gfx10-3-generic`
    - `gfx11-generic`
    - `gfx12-generic`

### **ROCm Data Center Tool** (0.3.0)

#### Added

* RDC policy feature
* Power and thermal throttling metrics
* RVS [IET](https://github.com/ROCm/ROCmValidationSuite/tree/a6177fc5e3f2679f98bbbc80dc536d535a43fb69/iet.so), [PEBB](https://github.com/ROCm/ROCmValidationSuite/tree/a6177fc5e3f2679f98bbbc80dc536d535a43fb69/pebb.so), and [memory bandwidth tests](https://github.com/ROCm/ROCmValidationSuite/tree/a6177fc5e3f2679f98bbbc80dc536d535a43fb69/babel.so)
* Link status
* RDC_FI_PROF_SM_ACTIVE metric

#### Changed

* Migrated from [ROCProfiler](https://github.com/ROCm/rocprofiler) to [ROCprofiler-SDK](https://github.com/ROCm/rocprofiler-sdk)
* Improved README.md for better usability
* Moved `rdc_options` into `share/rdc/conf/`

#### Resolved issues

* Fixed ABSL in clang18+

### **rocJPEG** (0.8.0)

#### Changed

* AMD Clang++ is now the default CXX compiler.
* The jpegDecodeMultiThreads sample has been renamed to jpegDecodePerf, and batch decoding has been added to this sample instead of single image decoding for improved performance.

### **ROCm SMI** (7.5.0)

#### Added

- Added support for GPU metrics 1.7 to `rsmi_dev_gpu_metrics_info_get()`.

- Added new GPU metrics 1.7 to `rocm-smi --showmetrics`.

#### Resolved issues

- Fixed `rsmi_dev_target_graphics_version_get`, `rocm-smi --showhw`, and `rocm-smi --showprod` not displaying graphics version correctly for Instinct MI200 Series, MI100 Series, and RDNA3-based GPUs. 

> [!NOTE]
> See the full [ROCm SMI changelog](https://github.com/ROCm/rocm_smi_lib/blob/release/rocm-rel-6.4/CHANGELOG.md) for details, examples, and in-depth descriptions.

### **ROCm Systems Profiler** (1.0.0)

#### Added 

- Support for VA-API and rocDecode tracing.
- Aggregation of MPI data collected across distributed nodes and ranks. The data is concatenated into a single proto file.

#### Changed
- Backend refactored to use [ROCprofiler-SDK](https://github.com/ROCm/rocprofiler-sdk) rather than [ROCProfiler](https://github.com/ROCm/rocprofiler) and [ROCTracer](https://github.com/ROCm/ROCTracer).

#### Resolved issues

- Fixed hardware counter summary files not being generated after profiling.

- Fixed an application crash when collecting performance counters with rocprofiler.

- Fixed interruption in config file generation.

- Fixed segmentation fault while running rocprof-sys-instrument.
- Fixed an issue where running `rocprof-sys-causal` or using the `-I all` option with `rocprof-sys-sample` caused the system to become non-responsive.

- Fixed an issue where sampling multi-GPU Python workloads caused the system to stop responding.

### **ROCm Validation Suite** (1.1.0)

#### Added

* Configuration files for MI210.
* Support for OCP fp8 data type.
* GPU index-based CLI execution.

#### Changed

* JSON logging with updated schema.

### **rocPRIM** (3.4.0)

#### Added

* The parallel `find_first_of` device function with autotuned configurations has been added. This function is similar to `std::find_first_of`. It searches for the first occurrence of any of the provided elements.
* Tuned configurations for segmented radix sort for gfx942 have been added to improve performance on the gfx942 architecture.
* The parallel device-level function, `rocprim::adjacent_find`, which is similar to the C++ Standard Library `std::adjacent_find` algorithm, has been added.
* Configuration autotuning has been added to device adjacent find (`rocprim::adjacent_find`) for improved performance on selected architectures.
* `rocprim::numeric_limits` has been added. This is an extension of `std::numeric_limits` that supports 128-bit integers.
* `rocprim::int128_t` and `rocprim::uint128_t` have been added. 
* The parallel `search` and `find_end` device functions have been added. These are similar to `std::search` and `std::find_end`. These functions search for the first and last occurrence of the sequence, respectively.
* A parallel device-level function, `rocprim::search_n`, has been added. `rocprim::search_n` is similar to the C++ Standard Library `std::search_n` algorithm.
* New constructors, a `base` function, and a `constexpr` specifier have been added to all functions in `rocprim::reverse_iterator` to improve parity with the C++17 `std::reverse_iterator`.
* hipGraph support has been added to the device run-length-encode for non-trivial runs (`rocprim::run_length_encode_non_trivial_runs`).
* Configuration autotuning has been added to the device run-length-encode for non-trivial runs (`rocprim::run_length_encode_non_trivial_runs`) for improved performance on selected architectures.
* Configuration autotuning has been added to the device run-length-encode for trivial runs (`rocprim::run_length_encode`) for improved performance on selected architectures.
* The `--emulation` option has been added to `rtest.py`. Unit tests can be run with `python rtest.py [--emulation|-e|--test|-t]=<test_name>`.
* Extended and regression tests have been added to `rtest.py`. Extended tests are tests that don't fit the criteria of smoke or regression tests, and take longer than smoke or regression tests to run. Use `python rtest.py [--emulation|-e|--test|-t]=extended` to run extended tests, and `python rtest.py [--emulation|-e|--test|-t]=regression` to run regression tests.
* Added a new type traits interface to enable users to provide additional type trait information to rocPRIM, facilitating better compatibility with custom types.

#### Changed

* Changed the subset of tests that are run for smoke tests such that the smoke test will complete faster and never exceed 2 GB of VRAM usage. Use `python rtest.py [--emulation|-e|--test|-t]=smoke` to run these tests.
* The `rtest.py` options have changed. `rtest.py` is now run with at least either `--test|-t` or `--emulation|-e`, but not both options.
* Changed the internal algorithm of block radix sort to use a rank match. This improves the performance of various radix sort-related algorithms.
* Disabled padding in various cases where higher occupancy resulted in better performance despite more bank conflicts.
* The C++ version has changed from 14 to 17. C++14 will be deprecated in the next major release.
* You can use CMake HIP language support with CMake 3.18 and later. To use HIP language support, run `cmake` with `-DUSE_HIPCXX=ON` instead of setting the `CXX` variable to the path to a HIP-aware compiler.

#### Removed

* HIP-CPU support

#### Resolved issues

* Fixed an issue where `rmake.py` generated incorrect cmake commands in a Linux environment.
* Fixed an issue where `rocprim::partial_sort_copy` would yield a compile error if the input iterator was a const.
* Fixed incorrect 128-bit signed and unsigned integer type traits.
* Fixed a compilation issue when `rocprim::radix_key_codec<...>` is specialized with a 128-bit integer.
* Fixed the warp-level reduction `rocprim::warp_reduce.reduce` DPP implementation to avoid undefined intermediate values during the reduction.
* Fixed an issue that caused a segmentation fault when `hipStreamLegacy` was passed to certain API functions.

#### Upcoming changes

* Using the initialization constructor of `rocprim::reverse_iterator` will throw a deprecation warning. It will be marked as explicit in the next major release.

### **ROCProfiler** (2.0.0)

#### Added
* Ops 16, 32, and 64 metrics for RDC.
* Tool deprecation message for ROCProfiler and ROCProfilerV2.

#### Changed
* Updated README for kernel filtration.

#### Resolved issues

* Fixed the program crash issue due to invalid UTF-8 characters in a trace log.

### **ROCprofiler-SDK** (0.6.0)

#### Added

* Support for `select()` operation in counter expression.
* `reduce()` operation for counter expression with respect to dimension.
* `--collection-period` feature in `rocprofv3` to enable filtering using time.
* `--collection-period-unit` feature in `rocprofv3` to control time units used in the collection period option.
* Deprecation notice for ROCProfiler and ROCProfilerV2.
* Support for rocDecode API Tracing.
* Usage documentation for ROCTx.
* Usage documentation for MPI applications.
* SDK: `rocprofiler_agent_v0_t` support for agent UUIDs.
* SDK: `rocprofiler_agent_v0_t` support for agent visibility based on gpu isolation environment variables such as `ROCR_VISIBLE_DEVICES` and so on.
* Accumulation VGPR support for `rocprofv3`.
* Host-trap based PC sampling support for `rocprofv3`.
* Support for OpenMP tool.

### **rocPyDecode** (0.3.1)

#### Added

* VP9 support

#### Changed

* AMD Clang is now the default CXX and C compiler.

#### Removed

* All MD5 functionality, APIs, and sample code have been removed.

#### Resolved issues

* Ubuntu 24.04 compile failure with FFmpeg version 5.X and above has been fixed.

### **rocRAND** (3.3.0)

#### Added

* Extended tests to `rtest.py`. These tests are extra tests that did not fit the criteria of smoke and regression tests. They take much longer to run relative to smoke and regression tests. Use `python rtest.py [--emulation|-e|--test|-t]=extended` to run these tests.
* Added regression tests to `rtest.py`. These tests recreate scenarios that have caused hardware problems in past emulation environments. Use `python rtest.py [--emulation|-e|--test|-t]=regression` to run these tests.
* Added smoke test options, which run a subset of the unit tests and ensure that less than 2 GB of VRAM will be used. Use `python rtest.py [--emulation|-e|--test|-t]=smoke` to run these tests.
* The `--emulation` option for `rtest.py`.

#### Changed

* `--test|-t` is no longer a required flag for `rtest.py`. Instead, the user can use either `--emulation|-e` or `--test|-t`, but not both.
* Removed the TBB dependency for multi-core processing of host-side generation.

### **ROCr Debug Agent** (2.0.4)

#### Added

* Functionality to print the associated kernel name for each wave.

### **ROCr Runtime** (1.15.0)

#### Added

* Support for asynchronous scratch reclaim on AMD Instinct MI300X GPUs. Asynchronous scratch reclaim allows scratch memory that was assigned to Command Processor(cp) queues to be reclaimed back in case the application runs out of device memory or if the `hsa_amd_agent_set_async_scratch_limit` API is called with the threshold parameter as 0.

### **rocSOLVER** (3.28.0)

#### Added

* Application of a sequence of plane rotations to a given matrix for LASR
* Algorithm selection mechanism for hybrid computation
* Hybrid computation support for existing routines:
    - BDSQR
    - GESVD

#### Optimized

* Improved the performance of SYEVJ.
* Improved the performance of GEQRF.

### **rocSPARSE** (3.4.0)

#### Added

* Added support for `rocsparse_matrix_type_triangular` in `rocsparse_spsv`.
* Added test filters `smoke`, `regression`, and `extended` for emulation tests.
* Added `rocsparse_[s|d|c|z]csritilu0_compute_ex` routines for iterative ILU.
* Added `rocsparse_[s|d|c|z]csritsv_solve_ex` routines for iterative triangular solve.
* Added `GPU_TARGETS` to replace the now deprecated `AMDGPU_TARGETS` in CMake files.
* Added BSR format to the SpMM generic routine `rocsparse_spmm`.

#### Changed

* By default, the rocSPARSE shared library is built using the `--offload-compress` compiler option which compresses the fat binary. This significantly reduces the shared library binary size.

#### Optimized

* Improved the performance of `rocsparse_spmm` when used with row order for `B` and `C` dense matrices and the row split algorithm `rocsparse_spmm_alg_csr_row_split`.
* Improved the adaptive CSR sparse matrix-vector multiplication algorithm when the sparse matrix has many empty rows at the beginning or at the end of the matrix. This improves the routines `rocsparse_spmv` and `rocsparse_spmv_ex` when the adaptive algorithm `rocsparse_spmv_alg_csr_adaptive` is used.
* Improved stream CSR sparse matrix-vector multiplication algorithm when the sparse matrix size (number of rows) decreases. This improves the routines `rocsparse_spmv` and `rocsparse_spmv_ex` when the stream algorithm `rocsparse_spmv_alg_csr_stream` is used.
* Compared to `rocsparse_[s|d|c|z]csritilu0_compute`, the routines `rocsparse_[s|d|c|z]csritilu0_compute_ex` introduce several free iterations. A free iteration is an iteration that does not compute the evaluation of the stopping criteria, if enabled. This allows the user to tune the algorithm for performance improvements.
* Compared to `rocsparse_[s|d|c|z]csritsv_solve`, the routines `rocsparse_[s|d|c|z]csritsv_solve_ex` introduce several free iterations. A free iteration is an iteration that does not compute the evaluation of the stopping criteria. This allows the user to tune the algorithm for performance improvements.
* Improved the user documentation.

#### Resolved issues

* Fixed an issue in `rocsparse_spgemm`, `rocsparse_[s|d|c|z]csrgemm`, and `rocsparse_[s|d|c|z]bsrgemm` where incorrect results could be produced when rocSPARSE was built with optimization level `O0`. This was caused by a bug in the hash tables that could allow keys to be inserted twice.
* Fixed an issue in the routine `rocsparse_spgemm` when using `rocsparse_spgemm_stage_symbolic` and `rocsparse_spgemm_stage_numeric`, where the routine would crash when `alpha` and `beta` were passed as host pointers and where `beta != 0`.
* Fixed an issue in `rocsparse_bsrilu0`, where the algorithm was running out of bounds of the `bsr_val` array.

#### Upcoming changes

* Deprecated the `rocsparse_[s|d|c|z]csritilu0_compute` routines. Users should use the newly added `rocsparse_[s|d|c|z]csritilu0_compute_ex` routines going forward.
* Deprecated the `rocsparse_[s|d|c|z]csritsv_solve` routines. Users should use the newly added `rocsparse_[s|d|c|z]csritsv_solve_ex` routines going forward.
* Deprecated the use of `AMDGPU_TARGETS` in CMake files. Users should use `GPU_TARGETS` going forward.

### **ROCTracer** (4.1.0)

#### Added

* Tool deprecation message for ROCTracer.

### **rocThrust** (3.3.0)

#### Added

* Added a section to install Thread Building Block (TBB) inside `cmake/Dependencies.cmake` if TBB is not already available.
* Made TBB an optional dependency with the new `BUILD_HIPSTDPAR_TEST_WITH_TBB` flag. When the flag is `OFF` and TBB is not already on the machine, it will compile without TBB. Otherwise, it will compile with TBB.
* Added extended tests to `rtest.py`. These tests are extra tests that did not fit the criteria of smoke and regression tests. These tests will take much longer than smoke and regression tests. Use `python rtest.py [--emulation|-e|--test|-t]=extended` to run these tests.
* Added regression tests to `rtest.py`. These tests recreate scenarios that have caused hardware problems in past emulation environments. Use `python rtest.py [--emulation|-e|--test|-t]=regression` to run these tests.
* Added smoke test options, which run a subset of the unit tests and ensure that less than 2 GB of VRAM will be used. Use `python rtest.py [--emulation|-e|--test|-t]=smoke` to run these tests.
* Added `--emulation` option for `rtest.py`
* Merged changes from upstream CCCL/thrust 2.4.0 and CCCL/thrust 2.5.0.
* Added `find_first_of`, `find_end`, `search`, and `search_n` to HIPSTDPAR.
* Updated HIPSTDPAR's `adjacent_find` to use the rocPRIM implementation.

#### Changed

* Changed the C++ version from 14 to 17. C++14 will be deprecated in the next major release.
* `--test|-t` is no longer a required flag for `rtest.py`. Instead, the user can use either `--emulation|-e` or `--test|-t`, but not both.
* Split HIPSTDPAR's forwarding header into several implementation headers.
* Fixed `copy_if` to work with large data types (512 bytes).

#### Known issues

*  `thrust::inclusive_scan_by_key` might produce incorrect results when it's used with -O2 or -O3 optimization.  This is caused by a recent compiler change and a fix will be made available at a later date.

### **rocWMMA** (1.7.0)

#### Added

* Added interleaved layouts that enhance the performance of GEMM operations.
* Emulation test suites. These suites are lightweight and well suited for execution on emulator platforms.

#### Changed

* Used `GPU_TARGETS` instead of `AMDGPU_TARGETS` in `cmakelists.txt`.
* Binary sizes can be reduced on supported compilers by using the `--offload-compress` compiler flag.

#### Resolved issues

* For a CMake bug workaround, set `CMAKE_NO_BUILTIN_CHRPATH` when `BUILD_OFFLOAD_COMPRESS` is unset.

#### Upcoming changes
 
* rocWMMA will augment the fragment API objects with additional meta-properties that improve API expressiveness and configurability of parameters including multiple-wave cooperation. As part of this change, cooperative rocWMMA API functions `load_matrix_coop_sync` and `store_matrix_coop_sync` will be deprecated in a future ROCm release.

### **rpp** (1.9.10)

#### Added

* RPP Tensor Gaussian Filter and Tensor Box Filter support on HOST (CPU) backend.
* RPP Fog and Rain augmentation on HOST (CPU) and HIP backends.
* RPP Warp Perspective on HOST (CPU) and HIP backends.
* RPP Tensor Bitwise-XOR support on HOST (CPU) and HIP backends.
* RPP Threshold on HOST (CPU) and HIP backends.
* RPP Audio Support for Spectrogram and Mel Filter Bank on HIP backend.

#### Changed

* AMD Clang is now the default CXX and C compiler.
* AMD RPP can now pass HOST (CPU) build with g++.
* Test Suite case numbers have been replaced with ENUMs for all augmentations to enhance test suite readability.
* Test suite updated to return error codes from RPP API and display them.

#### Resolved issues

* CXX Compiler: Fixed HOST (CPU) g++ issues. 
* Deprecation warning fixed for the `sprintf is deprecated` warning.
* Test suite build fix - RPP Test Suite Pre-requisite instructions updated to lock to a specific `nifti_clib` commit.
* Fixed broken image links for pixelate and jitter.

### **Tensile** (4.43.0)

#### Added

- Nightly builds with performance statistics.
- ASM cache capabilities for reuse.
- Virtual environment (venv) for `TensileCreateLibrary` invocation on Linux.
- Flag to keep `build_tmp` when running Tensile.
- Generalized profiling scripts.
- Support for gfx1151.
- Single-threaded support in `TensileCreateLibrary`.
- Logic to remove temporary build artifacts.

#### Changed

- Disabled ASM cache for tests.
- Replaced Perl script with `hipcc.bat` as a compiler on Microsoft Windows.
- Improved CHANGELOG.md.
- Enabled external CI.
- Improved Tensile documentation.
- Refactored kernel source and header creation.
- Refactored `writeKernels` in `TensileCreateLibrary`.
- Suppressed developer warnings to simplify the Tensile output.
- Introduced an explicit cast when invoking `min`.
- Introduced cache abbreviations to compute kernel names.

#### Removed

- OCL backend
- Unsupported tests
- Deep copy in `TensileCreateLibrary`

#### Optimized

- Linearized ASM register search to reduce build time.

#### Resolved issues

- Fixed Stream-K dynamic grid model.
- Fixed logic related to caching ASM capabilities.
- Fixed `accvgpr` overflow.
- Fixed test failures in SLES containers when running `TensileTests`.
- Fixed a regression that prevents `TensileCreateLibrary` from completing when fallback logic is not available.

## ROCm 6.3.3

See the [ROCm 6.3.3 release notes](https://rocm.docs.amd.com/en/docs-6.3.3/about/release-notes.html)
for a complete overview of this release.

### **ROCm Systems Profiler** (0.1.2)

#### Resolved issues

* Fixed an error that prevented GPU hardware activity from being presented in certain workloads.  

## ROCm 6.3.2

See the [ROCm 6.3.2 release notes](https://rocm.docs.amd.com/en/docs-6.3.2/about/release-notes.html)
for a complete overview of this release.

### **HIP** (6.3.2)

#### Added

* Tracking of Heterogeneous System Architecture (HSA) handlers:
    - Adds an atomic counter to track the outstanding HSA handlers.
    - Waits on CPU for the callbacks if the number exceeds the defined value.
* Codes to capture Architected Queueing Language (AQL) packets for HIP graph memory copy node between host and device. HIP enqueues AQL packets during graph launch.
* Control to use system pool implementation in runtime commands handling. By default, it is disabled.
* A new path to avoid `WaitAny` calls in `AsyncEventsLoop`. The new path is selected by default.
* Runtime control on decrement counter only if the event is popped. There is a new way to restore dead signals cleanup for the old path.
* A new logic in runtime to track the age of events from the kernel mode driver.

#### Optimized

* HSA callback performance. The HIP runtime creates and submits commands in the queue and interacts with HSA through a callback function. HIP waits for the CPU status from HSA to optimize the handling of events, profiling, commands, and HSA signals for higher performance.
* Runtime optimization which combines all logic of `WaitAny` in a single processing loop and avoids extra memory allocations or reference counting. The runtime won't spin on the CPU if all events are busy.
* Multi-threaded dispatches for performance improvement.
* Command submissions and processing between CPU and GPU by introducing a way to limit the software batch size.
* Switch to `std::shared_mutex` in book/keep logic in streams from multiple threads simultaneously, for performance improvement in specific customer applications.
* `std::shared_mutex` is used in memory object mapping, for performance improvement.

#### Resolved issues

* Race condition in multi-threaded producer/consumer scenario with `hipMallocFromPoolAsync`.
* Segmentation fault with `hipStreamLegacy` while using the API `hipStreamWaitEvent`.
* Usage of `hipStreamLegacy` in HIP event record.
* A soft hang in graph execution process from HIP user object. The fix handles the release of graph execution object properly considering synchronization on the device/stream. The user application now behaves the same with `hipUserObject` on both the AMD ROCm and NVIDIA CUDA platforms.

### **hipfort** (0.5.1)

#### Added

* Support for building with LLVM Flang.

#### Resolved issues

* Fixed the exported `hipfort::hipsparse` CMake target.

### **ROCm Systems Profiler** (0.1.1)

#### Resolved issues

* Fixed an error when building from source on some SUSE and RHEL systems when using the `ROCPROFSYS_BUILD_DYNINST` option.

### **ROCProfiler** (2.0.0)

#### Changed

* Replaced `CU_UTILIZATION` metric with `SIMD_UTILIZATION` for better accuracy.

#### Resolved issues

* Fixed the `VALUBusy` and `SALUBusy` activity metrics for accuracy on MI300.

### **ROCprofiler-SDK** (0.5.0)

#### Added

* Support for system-wide collection of SQ counters across all HSA processes.

#### Changed

* `rocprofiler_sample_device_counting_service` API updated to return counter output immediately, when called in synchronous mode.

## ROCm 6.3.1

See the [ROCm 6.3.1 release notes](https://rocm.docs.amd.com/en/docs-6.3.1/about/release-notes.html)
for a complete overview of this release.

### **AMD SMI** (24.7.1)

#### Changed

* `amd-smi monitor` displays `VCLOCK` and `DCLOCK` instead of `ENC_CLOCK` and `DEC_CLOCK`.

#### Resolved issues

* Fixed `amd-smi monitor`'s reporting of encode and decode information. `VCLOCK` and `DCLOCK` are
  now associated with both `ENC_UTIL` and `DEC_UTIL`.

> [!NOTE]
> See the full [AMD SMI changelog](https://github.com/ROCm/amdsmi/blob/6.3.x/CHANGELOG.md) for more details and examples.

### **HIP** (6.3.1)

#### Added

* An activeQueues set that tracks only the queues that have a command submitted to them, which allows fast iteration in ``waitActiveStreams``.

#### Resolved issues

* A deadlock in a specific customer application by preventing hipLaunchKernel latency degradation with number of idle streams.

### **HIPIFY** (18.0.0)

#### Added

* Support for: 
  * NVIDIA CUDA 12.6.2
  * cuDNN 9.5.1
  * LLVM 19.1.3
  * Full `hipBLAS` 64-bit APIs
  * Full `rocBLAS` 64-bit APIs

#### Resolved issues

* Added missing support for device intrinsics and built-ins: `__all_sync`, `__any_sync`, `__ballot_sync`, `__activemask`, `__match_any_sync`, `__match_all_sync`, `__shfl_sync`, `__shfl_up_sync`, `__shfl_down_sync`, and `__shfl_xor_sync`.

### **MIVisionX** (3.1.0)

#### Changed

* AMD Clang is now the default CXX and C compiler.
* The dependency on rocDecode has been removed and automatic rocDecode installation is now disabled in the setup script.

#### Resolved issues

* Canny failure on Instinct MI300 has been fixed.
* Ubuntu 24.04 CTest failures have been fixed.

#### Known issues

* CentOS, Red Hat, and SLES requires the manual installation of `OpenCV` and `FFMPEG`. 
* Hardware decode requires that ROCm is installed with `--usecase=graphics`.

#### Upcoming changes

* Optimized audio augmentations support for VX_RPP.

### **RCCL** (2.21.5)

#### Changed

* Enhanced the user documentation.

#### Resolved Issues

* Corrected some user help strings in `install.sh`.

### **ROCm Compute Profiler** (3.0.0)

#### Resolved issues

* Fixed a minor issue for users upgrading to ROCm 6.3 from 6.2 post-rename from `omniperf`.

### **ROCm Systems Profiler** (0.1.0)

#### Added

* Improvements to support OMPT target offload.

#### Resolved issues

* Fixed an issue with generated Perfetto files. See [issue #3767](https://github.com/ROCm/ROCm/issues/3767) for more information.

* Fixed an issue with merging multiple `.proto` files.

* Fixed an issue causing GPU resource data to be missing from traces of Instinct MI300A systems.

* Fixed a minor issue for users upgrading to ROCm 6.3 from 6.2 post-rename from `omnitrace`.

### **ROCprofiler-SDK** (0.5.0)

#### Added

* SIMD_UTILIZATION metric.
* New <a href="https://rocm.docs.amd.com/projects/rdc/en/docs-6.3.1/index.html">ROCm Data Center (RDC)</a> ops metrics.

## ROCm 6.3.0

See the [ROCm 6.3.0 release notes](https://rocm.docs.amd.com/en/docs-6.3.0/about/release-notes.html)
for a complete overview of this release.

### **AMD SMI** (24.7.1)

#### Added

- Support for `amd-smi metric --ecc` & `amd-smi metric --ecc-blocks` on Guest VMs.

- Support for GPU metrics 1.6 to `amdsmi_get_gpu_metrics_info()`

- New violation status outputs and APIs: `amdsmi_status_t amdsmi_get_violation_status()`, `amd-smi metric  --throttle`, and `amd-smi monitor --violation`. This feature is only available on MI300+ ASICs

- Ability to view XCP (Graphics Compute Partition) activity within `amd-smi metric --usage`. Partition-specific features are only available on MI300+ ASICs

- Added `LC_PERF_OTHER_END_RECOVERY` CLI output to `amd-smi metric --pcie` and updated `amdsmi_get_pcie_info()` to include this value. This feature is only available on MI300+ ASICs

- Ability to retrieve a set of GPUs that are nearest to a given device at a specific link type level
  - Added `amdsmi_get_link_topology_nearest()` function to amd-smi C and Python Libraries.

- More supported utilization count types to `amdsmi_get_utilization_count()`

- `amd-smi set -L/--clk-limit ...` command. This is equivalent to rocm-smi's `--extremum` command which sets sclk's or mclk's soft minimum or soft maximum clock frequency.

- Unittest functionality to test `amdsmi` API calls in Python

- GPU memory overdrive percentage to `amd-smi metric -o`
  - Added `amdsmi_get_gpu_mem_overdrive_level()` function to AMD SMI C and Python Libraries.

- Ability to retrieve connection type and P2P capabilities between two GPUs
  - Added `amdsmi_topo_get_p2p_status()` function to amd-smi C and Python Libraries.
  - Added retrieving P2P link capabilities to CLI `amd-smi topology`.

- New `amdsmi_kfd_info_t` type and added information under `amd-smi list`

- Subsystem device ID to `amd-smi static --asic`. There are no underlying changes to `amdsmi_get_gpu_asic_info`.

- `Target_Graphics_Version` to `amd-smi static --asic` and `amdsmi_get_gpu_asic_info()`.

#### Changed

- Updated BDF commands to use KFD SYSFS for BDF: `amdsmi_get_gpu_device_bdf()`. This change aligns BDF output with ROCm SMI.

- Moved Python tests directory path install location.
  - `/opt/<rocm-path>/share/amd_smi/pytest/..` to `/opt/<rocm-path>/share/amd_smi/tests/python_unittest/..`
  - Removed PyTest dependency. Python testing now depends on the unittest framework only.

- Changed the `power` parameter in `amdsmi_get_energy_count()` to `energy_accumulator`.
  - Changes propagate forwards into the Python interface as well. Backwards compatibility is maintained.

- Updated Partition APIs and struct information and added `partition_id` to `amd-smi static --partition`.
  - As part of an overhaul to partition information, some partition information will be made available in the `amdsmi_accelerator_partition_profile_t`.
  - This struct will be filled out by a new API, `amdsmi_get_gpu_accelerator_partition_profile()`.
  - Future data from these APIs will eventually be added to `amd-smi partition`.

#### Removed

- `amd-smi reset --compute-partition` and `... --memory-partition` and associated APIs
  - This change is part of the partition redesign. Reset functionality will be reintroduced in a later update.
  - Associated APIs include `amdsmi_reset_gpu_compute_partition()` and `amdsmi_reset_gpu_memory_partition()`

- Usage of `_validate_positive` is removed in parser and replaced with `_positive_int` and `_not_negative_int` as appropriate.
  - This will allow `0` to be a valid input for several options in setting CPUs where appropriate (for example, as a mode or NBIOID).

#### Optimized

- Adjusted ordering of `gpu_metrics` calls to ensure that `pcie_bw` values remain stable in `amd-smi metric` & `amd-smi monitor`.
  - With this change additional padding was added to `PCIE_BW` `amd-smi monitor --pcie`

#### Known issues

- See [AMD SMI manual build issue](https://rocm.docs.amd.com/en/docs-6.3.0/about/release-notes.html#amd-smi-manual-build-issue).

#### Resolved issues

- Improved Offline install process and lowered dependency for PyYAML.

- Fixed CPX not showing total number of logical GPUs.

- Fixed incorrect implementation of the Python API `amdsmi_get_gpu_metrics_header_info()`.

- `amdsmitst` `TestGpuMetricsRead` now prints metric in correct units.

#### Upcoming changes

- Python API for `amdsmi_get_energy_count()` will deprecate the `power` field in a future ROCm release and use `energy_accumulator` field instead.

- New memory and compute partition APIs will be added in a future ROCm release.
  - These APIs will be updated to fully populate the CLI and allowing compute (accelerator) partitions to be set by profile ID.
  - One API will be provided, to reset both memory and compute (accelerator).
  - The following APIs will remain:

    ```C
    amdsmi_status_t
    amdsmi_set_gpu_compute_partition(amdsmi_processor_handle processor_handle,
                                      amdsmi_compute_partition_type_t compute_partition);
    amdsmi_status_t
    amdsmi_get_gpu_compute_partition(amdsmi_processor_handle processor_handle,
                                      char *compute_partition, uint32_t len);
    amdsmi_status_t
    amdsmi_get_gpu_memory_partition(amdsmi_processor_handle processor_handle,

                                      char *memory_partition, uint32_t len);
    amdsmi_status_t
    amdsmi_set_gpu_memory_partition(amdsmi_processor_handle processor_handle,
                                      amdsmi_memory_partition_type_t memory_partition);
    ```

- `amd-smi set --compute-partition "SPX/DPX/CPX..."` will no longer be supported in a future ROCm release.
  - This is due to aligning with Host setups and providing more robust partition information through the APIs outlined above. Furthermore, new APIs which will be available on both BM/Host can set by profile ID.

- Added a preliminary `amd-smi partition` command.
  - The new partition command can display GPU information, including memory and accelerator partition information.
  - The command will be at full functionality once additional partition information from `amdsmi_get_gpu_accelerator_partition_profile()` has been implemented.

> [!NOTE]
> See the full [AMD SMI changelog](https://github.com/ROCm/amdsmi/blob/6.3.x/CHANGELOG.md) for more details and examples.

### **HIP** (6.3.0)

#### Added

* New HIP APIs:
  - `hipGraphExecGetFlags`  returns the flags on executable graph.
  - `hipGraphNodeSetParams`  updates the parameters of a created node.
  - `hipGraphExecNodeSetParams`  updates the parameters of a created node on an executable graph.
  - `hipDrvGraphMemcpyNodeGetParams`  gets a memcpy node's parameters.
  - `hipDrvGraphMemcpyNodeSetParams`  sets a memcpy node's parameters.
  - `hipDrvGraphAddMemFreeNode`  creates a memory free node and adds it to a graph.
  - `hipDrvGraphExecMemcpyNodeSetParams`  sets the parameters for a memcpy node in the given graphExec.
  - `hipDrvGraphExecMemsetNodeSetParams`  sets the parameters for a memset node in the given graphExec.

#### Changed

* Un-deprecated HIP APIs:
    - `hipHostAlloc`
    - `hipFreeHost`

#### Optimized

* Disabled CPU wait in device synchronize to avoid idle time in applications such as Hugging Face models and PyTorch.
* Optimized multi-threaded dispatches to improve performance.
* Limited the software batch size to control the number of command submissions for runtime to handle efficiently.
* Optimizes HSA callback performance when a large number of events are recorded by multiple threads and submitted to multiple GPUs.

#### Resolved issues

* Soft hang in runtime wait event when run TensorFlow.
* Memory leak in the API `hipGraphInstantiate` when kernel is launched using `hipExtLaunchKernelGGL` with event.
* Memory leak when the API `hipGraphAddMemAllocNode` is called.
* The `_sync()` version of crosslane builtins such as `shfl_sync()`,
  `__all_sync()` and `__any_sync()`, continue to be hidden behind the
  preprocessor macro `HIP_ENABLE_WARP_SYNC_BUILTINS`, and will be enabled
  unconditionally in the next ROCm release.

### **hipBLAS** (2.3.0)

#### Added

* Level 3 functions have an additional `ILP64` API for both C and Fortran (`_64` name suffix) with `int64_t` function arguments

#### Changed

* `amdclang` is used as the default compiler instead of `g++`.
* Added a dependency on the `hipblas-common` package.

### **hipBLASLt** (0.10.0)

#### Added

* Support for the V2 CPP extension API for backward compatibility
* Support for data type `INT8` in with `INT8` out
* Support for data type `FP32`/`FP64` for gfx110x
* Extension API `hipblaslt_ext::matmulIsTuned`
* Output `atol` and `rtol` for `hipblaslt-bench` validation
* Output the bench command for the hipblaslt CPP ext API path if `HIPBLASLT_LOG_MASK=32` is set
* Support odd sizes for `FP8`/`BF8` GEMM

#### Changed

* Reorganized and added more sample code.
* Added a dependency with the `hipblas-common` package and removed the dependency with the `hipblas` package.

#### Optimized

* Support fused kernel for `HIPBLASLT_MATMUL_DESC_AMAX_D_POINTER` for the `FP8`/`BF8` data type
* Improved the library loading time.
* Improved the overall performance of the first returned solution.

#### Upcoming changes

*  The V1 CPP extension API will be deprecated in a future release of hipBLASLt.

### **hipCUB** (3.3.0)

#### Added

* Support for large indices in `hipcub::DeviceSegmentedReduce::*` has been added, with the exception
  of `DeviceSegmentedReduce::Arg*`. Although rocPRIM's backend provides support for all reduce
  variants, CUB does not support large indices in `DeviceSegmentedReduce::Arg*`. For this reason,
  large index support is not available for `hipcub::DeviceSegmentedReduce::Arg*`.

#### Changed

* Changed the default value of `rmake.py -a` to `default_gpus`. This is equivalent to `gfx906:xnack-,gfx1030,gfx1100,gfx1101,gfx1102`.
* The NVIDIA backend now requires CUB, Thrust, and libcu++ 2.3.2.

#### Resolved issues

* Fixed an issue in `rmake.py` where the list storing cmake options would contain individual characters instead of a full string of options.
* Fixed an issue where `config.hpp` was not included in all hipCUB headers, resulting in build errors.

### **hipFFT** (1.0.17)

#### Changed

* The AMD backend is now compiled using amdclang++ instead of hipcc. The NVIDIA CUDA backend still uses hipcc-nvcc.
* CLI11 replaces Boost Program Options as the command line parser for clients.
* Building with the address sanitizer option sets xnack+ for the relevant GPU architectures.

### **hipfort** (0.5.0)

#### Added

* Added ROC-TX to the hipfort interfaces.

#### Changed

* Updated the hipSOLVER bindings.

### **HIPIFY** (18.0.0)

#### Added

* CUDA 12.6.1 support
* cuDNN 9.5.0 support
* LLVM 19.1.1 support
* rocBLAS 64-bit APIs support
* Initial support for direct hipification of cuDNN into MIOpen under the `--roc` option
* Initial support for direct hipification of cuRAND into rocRAND under the `--roc` option
* Added a filtering ability for the supplementary hipification scripts

#### Resolved issues

* Correct `roc` header files support

#### Known issues

* Support for `fp8` data types

### **hipRAND** (2.11.0)

> [!NOTE]
> In ROCm 6.3.0, the hipRAND package version is incorrectly set to `2.11.0`.
> In ROCm 6.2.4, the hipRAND package version was `2.11.1`.
> The hipRAND version number will be corrected in a future ROCm release.

#### Changed

* Updated the default value for the `-a` argument from `rmake.py` to `gfx906:xnack-,gfx1030,gfx1100,gfx1101,gfx1102`.

#### Resolved issues

* Fixed an issue in `rmake.py` where the list storing the CMake options would contain individual characters instead of a full string of options.

### **hipSOLVER** (2.3.0)

#### Added

* Auxiliary functions:
    * `hipsolverSetDeterministicMode`, `hipsolverGetDeterministicMode`
* Compatibility-only functions:
  * `potrf`
    * `hipsolverDnXpotrf_bufferSize`
    * `hipsolverDnXpotrf`
  * `potrs`
    * `hipsolverDnXpotrs`
  * `geqrf`
    * `hipsolverDnXgeqrf_bufferSize`
    * `hipsolverDnXgeqrf`

#### Changed

* Binaries in debug builds no longer have a `-d` suffix.
* Changed rocSPARSE and SuiteSparse to be runtime dependencies by default. The `BUILD_WITH_SPARSE` CMake option can still be used
  to convert them into build-time dependencies (now off by default).
* The `--no-sparse` option for the install script now only affects the hipSOLVER clients and their dependency on hipSPARSE. Use the
  `BUILD_HIPSPARSE_TESTS` CMake option to enable tests for the `hipsolverSp` API (on by default).

#### Upcoming changes

* The Fortran bindings provided in `hipsolver_module.f90` have been deprecated.
  The Fortran bindings provided by the hipfort project are recommended instead.

### **hipSPARSE** (3.1.2)

#### Added

* Added an alpha version of the `hipsparse-bench` executable to facilitate comparing NVIDIA CUDA cuSPARSE and rocSPARSE backends.

#### Changed

* Changed the default compiler from hipcc to amdclang in the install script and CMake files.
* Improved the user documentation.

#### Resolved issues

* Fixed the gfortran dependency for the Azure Linux operating system.

#### Known issues

* In `hipsparseSpSM_solve()`, the external buffer is passed as a parameter. This does not match the NVIDIA CUDA cuSPARSE API. This extra external buffer parameter will be removed in a future release. For now, this extra parameter can be ignored and `nullptr` passed as it is unused internally by `hipsparseSpSM_solve()`.

### **hipSPARSELt** (0.2.2)

#### Added

* Support for a new data type combination: `INT8` inputs, `BF16` output, and `INT32` Matrix Core accumulation
* Support for row-major memory order (`HIPSPARSE_ORDER_ROW`)

#### Changed

* Changed the default compiler to amdclang++.

#### Upcoming changes

* `hipsparseLtDatatype_t` is deprecated and will be removed in the next major release of ROCm. `hipDataType` should be used instead.

### **hipTensor** (1.4.0)

#### Added

* Added support for tensor reduction, including APIs, CPU reference, unit tests, and documentation

#### Changed

* ASAN builds only support xnack+ targets.
* ASAN builds use `-mcmodel=large` to accommodate library sizes greater than 2GB.
* Updated the permute backend to accommodate changes to element-wise operations.
* Updated the actor-critic implementation.
* Various documentation formatting updates.

#### Optimized

* Split kernel instances to improve build times.

#### Resolved issues

* Fixed a bug in randomized tensor input data generation.
* Fixed the default strides calculation to be in column-major order.
* Fixed a small memory leak by properly destroying HIP event objects in tests.
* Default strides calculations now follow column-major convention.

### **llvm-project** (18.0.0)

#### Resolved issues

* Fixed an issue where the compiler would incorrectly compile a program that used the `__shfl(var,
  srcLane, width)` function when one of the parameters to the function is undefined along some path
  to the function. See [issue #3499](https://github.com/ROCm/ROCm/issues/3499) on GitHub.

### **MIGraphX** (2.11.0)

#### Added

* Initial code to run on Windows
* Support for `FP8` and `INT4`
* Support for the Log2 internal operator
* Support for the GCC 14 compiler
* The `BitwiseAnd`, `Scan`, `SoftmaxCrossEntropyLoss`, `GridSample`, and `NegativeLogLikelihoodLoss` ONNX operators 
* The `MatMulNBits`, `QuantizeLinear`/`DequantizeLinear`, `GroupQueryAttention`, `SkipSimplifiedLayerNormalization`, and `SimpliedLayerNormalizationMicrosoft` Contrib operators 
* Dynamic batch parameter support to `OneHot` operator
* Split-K as an optional performance improvement
* Scripts to validate ONNX models from the ONNX Model Zoo
* GPU Pooling Kernel
* `--mlir` flag the migraphx-driver program to offload entire module to MLIR
* Fusing split-reduce with MLIR 
* Multiple outputs for the MLIR + Pointwise fusions 
* Pointwise fusions with MLIR across reshape operations
* `MIGRAPHX_MLIR_DUMP` environment variable to dump MLIR modules to MXRs
* The `3` option to `MIGRAPHX_TRACE_BENCHMARKING` to print the MLIR program for improved debug output
* `MIGRAPHX_ENABLE_HIPBLASLT_GEMM` environment variable to call hipBLASLt libraries
* `MIGRAPHX_VERIFY_DUMP_DIFF` to improve the debugging of accuracy issues  
* `reduce_any` and `reduce_all` options to the `Reduce` operation via Torch MIGraphX
* Examples for RNNT, and ControlNet

#### Changed

* Switched to MLIR's 3D Convolution operator.
* MLIR is now used for Attention operations by default on gfx942 and newer ASICs.
* Names and locations for VRM specific libraries have changed.
* Use random mode for benchmarking GEMMs and convolutions.
* Python version is now printed with an actual version number.

#### Removed

* Disabled requirements for MIOpen and rocBLAS when running on Windows.
* Removed inaccurate warning messages when using exhaustive-tune.
* Remove the hard coded path in `MIGRAPHX_CXX_COMPILER` allowing the compiler to be installed in different locations.

#### Optimized

* Improved:
    * Infrastructure code to enable better Kernel fusions with all supported data types
    * Subsequent model compile time by creating a cache for already performant kernels
    * Use of Attention fusion with models
    * Performance of the Softmax JIT kernel and of the Pooling operator
    * Tuning operations through a new 50ms delay before running the next kernel
    * Performance of several convolution-based models through an optimized NHWC layout 
    * Performance for the `FP8` datatype
    * GPU utilization
    * Verification tools
    * Debug prints
    * Documentation, including gpu-driver utility documentation
    * Summary section of the `migraphx-driver perf` command
* Reduced model compilation time
* Reordered some compiler passes to allow for more fusions
* Preloaded tiles into LDS to improve performance of pointwise transposes
* Exposed the `external_data_path` property in `onnx_options` to set the path from `onnxruntime`

#### Resolved issues

* Fixed a bug with gfx1030 that overwrote `dpp_reduce`.
* Fixed a bug in 1-arg dynamic reshape that created a failure.
* Fixed a bug with `dot_broadcast` and `inner_broadcast` that caused compile failures.
* Fixed a bug where some configs were failing when using exhaustive-tune.
* Fixed the ROCm Install Guide URL.
* Fixed an issue while building a whl package due to an apostrophe.
* Fixed the BERT Squad example requirements file to support different versions of Python.
* Fixed a bug that stopped the Vicuna model from compiling.
* Fixed failures with the verify option of migraphx-driver that would cause the application to exit early.


### **MIOpen** (3.3.0)

#### Added

- [RNN] LSTM forward pass
- [Mha] Mask is added for forward pass
- [GLU] Gated Linear Unit (this is an experimental feature)
- [PReLU] Implemented PReLU backward pass (this is an experimental feature)

#### Optimized

- MI300 TunaNet Update: CK forward pass and WRW Solvers updated

#### Resolved issues

- Fixed unset stream when calling `hipMemsetAsync`.
- Fixed a memory leak issue caused by an incorrect transpose in find 2.0. See PR [#3285](https://github.com/ROCm/MIOpen/pull/3285) on GitHub.
- Fixed a `memcopy` data race by replacing `hipMemcpy` with `hipMemcpyWithStream`.

### **MIVisionX** (3.1.0)

#### Changed

* rocDecode is no longer installed by the setup script.
* The rocDecode dependency has been removed from the package installation.

#### Known issues

* See [MIVisionX memory access fault in Canny edge detection](https://github.com/ROCm/ROCm/issues/4086).
* Package installation requires the manual installation of OpenCV.
* Installation on CentOS/RedHat/SLES requires the manual installation of the `FFMPEG Dev` package.
* Hardware decode requires installation with `--usecase=graphics` in addition to `--usecase=rocm`.

#### Upcoming changes

* Optimized audio augmentations support for VX_RPP

### **RCCL** (2.21.5)

#### Added

* MSCCL++ integration for specific contexts
* Performance collection to `rccl_replayer`
* Tuner Plugin example for Instinct MI300
* Tuning table for a large number of nodes
* Support for amdclang++
* New Rome model

#### Changed

* Compatibility with NCCL 2.21.5
* Increased channel count for MI300X multi-node
* Enabled MSCCL for single-process multi-threaded contexts
* Enabled CPX mode for MI300X
* Enabled tracing with `rocprof`
* Improved version reporting
* Enabled GDRDMA for Linux kernel 6.4.0+

#### Resolved issues

* Fixed an issue where, on systems running Linux kernel 6.8.0 such as Ubuntu 24.04, Direct Memory
  Access (DMA) transfers between the GPU and NIC were disabled, impacting multi-node RCCL
  performance. See [issue #3772](https://github.com/ROCm/ROCm/issues/3772) on GitHub.
* Fixed model matching with PXN enable

#### Known issues

* MSCCL is temporarily disabled for AllGather collectives.
  - This can impact in-place messages (< 2 MB) with ~2x latency.
  - Older RCCL versions are not impacted.
  - This issue will be addressed in a future ROCm release.
* Unit tests do not exit gracefully when running on a single GPU.
  - This issue will be addressed in a future ROCm release.

### **rocAL** (2.1.0)

#### Added

* rocAL Pybind support for package installation has been added. To use the rocAL python module, set the `PYTHONPATH`: `export PYTHONPATH=/opt/rocm/lib:$PYTHONPATH`
* Last batch policy, pad last batch, stick to shard, and shard size support have been added for the coco, caffe, caffe2, mxnet, tf, and cifar10 image readers.

#### Changed

* rocDecode is no longer installed by the setup script.
* The rocDecode dependency has been removed from the package installation.

#### Optimized

* CTest has been updated.

#### Resolved issues

* Test failures have been fixed.

#### Known issues

* The package installation requires the manual installation of `TurboJPEG` and `RapidJSON`.
* CentOS/RedHat/SLES requires the manual installation of the `FFMPEG Dev` package.
* Hardware decode requires installation with `--usecase=graphics` in addition to `--usecase=rocm`.

#### Upcoming changes

* Optimized audio augmentations support.

### **rocALUTION** (3.2.1)

#### Changed

* The default compiler has been changed from `hipcc` to `amdclang` in the installation script and cmake files.
* Changed the address sanitizer build targets. Now only `gfx908:xnack+`, `gfx90a:xnack+`, `gfx940:xnack+`, `gfx941:xnack+`, and `gfx942:xnack+` are built with `BUILD_ADDRESS_SANITIZER=ON`.

#### Resolved issues

* Fixed hang in `RS-AMG` for Navi on some specific matrix sparsity patterns.
* Fixed wrong results in `Apply` on multi-GPU setups.

### **rocBLAS** (4.3.0)

#### Added

* Level 3 and EX functions have an additional `ILP64` API for both C and Fortran (`_64` name suffix) with `int64_t` function arguments

#### Changed

* amdclang is used as the default compiler instead of hipcc
* Internal performance scripts use AMD SMI instead of the deprecated ROCm SMI

#### Optimized

* Improved performance of Level 2 gbmv
* Improved performance of Level 2 gemv for float and double precisions for problem sizes (`TransA == N && m==n && m % 128 == 0`) measured on a gfx942 GPU

#### Resolved issues

* Fixed the `stbsv_strided_batched_64` Fortran binding

#### Upcoming changes

* `rocblas_Xgemm_kernel_name` APIs are deprecated

### **ROCdbgapi** (0.77.0)

#### Added

* Support for setting precise ALU exception reporting

### **rocDecode** (0.8.0)

#### Changed

* Clang is now the default CXX compiler.
* The new minimum supported version of `va-api` is 1.16.
* New build and runtime options have been added to the `rocDecode-setup.py` setup script.

#### Removed

* Make tests have been removed. CTEST is now used for both Make tests and package tests.
* `mesa-amdgpu-dri-drivers` has been removed as a dependency on RHEL and SLES.

#### Resolved issues

* Fixed a bug in the size of output streams in the `videoDecodeBatch` sample.

### **rocFFT** (1.0.31)

#### Added

* rocfft-test now includes a `--smoketest` option.
* Implemented experimental APIs to allow computing FFTs on data
  distributed across multiple MPI ranks. These APIs can be enabled with the
  `ROCFFT_MPI_ENABLE` CMake option.  This option defaults to `OFF`.

  When `ROCFFT_MPI_ENABLE` is `ON`:

  * `rocfft_plan_description_set_comm` can be called to provide an
    MPI communicator to a plan description, which can then be passed
    to `rocfft_plan_create`.  Each rank calls
    `rocfft_field_add_brick` to specify the layout of data bricks on
    that rank.

  * An MPI library with ROCm acceleration enabled is required at
    build time and at runtime.

#### Changed

* Compilation uses amdclang++ instead of hipcc.
* CLI11 replaces Boost Program Options as the command line parser for clients and samples.
* Building with the address sanitizer option sets xnack+ on relevant GPU
  architectures and address-sanitizer support is added to runtime-compiled
  kernels.

### **ROCgdb** (15.2)

#### Added

- Support for precise ALU exception reporting for supported architectures. Precise ALU exceptions reporting is controlled with the following commands:
  - `set amdgpu precise-alu-exceptions`
  - `show amdgpu precise-alu-exceptions`

#### Changed

- The `sysroot` or `solib-search-path` settings can now be used to locate files containing GPU code objects when opening a core dump. This allows opening GPU code objects on systems different from the one where the core dump was generated.

#### Resolved issues

- Fixed possible hangs when opening some AMDGPU core dumps in ROCgdb.
- Addressed cases where the `roccoremerge` utility improperly handled LOAD segment copy from the host core dump to the combined core dump.

### **ROCm Compute Profiler** (3.0.0)

#### Changed

* Renamed to ROCm Compute Profiler from Omniperf.
  * New package name: `rocprofiler-compute`
  * New repository: [https://github.com/ROCm/rocprofiler-compute](https://github.com/ROCm/rocprofiler-compute)
  * New binary name: `rocprof-compute`

#### Known issues

- See [ROCm Compute Profiler post-upgrade](https://github.com/ROCm/ROCm/issues/4082).

- See [ROCm Compute Profiler CTest failure in CI](https://github.com/ROCm/ROCm/issues/4085).

### **ROCm Data Center Tool** (0.3.0)

#### Added

* RVS integration
* Real time logging for diagnostic command
* `--version` command
* `XGMI_TOTAL_READ_KB` and `XGMI_TOTAL_WRITE_KB` monitoring metrics

#### Known issues

- See [ROCm Data Center Tool incorrect RHEL9 package version](https://github.com/ROCm/ROCm/issues/4089).

### **ROCm SMI** (7.4.0)

#### Added

- **Added `rsmi_dev_memory_partition_capabilities_get` which returns driver memory partition capablities.**  
Driver now has the ability to report what the user can set memory partition modes to. User can now see available
memory partition modes upon an invalid argument return from memory partition mode set (`rsmi_dev_memory_partition_set`).

- Support for GPU metrics 1.6 to `rsmi_dev_gpu_metrics_info_get()`. Updated
  `rsmi_dev_gpu_metrics_info_get()` and structure `rsmi_gpu_metrics_t` to include new fields for
  PVIOL / TVIOL, XCP (Graphics Compute Partitions) stats, and `pcie_lc_perf_other_end_recovery`.

- Ability to view raw GPU metrics using `rocm-smi --showmetrics`.

#### Changed

- Added back in C++ tests for `memorypartition_read_write`

- Updated `rsmi_dev_memory_partition_set` to not return until a successful restart of AMD GPU Driver.

- All APIs now have the ability to catch driver reporting invalid arguments.

#### Removals

- Removed `--resetcomputepartition`, and  `--resetmemorypartition` options and associated APIs.
  - This change is part of the partition feature redesign.
  - The related APIs `rsmi_dev_compute_partition_reset()` and `rsmi_dev_memory_partition_reset()`.

#### Resolved issues

- Fixed `rsmi_dev_target_graphics_version_get`, `rocm-smi --showhw`, and `rocm-smi --showprod` not displaying properly for MI2x or Navi 3x ASICs.

#### Upcoming changes

- C++ tests for `memorypartition_read_write` are to be re-enabled in a future ROCm release.

> [!NOTE]
> See the full [ROCm SMI changelog](https://github.com/ROCm/rocm_smi_lib/blob/6.3.x/CHANGELOG.md) for more details and examples.

### **ROCm Systems Profiler** (0.1.0)

#### Changed

* Renamed to ROCm Systems Profiler from Omnitrace.
  * New package name: `rocprofiler-systems`
  * New repository: [https://github.com/ROCm/rocprofiler-systems](https://github.com/ROCm/rocprofiler-systems)
  * Reset the version to `0.1.0`
  * New binary prefix: `rocprof-sys-*`

#### Known issues

- See [ROCm Systems Profiler post-upgrade](https://github.com/ROCm/ROCm/issues/4083).

### **ROCm Validation Suite** (1.1.0)

#### Added

- Support for hipBLASLT blas library and option to select blas library in `conf` file.

#### Changed

- Babel parameters made runtime configurable.

#### Known issues

- See [ROCm Validation Suite needs specified configuration file](https://github.com/ROCm/ROCm/issues/4090).

### **rocPRIM** (3.3.0)

#### Added

* The `--test smoke` option has been added to `rtest.py`. When `rtest.py` is called with this option it runs a subset of tests such that the total test time is 5 minutes. Use `python3 ./rtest.py --test smoke` or `python3 ./rtest.py -t smoke` to run the smoke test.
* The `--seed` option has been added to `run_benchmarks.py`. The `--seed` option specifies a seed for the generation of random inputs. When the option is omitted, the default behavior is to use a random seed for each benchmark measurement.
* Added configuration autotuning to device partition (`rocprim::partition`, `rocprim::partition_two_way`, and `rocprim::partition_three_way`), to device select (`rocprim::select`, `rocprim::unique`, and `rocprim::unique_by_key`), and to device reduce by key (`rocprim::reduce_by_key`) to improve performance on selected architectures.
* Added `rocprim::uninitialized_array` to provide uninitialized storage in local memory for user-defined types.
* Added large segment support for `rocprim:segmented_reduce`.
* Added a parallel `nth_element` device function similar to `std::nth_element`. `nth_element` places elements that are smaller than the nth element before the nth element, and elements that are bigger than the nth element after the nth element.
* Added deterministic (bitwise reproducible) algorithm variants `rocprim::deterministic_inclusive_scan`, `rocprim::deterministic_exclusive_scan`, `rocprim::deterministic_inclusive_scan_by_key`, `rocprim::deterministic_exclusive_scan_by_key`, and `rocprim::deterministic_reduce_by_key`. These provide run-to-run stable results with non-associative operators such as float operations, at the cost of reduced performance.
* Added a parallel `partial_sort` and `partial_sort_copy` device functions similar to `std::partial_sort` and `std::partial_sort_copy`. `partial_sort` and `partial_sort_copy` arrange elements such that the elements are in the same order as a sorted list up to and including the middle index.

#### Changed

* Changed the default value of `rmake.py -a` to `default_gpus`. This is equivalent to `gfx906:xnack-,gfx1030,gfx1100,gfx1101,gfx1102`.
* Modified the input size in device adjacent difference benchmarks. Observed performance with these benchmarks might be different.
* Changed the default seed for `device_benchmark_segmented_reduce`.

#### Removed

* `rocprim::thread_load()` and `rocprim::thread_store()` have been deprecated. Use `dereference()` instead.

#### Resolved issues

* Fixed an issue in `rmake.py` where the list storing cmake options would contain individual characters instead of a full string of options.
* Resolved an issue in `rtest.py` where it crashed if the `build` folder was created without `release` or `debug` subdirectories.
* Resolved an issue with `rtest.py` on Windows where passing an absolute path to `--install_dir` caused a `FileNotFound` error.
* rocPRIM functions are no longer forcefully inlined on Windows. This significantly reduces the build time of debug builds.
* `block_load`, `block_store`, `block_shuffle`, `block_exchange`, and `warp_exchange` now use placement `new` instead of copy assignment (`operator=`) when writing to local memory. This fixes the behavior of custom types with non-trivial copy assignments.
* Fixed a bug in the generation of input data for benchmarks, which caused incorrect performance to be reported in specific cases. It may affect the reported performance for one-byte types (`uint8_t` and `int8_t`) and instantiations of `custom_type`. Specifically, device binary search, device histogram, device merge and warp sort are affected.
* Fixed a bug for `rocprim::merge_path_search` where using `unsigned` offsets would produce incorrect results.
* Fixed a bug for `rocprim::thread_load` and `rocprim::thread_store` where `float` and `double` were not cast to the correct type, resulting in incorrect results.
* Resolved an issue where tests were failing when they were compiled with `-D_GLIBCXX_ASSERTIONS=ON`.
* Resolved an issue where algorithms that used an internal serial merge routine caused a memory access fault that resulted in potential performance drops when using block sort, device merge sort (block merge), device merge, device partial sort, and device sort (merge sort).
* Fixed memory leaks in unit tests due to missing calls to `hipFree()` and the incorrect use of hipGraphs.
* Fixed an issue where certain inputs to `block_sort_merge()`, `device_merge_sort_merge_path()`, `device_merge()`, and `warp_sort_stable()` caused an assertion error during the call to `serial_merge()`.

### **ROCProfiler** (2.0.0)

#### Added

- JSON output plugin for `rocprofv2`. The JSON file matches Google Trace Format making it easy to load on Perfetto, Chrome tracing, or Speedscope. For Speedscope, use `--disable-json-data-flows` option as speedscope doesn't work with data flows.
- `--no-serialization` flag to disable kernel serialization when `rocprofv2` is in counter collection mode. This allows `rocprofv2` to avoid deadlock when profiling certain programs in counter collection mode.
- `FP64_ACTIVE` and `ENGINE_ACTIVE` metrics to AMD Instinct MI300 GPU
- New HIP APIs with struct defined inside union.
- Early checks to confirm the eligibility of ELF file in ATT plugin
- Support for kernel name filtering in `rocprofv2`
- Barrier bit to read and stop packets

#### Changed

- Extended lifetime for proxy queues
- Setting the `trace-start` option for `rocprof` to `off` now disables kernel tracing
- `libpciaccess-dev` functions now load with `dlopen`
-	`PcieAccessApi*` api and `void* libpciaccess_handle` are now initialized to `nullptr`

#### Removed

- Obsolete BSD and GPL licenses
- `libsystemd-dev` from `CMakeLists.txt`

#### Optimized

- ROCProfiler Performance improved to reduce profiling time for large workloads of counter collection

#### Resolved issues

- Bandwidth measurement in AMD Instinct MI300 GPU
- Perfetto plugin issue of `roctx` trace not getting displayed
- `--help` for counter collection
- Signal management issues in `queue.cpp`
- Perfetto tracks for multi-GPU
- Perfetto plugin usage with `rocsys`
- Incorrect number of columns in the output CSV files for counter collection and kernel tracing
- The ROCProfiler hang issue when running kernel trace, thread trace, or counter collection on Iree benchmark for AMD Instinct MI300 GPU
- Build errors thrown during parsing of unions
- The system hang caused while running `--kernel-trace` with Perfetto for certain applications
- Missing profiler records issue caused while running `--trace-period`
- The hang issue of `ProfilerAPITest` of `runFeatureTests` on AMD Instinct MI300 GPU
- Segmentation fault on Navi32


### **ROCprofiler-SDK** (0.5.0)

#### Added

- Start and end timestamp columns to the counter collection `csv` output
- Check to force tools to initialize context id with zero
- Support to specify hardware counters for collection using `rocprofv3` as `rocprofv3 --pmc [COUNTER [COUNTER ...]]`

#### Changed

- `--marker-trace` option for `rocprofv3` now supports the legacy ROC-TX library `libroctx64.so` when the application is linked against the new library `librocprofiler-sdk-roctx.so`
- Replaced deprecated `hipHostMalloc` and `hipHostFree` functions with `hipExtHostAlloc` and `hipFreeHost` for ROCm versions starting 6.3
- Updated `rocprofv3` `--help` options
- Changed naming of "agent profiling" to a more descriptive "device counting service". To convert existing tool or user code to the new name, use the following sed:
  ```
  find . -type f -exec sed -i 's/rocprofiler_agent_profile_callback_t/rocprofiler_device_counting_service_callback_t/g; s/rocprofiler_configure_agent_profile_counting_service/rocprofiler_configure_device_counting_service/g; s/agent_profile.h/device_counting_service.h/g; s/rocprofiler_sample_agent_profile_counting_service/rocprofiler_sample_device_counting_service/g' {} +
  ```
- Changed naming of "dispatch profiling service" to a more descriptive "dispatch counting service". To convert existing tool or user code to the new names, the following sed can be used:
  ```
  -type f -exec sed -i -e 's/dispatch_profile_counting_service/dispatch_counting_service/g' -e 's/dispatch_profile.h/dispatch_counting_service.h/g' -e 's/rocprofiler_profile_counting_dispatch_callback_t/rocprofiler_dispatch_counting_service_callback_t/g' -e 's/rocprofiler_profile_counting_dispatch_data_t/rocprofiler_dispatch_counting_service_data_t/g'  -e 's/rocprofiler_profile_counting_dispatch_record_t/rocprofiler_dispatch_counting_service_record_t/g' {} +
  ```
- `FETCH_SIZE` metric on gfx94x now uses `TCC_BUBBLE` for 128B reads
- PMC dispatch-based counter collection serialization is now per-device instead of being global across all devices

#### Removed

- `gfx8` metric definitions
- `rocprofv3` installation from `sbin` directory

#### Resolved issues

- Introduced subdirectory creation when `rocprofv3 --output-file` used to specify a folder path
- Fixed misaligned stores (undefined behavior) for buffer records
- Fixed crash when only scratch reporting is enabled
- Fixed `MeanOccupancy` metrics
- Fixed aborted-application validation test to properly check for `hipExtHostAlloc` command
- Fixed implicit reduction of SQ and GRBM metrics
- Fixed support for derived counters in reduce operation
- Bug fixed in max-in-reduce operation
- Introduced fix to handle a range of values for `select()` dimension in expressions parser
- Fixed Navi3x kernel tracing issues by setting the conditional `aql::set_profiler_active_on_queue` only when counter collection is registered

### **rocPyDecode** (0.2.0)

#### Added

* RGB and YUV pytorch tensors
* Python distribution wheel (`.whl`)
* Multiple usecase samples

#### Changed

* Clang replaces `hipcc` as the default CXX compiler. 

#### Removed

* Make tests have been removed. CTEST is now used for both Make tests and package tests.

#### Optimized

* Setup script - build and runtime install options
* Prerequisite installation helper Python scripts
* Same GPU memory viewed as pytorch tensor

#### Resolved issues

* Fixed setup issues.

### **rocRAND** (3.2.0)

#### Added

* Added host generator for MT19937
* Support for `rocrand_generate_poisson` in hipGraphs
* Added `engine`, `distribution`, `mode`, `throughput_gigabytes_per_second`, and `lambda` columns for the csv format in
  `benchmark_rocrand_host_api` and `benchmark_rocrand_device_api`. To see these new columns, set `--benchmark_format=csv`
  or `--benchmark_out_format=csv --benchmark_out="outName.csv"`.

#### Changed

* Updated the default value for the `-a` argument from `rmake.py` to `gfx906:xnack-,gfx1030,gfx1100,gfx1101,gfx1102`.
* `rocrand_discrete` for MTGP32, LFSR113 and ThreeFry generators now uses the alias method, which is faster than binary search in CDF.

#### Resolved issues

* Fixed an issue in `rmake.py` where the list storing the CMake options would contain individual characters instead of a full string of options.

### **rocSOLVER** (3.27.0)

#### Added

* 64-bit APIs for existing functions:
    - `LACGV_64`
    - `LARF_64`
    - `LARFG_64`
    - `GEQR2_64` (with batched and strided\_batched versions)
    - `GEQRF_64` (with batched and strided\_batched versions)
    - `POTF2_64` (with batched and strided\_batched versions)
    - `POTRF_64` (with batched and strided\_batched versions)
    - `POTRS_64` (with batched and strided\_batched versions)

#### Changed

* The rocSPARSE library is now an optional dependency at runtime. If rocSPARSE
  is not available, rocSOLVER&#39;s sparse refactorization and solvers functions
  will return `rocblas_status_not_implemented`.

#### Optimized

* Improved the performance of LARFG, LARF, and downstream functions such as GEQR2 and GEQRF on wave64 architectures
* Improved the performance of BDSQR and GESVD
* Improved the performance of STEDC and divide and conquer Eigensolvers

#### Resolved issues

* Fixed a memory allocation issue in SYEVJ that could cause failures on clients that manage their own memory.
* Fixed a synchronizarion issue with SYEVJ that could led to a convergence failure for large matrices.
* Fixed a convergence issue in STEIN stemming from numerical orthogonality of the initial choice of eigenvectors.
* Fixed a synchronization issue in STEIN.

#### Known issues

* A known issue in STEBZ can lead to errors in routines based on bisection to compute eigenvalues for symmetric/Hermitian matrices (for example, SYEVX/HEEVX and SYGVX/HEGVX), as well as singular values (for example, BDSVDX and GESVDX).

### **rocSPARSE** (3.3.0)

#### Added

* `rocsparse_create_extract_descr`, `rocsparse_destroy_extract_descr`, `rocsparse_extract_buffer_size`, `rocsparse_extract_nnz`, and `rocsparse_extract` APIs to allow extraction of the upper or lower part of sparse CSR or CSC matrices.

#### Changed

* Change the default compiler from hipcc to amdclang in install script and CMake files.
* Change address sanitizer build targets so that only gfx908:xnack+, gfx90a:xnack+, gfx940:xnack+, gfx941:xnack+, and gfx942:xnack+ are built when `BUILD_ADDRESS_SANITIZER=ON` is configured.

#### Optimized

* Improved user documentation

#### Resolved issues

* Fixed the `csrmm` merge path algorithm so that diagonal is clamped to the correct range.
* Fixed a race condition in `bsrgemm` that could on rare occasions cause incorrect results.
* Fixed an issue in `hyb2csr` where the CSR row pointer array was not being properly filled when `n=0`, `coo_nnz=0`, or `ell_nnz=0`.
* Fixed scaling in `rocsparse_Xhybmv` when only performing `y=beta*y`, for example, where `alpha==0` in `y=alpha*Ax+beta*y`.
* Fixed `rocsparse_Xgemmi` failures when the y grid dimension is too large. This occurred when `n >= 65536`.
* Fixed the gfortran dependency for the Azure Linux operating system.

### **rocThrust** (3.2.0)

#### Added

* Merged changes from upstream CCCL/thrust 2.3.2
  * Only the NVIDIA backend uses `tuple` and `pair` types from libcu++, other backends continue to use the original Thrust implementations and hence do not require libcu++ (CCCL) as a dependency.
* Added the `thrust::hip::par_det` execution policy to enable bitwise reproducibility on algorithms that are not bitwise reproducible by default.

#### Changed

* Changed the default value of `rmake.py -a` to `default_gpus`. This is equivalent to `gfx906:xnack-,gfx1030,gfx1100,gfx1101,gfx1102`.
* Enabled the upstream (thrust) test suite for execution by default. It can be disabled by using the `-DENABLE_UPSTREAM_TESTS=OFF` cmake option.

#### Resolved issues

* Fixed an issue in `rmake.py` where the list storing cmake options would contain individual characters instead of a full string of options.
* Fixed the HIP backend not passing `TestCopyIfNonTrivial` from the upstream (thrust) test suite.
* Fixed tests failing when compiled with `-D_GLIBCXX_ASSERTIONS=ON`.

### **rocWMMA** (1.6.0)

#### Added

* Added OCP `F8`/`BF8` datatype support

#### Changed

* Optimized some aos&lt;-&gt;soa transforms with half-rotation offsets
* Refactored the rocBLAS reference entry point for validation and benchmarking
* `ROCWMMA_*` preprocessor configurations are now all assigned values
* Updated the default architecture targets for ASAN builds
* Updated the actor-critic implementation

#### Resolved issues

* Fixed a bug in `F64` validation due to faulty typecasting
* Fixed a bug causing runtime compilation errors with hipRTC
* Various documentation updates and fixes

### **RPP** (1.9.1)

#### Added

* RPP Glitch and RPP Pixelate have been added to the HOST and HIP backend.
* The following audio support was added to the HIP backend:
  * Resample
  * Pre-emphasis filter
  * Down-mixing
  * To Decibels
  * Non-silent region

#### Changed

* Test prerequisites have been updated.
* AMD advanced build flag.

#### Removed

* Older versions of TurboJPEG have been removed.

#### Optimized

* Updated the test suite.

#### Resolved issues

* macOS build
* RPP Test Suite: augmentations fix
* Copy: bugfix for `NCDHW` layout
* MIVisionX compatibility fix: Resample and pre-emphasis filter

#### Known issues

* Package installation only supports the HIP backend.

#### Upcoming changes

* Optimized audio augmentations

### **Tensile** (4.42.0)

#### Added

- Testing and documentation for `MasterSolutionLibrary.ArchitectureIndexMap` and `remapSolutionIndicesStartingFrom`
- Functions for writing master file
- `tPrint` and reconcile printing options
- Python unit test coverage report
- Factor embed library logic into function and test
- `clang++` as `cxx` compiler option for Windows
- Logic to cope with different compilers
-`toFile` function to include `generateManifest` and moved to utilities
- Profiling CI job
- Support for `amdclang` and use defaults
- Architecture management functions in `TensileCreateLibrary`
- `TensileCreateLibrary` CLI reference docs
- New documentation for sphinx prototype and build out skeleton
- Contributor and developer guide
- Prediction model for optimal number of Stream-K tiles to run
  - Two-tile algorithm with Stream-K after DP
  - Atomic two-tile Stream-K and clean-up tuning parameters
  - Using glob to find logic files in `TensileCreateLibrary`
  - Function to confirm supported compiler rather than raw logic

#### Changed

- Improved rocBLAS build output by allowing warning suppression, ignoring developer warnings, displaying progress bar and quiet printing
- Reordered extensions for Windows in `which` function
- updated `amdclang++` and `asm` directories
- Updated duplicate marking tests with mocks
- Restored print ordering
- Print option
- Bumped rocm-docs-core from 1.2.0 to 1.5.0 in `/docs/sphinx`
- Refactored kernel duplicate matching
- Refactored `generateLogicDataAndSolutions`
- Restricted XCC mapping to gfx942
- Refactored argument parsing in `TensileCreateLibrary`
- Disabled failing rhel9 tests
- Changed line length to 100 characters for formatting
- Changed YAML operations to use C `libyaml` backend
- Improved warning text
- Updated clang support for Windows
- Updated `supportedCompiler` function
- Clang support on Windows to require use of conditional choices and defaults
- Refactored sanity check in `TensileCreateLibrary`
- Moved client config logic from `TensileCreateLibrary` main into `createClientConfig`
- Updated `verifyManifest` in `TensileCreateLibrary`
- Updated RTD configs
- Cleaned up CMake to avoid redundant work during client builds
- Updated Stream-K debug settings

#### Removed

- Deprecated flag from CI profiling job
- Diagnostic print
- Globals from `prepAsm`
- Deprecated `package-library` option
- Duplicate `which` function and minor cleanup

#### Optimized

- To optimize the performance of Stream-K kernels:
  - Introduced analytical grid size prediction model
  - Remapped XCC-based workgroup

#### Resolved issues

- Fixed stream-K XCC configs for gfx942
- Updated WMMA capability command for ISA 10+
- Fixed progress bar character encoding error on Windows
- Fixed solution redundancy removal
- Fixed tuning imports for `pyyaml`
- Fixed printing of ASM capabilities for ROCm versions prior to 6.3
- Fixed code objects by filtering kernels with build errors and unprocessed kernels
- Fixed fully qualified `std::get` in contraction solutions
- Fixed `add -v flag` and change system invocation
- Used conditional imports for new dependencies to fix yaml `CSafe` load and dump import and rich terminal print import
- Fixed comments on `scalarStaticDivideAndRemainder`

## ROCm 6.2.4

See the [ROCm 6.2.4 release notes](https://rocm.docs.amd.com/en/docs-6.2.4/about/release-notes.html)
for a complete overview of this release.

### **AMD SMI** (24.6.3)

#### Resolved issues

* Fixed support for the API calls `amdsmi_get_gpu_process_isolation` and
  `amdsmi_clean_gpu_local_data`, along with the `amd-smi set
  --process-isolation <0 or 1>` command. See issue
  [#3500](https://github.com/ROCm/ROCm/issues/3500) on GitHub.

### **rocFFT** (1.0.30)

#### Optimized

* Implemented 1D kernels for factorizable sizes greater than 1024 and less than 2048.

#### Resolved issues

* Fixed plan creation failure on some even-length real-complex transforms that use Bluestein's algorithm.

### **rocSOLVER** (3.26.2)

#### Resolved issues

* Fixed synchronization issue in STEIN.

## ROCm 6.2.2

### **AMD SMI** (24.6.3)

#### Changed

* Added `amd-smi static --ras` on Guest VMs. Guest VMs can view enabled/disabled RAS features on Host cards.

#### Removed

* Removed `amd-smi metric --ecc` & `amd-smi metric --ecc-blocks` on Guest VMs. Guest VMs do not support getting current ECC counts from the Host cards.

#### Resolved issues

* Fixed TypeError in `amd-smi process -G`.
* Updated CLI error strings to handle empty and invalid GPU/CPU inputs.
* Fixed Guest VM showing passthrough options.
* Fixed firmware formatting where leading 0s were missing.

### **HIP** (6.2.1)

#### Resolved issues

* Soft hang when using `AMD_SERIALIZE_KERNEL`
* Memory leak in `hipIpcCloseMemHandle`

### **HIPIFY** (18.0.0)

#### Added

* Added CUDA 12.5.1 support
* Added cuDNN 9.2.1 support
* Added LLVM 18.1.8 support
* Added `hipBLAS` 64-bit APIs support
* Added Support for math constants `math_constants.h`

### **Omnitrace** (1.11.2)

#### Known issues

Perfetto can no longer open Omnitrace proto files. Loading Perfetto trace output `.proto` files in the latest version of `ui.perfetto.dev` can result in a dialog with the message, "Oops, something went wrong! Please file a bug." The information in the dialog will refer to an "Unknown field type." The workaround is to open the files with the previous version of the Perfetto UI found at [https://ui.perfetto.dev/v46.0-35b3d9845/#!/](https://ui.perfetto.dev/v46.0-35b3d9845/#!/).

See [issue #3767](https://github.com/ROCm/ROCm/issues/3767) on GitHub.

### **RCCL** (2.20.5)

#### Known issues

On systems running Linux kernel 6.8.0, such as Ubuntu 24.04, Direct Memory Access (DMA) transfers between the GPU and NIC are disabled and impacts multi-node RCCL performance.
This issue was reproduced with RCCL 2.20.5 (ROCm 6.2.0 and 6.2.1) on systems with Broadcom Thor-2 NICs and affects other systems with RoCE networks using Linux 6.8.0 or newer.
Older RCCL versions are also impacted.

This issue will be addressed in a future ROCm release.

See [issue #3772](https://github.com/ROCm/ROCm/issues/3772) on GitHub.

### **rocAL** (2.0.0)

#### Changed
 
* The new version of rocAL introduces many new features, but does not modify any of the existing public API functions.However, the version number was incremented from 1.3 to 2.0.
  Applications linked to version 1.3 must be recompiled to link against version 2.0.
* Added development and test packages.
* Added C++ rocAL audio unit test and Python script to run and compare the outputs.
* Added Python support for audio decoders.
* Added Pytorch iterator for audio.
* Added Python audio unit test and support to verify outputs.
* Added rocDecode for HW decode.
* Added support for: 
    * Audio loader and decoder, which uses libsndfile library to decode wav files
    * Audio augmentation - PreEmphasis filter, Spectrogram, ToDecibels, Resample, NonSilentRegionDetection, MelFilterBank 
    * Generic augmentation - Slice, Normalize
    * Reading from file lists in file reader
    * Downmixing audio channels during decoding
    * TensorTensorAdd and TensorScalarMultiply operations
    * Uniform and Normal distribution nodes
* Image to tensor updates
* ROCm install - use case graphics removed

#### Known issues
 
* Dependencies are not installed with the rocAL package installer. Dependencies must be installed with the prerequisite setup script provided. See the [rocAL README on GitHub](https://github.com/ROCm/rocAL/blob/docs/6.2.1/README.md#prerequisites-setup-script) for details.

### **rocBLAS** (4.2.1)

#### Removed

* Removed Device_Memory_Allocation.pdf link in documentation.

#### Resolved issues

* Fixed error/warning message during `rocblas_set_stream()` call.

### **rocFFT** (1.0.29)

#### Optimized

* Implemented 1D kernels for factorizable sizes less than 1024.

### **ROCm SMI** (7.3.0)

#### Optimized

* Improved handling of UnicodeEncodeErrors with non UTF-8 locales. Non UTF-8 locales were causing crashes on UTF-8 special characters.

#### Resolved issues

* Fixed an issue where the Compute Partition tests segfaulted when AMDGPU was loaded with optional parameters.

#### Known issues

* When setting CPX as a partition mode, there is a DRM node limit of 64. This is a known limitation when multiple drivers are using the DRM nodes. The `ls /sys/class/drm` command can be used to see the number of DRM nodes, and the following steps can be used to remove unnecessary drivers:

    1. Unload AMDGPU: `sudo rmmod amdgpu`.
    2. Remove any unnecessary drivers using `rmmod`. For example, to remove an AST driver, run `sudo rmmod ast`.
    3. Reload AMDGPU using `modprobe`: `sudo modprobe amdgpu`.

### **rocPRIM** (3.2.1)

#### Optimized

* Improved performance of `block_reduce_warp_reduce` when warp size equals block size.

## ROCm 6.2.1

See the [ROCm 6.2.1 release notes](https://rocm.docs.amd.com/en/docs-6.2.1/about/release-notes.html)
for a complete overview of this release.

### **AMD SMI** (24.6.3)

#### Changes

* Added `amd-smi static --ras` on Guest VMs. Guest VMs can view enabled/disabled RAS features on Host cards.

#### Removals

* Removed `amd-smi metric --ecc` & `amd-smi metric --ecc-blocks` on Guest VMs. Guest VMs do not support getting current ECC counts from the Host cards.

#### Resolved issues

* Fixed TypeError in `amd-smi process -G`.
* Updated CLI error strings to handle empty and invalid GPU/CPU inputs.
* Fixed Guest VM showing passthrough options.
* Fixed firmware formatting where leading 0s were missing.

### **HIP** (6.2.1)

#### Resolved issues

* Soft hang when using `AMD_SERIALIZE_KERNEL`
* Memory leak in `hipIpcCloseMemHandle`

### **HIPIFY** (18.0.0)

#### Changes

* Added CUDA 12.5.1 support.
* Added cuDNN 9.2.1 support.
* Added LLVM 18.1.8 support.
* Added `hipBLAS` 64-bit APIs support.
* Added Support for math constants `math_constants.h`.

### **Omniperf** (2.0.1)

#### Changes

* Enabled rocprofv1 for MI300 hardware.
* Added dependency checks on application launch.
* Updated Omniperf packaging.
* Rolled back Grafana version in Dockerfile for Angular plugin compatibility.
* Added GPU model distinction for MI300 systems.
* Refactored and updated documemtation.

#### Resolved issues

* Fixed an issue with analysis output.
* Fixed issues with profiling multi-process and multi-GPU applications.

#### Optimizations

* Reduced running time of Omniperf when profiling.
* Improved console logging.

### **Omnitrace** (1.11.2)

#### Known issues

Perfetto can no longer open Omnitrace proto files. Loading Perfetto trace output `.proto` files in the latest version of `ui.perfetto.dev` can result in a dialog with the message, "Oops, something went wrong! Please file a bug." The information in the dialog will refer to an "Unknown field type." The workaround is to open the files with the previous version of the Perfetto UI found at [https://ui.perfetto.dev/v46.0-35b3d9845/#!/](https://ui.perfetto.dev/v46.0-35b3d9845/#!/).

See [issue #3767](https://github.com/ROCm/ROCm/issues/3767) on GitHub.

### **RCCL** (2.20.5)

#### Known issues

On systems running Linux kernel 6.8.0, such as Ubuntu 24.04, Direct Memory Access (DMA) transfers between the GPU and NIC are disabled and impacts multi-node RCCL performance.
This issue was reproduced with RCCL 2.20.5 (ROCm 6.2.0 and 6.2.1) on systems with Broadcom Thor-2 NICs and affects other systems with RoCE networks using Linux 6.8.0 or newer.
Older RCCL versions are also impacted.

This issue will be addressed in a future ROCm release.

See [issue #3772](https://github.com/ROCm/ROCm/issues/3772) on GitHub.

### **rocAL** (2.0.0)

#### Changed
 
* The new version of rocAL introduces many new features, but does not modify any of the existing public API functions.However, the version number was incremented from 1.3 to 2.0.
  Applications linked to version 1.3 must be recompiled to link against version 2.0.
* Added development and test packages.
* Added C++ rocAL audio unit test and Python script to run and compare the outputs.
* Added Python support for audio decoders.
* Added Pytorch iterator for audio.
* Added Python audio unit test and support to verify outputs.
* Added rocDecode for HW decode.
* Added support for: 
    * Audio loader and decoder, which uses libsndfile library to decode wav files
    * Audio augmentation - PreEmphasis filter, Spectrogram, ToDecibels, Resample, NonSilentRegionDetection, MelFilterBank 
    * Generic augmentation - Slice, Normalize
    * Reading from file lists in file reader
    * Downmixing audio channels during decoding
    * TensorTensorAdd and TensorScalarMultiply operations
    * Uniform and Normal distribution nodes
* Image to tensor updates
* ROCm install - use case graphics removed

#### Known issues
 
* Dependencies are not installed with the rocAL package installer. Dependencies must be installed with the prerequisite setup script provided. See the [rocAL README on GitHub](https://github.com/ROCm/rocAL/blob/docs/6.2.1/README.md#prerequisites-setup-script) for details.

### **rocBLAS** (4.2.1)

#### Removed

* Removed Device_Memory_Allocation.pdf link in documentation.

#### Resolved issues

* Fixed error/warning message during `rocblas_set_stream()` call.

### **rocFFT** (1.0.29)

#### Optimized

* Implemented 1D kernels for factorizable sizes less than 1024.

### **ROCm SMI** (7.3.0)

#### Optimized

* Improved handling of UnicodeEncodeErrors with non UTF-8 locales. Non UTF-8 locales were causing crashes on UTF-8 special characters.

#### Resolved issues

* Fixed an issue where the Compute Partition tests segfaulted when AMDGPU was loaded with optional parameters.

#### Known issues

* When setting CPX as a partition mode, there is a DRM node limit of 64. This is a known limitation when multiple drivers are using the DRM nodes. The `ls /sys/class/drm` command can be used to see the number of DRM nodes, and the following steps can be used to remove unnecessary drivers:
        
    1. Unload AMDGPU: `sudo rmmod amdgpu`.
    2. Remove any unnecessary drivers using `rmmod`. For example, to remove an AST driver, run `sudo rmmod ast`.
    3. Reload AMDGPU using `modprobe`: `sudo modprobe amdgpu`.

### **rocPRIM** (3.2.1)

#### Optimized

* Improved performance of `block_reduce_warp_reduce` when warp size equals block size.

## ROCm 6.2.0

See the [ROCm 6.2.0 release notes](https://rocm.docs.amd.com/en/docs-6.2.0/about/release-notes.html)
for a complete overview of this release.

### **AMD SMI** (24.6.2)

#### Changed

- Added the following functionality:
  - `amd-smi dmon` is now available as an alias to `amd-smi monitor`.
  - An optional process table under `amd-smi monitor -q`.
  - Handling to detect VMs with passthrough configurations in CLI tool.
  - Process Isolation and Clear SRAM functionality to the CLI tool for VMs.
  - Added Ring Hang event.
- Added macros that were in `amdsmi.h` to the AMD SMI Python library `amdsmi_interface.py`.
- Renamed `amdsmi_set_gpu_clear_sram_data()` to `amdsmi_clean_gpu_local_data()`.

#### Removed

- Removed `throttle-status` from `amd-smi monitor` as it is no longer reliably supported.
- Removed elevated permission requirements for `amdsmi_get_gpu_process_list()`.

#### Optimized

- Updated CLI error strings to specify invalid device type queried.
- Multiple structure updates in `amdsmi.h` and `amdsmi_interface.py` to align with host/guest.
  - Added `amdsmi.h` and `amdsmi_interface.py`.
  - `amdsmi_clk_info_t` struct
  - Added `AMDSMI` prefix to multiple structures.
- Updated `dpm_policy` references to `soc_pstate`.
- Updated `amdsmi_get_gpu_board_info()` product_name to fallback to `pciids` file.
- Updated `amdsmi_get_gpu_board_info()` now has larger structure sizes for `amdsmi_board_info_t`.
- Updated CLI voltage curve command output.

#### Resolved issues

- Fixed multiple processes not being registered in `amd-smi process` with JSON and CSV format.
- `amdsmi_get_gpu_board_info()` no longer returns junk character strings.
- Fixed parsing of `pp_od_clk_voltage` within `amdsmi_get_gpu_od_volt_info`.
- Fixed Leftover Mutex deadlock when running multiple instances of the CLI tool. When running
  `amd-smi reset --gpureset --gpu all` and then running an instance of `amd-smi static` (or any
  other subcommand that access the GPUs) a mutex would lock and not return requiring either a
  clear of the mutex in `/dev/shm` or rebooting the machine.

#### Known issues

- `amdsmi_get_gpu_process_isolation` and `amdsmi_clean_gpu_local_data` commands do not work.
  They will be supported in a future release.

See [issue #3500](https://github.com/ROCm/ROCm/issues/3500) on GitHub.

> [!NOTE]
> See the [detailed AMD SMI changelog](https://github.com/ROCm/amdsmi/blob/docs/6.2.0/CHANGELOG.md) on GitHub for more information.

### **Composable Kernel** (1.1.0)

#### Changed

- Added support for:
  - Permute scale for any dimension (#1198).
  - Combined elementwise op (#1217).
  - Multi D in grouped convolution backward weight (#1280).
  - K or C equal to 1 for `fp16` in grouped convolution backward weight (#1280).
  - Large batch in grouped convolution forward (#1332).
- Added `CK_TILE` layernorm example (#1339).
- `CK_TILE`-based Flash Attention 2 kernel is now merged into the upstream repository as ROCm backend.

#### Optimized

- Support universal GEMM in grouped convolution forward (#1320).
- Optimizations for low M and N in grouped convolution backward weight (#1303).
- Added a functional enhancement and compiler bug fix for FlashAttention Forward Kernel.
- `FP8` GEMM performance optimization and tuning (#1384).
- Added FlashAttention backward pass performance optimization (#1397).

### **HIP** (6.2.0)

#### Changed

- Added the `_sync()` version of crosslane builtins such as `shfl_sync()`, `__all_sync()` and `__any_sync()`. These take
  a 64-bit integer as an explicit mask argument.
  - In HIP 6.2, these are hidden behind the preprocessor macro `HIP_ENABLE_WARP_SYNC_BUILTINS`, and will be enabled
    unconditionally in a future HIP release.

- Added new HIP APIs:
  - `hipGetProcAddress` returns the pointer to driver function, corresponding to the defined driver function symbol.
  - `hipGetFuncBySymbol` returns the pointer to device entry function that matches entry function `symbolPtr`.
  - `hipStreamBeginCaptureToGraph` begins graph capture on a stream to an existing graph.
  - `hipGraphInstantiateWithParams` creates an executable graph from a graph.

- Added a new flag `integrated` -- supported in device property.

  - The integrated flag is added in the struct `hipDeviceProp_t`. On the integrated APU system, the runtime driver
    detects and sets this flag to `1`, in which case the API `hipDeviceGetAttribute` returns enum `hipDeviceAttribute_t` for
    `hipDeviceAttributeIntegrated` as value 1, for integrated GPU device.

- Added initial support for 8-bit floating point datatype in `amd_hip_fp8.h`. These are accessible via `#include <hip/hip_fp8.h>`.

- Added UUID support for environment variable `HIP_VISIBLE_DEVICES`.

#### Resolved issues

- Fixed stream capture support in HIP graphs. Prohibited and unhandled operations are fixed during stream capture in the HIP runtime.
- Fixed undefined symbol error for `hipTexRefGetArray` and `hipTexRefGetBorderColor`.

#### Upcoming changes

- The `_sync()` version of crosslane builtins such as `shfl_sync()`, `__all_sync()`, and `__any_sync()` will be enabled unconditionally in a future HIP release.

### **hipBLAS** (2.2.0)

#### Changed

* Added a new ILP64 API for level 2 functions for both C and FORTRAN (`_64` name suffix) with `int64_t` function arguments.
* Added a new ILP64 API for level 1 `_ex` functions.

* The `install.sh` script now invokes the `rmake.py` script. Made other various improvements to the build scripts.
* Changed library dependencies in the `install.sh` script from `rocblas` and `rocsolver` to the development packages
  `rocblas-dev` and `rocsolver-dev`.
* Updated Linux AOCL dependency to release 4.2 `gcc` build.
* Updated Windows `vcpkg` dependencies to release 2024.02.14.

### **hipBLASLt** (0.8.0)

#### Changed

* Added extension APIs:
  *`hipblasltExtAMaxWithScale`.
  * `GemmTuning` extension parameter to set `wgm` by user.
* Added support for:
  * `HIPBLASLT_MATMUL_DESC_AMAX_D_POINTER` for `FP8`/`BF8` datatype.
  * `FP8`/`BF8` input, `FP32/FP16/BF16/F8/BF8` output (gfx94x platform only).
  * `HIPBLASLT_MATMUL_DESC_COMPUTE_INPUT_TYPE_A_EXT` and `HIPBLASLT_MATMUL_DESC_COMPUTE_INPUT_TYPE_B_EXT` for `FP16` input data type to use `FP8`/`BF8` MFMA.
* Added support for gfx110x.

#### Optimized

* Improved library loading time.

### **HIPCC** (1.1.1)

#### Changed

* Split `hipcc` package into two packages for different hardware platforms.

* Cleaned up references to environment variables.

* Enabled `hipcc` and `hipconfig` binaries (`hipcc.bin`, `hipconfig.bin`) by
  default, instead of their Perl counterparts.

* Enabled function calls.

* Added support for generating packages for ROCm stack targeting static libraries.

#### Resolved issues

* Implemented numerous bug fixes and quality improvements.

### **hipCUB** (3.2.0)

#### Changed

* Added `DeviceCopy` function for parity with CUB.
* Added `enum WarpExchangeAlgorithm` to the rocPRIM backend, which is used as
  the new optional template argument for `WarpExchange`.
  * The potential values for the enum are `WARP_EXCHANGE_SMEM` and
    `WARP_EXCHANGE_SHUFFLE`.
  * `WARP_EXCHANGE_SMEM` stands for the previous algorithm, while
    `WARP_EXCHANGE_SHUFFLE` performs the exchange via shuffle operations.
  * `WARP_EXCHANGE_SHUFFLE` does not require any pre-allocated shared memory,
    but the `ItemsPerThread` must be a divisor of `WarpSize`.
* Added `tuple.hpp` which defines templates `hipcub::tuple`,
  `hipcub::tuple_element`, `hipcub::tuple_element_t` and `hipcub::tuple_size`.
* Added new overloaded member functions to `BlockRadixSort` and
  `DeviceRadixSort` that expose a `decomposer` argument. Keys of a custom type
  (`key_type`) can be sorted via these overloads, if an appropriate decomposer
  is passed. The decomposer has to implement `operator(const key_type&)` which
  returns a `hipcub::tuple` of references pointing to members of `key_type`.

* On AMD GPUs (using the HIP backend), you can now issue hipCUB API calls inside of
  HIP graphs, with several exceptions:
   * `CachingDeviceAllocator`
   * `GridBarrierLifetime`
   * `DeviceSegmentedRadixSort`
   * `DeviceRunLengthEncode`
  Currently, these classes rely on one or more synchronous calls to function correctly. Because of this, they cannot be used inside of HIP graphs.

#### Removed

* Deprecated `debug_synchronous` in hipCUB-2.13.2, and it no longer has any effect. With this release, passing `debug_synchronous`
  to the device functions results in a deprecation warning both at runtime and at compile time.
  * The synchronization that was previously achievable by passing `debug_synchronous=true` can now be achieved at compile time
    by setting the `CUB_DEBUG_SYNC` (or higher debug level) or the `HIPCUB_DEBUG_SYNC` preprocessor definition.
  * The compile time deprecation warnings can be disabled by defining the `HIPCUB_IGNORE_DEPRECATED_API` preprocessor definition.

#### Resolved issues

* Fixed the derivation for the accumulator type for device scan algorithms in the rocPRIM backend being different compared to CUB.
  It now derives the accumulator type as the result of the binary operator.

### **hipFFT** (1.0.15)

#### Resolved issues

* Added `hip::host` as a public link library, as `hipfft.h` includes HIP runtime headers.
* Prevented C++ exceptions leaking from public API functions.
* Made output of `hipfftXt` match `cufftXt` in geometry and alignment for 2D and 3D FFTs.

### **HIPIFY** (18.0.0)

#### Changed

- Added support for:
  - NVIDIA CUDA 12.4.1
  - cuDNN 9.1.1
  - LLVM 18.1.6
- Added full hipBLASLt support.

#### Resolved issues

- HIPIFY now applies `reinterpret_cast` for an explicit conversion between pointer-to-function and pointer-to-object;
  affected functions: `hipFuncGetAttributes`, `hipFuncSetAttribute`, `hipFuncSetCacheConfig`, `hipFuncSetSharedMemConfig`, `hipLaunchKernel`, and `hipLaunchCooperativeKernel`.

### **hipRAND** (2.11.0)

#### Changed

* Added support for setting generator output ordering in C and C++ API.
* `hiprandCreateGeneratorHost` dispatches to the host generator in the rocRAND backend instead of returning with
  `uHIPRAND_STATUS_NOT_IMPLEMENTED`.
* Added options to create:
  * A host generator to the Fortran wrapper.
  * A host generator to the Python wrapper.
* Previously, for internal testing with HMM the environment variable `ROCRAND_USE_HMM` was used in previous
  versions. The environment variable is now named `HIPRAND_USE_HMM`.
* Static library -- moved all internal symbols to namespaces to avoid potential symbol name collisions when linking.
* Device API documentation is improved in this version.

#### Removed

* Removed the option to build hipRAND as a submodule to rocRAND.
* Removed references to, and workarounds for, the deprecated `hcc`.
* Removed support for finding rocRAND based on the environment variable `ROCRAND_DIR`.
  Use `ROCRAND_PATH` instead.

#### Resolved issues

* Fixed a build error when using Clang++ directly due to unsupported references to `amdgpu-target`.

### **hipSOLVER** (2.2.0)

#### Changed

- Added compatibility-only functions:
  - `auxiliary`
    - `hipsolverDnCreateParams`, `hipsolverDnDestroyParams`, `hipsolverDnSetAdvOptions`
  - `getrf`
    - `hipsolverDnXgetrf_bufferSize`
    - `hipsolverDnXgetrf`
  - `getrs`
    - `hipsolverDnXgetrs`
- Added support for building on Ubuntu 24.04 and CBL-Mariner.
- Added `hip::host` to `roc::hipsolver` usage requirements.
- Added functions
  - `syevdx`/`heevdx`
    - `hipsolverSsyevdx_bufferSize`, `hipsolverDsyevdx_bufferSize`, `hipsolverCheevdx_bufferSize`, `hipsolverZheevdx_bufferSize`
    - `hipsolverSsyevdx`, `hipsolverDsyevdx`, `hipsolverCheevdx`, `hipsolverZheevdx`
  - `sygvdx`/`hegvdx`
    - `hipsolverSsygvdx_bufferSize`, `hipsolverDsygvdx_bufferSize`, `hipsolverChegvdx_bufferSize`, `hipsolverZhegvdx_bufferSize`
    - `hipsolverSsygvdx`, `hipsolverDsygvdx`, `hipsolverChegvdx`, `hipsolverZhegvdx`

- Updated `csrlsvchol` to perform numerical factorization on the GPU. The symbolic factorization is still performed on the CPU.
- Renamed `hipsolver-compat.h` to `hipsolver-dense.h`.

#### Removed

- Removed dependency on `cblas` from the hipSOLVER test and benchmark clients.

### **hipSPARSE** (3.1.1)

#### Changed

* Added the missing `hipsparseCscGet()` routine.

* All internal hipSPARSE functions now exist inside a namespace.
* Match deprecations found in cuSPARSE 12.x.x when using cuSPARSE backend.
* Improved the user manual and contribution guidelines.

#### Resolved issues

* Fixed `SpGEMM` and `SpGEMM_reuse` routines that were not matching cuSPARSE behavior.

#### Known issues

* In `hipsparseSpSM_solve()`, the external buffer is currently passed as a parameter. This does not match the cuSPARSE API
  and this extra external buffer parameter will be removed in a future release. For now this extra parameter can be
  ignored and passed a `nullptr` as it is unused internally by `hipsparseSpSM_solve()`.

### **hipSPARSELt** (0.2.1)

#### Optimized

* Refined test cases.

### **hipTensor** (1.3.0)

#### Changed

* Added support for:
  * Tensor permutation of ranks of 2, 3, 4, 5, and 6
  * Tensor contraction of M6N6K6: M, N, K up to rank 6
* Added tests for:
  * Tensor permutation of ranks of 2, 3, 4, 5, and 6
  * Tensor contraction of M6N6K6: M, N, K up to rank 6
  * YAML parsing to support sequential parameters ordering.
* Prefer `amd-llvm-devel` package before system LLVM library.
* Preferred compilers changed to `CC=amdclang` `CXX=amdclang++`.
* Updated actor-critic selection for new contraction kernel additions.
* Updated installation, programmer's guide, and API reference documentation.

#### Resolved issues

* Fixed LLVM parsing crash.
* Fixed memory consumption issue in complex kernels.
* Workaround implemented for compiler crash during debug build.
* Allow random modes ordering for tensor contractions.

### **llvm-project** (18.0.0)

#### Changed

* LLVM IR

  * The `llvm.stacksave` and `llvm.stackrestore` intrinsics now use an overloaded pointer type to support non-0 address
    spaces.

  * Added `llvm.exp10` intrinsic.

* LLVM infrastructure

  * The minimum Clang version to build LLVM in C++20 configuration is now `clang-17.0.6`.

* TableGen

  * Added constructs for debugging TableGen files:

    * `dump` keyword to dump messages to standard error. See [#68793](https://github.com/llvm/llvm-project/pull/68793).

    * `!repr` bang operator to inspect the content of values. See [#68716](https://github.com/llvm/llvm-project/pull/68716).

* AArch64 backend

  * Added support for Cortex-A520, Cortex-A720 and Cortex-X4 CPUs.

* AMDGPU backend

  * `llvm.sqrt.f32` is now lowered correctly. Use `llvm.amdgcn.sqrt.f32` for raw instruction access.

  * Implemented `llvm.stacksave` and `llvm.stackrestore` intrinsics.

  * Implemented `llvm.get.rounding`.

* ARM backend

  * Added support for Cortex-M52 CPUs.

  * Added execute-only support for Armv6-M.

* RISC-V backend

  * The `Zfa` extension version was upgraded to 1.0 and is no longer experimental.

  * `Zihintntl` extension version was upgraded to 1.0 and is no longer experimental.

  * Intrinsics were added for `Zk*`, `Zbb`, and `Zbc`. See
    [Scalar Bit Manipulation Extension Intrinsics](https://github.com/riscv-non-isa/riscv-c-api-doc/blob/main/src/c-api.adoc#scalar-bit-manipulation-extension-intrinsics) in the RISC-V C API specification.

  * Default ABI with F but without D was changed to ilp32f for RV32 and to lp64f for RV64.

  * The `Zvbb`, `Zvbc`, `Zvkb`, `Zvkg`, `Zvkn`, `Zvknc`, `Zvkned`, `Zvkng`, `Zvknha`, `Zvknhb`, `Zvks`, `Zvksc`,
    `Zvksed`, `Zvksg`, `Zvksh`, and `Zvkt` extension version was upgraded to 1.0 and is no longer experimental. However,
    the C intrinsics for these extensions are still experimental. To use the C intrinsics for these extensions,
    `-menable-experimental-extensions` needs to be passed to Clang.

  * `-mcpu=sifive-p450` was added.

  * CodeGen of `RV32E` and `RV64E` is supported experimentally.

  * CodeGen of `ilp32e` and `lp64e` is supported experimentally.

* X86 backend

  * Added support for the RDMSRLIST and WRMSRLIST instructions.

  * Added support for the WRMSRNS instruction.

  * Support ISA of AMX-FP16 which contains `tdpfp16ps` instruction.

  * Support ISA of CMPCCXADD.

  * Support ISA of AVX-IFMA.

  * Support ISA of AVX-VNNI-INT8.

  * Support ISA of AVX-NE-CONVERT.

  * `-mcpu=raptorlake`, `-mcpu=meteorlake` and `-mcpu=emeraldrapids` are now supported.

  * `-mcpu=sierraforest`, `-mcpu=graniterapids` and `-mcpu=grandridge` are now supported.

  * `__builtin_unpredictable` (unpredictable metadata in LLVM IR), is handled by X86 Backend. X86CmovConversion pass now
    respects this builtin and does not convert CMOVs to branches.

  * Add support for the PBNDKB instruction.

  * Support ISA of SHA512.

  * Support ISA of SM3.

  * Support ISA of SM4.

  * Support ISA of AVX-VNNI-INT16.

  * `-mcpu=graniterapids-d` is now supported.

  * The `i128` type now matches GCC and clang’s `__int128` type. This mainly benefits external projects such as Rust
    which aim to be binary compatible with C, but also fixes code generation where LLVM already assumed that the type
    matched and called into `libgcc` helper functions.

  * Support ISA of USER_MSR.

  * Support ISA of AVX10.1-256 and AVX10.1-512.

  * `-mcpu=pantherlake` and `-mcpu=clearwaterforest` are now supported.

  * `-mapxf` is supported.

  * Marking global variables with `code_model = "small"/"large"` in the IR now overrides the global code model to allow
    32-bit relocations or require 64-bit relocations to the global variable.

  * The medium code model’s code generation was audited to be more similar to the small code model where possible.

* C API

  * Added `LLVMGetTailCallKind` and `LLVMSetTailCallKind` to allow getting and setting `tail`, `musttail`, and `notail` attributes on call instructions.

  * Added `LLVMCreateTargetMachineWithOptions`, along with helper functions for an opaque option structure, as an
    alternative to `LLVMCreateTargetMachine`. The option structure exposes an additional setting (that is, the target
    ABI) and provides default values for unspecified settings.

  * Added `LLVMGetNNeg` and `LLVMSetNNeg` for getting and setting the new `nneg` flag on zext instructions, and
    `LLVMGetIsDisjoint` and `LLVMSetIsDisjoint` for getting and setting the new disjoint flag on or instructions.

  * Added the following functions for manipulating operand bundles, as well as building call and invoke instructions
    that use operand bundles:

    * `LLVMBuildCallWithOperandBundles`

    * `LLVMBuildInvokeWithOperandBundles`

    * `LLVMCreateOperandBundle`

    * `LLVMDisposeOperandBundle`

    * `LLVMGetNumOperandBundles`

    * `LLVMGetOperandBundleAtIndex`

    * `LLVMGetNumOperandBundleArgs`

    * `LLVMGetOperandBundleArgAtIndex`

    * `LLVMGetOperandBundleTag`

  * Added `LLVMGetFastMathFlags` and `LLVMSetFastMathFlags` for getting and setting the fast-math flags of an
    instruction, as well as `LLVMCanValueUseFastMathFlags` for checking if an instruction can use such flag.

* CodeGen infrastructure

  * A new debug type `isel-dump` is added to show only the SelectionDAG dumps after each ISel phase (i.e.
    `-debug-only=isel-dump`). This new debug type can be filtered by function names using
    `-filter-print-funcs=<function names>`, the same flag used to filter IR dumps after each Pass. Note that the
    existing `-debug-only=isel` will take precedence over the new behavior and print SelectionDAG dumps of every single
    function regardless of `-filter-print-funcs`’s values.

* Metadata info

  * Added a new loop metadata `!{!”llvm.loop.align”, i32 64}`.

* LLVM tools

  * `llvm-symbolizer` now treats invalid input as an address for which source information is not found.

  * `llvm-readelf` now supports `--extra-sym-info` (-X) to display extra information (section name) when showing
    symbols.

  * `llvm-readobj --elf-output-style=JSON` no longer prefixes each JSON object with the file name. Previously, each
    object file’s output looked like `"main.o":{"FileSummary":{"File":"main.o"},...}` but is now
    `{"FileSummary":{"File":"main.o"},...}`. This allows each JSON object to be parsed in the same way, since each
    object no longer has a unique key. Tools that consume `llvm-readobj`’s JSON output should update their parsers
    accordingly.

  * `llvm-objdump` now uses `--print-imm-hex` by default, which brings its default behavior closer in line with `objdump`.

  * `llvm-nm` now supports the `--line-numbers` (`-l`) option to use debugging information to print symbols’ filenames and line numbers.

  * `llvm-symbolizer` and `llvm-addr2line` now support addresses specified as symbol names.

  * `llvm-objcopy` now supports `--gap-fill` and `--pad-to` options, for ELF input and binary output files only.

* LLDB

  * `SBType::FindDirectNestedType` function is added. It’s useful for formatters to quickly find directly nested type
    when it’s known where to search for it, avoiding more expensive global search via `SBTarget::FindFirstType`.

  * Renamed `lldb-vscode` to `lldb-dap` and updated its installation instructions to reflect this. The underlying
    functionality remains unchanged.

  * The `mte_ctrl` register can now be read from AArch64 Linux core files.

  * LLDB on AArch64 Linux now supports debugging the Scalable Matrix Extension (SME) and Scalable Matrix Extension 2
    (SME2) for both live processes and core files. For details refer to the AArch64 Linux documentation.

  * LLDB now supports symbol and binary acquisition automatically using the DEBUFINFOD protocol. The standard mechanism
    of specifying DEBUFINOD servers in the DEBUGINFOD_URLS environment variable is used by default. In addition, users
    can specify servers to request symbols from using the LLDB setting `plugin.symbol-locator.debuginfod.server_urls`,
    override or adding to the environment variable.

  * When running on AArch64 Linux, `lldb-server` now provides register field information for the following registers:
    `cpsr`, `fpcr`, `fpsr`, `svcr` and `mte_ctrl`.

* Sanitizers

  * HWASan now defaults to detecting use-after-scope bugs.

#### Removals

* LLVM IR

  * The constant expression variants of the following instructions have been removed:

    * `and`

    * `or`

    * `lshr`

    * `ashr`

    * `zext`

    * `sext`

    * `fptrunc`

    * `fpext`

    * `fptoui`

    * `fptosi`

    * `uitofp`

    * `sitofp`

* RISC-V backend

  * XSfcie extension and SiFive CSRs and instructions that were associated with it have been removed. None of these CSRs and
    instructions were part of “SiFive Custom Instruction Extension”. The LLVM project needs to work with
    SiFive to define and document real extension names for individual CSRs and instructions.

* Python bindings

  * The Python bindings have been removed.

* C API

  * The following functions for creating constant expressions have been removed, because the underlying constant
    expressions are no longer supported. Instead, an instruction should be created using the `LLVMBuildXYZ` APIs, which
    will constant fold the operands if possible and create an instruction otherwise:

    * `LLVMConstAnd`

    * `LLVMConstOr`

    * `LLVMConstLShr`

    * `LLVMConstAShr`

    * `LLVMConstZExt`

    * `LLVMConstSExt`

    * `LLVMConstZExtOrBitCast`

    * `LLVMConstSExtOrBitCast`

    * `LLVMConstIntCast`

    * `LLVMConstFPTrunc`

    * `LLVMConstFPExt`

    * `LLVMConstFPToUI`

    * `LLVMConstFPToSI`

    * `LLVMConstUIToFP`

    * `LLVMConstSIToFP`

    * `LLVMConstFPCast`

* CodeGen infrastructure

  * `PrologEpilogInserter` no longer supports register scavenging during forwards frame index elimination. Targets
    should use backwards frame index elimination instead.

  * `RegScavenger` no longer supports forwards register scavenging. Clients should use backwards register scavenging
    instead, which is preferred because it does not depend on accurate kill flags.

* LLDB

  * `SBWatchpoint::GetHardwareIndex` is deprecated and now returns `-1` to indicate the index is unavailable.

  * Methods in `SBHostOS` related to threads have had their implementations removed. These methods will return a value
    indicating failure.

#### Resolved issues

* AArch64 backend

  * Neoverse-N2 was incorrectly marked as an Armv8.5a core. This has been changed to an Armv9.0a core. However, crypto
    options are not enabled by default for Armv9 cores, so `-mcpu=neoverse-n2+crypto` is now required to enable crypto for
    this core. As far as the compiler is concerned, Armv9.0a has the same features enabled as Armv8.5a, with the
    exception of crypto.

* Windows target

  * The LLVM filesystem class `UniqueID` and function `equivalent`() no longer determine that distinct different path
    names for the same hard linked file actually are equal. This is an intentional tradeoff in a bug fix, where the bug
    used to cause distinct files to be considered equivalent on some file systems. This change fixed the GitHub issues
    [#61401](https://github.com/llvm/llvm-project/issues/61401) and [#22079](https://github.com/llvm/llvm-project/issues/22079).

#### Known issues

The compiler may incorrectly compile a program that uses the
``__shfl(var, srcLane, width)`` function when one of the parameters to
the function is undefined along some path to the function. For most functions,
uninitialized inputs cause undefined behavior.

> [!NOTE]
> The ``-Wall`` compilation flag prompts the compiler to generate a warning if a variable is uninitialized along some path.

As a workaround, initialize the parameters to ``__shfl``. For example:

```{code-block} cpp
unsigned long istring = 0 // Initialize the input to __shfl
return __shfl(istring, 0, 64)
```

See [issue #3499](https://github.com/ROCm/ROCm/issues/3499) on GitHub.

### **MIGraphX** (2.10.0)

#### Changed

- Added support for ONNX Runtime MIGraphX EP on Windows.
- Added `FP8` Python API.
- Added examples for SD 2.1 and SDXL.
- Added support for BERT to Dynamic Batch.
- Added a `--test` flag in `migraphx-driver` to validate the installation.
- Added support for ONNX Operator: Einsum.
- Added `uint8` support in ONNX Operators.
- Added Split-k kernel configurations for performance improvements.
- Added fusion for group convolutions.
- Added rocMLIR conv3d support.
- Added rocgdb to the Dockerfile.
- Changed default location of libraries with release specific ABI changes.
- Reorganized documentation in GitHub.

#### Removed

- Removed the `--model` flag with `migraphx-driver`.

#### Optimized

- Improved ONNX Model Zoo coverage.
- Reorganized `memcpys` with ONNX Runtime to improve performance.
- Replaced scaler multibroadcast + unsqueeze with just a multibroadcast.
- Improved MLIR kernel selection for multibroadcasted GEMMs.
- Improved details of the perf report.
- Enable mlir by default for GEMMs with small K.
- Allow specifying dot or convolution fusion for mlir with environmental flag.
- Improve performance on small reductions by doing multiple reduction per wavefront.
- Add additional algebraic simplifications for mul-add-dot sequence of operations involving constants.
- Use MLIR attention kernels in more cases.
- Enables MIOpen and CK fusions for MI300 gfx arches.
- Support for QDQ quantization patterns from Brevitas which have explicit cast/convert nodes before and after QDQ pairs.
- Added Fusion of "contiguous + pointwise" and "layout + pointwise" operations which may result in performance gains in certain cases.
- Added Fusion for "pointwise + layout" and "pointwise + contiguous" operations which may result in performance gains when using NHWC layout.
- Added Fusion for "pointwise + concat" operation which may help in performance in certain cases.
- Fixes a bug in "concat + pointwise" fusion where output shape memory layout wasn't maintained.
- Simplifies "slice + concat" pattern in SDXL UNet.
- Removed ZeroPoint/Shift in QuantizeLinear or DeQuantizeLinear ops if zero points values are zeros.
- Improved inference performance by fusing Reduce to Broadcast.
- Added additional information when printing the perf report.
- Improve scalar fusions when not all strides are 0.
- Added support for multi outputs in pointwise ops.
- Improve reduction fusion with reshape operators.
- Use the quantized output when an operator is used again.
- Enabled Split-k GEMM perf configs for rocMLIR based GEMM kernels for better performance on all Hardware.

#### Resolved issues

- Fixed Super Resolution model verification failed with `FP16`.
- Fixed confusing messages by suppressing them when compiling the model.
- Fixed an issue causing the mod operator with `int8` and `int32` inputs.
- Fixed an issue by preventing the spawning too many threads for constant propagation when parallel STL is not enabled.
- Fixed a bug when running `migraphx-driver` with the `--run 1` option.
- Fixed Layernorm accuracy: calculations in `FP32`.
- Fixed update Docker generator script to ROCm 6.1 to point at Jammy.
- Fixed a floating point exception for `dim (-1)` in the reshape operator.
- Fixed issue with `int8` accuracy and models which were failing due to requiring a fourth bias input.
- Fixed missing inputs not previously handled for quantized bias for the weights, and data values of the input matrix.
- Fixed order of operations for `int8` quantization which were causing inaccuracies and slowdowns.
- Fixed an issues during compilation caused by the incorrect constructor being used at compile time.
  Removed list initializer of `prefix_scan_sum` which was causing issues during compilation.
- Fixed the `MIGRAPHX_GPU_COMPILE_PARALLEL` flag to enable users to control number of threads used for parallel compilation.

### **MIOpen** (3.2.0)

#### Changed

- Added:
  - [Conv] bilinear (alpha beta) solvers.
  - [Conv] enable bf16 for ck-based solvers.
  - [Conv] Add split_k tuning to 2d wrw ck-based solver.
  - [MHA] graph API fp8 fwd.
  - [RNN] multi-stream as default solution.
- Added TunaNetv2.0 for MI300.
- Added Adam and AMP Adam optimizer.

#### Resolved issues

- Memory access fault caused by `GemmBwdRest`.
- Context configuration in `GetWorkSpaceSize`.
- Fixes to support huge tensors.

#### Optimized

- Find: improved precision of benchmarking.

### **MIVisionX** (3.0.0)

#### Changed

- Added support for:
  - Advanced GPUs
  - PreEmphasis Filter augmentation in openVX extensions
  - Spectrogram augmentation in openVX extensions
  - Downmix and ToDecibels augmentations in openVX extensions
  - Resample augmentation and Operator overloading nodes in openVX extensions
  - NonSilentRegion and Slice augmentations in openVX extensions
  - Mel-Filter bank and Normalize augmentations in openVX extensions

#### Removed

- Deprecated the use of rocAL for processing. rocAL is available at [https://github.com/ROCm/rocAL](https://github.com/ROCm/rocAL).

#### Resolved issues

- Fixed issues with dependencies.

#### Known issues

- MIVisionX package install requires manual prerequisites installation.

### **Omniperf** (2.0.1)

#### Known issues

- Error when running Omniperf with an application with command line arguments. As a workaround, create an
  intermediary script to call the application with the necessary arguments, then call the script with Omniperf. This
  issue is fixed in a future release of Omniperf. See [#347](https://github.com/ROCm/rocprofiler-compute/issues/347).

- Omniperf might not work with AMD Instinct MI300 GPUs out of the box, resulting in the following error:
  "*ERROR gfx942 is not enabled rocprofv1. Available profilers include: ['rocprofv2']*". As a workaround, add the
  environment variable `export ROCPROF=rocprofv2`.

- Omniperf's Python dependencies may not be installed with your ROCm installation, resulting in the following message:

  "*[ERROR] The 'dash>=1.12.0' package was not found in the current execution environment.*

  *[ERROR] The 'dash-bootstrap-components' package was not found in the current execution environment.*

  *Please verify all of the Python dependencies called out in the requirements file are installed locally prior to running omniperf.*

  *See: /opt/rocm-6.2.0/libexec/omniperf/requirements.txt*"

  As a workaround, install these Python requirements manually: `pip install /opt/rocm-6.2.0/libexec/omniperf/requirements.txt`.

See [issue #3498](https://github.com/ROCm/ROCm/issues/3498) on GitHub.

### **OpenMP** (17.0.0)

#### Changed

- Added basic experimental support for ``libc`` functions on the GPU via the
  LLVM C Library for GPUs.
- Added minimal support for calling host functions from the device using the
  `libc` interface.
- Added vendor agnostic OMPT callback support for OpenMP-based device offload.

#### Removed

- Removed the "old" device plugins along with support for the `remote` and
  `ve` plugins.

#### Resolved issues

- Fixed the implementation of `omp_get_wtime` for AMDGPU targets.

### **RCCL** (2.20.5)

#### Changed

- Added support for `fp8` and `rccl_bfloat8`.
- Added support for using HIP contiguous memory.
- Added ROC-TX for host-side profiling.
- Added new rome model.
- Added `fp16` and `fp8` cases to unit tests.
- Added a new unit test for main kernel stack size.
- Added the new `-n` option for `topo_expl` to override the number of nodes.
- Improved debug messages of memory allocations.
- Enabled static build.
- Enabled compatibility with:
  - NCCL 2.20.5.
  - NCCL 2.19.4.
- Performance tuning for some collective operations on MI300.
- Enabled NVTX code in RCCL.
- Replaced `rccl_bfloat16` with hip_bfloat16.
- NPKit updates:
  - Removed warm-up iteration removal by default, need to opt in now.
  - Doubled the size of buffers to accommodate for more channels.
- Modified rings to be rail-optimized topology friendly.

#### Resolved issues

- Fixed a bug when configuring RCCL for only LL128 protocol.
- Fixed scratch memory allocation after API change for MSCCL.

### **rocAL** (1.0.0)

#### Changed

- Added tests and samples.

#### Removed

- Removed CuPy from `setup.py`.


#### Optimized

- Added setup and install updates.

#### Resolved issues

- Minor bug fixes.

### **rocALUTION** (3.2.0)

#### Changed

* Added new file I/O based on rocSPARSE I/O format.
* Added `GetConvergenceHistory` for ItILU0 preconditioner.

#### Removed

* Deprecated the following:
  * `LocalMatrix::ReadFileCSR`
  * `LocalMatrix::WriteFileCSR`
  * `GlobalMatrix::ReadFileCSR`
  * `GlobalMatrix::WriteFileCSR`

### **rocBLAS** (4.2.0)

#### Changed

* Added Level 2 functions and level 3 `trsm` have additional ILP64 API for both C and FORTRAN (`_64` name suffix) with `int64_t` function arguments.
* Added cache flush timing for `gemm_batched_ex`, `gemm_strided_batched_ex`, and `axpy`.
* Added Benchmark class for common timing code.
* Added an environment variable `ROCBLAS_DEFAULT_ATOMICS_MODE`; to set default atomics mode during creation of `rocblas_handle`.
* Added support for single-precision (`fp32_r`) input and double-precision (`fp64_r`) output and compute types by extending `dot_ex`.

* Updated Linux AOCL dependency to release 4.2 gcc build.
* Updated Windows vcpkg dependencies to release 2024.02.14.
* Increased default device workspace from 32 to 128 MiB for architecture gfx9xx with xx >= 40.

#### Optimized

* Improved performance of Level 1 `dot_batched` and `dot_strided_batched` for all precisions. Performance enhanced by 6 times for bigger problem sizes, as measured on an Instinct MI210 GPU.

#### Removed

* Deprecated `rocblas_gemm_ex3`, `gemm_batched_ex3` and `gemm_strided_batched_ex3`. They will be removed in the next
  major release of rocBLAS. Refer to [hipBLASLt](https://github.com/ROCm/hipBLASLt) for future 8-bit float usage.

### **ROCdbgapi** (0.76.0)

#### Removed

- Renamed `(AMD_DBGAPI_EXCEPTION_WAVE,AMD_DBGAPI_WAVE_STOP_REASON)_APERTURE_VIOLATION` to `(AMD_DBGAPI_EXCEPTION_WAVE,AMD_DBGAPI_WAVE_STOP_REASON)_ADDRESS_ERROR`.
  The old names are still accessible but deprecated.

### **rocDecode** (0.6.0)

#### Changed

- Added full H.264 support and bug fixes.

### **rocFFT** (1.0.28)

#### Changed

* Randomly generated accuracy tests are now disabled by default. They can be enabled using
  the `--nrand` option (which defaults to 0).

#### Optimized

* Implemented multi-device transform for 3D pencil decomposition.  Contiguous dimensions on input and output bricks
  are transformed locally, with global transposes to make remaining dimensions contiguous.

### **rocm-cmake** (0.13.0)

#### Changed

- `ROCmCreatePackage` now accepts a suffix parameter, automatically generating it for static or ASAN builds.
  - Package names are no longer pulled from `CPACK_<GEN>_PACKAGE_NAME`.
  - Runtime packages will no longer be generated for static builds.

### **ROCm Data Center Tool** (1.0.0)

#### Changed

- Added ROCProfiler `dmon` metrics.
- Added new ECC metrics.
- Added ROCm Validation Suite diagnostic command.
- Fully migrated to AMD SMI.

#### Removed

- Removed RASLIB dependency and blobs.
- Removed `rocm_smi_lib` dependency due to migration to AMD SMI.

### **ROCm Debugger (ROCgdb)** (14.2)

#### Changed

- Introduce the coremerge utility to merge a host core dump and a GPU-only AMDGPU core dump into a unified AMDGPU corefile.
- Added support for generating and opening core files for heterogeneous processes.

### **ROCm SMI** (7.3.0)

#### Changed

- Added Partition ID API (`rsmi_dev_partition_id_get(..)`).

#### Resolved issues

- Fixed Partition ID CLI output.

> [!NOTE]
> See the [detailed ROCm SMI changelog](https://github.com/ROCm/rocm_smi_lib/blob/docs/6.2.0/CHANGELOG.md) on GitHub for more information.

### **ROCm Validation Suite** (1.0.0)

#### Changed

* Added stress tests:

  * IET (power) stress test for MI300A.

  * IET (power transition) test for MI300X.

* Added support:

  * GEMM self-check and accuracy-check support for checking consistency and accuracy of GEMM output.

  * Trignometric float and random integer matrix data initialization support.

* Updated GST performance benchmark test for better numbers.

### **rocPRIM** (3.2.0)

#### Changed

* Added new overloads for `warp_scan::exclusive_scan` that take no initial value. These new overloads will write an unspecified result to the first value of each warp.
* The internal accumulator type of `inclusive_scan(_by_key)` and `exclusive_scan(_by_key)` is now exposed as an optional type parameter.
  * The default accumulator type is still the value type of the input iterator (inclusive scan) or the initial value's type (exclusive scan).
    This is the same behaviour as before this change.
* Added a new overload for `device_adjacent_difference_inplace` that allows separate input and output iterators, but allows them to point to the same element.
* Added new public APIs for deriving resulting type on device-only functions:
  * `rocprim::invoke_result`
  * `rocprim::invoke_result_t`
  * `rocprim::invoke_result_binary_op`
  * `rocprim::invoke_result_binary_op_t`
* Added the new `rocprim::batch_copy` function. Similar to `rocprim::batch_memcpy`, but copies by element, not with memcpy.
* Added more test cases, to better cover supported data types.
* Added an optional `decomposer` argument for all member functions of `rocprim::block_radix_sort` and all functions of `device_radix_sort`.
  To sort keys of an user-defined type, a decomposer functor should be passed. The decomposer should produce a `rocprim::tuple`
  of references to arithmetic types from the key.
* Added `rocprim::predicate_iterator` which acts as a proxy for an underlying iterator based on a predicate.
  It iterates over proxies that holds the references to the underlying values, but only allow reading and writing if the predicate is `true`.
  It can be instantiated with:
  * `rocprim::make_predicate_iterator`
  * `rocprim::make_mask_iterator`
* Added custom radix sizes as the last parameter for `block_radix_sort`. The default value is 4, it can be a number between 0 and 32.
* Added `rocprim::radix_key_codec`, which allows the encoding/decoding of keys for radix-based sorts. For user-defined key types, a decomposer functor should be passed.
* Updated some tests to work with supported data types.

#### Removed

* Deprecated the internal header `detail/match_result_type.hpp`.
* Deprecated `TwiddleIn` and `TwiddleOut` in favor of `radix_key_codec`.
* Deprecated the internal `::rocprim::detail::radix_key_codec` in favor of a new public utility with the same name.

#### Optimized

* Improved the performance of `warp_sort_shuffle` and `block_sort_bitonic`.
* Created an optimized version of the `warp_exchange` functions `blocked_to_striped_shuffle` and `striped_to_blocked_shuffle` when the warpsize is equal to the items per thread.

#### Resolved issues

* Fixed incorrect results of `warp_exchange::blocked_to_striped_shuffle` and `warp_exchange::striped_to_blocked_shuffle` when the block size is
  larger than the logical warp size. The test suite has been updated with such cases.
* Fixed incorrect results returned when calling device `unique_by_key` with overlapping `values_input` and `values_output`.
* Fixed incorrect output type used in `device_adjacent_difference`.
* Fixed an issue causing incorrect results on the GFX10 (RDNA1, RDNA2) ISA and GFX11 ISA on device scan algorithms `rocprim::inclusive_scan(_by_key)` and `rocprim::exclusive_scan(_by_key)` with large input types.
* Fixed an issue with `device_adjacent_difference`. It now considers both the
  input and the output type for selecting the appropriate kernel launch config.
  Previously only the input type was considered, which could result in compilation errors due to excessive shared memory usage.
* Fixed incorrect data being loaded with `rocprim::thread_load` when compiling with `-O0`.
* Fixed a compilation failure in the host compiler when instantiating various block and device algorithms with block sizes not divisible by 64.

### **ROCProfiler** (2.0.0)

#### Removed

- Removed `pcsampler` sample code due to deprecation from version 2.

### **rocRAND** (3.1.0)

#### Changed

* Added `rocrand_create_generator_host`.
  * The following generators are supported:
    * `ROCRAND_RNG_PSEUDO_MRG31K3P`
    * `ROCRAND_RNG_PSEUDO_MRG32K3A`
    * `ROCRAND_RNG_PSEUDO_PHILOX4_32_10`
    * `ROCRAND_RNG_PSEUDO_THREEFRY2_32_20`
    * `ROCRAND_RNG_PSEUDO_THREEFRY2_64_20`
    * `ROCRAND_RNG_PSEUDO_THREEFRY4_32_20`
    * `ROCRAND_RNG_PSEUDO_THREEFRY4_64_20`
    * `ROCRAND_RNG_PSEUDO_XORWOW`
    * `ROCRAND_RNG_QUASI_SCRAMBLED_SOBOL32`
    * `ROCRAND_RNG_QUASI_SCRAMBLED_SOBOL64`
    * `ROCRAND_RNG_QUASI_SOBOL32`
    * `ROCRAND_RNG_QUASI_SOBOL64`
  * The host-side generators support multi-core processing. On Linux, this requires the TBB (Thread Building Blocks) development package to be installed on the system when building rocRAND (`libtbb-dev` on Ubuntu and derivatives).
    * If TBB is not found when configuring rocRAND, the configuration is still successful, and the host generators are executed on a single CPU thread.
* Added the option to create a host generator to the Python wrapper.
* Added the option to create a host generator to the Fortran wrapper
* Added dynamic ordering. This ordering is free to rearrange the produced numbers,
  which can be specific to devices and distributions. It is implemented for:
  * XORWOW, MRG32K3A, MTGP32, Philox 4x32-10, MRG31K3P, LFSR113, and ThreeFry
* Added support for using Clang as the host compiler for alternative platform compilation.
* C++ wrapper:
  * Added support for `lfsr113_engine` being constructed with a seed of type `unsigned long long`, not only `uint4`.
  * Added optional order parameter to the constructor of `mt19937_engine`.
* Added the following functions for the `ROCRAND_RNG_PSEUDO_MTGP32` generator:
  * `rocrand_normal2`
  * `rocrand_normal_double2`
  * `rocrand_log_normal2`
  * `rocrand_log_normal_double2`
* Added `rocrand_create_generator_host_blocking` which dispatches without stream semantics.
* Added host-side generator for `ROCRAND_RNG_PSEUDO_MTGP32`.
* Added offset and skipahead functionality to LFSR113 generator.
* Added dynamic ordering for architecture `gfx1102`.

* For device-side generators, you can now wrap calls to `rocrand_generate_*` inside of a hipGraph. There are a few
  things to be aware of:
  - Generator creation (`rocrand_create_generator`), initialization (`rocrand_initialize_generator`), and destruction (`rocrand_destroy_generator`) must still happen outside the hipGraph.
  - After the generator is created, you may call API functions to set its seed, offset, and order.
  - After the generator is initialized (but before stream capture or manual graph creation begins), use `rocrand_set_stream` to set the stream the generator will use within the graph.
  - A generator's seed, offset, and stream may not be changed from within the hipGraph. Attempting to do so may result in unpredictable behaviour.
  - API calls for the poisson distribution (for example, `rocrand_generate_poisson`) are not yet supported inside of hipGraphs.
  - For sample usage, see the unit tests in `test/test_rocrand_hipgraphs.cpp`
* Building rocRAND now requires a C++17 capable compiler, as the internal library sources now require it. However consuming rocRAND is still possible from C++11 as public headers don't make use of the new features.
* Building rocRAND should be faster on machines with multiple CPU cores as the library has been
  split to multiple compilation units.
* C++ wrapper: the `min()` and `max()` member functions of the generators and distributions are now `static constexpr`.
* Renamed and unified the existing `ROCRAND_DETAIL_.*_BM_NOT_IN_STATE` to `ROCRAND_DETAIL_BM_NOT_IN_STATE`
* Static and dynamic library: moved all internal symbols to namespaces to avoid potential symbol name collisions when linking.

#### Removed

* Deprecated the following typedefs. Please use the unified `state_type` alias instead.
  * `rocrand_device::threefry2x32_20_engine::threefry2x32_20_state`
  * `rocrand_device::threefry2x64_20_engine::threefry2x64_20_state`
  * `rocrand_device::threefry4x32_20_engine::threefry4x32_20_state`
  * `rocrand_device::threefry4x64_20_engine::threefry4x64_20_state`
* Deprecated the following internal headers:
  * `src/rng/distribution/distributions.hpp`.
  * `src/rng/device_engines.hpp`.
* Removed references to and workarounds for deprecated hcc.
* Removed support for HIP-CPU.

#### Known issues

- `SOBOL64` and `SCRAMBLED_SOBOL64` generate poisson-distributed `unsigned long long int` numbers instead of `unsigned int`. This will be fixed in a future release.

### **ROCr Runtime** (1.14.0)

#### Changed

- Added PC sampling feature (experimental feature).

### **rocSOLVER** (3.26.0)

#### Changed

- Added 64-bit APIs for existing functions:
  - GETF2_64 (with `batched` and `strided_batched` versions)
  - GETRF_64 (with `batched` and `strided_batched` versions)
  - GETRS_64 (with `batched` and `strided_batched` versions)
- Added gfx900 to default build targets.
- Added partial eigenvalue decomposition routines for symmetric/hermitian matrices using Divide & Conquer and Bisection:
  - SYEVDX (with `batched` and `strided_batched` versions)
  - HEEVDX (with `batched` and `strided_batched` versions)
- Added partial generalized symmetric/hermitian-definite eigenvalue decomposition using Divide & Conquer and Bisection:
  - SYGVDX (with `batched` and `strided_batched` versions)
  - HEGVDX (with `batched` and `strided_batched` versions)
- Renamed install script arguments of the form `*_dir to *-path`. Arguments of the form `*_dir` remain functional for
  backwards compatibility.
- Functions working with arrays of size n - 1 can now accept null pointers when n = 1.

#### Optimized

- Improved performance of Cholesky factorization.
- Improved performance of `splitlu` to extract the L and U triangular matrices from the result of sparse factorization matrix M, where M = (L - eye) + U.

#### Resolved issues

- Fixed potential accuracy degradation in SYEVJ/HEEVJ for inputs with small eigenvalues.

### **rocSPARSE** (3.2.0)

#### Changed

* Added a new Merge-Path algorithm to SpMM, supporting CSR format.
* Added support for row order to SpSM.
* Added rocsparseio I/O functionality to the library.
* Added `rocsparse_set_identity_permutation`.

* Adjusted rocSPARSE dependencies to related HIP packages.
* Binary size has been reduced.
* A namespace has been wrapped around internal rocSPARSE functions and kernels.
* `rocsparse_csr_set_pointers`, `rocsparse_csc_set_pointers`, and `rocsparse_bsr_set_pointers` now allow the column indices and values arrays to be nullptr if `nnz` is 0.
* gfx803 target has been removed from address sanitizer builds.

#### Optimized

* SpMV adaptive and LRB algorithms have been further optimized on CSR format
* Improved performance of SpMV adaptive with symmetrically stored matrices on CSR format
* Improved documentation and contribution guidelines.

#### Resolved issues

* Fixed compilation errors with `BUILD_ROCSPARSE_ILP64=ON`.

### **rocThrust** (3.1.0)

#### Changed

* Added changes from upstream CCCL/thrust 2.2.0.
  * Updated the contents of `system/hip` and `test` with the upstream changes.
* Updated internal calls to `rocprim::detail::invoke_result` to use the public API `rocprim::invoke_result`.
* Updated to use `rocprim::device_adjacent_difference` for `adjacent_difference` API call.
* Updated internal use of custom iterator in `thrust::detail::unique_by_key` to use rocPRIM's `rocprim::unique_by_key`.
* Updated `adjecent_difference` to make use of `rocprim:adjecent_difference` when iterators are comparable and not equal otherwise use `rocprim:adjacent_difference_inplace`.

#### Known issues

* `thrust::reduce_by_key` outputs are not bit-wise reproducible, as run-to-run results for pseudo-associative reduction operators (e.g. floating-point arithmetic operators) are not deterministic on the same device.
* Note that currently, rocThrust memory allocation is performed in such a way that most algorithmic API functions cannot be called from within hipGraphs.

### **rocWMMA** (1.5.0)

#### Changed

* Added internal utilities for:
  * Element-wise vector transforms.
  * Cross-lane vector transforms.
* Added internal aos<->soa transforms for block sizes of 16, 32, 64, 128 and 256 and vector widths of 2, 4, 8 and 16.
* Added tests for new internal transforms.

* Improved loading layouts by increasing vector width for fragments with `blockDim > 32`.
* API `applyDataLayout` transform now accepts WaveCount template argument for cooperative fragments.
* API `applyDataLayout` transform now physically applies aos<->soa transform as necessary.
* Refactored entry-point of std library usage to improve hipRTC support.
* Updated installation, programmer's guide and API reference documentation.

#### Resolved issues

* Fixed the ordering of some header includes to improve portability.

### **RPP** (1.8.0)

#### Changed

- Prerequisites - ROCm install requires only `--usecase=rocm`.
- Use pre-allocated common scratchBufferHip everywhere in Tensor code for scratch HIP memory.
- Use `CHECK_RETURN_STATUS` everywhere to adhere to C++17 for HIP.
- RPP Tensor Audio support on HOST for Spectrogram.
- RPP Tensor Audio support on HOST/HIP for Slice, by modifying voxel slice kernels to now accept anchor and shape params for a more generic version.
- RPP Tensor Audio support on HOST for Mel Filter Bank.
- RPP Tensor Normalize ND support on HOST and `HIP`.

### **Tensile** (4.41.0)

#### Changed

- New tuning script to summarize rocBLAS log file
- New environment variable to test fixed grid size with Stream-K kernels
- New Stream-K dynamic mode to run large problems at slightly reduced CU count if it improves work division and power
- Add reject conditions for SourceKernel + PrefetchGlobalRead/LoopDoWhile
- Add reject condition for PreloadKernelArguments (disable PreloadKernelArguments if not supported (instead of rejecting kernel generation))
- Support NT flag for global load and store for gfx94x
- New Kernarg preloading feature (DelayRemainingArgument: initiate the load of the remaining (non-preloaded) arguments, updated AsmCaps, AsmRegisterPool to track registers for arguments and preload)
- Add option for rotating buffers timing with cache eviction
- Add predicate for arithmetic intensity
- Add DirectToVgpr + packing for f8/f16 + TLU cases
- Enable negative values for ExtraLatencyForLR to reduce interval of local read and wait for DTV
- Add test cases for DirectToVgpr + packing
- Add batch support for Stream-K kernels and new test cases
- New tuning scripts to analyze rocblas-bench results and remove tuned sizes from liblogic
- Enable VgprForLocalReadPacking + PrefetchLocalRead=1 (removed the reject condition for VFLRP + PLR=1, added test cases for VFLRP + PLR=1)
- Support VectorWidthB (new parameter VectorWidthB)
- Support VectorWidth + non SourceSwap
- Add test cases for VectorWidthB, VectorWidth + non SourceSwap
- Add code owners file
- New environment variables to dynamically adjust number of CUs used in Stream-K
- Add new parameters to specify global load width for A and B separately (GlobalLoadVectorWidthA, B (effective with GlobalReadVectorWidth=-1))
- Add xf32 option to rocblas-bench input creator

- Update rocBLAS-bench-input-create script (added number of iteration based on performance, rotating buffer flag)
- Limit build threads based on CPUs/RAM available on system (for tests)
- Update required workspace size for Stream-K, skip kernel initialization when possible
- Use fallback libraries for archs without optimized logic
- Use hipMemcpyAsync for validation (replace hipMemcpy with hipMemcpyAsync + hipStreamSynchronize in ReferenceValidator)
- Remove OCL tests
- Disable HostLibraryTests
- Reduce extended test time by removing extra parameters in the test config files
- Disable InitAccVgprOpt for Stream-K
- Skip sgemm 64bit offset tests for gfx94x
- Skip DTV, DTL, LSU+MFMA tests for gfx908
- Increase extended test timeout to 720 min
- Update xfail test (1sum tests only failing on gfx90a)
- Update lib logic convertor script
- Test limiting CI threads for only gfx11
- wGM related kernargs are removed if they are not needed (WGM=-1,0,1)
- Cleanup on unused old code, mostly related to old client
- Change GSUA to SingleBuffer if GlobalSplitU=1 + MultipleBuffer, instead of rejecting it
- Update efficiency script for new architecture and xf32 datatype
- Re-enable negative values for WorkGroupMapping (asm kernel only)
- Disable HW monitor for aquvavanjaram941
- Pre-apply offsets for strided batch kernels
- Update tensile build with 16 threads

#### Optimized

- Made initialization optimizations (reordered init code for PreloadKernelArguments opt, used s_mov_b64 for 64 bit address copy, used v_mov_b64/ds_read_b64 for C register initialization, added undefine AddressC/D with PreloadKernelArguments, optimized waitcnt for prefetch global read with DirectToVgpr, refactored waitcnt code for DTV and moved all asm related code to KernelWriterAssembly.py).
- Optimized temp vgpr allocation for ClusterLocalRead (added if condition to allocate temp vgpr only for 8bit datatype)
- Reversed MFMA order in inner loop for odd outer iteration
- Optimized waitcnt lgkmcnt for 1LDSBuffer + PGR>1 (removed redundant waitcnt lgkmcnt after 1LDSBuffer sync)
- Enhanced maximum value of DepthU to 1024 (used globalParameters MaxDepthU to define maximum value of DepthU)

#### Resolved issues

- Fixed `WorkspaceCheck` implementation when used in rocBLAS.
- Fixed Stream-K partials cache behavior.
- Fixed `MasterSolutionLibrary` indexing for multiple architecture build.
- Fixed memory allocation fail with FlushMemorySize + StridedBatched/Batched cases (multiply batch count size when calculating array size).
- Fixed BufferLoad=False with Stream-K.
- Fixed mismatch issue with `GlobalReadCoalesceGroup`.
- Fixed rocBLAS build fail on gfx11 (used state["ISA"] for reject conditions instead of globalParameters["CurrentISA"]).
- Fixed for LdsPad auto (fixed incorrect value assignment for autoAdjusted, set LdsBlockSizePerPadA or B = 0 if stride is not power of 2).
- Fixed inaccurate vgpr allocation for ClusterLocalRead.
- Fixed mismatch issue with LdsBlockSizePerPad + MT1(or 0) not power of 2.
- Fixed mismatch issue with InitAccOpt + InnerUnroll (use const 0 for src1 of MFMA only if index of innerUnrll (iui) is 0).
- Fixed HostLibraryTests on gfx942 and gfx941.
- Fixed LLVM crash issue.
- Fixed for newer windows vcpkg msgpack and vcpkg version package name.
- Fixed an error with DisableKernelPieces + 32bit ShadowLimit.
- Ignore asm cap check for kernel arg preload for rocm6.0 and older.

## ROCm 6.1.2

See the [ROCm 6.1.2 release notes](https://rocm.docs.amd.com/en/docs-6.1.2/about/release-notes.html)
for a complete overview of this release.

### **AMD SMI** (24.5.1)

#### Added

* Added process isolation and clean shader APIs and CLI commands.
  * `amdsmi_get_gpu_process_isolation()`
  * `amdsmi_set_gpu_process_isolation()`
  * `amdsmi_set_gpu_clear_sram_data()`
* Added the `MIN_POWER` metric to output provided by `amd-smi static --limit`.

#### Changed

* Updated `amismi_get_power_cap_info` to return values in uW instead of W.
* Updated Python library return types for `amdsmi_get_gpu_memory_reserved_pages` and `amdsmi_get_gpu_bad_page_info`.
* Updated the output of `amd-smi metric --ecc-blocks` to show counters available from blocks.

#### Removed

* Removed the `amdsmi_get_gpu_process_info` API from the Python library. It was removed from the C library in an earlier release.

#### Optimized

* Updated the `amd-smi monitor --pcie` output to prevent delays with the `monitor` command.

#### Resolved issues

* `amdsmi_get_gpu_board_info()` no longer returns junk character strings.
* `amd-smi metric --power` now correctly details power output for RDNA3, RDNA2, and MI1x devices.
* Fixed the `amdsmitstReadWrite.TestPowerCapReadWrite` test for RDNA3, RDNA2, and MI100 devices.
* Fixed an issue with the `amdsmi_get_gpu_memory_reserved_pages` and `amdsmi_get_gpu_bad_page_info` Python interface calls.

> [!NOTE]
> See the AMD SMI [detailed changelog](https://github.com/ROCm/amdsmi/blob/rocm-6.1.x/CHANGELOG.md) with code samples for more information.

### **RCCL** (2.18.6)

#### Changed

* Reduced `NCCL_TOPO_MAX_NODES` to limit stack usage and avoid stack overflow.

### **rocBLAS** (4.1.2)

#### Optimized

* Tuned BBS TN and TT operations on the CDNA3 architecture.

#### Resolved issues

* Fixed an issue related to obtaining solutions for BF16 TT operations.

### **rocDecode** (0.6.0)

#### Added

* Added support for FFmpeg v5.x.

#### Changed

* Updated core dependencies.
* Updated to support the use of public LibVA headers.

#### Optimized

* Updated error checking in the `rocDecode-setup.py` script.

#### Resolved issues

* Fixed some package dependencies.

### **ROCm SMI** (7.2.0)

#### Added

* Added the ring hang event to the `amdsmi_evt_notification_type_t` enum.

#### Resolved issues

* Fixed an issue causing ROCm SMI to incorrectly report GPU utilization for RDNA3 GPUs. See the issue on [GitHub](https://github.com/ROCm/ROCm/issues/3112).
* Fixed the parsing of `pp_od_clk_voltage` in `get_od_clk_volt_info` to work better with MI-Series hardware.

## ROCm 6.1.1

See the [ROCm 6.1.1 release notes](https://rocm.docs.amd.com/en/docs-6.1.1/about/release-notes.html)
for a complete overview of this release.

### **AMD SMI** (24.5.1)

#### Added

- Added deferred error correctable counts to `amd-smi metric -ecc -ecc-blocks`.

#### Changed

- Updated the output of `amd-smi metric --ecc-blocks` to show counters available from blocks.
- Updated the output of `amd-smi metric --clock` to reflect each engine.
- Updated the output of `amd-smi topology --json` to align with output reported by host and guest systems.

#### Removed

- Removed the `amdsmi_get_gpu_process_info` API from the Python library. It was removed from the C library in an earlier release.

#### Resolved issues

- Fixed `amd-smi metric --clock`'s clock lock and deep sleep status.
- Fixed an issue that would cause an error when resetting non-AMD GPUs.
- Fixed `amd-smi metric --pcie` and `amdsmi_get_pcie_info()` when using RDNA3 (Navi 32 and Navi 31) hardware to prevent "UNKNOWN" reports.
- Fixed the output results of `amd-smi process` when getting processes running on a device.

#### Known issues

- `amd-smi bad-pages` can result in a `ValueError: Null pointer access` error when using some PMU firmware versions.

> [!NOTE]
> See the [detailed changelog](https://github.com/ROCm/amdsmi/blob/docs/6.1.1/CHANGELOG.md) with code samples for more information.

### **hipBLASLt** (0.7.0)

#### Added

- Added `hipblasltExtSoftmax` extension API.
- Added `hipblasltExtLayerNorm` extension API.
- Added `hipblasltExtAMax` extension API.
- Added `GemmTuning` extension parameter to set split-k by user.
- Added support for mixed precision datatype: fp16/fp8 in with fp16 outk.

#### Upcoming changes

- `algoGetHeuristic()` ext API for GroupGemm will be deprecated in a future release of hipBLASLt.

### **HIPCC** (1.0.0)

#### Changed

- **Upcoming:** a future release will enable use of compiled binaries `hipcc.bin` and `hipconfig.bin` by default. No action is needed by users. You can continue calling high-level Perl scripts `hipcc` and `hipconfig`. `hipcc.bin` and `hipconfig.bin` will be invoked by the high-level Perl scripts. To revert to the previous behavior and invoke `hipcc.pl` and `hipconfig.pl`, set the `HIP_USE_PERL_SCRIPTS` environment variable to `1`.
- **Upcoming:** a subsequent release will remove high-level Perl scripts `hipcc` and `hipconfig`. This release will remove the `HIP_USE_PERL_SCRIPTS` environment variable. It will rename `hipcc.bin` and `hipconfig.bin` to `hipcc` and `hipconfig` respectively. No action is needed by the users. To revert to the previous behavior, invoke `hipcc.pl` and `hipconfig.pl` explicitly.
- **Upcoming:** a subsequent release will remove `hipcc.pl` and `hipconfig.pl`.

### **hipSOLVER** (2.1.1)

#### Changed

- By default, `BUILD_WITH_SPARSE` is now set to OFF on Microsoft Windows.

#### Resolved issues

- Fixed benchmark client build when `BUILD_WITH_SPARSE` is OFF.

### **rocFFT** (1.0.27)

#### Added

- Enable multi-GPU testing on systems without direct GPU-interconnects.

#### Resolved issues

- Fixed kernel launch failure on execute of very large odd-length real-complex transforms.

### **ROCm SMI** (7.0.0)

#### Added

* Added the capability to unlock mutex when a process is dead. Added related debug output.
* Added the `Partition ID` field to the `rocm-smi` CLI.
* Added `NODE`, `GUID`, and `GFX Version` fields to the CLI.
* Documentation now includes C++ and Python tutorials, API guides, and reference material.

#### Changed

* Some `rocm-smi` fields now display `N/A` instead of `unknown/unsupported` for consistency.
* Changed stacked ID formatting in the `rocm-smi` CLI to make it easier to spot identifiers.

#### Resolved issues

* Fixed HIP and ROCm SMI mismatch on GPU bus assignments.
* Fixed memory leaks caused by not closing directories and creating maps nodes instead of using `.at()`.
* Fixed initializing calls which reuse `rocmsmi.initializeRsmi()` bindings in the `rocmsmi` Python API.
* Fixed an issue causing `rsmi_dev_activity_metric_get` gfx/memory to not update with GPU activity.

#### Known issues

- ROCm SMI reports GPU utilization incorrectly for RDNA3 GPUs in some situations. See the issue on [GitHub](https://github.com/ROCm/ROCm/issues/3112).

> [!NOTE]
> See the [detailed ROCm SMI changelog](https://github.com/ROCm/rocm_smi_lib/blob/docs/6.1.1/CHANGELOG.md) with code samples for more information.

## ROCm 6.1.0

See the [ROCm 6.1.0 release notes](https://rocm.docs.amd.com/en/docs-6.1.0/about/release-notes.html)
for a complete overview of this release.

### **AMD SMI** (24.4.1)

#### Added

* New monitor command for GPU metrics.
  Use the monitor command to customize, capture, collect, and observe GPU metrics on
  target devices.

* Integration with E-SMI.
  The EPYC™ System Management Interface In-band Library is a Linux C-library that provides in-band
  user space software APIs to monitor and control your CPU’s power, energy, performance, and other
  system management functionality. This integration enables access to CPU metrics and telemetry
  through the AMD SMI API and CLI tools.

### **Composable Kernel** (1.1.0)

#### Added

* New architecture support.
  CK now supports to the following architectures to enable efficient image denoising on the following
  AMD GPUs: gfx1030, gfx1100, gfx1031, gfx1101, gfx1032, gfx1102, gfx1034, gfx1103, gfx1035,
  gfx1036

#### Changed

* FP8 rounding logic is replaced with stochastic rounding.
  Stochastic rounding mimics a more realistic data behavior and improves model convergence.

### **HIP** (6.1)

#### Added

* New environment variable to enable kernel run serialization.
  The default `HIP_LAUNCH_BLOCKING` value is `0` (disable); which causes kernels to run as defined in
  the queue. When set to `1` (enable), the HIP runtime serializes the kernel queue, which behaves the
  same as `AMD_SERIALIZE_KERNEL`.

### **hipBLASLt** (0.7.0)

#### Added

* New GemmTuning extension parameter. GemmTuning allows you to set a split-k value for each solution, which is more feasible for
  performance tuning.

### **hipFFT** (1.0.14)

#### Added

* New multi-GPU support for single-process transforms. Multiple GPUs can be used to perform a transform in a single process. Note that this initial
  implementation is a functional preview.

### **HIPIFY** (17.0.0)

#### Changed

* Skipped code blocks: Code blocks that are skipped by the preprocessor are no longer hipified under the
  `--default-preprocessor` option. To hipify everything, despite conditional preprocessor directives
  (`#if`, `#ifdef`, `#ifndef`, `#elif`, or `#else`), don't use the `--default-preprocessor` or `--amap` options.

### **hipSPARSELt** (0.1.0)

#### Added

* Structured sparsity matrix support extensions.
  Structured sparsity matrices help speed up deep-learning workloads. We now support `B` as the
  sparse matrix and `A` as the dense matrix in Sparse Matrix-Matrix Multiplication (SPMM). Prior to this
  release, we only supported sparse (matrix A) x dense (matrix B) matrix multiplication. Structured
  sparsity matrices help speed up deep learning workloads.

### **hipTensor** (1.2.0)

#### Added

* 4D tensor permutation and contraction support.
  You can now perform tensor permutation on 4D tensors and 4D contractions for F16, BF16, and
  Complex F32/F64 datatypes.

### **llvm-project** (17.0.0)

#### Changed

* Combined projects. ROCm Device-Libs, ROCm Compiler Support, and hipCC are now located in
  the `llvm-project/amd` subdirectory of AMD's fork of the LLVM project. Previously, these projects
  were maintained in separate repositories. Note that the projects themselves will continue to be
  packaged separately.

* Split the `rocm-llvm` package. This package has been split into a required and an optional package: 

  * **rocm-llvm(required)**: A package containing the essential binaries needed for compilation.

  * **rocm-llvm-dev(optional)**: A package containing binaries for compiler and application developers.

### **MIGraphX** (2.9.0)

#### Added

* Improved performance for transformer-based models.
  We added support for FlashAttention, which benefits models like BERT, GPT, and Stable Diffusion.

* New Torch-MIGraphX driver.
  This driver calls MIGraphX directly from PyTorch. It provides an `mgx_module` object that you can
  invoke like any other Torch module, but which utilizes the MIGraphX inference engine internally.
  Torch-MIGraphX supports FP32, FP16, and INT8 datatypes.

* FP8 support. We now offer functional support for inference in the FP8E4M3FNUZ datatype. You
  can load an ONNX model in FP8E4M3FNUZ using C++ or Python APIs, or `migraphx-driver`.
  You can quantize a floating point model to FP8 format by using the `--fp8` flag with `migraphx-driver`.
  To accelerate inference, MIGraphX uses hardware acceleration on MI300 for FP8 by leveraging FP8
  support in various backend kernel libraries.

### **MIOpen** (3.1.0)

#### Added

* Improved performance for inference and convolutions.
  Inference support now provided for Find 2.0 fusion plans. Additionally, we've enhanced the Number of
  samples, Height, Width, and Channels (NHWC) convolution kernels for heuristics. NHWC stores data
  in a format where the height and width dimensions come first, followed by channels.

### **OpenMP** (17.60.0)

#### Added

* New MI300 FP atomics. Application performance can now improve by leveraging fast floating-point atomics on MI300 (gfx942).

#### Changed

* Implicit Zero-copy is triggered automatically in XNACK-enabled MI300A systems.
  Implicit Zero-copy behavior in `non unified_shared_memory` programs is triggered automatically in
  XNACK-enabled MI300A systems (for example, when using the `HSA_XNACK=1` environment
  variable). OpenMP supports the 'requires `unified_shared_memory`' directive to support programs
  that don’t want to copy data explicitly between the CPU and GPU. However, this requires that you add
  these directives to every translation unit of the program.

### **RCCL** (2.18.6)

#### Changed

* NCCL 2.18.6 compatibility.
  RCCL is now compatible with NCCL 2.18.6, which includes increasing the maximum IB network interfaces to 32 and fixing network device ordering when creating communicators with only one GPU
  per node.

* Doubled simultaneous communication channels.
  We improved MI300X performance by increasing the maximum number of simultaneous
  communication channels from 32 to 64.

### **rocALUTION** (3.1.1)

#### Added

* New multiple node and GPU support.
  Unsmoothed and smoothed aggregations and Ruge-Stueben AMG now work with multiple nodes
  and GPUs. For more information, refer to the 
  [API documentation](https://rocm.docs.amd.com/projects/rocALUTION/en/docs-6.1.0/usermanual/solvers.html#unsmoothed-aggregation-amg).

### **rocDecode** (0.5.0)

#### Added

* New ROCm component.
  rocDecode ROCm's newest component, providing high-performance video decode support for AMD
  GPUs. To learn more, refer to the 
  [documentation](https://rocm.docs.amd.com/projects/rocDecode/en/latest/).

### **ROCm Data Center Tool** (0.3.0)

#### Changed

* C++ upgrades.
  RDC was upgraded from C++11 to C++17 to enable a more modern C++ standard when writing RDC plugins.

### **RPP** (1.5.0)

#### Added

* New backend support.
  Audio processing support added for the `HOST` backend and 3D Voxel kernels support
  for the `HOST` and `HIP` backends.

### **ROCm Validation Suite** (1.0)

#### Added

* New datatype support.
  Added BF16 and FP8 datatypes based on General Matrix Multiply(GEMM) operations in the GPU Stress Test (GST) module. This provides additional performance benchmarking and stress testing based on the newly supported datatypes.

### **rocSOLVER** (3.25.0)

#### Added

* New EigenSolver routine.
  Based on the Jacobi algorithm, a new EigenSolver routine was added to the library. This routine computes the eigenvalues and eigenvectors of a matrix with improved performance.

### **ROCTracer** (4.1)

#### Changed

* New versioning and callback enhancements.
  Improved to match versioning changes in HIP Runtime and supports runtime API callbacks and activity record logging. The APIs of different runtimes at different levels are considered different API domains with assigned domain IDs.

## ROCm 6.0.2

See the [ROCm 6.0.2 release notes](https://rocm.docs.amd.com/en/docs-6.0.2/about/release-notes.html)
for a complete overview of this release.

### **hipFFT** (1.0.13)

#### Changed

* Removed the Git submodule for shared files between rocFFT and hipFFT; instead, just copy the files
 over (this should help simplify downstream builds and packaging)

## ROCm 6.0.0

See the [ROCm 6.0.0 release notes](https://rocm.docs.amd.com/en/docs-6.0.0/about/release-notes.html)
for a complete overview of this release.

### **AMD SMI** (23.4.2)

#### Added

* Integrated the E-SMI (EPYC-SMI) library.
  You can now query CPU-related information directly through AMD SMI. Metrics include power,
  energy, performance, and other system details.

* Added support for gfx942 metrics.
  You can now query MI300 device metrics to get real-time information. Metrics include power,
  temperature, energy, and performance.

### **HIP** (6.0.0)

#### Added

* New features to improve resource interoperability.
  * For external resource interoperability, we've added new structs and enums.
  * We've added new members to HIP struct `hipDeviceProp_t` for surfaces, textures, and device
    identifiers.

#### Changed

* Changes impacting backward compatibility.
  There are several changes impacting backward compatibility: we changed some struct members and
  some enum values, and removed some deprecated flags. For additional information, please refer to
  the Changelog.

### **hipCUB** (3.0.0)

#### Changed

* Additional CUB API support.
  The hipCUB backend is updated to CUB and Thrust 2.1.

### **HIPIFY** (17.0.0)

#### Added

* Hipified rocSPARSE.
  We've implemented support for the direct hipification of additional cuSPARSE APIs into rocSPARSE
  APIs under the `--roc` option. This covers a major milestone in the roadmap towards complete
  cuSPARSE-to-rocSPARSE hipification.

#### Optimized

* Enhanced CUDA2HIP document generation.
  API versions are now listed in the CUDA2HIP documentation. To see if the application binary
  interface (ABI) has changed, refer to the
  [*C* column](https://rocm.docs.amd.com/projects/HIPIFY/en/latest/tables/CUDA_Runtime_API_functions_supported_by_HIP.html)
  in our API documentation.

### **hipRAND** (2.10.16)

* Official release.
  hipRAND is now a *standalone project*--it's no longer available as a submodule for rocRAND.

### **hipTensor** (1.1.0)

#### Added

* Added architecture support.
  We've added contraction support for gfx942 architectures, and f32 and f64 data
  types.

#### Optimized

* Upgraded testing infrastructure.
  hipTensor will now support dynamic parameter configuration with input YAML config.

### **llvm-project** (17.0.0)

#### Added

* Added kernel argument optimization on gfx942.
  With the new feature, you can preload kernel arguments into Scalar General-Purpose Registers
  (SGPRs) rather than pass them in memory. This feature is enabled with a compiler option, which also
  controls the number of arguments to pass in SGPRs. For more information, see:
  [https://llvm.org/docs/AMDGPUUsage.html#preloaded-kernel-arguments](https://llvm.org/docs/AMDGPUUsage.html#preloaded-kernel-arguments)

#### Optimized

* Improved register allocation at -O0.
  We've improved the register allocator used at -O0 to avoid compiler crashes (when the signature is
  'ran out of registers during register allocation').

* Improved generation of debug information.
  We've improved compile time when generating debug information for certain corner cases. We've
  also improved the compiler to eliminate compiler crashes when generating debug information.

### **MIGraphX** (2.8.0)

#### Added

* Added TorchMIGraphX.
  We introduced a Dynamo backend for Torch, which allows PyTorch to use MIGraphX directly
  without first requiring a model to be converted to the ONNX model format. With a single line of
  code, PyTorch users can utilize the performance and quantization benefits provided by MIGraphX.

* Added INT8 support across the MIGraphX portfolio.
  We now support the INT8 data type. MIGraphX can perform the quantization or ingest
  prequantized models. INT8 support extends to the MIGraphX execution provider for ONNX Runtime.

* Boosted overall performance with rocMLIR.
  We've integrated the rocMLIR library for ROCm-supported RDNA and CDNA GPUs. This
  technology provides MLIR-based convolution and GEMM kernel generation.

### **ROCgdb** (13.2)

#### Added

* Added support for additional GPU architectures.
  * Navi 3 Series: gfx1100, gfx1101, and gfx1102.
  * MI300 Series: gfx942.

### **ROCm SMI** (6.0.0)

#### Added

* Improved accessibility to GPU partition nodes.
  You can now view, set, and reset the compute and memory partitions. You'll also get notifications of
  a GPU busy state, which helps you avoid partition set or reset failure.

#### Optimized

* Upgraded GPU metrics version 1.4.
  The upgraded GPU metrics binary has an improved metric version format with a content version
  appended to it. You can read each metric within the binary without the full `rsmi_gpu_metric_t` data
  structure.

* Updated GPU index sorting.
  We made GPU index sorting consistent with other ROCm software tools by optimizing it to use
  `Bus:Device.Function` (BDF) instead of the card number.

### **ROCm Validation Suite** (1.0)

#### Added

* Added GPU and operating system support.
  We added support for MI300X GPU in GPU Stress Test (GST).

### **ROCProfiler** (2.0)

#### Added

* Added option to specify desired ROCProfiler version.
  You can now use rocProfV1 or rocProfV2 by specifying your desired version, as the legacy rocProf
  (`rocprofv1`) provides the option to use the latest version (`rocprofv2`).

* Added ATT support for parallel kernels.
  The automatic ISA dumping process also helps ATT successfully parse multiple kernels running in
  parallel, and provide cycle-accurate occupancy information for multiple kernels at the same time.

#### Changed

* Automated the ISA dumping process by Advance Thread Tracer.
  Advance Thread Tracer (ATT) no longer depends on user-supplied Instruction Set Architecture (ISA)
  and compilation process (using ``hipcc --save-temps``) to dump ISA from the running kernels.

### **ROCr Runtime** (1.12.0)

#### Added

* Support for SDMA link aggregation.
  If multiple XGMI links are available when making SDMA copies between GPUs, the copy is
  distributed over multiple links to increase peak bandwidth.

### **rocThrust** (3.0.0)

#### Added

* Added Thrust 2.1 API support.
  rocThrust backend is updated to Thrust and CUB 2.1.

### **rocWMMA** (1.3.0)

#### Added

* **Added new architecture support**.
    We added support for gfx942 architectures.

* **Added data type support**.
    We added support for f8, bf8, xf32 data types on supporting architectures, and for bf16 in the HIP RTC
    environment.

* **Added support for the PyTorch kernel plugin**.
    We added awareness of `__HIP_NO_HALF_CONVERSIONS__` to support PyTorch users.

### **TransferBench** (beta)

#### Optimized

* Improved ordering control.
  You can now set the thread block size (`BLOCK_SIZE`) and the thread block order (`BLOCK_ORDER`)
  in which thread blocks from different transfers are run when using a single stream.

* Added comprehensive reports.
  We modified individual transfers to report X Compute Clusters (XCC) ID when `SHOW_ITERATIONS`
  is set to 1.

* Improved accuracy in result validation.
  You can now validate results for each iteration instead of just once for all iterations.

## ROCm 5.7.1

See the [ROCm 5.7.1 release notes](https://github.com/ROCm/ROCm/blob/docs/5.7.1/RELEASE.md)
on GitHub for a complete overview of this release.

### **HIP** (5.7.1)

#### Resolved issues

* The *hipPointerGetAttributes* API returns the correct HIP memory type as *hipMemoryTypeManaged* for managed memory.

### **hipSOLVER** (1.8.2)

#### Resolved issues

- Fixed conflicts between the hipsolver-dev and -asan packages by excluding
  hipsolver_module.f90 from the latter

### **rocBLAS** (3.1.0)

#### Added

* A new functionality `rocblas-gemm-tune` and an environment variable `ROCBLAS_TENSILE_GEMM_OVERRIDE_PATH`.
  For more details, refer to the [rocBLAS Programmer's Guide.](https://rocm.docs.amd.com/projects/rocBLAS/en/latest/Programmers_Guide.html#rocblas-gemm-tune)

## ROCm 5.7.0

See the [ROCm 5.7.0 release notes](https://github.com/ROCm/ROCm/blob/docs/5.7.0/RELEASE.md)
on GitHub for a complete overview of this release.

### **HIP** (5.7.0)

#### Added

- Added `meta_group_size`/`rank` for getting the number of tiles and rank of a tile in the partition

- Added new APIs supporting Windows only, under development on Linux

    - `hipMallocMipmappedArray` for allocating a mipmapped array on the device

    - `hipFreeMipmappedArray` for freeing a mipmapped array on the device

    - `hipGetMipmappedArrayLevel` for getting a mipmap level of a HIP mipmapped array

    - `hipMipmappedArrayCreate` for creating a mipmapped array

    - `hipMipmappedArrayDestroy` for destroy a mipmapped array

    - `hipMipmappedArrayGetLevel` for getting a mipmapped array on a mipmapped level

#### Known issues

- HIP memory type enum values currently don't support equivalent value to `cudaMemoryTypeUnregistered`, due to HIP functionality backward compatibility.
- HIP API `hipPointerGetAttributes` could return invalid value in case the input memory pointer was not allocated through any HIP API on device or host.

#### Upcoming changes

- Removal of gcnarch from hipDeviceProp_t structure

- Addition of new fields in hipDeviceProp_t structure

    - maxTexture1D

    - maxTexture2D

    - maxTexture1DLayered

    - maxTexture2DLayered
    
    - sharedMemPerMultiprocessor
    
    - deviceOverlap
    
    - asyncEngineCount
    
    - surfaceAlignment
    
    - unifiedAddressing
    
    - computePreemptionSupported
    
    - hostRegisterSupported
    
    - uuid
    
- Removal of deprecated code -hip-hcc codes from hip code tree

- Correct hipArray usage in HIP APIs such as hipMemcpyAtoH and hipMemcpyHtoA

- HIPMEMCPY_3D fields correction to avoid truncation of "size_t" to "unsigned int" inside hipMemcpy3D()

- Renaming of 'memoryType' in hipPointerAttribute_t structure to 'type'

- Correct hipGetLastError to return the last error instead of last API call's return code

- Update hipExternalSemaphoreHandleDesc to add "unsigned int reserved[16]"

- Correct handling of flag values in hipIpcOpenMemHandle for hipIpcMemLazyEnablePeerAccess

- Remove hiparray* and make it opaque with hipArray_t

### **hipBLAS** (1.1.0)

#### Changed

- updated documentation requirements
- dependency rocSOLVER now depends on rocSPARSE

### **hipCUB** (2.13.1)

#### Changed

- CUB backend references CUB and Thrust version 2.0.1.
- Fixed `DeviceSegmentedReduce::ArgMin` and `DeviceSegmentedReduce::ArgMax` by returning the segment-relative index instead of the absolute one.
- Fixed `DeviceSegmentedReduce::ArgMin` for inputs where the segment minimum is smaller than the value returned for empty segments. An equivalent fix is applied to `DeviceSegmentedReduce::ArgMax`.

#### Known issues

- `debug_synchronous` no longer works on CUDA platform. `CUB_DEBUG_SYNC` should be used to enable those checks.
- `DeviceReduce::Sum` does not compile on CUDA platform for mixed extended-floating-point/floating-point InputT and OutputT types.
- `DeviceHistogram::HistogramEven` fails on CUDA platform for `[LevelT, SampleIteratorT] = [int, int]`.
- `DeviceHistogram::MultiHistogramEven` fails on CUDA platform for `[LevelT, SampleIteratorT] = [int, int/unsigned short/float/double]` and `[LevelT, SampleIteratorT] = [float, double]`.

### **hipFFT** (1.0.12)

#### Added

- Implemented the hipfftXtMakePlanMany, hipfftXtGetSizeMany, hipfftXtExec APIs, to allow requesting half-precision transforms.

#### Changed

- Added --precision argument to benchmark/test clients.  --double is still accepted but is deprecated as a method to request a double-precision transform.

### **hipSOLVER** (1.8.1)

#### Changed

- Changed hipsolver-test sparse input data search paths to be relative to the test executable

### **hipSPARSE** (2.3.8)

#### Optimized

- Fix compilation failures when using cusparse 12.1.0 backend
- Fix compilation failures when using cusparse 12.0.0 backend
- Fix compilation failures when using cusparse 10.1 (non-update versions) as backend
- Minor improvements

### **MIOpen** (2.19.0)

#### Added

- ROCm 5.5 support for gfx1101 (Navi32)

#### Changed

- Tuning results for MLIR on ROCm 5.5
- Bumping MLIR commit to 5.5.0 release tag

#### Resolved issues

- Fix 3d convolution Host API bug
- [HOTFIX][MI200][FP16] Disabled ConvHipImplicitGemmBwdXdlops when FP16_ALT is required.

### **RCCL** (2.17.1-1)

#### Added

- Minor improvements to MSCCL codepath
- NCCL_NCHANNELS_PER_PEER support
- Improved compilation performance
- Support for gfx94x

#### Changed

- Compatibility with NCCL 2.17.1-1
- Performance tuning for some collective operations

#### Resolved issues

- Potential race-condition during ncclSocketClose()

### **rocALUTION** (2.1.11)

#### Added

- Added support for gfx940, gfx941 and gfx942

#### Optimized

- Fixed OpenMP runtime issue with Windows toolchain

### **rocBLAS** (3.1.0)

#### Added

- yaml lock step argument scanning for rocblas-bench and rocblas-test clients. See Programmers Guide for details.
- rocblas-gemm-tune is used to find the best performing GEMM kernel for each of a given set of GEMM problems.

#### Changed

- dot when using rocblas_pointer_mode_host is now synchronous to match legacy BLAS as it stores results in host memory
- enhanced reporting of installation issues caused by runtime libraries (Tensile)
- standardized internal rocblas C++ interface across most functions
- Dependencies:
  - optional use of AOCL BLIS 4.0 on Linux for clients
  - optional build tool only dependency on python psutil

#### Resolved issues

- make offset calculations for rocBLAS functions 64 bit safe.  Fixes for very large leading dimensions or increments potentially causing overflow:
  - Level 1: axpy, copy, rot, rotm, scal, swap, asum, dot, iamax, iamin, nrm2
  - Level 2: gemv, symv, hemv, trmv, ger, syr, her, syr2, her2, trsv
  - Level 3: gemm, symm, hemm, trmm, syrk, herk, syr2k, her2k, syrkx, herkx, trsm, trtri, dgmm, geam
  - General: set_vector, get_vector, set_matrix, get_matrix
  - Related fixes: internal scalar loads with &gt; 32bit offsets
  - fix in-place functionality for all trtri sizes

#### Upcoming changes

- Removal of __STDC_WANT_IEC_60559_TYPES_EXT__ define in future release

### **rocFFT** (1.0.24)

#### Added

- Implemented a solution map version converter and finish the first conversion from ver.0 to ver.1. Where version 1 removes some incorrect kernels (sbrc/sbcr using half_lds)

#### Changed

- Moved rocfft_rtc_helper executable to lib/rocFFT directory on Linux.
- Moved library kernel cache to lib/rocFFT directory.

#### Optimized

- Improved performance of complex forward/inverse 1D FFTs (2049 &lt;= length &lt;= 131071) that use Bluestein&#39;s algorithm.

### **rocm-cmake** (0.10.0)

#### Added

- Added ROCMTest module
- ROCMCreatePackage: Added support for ASAN packages

### **rocPRIM** (2.13.1)

#### Changed

- Deprecated configuration `radix_sort_config` for device-level radix sort as it no longer matches the algorithm&#39;s parameters. New configuration `radix_sort_config_v2` is preferred instead.
- Removed erroneous implementation of device-level `inclusive_scan` and `exclusive_scan`. The prior default implementation using lookback-scan now is the only available implementation.
- The benchmark metric indicating the bytes processed for `exclusive_scan_by_key` and `inclusive_scan_by_key` has been changed to incorporate the key type. Furthermore, the benchmark log has been changed such that these algorithms are reported as `scan` and `scan_by_key` instead of `scan_exclusive` and `scan_inclusive`.
- Deprecated configurations `scan_config` and `scan_by_key_config` for device-level scans, as they no longer match the algorithm&#39;s parameters. New configurations `scan_config_v2` and `scan_by_key_config_v2` are preferred instead.

#### Resolved issues

- Fixed build issue caused by missing header in `thread/thread_search.hpp`.

### **rocRAND** (2.10.17)

#### Added

- MT19937 pseudo random number generator based on M. Matsumoto and T. Nishimura, 1998, Mersenne Twister: A 623-dimensionally equidistributed uniform pseudorandom number generator.
- New benchmark for the device API using Google Benchmark, `benchmark_rocrand_device_api`, replacing `benchmark_rocrand_kernel`. `benchmark_rocrand_kernel` is deprecated and will be removed in a future version. Likewise, `benchmark_curand_host_api` is added to replace `benchmark_curand_generate` and `benchmark_curand_device_api` is added to replace `benchmark_curand_kernel`.
- experimental HIP-CPU feature
- ThreeFry pseudorandom number generator based on Salmon et al., 2011, &#34;Parallel random numbers: as easy as 1, 2, 3&#34;.

#### Changed

- Python 2.7 is no longer officially supported.

### **rocSOLVER** (3.23.0)

#### Added

- LU factorization without pivoting for block tridiagonal matrices:
    - GEBLTTRF_NPVT now supports interleaved\_batched format
- Linear system solver without pivoting for block tridiagonal matrices:
    - GEBLTTRS_NPVT now supports interleaved\_batched format

#### Changed

- Changed rocsolver-test sparse input data search paths to be relative to the test executable
- Changed build scripts to default to compressed debug symbols in Debug builds

#### Resolved issues

- Fixed stack overflow in sparse tests on Windows

### **rocSPARSE** (2.5.4)

#### Added

- Added more mixed precisions for SpMV, (matrix: float, vectors: double, calculation: double) and (matrix: rocsparse_float_complex, vectors: rocsparse_double_complex, calculation: rocsparse_double_complex)
- Added support for gfx940, gfx941 and gfx942

#### Optimized

- Fixed a bug in csrsm and bsrsm

#### Known issues

In csritlu0, the algorithm rocsparse_itilu0_alg_sync_split_fusion has some accuracy issues to investigate with XNACK enabled. The fallback is rocsparse_itilu0_alg_sync_split.

### **rocThrust** (2.18.0)

#### Changed

- Updated `docs` directory structure to match the standard of [rocm-docs-core](https://github.com/RadeonOpenCompute/rocm-docs-core).
- Removed references to and workarounds for deprecated hcc

#### Resolved issues

- `lower_bound`, `upper_bound`, and `binary_search` failed to compile for certain types.
- Fixed issue where `transform_iterator` would not compile with `__device__`-only operators.

### **rocWMMA** (1.2.0)

#### Changed

- Fixed a bug with synchronization
- Updated rocWMMA cmake versioning

### **Tensile** (4.38.0)

#### Added

- Added support for FP16 Alt Round Near Zero Mode (this feature allows the generation of alternate kernels with intermediate rounding instead of truncation)
- Added user-driven solution selection feature

#### Changed

- Removed DGEMM NT custom kernels and related test cases
- Changed noTailLoop logic to apply noTailLoop only for NT
- Changed the range of AssertFree0ElementMultiple and Free1
- Unified aStr, bStr generation code in mfmaIter

#### Optimized

- Enabled LocalSplitU with MFMA for I8 data type
- Optimized K mask code in mfmaIter
- Enabled TailLoop code in NoLoadLoop to prefetch global/local read
- Enabled DirectToVgpr in TailLoop for NN, TN, and TT matrix orientations
- Optimized DirectToLds test cases to reduce the test duration

#### Resolved issues

- Fixed LocalSplitU mismatch issue for SGEMM
- Fixed BufferStore=0 and Ldc != Ldd case
- Fixed mismatch issue with TailLoop + MatrixInstB > 1

## ROCm 5.6.1

See the [ROCm 5.6.1 release notes](https://github.com/ROCm/ROCm/blob/docs/5.6.1/RELEASE.md)
on GitHub for a complete overview of this release.

### **HIP** (5.6.1)

#### Resolved issues

- *hipMemcpy* device-to-device (intra device) is now asynchronous with respect to the host
- Enabled xnack+ check in HIP catch2 tests hang when executing tests
- Memory leak when code object files are loaded/unloaded via hipModuleLoad/hipModuleUnload APIs
- Using *hipGraphAddMemFreeNode* no longer results in a crash

## ROCm 5.6.0

See the [ROCm 5.6.0 release notes](https://github.com/ROCm/ROCm/blob/docs/5.6.0/RELEASE.md)
on GitHub for a complete overview of this release.

### **AMD SMI** (1.0.0)

#### Added

- AMDSMI CLI tool enabled for Linux Bare Metal & Guest

- Package: amd-smi-lib
 
#### Known issues

- not all Error Correction Code (ECC) fields are currently supported

- RHEL 8 & SLES 15 have extra install steps

### **HIP** (5.6.0)

#### Added

- Added hipRTC support for amd_hip_fp16
- Added hipStreamGetDevice implementation to get the device associated with the stream
- Added HIP_AD_FORMAT_SIGNED_INT16 in hipArray formats
- hipArrayGetInfo for getting information about the specified array
- hipArrayGetDescriptor for getting 1D or 2D array descriptor
- hipArray3DGetDescriptor to get 3D array descriptor

#### Changed

- hipMallocAsync to return success for zero size allocation to match hipMalloc
- Separation of hipcc perl binaries from HIP project to hipcc project. hip-devel package depends on newly added hipcc package
- Consolidation of hipamd, ROCclr, and OpenCL repositories into a single repository called clr. Instructions are updated to build HIP from sources in the HIP Installation guide
- Removed hipBusBandwidth and hipCommander samples from hip-tests

#### Optimized

- Consolidation of hipamd, rocclr and OpenCL projects in clr
- Optimized lock for graph global capture mode

#### Resolved issues

- Fixed regression in hipMemCpyParam3D when offset is applied

#### Known issues

- Limited testing on xnack+ configuration
  - Multiple HIP tests failures (gpuvm fault or hangs)
- hipSetDevice and hipSetDeviceFlags APIs return hipErrorInvalidDevice instead of hipErrorNoDevice, on a system without GPU
- Known memory leak when code object files are loaded/unloaded via hipModuleLoad/hipModuleUnload APIs. Issue will be fixed in a future ROCm release

#### Upcoming changes

- Removal of gcnarch from hipDeviceProp_t structure
- Addition of new fields in hipDeviceProp_t structure
  - maxTexture1D
  - maxTexture2D
  - maxTexture1DLayered
  - maxTexture2DLayered
  - sharedMemPerMultiprocessor
  - deviceOverlap
  - asyncEngineCount
  - surfaceAlignment
  - unifiedAddressing
  - computePreemptionSupported
  - uuid
- Removal of deprecated code
  - hip-hcc codes from hip code tree
- Correct hipArray usage in HIP APIs such as hipMemcpyAtoH and hipMemcpyHtoA
- HIPMEMCPY_3D fields correction (unsigned int -> size_t)
- Renaming of 'memoryType' in hipPointerAttribute_t structure to 'type'

### **ROCgdb** (13.1)

#### Optimized

- Improved performances when handling the end of a process with a large number of threads.

#### Known issues

- On certain configurations, ROCgdb can show the following warning message:

  `warning: Probes-based dynamic linker interface failed. Reverting to original interface.`

  This does not affect ROCgdb's functionalities.

### **hipBLAS** (1.0.0)

#### Changed

- added const qualifier to hipBLAS functions (swap, sbmv, spmv, symv, trsm) where missing

#### Removed

- removed support for deprecated hipblasInt8Datatype_t enum
- removed support for deprecated hipblasSetInt8Datatype and hipblasGetInt8Datatype functions
- in-place trmm is deprecated. It will be replaced by trmm which includes both in-place and
  out-of-place functionality

### **hipCUB** (2.13.1)

#### Added

- Benchmarks for `BlockShuffle`, `BlockLoad`, and `BlockStore`.

#### Changed

- CUB backend references CUB and Thrust version 1.17.2.
- Improved benchmark coverage of `BlockScan` by adding `ExclusiveScan`, benchmark coverage of `BlockRadixSort` by adding `SortBlockedToStriped`, and benchmark coverage of `WarpScan` by adding `Broadcast`.
- Updated `docs` directory structure to match the standard of [rocm-docs-core](https://github.com/RadeonOpenCompute/rocm-docs-core).

#### Known issues

- `BlockRadixRankMatch` is currently broken under the rocPRIM backend.
- `BlockRadixRankMatch` with a warp size that does not exactly divide the block size is broken under the CUB backend.

### **hipFFT** (1.0.12)

#### Added

- Implemented the hipfftXtMakePlanMany, hipfftXtGetSizeMany, hipfftXtExec APIs, to allow requesting half-precision transforms.

#### Changed

- Added --precision argument to benchmark/test clients.  --double is still accepted but is deprecated as a method to request a double-precision transform.

### **hipSOLVER** (1.8.0)

#### Added

- Added compatibility API with hipsolverRf prefix

### **hipSPARSE** (2.3.6)

#### Added

- Added SpGEMM algorithms

#### Changed

- For hipsparseXbsr2csr and hipsparseXcsr2bsr, blockDim == 0 now returns HIPSPARSE_STATUS_INVALID_SIZE

### **MIOpen** (2.19.0)

#### Added

- ROCm 5.5 support for gfx1101 (Navi32)

#### Changed

- Tuning results for MLIR on ROCm 5.5
- Bumping MLIR commit to 5.5.0 release tag

#### Resolved issues

- Fix 3d convolution Host API bug
- [HOTFIX][MI200][FP16] Disabled ConvHipImplicitGemmBwdXdlops when FP16_ALT is required.

### **RCCL** (2.15.5)

#### Added

- HW-topology aware binary tree implementation
- Experimental support for MSCCL
- New unit tests for hipGraph support
- NPKit integration

#### Changed

- Compatibility with NCCL 2.15.5
- Unit test executable renamed to rccl-UnitTests

#### Removed

- Removed TransferBench from tools.  Exists in standalone repo: https://github.com/ROCmSoftwarePlatform/TransferBench

#### Resolved issues

- rocm-smi ID conversion
- Support for HIP_VISIBLE_DEVICES for unit tests
- Support for p2p transfers to non (HIP) visible devices

### **rocALUTION** (2.1.9)

#### Optimized

- Fixed synchronization issues in level 1 routines

### **rocBLAS** (3.0.0)

#### Added

- Added bf16 inputs and f32 compute support to Level 1 rocBLAS Extension functions axpy_ex, scal_ex and nrm2_ex.

#### Changed

- refactor rotg test code
- Dependencies:
  - build only dependency on python joblib added as used by Tensile build
  - fix for cmake install on some OS when performed by install.sh -d --cmake_install

#### Removed

- is_complex helper was deprecated and now removed.  Use rocblas_is_complex instead.
- The enum truncate_t and the value truncate was deprecated and now removed from. It was replaced by rocblas_truncate_t and rocblas_truncate, respectively.
- rocblas_set_int8_type_for_hipblas was deprecated and is now removed.
- rocblas_get_int8_type_for_hipblas was deprecated and is now removed.
- trmm inplace is deprecated. It will be replaced by trmm that has both inplace and out-of-place functionality
- rocblas_query_int8_layout_flag() is deprecated and will be removed in a future release
- rocblas_gemm_flags_pack_int8x4 enum is deprecated and will be removed in a future release
- rocblas_set_device_memory_size() is deprecated and will be replaced by a future function rocblas_increase_device_memory_size()
- rocblas_is_user_managing_device_memory() is deprecated and will be removed in a future release

#### Optimized

- Improved performance of Level 2 rocBLAS GEMV on gfx90a GPU for non-transposed problems having small matrices and larger batch counts. Performance enhanced for problem sizes when m and n &lt;= 32 and batch_count &gt;= 256.
- Improved performance of rocBLAS syr2k for single, double, and double-complex precision, and her2k for double-complex precision. Slightly improved performance for general sizes on gfx90a.

#### Resolved issues

- make trsm offset calculations 64 bit safe

### **rocFFT** (1.0.23)

#### Added

- Implemented half-precision transforms, which can be requested by passing rocfft_precision_half to rocfft_plan_create.
- Implemented a hierarchical solution map which saves how to decompose a problem and the kernels to be used.
- Implemented a first version of offline-tuner to support tuning kernels for C2C/Z2Z problems.

#### Changed

- Replaced std::complex with hipComplex data types for data generator.
- FFT plan dimensions are now sorted to be row-major internally where possible, which produces better plans if the dimensions were accidentally specified in a different order (column-major, for example).
- Added --precision argument to benchmark/test clients.  --double is still accepted but is deprecated as a method to request a double-precision transform.

#### Resolved issues

- Fixed over-allocation of LDS in some real-complex kernels, which was resulting in kernel launch failure.

### **rocm-cmake** (0.9.0)

#### Added

- Added the option ROCM_HEADER_WRAPPER_WERROR
    - Compile-time C macro in the wrapper headers causes errors to be emitted instead of warnings.
    - Configure-time CMake option sets the default for the C macro.

### **rocPRIM** (2.13.0)

#### Added

- New block level `radix_rank` primitive.
- New block level `radix_rank_match` primitive.
- Added a stable block sorting implementation. This be used with `block_sort` by using the `block_sort_algorithm::stable_merge_sort` algorithm.

#### Changed

- Improved the performance of `block_radix_sort` and `device_radix_sort`.
- Improved the performance of `device_merge_sort`.
- Updated `docs` directory structure to match the standard of [rocm-docs-core](https://github.com/RadeonOpenCompute/rocm-docs-core). Contributed by: [v01dXYZ](https://github.com/v01dXYZ).

#### Known issues

- Disabled GPU error messages relating to incorrect warp operation usage with Navi GPUs on Windows, due to GPU printf performance issues on Windows.
- When `ROCPRIM_DISABLE_LOOKBACK_SCAN` is set, `device_scan` fails for input sizes bigger than `scan_config::size_limit`, which defaults to `std::numeric_limits&lt;unsigned int&gt;::max()`.

### **ROCprofiler**

In ROCm 5.6 the `rocprofilerv1` and `rocprofilerv2` include and library files of
ROCm 5.5 are split into separate files. The `rocmtools` files that were
deprecated in ROCm 5.5 have been removed.

  | ROCm 5.6        | rocprofilerv1                       | rocprofilerv2                          |
  |-----------------|-------------------------------------|----------------------------------------|
  | **Tool script** | `bin/rocprof`                       | `bin/rocprofv2`                        |
  | **API include** | `include/rocprofiler/rocprofiler.h` | `include/rocprofiler/v2/rocprofiler.h` |
  | **API library** | `lib/librocprofiler.so.1`           | `lib/librocprofiler.so.2`              |

The ROCm Profiler Tool that uses `rocprofilerV1` can be invoked using the
following command:

```sh
$ rocprof …
```

To write a custom tool based on the `rocprofilerV1` API do the following:

```C
main.c:
#include <rocprofiler/rocprofiler.h> // Use the rocprofilerV1 API
int main() {
  // Use the rocprofilerV1 API
  return 0;
}
```

This can be built in the following manner:

```sh
$ gcc main.c -I/opt/rocm-5.6.0/include -L/opt/rocm-5.6.0/lib -lrocprofiler64
```

The resulting `a.out` will depend on
`/opt/rocm-5.6.0/lib/librocprofiler64.so.1`.

The ROCm Profiler that uses `rocprofilerV2` API can be invoked using the
following command:

```sh
$ rocprofv2 …
```

To write a custom tool based on the `rocprofilerV2` API do the following:

```C
main.c:
#include <rocprofiler/v2/rocprofiler.h> // Use the rocprofilerV2 API
int main() {
  // Use the rocprofilerV2 API
  return 0;
}
```

This can be built in the following manner:

```sh
$ gcc main.c -I/opt/rocm-5.6.0/include -L/opt/rocm-5.6.0/lib -lrocprofiler64-v2
```

The resulting `a.out` will depend on
`/opt/rocm-5.6.0/lib/librocprofiler64.so.2`.

#### Added

- 'end_time' need to be disabled in roctx_trace.txt

#### Optimized

- Improved Test Suite

#### Resolved issues

- rocprof in ROcm/5.4.0 gpu selector broken.
- rocprof in ROCm/5.4.1 fails to generate kernel info.
- rocprof clobbers LD_PRELOAD.

### **rocRAND** (2.10.17)

#### Added

- MT19937 pseudo random number generator based on M. Matsumoto and T. Nishimura, 1998, Mersenne Twister: A 623-dimensionally equidistributed uniform pseudorandom number generator.
- New benchmark for the device API using Google Benchmark, `benchmark_rocrand_device_api`, replacing `benchmark_rocrand_kernel`. `benchmark_rocrand_kernel` is deprecated and will be removed in a future version. Likewise, `benchmark_curand_host_api` is added to replace `benchmark_curand_generate` and `benchmark_curand_device_api` is added to replace `benchmark_curand_kernel`.
- experimental HIP-CPU feature
- ThreeFry pseudorandom number generator based on Salmon et al., 2011, &#34;Parallel random numbers: as easy as 1, 2, 3&#34;.

#### Changed

- Python 2.7 is no longer officially supported.

### **rocSOLVER** (3.22.0)

#### Added

- LU refactorization for sparse matrices
    - CSRRF_ANALYSIS
    - CSRRF_SUMLU
    - CSRRF_SPLITLU
    - CSRRF_REFACTLU
- Linear system solver for sparse matrices
    - CSRRF_SOLVE
- Added type `rocsolver_rfinfo` for use with sparse matrix routines

#### Optimized

- Improved the performance of BDSQR and GESVD when singular vectors are requested

#### Resolved issues

- BDSQR and GESVD should no longer hang when the input contains `NaN` or `Inf`

### **rocSPARSE** (2.5.2)

#### Optimized

- Fixed a memory leak in csritsv
- Fixed a bug in csrsm and bsrsm

### **rocThrust** (2.18.0)

#### Changed

- Updated `docs` directory structure to match the standard of [rocm-docs-core](https://github.com/RadeonOpenCompute/rocm-docs-core).

#### Resolved issues

- `lower_bound`, `upper_bound`, and `binary_search` failed to compile for certain types.

### **rocWMMA** (1.1.0)

#### Added

- Added cross-lane operation backends (Blend, Permute, Swizzle and Dpp)
- Added GPU kernels for rocWMMA unit test pre-process and post-process operations (fill, validation)
- Added performance gemm samples for half, single and double precision
- Added rocWMMA cmake versioning
- Added vectorized support in coordinate transforms
- Included ROCm smi for runtime clock rate detection
- Added fragment transforms for transpose and change data layout

#### Changed

- Default to GPU rocBLAS validation against rocWMMA
- Re-enabled int8 gemm tests on gfx9
- Upgraded to C++17
- Restructured unit test folder for consistency
- Consolidated rocWMMA samples common code

### **Tensile** (4.37.0)

#### Added

- Added user driven tuning API
- Added decision tree fallback feature
- Added SingleBuffer + AtomicAdd option for GlobalSplitU
- DirectToVgpr support for fp16 and Int8 with TN orientation
- Added new test cases for various functions
- Added SingleBuffer algorithm for ZGEMM/CGEMM
- Added joblib for parallel map calls
- Added support for MFMA + LocalSplitU + DirectToVgprA+B
- Added asmcap check for MIArchVgpr
- Added support for MFMA + LocalSplitU
- Added frequency, power, and temperature data to the output

#### Changed

- Updated custom kernels with 64-bit offsets
- Adapted 64-bit offset arguments for assembly kernels
- Improved temporary register re-use to reduce max sgpr usage
- Removed some restrictions on VectorWidth and DirectToVgpr
- Updated the dependency requirements for Tensile
- Changed the range of AssertSummationElementMultiple
- Modified the error messages for more clarity
- Changed DivideAndReminder to vectorStaticRemainder in case quotient is not used
- Removed dummy vgpr for vectorStaticRemainder
- Removed tmpVgpr parameter from vectorStaticRemainder/Divide/DivideAndReminder
- Removed qReg parameter from vectorStaticRemainder

#### Optimized

- Improved the performance of GlobalSplitU with SingleBuffer algorithm
- Reduced the running time of the extended and pre_checkin tests
- Optimized the Tailloop section of the assembly kernel
- Optimized complex GEMM (fixed vgpr allocation, unified CGEMM and ZGEMM code in MulMIoutAlphaToArch)
- Improved the performance of the second kernel of MultipleBuffer algorithm

#### Resolved issues

- Fixed tmp sgpr allocation to avoid over-writing values (alpha)
- 64-bit offset parameters for post kernels
- Fixed gfx908 CI test failures
- Fixed offset calculation to prevent overflow for large offsets
- Fixed issues when BufferLoad and BufferStore are equal to zero
- Fixed StoreCInUnroll + DirectToVgpr + no useInitAccVgprOpt mismatch
- Fixed DirectToVgpr + LocalSplitU + FractionalLoad mismatch
- Fixed the memory access error related to StaggerU + large stride
- Fixed ZGEMM 4x4 MatrixInst mismatch
- Fixed DGEMM 4x4 MatrixInst mismatch
- Fixed ASEM + GSU + NoTailLoop opt mismatch
- Fixed AssertSummationElementMultiple + GlobalSplitU issues
- Fixed ASEM + GSU + TailLoop inner unroll

## ROCm 5.5.1

See the [ROCm 5.5.1 changelog](https://github.com/ROCm/ROCm/blob/docs/5.5.1/CHANGELOG.md)
on GitHub for a complete overview of this release.

## ROCm 5.5.0

See the [ROCm 5.5.0 changelog](https://github.com/ROCm/ROCm/blob/docs/5.5.0/CHANGELOG.md)
on GitHub for a complete overview of this release.

### **hipBLAS** (0.54.0)

#### Added

- added option to opt-in to use __half for hipblasHalf type in the API for c++ users who define HIPBLAS_USE_HIP_HALF
- added scripts to plot performance for multiple functions
- data driven hipblas-bench and hipblas-test execution via external yaml format data files
- client smoke test added for quick validation using command hipblas-test --yaml hipblas_smoke.yaml

#### Changed

- changed reference code for Windows to OpenBLAS
- hipblas client executables all now begin with hipblas- prefix

#### Resolved issues

- fixed datatype conversion functions to support more rocBLAS/cuBLAS datatypes
- fixed geqrf to return successfully when nullptrs are passed in with n == 0 || m == 0
- fixed getrs to return successfully when given nullptrs with corresponding size = 0
- fixed getrs to give info = -1 when transpose is not an expected type
- fixed gels to return successfully when given nullptrs with corresponding size = 0
- fixed gels to give info = -1 when transpose is not in (&#39;N&#39;, &#39;T&#39;) for real cases or not in (&#39;N&#39;, &#39;C&#39;) for complex cases

### **hipCUB** (2.13.1)

#### Added

- Benchmarks for `BlockShuffle`, `BlockLoad`, and `BlockStore`.

#### Changed

- CUB backend references CUB and Thrust version 1.17.2.
- Improved benchmark coverage of `BlockScan` by adding `ExclusiveScan`, benchmark coverage of `BlockRadixSort` by adding `SortBlockedToStriped`, and benchmark coverage of `WarpScan` by adding `Broadcast`.

#### Resolved issues

- Windows HIP SDK support

#### Known Issues

- `BlockRadixRankMatch` is currently broken under the rocPRIM backend.
- `BlockRadixRankMatch` with a warp size that does not exactly divide the block size is broken under the CUB backend.

### **hipFFT** (1.0.11)

#### Resolved issues

- Fixed old version rocm include/lib folders not removed on upgrade.

### **hipSOLVER** (1.7.0)

#### Added

- Added functions
  - gesvdj
    - hipsolverSgesvdj_bufferSize, hipsolverDgesvdj_bufferSize, hipsolverCgesvdj_bufferSize, hipsolverZgesvdj_bufferSize
    - hipsolverSgesvdj, hipsolverDgesvdj, hipsolverCgesvdj, hipsolverZgesvdj
  - gesvdjBatched
    - hipsolverSgesvdjBatched_bufferSize, hipsolverDgesvdjBatched_bufferSize, hipsolverCgesvdjBatched_bufferSize, hipsolverZgesvdjBatched_bufferSize
    - hipsolverSgesvdjBatched, hipsolverDgesvdjBatched, hipsolverCgesvdjBatched, hipsolverZgesvdjBatched

### **hipSPARSE** (2.3.5)

#### Optimized

- Fixed an issue, where the rocm folder was not removed on upgrade of meta packages
- Fixed a compilation issue with cusparse backend
- Added more detailed messages on unit test failures due to missing input data
- Improved documentation
- Fixed a bug with deprecation messages when using gcc9 (Thanks @Maetveis)

### **MIOpen** (2.19.0)

#### Added

- ROCm 5.5 support for gfx1101 (Navi32)

#### Changed

- Tuning results for MLIR on ROCm 5.5
- Bumping MLIR commit to 5.5.0 release tag

#### Resolved issues

- Fix 3d convolution Host API bug
- [HOTFIX][MI200][FP16] Disabled ConvHipImplicitGemmBwdXdlops when FP16_ALT is required.

### **RCCL** (2.15.5)

#### Added

- HW-topology aware binary tree implementation
- Experimental support for MSCCL
- New unit tests for hipGraph support
- NPKit integration

#### Changed

- Compatibility with NCCL 2.15.5
- Unit test executable renamed to rccl-UnitTests

#### Removed

- Removed TransferBench from tools. Exists in standalone repo: https://github.com/ROCmSoftwarePlatform/TransferBench

#### Resolved issues

- rocm-smi ID conversion
- Support for HIP_VISIBLE_DEVICES for unit tests
- Support for p2p transfers to non (HIP) visible devices

### **rocALUTION** (2.1.8)

#### Added

- Added build support for Navi32

#### Changed

- LocalVector::GetIndexValues(ValueType\*) is deprecated, use LocalVector::GetIndexValues(const LocalVector&amp;, LocalVector\*) instead
- LocalVector::SetIndexValues(const ValueType\*) is deprecated, use LocalVector::SetIndexValues(const LocalVector&amp;, const LocalVector&amp;) instead
- LocalMatrix::RSDirectInterpolation(const LocalVector&amp;, const LocalVector&amp;, LocalMatrix\*, LocalMatrix\*) is deprecated, use LocalMatrix::RSDirectInterpolation(const LocalVector&amp;, const LocalVector&amp;, LocalMatrix\*) instead
- LocalMatrix::RSExtPIInterpolation(const LocalVector&amp;, const LocalVector&amp;, bool, float, LocalMatrix\*, LocalMatrix\*) is deprecated, use LocalMatrix::RSExtPIInterpolation(const LocalVector&amp;, const LocalVector&amp;, bool, LocalMatrix\*) instead
- LocalMatrix::RugeStueben() is deprecated
- LocalMatrix::AMGSmoothedAggregation(ValueType, const LocalVector&amp;, const LocalVector&amp;, LocalMatrix\*, LocalMatrix\*, int) is deprecated, use LocalMatrix::AMGAggregation(ValueType, const LocalVector&amp;, const LocalVector&amp;, LocalMatrix\*, int) instead
- LocalMatrix::AMGAggregation(const LocalVector&amp;, LocalMatrix\*, LocalMatrix\*) is deprecated, use LocalMatrix::AMGAggregation(const LocalVector&amp;, LocalMatrix\*) instead

#### Optimized

- Fixed a typo in MPI backend
- Fixed a bug with the backend when HIP support is disabled
- Fixed a bug in SAAMG hierarchy building on HIP backend
- Improved SAAMG hierarchy build performance on HIP backend

### **rocBLAS** (2.47.0)

#### Added

- added functionality rocblas_geam_ex for matrix-matrix minimum operations
- added HIP Graph support as beta feature for rocBLAS Level 1, Level 2, and Level 3(pointer mode host) functions
- added beta features API. Exposed using compiler define ROCBLAS_BETA_FEATURES_API
- added support for vector initialization in the rocBLAS test framework with negative increments
- added windows build documentation for forthcoming support using ROCm HIP SDK
- added scripts to plot performance for multiple functions

#### Changed

- install.sh internally runs rmake.py (also used on windows) and rmake.py may be used directly by developers on linux (use --help)
- rocblas client executables all now begin with rocblas- prefix

#### Removed

- install.sh removed options -o --cov as now Tensile will use the default COV format, set by cmake define Tensile_CODE_OBJECT_VERSION=default

#### Optimized

- improved performance of Level 2 rocBLAS GEMV for float and double precision. Performance enhanced by 150-200% for certain problem sizes when (m==n) measured on a gfx90a GPU.
- improved performance of Level 2 rocBLAS GER for float, double and complex float precisions. Performance enhanced by 5-7% for certain problem sizes measured on a gfx90a GPU.
- improved performance of Level 2 rocBLAS SYMV for float and double precisions. Performance enhanced by 120-150% for certain problem sizes measured on both gfx908 and gfx90a GPUs.

#### Resolved issues

- fixed setting of executable mode on client script rocblas_gentest.py to avoid potential permission errors with clients rocblas-test and rocblas-bench
- fixed deprecated API compatibility with Visual Studio compiler
- fixed test framework memory exception handling for Level 2 functions when the host memory allocation exceeds the available memory

### **rocFFT** (1.0.22)

#### Added

- Added gfx1101 to default AMDGPU_TARGETS.

#### Changed

- Moved client programs to C++17.
- Moved planar kernels and infrequently used Stockham kernels to be runtime-compiled.
- Moved transpose, real-complex, Bluestein, and Stockham kernels to library kernel cache.

#### Optimized

- Improved performance of 1D lengths &lt; 2048 that use Bluestein&#39;s algorithm.
- Reduced time for generating code during plan creation.
- Optimized 3D R2C/C2R lengths 32, 84, 128.
- Optimized batched small 1D R2C/C2R cases.

#### Resolved issues

- Removed zero-length twiddle table allocations, which fixes errors from hipMallocManaged.
- Fixed incorrect freeing of HIP stream handles during twiddle computation when multiple devices are present.

### **rocm-cmake** (0.8.1)

#### Changed

- ROCMHeaderWrapper: The wrapper header deprecation message is now a deprecation warning.

#### Resolved issues

- ROCMInstallTargets: Added compatibility symlinks for included cmake files in `&lt;ROCM&gt;/lib/cmake/&lt;PACKAGE&gt;`.

### **rocPRIM** (2.13.0)

#### Added

- New block level `radix_rank` primitive.
- New block level `radix_rank_match` primitive.

#### Changed

- Improved the performance of `block_radix_sort` and `device_radix_sort`.

#### Resolved issues

- Fixed benchmark build on Windows

#### Known issues

- Disabled GPU error messages relating to incorrect warp operation usage with Navi GPUs on Windows, due to GPU printf performance issues on Windows.

### **rocRAND** (2.10.17)

#### Added

- MT19937 pseudo random number generator based on M. Matsumoto and T. Nishimura, 1998, Mersenne Twister: A 623-dimensionally equidistributed uniform pseudorandom number generator.
- New benchmark for the device API using Google Benchmark, `benchmark_rocrand_device_api`, replacing `benchmark_rocrand_kernel`. `benchmark_rocrand_kernel` is deprecated and will be removed in a future version. Likewise, `benchmark_curand_host_api` is added to replace `benchmark_curand_generate` and `benchmark_curand_device_api` is added to replace `benchmark_curand_kernel`.
- experimental HIP-CPU feature
- ThreeFry pseudorandom number generator based on Salmon et al., 2011, &#34;Parallel random numbers: as easy as 1, 2, 3&#34;.

#### Changed

- Python 2.7 is no longer officially supported.

#### Fixed

- Windows HIP SDK support

### **rocSOLVER** (3.21.0)

#### Added

- SVD for general matrices using Jacobi algorithm:
    - GESVDJ (with batched and strided\_batched versions)
- LU factorization without pivoting for block tridiagonal matrices:
    - GEBLTTRF_NPVT (with batched and strided\_batched versions)
- Linear system solver without pivoting for block tridiagonal matrices:
    - GEBLTTRS_NPVT (with batched and strided\_batched, versions)
- Product of triangular matrices
    - LAUUM
- Added experimental hipGraph support for rocSOLVER functions

#### Optimized

- Improved the performance of SYEVJ/HEEVJ.

#### Changed

- STEDC, SYEVD/HEEVD and SYGVD/HEGVD now use fully implemented Divide and Conquer approach.

#### Fixed

- SYEVJ/HEEVJ should now be invariant under matrix scaling.
- SYEVJ/HEEVJ should now properly output the eigenvalues when no sweeps are executed.
- Fixed GETF2\_NPVT and GETRF\_NPVT input data initialization in tests and benchmarks.
- Fixed rocblas missing from the dependency list of the rocsolver deb and rpm packages.

### **rocSPARSE** (2.5.1)

#### Added

- Added bsrgemm and spgemm for BSR format
- Added bsrgeam
- Added build support for Navi32
- Added experimental hipGraph support for some rocSPARSE routines
- Added csritsv, spitsv csr iterative triangular solve
- Added mixed precisions for SpMV
- Added batched SpMM for transpose A in COO format with atomic atomic algorithm

#### Improved

- Optimization to csr2bsr
- Optimization to csr2csr_compress
- Optimization to csr2coo
- Optimization to gebsr2csr
- Optimization to csr2gebsr
- Fixes to documentation
- Fixes a bug in COO SpMV gridsize
- Fixes a bug in SpMM gridsize when using very large matrices

#### Known issues

- In csritlu0, the algorithm rocsparse_itilu0_alg_sync_split_fusion has some accuracy issues to investigate with XNACK enabled. The fallback is rocsparse_itilu0_alg_sync_split.

### **rocWMMA** (1.0)

#### Added

- Added support for wave32 on gfx11+
- Added infrastructure changes to support hipRTC
- Added performance tracking system

#### Changed

- Modified the assignment of hardware information
- Modified the data access for unsigned datatypes
- Added library config to support multiple architectures

### **Tensile** (4.36.0)

#### Added

- Add functions for user-driven tuning
- Add GFX11 support: HostLibraryTests yamls, rearragne FP32(C)/FP64(C) instruction order, archCaps for instruction renaming condition, adjust vgpr bank for A/B/C for optimize, separate vscnt and vmcnt, dual mac
- Add binary search for Grid-Based algorithm
- Add reject condition for (StoreCInUnroll + BufferStore=0) and (DirectToVgpr + ScheduleIterAlg&lt;3 + PrefetchGlobalRead==2)
- Add support for (DirectToLds + hgemm + NN/NT/TT) and (DirectToLds + hgemm + GlobalLoadVectorWidth &lt; 4)
- Add support for (DirectToLds + hgemm(TLU=True only) or sgemm + NumLoadsCoalesced &gt; 1)
- Add GSU SingleBuffer algorithm for HSS/BSS
- Add gfx900:xnack-, gfx1032, gfx1034, gfx1035
- Enable gfx1031 support

#### Changed

- Use global_atomic for GSU instead of flat and global_store for debug code
- Replace flat_load/store with global_load/store
- Use global_load/store for BufferLoad/Store=0 and enable scheduling
- LocalSplitU support for HGEMM+HPA when MFMA disabled
- Update Code Object Version
- Type cast local memory to COMPUTE_DATA_TYPE in LDS to avoid precision loss
- Update asm cap cache arguments
- Unify SplitGlobalRead into ThreadSeparateGlobalRead and remove SplitGlobalRead
- Change checks, error messages, assembly syntax, and coverage for DirectToLds
- Remove unused cmake file
- Clean up the LLVM dependency code
- Update ThreadSeparateGlobalRead test cases for PrefetchGlobalRead=2
- Update sgemm/hgemm test cases for DirectToLds and ThreadSepareteGlobalRead

#### Optimized

- Use AssertSizeLessThan for BufferStoreOffsetLimitCheck if it is smaller than MT1
- Improve InitAccVgprOpt

#### Resolved issues

- Add build-id to header of compiled source kernels
- Fix solution index collisions
- Fix h beta vectorwidth4 correctness issue for WMMA
- Fix an error with BufferStore=0
- Fix mismatch issue with (StoreCInUnroll + PrefetchGlobalRead=2)
- Fix MoveMIoutToArch bug
- Fix flat load correctness issue on I8 and flat store correctness issue
- Fix mismatch issue with BufferLoad=0 + TailLoop for large array sizes
- Fix code generation error with BufferStore=0 and StoreCInUnrollPostLoop
- Fix issues with DirectToVgpr + ScheduleIterAlg&lt;3
- Fix mismatch issue with DGEMM TT + LocalReadVectorWidth=2
- Fix mismatch issue with PrefetchGlobalRead=2
- Fix mismatch issue with DirectToVgpr + PrefetchGlobalRead=2 + small tile size
- Fix an error with PersistentKernel=0 + PrefetchAcrossPersistent=1 + PrefetchAcrossPersistentMode=1
- Fix mismatch issue with DirectToVgpr + DirectToLds + only 1 iteration in unroll loop case
- Remove duplicate GSU kernels: for GSU = 1, GSUAlgorithm SingleBuffer and MultipleBuffer kernels are identical
- Fix for failing CI tests due to CpuThreads=0
- Fix mismatch issue with DirectToLds + PrefetchGlobalRead=2
- Remove the reject condition for ThreadSeparateGlobalRead and DirectToLds (HGEMM, SGEMM only)
- Modify reject condition for minimum lanes of ThreadSeparateGlobalRead (SGEMM or larger data type only)

## ROCm 5.4.3

See the [ROCm 5.4.3 changelog](https://github.com/ROCm/ROCm/blob/docs/5.4.3/CHANGELOG.md)
on GitHub for a complete overview of this release.

### **rocFFT** (1.0.21)

#### Resolved issues

- Removed source directory from rocm_install_targets call to prevent installation of rocfft.h in an unintended location.

## ROCm 5.4.2

See the [ROCm 5.4.2 changelog](https://github.com/ROCm/ROCm/blob/docs/5.4.2/CHANGELOG.md)
on GitHub for a complete overview of this release.

## ROCm 5.4.1

See the [ROCm 5.4.1 changelog](https://github.com/ROCm/ROCm/blob/docs/5.4.1/CHANGELOG.md)
on GitHub for a complete overview of this release.

### **rocFFT** (1.0.20)

#### Fixed

- Fixed incorrect results on strided large 1D FFTs where batch size does not equal the stride.

## ROCm 5.4.0

See the [ROCm 5.4.0 changelog](https://github.com/ROCm/ROCm/blob/docs/5.4.0/CHANGELOG.md)
on GitHub for a complete overview of this release.

### **hipBLAS** (0.53.0)

#### Added

- Allow for selection of int8 datatype
- Added support for hipblasXgels and hipblasXgelsStridedBatched operations (with s,d,c,z precisions),
  only supported with rocBLAS backend
- Added support for hipblasXgelsBatched operations (with s,d,c,z precisions)

### **hipCUB** (2.13.0)

#### Added

- CMake functionality to improve build parallelism of the test suite that splits compilation units by
function or by parameters.
- New overload for `BlockAdjacentDifference::SubtractLeftPartialTile` that takes a predecessor item.

#### Changed

- Improved build parallelism of the test suite by splitting up large compilation units for `DeviceRadixSort`, 
`DeviceSegmentedRadixSort` and `DeviceSegmentedSort`.
- CUB backend references CUB and thrust version 1.17.1.

### **hipFFT** (1.0.10)

#### Added

- Added hipfftExtPlanScaleFactor API to efficiently multiply each output element of a FFT by a given scaling factor.  Result scaling must be supported in the backend FFT library.

#### Changed

- When hipFFT is built against the rocFFT backend, rocFFT 1.0.19 or higher is now required.

### **hipSOLVER** (1.6.0)

#### Added

- Added compatibility-only functions
  - gesvdaStridedBatched
    - hipsolverDnSgesvdaStridedBatched_bufferSize, hipsolverDnDgesvdaStridedBatched_bufferSize, hipsolverDnCgesvdaStridedBatched_bufferSize, hipsolverDnZgesvdaStridedBatched_bufferSize
    - hipsolverDnSgesvdaStridedBatched, hipsolverDnDgesvdaStridedBatched, hipsolverDnCgesvdaStridedBatched, hipsolverDnZgesvdaStridedBatched

### **hipSPARSE** (2.3.3)

#### Added

- Added hipsparseCsr2cscEx2_bufferSize and hipsparseCsr2cscEx2 routines

#### Changed

- HIPSPARSE_ORDER_COLUMN has been renamed to HIPSPARSE_ORDER_COL to match cusparse

### **RCCL** (2.13.4)

#### Changed

- Compatibility with NCCL 2.13.4
- Improvements to RCCL when running with hipGraphs
- RCCL_ENABLE_HIPGRAPH environment variable is no longer necessary to enable hipGraph support
- Minor latency improvements

#### Resolved issues

- Resolved potential memory access error due to asynchronous memset

### **rocALUTION** (2.1.3)

#### Added

- Added build support for Navi31 and Navi33
- Added support for non-squared global matrices

#### Changed

- Switched GTest death test style to &#39;threadsafe&#39;
- GlobalVector::GetGhostSize() is deprecated and will be removed
- ParallelManager::GetGlobalSize(), ParallelManager::GetLocalSize(), ParallelManager::SetGlobalSize() and ParallelManager::SetLocalSize() are deprecated and will be removed
- Vector::GetGhostSize() is deprecated and will be removed
- Multigrid::SetOperatorFormat(unsigned int) is deprecated and will be removed, use Multigrid::SetOperatorFormat(unsigned int, int) instead
- RugeStuebenAMG::SetCouplingStrength(ValueType) is deprecated and will be removed, use SetStrengthThreshold(float) instead

#### Optimized

- Fixed a memory leak in MatrixMult on HIP backend
- Global structures can now be used with a single process

### **rocBLAS** (2.46.0)

#### Added

- client smoke test dataset added for quick validation using command rocblas-test --yaml rocblas_smoke.yaml
- Added stream order device memory allocation as a non-default beta option.

#### Changed

- Level 2, Level 1, and Extension functions: argument checking when the handle is set to rocblas_pointer_mode_host now returns the status of rocblas_status_invalid_pointer only for pointers that must be dereferenced based on the alpha and beta argument values.  With handle mode rocblas_pointer_mode_device only pointers that are always dereferenced regardless of alpha and beta values are checked and so may lead to a return status of rocblas_status_invalid_pointer.   This improves consistency with legacy BLAS behaviour.
- Add variable to turn on/off ieee16/ieee32 tests for mixed precision gemm
- Allow hipBLAS to select int8 datatype
- Disallow B == C &amp;&amp; ldb != ldc in rocblas_xtrmm_outofplace

#### Optimized

- Improved trsm performance for small sizes by using a substitution method technique
- Improved syr2k and her2k performance significantly by using a block-recursive algorithm

#### Fixed

- FORTRAN interfaces generalized for FORTRAN compilers other than gfortran
- fix for trsm_strided_batched rocblas-bench performance gathering
- Fix for rocm-smi path in commandrunner.py script to match ROCm 5.2 and above

### **rocFFT** (1.0.19)

#### Added

- Added rocfft_plan_description_set_scale_factor API to efficiently multiply each output element of a FFT by a given scaling factor.
- Created a rocfft_kernel_cache.db file next to the installed library. SBCC kernels are moved to this file when built with the library, and are runtime-compiled for new GPU architectures.
- Added gfx1100 and gfx1102 to default AMDGPU_TARGETS.

#### Changed

- Moved runtime compilation cache to in-memory by default.  A default on-disk cache can encounter contention problems 
on multi-node clusters with a shared filesystem.  rocFFT can still be told to use an on-disk cache by setting the 
ROCFFT_RTC_CACHE_PATH environment variable.

#### Optimized

- Optimized some strided large 1D plans.

### **rocPRIM** (2.12.0)

#### Changed

- `device_partition`, `device_unique`, and `device_reduce_by_key` now support problem 
  sizes larger than 2^32 items.

#### Removed

- `block_sort::sort()` overload for keys and values with a dynamic size. This overload was documented but the
  implementation is missing. To avoid further confusion the documentation is removed until a decision is made on
  implementing the function.

#### Resolved issues

- Fixed the compilation failure in `device_merge` if the two key iterators don&#39;t match.

### **rocRAND** (2.10.16)

#### Added

- MRG31K3P pseudorandom number generator based on L&#39;Ecuyer and Touzin, 2000, &#34;Fast combined multiple recursive generators with multipliers of the form a = ±2q ±2r&#34;.
- LFSR113 pseudorandom number generator based on L&#39;Ecuyer, 1999, &#34;Tables of maximally equidistributed combined LFSR generators&#34;.
- SCRAMBLED_SOBOL32 and SCRAMBLED_SOBOL64 quasirandom number generators. The Scrambled Sobol sequences are generated by scrambling the output of a Sobol sequence.

#### Changed

- The `mrg_&lt;distribution&gt;_distribution` structures, which provided numbers based on MRG32K3A, are now replaced by `mrg_engine_&lt;distribution&gt;_distribution`, where `&lt;distribution&gt;` is `log_normal`, `normal`, `poisson`, or `uniform`. These structures provide numbers for MRG31K3P (with template type `rocrand_state_mrg31k3p`) and MRG32K3A (with template type `rocrand_state_mrg32k3a`).

#### Resolved issues

- Sobol64 now returns 64 bits random numbers, instead of 32 bits random numbers. As a result, the performance of this generator has regressed.
- Fixed a bug that prevented compiling code in C++ mode (with a host compiler) when it included the rocRAND headers on Windows.

### **rocSOLVER** (3.20.0)

#### Added

- Partial SVD for bidiagonal matrices:
    - BDSVDX
- Partial SVD for general matrices:
    - GESVDX (with batched and strided\_batched versions)

#### Changed

- Changed `ROCSOLVER_EMBED_FMT` default to `ON` for users building directly with CMake.
  This matches the existing default when building with install.sh or rmake.py.

### **rocSPARSE** (2.4.0)

#### Added

- Added rocsparse_spmv_ex routine
- Added rocsparse_bsrmv_ex_analysis and rocsparse_bsrmv_ex routines
- Added csritilu0 routine
- Added build support for Navi31 and Navi 33

#### Optimized

- Optimization to segmented algorithm for COO SpMV by performing analysis
- Improve performance when generating random matrices.
- Fixed bug in ellmv
- Optimized bsr2csr routine
- Fixed integer overflow bugs

### **rocThrust** (2.17.0)

#### Added

- Updated to match upstream Thrust 1.17.0

### **rocWMMA** (0.9)

#### Added

- Added gemm driver APIs for flow control builtins
- Added benchmark logging systems
- Restructured tests to follow naming convention. Added macros for test generation

#### Changed

- Changed CMake to accomodate the modified test infrastructure
- Fine tuned the multi-block kernels with and without lds
- Adjusted Maximum Vector Width to dWordx4 Width
- Updated Efficiencies to display as whole number percentages
- Updated throughput from GFlops/s to TFlops/s
- Reset the ad-hoc tests to use smaller sizes
- Modified the output validation to use CPU-based implementation against rocWMMA
- Modified the extended vector test to return error codes for memory allocation failures

### **Tensile** (4.35.0)

#### Added

- Async DMA support for Transpose Data Layout (ThreadSeparateGlobalReadA/B)
- Option to output library logic in dictionary format
- No solution found error message for benchmarking client
- Exact K check for StoreCInUnrollExact
- Support for CGEMM + MIArchVgpr
- client-path parameter for using prebuilt client
- CleanUpBuildFiles global parameter
- Debug flag for printing library logic index of winning solution
- NumWarmups global parameter for benchmarking
- Windows support for benchmarking client
- DirectToVgpr support for CGEMM
- TensileLibLogicToYaml for creating tuning configs from library logic solutions

#### Changed

- Re-enable HardwareMonitor for gfx90a
- Decision trees use MLFeatures instead of Properties

#### Optimized

- Put beta code and store separately if StoreCInUnroll = x4 store
- Improved performance for StoreCInUnroll + b128 store

#### Resolved issues

- Reject DirectToVgpr + MatrixInstBM/BN &gt; 1
- Fix benchmark timings when using warmups and/or validation
- Fix mismatch issue with DirectToVgprB + VectorWidth &gt; 1
- Fix mismatch issue with DirectToLds + NumLoadsCoalesced &gt; 1 + TailLoop
- Fix incorrect reject condition for DirectToVgpr
- Fix reject condition for DirectToVgpr + MIWaveTile &lt; VectorWidth
- Fix incorrect instruction generation with StoreCInUnroll

## ROCm 5.3.3

See the [ROCm 5.3.3 changelog](https://github.com/ROCm/ROCm/blob/docs/5.3.3/CHANGELOG.md)
on GitHub for a complete overview of this release.

## ROCm 5.3.2

See the [ROCm 5.3.2 changelog](https://github.com/ROCm/ROCm/blob/docs/5.3.2/CHANGELOG.md)
on GitHub for a complete overview of this release.

## ROCm 5.3.0

See the [ROCm 5.3.0 changelog](https://github.com/ROCm/ROCm/blob/docs/5.3.0/CHANGELOG.md)
on GitHub for a complete overview of this release.

### **hipBLAS** (0.52.0)

#### Added

- Added --cudapath option to install.sh to allow user to specify which cuda build they would like to use.
- Added --installcuda option to install.sh to install cuda via a package manager. Can be used with new --installcudaversion
  option to specify which version of cuda to install.

#### Resolved issues

- Fixed #includes to support a compiler version.
- Fixed client dependency support in install.sh

### **hipCUB** (2.12.0)

#### Added

- UniqueByKey device algorithm
- SubtractLeft, SubtractLeftPartialTile, SubtractRight, SubtractRightPartialTile overloads in BlockAdjacentDifference.
  - The old overloads (FlagHeads, FlagTails, FlagHeadsAndTails) are deprecated.
- DeviceAdjacentDifference algorithm.
- Extended benchmark suite of `DeviceHistogram`, `DeviceScan`, `DevicePartition`, `DeviceReduce`,
`DeviceSegmentedReduce`, `DeviceSegmentedRadixSort`, `DeviceRadixSort`, `DeviceSpmv`, `DeviceMergeSort`,
`DeviceSegmentedSort`

#### Changed

- Obsolated type traits defined in util_type.hpp. Use the standard library equivalents instead.
- CUB backend references CUB and thrust version 1.16.0.
- DeviceRadixSort&#39;s num_items parameter&#39;s type is now templated instead of being an int.
  - If an integral type with a size at most 4 bytes is passed (i.e. an int), the former logic applies.
  - Otherwise the algorithm uses a larger indexing type that makes it possible to sort input data over 2**32 elements.
- Improved build parallelism of the test suite by splitting up large compilation units

### **hipFFT** (1.0.9)

#### Changed

- Clean up build warnings.
- GNUInstall Dir enhancements.
- Requires gtest 1.11.

### **hipSOLVER** (1.5.0)

#### Added

- Added functions
  - syevj
    - hipsolverSsyevj_bufferSize, hipsolverDsyevj_bufferSize, hipsolverCheevj_bufferSize, hipsolverZheevj_bufferSize
    - hipsolverSsyevj, hipsolverDsyevj, hipsolverCheevj, hipsolverZheevj
  - syevjBatched
    - hipsolverSsyevjBatched_bufferSize, hipsolverDsyevjBatched_bufferSize, hipsolverCheevjBatched_bufferSize, hipsolverZheevjBatched_bufferSize
    - hipsolverSsyevjBatched, hipsolverDsyevjBatched, hipsolverCheevjBatched, hipsolverZheevjBatched
  - sygvj
    - hipsolverSsygvj_bufferSize, hipsolverDsygvj_bufferSize, hipsolverChegvj_bufferSize, hipsolverZhegvj_bufferSize
    - hipsolverSsygvj, hipsolverDsygvj, hipsolverChegvj, hipsolverZhegvj
- Added compatibility-only functions
  - syevdx/heevdx
    - hipsolverDnSsyevdx_bufferSize, hipsolverDnDsyevdx_bufferSize, hipsolverDnCheevdx_bufferSize, hipsolverDnZheevdx_bufferSize
    - hipsolverDnSsyevdx, hipsolverDnDsyevdx, hipsolverDnCheevdx, hipsolverDnZheevdx
  - sygvdx/hegvdx
    - hipsolverDnSsygvdx_bufferSize, hipsolverDnDsygvdx_bufferSize, hipsolverDnChegvdx_bufferSize, hipsolverDnZhegvdx_bufferSize
    - hipsolverDnSsygvdx, hipsolverDnDsygvdx, hipsolverDnChegvdx, hipsolverDnZhegvdx
- Added --mem_query option to hipsolver-bench, which will print the amount of device memory workspace required by the function.

#### Changed

- The rocSOLVER backend will now set `info` to zero if rocSOLVER does not reference `info`. (Applies to orgbr/ungbr, orgqr/ungqr, orgtr/ungtr, ormqr/unmqr, ormtr/unmtr, gebrd, geqrf, getrs, potrs, and sytrd/hetrd).
- gesvdj will no longer require extra workspace to transpose `V` when `jobz` is `HIPSOLVER_EIG_MODE_VECTOR` and `econ` is 1.

#### Fixed

- Fixed Fortran return value declarations within hipsolver_module.f90
- Fixed gesvdj_bufferSize returning `HIPSOLVER_STATUS_INVALID_VALUE` when `jobz` is `HIPSOLVER_EIG_MODE_NOVECTOR` and 1 &lt;= `ldv` &lt; `n`
- Fixed gesvdj returning `HIPSOLVER_STATUS_INVALID_VALUE` when `jobz` is `HIPSOLVER_EIG_MODE_VECTOR`, `econ` is 1, and `m` &lt; `n`

### **hipSPARSE** (2.3.1)

#### Added

- Add SpMM and SpMM batched for CSC format

### **rocALUTION** (2.1.0)

#### Added

- Benchmarking tool
- Ext+I Interpolation with sparsify strategies added for RS-AMG

#### Optimized

- ParallelManager

### **rocBLAS** (2.45.0)

#### Added

- install.sh option --upgrade_tensile_venv_pip to upgrade Pip in Tensile Virtual Environment. The corresponding CMake option is TENSILE_VENV_UPGRADE_PIP.
- install.sh option --relocatable or -r adds rpath and removes ldconf entry on rocBLAS build.
- install.sh option --lazy-library-loading to enable on-demand loading of tensile library files at runtime to speedup rocBLAS initialization.
- Support for RHEL9 and CS9.
- Added Numerical checking routine for symmetric, Hermitian, and triangular matrices, so that they could be checked for any numerical abnormalities such as NaN, Zero, infinity and denormal value.

#### Changed

- Unifying library logic file names: affects HBH (-&gt;HHS_BH), BBH (-&gt;BBS_BH), 4xi8BH (-&gt;4xi8II_BH). All HPA types are using the new naming convention now.
- Level 3 function argument checking when the handle is set to rocblas_pointer_mode_host now returns the status of rocblas_status_invalid_pointer only for pointers that must be dereferenced based on the alpha and beta argument values. With handle mode rocblas_pointer_mode_device only pointers that are always dereferenced regardless of alpha and beta values are checked and so may lead to a return status of rocblas_status_invalid_pointer. This improves consistency with legacy BLAS behaviour.
- Level 1, 2, and 3 function argument checking for enums is now more rigorously matching legacy BLAS so returns rocblas_status_invalid_value if arguments do not match the accepted subset.
- Add quick-return for internal trmm and gemm template functions.
- Moved function block sizes to a shared header file.
- Level 1, 2, and 3 functions use rocblas_stride datatype for offset.
- Modified the matrix and vector memory allocation in our test infrastructure for all Level 1, 2, 3 and BLAS_EX functions.
- Added specific initialization for symmetric, Hermitian, and triangular matrix types in our test infrastructure.
- Added NaN tests to the test infrastructure for the rest of Level 3, BLAS_EX functions.

#### Removed

- install.sh options  --hip-clang , --no-hip-clang, --merge-files, --no-merge-files are removed.
- is_complex helper is now deprecated.  Use rocblas_is_complex instead.
- The enum truncate_t and the value truncate is now deprecated and will removed from the ROCm release 6.0. It is replaced by rocblas_truncate_t and rocblas_truncate, respectively. The new enum rocblas_truncate_t and the value rocblas_truncate could be used from this ROCm release for an easy transition.

#### Optimized

- trmm_outofplace performance improvements for all sizes and data types using block-recursive algorithm.
- herkx performance improvements for all sizes and data types using block-recursive algorithm.
- syrk/herk performance improvements by utilising optimised syrkx/herkx code.
- symm/hemm performance improvements for all sizes and datatypes using block-recursive algorithm.

#### Resolved issues

- Improved logic to #include &lt;filesystem&gt; vs &lt;experimental/filesystem&gt;.
- install.sh -s option to build rocblas as a static library.
- dot function now sets the device results asynchronously for N &lt;= 0

### **rocFFT** (1.0.18)

#### Changed

- Runtime compilation cache now looks for environment variables XDG_CACHE_HOME (on Linux) and LOCALAPPDATA (on
  Windows) before falling back to HOME.

#### Optimized

- Optimized 2D R2C/C2R to use 2-kernel plans where possible.
- Improved performance of the Bluestein algorithm.
- Optimized sbcc-168 and 100 by using half-lds.

#### Resolved issues

- Fixed occasional failures to parallelize runtime compilation of kernels.
  Failures would be retried serially and ultimately succeed, but this would take extra time.
- Fixed failures of some R2C 3D transforms that use the unsupported TILE_UNALGNED SBRC kernels.
  An example is 98^3 R2C out-of-place.
- Fixed bugs in SBRC_ERC type.

### **rocm-cmake** (0.8.0)

#### Changed

- `ROCM_USE_DEV_COMPONENT` set to on by default for all platforms. This means that Windows will now generate runtime and devel packages by default
- ROCMInstallTargets now defaults `CMAKE_INSTALL_LIBDIR` to `lib` if not otherwise specified.
- Changed default Debian compression type to xz and enabled multi-threaded package compression.
- `rocm_create_package` will no longer warn upon failure to determine version of program rpmbuild.

#### Resolved issues

- Fixed error in prerm scripts created by `rocm_create_package` that could break uninstall for packages using the `PTH` option.

### **rocPRIM** (2.11.0)

#### Added

- New functions `subtract_left` and `subtract_right` in `block_adjacent_difference` to apply functions
  on pairs of adjacent items distributed between threads in a block.
- New device level `adjacent_difference` primitives.
- Added experimental tooling for automatic kernel configuration tuning for various architectures
- Benchmarks collect and output more detailed system information
- CMake functionality to improve build parallelism of the test suite that splits compilation units by
function or by parameters.
- Reverse iterator.

### **rocRAND** (2.10.15)

#### Changed

- Increased number of warmup iterations for rocrand_benchmark_generate from 5 to 15 to eliminate corner cases that would generate artificially high benchmark scores.

### **rocSOLVER** (3.19.0)

#### Added

- Partial eigensolver routines for symmetric/hermitian matrices:
    - SYEVX (with batched and strided\_batched versions)
    - HEEVX (with batched and strided\_batched versions)
- Generalized symmetric- and hermitian-definite partial eigensolvers:
    - SYGVX (with batched and strided\_batched versions)
    - HEGVX (with batched and strided\_batched versions)
- Eigensolver routines for symmetric/hermitian matrices using Jacobi algorithm:
    - SYEVJ (with batched and strided\_batched versions)
    - HEEVJ (with batched and strided\_batched versions)
- Generalized symmetric- and hermitian-definite eigensolvers using Jacobi algorithm:
    - SYGVJ (with batched and strided\_batched versions)
    - HEGVJ (with batched and strided\_batched versions)
- Added --profile_kernels option to rocsolver-bench, which will include kernel calls in the
  profile log (if profile logging is enabled with --profile).

#### Changed

- Changed rocsolver-bench result labels `cpu_time` and `gpu_time` to
  `cpu_time_us` and `gpu_time_us`, respectively.

#### Removed

- Removed dependency on cblas from the rocsolver test and benchmark clients.

#### Resolved issues

- Fixed incorrect SYGS2/HEGS2, SYGST/HEGST, SYGV/HEGV, and SYGVD/HEGVD results for batch counts
  larger than 32.
- Fixed STEIN memory access fault when nev is 0.
- Fixed incorrect STEBZ results for close eigenvalues when range = index.
- Fixed git unsafe repository error when building with `./install.sh -cd` as a non-root user.

### **rocThrust** (2.16.0)

#### Changed

- rocThrust functionality dependent on device malloc works is functional as ROCm 5.2 reneabled device malloc. Device launched `thrust::sort` and `thrust::sort_by_key` are available for use.

### **Tensile** (4.34.0)

#### Added

- Lazy loading of solution libraries and code object files
- Support for dictionary style logic files
- Support for decision tree based logic files using dictionary format
- DecisionTreeLibrary for solution selection
- DirectToLDS support for HGEMM
- DirectToVgpr support for SGEMM
- Grid based distance metric for solution selection
- Support for gfx11xx
- Support for DirectToVgprA/B + TLU=False
- ForkParameters Groups as a way of specifying solution parameters
- Support for a new Tensile yaml config format
- TensileClientConfig for generating Tensile client config files
- Options for TensileCreateLibrary to build client and create client config file

#### Changed

- Default MACInstruction to FMA

#### Optimized

- Solution generation is now cached and is not repeated if solution parameters are unchanged

#### Resolved issues

- Accept StaggerUStride=0 as valid
- Reject invalid data types for UnrollLoopEfficiencyEnable
- Fix invalid code generation issues related to DirectToVgpr
- Return hipErrorNotFound if no modules are loaded
- Fix performance drop for NN ZGEMM with 96x64 macro tile
- Fix memory violation for general batched kernels when alpha/beta/K = 0

## ROCm 5.2.3

See the [ROCm 5.2.3 changelog](https://github.com/ROCm/ROCm/blob/docs/5.2.3/CHANGELOG.md)
on GitHub for a complete overview of this release.

### **RCCL** (2.12.10)

#### Added

- Compatibility with NCCL 2.12.10
- Packages for test and benchmark executables on all supported OSes using CPack.
- Adding custom signal handler - opt-in with RCCL_ENABLE_SIGNALHANDLER=1
  - Additional details provided if Binary File Descriptor library (BFD) is pre-installed
- Adding support for reusing ports in NET/IB channels
  - Opt-in with NCCL_IB_SOCK_CLIENT_PORT_REUSE=1 and NCCL_IB_SOCK_SERVER_PORT_REUSE=1
  - When &#34;Call to bind failed : Address already in use&#34; error happens in large-scale AlltoAll
    (e.g., &gt;=64 MI200 nodes), users are suggested to opt-in either one or both of the options
    to resolve the massive port usage issue
  - Avoid using NCCL_IB_SOCK_SERVER_PORT_REUSE when NCCL_NCHANNELS_PER_NET_PEER is tuned &gt;1

#### Removed

- Removed experimental clique-based kernels

## ROCm 5.2.1

See the [ROCm 5.2.1 changelog](https://github.com/ROCm/ROCm/blob/docs/5.2.1/CHANGELOG.md)
on GitHub for a complete overview of this release.

## ROCm 5.2.0

See the [ROCm 5.2.0 changelog](https://github.com/ROCm/ROCm/blob/docs/5.2.0/CHANGELOG.md)
on GitHub for a complete overview of this release.

### **hipBLAS** (0.51.0)

#### Added

- Packages for test and benchmark executables on all supported OSes using CPack.
- Added File/Folder Reorg Changes with backward compatibility support enabled using ROCM-CMAKE wrapper functions
- Added user-specified initialization option to hipblas-bench

#### Resolved issues

- Fixed version gathering in performance measuring script

### **hipCUB** (2.11.1)

#### Added

- Packages for tests and benchmark executable on all supported OSes using CPack.

### **hipFFT** (1.0.8)

#### Added

- Added File/Folder Reorg Changes with backward compatibility support using ROCM-CMAKE wrapper functions.
- Packages for test and benchmark executables on all supported OSes using CPack.

### **hipSOLVER** (1.4.0)

#### Added

- Package generation for test and benchmark executables on all supported OSes using CPack.
- File/Folder Reorg
  - Added File/Folder Reorg Changes with backward compatibility support using ROCM-CMAKE wrapper functions.

#### Resolved issues

- Fixed the ReadTheDocs documentation generation.

### **hipSPARSE** (2.2.0)

#### Added

- Packages for test and benchmark executables on all supported OSes using CPack.

### **rocALUTION** (2.0.3)

#### Added

- Packages for test and benchmark executables on all supported OSes using CPack.

### **rocBLAS** (2.44.0)

#### Added

- Packages for test and benchmark executables on all supported OSes using CPack.
- Added Denormal number detection to the Numerical checking helper function to detect denormal/subnormal numbers in the input and the output vectors of rocBLAS level 1 and 2 functions.
- Added Denormal number detection to the Numerical checking helper function to detect denormal/subnormal numbers in the input and the output general matrices of rocBLAS level 2 and 3 functions.
- Added NaN initialization tests to the yaml files of Level 2 rocBLAS batched and strided-batched functions for testing purposes.
- Added memory allocation check to avoid disk swapping during rocblas-test runs by skipping tests.

#### Changed

- Modifying gemm_ex for HBH (High-precision F16). The alpha/beta data type remains as F32 without narrowing to F16 and expanding back to F32 in the kernel. This change prevents rounding errors due to alpha/beta conversion in situations where alpha/beta are not exactly represented as an F16.
- Modified non-batched and batched asum, nrm2 functions to use shuffle instruction based reductions.
- For gemm, gemm_ex, gemm_ex2 internal API use rocblas_stride datatype for offset.
- For symm, hemm, syrk, herk, dgmm, geam internal API use rocblas_stride datatype for offset.
-  AMD copyright year for all rocBLAS files.
- For gemv (transpose-case), typecasted the &#39;lda&#39;(offset) datatype to size_t during offset calculation to avoid overflow and remove duplicate template functions.

#### Removed

- Remove Navi12 (gfx1011) from fat binary.

#### Optimized

- Improved performance of non-batched and batched her2 for all sizes and data types.
- Improved performance of non-batched and batched amin for all data types using shuffle reductions.
- Improved performance of non-batched and batched amax for all data types using shuffle reductions.
- Improved performance of trsv for all sizes and data types.

#### Resolved issues

- For function her2 avoid overflow in offset calculation.
- For trsm when alpha == 0 and on host, allow A to be nullptr.
- Fixed memory access issue in trsv.
- Fixed git pre-commit script to update only AMD copyright year.
- Fixed dgmm, geam test functions to set correct stride values.
- For functions ssyr2k and dsyr2k allow trans == rocblas_operation_conjugate_transpose.
- Fixed compilation error for clients-only build.

### **rocFFT** (1.0.17)

#### Added

- Packages for test and benchmark executables on all supported OSes using CPack.
- Added File/Folder Reorg Changes with backward compatibility support using ROCM-CMAKE wrapper functions.

#### Changed

- Improved reuse of twiddle memory between plans.
- Set a default load/store callback when only one callback
  type is set via the API for improved performance.

#### Optimized

- Introduced a new access pattern of lds (non-linear) and applied it on
  sbcc kernels len 64 to get performance improvement.

#### Resolved issues

- Fixed plan creation failure in cases where SBCC kernels would need to write to non-unit-stride buffers.

### **rocPRIM** (2.10.14)

#### Added

- Packages for tests and benchmark executable on all supported OSes using CPack.
- Added File/Folder Reorg Changes and Enabled Backward compatibility support using wrapper headers.

### **rocRAND** (2.10.14)

#### Added

- Backward compatibility for deprecated `#include &lt;rocrand.h&gt;` using wrapper header files.
- Packages for test and benchmark executables on all supported OSes using CPack.

### **rocSOLVER** (3.18.0)

#### Added

- Partial eigenvalue decomposition routines:
    - STEBZ
    - STEIN
- Package generation for test and benchmark executables on all supported OSes using CPack.
- Added tests for multi-level logging
- Added tests for rocsolver-bench client
- File/Folder Reorg
  - Added File/Folder Reorg Changes with backward compatibility support using ROCM-CMAKE wrapper functions.

#### Resolved issues

- Fixed compatibility with libfmt 8.1

### **rocSPARSE** (2.2.0)

#### Added

- batched SpMM for CSR, COO and Blocked ELL formats. 
- Packages for test and benchmark executables on all supported OSes using CPack.
- Clients file importers and exporters.

#### Changed

- Test adjustments due to roundoff errors.
- Fixing API calls compatiblity with rocPRIM.

#### Optimized

- Clients code size reduction.
- Clients error handling.
- Clients benchmarking for performance tracking.

### **rocThrust** (2.15.0)

#### Added

- Packages for tests and benchmark executable on all supported OSes using CPack.

### **rocWMMA** (0.7)

#### Added

- Added unit tests for DLRM kernels
- Added GEMM sample
- Added DLRM sample
- Added SGEMV sample
- Added unit tests for cooperative wmma load and stores
- Added unit tests for IOBarrier.h
- Added wmma load/ store  tests for different matrix types (A, B and Accumulator)
- Added more block sizes 1, 2, 4, 8 to test MmaSyncMultiTest
- Added block sizes 4, 8 to test MmaSynMultiLdsTest
- Added support for wmma load / store layouts with block dimension greater than 64
- Added IOShape structure to define the attributes of mapping and layouts for all wmma matrix types
- Added CI testing for rocWMMA

#### Changed

- Renamed wmma to rocwmma in cmake, header files and documentation
- Renamed library files
- Modified Layout.h to use different matrix offset calculations (base offset, incremental offset and cumulative offset)
- Opaque load/store continue to use incrementatl offsets as they fill the entire block
- Cooperative load/store use cumulative offsets as they fill only small portions for the entire block
- Increased Max split counts to 64 for cooperative load/store
- Moved all the wmma definitions, API headers to rocwmma namespace
- Modified wmma fill unit tests to validate all matrix types (A, B, Accumulator)

### **Tensile** (4.33.0)

#### Added

- TensileUpdateLibrary for updating old library logic files
- Support for TensileRetuneLibrary to use sizes from separate file
- ZGEMM DirectToVgpr/DirectToLds/StoreCInUnroll/MIArchVgpr support
- Tests for denorm correctness
- Option to write different architectures to different TensileLibrary files

#### Optimizations

- Optimize MessagePackLoadLibraryFile by switching to fread
- DGEMM tail loop optimization for PrefetchAcrossPersistentMode=1/DirectToVgpr

#### Changed

- Alpha/beta datatype remains as F32 for HPA HGEMM
- Force assembly kernels to not flush denorms
- Use hipDeviceAttributePhysicalMultiProcessorCount as multiProcessorCount

#### Resolved issues

- Fix segmentation fault when run i8 datatype with TENSILE_DB=0x80

## ROCm 5.1.3

See the [ROCm 5.1.3 changelog](https://github.com/ROCm/ROCm/blob/docs/5.1.3/CHANGELOG.md)
on GitHub for a complete overview of this release.

## ROCm 5.1.1

See the [ROCm 5.1.1 changelog](https://github.com/ROCm/ROCm/blob/docs/5.1.1/CHANGELOG.md)
on GitHub for a complete overview of this release.

## ROCm 5.1.0

See the [ROCm 5.1.0 changelog](https://github.com/ROCm/ROCm/blob/docs/5.1.0/CHANGELOG.md)
on GitHub for a complete overview of this release.

### **hipBLAS** (0.50.0)

#### Added

- Added library version and device information to hipblas-test output
- Added --rocsolver-path command line option to choose path to pre-built rocSOLVER, as
  absolute or relative path
- Added --cmake_install command line option to update cmake to minimum version if required
- Added cmake-arg parameter to pass in cmake arguments while building
- Added infrastructure to support readthedocs hipBLAS documentation.

#### Fixed

- Added hipblasVersionMinor define. hipblaseVersionMinor remains defined
  for backwards compatibility.
- Doxygen warnings in hipblas.h header file.

#### Changed

- rocblas-path command line option can be specified as either absolute or relative path
- Help message improvements in install.sh and rmake.py
- Updated googletest dependency from 1.10.0 to 1.11.0

### **hipCUB** (2.11.0)

#### Added

- Device segmented sort
- Warp merge sort, WarpMask and thread sort from cub 1.15.0 supported in hipCUB
- Device three way partition

#### Changed

- Device_scan and device_segmented_scan: inclusive_scan now uses the input-type as accumulator-type, exclusive_scan uses initial-value-type.
  - This particularly changes behaviour of small-size input types with large-size output types (e.g. short input, int output).
  - And low-res input with high-res output (e.g. float input, double output)
  - Block merge sort no longer supports non power of two blocksizes

### **hipFFT** (1.0.7)

#### Changed

- Use fft_params struct for accuracy and benchmark clients.

### **hipSOLVER** (1.3.0)

#### Added

- Added functions
  - gels
    - hipsolverSSgels_bufferSize, hipsolverDDgels_bufferSize, hipsolverCCgels_bufferSize, hipsolverZZgels_bufferSize
    - hipsolverSSgels, hipsolverDDgels, hipsolverCCgels, hipsolverZZgels
- Added library version and device information to hipsolver-test output.
- Added compatibility API with hipsolverDn prefix.
- Added compatibility-only functions
  - gesvdj
    - hipsolverDnSgesvdj_bufferSize, hipsolverDnDgesvdj_bufferSize, hipsolverDnCgesvdj_bufferSize, hipsolverDnZgesvdj_bufferSize
    - hipsolverDnSgesvdj, hipsolverDnDgesvdj, hipsolverDnCgesvdj, hipsolverDnZgesvdj
  - gesvdjBatched
    - hipsolverDnSgesvdjBatched_bufferSize, hipsolverDnDgesvdjBatched_bufferSize, hipsolverDnCgesvdjBatched_bufferSize, hipsolverDnZgesvdjBatched_bufferSize
    - hipsolverDnSgesvdjBatched, hipsolverDnDgesvdjBatched, hipsolverDnCgesvdjBatched, hipsolverDnZgesvdjBatched
  - syevj
    - hipsolverDnSsyevj_bufferSize, hipsolverDnDsyevj_bufferSize, hipsolverDnCheevj_bufferSize, hipsolverDnZheevj_bufferSize
    - hipsolverDnSsyevj, hipsolverDnDsyevj, hipsolverDnCheevj, hipsolverDnZheevj
  - syevjBatched
    - hipsolverDnSsyevjBatched_bufferSize, hipsolverDnDsyevjBatched_bufferSize, hipsolverDnCheevjBatched_bufferSize, hipsolverDnZheevjBatched_bufferSize
    - hipsolverDnSsyevjBatched, hipsolverDnDsyevjBatched, hipsolverDnCheevjBatched, hipsolverDnZheevjBatched
  - sygvj
    - hipsolverDnSsygvj_bufferSize, hipsolverDnDsygvj_bufferSize, hipsolverDnChegvj_bufferSize, hipsolverDnZhegvj_bufferSize
    - hipsolverDnSsygvj, hipsolverDnDsygvj, hipsolverDnChegvj, hipsolverDnZhegvj

#### Changed

- The rocSOLVER backend now allows hipsolverXXgels and hipsolverXXgesv to be called in-place when B == X.
- The rocSOLVER backend now allows rwork to be passed as a null pointer to hipsolverXgesvd.

#### Resolved issues

- bufferSize functions will now return HIPSOLVER_STATUS_NOT_INITIALIZED instead of HIPSOLVER_STATUS_INVALID_VALUE when both handle and lwork are null.
- Fixed rare memory allocation failure in syevd/heevd and sygvd/hegvd caused by improper workspace array allocation outside of rocSOLVER.

### **hipSPARSE** (2.1.0)

#### Added

- Added gtsv_interleaved_batch and gpsv_interleaved_batch routines
- Add SpGEMM_reuse

#### Changed

- Changed BUILD_CUDA with USE_CUDA in install script and cmake files
- Update googletest to 11.1

#### Resolved issues

- Fixed a bug in SpMM Alg versioning

### **RCCL** (2.11.4)

#### Added

- Compatibility with NCCL 2.11.4

#### Known issues

- Managed memory is not currently supported for clique-based kernels

### **rocALUTION** (2.0.2)

#### Added

- Added out-of-place matrix transpose functionality
- Added LocalVector&lt;bool&gt;

### **rocBLAS** (2.43.0)

#### Added

- Option to install script for number of jobs to use for rocBLAS and Tensile compilation (-j, --jobs)
- Option to install script to build clients without using any Fortran (--clients_no_fortran)
- rocblas_client_initialize function, to perform rocBLAS initialize for clients(benchmark/test) and report the execution time.
- Added tests for output of reduction functions when given bad input
- Added user specified initialization (rand_int/trig_float/hpl) for initializing matrices and vectors in rocblas-bench

#### Changed

- For syrkx and trmm internal API use rocblas_stride datatype for offset
- For non-batched and batched gemm_ex functions if the C matrix pointer equals the D matrix pointer (aliased) their respective type and leading dimension arguments must now match
- Test client dependencies updated to GTest 1.11
- non-global false positives reported by cppcheck from file based suppression to inline suppression. File based suppression will only be used for global false positives.
- Help menu messages in install.sh
- For ger function, typecast the &#39;lda&#39;(offset) datatype to size_t during offset calculation to avoid overflow and remove duplicate template functions.
- Modified default initialization from rand_int to hpl for initializing matrices and vectors in rocblas-bench

#### Optimized

- Improved performance of trsm with side == left and n == 1
- Improved perforamnce of trsm with side == left and m &lt;= 32 along with side == right and n &lt;= 32

#### Resolved issues

- For function trmv (non-transposed cases) avoid overflow in offset calculation
- Fixed cppcheck errors/warnings
- Fixed doxygen warnings

### **rocFFT** (1.0.16)

#### Changed

- Supported unaligned tile dimension for SBRC_2D kernels.
- Improved (more RAII) test and benchmark infrastructure.
- Enabled runtime compilation of length-2304 FFT kernel during plan creation.

#### Removed

- The hipFFT API (header) has been removed from after a long deprecation period.  Please use the [hipFFT](https://github.com/ROCmSoftwarePlatform/hipFFT) package/repository to obtain the hipFFT API.

#### Optimized

- Optimized more large 1D cases by using L1D_CC plan.
- Optimized 3D 200^3 C2R case.
- Optimized 1D 2^30 double precision on MI200.

#### Resolved issues

- Fixed correctness of some R2C transforms with unusual strides.

### **rocPRIM** (2.10.13)

#### Added

- Future value
- Added device partition_three_way to partition input to three output iterators based on two predicates

#### Changed

- The reduce/scan algorithm precision issues in the tests has been resolved for half types.

#### Resolved issues

- Fixed radix sort int64_t bug introduced in [2.10.11]

#### Known issues

- device_segmented_radix_sort unit test failing for HIP on Windows

### **rocRAND** (2.10.13)

#### Added

- Generating a random sequence different sizes now produces the same sequence without gaps
  indepent of how many values are generated per call.
  - Only in the case of XORWOW, MRG32K3A, PHILOX4X32_10, SOBOL32 and SOBOL64
  - This only holds true if the size in each call is a divisor of the distributions
    `output_width` due to performance
  - Similarly the output pointer has to be aligned to `output_width * sizeof(output_type)`

#### Changed

- [hipRAND](https://github.com/ROCmSoftwarePlatform/hipRAND.git) split into a separate package
- Header file installation location changed to match other libraries.
  - Using the `rocrand.h` header file should now use `#include &lt;rocrand/rocrand.h&gt;`, rather than `#include &lt;rocrand/rocrand.h&gt;`
- rocRAND still includes hipRAND using a submodule
  - The rocRAND package also sets the provides field with hipRAND, so projects which require hipRAND can begin to specify it.

#### Resolved issues

- Fix offset behaviour for XORWOW, MRG32K3A and PHILOX4X32_10 generator, setting offset now
  correctly generates the same sequence starting from the offset.
  - Only uniform int and float will work as these can be generated with a single call to the generator

#### Known issues

- kernel_xorwow unit test is failing for certain GPU architectures.

### **rocSOLVER** (3.17.0)

#### Optimized

- Optimized non-pivoting and batch cases of the LU factorization

#### Resolved issues

- Fixed missing synchronization in SYTRF with `rocblas_fill_lower` that could potentially
  result in incorrect pivot values.
- Fixed multi-level logging output to file with the `ROCSOLVER_LOG_PATH`,
  `ROCSOLVER_LOG_TRACE_PATH`, `ROCSOLVER_LOG_BENCH_PATH` and `ROCSOLVER_LOG_PROFILE_PATH`
  environment variables.
- Fixed performance regression in the batched LU factorization of tiny matrices

### **rocSPARSE** (2.1.0)

#### Added

- gtsv_interleaved_batch 
- gpsv_interleaved_batch
- SpGEMM_reuse
- Allow copying of mat info struct

#### Optimized

- Optimization for SDDMM
- Allow unsorted matrices in csrgemm multipass algorithm

### **rocThrust** (2.14.0)

rocThrust 2.14.0 for ROCm 5.1.0

#### Added

- Updated to match upstream Thrust 1.15.0

#### Known issues

- async_copy, partition, and stable_sort_by_key unit tests are failing on HIP on Windows.

### **Tensile** (4.32.0)

Tensile 4.32.0 for ROCm 5.1.0

#### Added

- Better control of parallelism to control memory usage
- Support for multiprocessing on Windows for TensileCreateLibrary
- New JSD metric and metric selection functionality
- Initial changes to support two-tier solution selection

#### Changed

- Update Googletest to 1.11.0

##### Removed

- Removed no longer supported benchmarking steps

#### Optimized

- Optimized runtime of TensileCreateLibraries by reducing max RAM usage
- StoreCInUnroll additional optimizations plus adaptive K support
- DGEMM NN optimizations with PrefetchGlobalRead(PGR)=2 support

## ROCm 5.0.2

See the [ROCm 5.0.2 changelog](https://github.com/ROCm/ROCm/blob/docs/5.0.2/CHANGELOG.md)
on GitHub for a complete overview of this release.

## ROCm 5.0.1

See the [ROCm 5.0.1 changelog](https://github.com/ROCm/ROCm/blob/docs/5.0.1/CHANGELOG.md)
on GitHub for a complete overview of this release.

## ROCm 5.0.0

See the [ROCm 5.0.0 changelog](https://github.com/ROCm/ROCm/blob/docs/5.0.0/CHANGELOG.md)
on GitHub for a complete overview of this release.

### **hipBLAS** (0.49.0)

#### Added

- Added rocSOLVER functions to hipblas-bench
- Added option ROCM_MATHLIBS_API_USE_HIP_COMPLEX to opt-in to use hipFloatComplex and hipDoubleComplex
- Added compilation warning for future trmm changes
- Added documentation to hipblas.h
- Added option to forgo pivoting for getrf and getri when ipiv is nullptr
- Added code coverage option

#### Resolved issues

- Fixed use of incorrect &#39;HIP_PATH&#39; when building from source.
- Fixed windows packaging
- Allowing negative increments in hipblas-bench
- Removed boost dependency

### **hipCUB** (2.10.13)

#### Added

- Bfloat16 support to test cases (device_reduce &amp; device_radix_sort)
- Device merge sort
- Block merge sort
- API update to CUB 1.14.0

#### Changed

- The SetupNVCC.cmake automatic target selector select all of the capabalities of all available card for NVIDIA backend.

#### Resolved issues

- Added missing includes to hipcub.hpp

### **hipFFT** (1.0.4)

#### Fixed

- Add calls to rocFFT setup/cleanup.
- Cmake fixes for clients and backend support.

#### Added

- Added support for Windows 10 as a build target.

### **hipSOLVER** (1.2.0)

#### Added

- Added functions
  - sytrf
    - hipsolverSsytrf_bufferSize, hipsolverDsytrf_bufferSize, hipsolverCsytrf_bufferSize, hipsolverZsytrf_bufferSize
    - hipsolverSsytrf, hipsolverDsytrf, hipsolverCsytrf, hipsolverZsytrf

#### Resolved issues

- Fixed use of incorrect `HIP_PATH` when building from source (#40).

### **hipSPARSE** (2.0.0)

#### Added

- Added (conjugate) transpose support for csrmv, hybmv and spmv routines

### **RCCL** (2.10.3)

#### Added

- Compatibility with NCCL 2.10.3

#### Known issues

- Managed memory is not currently supported for clique-based kernels

### **rocALUTION** (2.0.1)

#### Changed

- Removed deprecated GlobalPairwiseAMG class, please use PairwiseAMG instead.
- Changed to C++ 14 Standard

#### Optimized

- Added sanitizer option
- Improved documentation

### **rocBLAS** (2.42.0)

#### Added

- Added rocblas_get_version_string_size convenience function
- Added rocblas_xtrmm_outofplace, an out-of-place version of rocblas_xtrmm
- Added hpl and trig initialization for gemm_ex to rocblas-bench
- Added source code gemm. It can be used as an alternative to Tensile for debugging and development
- Added option ROCM_MATHLIBS_API_USE_HIP_COMPLEX to opt-in to use hipFloatComplex and hipDoubleComplex

#### Changed

- Instantiate templated rocBLAS functions to reduce size of librocblas.so
- Removed static library dependency on msgpack
- Removed boost dependencies for clients

#### Optimized

- Improved performance of non-batched and batched single-precision GER for size m &gt; 1024. Performance enhanced by 5-10% measured on a MI100 (gfx908) GPU.
- Improved performance of non-batched and batched HER for all sizes and data types. Performance enhanced by 2-17% measured on a MI100 (gfx908) GPU.

#### Resolved issues

- Option to install script to build only rocBLAS clients with a pre-built rocBLAS library
- Correctly set output of nrm2_batched_ex and nrm2_strided_batched_ex when given bad input
- Fix for dgmm with side == rocblas_side_left and a negative incx
- Fixed out-of-bounds read for small trsm
- Fixed numerical checking for tbmv_strided_batched

### **rocFFT** (1.0.13)

#### Added

- Added new kernel generator for select fused-2D transforms.

#### Optimized

- Improved many plans by removing unnecessary transpose steps.
- Optimized scheme selection for 3D problems.
  - Imposed less restrictions on 3D_BLOCK_RC selection. More problems can use 3D_BLOCK_RC and
    have some performance gain.
  - Enabled 3D_RC. Some 3D problems with SBCC-supported z-dim can use less kernels and get benefit.
  - Force --length 336 336 56 (dp) use faster 3D_RC to avoid it from being skipped by conservative
    threshold test.
- Optimized some even-length R2C/C2R cases by doing more operations
  in-place and combining pre/post processing into Stockham kernels.
- Added radix-17.

#### Resolved issues

- Improved large 1D transform decompositions.

### **rocPRIM** (2.10.12)

#### Added

- Added scan size limit feature
- Added reduce size limit feature
- Added transform size limit feature
- Add block_load_striped and block_store_striped
- Add gather_to_blocked to gather values from other threads into a blocked arrangement
- The block sizes for device merge sorts initial block sort and its merge steps are now separate in its kernel config
    - the block sort step supports multiple items per thread

#### Changed

- size_limit for scan, reduce and transform can now be set in the config struct instead of a parameter
- Device_scan and device_segmented_scan: `inclusive_scan` now uses the input-type as accumulator-type, `exclusive_scan` uses initial-value-type.
  - This particularly changes behaviour of small-size input types with large-size output types (e.g. `short` input, `int` output).
  - And low-res input with high-res output (e.g. `float` input, `double` output)
- Revert old Fiji workaround, because they solved the issue at compiler side
- Update README cmake minimum version number
- Block sort support multiple items per thread
    - currently only powers of two block sizes, and items per threads are supported and only for full blocks
- Bumped the minimum required version of CMake to 3.16

#### Resolved issues

- Enable bfloat16 tests and reduce threshold for bfloat16
- Fix device scan limit_size feature
- Non-optimized builds no longer trigger local memory limit errors

#### Known issues

- Unit tests may soft hang on MI200 when running in hipMallocManaged mode.
- device_segmented_radix_sort, device_scan unit tests failing for HIP on Windows
- ReduceEmptyInput cause random faulire with bfloat16

### **rocSOLVER** (3.16.0)

#### Added

- Symmetric matrix factorizations:
    - LASYF
    - SYTF2, SYTRF (with batched and strided\_batched versions)
- Added `rocsolver_get_version_string_size` to help with version string queries
- Added `rocblas_layer_mode_ex` and the ability to print kernel calls in the trace and profile logs
- Expanded batched and strided\_batched sample programs.

#### Changed

- The rocsolver-test client now prints the rocSOLVER version used to run the tests,
  rather than the version used to build them
- The rocsolver-bench client now prints the rocSOLVER version used in the benchmark

#### Optimized

- Improved general performance of LU factorization
- Increased parallelism of specialized kernels when compiling from source, reducing build times on multi-core systems.

#### Resolved issues

- Added missing `stdint.h` include to `rocsolver.h`

### **rocSPARSE** (2.0.0)

#### Added

- csrmv, coomv, ellmv, hybmv for (conjugate) transposed matrices
- csrmv for symmetric matrices

#### Changed

- spmm\_ex is now deprecated and will be removed in the next major release
- Optimization for gtsv

### **rocThrust** (2.13.0)

#### Added

- Updated to match upstream Thrust 1.13.0
- Updated to match upstream Thrust 1.14.0
- Added async scan

#### Changed

- Scan algorithms: `inclusive_scan` now uses the input-type as accumulator-type, `exclusive_scan` uses initial-value-type.
    - This particularly changes behaviour of small-size input types with large-size output types (e.g. `short` input, `int` output).
    - And low-res input with high-res output (e.g. `float` input, `double` output)

### **Tensile** (4.31.0)

#### Added

- DirectToLds support (x2/x4)
- DirectToVgpr support for DGEMM
- Parameter to control number of files kernels are merged into to better parallelize kernel compilation
- FP16 alternate implementation for HPA HGEMM on aldebaran

#### Changed

- Update tensile_client executable to std=c++14

#### Removed

- Remove unused old Tensile client code

#### Optimized

- Add DGEMM NN custom kernel for HPL on aldebaran

#### Resolved issues

- Fixed `hipErrorInvalidHandle` during benchmarks
- Fixed `addrVgpr` for atomic GSU
- Fixed for Python 3.8: add case for Constant nodeType
- Fixed architecture mapping for gfx1011 and gfx1012
- Fixed `PrintSolutionRejectionReason` verbiage in `KernelWriter.py`
- Fixed vgpr alignment problem when enabling flat buffer load
