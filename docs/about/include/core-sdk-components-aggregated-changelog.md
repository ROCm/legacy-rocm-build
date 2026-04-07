#### **AMD SMI (BM)** (26.4.0)

##### Added

* **Added APU metrics support (table versions 2.4 and 3.0)**.
  * New `amdsmi_apu_metrics_t` struct accessible via `amdsmi_gpu_metrics_t.apu_metrics` pointer (non-null when APU-specific metrics are available).
  * **v2.4 metrics**:
    * `temperature_gfx`, `temperature_soc`, `temperature_core[8]`, `temperature_l3[2]`
    * `average_gfx_activity`, `average_mm_activity`
    * `average_socket_power`, `average_cpu_power`, `average_soc_power`, `average_gfx_power`, `average_core_power[8]`
    * Average clocks: `gfxclk`, `socclk`, `uclk`, `fclk`, `vclk`, `dclk`
    * Current clocks: `gfxclk`, `socclk`, `uclk`, `fclk`, `vclk`, `dclk`, `coreclk[8]`, `l3clk[2]`
    * `average_temperature_gfx`, `average_temperature_soc`, `average_temperature_core[8]`, `average_temperature_l3[2]`
    * `average_cpu_voltage`, `average_soc_voltage`, `average_gfx_voltage`, `average_cpu_current`, `average_soc_current`, `average_gfx_current`
    * `throttle_status`, `indep_throttle_status`
    * `fan_pwm`
  * **v3.0 metrics**:
    * `temperature_core[16]`, `temperature_skin`
    * `average_vcn_activity`, `average_ipu_activity[8]`, `average_core_c0_activity[16]`
    * `average_dram_reads`, `average_dram_writes`, `average_ipu_reads`, `average_ipu_writes`
    * `average_apu_power`, `average_dgpu_power`, `average_all_core_power`, `average_ipu_power`, `average_sys_power`
    * `stapm_power_limit`, `current_stapm_power_limit`
    * `average_core_power[16]`, `current_coreclk[16]`
    * `current_core_maxfreq`, `current_gfx_maxfreq`
    * `average_vpeclk_frequency`, `average_ipuclk_frequency`, `average_mpipu_frequency`
    * `throttle_residency_prochot`, `throttle_residency_spl`, `throttle_residency_fppt`, `throttle_residency_sppt`, `throttle_residency_thm_core`, `throttle_residency_thm_gfx`, `throttle_residency_thm_soc`
    * `time_filter_alphavalue`
  * Fields not applicable to the current version are set to sentinel values: `0xFFFF` for `uint16_t`, `0xFFFFFFFF` for `uint32_t`, and `UINT64_MAX` for `uint64_t` fields.
  * Python bindings updated with `AmdSmiApuMetrics` ctypes structure.

* **Added `oam_id` to `amdsmi_enumeration_info_t`**.
  * `amd-smi list -e` now displays `OAM_ID` (Physical XGMI ID / OAM ID).
  * Added `--enumeration` as a long-form alias for `-e` in `amd-smi list`.

* **Added support for GPU metrics v1.9 new fields**.
  * Added new temperature fields to `amdsmi_gpu_metrics_t`:
    * `temperature_hbm_stacks` — per-stack HBM temperatures (°C)
    * `temperature_mid` — per-MID temperatures (°C)
    * `temperature_aid` — per-AID temperatures (°C)
    * `temperature_xcd` — per-XCC compute die temperatures (°C)
  * Added new per-die clock fields to `amdsmi_gpu_metrics_t`:
    * `current_uclk_aid` — per-AID uclk (MHz)
    * `current_socclks_mid` — per-MID SOC clock (MHz)
  * Added new constants:
    * `AMDSMI_MAX_NUM_HBM_STACKS` (12)
    * `AMDSMI_MAX_NUM_AID` (2)
    * `AMDSMI_MAX_NUM_MID` (2)
    * `AMDSMI_MAX_NUM_CLKS_PER_AID` (2)
    * `AMDSMI_MAX_NUM_CLKS_PER_MID` (2)

* **Added VRAM and GTT tuning interface**.
  * New `amd-smi static --mem-carveout` to view VRAM carveout options.
  * New `amd-smi set --mem-carveout` to change the VRAM carveout (APU).
  * New `amd-smi set --gtt` and `amd-smi reset --gtt` for system-wide GTT size tuning.
  * New APIs: `amdsmi_get_gpu_uma_carveout_info()`, `amdsmi_set_gpu_uma_carveout()`, `amdsmi_get_ttm_info()`, `amdsmi_set_ttm_pages_limit()`, `amdsmi_reset_ttm_pages_limit()`.

* **Added UBB power and power_limit fields to `amdsmi_power_info_t` and `amdsmi_npm_info_t`**.
  * `amd-smi metric --power` now displays `ubb_power` when available.
  * `amd-smi node -p` now displays UBB power threshold when available.

* **Added CPU support for family 1A Models 50h-57h**.
  * New APIs: `amdsmi_get_cpu_xgmi_pstate_range()`, `amdsmi_get_cpu_core_ccd_power()`, `amdsmi_get_cpu_tdelta()`, `amdsmi_get_cpu_dimm_sb_reg()`, `amdsmi_get_cpu_svi3_vr_controller_temp()`, `amdsmi_get_cpu_pc6_enable()`, `amdsmi_get_cpu_cc6_enable()`, `amdsmi_get_cpu_sdps_limit()`, `amdsmi_get_cpu_core_floor_freq_limit()`, `amdsmi_get_cpu_core_eff_floor_freq_limit()`, and corresponding set APIs.
  * **Note**: `amdsmi_get_dfc_ctrl()` renamed to `amdsmi_get_cpu_dfc_ctrl()` and `amdsmi_set_dfc_ctrl()` renamed to `amdsmi_set_cpu_dfc_ctrl()` for naming consistency.

* **Updated memory API documentation**
    Added note that the sum of per-process memory usage is not expected to equal total usage.

##### Changed

* **Renamed `processor_type_t` enum typedef to `amdsmi_processor_type_t`**.
  * The unprefixed typedef name did not follow the `amdsmi_*_t` convention used throughout `amdsmi.h` and was easy to collide with identifiers defined by other system-management libraries. New code should use `amdsmi_processor_type_t`. The old name is preserved as a backward-compatibility typedef alias, so existing callers continue to compile unchanged.

* **Package install no longer modifies the system-wide `logrotate` timer or cron schedule**.
  * Previously, installing `amd-smi-lib` overwrote `/lib/systemd/system/logrotate.timer` (or moved `/etc/cron.daily/logrotate` to `/etc/cron.hourly/`) to force hourly rotation, which affected every other package using `logrotate`.
  * The package now only ships `/etc/logrotate.d/amd_smi.conf`, which sets its own `hourly` + `size 1M` cadence. AMD-SMI logs still rotate at the same frequency; system-wide settings stay as the distribution configured them.

##### Optimized

* **Optimized `rsmi_dev_device_identifiers_get()` in the ROCm-SMI device layer**.
  * Removed unnecessary iteration by directly indexing the device list.
  * Added bounds checking for `device_id`, with clearer error handling/logging.
  * Improves performance for device identifier queries.

##### Resolved issues

* **Fixed `amd-smi metric` crashing with `TypeError` on MI300A when no CPU flags are specified**.
  * When no CPU arguments are passed, `metric_cpu()` sets all boolean CPU args to `True` to display all available data. `--cpu-svi3-vr-controller-temp` takes a TYPE argument (and optional RAIL_INDEX) rather than a boolean flag — setting it to `True` caused a `TypeError` crash when the code tried to subscript it with `[0][0]`. Added `cpu_svi3_vr_controller_temp` to the show-all exclusion list, following the existing pattern for `cpu_lclk_dpm_level`, `cpu_io_bandwidth`, `cpu_dimm_sb_reg`, and similar argument-taking flags.

* **Fixed `amdsmi_get_gpu_accelerator_partition_profile()` returning incorrect `num_partitions` when `num_partition` is unavailable from GPU metrics**.
  * GPU metrics no longer always provides `num_partition`. The function now derives the partition count from the active partition type when `num_partition` is not available:
    * SPX → 1, DPX → 2, TPX → 3, QPX → 4
    * CPX → derived from the XCD counter via `amdsmi_get_gpu_xcd_counter()`

* **Fixed `amdsmi_topo_get_p2p_status()` returning a raw `ctypes.c_uint32` object instead of an integer for the `type` field**.
  * The `'type'` key in the returned dictionary now correctly returns `type_32.value` (an `int`) rather than the unwrapped ctypes object, consistent with the pattern used in `amdsmi_topo_get_link_type()`.

* **Adjusted KFD process caching to be more responsive**.
  * Updated process caching to allow cache duration adjustment via the `AMDSMI_PROCESS_INFO_CACHE_MS` environment variable for workflows with rapid metric polling.

* **Fixed CLI exit codes to use absolute values**.
  * Invalid GPU parameters now return positive error codes as documented.

* **Fixed CLI breakage when `amdgpu` driver is not present**.
  * Improved init to better catch driver loading issues.

* **Aligned `amdsmi_get_gpu_device_uuid()` with HIP/rocminfo UUID format**.
  * Modified `amdsmi_asic_info_t.asic_serial` to report per-socket serial using KFD's `unique_id`.

* **Fixed multiple bugs in NIC/switch code and `amdsmi_init()` NIC handling**.
  * Fixed `sizeof` operator precedence, `hw_mon` reset, NUMA=65535 handling, and several CLI function call errors.
  * Fixed `amdsmi_init()` to succeed when no NIC hardware is present.

* **Fixed shared mutex and self-heal**.
  * Improved self-heal logic to correctly identify and recover from corrupted or uninitialized mutex state.

* **Fixed `cu_occupancy` displaying `0%` instead of `N/A` when file is unavailable**.
  * Process `cu_occupancy` is now initialized to `INVALID` instead of zero, so `amd-smi process` displays `N/A` rather than a misleading `0%` when the sysfs file is not accessible.

* **Fixed CLI set commands silently succeeding on invalid input values**.
  * `amd-smi set --profile <INVALID>` now returns a non-zero exit code and lists available profiles in the error message; invalid profile names are rejected at parse time.
  * `amd-smi set --clk-level <CLK_TYPE>` (missing performance level indices) now returns a non-zero exit code with a usage hint instead of silently succeeding.
  * `amd-smi set --power-cap <OUT_OF_RANGE>` now returns a non-zero exit code.
  * `amd-smi set --fan <INVALID>%` no longer prompts the out-of-spec warning before validating the percentage range; invalid values are rejected immediately.

* **Fixed `amd-smi set --profile` help text omitting `BOOTUP_DEFAULT`**.
  * `BOOTUP_DEFAULT` was always accepted at runtime but was missing from the `--help` profile list. Auditing invalid-input handling exposed this gap. `amd-smi reset --profile` can also be used to return to the bootup default power profile.

* **Fixed `amd-smi monitor --brcm_nic` and `--brcm_switch` flags being registered on non-BRCM systems**.
  * These flags are now only registered when BRCM hardware is present, preventing spurious failures on AMD GPU-only systems.

* **Fixed `amd-smi` default command alignment**.
  * Updated default `amd-smi` output to align values to the left for improved readability.
    Several items were misaligned in the default output, and this change ensures a consistent left-aligned format across all fields.
  * *This change is purely cosmetic and does not affect any functionality.*

* **Renamed `lc_perf_other_end_recovery` to `lc_perf_other_end_recovery_count` in `amd-smi metric` CLI output for unification**.

* **Removed references to deprecated `amd-smi reset -r`**.
  * CLI help text and memory partition change warnings no longer reference `amd-smi reset -r` for driver reloading.
  * Users are now directed to use `sudo modprobe -r amdgpu && sudo modprobe amdgpu` to reload the driver after partition changes.

* **Changed CPU power APIs to return values in milliwatts (mW) for higher precision**.
  * Removed lossy integer rounding (`(mW + 500) / 1000`) from 6 CPU power get APIs. Values are now
    returned in milliwatts directly from the ESMI library, preserving sub-watt precision.
  * **C API**: Output parameter type remains `uint32_t*`, but the unit changed from watts to milliwatts (mW).
    * `amdsmi_get_cpu_socket_power`
    * `amdsmi_get_cpu_socket_power_cap`
    * `amdsmi_get_cpu_socket_power_cap_max`
    * `amdsmi_get_cpu_pwr_efficiency_mode` (ppt_limit field)
    * `amdsmi_get_cpu_core_ccd_power`
    * `amdsmi_get_cpu_sdps_limit`
  * **Python API (breaking)**: These functions now return `int` (milliwatts) instead of `str` (e.g., `"240 Watts"`).
    Callers that parsed the string output must update to handle the numeric return value.
  * **CLI output**: Power values now display with milliwatt precision (e.g., `240.500 Watts`).
  * Added missing null-pointer validation for output parameters in `amdsmi_get_cpu_socket_power_cap`
    and `amdsmi_get_cpu_socket_power_cap_max`.
  * Updated header documentation to specify milliwatt units for all affected get and set API parameters.

* **Changed power APIs to have consistent output parameter types**.
  * Modified 6 CPU power APIs to have consistent output power types. All set and get APIs have `uint32_t` output values.
  * Modified get and set APIs that had double output types to have `uint32_t` output types in milliwatts (mW).
    * `amdsmi_get_cpu_socket_power(amdsmi_processor_handle processor_handle, uint32_t* ppower)`
    * `amdsmi_get_cpu_socket_power_cap(amdsmi_processor_handle processor_handle, uint32_t* pcap)`
    * `amdsmi_get_cpu_socket_power_cap_max(amdsmi_processor_handle processor_handle, uint32_t* pmax)`
    * `amdsmi_get_cpu_pwr_efficiency_mode(amdsmi_processor_handle processor_handle, uint32_t* power_efficiency_mode, uint32_t* utilization, uint32_t* ppt_limit)`
    * `amdsmi_get_cpu_core_ccd_power(amdsmi_processor_handle processor_handle, uint32_t* power)`
    * `amdsmi_get_cpu_sdps_limit(amdsmi_processor_handle processor_handle, uint32_t* sdps_limit)`

#### **Composable Kernel** (1.3.0)

##### Added

* Added overload of `load_tile_transpose` that takes reference to output tensor as output parameter.
* Use data type from LDS tensor view when determining tile distribution for transpose in the GEMM pipeline.
* Added `eightwarps` support for abquant mode in blockscale GEMM.
* Added `preshuffleB` support for abquant mode in blockscale GEMM.
* Added support for explicit GEMM in `CK_TILE` grouped convolution forward and backward weight.
* Added TF32 convolution support on gfx942 and gfx950 in CK. It can be enabled or disabled via `DTYPES` of `tf32`.
* Added `streamingllm` sink support for FMHA FWD, include `qr_ks_vs`, `qr_async` and `splitkv` pipelines.
* Added support for microscaling (MX) FP8/FP4 mixed data types to Flatmm pipeline.
* Added support for fp8 dynamic tensor-wise quantization of FP8 fmha fwd kernel.
* Added FP8 KV cache support for FMHA batch prefill.
* Added FMHA batch prefill kernel support for several KV cache layouts, flexible page sizes, and different lookup table configurations.
* Added gpt-oss sink support for FMHA FWD, include `qr_ks_vs`, `qr_async`, `qr_async_trload` and `splitkv` pipelines.
* Added persistent async input scheduler for CK Tile universal GEMM kernels to support asynchronous input streaming.
* Added FP8 block scale quantization for FMHA forward kernel.
* Added gfx11xx support for FMHA.
* Added microscaling (MX) FP8/FP4 support on gfx950 for FMHA forward kernel (`qr` pipeline only).
* Added FP8 per-tensor quantization support for FMHA forward V3 pipeline on gfx950.

#### **HIP** (7.13)

##### Added

* New HIP APIs
  * `cooperative_groups::reduce()` allows calling reduce operators on `thread_block_tile` and `coalesced_threads`. The implementation is based on the `__reduce_*_sync` operations, so the macro `HIP_ENABLE_EXTRA_WARP_SYNC_TYPES` might be needed to unlock some optimizations.
* New device attribute `hipDeviceAttributeGPUDirectRDMAWithHipVMMSupported`, indicating support for GPU Direct RDMA when using HIP VMM. This attribute corresponds to the CUDA `CU_DEVICE_ATTRIBUTE_GPU_DIRECT_RDMA_WITH_CUDA_VMM_SUPPORTED`.

##### Resolved issues

* A segmentation fault that occurred in child graphs during the graph‑launch phase. The issue originated from the entire graph being launched solely according to the parent graph’s scheduling logic. The HIP runtime now introduces a per‑graph segment‑scheduling control flag and propagates the parent graph’s scheduling mode to its child graphs, ensuring consistent scheduling behavior (classic vs. segment) and preventing failures when the parent falls back to classic scheduling.
* A segmentation fault caused by passing a null pointer to the hipMemGetAddressRange API. The function now handles null pointers correctly, matching the behavior of the corresponding CUDA API.

##### Changed

* `__reduce_and_sync()`, `__reduce_or_sync()` and `__reduce_xor_sync()` now provide a consistent behavior for all mask values and with CUDA. Previously, some masks were translated into bitwise operations, but others were not (such as those containing "holes"). Now, all masks cause bitwise instructions to be emitted. This is a change in behavior compared to previous versions.

##### Optimized

* Improved HIP runtime error logging when an application's fat binary does not include a compatible code object for the detected GPU architecture, offering clearer guidance to rebuild with the appropriate `--offload-arch=gfxXXXX` option.

* Enables in‑memory and background‑thread asynchronous logging in the HIP runtime by default to improve overall logging capability. This behavior can be disabled by setting the environment variable `AMD_LOG_ASYNC=0`.

#### **hipBLAS** (3.4.0)

##### Added

* gfx1250 and gfx90c support to clients.
* Version and other properties to Windows `hipblas.dll`.
* Support for `OpenBLAS` ILP64-based API usage in clients.

##### Resolved issues

* Restored the fallback of using the deprecated rocBLAS API `rocblas_set_device_memory_size` if allocations are failing.

#### **hipBLASLt** (1.3.0)

##### Added

* General Batched GEMM support.

##### Changed

* Replaced `install.sh` with an invoke-based task runner (`tasks.py`) to support cross-platform builds including Windows (ROCm 7.0+).
* `gtest` and `msgpack-cxx` are now fetched automatically using CMake FetchContent if not found on the system.

#### **hipCUB** (4.4.0)

##### Optimized

* Reduced build times for unit tests.

##### Resolved issues

* Fixed more memory leak issues with some unit tests.

#### **hipFFT** (1.0.23)

##### Added

* hipFFTW plan creation functions for advanced and general plans:
  * `fftw_plan_many_dft`
  * `fftwf_plan_many_dft`
  * `fftw_plan_many_dft_r2c`
  * `fftwf_plan_many_dft_r2c`
  * `fftw_plan_many_dft_c2r`
  * `fftwf_plan_many_dft_c2r`
  * `fftw_plan_guru_dft`
  * `fftwf_plan_guru_dft`
  * `fftw_plan_guru_dft_r2c`
  * `fftwf_plan_guru_dft_r2c`
  * `fftw_plan_guru_dft_c2r`
  * `fftwf_plan_guru_dft_c2r`
  * `fftw_plan_guru64_dft`
  * `fftwf_plan_guru64_dft`
  * `fftw_plan_guru64_dft_r2c`
  * `fftwf_plan_guru64_dft_r2c`
  * `fftw_plan_guru64_dft_c2r`
  * `fftwf_plan_guru64_dft_c2r`
* Support for gfx1150 architecture.

##### Changed

* Moved library to C++20 standard.
* Removed Boost as a dependency for clients and samples.
* Callback functions will be deprecated in a future release.

##### Resolved issues

* Fixed potential launch failure of data generation kernels in test and benchmark programs.

#### **hipRAND** (3.3.0)

##### Added

* `hiprand.dll` now contains embedded file version metadata.

#### **hipSOLVER** (3.4.0)

##### Added

* Compatibility-only functions:
  * `geev`
    * `hipsolverDnXgeev_bufferSize`
    * `hipsolverDnXgeev`
  * `syevBatched`
    * `hipsolverDnXsyevBatched_bufferSize`
    * `hipsolverDnXsyevBatched`
  * `syevd`
    * `hipsolverDnXsyevd_bufferSize`
    * `hipsolverDnXsyevd`
  * `sytrs`
    * `hipsolverDnXsytrs_bufferSize`
    * `hipsolverDnXsytrs`

#### **hipSPARSELt** (0.2.8)

##### Added

* CTest and test categories support (`--smoke`, `--pre_checkin`, and `--nightly`).

##### Optimized

* Provided more kernels for the `FP16`, `BF16`, and `Int8` datatypes.
* Improved the performance of the `HIPSPARSELT_PRUNE_SPMMA_TILE` function.

##### Resolved issues

* Fixed incorrect behavior when retrieving the PCI chip ID.
* Fixed LDS out-of-bounds read in `prune_tile_kernel`.
* Fixed out-of-bounds access for compress function test cases.
* Fixed missing null terminator in the return value of `hipsparseLtGetArchName()`.
* Fixed incorrect CPU result when `bias_type` is `BF16` for spmm test cases.
* Fixed double-free issue in the example code `example_prune_strip`.
* Fixed symbol interposition in the hipSPARSELt library.

#### **MIOpen** (3.5.1)

##### Added

* Added `MIOPEN_LOG_BUFFER_SIZE` option: when set to non-zero, dumps recent MIOpen logs to file on error.
* [Conv] Added `ConvDepthwiseFwd3D` solver for optimizing specific 3D depthwise convolutions.
* [Conv] Added NHWC layout support for Winograd convolution solvers.
* [Conv] Added regular GEMM solver support for Conv3D forward and backward-data with 1x1x1 filters.
* [Conv] Added configurable problem size threshold (`MIOPEN_CONV_DIRECT_MAX_SIZE`) for direct solver.
* [Softmax] Added tuning support via Generic Search.

##### Changed

* [Conv] Improved default kernel selection for Composable Kernel (CK) convolution solvers with ranked shortlists.
* [Conv] Split CK grouped convolution kernels into per-architecture runtime-loaded dynamic libraries.

##### Optimized

* Optimized transpose operations with tiled and vectorized variants for NCHW/NHWC conversions.
* [BatchNorm] Optimized batchnorm reduction using warp shuffle intrinsics.
* [Conv] Added heuristic filtering of slow GEMM solver configurations during tuning.

##### Deprecated

* [Conv] Deprecated CK non-grouped convolution forward and backward solvers.
* Deprecated `miopenConvolutionBackwardBias`: the underlying OpenCL kernel (`MIOpenConvBwdBias.cl`) has been removed. The function now returns `miopenStatusNotImplemented` and will be removed in a future release.

##### Removed

* Removed GraphAPI experimental feature and related code.

##### Resolved issues

* [Conv] Fixed Winograd Fury grouped convolution correctness on gfx12xx when G > 1.
* [Conv] Fixed bf16 WrW convolution precision loss in inter-batch accumulation.
* [Conv] Fixed GPU memory fault in Winograd v3.0 WrW solver for large tensor shapes.
* Fixed BF16 `abs` function precision error caused by unnecessary cast through FP16.
* Fixed pooling kernel runtime compilation failure.
* Fixed gfx1151 inline assembly compilation errors in batchnorm kernels.
* Fixed use-after-free in HIPOCProgram binary loading.

#### **ROCm Data Center Tool (RDC)** (1.3.0)

##### Resolved issues

* **Fixed broken partition metrics**.
  * Regardless of whether the GPU was partitioned, RDC only saw the GPU index and no instances due to upstream gpu_metrics changes.

#### **rocBLAS** (5.4.0)

##### Added

* gfx1250 and gfx90c enabled.
* Trace logging using `ROCBLAS_LAYER=1` for `rocblas_gemm_ex_get_solutions`, `rocblas_gemm_batched_ex_get_solutions`, `rocblas_gemm_ex_get_solutions_by_type`, and `rocblas_gemm_batched_ex_get_solutions_by_type`.
* Version and other properties to Windows `rocblas.dll`.
* Support for `OpenBLAS` ILP64 API for host reference in clients.
* Dockerfiles in the `docker` directory to assist in setting up development.

##### Optimized

* Improved the performance of Level 3 `geam` for pure transpose scale use cases.
* Improved the performance of Level 2 `tpsv`.

##### Resolved issues

* Fix for querying solutions when using the `hipBLASLt` backend with `rocblas_gemm_batched_ex_get_solutions` if using null data pointers.

#### **ROCdbgapi** (0.80.0)

##### Added

* `amd_dbgapi_process_get_info()` adds a new query to get a mask spanning
  over all the bits used by all the address spaces.  The query is called
  `AMD_DBGAPI_PROCESS_INFO_SIGNIFICANT_ADDRESS_BITS`.

#### **rocDecode** (1.8.0)

##### Added

* Logging improvement: Added function entry and exit logs (at Info log level).
* Logging improvement: Added duration to function exit logs and optimized log message formatting to reduce runtime overhead.
* Logging improvement: Merged all logger instances into one global instance.
* Logging improvement: Unified logging format in utility classes with core library logging format.
* Logging improvement: Moved debug logging from a compile-time switch to the runtime logger level controlled by `ROCDEC_LOG_LEVEL` (debug = 4).
* Added support for user-set output surface format.

##### Changed

* Removed CPack packaging (DEB/RPM/NSIS/TGZ/ZIP generation and all related CPACK variables).
* Removed `rocDecode-setup.py` dependency installer script.
* Removed Docker files.
* Removed package install documentation; updated all documentation to reference TheRock for installation.
* Simplified libva version check (single `>= 1.22` requirement).
* Cleaned up CMake error messages.

#### **rocFFT** (1.0.37)

##### Optimized

* Allow plans to share hipModules if they use the same kernels.  This reduces time spent and memory used when
  creating plans that exist concurrently.
* Improved performance of unit-strided, interleaved, complex-to-complex and real-to-complex FFTs on gfx1201, gfx90a, gfx942, and gfx950.

  Single-precision lengths:
  * (160,72,72)
  * (160,80,72)
  * (160,80,80)
  * (72,72,72)
  * (80,80,80)
  * (84,84,72)
  * (96,96,96)
  * (108,108,80)

  Double-precision lengths:
  * (72,72,52)
  * (60,60,60)
  * (64,64,52)
  * (64,64,64)

##### Changed

* Moved library to C++20 standard.
* Removed Boost as a dependency for clients and samples.
* Split the precompiled kernel cache file (`rocfft_kernel_cache.db`) into per-architecture files (`rocfft_kernel_cache_gfx950.db`, `rocfft_kernel_cache_gfx1201.db`, etc).
* `rocfft_plan_create` returns `rocfft_status_invalid_offset` for any usage of non-zero offsets in plan descriptions. The feature is not supported yet.
* Callback functions will be deprecated in a future release.

##### Resolved issues

* Potential issue with data generation for multi-dimensional transforms in rocfft-tests and rocfft-bench.
* An issue that sometimes blocked complex-to-complex FFT plan creation when using noncontiguous strides in multiple dimensions.
* An issue that sometimes blocked complex-to-real FFT plan creation when using noncontiguous strides in multiple dimensions.
* An issue that sometimes blocked complex-to-real FFT plan creation when using noncontiguous strides with small lengths on the two fastest dimensions.
* Potential launch failure of data generation kernels in test and benchmark programs.
* Incorrect results on some strided real-complex FFTs on gfx90a.
* Incorrect results on some even-length real FFTs that have odd-length strides on higher dimensions.
* Callbacks on MPI transforms when not all ranks have the same number of data bricks.
* Functional issues for multi-device, in-place real transforms.
* Functional issues for multi-dimensional, multi-device transforms involving some unit length(s).
* Functional issues for multi-device transforms involving data divisions along the slowest-varying axis (only) for some bricks but not all.
* Functional issues for multi-device transforms setting no field on input or output.
* Automatic allocation of work memory at plan execution time, when work memory is required on multiple devices.

#### **rocJPEG** (1.5.0)

##### Changed

* rocJPEG is now delivered as part of [TheRock](https://github.com/ROCm/TheRock). All core dependencies are provided by the TheRock build.
* Removed CPack packaging (DEB/RPM/NSIS/TGZ/ZIP generation and all related CPACK variables).
* Removed `rocJPEG-setup.py` dependency installer script.
* Removed Docker files.
* Removed package install documentation; updated all documentation to reference TheRock for installation.
* Simplified libva version check (single `>= 1.22` requirement).
* Cleaned up CMake error messages.

#### **ROCm Compute Profiler** (3.6.0)

##### Added

* Added L2 memory bandwidth derived metrics under `--membw-analysis` to allow L2 memory bandwidth specific profiling and analysis metric block 30.

* Added AMD Ryzen AI Max 300 series (gfx1151) support.
  * New memory hierarchy visualization for RDNA 3.5 (gfx115X) in analyze CLI mode.

* Introduced support for AMD Instinct MI350P GPU.

* ``--view table`` option in analyze mode to force all TTY output to plain tables and ignore ``cli_style`` from YAML config (for example, mem_chart, Roofline charts render as tables). The ``--view`` argument is reserved for future TTY views (for example, other chart styles).

* Added EA memory bandwidth derived metrics under `--membw-analysis` to allow EA memory bandwidth specific profiling and analysis metric block 30.

##### Changed

* Standalone roofline (`--roof-only` option) in profile mode now creates `roofline.csv` only. HTML roofline charts are generated via `rocprof-compute analyze`. The `calc_ai_profile()` function has been removed; `calc_ai_analyze()` is the single source of truth for arithmetic intensity calculation.
  * Roofline visualization options (`--sort`, `--mem-level`, `--roofline-data-type`) have moved from profile mode to analyze mode.

* Standardized unit naming in analysis configs and Python utilities: `pct`/`Pct` → `Percent`, `instr` → `Instructions`.

* Profile mode output format:
  * Profile mode now creates separate counter collection files for each application replay (pmc_perf_*.csv or results_*.csv).
  * Analyze mode automatically merges these files into a unified pmc_perf.csv containing information from all application replays during pre-processing.

* ROCm Compute Profiler now builds and runs profile mode with vanilla Python without requiring any Python dependencies to be installed via `pip`.
  * Note that analysis mode will still require Python dependencies and will report any missing packages.

##### Removed

* Removed HIP API tracing since it's out-of-scope for ROCm Compute Profiler and the trace files were not being analyzed.

##### Optimized

* Filtering for block 21 (`-b 21`) in profile mode now only performs pc sampling and skips unnecessary counter collection.
  * Filtering for block 21 in analysis mode now skips metrics calculations and only shows kernel/dispatch/system statistics and pc sampling table.

##### Resolved issues

* Fixed roofline benchmark MFMA FP16/BF16/INT8 peaks for MI350.
* Fixed an issue where pc sampling profiling failed with multi-argument commands and live process attachment.

##### Upcoming changes

* `--path` and `--subpath` options are deprecated and will be removed in a future release.
* Intermediate CSV generation (`results_*.csv`) from rocpd databases during profiling is deprecated and will be removed in a future release. The analyze step will read `.db` files directly.
* `--retain-rocpd-output` is deprecated and will be removed in a future release. `.db` files will be retained by default.

##### Known issues

* For AMD Ryzen AI Max 300 series, the roofline metrics table will have N/A values for "peak" field.
  * This is planned to be addressed by adding empirical benchmark support for AMD Ryzen AI Max 300 series in a future release.

#### **ROCm Systems Profiler** (1.6.0)

##### Added

* Kernel Fusion Driver (KFD) event tracing support to capture page faults, page migrations, queue evictions, GPU unmap events, and dropped events. Requires ROCprofiler-SDK 1.2.1 or later. Enable with `ROCPROFSYS_ROCM_DOMAINS=kfd_events`.
* Support for pause and resume of profiling via `roctxProfilerPause` and `roctxProfilerResume`.
* Support for selective region tracing via the `ROCPROFSYS_SELECTED_REGIONS` environment variable, limiting tracing to specified regions.
* `--selected-regions` CLI argument to `rocprof-sys-sample`, `rocprof-sys-run`, and `rocprof-sys-instrument` for specifying selective region tracing from the command line.
* Support for re-attaching to a previously profiled process. After detaching, `rocprof-sys-attach` can re-attach to the same PID for a new profiling session.
* MPI-rank-based file output filtering feature controlled with two new CLI arguments: `--rank-filter-output` and `--rank-filter-id`.
* JSON-based configurable preset system with `--preset=<name>` flag, replacing the old `--<preset-name>` flags. Presets are now loaded from JSON files in `source/bin/common/presets/`, making them extensible and exportable. Use `--list-presets` to see available presets and `--explain=<name>` for detailed preset information.
* Domain flags for composable configuration: `--gpu[=metrics]`, `--rocm[=domains]`, `--cpu[=hz]`, `--parallel[=runtimes]`. Domain flags can be combined with presets to customize profiling without editing configuration files.
* Configuration export via `--export-config[=file]` to save resolved settings as reusable JSON configuration files. Exported configs can be loaded back with `--preset=./config.json`.
* Topic-based help system: `--help` now shows a compact summary with essential options and a list of help topics. Use `--help=<topic>` (e.g., `--help=sampling`, `--help=gpu`, `--help=tracing`) to see only relevant options. Use `--help=all` for the full option listing.
* Post-run output summary during library finalization showing result file locations.
* JSON schema file (`share/rocprofiler-systems/presets/schema.json`) for preset validation.
* Documentation (`docs/how-to/instrumenting-rewriting-binary-application.rst`) describing what to do when Dyninst reports a "Failed to transform trace" error during instrumentation.

##### Changed

* `rocprof-sys-avail` no longer queries GPU devices or hardware counters unless `--hw-counters` or `--all` is requested, reducing startup time and allowing settings/component queries in environments without GPU/ROCm.
* `rocprof-sys-instrument` diagnostic file dumps (available, instrumented, excluded, coverage, overlapping) are now gated behind the `--dump-info` flag instead of being generated unconditionally.
* Preset flags changed from `--balanced` to `--preset=balanced` syntax. The old `--<preset-name>` flags are still supported and handled within `preset_registry`.
* Removed the `ROCPROFSYS_USE_ROCM` CMake option. ROCm is now required for building the ROCm Systems Profiler.

##### Resolved issues

* Fixed an issue where the `--rocm-domains` CLI option for `rocprof-sys-run` was not recognized.

#### **rocminfo** (1.0.0)

##### Resolved issues

* Fixed BDF (Bus:Device.Function) ID truncation issue that caused incorrect display of PCI device identifiers. The `bdf_id` field was incorrectly declared as `uint16_t` instead of `uint32_t`, causing silent truncation when HSA runtime returned the full 32-bit BDF ID value. This has been corrected to properly display complete BDF information for all GPU agents.

#### **rocPRIM** (4.4.0)

##### Added

* Added type trait definitions for `__hip_bfloat16`. This should resolve issues where this type did not work with radix-based algorithms.
* Unit tests for config_types.

##### Optimized

* Reduced build times for unit tests.
* Reduced memory usage in unit tests.

##### Resolved issues

* Fixed a silent overflow in `rocprim::device_segmented_reduce` where it could exceed the maximum number of HIP threads, resulting in missing output.
* Certain large unit tests now properly detect if insufficient system memory is present and skip the test case accordingly.
* Fixed out-of-bounds memory access in block run length decode.
* Fixed memory leak in unit tests.

#### **ROCprofiler-SDK** (1.3.0)

##### Added

**API:**

* Late-start profiling support: Enables profiling when `rocprofiler-sdk` is loaded after HSA/HIP runtimes have already initialized.
  * `rocprofiler_force_configure()` now automatically detects and profiles runtimes initialized before the SDK loads.
  * Integrates with `rocprofiler-register` to retrieve the registered API tables.
  * Supports all runtime types (HSA, HIP, ROCTX, RCCL, rocDecode, rocJPEG, and more) automatically.
  * No explicit late-start API calls required; works transparently.

* KFD (Kernel Fusion Driver) event tracing support:
  * Buffer service configurations for each KFD buffer tracing type.
  * New type `tool_buffer_tracing_kfd_record_t` using `std::variant` to wrap 8 different KFD buffer tracing types.
  * Each KFD event generates `rocpd_info_pmc`, `rocpd_event`, `rocpd_region`, and `rocpd_pmc_event` rows.
  * Fixed handling for special SVM location in KFD prefetch location reporting.
  * Fixed parsing for queue restore events to handle both correct format (character '0') and broken driver format (NULL character '\0').

**rocprofv3 (CLI):**

* Multi-pass counter collection support: Support for multiple `--pmc` flags to define separate counter groups for different profiling passes.
  * Ability to combine command-line `--pmc` flags with input file counter groups.
  * Each pass generates output in a separate `pass_n` subdirectory.
  * Example: `rocprofv3 --pmc SQ_WAVES --pmc GRBM_COUNT -- <app>` creates two profiling passes.

* KFD (Kernel Fusion Driver) event tracing support:
  * KFD record dumping to `rocpd` with support for 8 main KFD event types.
  * Support for `rocpd` to Perfetto conversion for KFD events.
  * `--kfd-trace` flag to enable KFD event tracing.

* ROCTx support for ATT: Added ROCtx support to device thread trace when using `--att --selected-regions`.
  * Allows `roctxProfilerPause` and `roctxProfilerResume` to explicitly control when ATT data collection starts and stops.
  * Enables more precise, region-focused ATT tracing with reduced overhead and noise.
  * Supports multiple resume/pause cycles, each producing separate trace output files.
  * Incompatible with `--att-consecutive-kernels`.

* PC sampling support for dynamic attach: Allows users to attach to a running application and collect PC samples without restarting the workload.
  * Enables profiling long-running or production-style jobs at the point of interest.
  * Results integrate with the existing PC sampling analysis flow.

**Documentation:**

* Added marker-controlled thread tracing section to the thread trace how-to guide.
* Added cross-reference from ROCTx documentation to ATT with `selected-regions`.

##### Changed

**Implementation:**

* Late-start architecture redesign: Removed direct runtime symbol access in favor of proper rocprofiler-register integration.
  * Replaced ~600 lines of `dlopen`/`dlsym` bypass logic with ~80 lines by using `rocprofiler_register_invoke_all_registrations()`.
  * Late-start now works by requesting `rocprofiler-register` to re-propagate stored API tables.
  * Extensible design. Automatically supports new runtimes without SDK code changes.
  * Provides a proper separation of concerns. `rocprofiler-register` manages the table storage while SDK manages the table wrapping.
* Counter dimension encoding changed from fixed-width to variable-width allocation per dimension type.
* Dimension selection and reduction logic now uses explicit dimension masks and single-index selection.
* HSA queue interception extended to handle AMD extended kernel dispatch packets.

##### Removed

* Counter collection support for plain text (`.txt`) input files. Only structured file formats (JSON and YAML) with schema validation are now supported.

##### Resolved issues

* Fixed rocpd OTF2 output to add `ACCELERATOR_DEVICE` as system tree node domain for AMD devices.
* Fixed `rocprofv3` input file parsing where comment lines containing `pmc:` were incorrectly processed as valid counter collection directives, causing unintended profiling passes.

#### **rocRAND** (4.4.0)

##### Added

* gfx1150 and gfx1152 support.
* rocrand.dll now contains embedded file version metadata.

##### Resolved issues

* Fixed memory leak in unit tests.

#### **rocSHMEM** (3.4.0)

##### Added

* Added new APIs:
  * `rocshmem_quiet_on_stream`
  * `rocshmem_sync_all_on_stream`
  * `rocshmem_TYPENAME_alltoall_wg`
  * `rocshmem_TYPENAME_alltoallv_wg`
  * `rocshmem_team_my_pe`
  * `rocshmem_team_n_pes`
  * `rocshmem_barrier`
  * `rocshmem_barrier_wave`
  * `rocshmem_barrier_wg`
  * `rocshmem_buffer_register`
  * `rocshmem_buffer_unregister`
  * `rocshmem_info_get_version`
  * `rocshmem_info_get_name`
  * `rocshmem_vendor_get_version_info`
* Added library constants: `ROCSHMEM_MAJOR_VERSION`, `ROCSHMEM_MINOR_VERSION`,
  `ROCSHMEM_MAX_NAME_LEN`, `ROCSHMEM_VENDOR_STRING`, `ROCSHMEM_VERSION`,
  `ROCSHMEM_VENDOR_MAJOR_VERSION`, `ROCSHMEM_VENDOR_MINOR_VERSION`,
  `ROCSHMEM_VENDOR_PATCH_VERSION`.
* Added vendor string and backend metadata to the `rocshmem_info` output.
* Added `ROCSHMEM_TEAM_WORLD` for device code.
* Added `ROCSHMEM_TEAM_SHARED` predefined team for PEs sharing a common memory domain (same node).
* Added new environment variables:
  * `ROCSHMEM_GDA_OVERRIDE_NIC_FIRMWARE_CHECK`
  * `ROCSHMEM_GDA_NUM_QPS_PER_PE_DEFAULT_CTX`
  * `ROCSHMEM_GDA_NUM_QPS_PER_PE_USR_CTX`
* Added VMM POSIX memory allocator (`USE_HEAP_DEVICE_VMM_POSIX`):
  * Uses HIP Virtual Memory Management (VMM) APIs for fine-grained memory control.
  * Requires ROCm 7.0+ and Linux kernel 5.6+.
  * Not compatible with MPI-based initialization (use `ROCSHMEM_INIT_WITH_UNIQUEID` instead).

##### Changed

* Use CQ collapsing for the Mellanox MLX5 GDA conduit.

#### **rocSOLVER** (3.34.0)

##### Added

* Computation of solution for LU factorization without pivoting:
  * GETRS_NPVT (with batched and strided\_batched versions)
  * GETRS_NPVT_64 (with batched and strided\_batched versions)
* Linear solver routines for symmetric matrices:
  * SYTRS (with batched and strided\_batched versions)
  * SYTRS_64 (with batched and strided\_batched versions)

##### Optimized

* Improved the performance of POTF2 and downstream functions such as POTRF.

##### Resolved issues

* Fixed a memory access error in SYTRF and synchronization issues in LASYF and SYTF2.

#### **rocSPARSE** (4.6.0)

##### Added

* `rocsparse_create_const_bsr_descr` routine for creating a const sparse BSR matrix descriptor.
* `rocsparse_spic0` and `rocsparse_spilu0` routines for incomplete factorizations, with strided batched computations enabled.
* `rocsparse_sptrsv_descr_create` and `rocsparse_sptrsv_descr_destroy` routines.
* `rocsparse_singularity` enumeration.
* `rocsparse_sptrsv_output_singularity` and `rocsparse_sptrsv_output_singularity_position` in `rocsparse_sptrsv_output`.
* Strided batched computations for `rocsparse_sptrsv`.

##### Optimized

* Significant performance improvement for `rocsparse_Xgtsv_no_pivot_strided_batch`.
* Significant performance improvement for `rocsparse_Xgtsv_no_pivot`.

##### Resolved issues

* Fixed incorrect usage of `__syncthreads` in `bsrmm`, `csrmm` (row_split), and `csritilu0x`.
* Fixed incorrect usage of `__syncthreads` in `csx2dense`, `dense2csx`, `prune_dense2csr`, `csrcolor`, and `csrmm` (`nnz_split`).
* Fixed `rocsparse_[s|d|c|z]csric0` where `rocsparse_status_invalid_value` was being returned when the maximum number of non-zeros in any row is between 513 and 1024.
* Fixed compilation when using `--rocsparse_ILP64`.
* Fixed off-by-one heap-buffer-overflow in temporary buffer allocation for `rocsparse_csrsort`, `rocsparse_check_matrix_csr`, and `rocsparse_check_matrix_gebsr` (and their delegating routines `rocsparse_cscsort`, `rocsparse_coosort`, `rocsparse_check_matrix_csc`, and `rocsparse_check_matrix_gebsc`) where the `shift_offsets_kernel` temp buffer was sized for `m` elements instead of `m+1`.

##### Removed

* The deprecated C++14 support, which is no longer supported by the rocPRIM dependency.

#### **rocThrust** (4.4.0)

##### Resolved issues

* Fixed memory leak in unit test.
* Fixed unit test compatibility with ASAN.

#### **rocWMMA** (2.2.1)

##### Added

* Added the following community samples for external contributions, with build support and documentation:
  * `simple_gemm_silu`: demonstrates a GEMM + SiLU fused operator using the rocWMMA API.
  * `simple_gemm_fusion`: demonstrates block-tile-level dual-GEMM fusion using the rocWMMA API.
  * `simple_gemm_swiglu`: demonstrates a SwiGLU fused dual-GEMM kernel (LLaMA/Mistral FFN gate layer) using the rocWMMA API.

##### Changed

* Updated the `find_package` search for OpenMP to prefer the `openmp-config.cmake` provided by ROCm, with a fallback to module search mode.
* Updated `INSTALL_RPATH` and added `BUILD_RPATH` for OpenMP.

##### Resolved issues

* Improved HIP RTC regression test portability when deployed outside the default path.
