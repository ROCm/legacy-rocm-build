# Transition guide from legacy ROCm release stream

[ROCm Core SDK 7.14.0](https://rocm.docs.amd.com/en/latest/index.html#rocm-core-sdk) marks a step change from the ROCm legacy release stream. It is built on our new build system, TheRock.

## Major changes

<table class="rocm-docs-table table">
  <thead>
    <tr>
      <th class="head">Feature</th>
      <th class="head">ROCm Core SDK</th>
      <th class="head">ROCm Legacy</th>
      <th class="head">Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Installation directory</td>
      <td><code class="docutils literal notranslate"><span class="pre">/opt/rocm/core</span></code></td>
      <td><code class="docutils literal notranslate"><span class="pre">/opt/rocm/</span></code></td>
      <td>To support additional release streams downstream of the ROCm Core SDK</td>
    </tr>
    <tr>
      <td>Package names</td>
      <td><code class="docutils literal notranslate"><span class="pre">amdrocm-[$component]</span></code></td>
      <td><code class="docutils literal notranslate"><span class="pre">rocm-[$component]</span></code> or <code class="docutils literal notranslate"><span class="pre">roc[$component]</span></code> or <code class="docutils literal notranslate"><span class="pre">hip[$component]</span></code></td>
      <td>Unique package prefix to avoid conflicts with upstream packages</td>
    </tr>
    <tr>
      <td>Extras directory</td>
      <td><code class="docutils literal notranslate"><span class="pre">/opt/rocm/extras-7/</span></code></td>
      <td>N/A</td>
      <td>Shared install prefix scoped to each ROCm major version for projects built on the ROCm Core SDK</td>
    </tr>
  </tbody>
</table>

## Paths and linking

ROCm Core SDK 7.14.0 maintains ABI and API compatibility with the ROCm 7.2
legacy releases, so recompilation is not required. For installations using your
Linux distribution's package manager, the `amdrocm` meta package configures
`update-alternatives` and provides backward-compatible symlinks for
`/opt/rocm/bin`, `/opt/rocm/lib`, and other `/opt/rocm/` directories. For
tarball installs, update `PATH`, `LD_LIBRARY_PATH`, `ROCM_PATH`, or other
environment variables to reflect the new installation path (`/opt/rocm/core`).

## Software packages

ROCm Core SDK packages are more consolidated than the legacy ROCm release
stream. For example, hipBLAS and rocBLAS are now combined into one package,
`amdrocm-blas`. The table below lists new packages, their contents, and the
corresponding legacy packages.

> **Note:** ASAN packages are not available in 7.14.0 and are planned for a future release.

(linux-packages-available-in-rocm-7-14-0)=

### Linux packages available in ROCm 7.14.0

<table class="rocm-docs-table table">
  <thead>
    <tr>
      <th class="head">ROCm Core SDK Package</th>
      <th class="head">Package Contents</th>
      <th class="head">ROCm Legacy Package</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>amdrocm-amdsmi</td>
      <td>amd-smi</td>
      <td>amd-smi-lib, rocm-smi-lib</td>
    </tr>
    <tr>
      <td>amdrocm-llvm</td>
      <td>amdclang++, hipcc, flang</td>
      <td>rocm-llvm, rocm-llvm-dev, Fortran compiler (included in rocm-llvm OpenMP runtime)</td>
    </tr>
    <tr>
      <td>amdrocm-runtime</td>
      <td>HIP, ROCR, runtime compilation</td>
      <td>hip-runtime-amd, rocm-hip-runtime, rocm-language-runtime, hsa-rocr, comgr</td>
    </tr>
    <tr>
      <td>amdrocm-fft</td>
      <td>rocFFT, hipFFT, hipFFTW</td>
      <td>rocfft, hipfft</td>
    </tr>
    <tr>
      <td>amdrocm-blas</td>
      <td>rocBLAS, hipBLAS, hipBLASLt, hipSPARSELt</td>
      <td>rocblas, hipblas, hipblaslt, hipsparselt</td>
    </tr>
    <tr>
      <td>amdrocm-sparse</td>
      <td>rocSPARSE, hipSPARSE</td>
      <td>rocsparse, hipsparse</td>
    </tr>
    <tr>
      <td>amdrocm-solver</td>
      <td>rocSOLVER, hipSOLVER</td>
      <td>rocsolver, hipsolver, rocalution</td>
    </tr>
    <tr>
      <td>amdrocm-dnn</td>
      <td>hipDNN, MIOpen</td>
      <td>miopen-hip</td>
    </tr>
    <tr>
      <td>amdrocm-rand</td>
      <td>rocRAND, hipRAND</td>
      <td>rocrand, hiprand</td>
    </tr>
    <tr>
      <td>amdrocm-ccl</td>
      <td>rocPRIM, rocThrust, hipCUB</td>
      <td>rocprim, rocthrust, hipcub, rocwmma</td>
    </tr>
    <tr>
      <td>amdrocm-profiler</td>
      <td>rocprofiler-systems, rocprofiler-compute, rocprofiler-sdk, roctracer</td>
      <td>rocprofiler, rocprofiler-compute, rocprofiler-systems, rocprofiler-sdk, roctracer</td>
    </tr>
    <tr>
      <td>amdrocm-profiler-base</td>
      <td>rocprofiler-sdk, roctracer</td>
      <td>rocprofiler-register, roctracer, hsa-amd-aqlprofile</td>
    </tr>
    <tr>
      <td>amdrocm-base</td>
      <td>rocminfo, rocm-core</td>
      <td>rocm-core, rocminfo, rocm-cmake, half</td>
    </tr>
    <tr>
      <td>amdrocm-ck</td>
      <td>Composable Kernel</td>
      <td>composablekernel</td>
    </tr>
    <tr>
      <td>amdrocm-debugger</td>
      <td>rocgdb, ROCdbgapi, ROCR Debug Agent</td>
      <td>rocm-gdb, rocm-dbgapi, rocm-debug-agent</td>
    </tr>
    <tr>
      <td>amdrocm-hipify</td>
      <td>HIPIFY</td>
      <td>hipify-clang</td>
    </tr>
    <tr>
      <td>amdrocm-opencl</td>
      <td>OpenCL runtime and ICD loader</td>
      <td>rocm-opencl-runtime, rocm-opencl, hip-opencl</td>
    </tr>
    <tr>
      <td>amdrocm-decode</td>
      <td>rocDecode (newly included in the ROCm Core SDK)</td>
      <td>rocdecode</td>
    </tr>
    <tr>
      <td>amdrocm-jpeg</td>
      <td>rocJPEG (newly included in the ROCm Core SDK)</td>
      <td>rocjpeg</td>
    </tr>
    <tr>
      <td>amdrocm-rccl</td>
      <td>rccl</td>
      <td>rccl</td>
    </tr>
    <tr>
      <td>amdrocm-rocshmem</td>
      <td>rocSHMEM</td>
      <td>rocshmem</td>
    </tr>
    <tr>
      <td>amdrocm-rdc</td>
      <td>ROCm Data Center Tool (newly included in the ROCm Core SDK)</td>
      <td>rdc</td>
    </tr>
    <tr>
      <td>amdrocm-sysdeps</td>
      <td>Bundled third-party dependencies (libdrm, libelf, numa, libVA)</td>
      <td>System dependencies</td>
    </tr>
  </tbody>
</table>

Packages are offered in the following variants:

- **For all supported GPUs** -- works across all GPUs supported by ROCm (for example, `apt install amdrocm-core-sdk7.14`).
- **For a specific GPU architecture** -- smaller install size, but requires you to know the GPU installed in your system (for example, `apt install amdrocm-core-sdk7.14-gfx110x`).

Installing all GPU architectures is not required. You can install packages for a specific architecture, multiple architectures side by side, or all supported GPU architectures.

When redistributing software built on the ROCm Core SDK (for example, via containers), we recommend the all GPU package variant for broad hardware support. If disk footprint is a concern, you can use a single GPU architecture package variant instead.

### Architecture-specific packages available in ROCm 7.14.0

<table class="rocm-docs-table table">
  <thead>
    <tr>
      <th class="head">Architecture Family</th>
      <th class="head">Package Suffix</th>
      <th class="head">Product Name (Not Exhaustive)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>CDNA4</td>
      <td>-gfx950</td>
      <td>AMD Instinct MI355X / MI350X</td>
    </tr>
    <tr>
      <td>CDNA3</td>
      <td>-gfx94x</td>
      <td>AMD Instinct MI325X / MI300X / MI300A</td>
    </tr>
    <tr>
      <td>CDNA2</td>
      <td>-gfx90a</td>
      <td>AMD Instinct MI250X / MI250 / MI210</td>
    </tr>
    <tr>
      <td>CDNA</td>
      <td>-gfx908</td>
      <td>AMD Instinct MI100</td>
    </tr>
    <tr>
      <td>RDNA4</td>
      <td>-gfx120x</td>
      <td>AMD Radeon RX 9070 / AMD Radeon RX 9060 / AMD Radeon RX 9070 XT / AMD Radeon RX 9060 XT / AMD Radeon RX 9070 GRE / AMD Radeon AI PRO R9700S / AMD Radeon AI PRO R9700 / AMD Radeon AI PRO R9600D / AMD Radeon RX 9060 XT LP</td>
    </tr>
    <tr>
      <td>RDNA3.5</td>
      <td>-gfx1150<br>-gfx1151<br>-gfx1152</td>
      <td>AMD Ryzen AI 9 465 / AMD Ryzen AI 9 365 / AMD Ryzen AI 9 HX 475 / AMD Ryzen AI 9 HX 470 / AMD Ryzen AI 9 HX 375 / AMD Ryzen AI 9 HX 370 / AMD Ryzen AI 9 PRO 465 / AMD Ryzen AI 9 PRO HX 475 / AMD Ryzen AI 9 PRO HX 470 / AMD Ryzen AI 9 HX PRO 375 / AMD Ryzen AI 9 HX PRO 370 / AMD Ryzen AI Max 390 / AMD Ryzen AI Max 385 / AMD Ryzen AI Max+ 395 / AMD Ryzen AI Max+ 392 / AMD Ryzen AI Max+ 388 / AMD Ryzen AI Max PRO 390 / AMD Ryzen AI Max PRO 385 / AMD Ryzen AI Max PRO 380 / AMD Ryzen AI Max+ PRO 395 / AMD Ryzen AI 7 450 / AMD Ryzen AI 7 350 / AMD Ryzen AI 7 345 / AMD Ryzen AI 5 340 / AMD Ryzen AI 5 330 / AMD Ryzen AI 7 PRO 450 / AMD Ryzen AI 5 PRO 440 / AMD Ryzen AI 7 PRO 350 / AMD Ryzen AI 5 PRO 340</td>
    </tr>
    <tr>
      <td>RDNA3</td>
      <td>-gfx110x</td>
      <td>AMD Radeon RX 7700 / AMD Radeon RX 7600 / AMD Radeon PRO V710 / AMD Radeon PRO W7900 / AMD Radeon PRO W7800 / AMD Radeon PRO W7700 / AMD Radeon RX 7900 XT / AMD Radeon RX 7800 XT / AMD Radeon RX 7700 XT / AMD Radeon RX 7700 XE / AMD Radeon RX 7900 XTX / AMD Radeon RX 7900 GRE / AMD Radeon PRO W7800 48GB / AMD Radeon PRO W7900 Dual Slot</td>
    </tr>
    <tr>
      <td>RDNA2</td>
      <td>-gfx1030</td>
      <td>AMD Radeon PRO V620 / AMD Radeon PRO W6800</td>
    </tr>
  </tbody>
</table>

## ROCm Core SDK component changes (moved or removed)

### Planned for future releases

- ROCm Core SDK: RPP
- ROCm-Extras: hipfort, rocPyDecode, rocAL, MIVisionX

### Moved to ROCm-Extras

- ROCm Validation Suite
- TransferBench
- MIGraphX

### Moved to Standalone/ONNX

- ONNX runtime

### Removed

- [ROCm SMI](https://rocm.docs.amd.com/en/latest/about/release-notes.html#rocm-smi-deprecation) (replaced by AMD SMI)
- ROCm Bandwidth Test (deprecated; reached end-of-life with the TheRock-based ROCm 7.14.0 release — use TransferBench or RVS instead)

## Notable package relocations

- rocMLIR (now included in MIGraphX)
- HIPCC (now included in `amdrocm-llvm`)
- FLANG (now included in `amdrocm-llvm`)
- ROCm CMake (now in `amdrocm-base`)
- ROCTracer (now in `amdrocm-profiler-base`)
- ROCProfiler (functionality in `amdrocm-profiler`)

## Components available in the ROCm Core SDK, ROCm-Extras, and Standalone/ONNX

<table class="rocm-docs-table table">
  <thead>
    <tr>
      <th class="head"></th>
      <th class="head">Category</th>
      <th class="head">Present</th>
      <th class="head">Absent/Moved</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan="6" class="stub" style="vertical-align: middle"><strong>ROCm Core SDK</strong></td>
      <td>Math and compute libraries</td>
      <td>CK, hipBLAS, hipBLASLt, hipCUB, hipFFT, hipRAND, hipSOLVER, hipSPARSE/SPARSELt, MIOpen, rocBLAS, rocFFT, rocRAND, rocSOLVER, rocSPARSE, rocPRIM, rocThrust, rocWMMA</td>
      <td>hipfort, rocALUTION</td>
    </tr>
    <tr>
      <td>Communication libraries</td>
      <td>RCCL, rocSHMEM</td>
      <td>—</td>
    </tr>
    <tr>
      <td>Media libraries</td>
      <td>rocDecode, rocJPEG, ROCm Performance Primitives (RPP planned for a future release)</td>
      <td>rocPyDecode, rocAL, MIVisionX, MIGraphX, CK (moved to math and compute)</td>
    </tr>
    <tr>
      <td>Runtime, compilers, build tools</td>
      <td>HIP, HIPIFY, LLVM</td>
      <td>HIPCC, FLANG, ROCm CMake</td>
    </tr>
    <tr>
      <td>Profiling and debugging tools</td>
      <td>ROCm Compute Profiler, ROCm Systems Profiler, ROCprofiler-SDK, ROCdbgapi, ROCm Debugger, ROCR Debug Agent</td>
      <td>ROCTracer, ROCProfiler</td>
    </tr>
    <tr>
      <td>Control and monitoring tools</td>
      <td>AMD SMI, ROCm Data Center Tool, rocminfo, hipinfo</td>
      <td>ROCm SMI (removed), ROCm Validation Suite, ROCm Bandwidth Test (removed)</td>
    </tr>
    <tr>
      <td style="vertical-align: middle"><strong>ROCm-Extras</strong></td>
      <td>—</td>
      <td>ROCm Validation Suite, TransferBench, MIGraphX</td>
      <td>—</td>
    </tr>
    <tr>
      <td style="vertical-align: middle"><strong>Standalone/ONNX</strong></td>
      <td>—</td>
      <td>rocMLIR, ONNX runtime</td>
      <td>—</td>
    </tr>
  </tbody>
</table>
