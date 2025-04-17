# ROCm consolidated changelog

This page is a historical overview of changes made to ROCm components. This
consolidated changelog documents key modifications and improvements across
different versions of the ROCm software stack and its components.

## ROCm 6.4.0

See the [ROCm 6.4.0 release notes](https://rocm-stg.amd.com/en/latest/about/release-notes.html)
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
  Users can retrieve violation status through either our Python or C++ APIs. Only available for MI300 series+ ASICs.

- Updated API `amdsmi_get_violation_status()` structure and CLI `amdsmi_violation_status_t` to include GFX Clk below host limit.

- Updated API `amdsmi_get_gpu_vram_info()` structure and CLI `amd-smi static --vram`.

#### Removed

- Removed `GFX_BUSY_ACC` from `amd-smi metric --usage` as it did not provide helpful output to users.

#### Optimized

- Added additional help information to `amd-smi set --help` command. The subcommands now detail what values are accepted as input.

- Modified `amd-smi` CLI to allow case insensitive arguments if the argument does not begin with a single dash.

- Converted `xgmi` read and write from KBs to dynamically selected readable units.

#### Resolved issues

- Fixed `amdsmi_get_gpu_asic_info` and `amd-smi static --asic` not displaying graphics version correctly for Instinct MI200 series, Instinct MI100 series, and RDNA3-based GPUs.

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

```{note}
See the full [AMD SMI changelog](https://github.com/ROCm/amdsmi/blob/release/rocm-rel-6.4/CHANGELOG.md) for details, examples, and in-depth descriptions.
```

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

- Fixed `rsmi_dev_target_graphics_version_get`, `rocm-smi --showhw`, and `rocm-smi --showprod` not displaying graphics version correctly for Instinct MI200 series, MI100 series, and RDNA3-based GPUs. 

```{note}
See the full [ROCm SMI changelog](https://github.com/ROCm/rocm_smi_lib/blob/release/rocm-rel-6.4/CHANGELOG.md) for details, examples, and in-depth descriptions.
```

### **ROCm Systems Profiler** (1.0.0)

#### Added 

- Support for VA-API and rocDecode tracing.

#### Resolved issues

- Fixed hardware counter summary files not being generated after profiling.

- Fixed an application crash when collecting performance counters with rocprofiler.

- Fixed interruption in config file generation.

- Fixed segmentation fault while running rocprof-sys-instrument.

#### Changed
- Backend refactored to use [ROCprofiler-SDK](https://github.com/ROCm/rocprofiler-sdk) rather than [ROCProfiler](https://github.com/ROCm/rocprofiler) and [ROCTracer](https://github.com/ROCm/ROCTracer).

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

```{note}
See the full [AMD SMI changelog](https://github.com/ROCm/amdsmi/blob/6.3.x/CHANGELOG.md) for more details and examples.
```

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

```{note}
See the full [AMD SMI changelog](https://github.com/ROCm/amdsmi/blob/6.3.x/CHANGELOG.md) for more details and examples.
```

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

### **hipRAND** (2.11.0[*](#id22))

#### Changed

* Updated the default value for the `-a` argument from `rmake.py` to `gfx906:xnack-,gfx1030,gfx1100,gfx1101,gfx1102`.

#### Known issues

* In ROCm 6.3.0, the hipRAND package version is incorrectly set to `2.11.0`. In ROCm
  6.2.4, the hipRAND package version was `2.11.1`. The hipRAND version number will be corrected in a
  future ROCm release.

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

* See [MIVisionX memory access fault in Canny edge detection](#mivisionx-memory-access-fault-in-canny-edge-detection).
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

- See [ROCm Compute Profiler post-upgrade](#rocm-compute-profiler-post-upgrade).

- See [ROCm Compute Profiler CTest failure in CI](#rocm-compute-profiler-ctest-failure-in-ci).

### **ROCm Data Center Tool** (0.3.0)

#### Added

* RVS integration
* Real time logging for diagnostic command
* `--version` command
* `XGMI_TOTAL_READ_KB` and `XGMI_TOTAL_WRITE_KB` monitoring metrics

#### Known issues

- See [ROCm Data Center Tool incorrect RHEL9 package version](#rocm-data-center-tool-incorrect-rhel9-package-version).

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

```{note}
See the full [ROCm SMI changelog](https://github.com/ROCm/rocm_smi_lib/blob/6.3.x/CHANGELOG.md) for more details and examples.
```

### **ROCm Systems Profiler** (0.1.0)

#### Changed

* Renamed to ROCm Systems Profiler from Omnitrace.
  * New package name: `rocprofiler-systems`
  * New repository: [https://github.com/ROCm/rocprofiler-systems](https://github.com/ROCm/rocprofiler-systems)
  * Reset the version to `0.1.0`
  * New binary prefix: `rocprof-sys-*`

#### Known issues

- See [ROCm Systems Profiler post-upgrade](#rocm-systems-profiler-post-upgrade).

### **ROCm Validation Suite** (1.1.0)

#### Added

- Support for hipBLASLT blas library and option to select blas library in `conf` file.

#### Changed

- Babel parameters made runtime configurable.

#### Known issues

- See [ROCm Validation Suite needs specified configuration file](#rocm-validation-suite-needs-specified-configuration-file).

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
- `FP64_ACTIVE` and `ENGINE_ACTIVE` metrics to AMD Instinct MI300 accelerator
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

- Bandwidth measurement in AMD Instinct MI300 accelerator
- Perfetto plugin issue of `roctx` trace not getting displayed
- `--help` for counter collection
- Signal management issues in `queue.cpp`
- Perfetto tracks for multi-GPU
- Perfetto plugin usage with `rocsys`
- Incorrect number of columns in the output CSV files for counter collection and kernel tracing
- The ROCProfiler hang issue when running kernel trace, thread trace, or counter collection on Iree benchmark for AMD Instinct MI300 accelerator
- Build errors thrown during parsing of unions
- The system hang caused while running `--kernel-trace` with Perfetto for certain applications
- Missing profiler records issue caused while running `--trace-period`
- The hang issue of `ProfilerAPITest` of `runFeatureTests` on AMD Instinct MI300 accelerator
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

```{note}
See the [detailed AMD SMI changelog](https://github.com/ROCm/amdsmi/blob/docs/6.2.0/CHANGELOG.md)
on GitHub for more information.
```

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

```{note}
The ``-Wall`` compilation flag prompts the compiler to generate a warning if a variable is uninitialized along some path.
```

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
  issue is fixed in a future release of Omniperf. See [#347](https://github.com/ROCm/omniperf/issues/347).

- Omniperf might not work with AMD Instinct MI300 accelerators out of the box, resulting in the following error:
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

* Improved performance of Level 1 `dot_batched` and `dot_strided_batched` for all precisions. Performance enhanced by 6 times for bigger problem sizes, as measured on an Instinct MI210 accelerator.

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

```{note}
See the [detailed ROCm SMI changelog](https://github.com/ROCm/rocm_smi_lib/blob/docs/6.2.0/CHANGELOG.md)
on GitHub for more information.
```

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

```{note}
See the AMD SMI [detailed changelog](https://github.com/ROCm/amdsmi/blob/rocm-6.1.x/CHANGELOG.md) with code samples for more information.
```

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
* Fixed the parsing of `pp_od_clk_voltage` in `get_od_clk_volt_info` to work better with MI-series hardware.

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

```{note}
See the [detailed changelog](https://github.com/ROCm/amdsmi/blob/docs/6.1.1/CHANGELOG.md) with code samples for more information.
```

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

```{note}
See the [detailed ROCm SMI changelog](https://github.com/ROCm/rocm_smi_lib/blob/docs/6.1.1/CHANGELOG.md) with code samples for more information.
```

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
  * Navi 3 series: gfx1100, gfx1101, and gfx1102.
  * MI300 series: gfx942.

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

##### Added

- Added more mixed precisions for SpMV, (matrix: float, vectors: double, calculation: double) and (matrix: rocsparse_float_complex, vectors: rocsparse_double_complex, calculation: rocsparse_double_complex)
- Added support for gfx940, gfx941 and gfx942

##### Optimized

- Fixed a bug in csrsm and bsrsm

##### Known issues

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

##### Added

- Added hipRTC support for amd_hip_fp16
- Added hipStreamGetDevice implementation to get the device associated with the stream
- Added HIP_AD_FORMAT_SIGNED_INT16 in hipArray formats
- hipArrayGetInfo for getting information about the specified array
- hipArrayGetDescriptor for getting 1D or 2D array descriptor
- hipArray3DGetDescriptor to get 3D array descriptor

##### Changed

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

##### Added

- 'end_time' need to be disabled in roctx_trace.txt

##### Optimized

- Improved Test Suite

##### Resolved issues

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
