# ROCm Core SDK 7.12.0 release notes

ROCm Core SDK 7.12.0 continues the technology preview release stream that began
with [ROCm
7.9.0](https://rocm.docs.amd.com/en/7.9.0-preview/about/release-notes.html),
advancing the transition to the new [TheRock](https://github.com/rocm/therock)
build and release system. To learn more about TheRock, see [ROCm Core SDK and
TheRock Build
System](https://rocm.blogs.amd.com/software-tools-optimization/therock/README.html).

This release expands support for more AMD GPUs and APUs. Developers can expect
a more consistent build experience and streamlined workflows that pave the way
toward modular future ROCm releases planned for mid-2026.

(preview-stream-note)=
:::{important}
ROCm 7.12.0 follows the [versioning discontinuity that began with
7.9.0](https://rocm.docs.amd.com/en/7.9.0-preview/about/release-notes.html#preview-stream-note)
and remains separate from the 7.0 to 7.2 production releases. For the latest
production stream release, see the [ROCm
documentation](https://rocm.docs.amd.com/en/latest/).

Maintaining parallel release streams -- preview and production -- gives users
ample time to evaluate and adopt the new build system and dependency changes.
The technology preview stream is planned to continue through mid‑2026, after
which it will replace the current production stream.
:::

## Release highlights

ROCm Core SDK 7.12.0 with TheRock builds upon the 7.11.0 release with several key
enhancements:

### Expanded AMD GPU support

The ROCm 7.12.0 preview adds support for the following AMD GPUs and APUs:

- AMD Instinct MI100

- AMD Radeon RX 7700 XE

- AMD Radeon RX 7600

- AMD Ryzen AI 9 HX PRO 475

- AMD Ryzen AI 9 HX PRO 470

- AMD Ryzen AI 9 PRO 465

- AMD Ryzen AI 7 PRO 450

- AMD Ryzen AI 5 PRO 440

- AMD Ryzen AI 5 PRO 435

- AMD Ryzen 9 270

- AMD Ryzen 7 260

- AMD Ryzen 7 250

- AMD Ryzen 5 240

- AMD Ryzen 5 230

- AMD Ryzen 5 220

- AMD Ryzen 3 210

For the full list of supported hardware, see [Hardware support](#release-supported-hw).

### Expanded Linux distribution support

ROCm 7.12.0 adds support for Debian 12 with AMD Instinct GPUs.

For the full list of supported Linux distributions, see [Operating system
support](#release-supported-os).

### Expanded GPU virtualization support for Instinct GPUs

ROCm 7.12.0 adds support for the following KVM SR-IOV virtualization configurations on AMD Instinct
MI355X and MI350X GPUs.

- On MI355X: Ubuntu 24.04 host OS with RHEL 10.0 or RHEL 9.6 guest OS.

- On MI350X: Ubuntu 24.04 host OS with RHEL 9.6 guest OS.

For details, see [GPU virtualization support](#release-virtualization-support).

### Added GPU partitioning support

ROCm 7.12.0 adds support for the following compute partition and NUMA-per-socket
(NPS) configurations on AMD Instinct GPUs in bare metal deployments.

<table class="rocm-docs-table table">
  <thead>
    <tr>
      <th class="head"><p>Device</p></th>
      <th class="head"><p>Compute partition mode</p></th>
      <th class="head"><p>NPS mode</p></th>
      <th class="head"><p>Deployment</p></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan="2" style="vertical-align: middle;">
        <p>Instinct MI355X, MI350X</p>
      </td>
      <td><p>CPX</p></td>
      <td><p>NPS 2</p></td>
      <td rowspan="4" style="vertical-align: middle;"><p>Bare metal</p></td>
    </tr>
    <tr>
      <td><p>DPX</p></td>
      <td><p>NPS 2</p></td>
    </tr>
    <tr>
      <td rowspan="2" style="vertical-align: middle;">
        <p>Instinct MI300X</p>
      </td>
      <td><p>CPX</p></td>
      <td><p>NPS 4</p></td>
    </tr>
    <tr>
      <td><p>DPX</p></td>
      <td><p>NPS 2</p></td>
    </tr>
  </tbody>
</table>

### Added Runfile installation method

The ROCm Runfile Installer can install ROCm and/or the AMD GPU Driver (amdgpu)
without using a native Linux package management system, making it ideal for
systems with policy constraints or restricted environments. Network access is
not needed for installation as long as dependencies for ROCm and/or AMD GPU driver
(amdgpu) are met. A single installer supports all GFX architectures, automates
post-installation configuration, and offers an interactive command-line GUI for
guided setup.

For details, see the [ROCm installation instructions](/install/rocm).

### Added rocSHMEM library to TheRock

The rocSHMEM (ROCm OpenSHMEM) runtime provides GPU-centric networking through
an OpenSHMEM-like interface. It simplifies application code complexity and
enables finer communication and computation overlap than traditional
host-driven networking.

rocSHMEM is supported on Linux on AMD Instinct, Radeon PRO, and Radeon GPUs.
See the project in
[ROCm/rocm-systems](https://github.com/ROCm/rocm-systems/tree/release/therock-7.12/projects/rocshmem)
for more information.

### Expanded AI ecosystem support

- PyTorch 2.10.0 is now supported on Linux and Windows. PyTorch 2.7 support is
  no longer validated. See [Install PyTorch](/rocm-for-ai/pytorch).

- JAX 0.8.2 and 0.8.0 are now built and distributed through TheRock on Linux.
  See [Install JAX](/rocm-for-ai/jax).

- vLLM 0.16.0 wheels and Docker images are now available through AMD package
  repositories for select GFX architectures (gfx950, gfx942, gfx1200,
  gfx1201, and gfx1151) on Linux. See [vLLM inference](/rocm-for-ai/vllm).

See [](#release-ai-ecosystem) for details.

### ROCm profilers now support virtualized environments

ROCprofiler-SDK, ROCm Systems Profiler (rocprofiler-systems), and ROCm Compute
Profiler (rocprofiler-compute) now support performance profiling and analysis
in KVM (kernel-based virtual machine) environments, enabling developers to
profile GPU workloads running on virtualized infrastructure.

### ROCm Compute Profiler: introduced iteration multiplexing

ROCm Compute Profiler (rocprofiler‑compute) now supports iteration multiplexing
for large workloads. This enhancement enables the collection of the full set of
hardware performance counters in a single profiling run, significantly
reducing overall profiling time. Iteration multiplexing eliminates the need
for application replay to gather extensive counter sets, which is often
impractical for large or long‑running workloads. For smaller workloads with
a limited number of kernel dispatches, existing pass‑reduction techniques
remain recommended. For more details, see [Iteration
multiplexing](https://rocm.docs.amd.com/projects/rocprofiler-compute/en/develop/how-to/profile/mode.html#iteration-multiplexing).

### ROCm Compute Profiler: isolate profiling output by MPI rank

ROCm Compute Profiler (rocprofiler-compute) now supports isolating profiling
output by MPI rank when profiling distributed workloads. If ranks are detected
and no rank placeholder is specified in the output path, each rank
automatically writes its results to a rank-named subdirectory, preventing
output collisions and simplifying per-rank analysis. For more information, see
[Multi-rank
profiling](https://rocm.docs.amd.com/projects/rocprofiler-compute/en/develop/how-to/profile/mode.html#multi-rank-profiling)
in the ROCm Compute Profiler documentation.

### ROCm Compute Profiler: experimental Torch operator counter collection and tracing

ROCm Compute Profiler (rocprofiler-compute) introduces experimental support for
Torch operator-based counter collection and tracing. This feature enables
profiling at the PyTorch operator level, allowing developers to correlate
hardware performance counters with individual Torch operations and better
understand the GPU performance characteristics of deep learning workloads. For
more information, see [Torch operator
mapping](https://rocm.docs.amd.com/projects/rocprofiler-compute/en/develop/how-to/profile/mode.html#torch-operator-mapping)
in the ROCm Compute Profiler documentation.

### Memory latency and derived counters now visible in ROCprof Compute Viewer

You can now view memory latency and derived counters in [ROCprof Compute
Viewer](https://rocm.docs.amd.com/projects/rocprof-compute-viewer/en/latest/),
providing clearer insights into memory performance characteristics. This
enhancement improves analysis and interpretation of memory-related bottlenecks.

### ROCm Systems Profiler: added network performance metrics for Pensando AI NICs

ROCm Systems Profiler (rocprofiler-systems) now surfaces key network metrics for
Pensando AI NICs, including Congestion Notification Packets (CNPs sent and
received) and bandwidth utilization as a percentage of peak throughput.
For more information, see [Network performance
profiling](https://rocm.docs.amd.com/projects/rocprofiler-systems/en/develop/how-to/nic-profiling.html)
in the ROCm Systems Profiler documentation.

### ROCm Systems Profiler: added Triton workload profiling support

ROCm Systems Profiler (rocprofiler-systems) now supports profiling Triton-based
workloads, enabling detailed runtime tracing in distributed environments. This
enhancement allows developers to correlate Triton framework activity with HIP
runtime behavior, including CPU and GPU execution, memory usage, and
communication patterns across multi-node jobs.

### ROCm Systems Profiler: added preset profiles

ROCm Systems Profiler (rocprofiler-systems) now includes preset profiles that
automatically configure profiling settings for common workload scenarios using
a single command-line flag. These presets provide optimized, pre-tuned
configurations that reduce setup complexity, minimize profiling overhead, and
ensure consistent behavior across general-purpose, workload-specific, and API
tracing use cases. For more information, see [Using preset
profiles](https://rocm.docs.amd.com/projects/rocprofiler-systems/en/develop/how-to/using-preset-profiles.html)
in the ROCm Systems Profiler documentation.

### ROCm Systems Profiler: added OpenSHMEM and UCX tracing

ROCm Systems Profiler (rocprofiler-systems) now supports comprehensive
OpenSHMEM and UCX tracing, providing deeper visibility into inter-node
communication patterns and helping developers identify and diagnose
communication inefficiencies in large-scale AI and HPC workloads. For more
information, see how to profile
[OpenSHMEM](https://rocm.docs.amd.com/projects/rocprofiler-systems/en/develop/how-to/communication-runtime-profiling.html#profiling-shmem-openshmem)
and
[UCX](https://rocm.docs.amd.com/projects/rocprofiler-systems/en/develop/how-to/communication-runtime-profiling.html#profiling-ucx)
using ROCm Systems Profiler.

### ROCm Systems Profiler now supports attaching to running processes

ROCm Systems Profiler (rocprofiler-systems) now supports attaching to and
profiling an already running process using the new `rocprof-sys-attach`
utility. This capability enables profiling of long-running applications,
services, or externally launched jobs without requiring a restart, making it
easier to capture performance data for specific runtime phases. Attached
profiling provides detailed insights while the application continues to run,
supporting dynamic and flexible performance analysis workflows. For more
information, see [Attaching to a running
process](https://rocm.docs.amd.com/projects/rocprofiler-systems/en/develop/how-to/attaching-to-running-process.html).

### ROCprofiler-SDK and rocprofv3: expanded Ryzen AI profiling support

ROCprofiler-SDK and `rocprofv3` now enable profiling on Ryzen AI Max 395,
390, and 385, Ryzen AI 7 350, 340, and 330, and Ryzen AI 7 400, extending
performance analysis capabilities to the latest Ryzen AI platforms on Linux.

### ROCprofiler-SDK: rocprofiler_force_configure() enables late-start profiling

The `rocprofiler_force_configure()` API now automatically detects
already-initialized HSA and HIP runtimes, enabling late-start profiling without
requiring application restarts. This enhancement supports profiling for
applications that dynamically load tools at runtime, use plugin architectures
where the ROCprofiler-SDK is loaded after GPU initialization, or need to attach
to already running GPU workloads.

### ROCprofiler-SDK now exposes process attach and detach as a public API

The `rocattach.so` library enables attaching to and detaching from running
processes using ptrace-based control and lifecycle synchronization. The
`tool_attach` and `tool_detach` entry points allow any rocprofiler-SDK tool
library to integrate into the attach and detach workflow. This functionality is
now exposed as a public API, allowing ROCprofiler-SDK users to incorporate
custom tool libraries into the attach and detach workflow without
re-implementing this logic.

### Compatibility notices

In terms of package compatibility, ROCm 7.12.0 diverges from the existing ROCm
7.0 production stream and future stable releases in that stream:

* **Compute-focused**: ROCm 7.12.0 enables support for primarily compute workloads.
  Future releases will support mixed workloads (compute and graphics).

  Graphics applications that rely on the ROCm stack are not fully supported
  with this release. For users running graphics applications alongside ROCm
  7.12.0, use the inbox Mesa user mode driver. Do not manually install the Mesa
  user mode driver.

* **No upgrade path from existing production releases** including ROCm 7.2.1
  and earlier, as well as from upcoming stable releases. See the [explanatory
  note](#preview-stream-note).

* **Not intended for production workloads**: users running production
  environments should continue using the [ROCm 7.0
  stream](https://rocm.docs.amd.com/en/latest/). See the [explanatory
  note](#preview-stream-note).

* **Not fully featured**: this release is a stepping stone toward fully open
  software development.

* **Limited hardware support**: preview releases are only supported on some AMD
  Instinct GPUs, Radeon GPUs, and Ryzen APUs. See [Supported hardware and
  operating systems](#release-supported-hw).

* **Software components**: additional components are planned to be introduced
  in future preview releases as part of the ROCm Core SDK. Other libraries and
  tools not included in the future Core SDK will either be:
  * Released as standalone project-specific packages, or
  * Grouped into domain-specific toolkits.

(release-supported-hw)=
## Hardware support

The following table lists supported AMD Instinct GPUs, Radeon GPUs, and Ryzen
APUs. Each supported device is listed with its corresponding GPU
microarchitecture and LLVM target.

::::{tab-set}
:::{tab-item} Instinct
:sync: instinct

<table class="rocm-docs-table table">
  <thead>
    <colgroup style="width: 33%;">
    <colgroup style="width: 32%;">
    <tr>
      <th class="head">
        <p>Device series</p>
      </th>
      <th class="head">
        <p>Device</p>
      </th>
      <th class="head">
        <p>LLVM target</p>
      </th>
      <th class="head">
        <p>Architecture</p>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td class="stub">
        <a href="https://www.amd.com/en/products/accelerators/instinct/mi350.html" target="_blank">AMD Instinct MI350 Series</a>
      </td>
      <td>
        <p><a href="https://www.amd.com/en/products/accelerators/instinct/mi350/mi355x.html" target="_blank">Instinct MI355X</a></p>
        <p><a href="https://www.amd.com/en/products/accelerators/instinct/mi350/mi350x.html" target="_blank">Instinct MI350X</a></p>
      </td>
      <td>
        <p>gfx950</p>
      </td>
      <td>
        <a href="https://www.amd.com/en/technologies/cdna.html#cdna4" target="_blank">CDNA 4</a>
      </td>
    </tr>
    <tr>
      <td class="stub">
        <a href="https://www.amd.com/en/products/accelerators/instinct/mi300.html" target="_blank">AMD Instinct MI300 Series</a>
      </td>
      <td>
        <p><a href="https://www.amd.com/en/products/accelerators/instinct/mi300/mi325x.html" target="_blank">Instinct MI325X</a></p>
        <p><a href="https://www.amd.com/en/products/accelerators/instinct/mi300/mi300x.html" target="_blank">Instinct MI300X</a></p>
        <p><a href="https://www.amd.com/en/products/accelerators/instinct/mi300/mi300a.html" target="_blank">Instinct MI300A</a></p>
      </td>
      <td>
        <p>gfx942</p>
      </td>
      <td>
        <a href="https://www.amd.com/en/technologies/cdna.html#cdna3" target="_blank">CDNA 3</a>
      </td>
    </tr>
    <tr>
      <td class="stub">
        <a href="https://www.amd.com/en/products/accelerators/instinct/mi200.html" target="_blank">AMD Instinct MI200 Series</a>
      </td>
      <td>
        <p><a href="https://www.amd.com/en/products/accelerators/instinct/mi200/mi250x.html" target="_blank">Instinct MI250X</a></p>
        <p><a href="https://www.amd.com/en/products/accelerators/instinct/mi200/mi250.html" target="_blank">Instinct MI250</a></p>
        <p><a href="https://www.amd.com/en/products/accelerators/instinct/mi200/mi210.html" target="_blank">Instinct MI210</a></p>
      </td>
      <td>
        <p>gfx90a</p>
      </td>
      <td>
        <a href="https://www.amd.com/en/technologies/cdna.html#cdna2" target="_blank">CDNA 2</a>
      </td>
    </tr>
    <tr>
      <td class="stub">
        <a href="https://www.amd.com/en/products/accelerators/instinct/mi100.html" target="_blank">AMD Instinct MI100 Series</a>
      </td>
      <td>
        <a href="https://www.amd.com/en/products/accelerators/instinct/mi100.html" target="_blank">Instinct MI100</a>
      </td>
      <td>
        <p>gfx908</p>
      </td>
      <td>
        <a href="https://www.amd.com/en/technologies/cdna.html#cdna" target="_blank">CDNA</a>
      </td>
    </tr>
  </tbody>
</table>
:::

:::{tab-item} Radeon PRO
:sync: radeon-pro

<table class="rocm-docs-table table">
  <thead>
    <colgroup style="width: 33%;">
    <colgroup style="width: 32%;">
    <tr>
      <th class="head">
        <p>AMD device series</p>
      </th>
      <th class="head">
        <p>Device</p>
      </th>
      <th class="head">
        <p>LLVM target</p>
      </th>
      <th class="head">
        <p>Architecture</p>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <a href="https://www.amd.com/en/products/graphics/workstations/radeon-ai-pro.html#tabs-95fa144b96-item-b95ec9e1ca-tab" target="_blank">Radeon AI PRO R9000 Series</a>
      </td>
      <td>
        <p><a href="https://www.amd.com/en/products/graphics/workstations/radeon-ai-pro/ai-9000-series/amd-radeon-ai-pro-r9700.html" target="_blank">Radeon AI PRO R9700</a></p>
        <p><a href="https://www.amd.com/en/products/graphics/workstations/radeon-ai-pro/ai-9000-series/amd-radeon-ai-pro-r9600d.html" target="_blank">Radeon AI PRO R9600D</a></p>
      </td>
      <td>
        <p>gfx1201</p>
      </td>
      <td>
        <a href="https://www.amd.com/en/technologies/rdna.html#tabs-1fabb91c39-item-330ee548f0-tab" target="_blank">RDNA 4</p>
      </td>
    </tr>
    <tr>
      <td rowspan="2" class="stub">
        <a href="https://www.amd.com/en/products/graphics/workstations/radeon-pro.html#tabs-990fdead92-item-20daa37284-tab" target="_blank">Radeon PRO W7000 Series</a>
      </td>
      <td>
        <p><a href="https://www.amd.com/en/products/graphics/workstations/radeon-pro/w7900-dual-slot.html" target="_blank">Radeon PRO W7900 Dual Slot</a></p>
        <p><a href="https://www.amd.com/en/products/graphics/workstations/radeon-pro/w7900.html" target="_blank">Radeon PRO W7900</a></p>
        <p><a href="https://www.amd.com/en/products/graphics/workstations/radeon-pro/w7800-48gb.html" target="_blank">Radeon PRO W7800 48GB</a></p>
        <p><a href="https://www.amd.com/en/products/graphics/workstations/radeon-pro/w7800.html" target="_blank">Radeon PRO W7800</a></p>
      </td>
      <td>
        <p>gfx1100</p>
      </td>
      <td rowspan="3">
        <a href="https://www.amd.com/en/technologies/rdna.html#tabs-1fabb91c39-item-05915f6044-tab" target="_blank">RDNA 3</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><a href="https://www.amd.com/en/products/graphics/workstations/radeon-pro/w7700.html" target="_blank">Radeon PRO W7700</a></p>
      </td>
      <td rowspan="2">
        <p>gfx1101</p>
      </td>
    </tr>
    <tr>
      <td>
        <a href="https://www.amd.com/en/products/accelerators/radeon-pro.html" target="_blank">Radeon PRO V Series</a>
      </td>
      <td>
        <p><a href="https://www.amd.com/en/products/accelerators/radeon-pro/amd-radeon-pro-v710.html" target="_blank">Radeon PRO V710</a></p>
      </td>
    </tr>
  </tbody>
</table>
:::

:::{tab-item} Radeon
:sync: radeon

<table class="rocm-docs-table table">
  <thead>
    <colgroup style="width: 33%;">
    <colgroup style="width: 32%;">
    <tr>
      <th class="head">
        <p>AMD device series</p>
      </th>
      <th class="head">
        <p>Device</p>
      </th>
      <th class="head">
        <p>LLVM target</p>
      </th>
      <th class="head">
        <p>Architecture</p>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan="2" class="stub">
        <a href="https://www.amd.com/en/products/graphics/desktops/radeon.html#tabs-ff9c5c3863-item-37fb38a236-tab" target="_blank">Radeon RX 9000 Series</p>
      </td>
      <td>
        <p><a href="https://www.amd.com/en/products/graphics/desktops/radeon/9000-series/amd-radeon-rx-9070xt.html" target="_blank">Radeon RX 9070 XT</a></p>
        <p>Radeon RX 9070 GRE</p>
        <p><a href="https://www.amd.com/en/products/graphics/desktops/radeon/9000-series/amd-radeon-rx-9070.html" target="_blank">Radeon RX 9070</a></p>
      </td>
      <td>
        <p>gfx1201</p>
      </td>
      <td rowspan="2">
        <a href="https://www.amd.com/en/technologies/rdna.html#tabs-1fabb91c39-item-330ee548f0-tab" target="_blank">RDNA 4</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><a href="https://www.amd.com/en/products/graphics/desktops/radeon/9000-series/amd-radeon-rx-9060xt-lp.html" target="_blank">Radeon RX 9060 XT LP</a></p>
        <p><a href="https://www.amd.com/en/products/graphics/desktops/radeon/9000-series/amd-radeon-rx-9060xt.html" target="_blank">Radeon RX 9060 XT</a></p>
        <p><a href="https://www.amd.com/en/products/graphics/desktops/radeon/9000-series/amd-radeon-rx-9060.html" target="_blank">Radeon RX 9060</a></p>
      </td>
      <td>
        <p>gfx1200</p>
      </td>
    </tr>
    <tr>
      <td rowspan="3" class="stub">
        <a href="https://www.amd.com/en/products/graphics/desktops/radeon.html#tabs-ff9c5c3863-item-b55a56bf12-tab" target="_blank">Radeon RX 7000 Series</p>
      </td>
      <td>
        <p><a href="https://www.amd.com/en/products/graphics/desktops/radeon/7000-series/amd-radeon-rx-7900xtx.html" target="_blank">Radeon RX 7900 XTX</a></p>
        <p><a href="https://www.amd.com/en/products/graphics/desktops/radeon/7000-series/amd-radeon-rx-7900xt.html" target="_blank">Radeon RX 7900 XT</a></p>
        <p><a href="https://www.amd.com/en/products/graphics/desktops/radeon/7000-series/amd-radeon-rx-7900-gre.html" target="_blank">Radeon RX 7900 GRE</a></p>
      </td>
      <td>
        <p>gfx1100</p>
      </td>
      <td rowspan="3">
        <a href="https://www.amd.com/en/technologies/rdna.html#tabs-1fabb91c39-item-05915f6044-tab" target="_blank">RDNA 3</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><a href="https://www.amd.com/en/products/graphics/desktops/radeon/7000-series/amd-radeon-rx-7800-xt.html" target="_blank">Radeon RX 7800 XT</a></p>
        <p><a href="https://www.amd.com/en/products/graphics/desktops/radeon/7000-series/amd-radeon-rx-7700-xt.html" target="_blank">Radeon RX 7700 XT</a></p>
        <p>Radeon RX 7700 XE</p>
        <p><a href="https://www.amd.com/en/products/graphics/desktops/radeon/7000-series/amd-radeon-rx-7700.html" target="_blank">Radeon RX 7700</a></p>
      </td>
      <td>
        <p>gfx1101</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><a href="https://www.amd.com/en/products/graphics/desktops/radeon/7000-series/amd-radeon-rx-7600.html" target="_blank">Radeon RX 7600</a></p>
      </td>
      <td>
        <p>gfx1102</p>
      </td>
    </tr>
  </tbody>
</table>
:::

:::{tab-item} Ryzen
:sync: ryzen

<table class="rocm-docs-table table">
  <thead>
    <colgroup style="width: 33%;">
    <colgroup style="width: 32%;">
    <tr>
      <th class="head">
        <p>AMD device series</p>
      </th>
      <th class="head">
        <p>Device</p>
      </th>
      <th class="head">
        <p>LLVM target</p>
      </th>
      <th class="head">
        <p>Architecture</p>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td class="stub">
        <a href="https://www.amd.com/en/products/processors/workstations/mobile.html#tabs-7f0c432fb2-item-5116ab7a74-tab" target="_blank">Ryzen AI Max PRO 300 Series</a>
      </td>
      <td>
        <p><a href="https://www.amd.com/en/products/processors/laptop/ryzen-pro/ai-max-pro-300-series/amd-ryzen-ai-max-plus-pro-395.html" target="_blank">Ryzen AI Max+ PRO 395</a></p>
        <p><a href="https://www.amd.com/en/products/processors/laptop/ryzen-pro/ai-max-pro-300-series/amd-ryzen-ai-max-pro-390.html" target="_blank">Ryzen AI Max PRO 390</a></p>
        <p><a href="https://www.amd.com/en/products/processors/laptop/ryzen-pro/ai-max-pro-300-series/amd-ryzen-ai-max-pro-385.html" target="_blank">Ryzen AI Max PRO 385</a></p>
        <p><a href="https://www.amd.com/en/products/processors/laptop/ryzen-pro/ai-max-pro-300-series/amd-ryzen-ai-max-pro-380.html" target="_blank">Ryzen AI Max PRO 380</a></p>
      </td>
      <td rowspan="2">
        <p>gfx1151</p>
      </td>
      <td rowspan="4">
        <p>RDNA 3.5</p>
      </td>
    </tr>
    <tr>
      <td class="stub">
        <a href="https://www.amd.com/en/products/processors/laptop/ryzen.html#tabs-1181ea0b44-item-6ccfea5f65-tab" target="_blank">Ryzen AI Max 300 Series</a>
      </td>
      <td>
        <p><a href="https://www.amd.com/en/products/processors/laptop/ryzen/ai-300-series/amd-ryzen-ai-max-plus-395.html" target="_blank">Ryzen AI Max+ 395</a></p>
        <p><a href="https://www.amd.com/en/products/processors/laptop/ryzen/ai-300-series/amd-ryzen-ai-max-390.html" target="_blank">Ryzen AI Max 390</a></p>
        <p><a href="https://www.amd.com/en/products/processors/laptop/ryzen/ai-300-series/amd-ryzen-ai-max-385.html" target="_blank">Ryzen AI Max 385</a></p>
      </td>
    </tr>
    <tr>
      <td class="stub">
        <a href="https://www.amd.com/en/products/processors/workstations/mobile.html#tabs-7f0c432fb2-item-0c42136112-tab" target="_blank">Ryzen AI PRO 400 Series</a>
      </td>
      <td>
        <p><a href="https://www.amd.com/en/products/processors/laptop/ryzen-pro/ai-400-series/amd-ryzen-ai-9-hx-pro-475.html" target="_blank">Ryzen AI 9 HX PRO 475</a></p>
        <p><a href="https://www.amd.com/en/products/processors/laptop/ryzen-pro/ai-400-series/amd-ryzen-ai-9-hx-pro-470.html" target="_blank">Ryzen AI 9 HX PRO 470</a></p>
        <p><a href="https://www.amd.com/en/products/processors/laptop/ryzen-pro/ai-400-series/amd-ryzen-ai-9-pro-465.html" target="_blank">Ryzen AI 9 PRO 465</a></p>
        <p><a href="https://www.amd.com/en/products/processors/laptop/ryzen-pro/ai-400-series/amd-ryzen-ai-7-pro-450.html" target="_blank">Ryzen AI 7 PRO 450</a></p>
        <p><a href="https://www.amd.com/en/products/processors/laptop/ryzen-pro/ai-400-series/amd-ryzen-ai-5-pro-440.html" target="_blank">Ryzen AI 5 PRO 440</a></p>
        <p><a href="https://www.amd.com/en/products/processors/laptop/ryzen-pro/ai-400-series/amd-ryzen-ai-5-pro-435.html" target="_blank">Ryzen AI 5 PRO 435</a></p>
      </td>
      <td rowspan="2">
        <p>gfx1150</p>
      </td>
    </tr>
    <tr>
      <td class="stub">
        <a href="https://www.amd.com/en/products/processors/consumer/ryzen-ai.html#tabs-f556098628-item-54e149d850-tab" target="_blank">Ryzen AI 300 Series</a>
      </td>
      <td>
        <p><a href="https://www.amd.com/en/products/processors/laptop/ryzen/ai-300-series/amd-ryzen-ai-9-hx-375.html" target="_blank">Ryzen AI 9 HX 375</a></p>
        <p><a href="https://www.amd.com/en/products/processors/laptop/ryzen/ai-300-series/amd-ryzen-ai-9-hx-370.html" target="_blank">Ryzen AI 9 HX 370</a></p>
        <p><a href="https://www.amd.com/en/products/processors/laptop/ryzen/ai-300-series/amd-ryzen-ai-9-365.html" target="_blank">Ryzen AI 9 365</a></p>
      </td>
    </tr>
    <tr>
      <td class="stub">
        <a href="https://www.amd.com/en/products/processors/laptop/ryzen.html#tabs-1181ea0b44-item-895d56feed-tab" target="_blank">Ryzen 200 Series</a>
      </td>
      <td>
        <p><a href="https://www.amd.com/en/products/processors/laptop/ryzen/200-series/amd-ryzen-9-270.html" target="_blank">Ryzen 9 270</a></p>
        <p><a href="https://www.amd.com/en/products/processors/laptop/ryzen/200-series/amd-ryzen-7-260.html" target="_blank">Ryzen 7 260</a></p>
        <p><a href="https://www.amd.com/en/products/processors/laptop/ryzen/200-series/amd-ryzen-7-250.html" target="_blank">Ryzen 7 250</a></p>
        <p><a href="https://www.amd.com/en/products/processors/laptop/ryzen/200-series/amd-ryzen-5-240.html" target="_blank">Ryzen 5 240</a></p>
        <p><a href="https://www.amd.com/en/products/processors/laptop/ryzen/200-series/amd-ryzen-5-230.html" target="_blank">Ryzen 5 230</a></p>
        <p><a href="https://www.amd.com/en/products/processors/laptop/ryzen/200-series/amd-ryzen-5-220.html" target="_blank">Ryzen 5 220</a></p>
        <p><a href="https://www.amd.com/en/products/processors/laptop/ryzen/200-series/amd-ryzen-3-210.html" target="_blank">Ryzen 3 210</a></p>
      </td>
      <td>
        <p>gfx1103</p>
      </td>
      <td>
        <a href="https://www.amd.com/en/technologies/rdna.html#tabs-1fabb91c39-item-05915f6044-tab" target="_blank">RDNA 3</a>
      </td>
    </tr>
  </tbody>
</table>
:::
::::

```{note}
This preview release supports a limited number of GPU and APUs. Hardware
support will be expanded with future releases, following a six-week release
cadence.
```

(release-supported-os)=

## Operating system support

ROCm supports the following Linux distribution and Microsoft Windows versions.
If you're running ROCm on Linux, ensure your system is using a supported kernel
version. Future preview releases will expand operating system support coverage.

:::{important}
The following table is a general overview of supported OSes. Actual support
might vary by [GPU](#release-supported-hw). Use the {doc}`Compatibility matrix
</compatibility/compatibility-matrix>` to verify support for your specific
setup before installation.
:::

::::{tab-set}
:::{tab-item} Instinct
:sync: instinct

<table class="rocm-docs-table table">
  <thead>
    <colgroup style="width: 33%;">
    <tr>
      <th class="head">
        <p>Linux distribution</p>
      </th>
      <th class="head">
        <p>Supported versions</p>
      </th>
      <th class="head">
        <p>Linux kernel version</p>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" class="stub" style="vertical-align: middle">
        <p>Ubuntu</p>
      </th>
      <td>
        <p>24.04.3</p>
      </td>
      <td>
        <p>GA 6.8</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>22.04.5</p>
      </td>
      <td>
        <p>GA 5.15</p>
      </td>
    </tr>
    <tr>
      <th rowspan="2" class="stub" style="vertical-align: middle">
        <p>Debian</p>
      </th>
      <td>
        <p>13</p>
      </td>
      <td>
        <p>6.12</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>12</p>
      </td>
      <td>
        <p>6.1.0</p>
      </td>
    </tr>
    <tr>
      <th rowspan="6" class="stub" style="vertical-align: middle">
        <p>Red Hat Enterprise Linux (RHEL)</p>
      </th>
      <td>
        <p>10.1</p>
      </td>
      <td>
        <p>6.12.0-124</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>10.0</p>
      </td>
      <td>
        <p>6.12.0-55</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>9.7</p>
      </td>
      <td>
        <p>5.14.0-611</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>9.6</p>
      </td>
      <td>
        <p>5.14.0-570</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>9.4</p>
      </td>
      <td>
        <p>5.14.0-427</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>8.10</p>
      </td>
      <td>
        <p>4.18.0-553</p>
      </td>
    </tr>
    <tr>
      <th rowspan="3" class="stub" style="vertical-align: middle">
        <p>Oracle Linux</p>
      </th>
      <td>
        <p>10</p>
      </td>
      <td>
        <p>UEK 8.1</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>9</p>
      </td>
      <td>
        <p>UEK 8</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>8</p>
      </td>
      <td>
        <p>UEK 7</p>
      </td>
    </tr>
    <tr>
      <th class="stub" style="vertical-align: middle">
        <p>Rocky Linux</p>
      </th>
      <td>
        <p>9</p>
      </td>
      <td>
        <p>5.14.0-570</p>
      </td>
    </tr>
    <tr>
      <th rowspan="2" class="stub" style="vertical-align: middle">
        <p>SUSE Linux Enterprise Server (SLES)</p>
      </th>
      <td>
        <p>16.0</p>
      </td>
      <td>
        <p>6.12</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>15.7</p>
      </td>
      <td>
        <p>6.4.0-150700.51</p>
      </td>
    </tr>
  </tbody>
</table>
:::

:::{tab-item} Radeon PRO
:sync: radeon-pro

<table class="rocm-docs-table table">
  <thead>
    <colgroup style="width: 33%;">
    <tr>
      <th class="head">
        <p>Operating system</p>
      </th>
      <th class="head">
        <p>Supported versions</p>
      </th>
      <th class="head">
        <p>Linux kernel version</p>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" class="stub" style="vertical-align: middle">
        <p>Ubuntu</p>
      </th>
      <td>
        <p>24.04.3</p>
      </td>
      <td>
        <p>GA 6.8</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>22.04.5</p>
      </td>
      <td>
        <p>GA 5.15</p>
      </td>
    </tr>
    <tr>
      <th rowspan="2" class="stub" style="vertical-align: middle">
        <p>Red Hat Enterprise Linux (RHEL)</p>
      </th>
      <td>
        <p>10.1</p>
      </td>
      <td>
        <p>6.12.0-124</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>9.7</p>
      </td>
      <td>
        <p>5.14.0-611</p>
      </td>
    </tr>
    <tr>
      <th class="stub" style="vertical-align: middle">
        <p>Windows</p>
      </th>
      <td>
        <p>11 25H2</p>
      </td>
      <td>
        <p style="text-align: center;"> — </p>
      </td>
    </tr>
  </tbody>
</table>
:::

:::{tab-item} Radeon
:sync: radeon

<table class="rocm-docs-table table">
  <thead>
    <colgroup style="width: 33%;">
    <tr>
      <th class="head">
        <p>Operating system</p>
      </th>
      <th class="head">
        <p>Supported versions</p>
      </th>
      <th class="head">
        <p>Linux kernel version</p>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th rowspan="2" class="stub" style="vertical-align: middle">
        <p>Ubuntu</p>
      </th>
      <td>
        <p>24.04.3</p>
      </td>
      <td>
        <p>GA 6.8</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>22.04.5</p>
      </td>
      <td>
        <p>GA 5.15</p>
      </td>
    </tr>
    <tr>
      <th rowspan="2" class="stub" style="vertical-align: middle">
        <p>Red Hat Enterprise Linux (RHEL)</p>
      </th>
      <td>
        <p>10.1</p>
      </td>
      <td>
        <p>6.12.0-124</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>9.7</p>
      </td>
      <td>
        <p>5.14.0-611</p>
      </td>
    </tr>
    <tr>
      <th class="stub" style="vertical-align: middle">
        <p>Windows</p>
      </th>
      <td>
        <p>11 25H2</p>
      </td>
      <td>
        <p style="text-align: center;"> — </p>
      </td>
    </tr>
  </tbody>
</table>
:::

:::{tab-item} Ryzen
:sync: ryzen

<table class="rocm-docs-table table">
  <thead>
    <colgroup style="width: 33%;">
    <tr>
      <th class="head">
        <p>Operating system</p>
      </th>
      <th class="head">
        <p>Supported versions</p>
      </th>
      <th class="head">
        <p>Linux kernel version</p>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th class="stub" style="vertical-align: middle">
        <p>Ubuntu</p>
      </th>
      <td>
        <p>24.04.3</p>
      </td>
      <td>
        <p>HWE 6.14</p>
      </td>
    </tr>
    <tr>
      <th class="stub" style="vertical-align: middle">
        <p>Windows</p>
      </th>
      <td>
        <p>11 25H2</p>
      </td>
      <td>
        <p style="text-align: center;"> — </p>
      </td>
    </tr>
  </tbody>
</table>
:::
::::

(release-supported-fw)=
## Kernel driver and firmware bundle support

ROCm requires a coordinated stack of compatible firmware, driver, and user
space components. Maintaining version alignment between these layers ensures
correct GPU operation and performance, especially for AMD data center products.
While AMD publishes the AMD GPU driver and ROCm user space components, your
server OEM or infrastructure provider distributes the firmware packages. AMD
supplies those firmware images (PLDM bundles), which the OEM integrates and
distributes.

::::{tab-set}
:::{tab-item} Instinct
:sync: instinct

<table class="rocm-docs-table table">
  <colgroup style="width: 25%;">
  <thead>
    <tr>
      <th class="head">
        <p>AMD device</p>
      </th>
      <th class="head">
        <p>Firmware</p>
      </th>
      <th class="head">
        <p>Linux driver</p>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p>Instinct MI355X</p>
      </td>
      <td rowspan="2" style="vertical-align: middle">
        <p>PLDM bundle 01.25.17.07, 01.25.16.03</p>
      </td>
      <td rowspan="9" style="vertical-align: middle">
        <p>
          <strong>AMD GPU Driver (amdgpu)</strong><br>
          <a
            href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.20.0-preview/documentation/release-notes.html"
            target="_blank"
          >31.20.0</a><br>
          <a
            href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.10.0-preview/documentation/release-notes.html"
            target="_blank"
          >31.10.0</a><br>
          <a
            href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.20.1/documentation/release-notes.html"
            target="_blank"
          >30.20.1</a><br>
          <a
            href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.20.0/documentation/release-notes.html"
            target="_blank"
          >30.20.0</a><br>
          <a
            href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10.2/documentation/release-notes.html"
            target="_blank"
          >30.10.2</a><br>
          <a
            href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10.1/documentation/release-notes.html"
            target="_blank"
          >30.10.1</a><br>
          <a
            href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10/documentation/release-notes.html"
            target="_blank"
          >30.10.0</a><br>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Instinct MI350X</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Instinct MI325X</p>
      </td>
      <td style="vertical-align: middle">
        <p>PLDM bundle 01.25.04.02</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Instinct MI300X</p>
      </td>
      <td>
        <p>PLDM bundle 01.25.03.12</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Instinct MI300A</p>
      </td>
      <td>
        <p>BKC 26.1</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Instinct MI250X</p>
      </td>
      <td>
        <p>IFWI 75 (or later)</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Instinct MI250</p>
      </td>
      <td rowspan="2">
        <p>Maintenance update 5 with IFWI 75 (or later)</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Instinct MI210</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Instinct MI100</p>
      </td>
      <td>
        <p>VBIOS D3430401-037</p>
      </td>
    </tr>
  </tbody>
</table>
:::

:::{tab-item} Radeon PRO
:sync: radeon-pro

<table class="rocm-docs-table table">
  <colgroup style="width: 25%;">
  <thead>
    <tr>
      <th class="head">
        <p>AMD device</p>
      </th>
      <th class="head">
        <p>Linux driver</p>
      </th>
      <th class="head">
        <p>Windows driver</p>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p>Radeon AI PRO R9700</p>
      </td>
      <td rowspan="8" style="vertical-align: middle">
        <p>
          <strong>AMD GPU Driver (amdgpu)</strong><br>
          <a
            href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.20.0-preview/documentation/release-notes.html"
            target="_blank"
          >31.20.0</a><br>
          <a
            href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.10.0-preview/documentation/release-notes.html"
            target="_blank"
          >31.10.0</a><br>
          <a
            href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.20.1/documentation/release-notes.html"
            target="_blank"
          >30.20.1</a><br>
          <a
            href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.20.0/documentation/release-notes.html"
            target="_blank"
          >30.20.0</a><br>
          <a
            href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10.2/documentation/release-notes.html"
            target="_blank"
          >30.10.2</a><br>
          <a
            href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10.1/documentation/release-notes.html"
            target="_blank"
          >30.10.1</a><br>
          <a
            href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10/documentation/release-notes.html"
            target="_blank"
          >30.10.0</a><br>
        </p>
      </td>
      <td style="vertical-align: middle">
        <p>
          <strong>AMD Software: Adrenalin Edition</strong><br>
          <a
            href="https://www.amd.com/en/resources/support-articles/release-notes/RN-RAD-WIN-26-3-1.html"
            target="_blank"
          >26.3.1</a>
      </td>
    </tr>
    <tr>
      <td>
        <p>Radeon AI PRO R9600D</p>
      </td>
      <td>
        <p style="text-align: center;"> — </p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Radeon PRO W7900 Dual Slot</p>
      </td>
      <td rowspan="5" style="vertical-align: middle">
        <p>
          <strong>AMD Software: Adrenalin Edition</strong><br>
          <a
            href="https://www.amd.com/en/resources/support-articles/release-notes/RN-RAD-WIN-26-3-1.html"
            target="_blank"
          >26.3.1</a>
      </td>
    </tr>
    <tr>
      <td>
        <p>Radeon PRO W7900</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Radeon PRO W7800 48GB</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Radeon PRO W7800</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Radeon PRO W7700</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Radeon PRO V710</p>
      </td>
      <td>
        <p style="text-align: center;"> — </p>
      </td>
    </tr>
  </tbody>
</table>
:::

:::{tab-item} Radeon
:sync: radeon

<table class="rocm-docs-table table">
  <colgroup style="width: 25%;">
  <thead>
    <tr>
      <th class="head">
        <p>AMD device</p>
      </th>
      <th class="head">
        <p>Linux driver</p>
      </th>
      <th class="head">
        <p>Windows driver</p>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p>Radeon RX 9070 XT</p>
      </td>
      <td rowspan="14" style="vertical-align: middle">
        <p>
          <strong>AMD GPU Driver (amdgpu)</strong><br>
          <a
            href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.20.0-preview/documentation/release-notes.html"
            target="_blank"
          >31.20.0</a><br>
          <a
            href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/31.10.0-preview/documentation/release-notes.html"
            target="_blank"
          >31.10.0</a><br>
          <a
            href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.20.1/documentation/release-notes.html"
            target="_blank"
          >30.20.1</a><br>
          <a
            href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.20.0/documentation/release-notes.html"
            target="_blank"
          >30.20.0</a><br>
          <a
            href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10.2/documentation/release-notes.html"
            target="_blank"
          >30.10.2</a><br>
          <a
            href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10.1/documentation/release-notes.html"
            target="_blank"
          >30.10.1</a><br>
          <a
            href="https://instinct.docs.amd.com/projects/amdgpu-docs/en/docs-30.10/documentation/release-notes.html"
            target="_blank"
          >30.10.0</a><br>
        </p>
      </td>
      <td rowspan="6" style="text-align: center; vertical-align: middle;">
        <p> — </p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Radeon RX 9070 GRE</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Radeon RX 9070</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Radeon RX 9060 XT LP</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Radeon RX 9060 XT</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Radeon RX 9060</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Radeon RX 7900 XTX</p>
      </td>
      <td rowspan="6" style="vertical-align: middle">
        <p>
          <strong>AMD Software: Adrenalin Edition</strong><br>
          <a
            href="https://www.amd.com/en/resources/support-articles/release-notes/RN-RAD-WIN-26-3-1.html"
            target="_blank"
          >26.3.1</a>
      </td>
    </tr>
    <tr>
      <td>
        <p>Radeon RX 7900 XT</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Radeon RX 7900 GRE</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Radeon RX 7800 XT</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Radeon RX 7700 XT</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Radeon RX 7700 XE</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Radeon RX 7700</p>
      </td>
      <td rowspan="2" style="text-align: center; vertical-align: middle;">
        <p> — </p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Radeon RX 7600</p>
      </td>
    </tr>
  </tbody>
</table>
:::

:::{tab-item} Ryzen
:sync: ryzen

<table class="rocm-docs-table table">
  <colgroup style="width: 25%;">
  <thead>
    <tr>
      <th class="head">
        <p>AMD device</p>
      </th>
      <th class="head">
        <p>Linux driver</p>
      </th>
      <th class="head">
        <p>Windows driver</p>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p>Ryzen AI Max+ PRO 395</p>
      </td>
      <td rowspan="23" style="vertical-align: middle">
        <p>Inbox kernel driver<br>in Ubuntu 24.04.3</p>
      </td>
      <td rowspan="23" style="vertical-align: middle">
        <p>
          <strong>AMD Software: Adrenalin Edition</strong><br>
          <a
            href="https://www.amd.com/en/resources/support-articles/release-notes/RN-RAD-WIN-26-3-1.html"
            target="_blank"
          >26.3.1</a>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Ryzen AI Max PRO 390</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Ryzen AI Max PRO 385</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Ryzen AI Max PRO 380</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Ryzen AI Max+ 395</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Ryzen AI Max 390</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Ryzen AI Max 385</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Ryzen AI 9 HX 375</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Ryzen AI 9 HX 370</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Ryzen AI 9 365</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Ryzen AI 9 HX PRO 475</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Ryzen AI 9 HX PRO 470</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Ryzen AI 9 PRO 465</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Ryzen AI 7 PRO 450</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Ryzen AI 5 PRO 440</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Ryzen AI 5 PRO 435</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Ryzen 9 270</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Ryzen 7 260</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Ryzen 7 250</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Ryzen 5 240</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Ryzen 5 230</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Ryzen 5 220</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Ryzen 3 210</p>
      </td>
    </tr>
  </tbody>
</table>
:::
::::

(release-virtualization-support)=
## GPU virtualization support

AMD Instinct data center GPUs support virtualization in the following
configurations. Supported SR-IOV configurations require the AMD GPU
Virtualization Driver (GIM) 8.7.1K -- see the [AMD Instinct Virtualization
Driver
documentation](https://instinct.docs.amd.com/projects/virt-drv/en/mainline-8.7.1.k/)
for more information.

<table class="rocm-docs-table table">
  <colgroup style="width: 14%;">
  <colgroup style="width: 14%;">
  <colgroup style="width: 17%;">
  <colgroup style="width: 17%;">
  <colgroup style="width: 19%;">
  <colgroup style="width: 19%;">
  <thead>
    <tr>
      <th class="head">
        <p>AMD GPU</p>
      </th>
      <th class="head">
        <p>Hypervisor</p>
      </th>
      <th class="head">
        <p>Virtualization technology</p>
      </th>
      <th class="head">
        <a>Virtualization driver</a>
      </th>
      <th class="head">
        <p>Host OS</p>
      </th>
      <th class="head">
        <p>Guest OS</p>
      </th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan="4" style="vertical-align: middle">
        <p>Instinct MI355X</p>
      </td>
      <td rowspan="4" style="vertical-align: middle">
        <p>KVM</p>
      </td>
      <td style="vertical-align: middle">
        <p>Passthrough</p>
      </td>
      <td>
        <p style="text-align: center">—</p>
      </td>
      <td rowspan="4" style="vertical-align: middle">
        <p>Ubuntu 24.04</p>
      </td>
      <td style="vertical-align: middle">
        <p>Ubuntu 24.04</p>
      </td>
    </tr>
    <tr>
      <td rowspan="3" style="vertical-align: middle">
        <p>SR-IOV</p>
      </td>
      <td rowspan="3" style="vertical-align: middle">
        <a
          href="https://github.com/amd/MxGPU-Virtualization/releases/tag/8.7.1.K"
          target="_blank"
        >GIM 8.7.1K
        </a>
      </td>
      <td style="vertical-align: middle">
        <p>Ubuntu 24.04</p>
      </td>
    </tr>
    <tr>
      <td style="vertical-align: middle">
        <p>RHEL 10.0</p>
      </td>
    </tr>
    <tr>
      <td style="vertical-align: middle">
        <p>RHEL 9.6</p>
      </td>
    </tr>
    <tr>
      <td rowspan="3" style="vertical-align: middle">
        <p>Instinct MI350X</p>
      </td>
      <td rowspan="3" style="vertical-align: middle">
        <p>KVM</p>
      </td>
      <td style="vertical-align: middle">
        <p>Passthrough</p>
      </td>
      <td>
        <p style="text-align: center">—</p>
      </td>
      <td rowspan="3" style="vertical-align: middle">
        <p>Ubuntu 24.04</p>
      </td>
      <td style="vertical-align: middle">
        <p>Ubuntu 24.04</p>
      </td>
    </tr>
    <tr>
      <td rowspan="2" style="vertical-align: middle">
        <p>SR-IOV</p>
      </td>
      <td rowspan="2" style="vertical-align: middle">
        <a
          href="https://github.com/amd/MxGPU-Virtualization/releases/tag/8.7.1.K"
          target="_blank"
        >GIM 8.7.1K
        </a>
      </td>
      <td style="vertical-align: middle">
        <p>Ubuntu 24.04</p>
      </td>
    </tr>
    <tr>
      <td style="vertical-align: middle">RHEL 9.6</td>
    </tr>
    <tr>
      <td style="vertical-align: middle">
        <p>Instinct MI325X</p>
      </td>
      <td style="vertical-align: middle">
        <p>KVM</p>
      </td>
      <td style="vertical-align: middle">
        <p>SR-IOV</p>
      </td>
      <td style="vertical-align: middle">
        <a
          href="https://github.com/amd/MxGPU-Virtualization/releases/tag/8.7.1.K"
          target="_blank"
        >GIM 8.7.1K
        </a>
      </td>
      <td style="vertical-align: middle">
        <p>Ubuntu 22.04</p>
      </td>
      <td style="vertical-align: middle">
        <p>Ubuntu 22.04</p>
      </td>
    </tr>
    <tr>
      <td rowspan="2" style="vertical-align: middle">
        <p>Instinct MI300X</p>
      </td>
      <td rowspan="2" style="vertical-align: middle">
        <p>KVM</p>
      </td>
      <td style="vertical-align: middle">
        <p>Passthrough</p>
      </td>
      <td>
        <p style="text-align: center">—</p>
      </td>
      <td rowspan="2" style="vertical-align: middle">
        <p>Ubuntu 22.04</p>
      </td>
      <td rowspan="2" style="vertical-align: middle">
        <p>Ubuntu 22.04</p>
      </td>
    </tr>
    <tr>
      <td style="vertical-align: middle">
        <p>SR-IOV</p>
      </td>
      <td style="vertical-align: middle">
        <a
          href="https://github.com/amd/MxGPU-Virtualization/releases/tag/8.7.1.K"
          target="_blank"
        >GIM 8.7.1K
        </a>
      </td>
    </tr>
  </tbody>
</table>

(release-ai-ecosystem)=
## AI ecosystem support

ROCm 7.12.0 provides optimized support for popular deep learning frameworks and
AI inference engines. The following table lists supported frameworks and
libraries, their compatible operating systems, and validated versions.

<table class="rocm-docs-table table">
	<thead>
		<tr>
			<th class="head">
				<p>Framework</p>
			</th>
			<th class="head">
				<p>Supported versions</p>
			</th>
			<th class="head">
				<p>Supported OS</p>
			</th>
			<th class="head">
				<p>Supported Python versions</p>
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td rowspan="2" style="vertical-align: middle;">
				<p>PyTorch</p>
			</td>
			<td style="vertical-align: middle;">
				<p>2.10.0, 2.9.1, 2.8.0</p>
			</td>
			<td>
				<p>Linux</p>
			</td>
			<td rowspan="2">
				<p>3.13, 3.12, 3.11</p>
			</td>
		</tr>
		<tr>
			<td style="vertical-align: middle;">
				<p>2.10.0, 2.9.1</p>
			</td>
			<td style="vertical-align: middle;">
				<p>Windows</p>
			</td>
		</tr>
		<tr>
			<td style="vertical-align: middle;">
				<p>JAX</p>
			</td>
			<td style="vertical-align: middle;">
				<p>0.8.2, 0.8.0</p>
			</td>
			<td>
				<p>Linux</p>
			</td>
			<td>
				<p>3.14, 3.13, 3.12, 3.11</p>
			</td>
		</tr>
		<tr>
			<td style="vertical-align: middle;">
				<p>vLLM<br>(<a href="#release-supported-hw">gfx950, gfx942, gfx1200,<br>gfx1201, gfx1151 GPUs only</a>)</p>
			</td>
			<td>
				<p>0.16.0</p>
			</td>
			<td>
				<p>Linux</p>
			</td>
			<td>
				<p>3.12</p>
			</td>
		</tr>
    </tbody>
<table>

(release-components)=
## ROCm Core SDK components

The following table lists tools and libraries included in the ROCm 7.12.0
release. Expect future releases to expand the list of components.

:::{important}
The following table is a general overview of ROCm Core SDK components. Actual
support for these libraries and tools might vary by GPU and OS. Use the
{doc}`Compatibility matrix </compatibility/compatibility-matrix>` to verify
support for your specific setup.
:::

<table class="rocm-docs-table table">
	<thead>
		<tr>
			<th class="head">
				<p>Component group</p>
			</th>
			<th class="head">
				<p>Component name</p>
			</th>
			<th class="head">
				<p>Support</p>
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td rowspan="18" style="vertical-align: middle;">
				<p>Math and compute libraries</p>
			</td>
            <td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.12/projects/composablekernel">Composable Kernel</a>
            </td>
			<td rowspan="17" style="vertical-align: middle;">
				Linux, Windows
			</td>
		</tr>
		<tr>
			<td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.12/projects/hipblas">hipBLAS</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.12/projects/hipblaslt">hipBLASLt</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.12/projects/hipcub">hipCUB</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.12/projects/hipfft">hipFFT</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.12/projects/hiprand">hipRAND</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.12/projects/hipsolver">hipSOLVER</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.12/projects/hipsparse">hipSPARSE</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.12/projects/miopen">MIOpen</a>
			</td>
        </tr>
        <tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.12/projects/rocblas">rocBLAS</a>
			</td>
        </tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.12/projects/rocfft">rocFFT</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.12/projects/rocrand">rocRAND</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.12/projects/rocsolver">rocSOLVER</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.12/projects/rocsparse">rocSPARSE</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.12/projects/rocprim">rocPRIM</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.12/projects/rocthrust">rocThrust</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.12/projects/rocwmma">rocWMMA</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.12/projects/hipsparselt">hipSPARSELt</a>
			</td>
			<td>
                Linux only (Instinct MI350, MI300 Series, Ryzen APUs)
			</td>
		</tr>
        <tr>
			<td rowspan="2" style="vertical-align: middle;">
				<p>Communication libraries</p>
			</td>
			<td>
				<a href="https://github.com/ROCm/rocm-systems/tree/release/therock-7.12/projects/rccl">RCCL</a>
			</td>
			<td style="vertical-align: middle;">
				Linux only
			</td>
		</tr>
        <tr>
			<td>
				<a href="https://github.com/ROCm/rocm-systems/tree/release/therock-7.12/projects/rocshmem">rocSHMEM</a>
			</td>
			<td style="vertical-align: middle;">
				Linux only (Instinct, Radeon PRO, Radeon)
			</td>
		</tr>
		<tr>
			<td style="vertical-align: middle;">
				<p>Support libraries</p>
			</td>
			<td>
				<a href="https://github.com/ROCm/rocm-cmake/tree/release/therock-7.12">ROCm CMake</a>
			</td>
			<td>
				Linux, Windows
			</td>
		</tr>
		<tr>
			<td rowspan="5" style="vertical-align: middle;">
				<p>Runtimes and compilers</p>
			</td>
			<td>
				<a href="https://github.com/ROCm/rocm-systems/tree/release/therock-7.12/projects/hip">HIP</a>
			</td>
			<td rowspan="4" style="vertical-align: middle;">
				<p>Linux, Windows</p>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/HIPIFY/tree/release/therock-7.12">HIPIFY</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/llvm-project/tree/release/therock-7.12">LLVM</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/SPIRV-LLVM-Translator/tree/release/therock-7.12">SPIRV-LLVM-Translator</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-systems/tree/release/therock-7.12/projects/rocr-runtime">ROCr Runtime</a>
			</td>
			<td>
				Linux only
			</td>
		</tr>
		<tr>
			<td rowspan="6" style="vertical-align: middle;">
				<p>Profiling and debugging tools</p>
			</td>
			<td>
				<a href="https://github.com/ROCm/rocm-systems/tree/release/therock-7.12/projects/rocprofiler-compute">ROCm Compute Profiler (rocprofiler-compute)</a>
			</td>
			<td rowspan="2" style="vertical-align: middle;">
                Linux only (Instinct)
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-systems/tree/release/therock-7.12/projects/rocprofiler-systems">ROCm Systems Profiler (rocprofiler-systems)</a>
			</td>
        </tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-systems/tree/release/therock-7.12/projects/rocprofiler-sdk">ROCprofiler-SDK</a>
			</td>
			<td>
				Linux
			</td>
        </tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/ROCdbgapi/tree/release/therock-7.12">ROCdbgapi</a>
			</td>
			<td rowspan="3" style="vertical-align: middle;">
				Linux only (Instinct, Radeon PRO, Radeon)
			</td>
        </tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/ROCgdb/tree/release/therock-7.12">ROCm Debugger (ROCgdb)</a>
			</td>
        </tr>
        <tr>
			<td>
				<a href="https://github.com/ROCm/rocr_debug_agent/tree/release/therock-7.12">ROCr Debug Agent</a>
			</td>
        </tr>
		<tr>
			<td rowspan="3" style="vertical-align: middle;">
				<p>Control and monitoring tools</p>
			</td>
			<td>
				<a href="https://github.com/ROCm/rocm-systems/tree/release/therock-7.12/projects/amdsmi">AMD SMI</a>
			</td>
			<td style="vertical-align: middle;">
                Linux only (Instinct, Radeon PRO, Radeon)
			</td>
		</tr>
		<tr>
			<td>
				<a>hipinfo</a>
			</td>
			<td style="vertical-align: middle;">
                Windows
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-systems/tree/release/therock-7.12/projects/rocminfo">rocminfo</a>
			</td>
			<td style="vertical-align: middle;">
                Linux only
			</td>
		</tr>
	</tbody>
</table>

## Known issues

The following are known issues identified in ROCm 7.12.0.

(release-jax-known-issue)=
### JAX GPU initialization might fail without AMD_COMGR_NAMESPACE set

When running JAX with ROCm, symbol collisions can occur between the ROCm
compiler infrastructure and other libraries. These collisions may prevent
proper GPU initialization for JAX and can lead to crashes or cause JAX to
silently fall back to CPU execution.


Set the environment variable `AMD_COMGR_NAMESPACE=1` to isolate the ROCm
compiler infrastructure's symbol namespace and avoid these collisions.

```bash
export AMD_COMGR_NAMESPACE=1
```

(release-jax-path-known-issue)=
### JAX fails to initialize due to missing ROCm shared libraries

A path resolution issue in the JAX environment prevents the loader from
locating required ROCm SDK shared libraries, causing JAX GPU initialization to
fail.

As a workaround, set `LD_LIBRARY_PATH` to include the ROCm SDK core library
path before running JAX. Replace `<python_version>` with the Python version
being used with JAX (3.14, 3.13, 3.12, or 3.11); for example:

```bash
export LD_LIBRARY_PATH=/opt/python/lib/<python_version>/site-packages/_rocm_sdk_core/lib:$LD_LIBRARY_PATH
```

To ensure JAX does not silently fallback to CPU execution, set `JAX_PLATFORMS=rocm`.

(release-vllm-path-known-issue)=
### vLLM server fails to launch with ROCm 7.12 Docker image due to path failure

A path resolution issue in the vLLM Docker environment prevents the loader
from locating required ROCm SDK shared libraries. As a result, library lookups
are redirected to an invalid or unexpected location, causing the vLLM server
startup to fail.

As a workaround, before starting the vLLM server inside the ROCm 7.12 vLLM
Docker container, set `LD_LIBRARY_PATH` to include the ROCm SDK core library
path; for example:

```bash
export LD_LIBRARY_PATH=/opt/python/lib/python3.12/site-packages/_rocm_sdk_core/lib:$LD_LIBRARY_PATH
```

(release-vllm-tp-known-issue)=
### vLLM server fails to launch for models with tensor parallelism set to 8

Launching the vLLM server might fail for models configured with tensor
parallelism (`--tensor-parallel-size 8` or `tp=8`), resulting in
a `custom_all_reduce_hip.cuh: invalid device pointer` error. This issue will be
fixed in a future release.

### PyTorch DDP Gloo backend test might fail on AMD GPUs

On AMD GPUs, the PyTorch Distributed Data Parallel (DDP) test
`test_ddp_apply_optim_in_backward_grad_as_bucket_view_false` fails when using
the Gloo backend. This issue affects correctness of distributed training flows
that rely on this code path in PyTorch 2.8 when configured with Gloo.

As a workaround, use the NCCL backend instead of Gloo for multi-GPU distributed
training using PyTorch 2.8. For example:

```py
torch.distributed.init_process_group(backend="nccl", ...)
```

This issue will be fixed in a future release.

### HIP kernel launch limit might be hit for some models

With PyTorch 2.10, some models can hit the HIP kernel launch limit of 2³²
kernel launches within a single process. When this limit is reached, further
kernel launches fail. One known affected model is:

- [black-forest-labs/flux](https://github.com/black-forest-labs/flux)

This issue manifests as a HIP kernel launch error during model execution. This
issue will be fixed in a future release.

### Performance regression in specific MAD PyTorch models between 2.9 and 2.10

On ROCm PyTorch 2.10, some MAD-based ImageNet training and wrapper models show
a performance regression compared to ROCm PyTorch 2.9. The currently known
affected models include:

- `pyt_torchimagenet_inceptionv3_training`

- `pyt_torchimagenet_resnet50_training`

- `pt2_resnet152_pywrapper`

These workloads might run slower on 2.10 than on 2.9 under similar conditions.
This issue will be fixed in a future release.

### ROCm 7.12 validation with PyTorch unit tests is limited

For ROCm 7.12, the validation coverage using the PyTorch unit test suite is
limited. Only a subset of the full PyTorch unit tests has been executed and
validated on this release.

### Some torchaudio transforms cannot be exported with torch.jit.script

The following torchaudio transforms fail to export with `torch.jit.script` due
to missing TorchScript annotations and type compatibility issues:

- `FrequencyMasking`
- `TimeMasking`
- `DifferentiableFIR`
- `RNNTLoss`

Users cannot export torchaudio models containing these transforms to
TorchScript, blocking deployment of optimized audio processing pipelines.
This issue will be fixed in a future release.

As a workaround, build torchaudio from the `rocm/audio` branch, which includes
the fix, or use eager mode execution instead of TorchScript.

### PyTorch TestAutograd.test_multi_grad_all_hooks fails on Windows

On Windows, the PyTorch sub-test `TestAutograd.test_multi_grad_all_hooks` fails
during runtime compilation of a temporary C++ extension due to MSVC linker
errors. This issue will be fixed in a future release.

### TransferBench plugin fails to build for gfx1103

Building rocm_bandwidth_test with `--offload-arch=gfx1103` fails when compiling
the TransferBench plugin. As a result, TransferBench-based builds might not complete successfully
Ryzen 200 Series (gfx1103) APUs. This issue will be fixed in a future release.

### HIP unit tests trigger a TDR event on Windows with gfx1103

On Windows with Ryzen 200 Series (gfx1103) APUs, the HIP unit test
`Unit_hipStreamValue_Wait_Blocking - uint32_t` triggers a Timeout Detection and
Recovery (TDR) event. This causes the GPU driver to reset during test execution.
This issue will be fixed in a future release.

### PyTorch TestNN and RNN tests might fail on Windows with gfx1103

On Windows systems using Ryzen 200 Series (gfx1103) APUs, some PyTorch TestNN and RNN tests
might fail at runtime due to MIOpen HIPRTC compilation errors in Composable Kernel
(CK) reductions. The failure occurs because the required `CK_AMD_GPU_GFX*` macros
are not defined for gfx1103, resulting in `HIPRTC_ERROR_COMPILATION` and
`miopenStatusUnknownError`. This issue will be fixed in a future release.

### amd-smi reset -r help text is not updated

The `amd-smi reset --reload-driver` (`-r`) command has been deprecated, but the
help text is not updated to reflect the current CLI options.

You can use `modprobe` instead of `amd-smi reset -r` to unload and reload the
AMD GPU driver:

```shell
modprobe -r amdgpu && modprobe amdgpu
```

### rocWMMA header produces unknown type errors in HIP RTC

Including `rocwmma/rocwmma.hpp` in HIP RTC (runtime compilation) contexts
produces compiler errors such as `unknown type name '__bf16'` and
`unknown type name '__fp8_e4m3_fnuz'`. This prevents using rocWMMA in HIP RTC
workflows.

As a workaround, add typedef definitions for the missing types before including
the rocWMMA header. For example:

```cpp
#if defined(__HIPCC_RTC__)
typedef _BitInt(16) __bf16;
typedef _BitInt(8) __fp8_e4m3_fnuz;
typedef _BitInt(8) __fp8_e5m2_fnuz;
#endif
#include <rocwmma/rocwmma.hpp>
```

### hipCUB DeviceMerge large-size stress test fails with OOM on gfx1150

On gfx1150 APUs, the hipCUB `DeviceMerge` large-size stress
test (`MergeLargeSizeIterators`) might fail with an out-of-memory (OOM) error
when running ROCm 7.12.0. All standard `DeviceMerge` test cases pass; only the
large-size stress configuration is affected. This issue will be fixed in a
future release.

### ROCm Debug Agent tests fail with "wave not found in queue" on gfx1150

On Gorgan Point (gfx1150) APUs, ROCm Debug Agent tests may fail with a fatal
`wave not found in queue` error. This occurs during debug API queue and
wavefront tracking, causing `rocm-dbgapi` to terminate while processing shader
debug events. This issue will be fixed in a future release.

### rocprof-compute and rocprofv3-avail fail due to shared library not found

Errors might occur when running `rocprof-compute` or `rocprofv3-avail`
commands that require ROCm shared libraries. For example:

```
OSError: librocm_sysdeps_dw.so.1: cannot open shared object file: No such file or directory
```

As a workaround, add the ROCm system dependencies path to `LD_LIBRARY_PATH`
before running the affected tools. Replace `<ROCM_PATH>` with your ROCm
installation location:

```bash
export LD_LIBRARY_PATH=<ROCM_PATH>/lib/rocm_sysdeps/lib:$LD_LIBRARY_PATH
```

This issue will be fixed in a future release.

### Training instability with custom-built hipBLASLt and tuned GEMMs on MI300 Series GPUs

In partner-style validation of MLPerf DLRM DCN v2 training on Instinct MI300
Series GPUs (gfx942), a stack using PyTorch with a custom-built hipBLASLt that
includes tuned GEMMs for that workload can experience training instability,
with `NaN`s appearing after many iterations. The time-to-failure varies between
runs. This issue can affect anyone mirroring that integration; typical
ROCm-shipped stacks are not found to experience the same issue.

Use the ROCm-provided hipBLASLt and supported ROCm stack rather than an
experimental or locally rebuilt hipBLASLt with additional GEMM tuning until
a fix is released.

### rocPRIM adjacent_find test hangs on Windows with Navi44

On Windows with Navi44 GPUs, the `adjacent_find` unit test in rocPRIM hangs
when running ROCm 7.11 or 7.12. It's recommended to avoid running the
`adjacent_find` unit test on Windows. This issue will be fixed in a future
release.

### MIOpen GPU_Find2Conv_FP32 tests might intermittently fail

The `GPU_Find2Conv_FP32.Find2ConvTest` tests can intermittently fail when run in
ROCm 7.12.0. This is not a new issue; it sometimes occurred in previous releases
but became more frequent when the tests were converted from ctest to gtest. The
failure depends on the order in which tests are executed. This issue will be fixed
in a future release.

### Multi-ROCm installation fails on RPM-based distros

On RPM-based Linux distributions (including RHEL and SLES), installing
ROCm 7.12 alongside an existing ROCm 7.11 installation using the
`amdrocm7.<...>-gfx<...>` meta-packages can fail due to RPM file conflicts. This
prevents side‑by‑side installation of ROCm 7.11 and 7.12 using the standard
repositories and package names. This issue will be fixed in a future release.

## Resolved issues

The following notable issues have been fixed in ROCm 7.12.0.

### ROCm debugging tools binaries now fully available

Previously, ROCm debugging tools -- ROCdbgapi, ROCgdb, and ROCr Debug Agent --
were not available after installing using your Linux distribution's package
manager or using `pip`.

This issue has been resolved.

### Multi-node RCCL tests could crash or hang on MI355X with AINIC NICs

Previously, multi-node RCCL tests (such as `alltoall_perf`, `allgather_perf`,
`allreduce_perf`, and `reduce_scatter_perf`) could crash intermittently or hang
on Instinct MI355X GPUs when using AINIC NICs and the AINIC RoCE path
(`RCCL_AINIC_ROCE=1`).

This issue has been resolved.

### hipify-clang emitted spurious errors with CUDA 12.x

Previously, when using `hipify-clang` with CUDA 12.x, the following messages
could appear during hipification:

```
error: must pass in an explicit nvptx64 gpu architecture to 'ptxas'
error: must pass in an explicit nvptx64 gpu architecture to 'nvlink'
```

These were emitted by the CUDA detection phase, which unnecessarily invoked the
CUDA device toolchain. The `.hip` files were still generated correctly and
could be used normally.

This issue has been resolved.

### Apex encountered crashes and segfaults with the TheRock build system

Previously, [Apex](https://github.com/ROCm/apex/) would encounter crashes,
missing module errors, and segfaults related to the HIP runtime during testing
with the TheRock build system.

This issue has been resolved.

### MIOpen unit tests failed to find rocrand headers during runtime kernel compilation

Previously, MIOpen unit tests could fail to find the `rocrand_xorwow.h` header
during runtime compilation of certain kernels (for example,
`MIOpenSoftmaxAttn.cpp`), resulting in `HIPRTC_ERROR_COMPILATION`. This was
caused by missing runtime include-path configuration in TheRock artifacts: ROCm
could be installed in arbitrary locations, and the rocrand headers were not
reliably discoverable by HIPRTC/COMGR at runtime.

This issue has been resolved.

## Upcoming changes

Future preview releases will expand support for:

* Additional ROCm Core SDK components

* Domain-specific expansion toolkits (data science, life science, finance,
  simulation, and other HPC domains)

* Extended AMD hardware support
