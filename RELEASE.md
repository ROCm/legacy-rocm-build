# ROCm Core SDK 7.11.0 release notes

ROCm Core SDK 7.11.0 continues the technology preview release stream that began
with [ROCm
7.9.0](https://rocm.docs.amd.com/en/7.9.0-preview/about/release-notes.html),
advancing the transition to the new [TheRock](https://github.com/rocm/therock)
build and release system. To learn more about TheRock, see [ROCm Core SDK and
TheRock Build
System](https://rocm.blogs.amd.com/software-tools-optimization/therock/README.html).

This release expands AMD GPU and APU support and adds more components
to the ROCm Core SDK. Developers can expect a more consistent build experience
and streamlined workflows that pave the way toward modular future ROCm
releases planned for mid-2026.

(preview-stream-note)=
:::{important}
ROCm 7.11.0 follows the [versioning discontinuity that began with
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

ROCm Core SDK 7.11.0 with TheRock builds on the 7.10.0 release with several key
enhancements:

### Expanded AMD GPU support

The ROCm 7.11.0 preview adds support for RDNA 4 and other GPUs:

- Radeon AI PRO R9700

- Radeon AI PRO R9600D

- Radeon PRO W7900 Dual Slot

- Radeon PRO V710

- Radeon RX 9070 XT

- Radeon RX 9070 GRE

- Radeon RX 9070

- Radeon RX 9060 XT LP

- Radeon RX 9060 XT

- Radeon RX 9060

- Radeon RX 7700

For the full list of supported hardware, see [Hardware support](#release-supported-hw).

### Expanded Linux distribution support

ROCm 7.11.0 adds support for the following Linux distributions on AMD Instinct
and Radeon GPUs.

- Debian 13

- Red Hat Enterprise Linux (RHEL) 9.4, 8.10

- SUSE Linux Enterprise Server (SLES) 16.0

- Oracle Linux 10, 9, 8

- Rocky Linux 9

For the full list of supported Linux distributions, see [Operating system
support](#release-supported-os).

### Added Linux package manager support

ROCm Core SDK packages are now available in `.deb` and `.rpm` formats and can
be installed using your Linux distro's package manager. See the
{doc}`installation instructions </install/rocm>` for details.

### Added GPU virtualization support for Instinct GPUs

ROCm 7.11.0 supports GPU virtualization on AMD Instinct MI355X, MI350X, MI325X,
and MI300X GPUs. For details, see [GPU virtualization
support](#release-virtualization-support).

### Added debugging tools to the ROCm Core SDK

ROCm 7.11.0 adds the following debugging tools to the ROCm Core SDK on Linux:

- [ROCdbgapi](https://github.com/ROCm/ROCdbgapi/tree/release/therock-7.11)

- [ROCm Debugger (ROCgdb)](https://github.com/ROCm/ROCgdb/tree/release/therock-7.11)

- [ROCr Debug Agent](https://github.com/ROCm/rocr_debug_agent/tree/release/therock-7.11)

For the full list of core components, see [ROCm Core SDK
components](release-components).

### Compatibility notices

In terms of package compatibility, ROCm 7.11.0 diverges from the existing ROCm
7.0 production stream and future stable releases in that stream:

* **Compute-focused**: ROCm 7.11.0 enables support for primarily compute workloads.
  Future releases will support mixed workloads (compute and graphics).

  If you’re interested in testing AMD Radeon GPUs with preview support for
  graphics use cases with AMD ROCm 7.11.0, install Radeon Software for Linux
  version 25.35 from [Linux Drivers for AMD Radeon and Radeon PRO
  Graphics](https://www.amd.com/en/support/download/linux-drivers.html).

  If you're interested in testing AMD Ryzen APUs with preview support for
  graphics use cases with AMD ROCm 7.11.0, use the inbox graphics drivers of
  Ubuntu 24.04.3.

* **No upgrade path from existing production releases** including ROCm 7.2.0
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
AI APUs. Each supported device is listed with its corresponding GPU
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
      <th class="stub">
        <p>Instinct MI350 Series</p>
      </th>
      <td>
        <p>Instinct MI355X</p>
        <p>Instinct MI350X</p>
      </td>
      <td>
        <p>gfx950</p>
      </td>
      <td>
        <p>CDNA 4</p>
      </td>
    </tr>
    <tr>
      <th class="stub">
        <p>Instinct MI300 Series</p>
      </th>
      <td>
        <p>Instinct MI325X</p>
        <p>Instinct MI300X</p>
        <p>Instinct MI300A</p>
      </td>
      <td>
        <p>gfx942</p>
      </td>
      <td>
        <p>CDNA 3</p>
      </td>
    </tr>
    <tr>
      <th class="stub">
        <p>Instinct MI200 Series</p>
      </th>
      <td>
        <p>Instinct MI250X</p>
        <p>Instinct MI250</p>
        <p>Instinct MI210</p>
      </td>
      <td>
        <p>gfx90a</p>
      </td>
      <td>
        <p>CDNA 2</p>
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
      <th>
        <p>Radeon AI PRO R9000 Series</p>
      </th>
      <td>
        <p>Radeon AI PRO R9700</p>
        <p>Radeon AI PRO R9600D</p>
      </td>
      <td>
        <p>gfx1201</p>
      </td>
      <td>
        <p>RDNA 4</p>
      </td>
    </tr>
    <tr>
      <th rowspan="2" class="stub">
        <p>Radeon PRO W7000 Series</p>
      </th>
      <td>
        <p>Radeon PRO W7900 Dual Slot</p>
        <p>Radeon PRO W7900</p>
        <p>Radeon PRO W7800 48GB</p>
        <p>Radeon PRO W7800</p>
      </td>
      <td>
        <p>gfx1100</p>
      </td>
      <td rowspan="3">
        <p>RDNA 3</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Radeon PRO W7700</p>
      </td>
      <td rowspan="2">
        <p>gfx1101</p>
      </td>
    </tr>
    <tr>
      <th>
        <p>Radeon PRO V Series</p>
      </th>
      <td>
        <p>Radeon PRO V710</p>
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
      <th rowspan="2" class="stub">
        <p>Radeon RX 9000 Series</p>
      </th>
      <td>
        <p>Radeon RX 9070 XT</p>
        <p>Radeon RX 9070 GRE</p>
        <p>Radeon RX 9070</p>
      </td>
      <td>
        <p>gfx1201</p>
      </td>
      <td rowspan="2">
        <p>RDNA 4</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Radeon RX 9060 XT LP</p>
        <p>Radeon RX 9060 XT</p>
        <p>Radeon RX 9060</p>
      </td>
      <td>
        <p>gfx1200</p>
      </td>
    </tr>
    <tr>
      <th rowspan="2" class="stub">
        <p>Radeon RX 7000 Series</p>
      </th>
      <td>
        <p>Radeon RX 7900 XTX</p>
        <p>Radeon RX 7900 XT</p>
        <p>Radeon RX 7900 GRE</p>
      </td>
      <td>
        <p>gfx1100</p>
      </td>
      <td rowspan="2">
        <p>RDNA 3</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Radeon RX 7800 XT</p>
        <p>Radeon RX 7700 XT</p>
        <p>Radeon RX 7700</p>
      </td>
      <td>
        <p>gfx1101</p>
      </td>
    </tr>
  </tbody>
</table>
:::

:::{tab-item} Ryzen AI
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
      <th class="stub">
        <p>Ryzen AI Max PRO 300 Series</p>
      </th>
      <td>
        <p>Ryzen AI Max+ PRO 395</p>
        <p>Ryzen AI Max PRO 390</p>
        <p>Ryzen AI Max PRO 385</p>
        <p>Ryzen AI Max PRO 380</p>
      </td>
      <td rowspan="2">
        <p>gfx1151</p>
      </td>
      <td rowspan="3">
        <p>RDNA 3.5</p>
      </td>
    </tr>
    <tr>
      <th class="stub">
        <p>Ryzen AI Max 300 Series</p>
      </th>
      <td>
        <p>Ryzen AI Max+ 395</p>
        <p>Ryzen AI Max 390</p>
        <p>Ryzen AI Max 385</p>
      </td>
    </tr>
    <tr>
      <th class="stub">
        <p>Ryzen AI 300 Series</p>
      </th>
      <td>
        <p>Ryzen AI 9 HX 375</p>
        <p>Ryzen AI 9 HX 370</p>
        <p>Ryzen AI 9 365</p>
      </td>
      <td>
        <p>gfx1150</p>
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
      <th class="stub" style="vertical-align: middle">
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

:::{tab-item} Ryzen AI
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
        <p>PLDM bundle 01.25.16.03</p>
      </td>
      <td rowspan="8" style="vertical-align: middle">
        <p>
          <strong>AMD GPU Driver (amdgpu)</strong><br>
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
            href="https://www.amd.com/en/resources/support-articles/release-notes/RN-RAD-WIN-26-1-1.html"
            target="_blank"
          >26.1.1</a>
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
            href="https://www.amd.com/en/resources/support-articles/release-notes/RN-RAD-WIN-26-1-1.html"
            target="_blank"
          >26.1.1</a>
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

:::{tab-item} Radeon RX
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
      <td rowspan="11" style="vertical-align: middle">
        <p>
          <strong>AMD GPU Driver (amdgpu)</strong><br>
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
      <td rowspan="5" style="vertical-align: middle">
        <p>
          <strong>AMD Software: Adrenalin Edition</strong><br>
          <a
            href="https://www.amd.com/en/resources/support-articles/release-notes/RN-RAD-WIN-26-1-1.html"
            target="_blank"
          >26.1.1</a>
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
  </tbody>
</table>
:::

:::{tab-item} Ryzen AI
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
      <td rowspan="10" style="vertical-align: middle">
        <p>Inbox kernel driver<br>in Ubuntu 24.04.3</p>
      </td>
      <td rowspan="10" style="vertical-align: middle">
        <p>
          <strong>AMD Software: Adrenalin Edition</strong><br>
          <a
            href="https://www.amd.com/en/resources/support-articles/release-notes/RN-RAD-WIN-26-1-1.html"
            target="_blank"
          >26.1.1</a>
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
  </tbody>
</table>
:::
::::

(release-virtualization-support)=
## GPU virtualization support

AMD Instinct data center GPUs support virtualization in the following
configurations. Supported SR-IOV configurations require the AMD GPU
Virtualization Driver (GIM) 8.7.0K -- see the [AMD Instinct Virtualization
Driver
documentation](https://instinct.docs.amd.com/projects/virt-drv/en/mainline-8.7.0.k/)
to learn more.

<table class="rocm-docs-table table">
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
			<td rowspan="2" style="vertical-align: middle;">
				<p>Instinct MI355X</p>
			</td>
			<td rowspan="2" style="vertical-align: middle;">
				<p>KVM</p>
			</td>
			<td style="vertical-align: middle;">
				<p>Passthrough</p>
			</td>
            <td>
              <p style="text-align: center;"> — </p>
            </td>
			<td rowspan="4" style="vertical-align: middle;">
				<p>Ubuntu 24.04</p>
			</td>
			<td rowspan="4" style="vertical-align: middle;">
				<p>Ubuntu 24.04</p>
			</td>
		</tr>
	    <tr>
			<td style="vertical-align: middle;">
				<p>SR-IOV</p>
			</td>
			<td style="vertical-align: middle;">
				<a href="https://github.com/amd/MxGPU-Virtualization/releases/tag/8.7.0.K" target="_blank">GIM 8.7.0K</p>
			</td>
		</tr>
		<tr>
			<td rowspan="2" style="vertical-align: middle;">
				<p>Instinct MI350X</p>
			</td>
			<td rowspan="2" style="vertical-align: middle;">
				<p>KVM</p>
			</td>
			<td style="vertical-align: middle;">
				<p>Passthrough</p>
			</td>
            <td>
              <p style="text-align: center;"> — </p>
            </td>
		</tr>
		<tr>
			<td style="vertical-align: middle;">
				<p>SR-IOV</p>
			</td>
			<td style="vertical-align: middle;">
				<a href="https://github.com/amd/MxGPU-Virtualization/releases/tag/8.7.0.K" target="_blank">GIM 8.7.0K</p>
			</td>
		</tr>
		<tr>
			<td style="vertical-align: middle;">
				<p>Instinct MI325X</p>
			</td>
			<td style="vertical-align: middle;">
				<p>KVM</p>
			</td>
			<td style="vertical-align: middle;">
				<p>SR-IOV</p>
			</td>
			<td style="vertical-align: middle;">
				<a href="https://github.com/amd/MxGPU-Virtualization/releases/tag/8.7.0.K" target="_blank">GIM 8.7.0K</p>
			</td>
			<td rowspan="3" style="vertical-align: middle;">
				<p>Ubuntu 22.04</p>
			</td>
			<td rowspan="3" style="vertical-align: middle;">
				<p>Ubuntu 22.04</p>
			</td>
		</tr>
		<tr>
			<td rowspan="2" style="vertical-align: middle;">
				<p>Instinct MI300X</p>
			</td>
			<td rowspan="2" style="vertical-align: middle;">
				<p>KVM</p>
			</td>
			<td style="vertical-align: middle;">
				<p>Passthrough</p>
			</td>
            <td>
              <p style="text-align: center;"> — </p>
            </td>
		</tr>
		<tr>
			<td style="vertical-align: middle;">
				<p>SR-IOV</p>
			</td>
			<td style="vertical-align: middle;">
				<a href="https://github.com/amd/MxGPU-Virtualization/releases/tag/8.7.0.K" target="_blank">GIM 8.7.0K</p>
			</td>
		</tr>
    </tbody>
<table>

## Deep learning framework support

ROCm 7.11.0 provides optimized support for popular deep learning frameworks.
The following table lists supported frameworks, their compatible operating
systems, and validated framework versions.

<table class="rocm-docs-table table">
	<thead>
		<tr>
			<th class="head">
				<p>Framework</p>
			</th>
			<th class="head">
				<p>Supported OS</p>
			</th>
			<th class="head">
				<p>Supported framework versions</p>
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td rowspan="2" style="vertical-align: middle;">
				<p>PyTorch</p>
			</td>
			<td>
				<p>Linux</p>
			</td>
			<td style="vertical-align: middle;">
				<p>2.9.1, 2.8.0, 2.7.1</p>
			</td>
		</tr>
		<tr>
			<td style="vertical-align: middle;">
				<p>Windows</p>
			</td>
			<td style="vertical-align: middle;">
				<p>2.9.1</p>
			</td>
		</tr>
    </tbody>
<table>

(release-components)=
## ROCm Core SDK components

The following table lists tools and libraries included in the ROCm 7.11.0
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
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.11/projects/composablekernel">Composable Kernel</a>
            </td>
			<td rowspan="17" style="vertical-align: middle;">
				Linux, Windows
			</td>
		</tr>
		<tr>
			<td>
                <a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.11/projects/hipblas">hipBLAS</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.11/projects/hipblaslt">hipBLASLt</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.11/projects/hipcub">hipCUB</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.11/projects/hipfft">hipFFT</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.11/projects/hiprand">hipRAND</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.11/projects/hipsolver">hipSOLVER</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.11/projects/hipsparse">hipSPARSE</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.11/projects/miopen">MIOpen</a>
			</td>
        </tr>
        <tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.11/projects/rocblas">rocBLAS</a>
			</td>
        </tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.11/projects/rocfft">rocFFT</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.11/projects/rocrand">rocRAND</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.11/projects/rocsolver">rocSOLVER</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.11/projects/rocsparse">rocSPARSE</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.11/projects/rocprim">rocPRIM</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.11/projects/rocthrust">rocThrust</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.11/projects/rocwmma">rocWMMA</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-libraries/tree/release/therock-7.11/projects/hipsparselt">hipSPARSELt</a>
			</td>
			<td>
                Linux only (Instinct MI350, MI300 Series, Ryzen APUs)
			</td>
		</tr>
        <tr>
			<td style="vertical-align: middle;">
				<p>Communication libraries</p>
			</td>
			<td>
				<a href="https://github.com/ROCm/rocm-systems/tree/release/therock-7.11/projects/rccl">RCCL</a>
			</td>
			<td style="vertical-align: middle;">
				Linux only
			</td>
		</tr>
		<tr>
			<td style="vertical-align: middle;">
				<p>Support libraries</p>
			</td>
			<td>
				<a href="https://github.com/ROCm/rocm-cmake/tree/release/therock-7.11">ROCm CMake</a>
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
				<a href="https://github.com/ROCm/rocm-systems/tree/release/therock-7.11/projects/hip">HIP</a>
			</td>
			<td rowspan="4" style="vertical-align: middle;">
				<p>Linux, Windows</p>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/HIPIFY/tree/release/therock-7.11">HIPIFY</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/llvm-project/tree/release/therock-7.11">LLVM</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/SPIRV-LLVM-Translator/tree/release/therock-7.11">SPIRV-LLVM-Translator</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-systems/tree/release/therock-7.11/projects/rocr-runtime">ROCr Runtime</a>
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
				<a href="https://github.com/ROCm/rocm-systems/tree/release/therock-7.11/projects/rocprofiler-compute">ROCm Compute Profiler (rocprofiler-compute)</a>
			</td>
			<td rowspan="2" style="vertical-align: middle;">
                Linux only (Instinct)
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-systems/tree/release/therock-7.11/projects/rocprofiler-systems">ROCm Systems Profiler (rocprofiler-systems)</a>
			</td>
        </tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/rocm-systems/tree/release/therock-7.11/projects/rocprofiler-sdk">ROCprofiler-SDK</a>
			</td>
			<td rowspan="4" style="vertical-align: middle;">
				Linux only (Instinct, Radeon PRO, Radeon)
			</td>
        </tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/ROCdbgapi/tree/release/therock-7.11">ROCdbgapi</a>
			</td>
        </tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/ROCgdb/tree/release/therock-7.11">ROCm Debugger (ROCgdb)</a>
			</td>
        </tr>
        <tr>
			<td>
				<a href="https://github.com/ROCm/rocr_debug_agent/tree/release/therock-7.11">ROCr Debug Agent</a>
			</td>
        </tr>
		<tr>
			<td rowspan="3" style="vertical-align: middle;">
				<p>Control and monitoring tools</p>
			</td>
			<td>
				<a href="https://github.com/ROCm/rocm-systems/tree/release/therock-7.11/projects/amdsmi">AMD SMI</a>
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
				<a href="https://github.com/ROCm/rocm-systems/tree/release/therock-7.11/projects/rocminfo">rocminfo</a>
			</td>
			<td rowspan="3" style="vertical-align: middle;">
                Linux only
			</td>
		</tr>
		<tr>
			<td rowspan="2" style="vertical-align: middle;">
				<p>System validation tools</p>
			</td>
			<td>
				<a href="https://github.com/ROCm/rocm_bandwidth_test">ROCm Bandwidth Test (RBT)</a>
			</td>
		</tr>
		<tr>
			<td>
				<a href="https://github.com/ROCm/TransferBench">TransferBench</a>
			</td>
		</tr>
	</tbody>
</table>

## Known issues

The following are known issues identified in ROCm 7.11.0.

### DistilBERT model performance regression on AMD Instinct MI350 Series

The [DistilBERT](https://huggingface.co/distilbert/distilbert-base-uncased)
base model experiences reduced GPU kernel performance on Instinct MI350 Series
GPUs (gfx950). This issue is under investigation.

### ROCgdb GPU core dump limitation

ROCgdb has a limitation that prevents proper GPU core dumps from being
generated. This blocks effective root‑cause analysis of GPU faults.
[ROCm/rocm-systems PR #2851](https://github.com/ROCm/rocm-systems/pull/2851)
introduces a fix to the ROCr Runtime's core dump generation and will be
included in a future release.

### Clang illegal instruction error on Radeon GPUs

Using Clang with the `-O0` optimization level on certain supported AMD Radeon PRO
and Radeon GPUs might trigger an illegal instructions detected error. This
failure typically occurs in code paths that use `ockl_wfred_*` functions, which
handle wavefront operations and synchronization. Projects like llama.cpp are
known to be affected. As a workaround, use `-Og` optimization level instead of
`-O0` for debug builds:

- Linux (CMake)
  ```bash
  DCMAKE_CXX_FLAGS_DEBUG="-Og -g"
  ```
- Windows (CMake)
  ```bash
  -DCMAKE_CXX_FLAGS_DEBUG="-Og -g -Xclang -gcodeview -D_DEBUG -D_DLL -D_MT -Xclang --dependent-lib=msvcrtd"
  ```

### llama.cpp runtime failures on Instinct MI350 Series

llama.cpp builds successfully but might fail at runtime with the error "HIP
kernel mul_mat_q has no device code". This issue is under investigation.

### llama.cpp prompt processing performance regression

llama.cpp experiences reduced prompt processing performance across multiple AMD
GPU architectures. As a workaround, pass the compiler flag `-mllvm
--amdgpu-unroll-threshold-local=600` to `hipcc` or `amdclang` when compiling
llama.cpp:

```bash
hipcc -mllvm --amdgpu-unroll-threshold-local=600 ...
```

This issue will be fixed in a future release.

### PyTorch model training validation issues

The following models failed validation on PyTorch for ROCm 7.11.0 due to
compilation errors and other issues: Llama 3.1 8B, Llama 3.1 70B, Llama
2 70B-chat-hf, and DeepSpeed Megatron-LM GPT2.

### Apex fails to build using TheRock

[Apex](https://github.com/ROCm/apex/) encounters crashes, missing module
errors, and segmentation faults related to the HIP runtime during testing with
the TheRock build system. This will be fixed in a future release.

### PyTorch unit tests freeze on Microsoft Windows

The `test_cublas_config_nondeterministic_alert_cuda` and `test_graph_error`
PyTorch tests fail and hang indefinitely on Windows. This issue will be fixed
in a future release.

### HIPRTC rocWMMA unknown type name compilation errors

Any HIPRTC program using the `rocwmma.hpp` header will fail to compile and
produce "unknown type name" errors. This issue will be fixed in
a future release. As a workaround, add the following code before including the
`rocwmma.hpp` header:

```cpp
typedef signed char int8_t;
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
```

### hipBLASLt TF32 matmul INF propagation on Instinct MI350 Series

On Instinct MI350 Series GPUs (gfx950), `hipblasLtMatmul` with `computeType
= HIPBLAS_COMPUTE_32F_FAST_TF32` returns `NaN` instead of propagating `INF`
values from input tensors. As a workaround, sanitize or clamp tensors before
TF32 matmul operations if acceptable for the workload. This issue will be fixed
in a future release.

### rocPRIM unit test fails on Windows on Radeon RX 9060 GPUs

The `rocprim.device_adjacent_find` unit test on Windows on Radeon RX 9060 XT
LP, 9060 XT, and 9060 GPUs might hang intermittently. This issue will be fixed
in a future release.

### MIOpen unit test runtime compilation failures

MIOpen unit tests fail to find the `rocrand_xorwow.h` header during runtime
compilation of certain kernels. This occurs because ROCm can be installed in
various locations and the include path is not automatically resolved. Impact is
minimal as the affected kernel (softmax attention) is not used in production
workloads. This issue will be fixed in a future release.

### CRIU checkpoint fails on Instinct MI300X with Debian 13

ROCm Bandwidth Test (RBT) test cases for Checkpoint/Restore In Userspace (CRIU)
fail on Instinct MI300X GPUs running Debian 13. Debian 13 users might
experience CRIU failures. This issue will be fixed in a future release.

### Multi-node RCCL tests crash intermittently

Multi-node RCCL tests (such as `alltoall_perf`, `allgather_perf`) are
experiencing intermittent crashes on Instinct MI355X GPUs with AINIC NICs. This
issue will be fixed in a future release.

### hipify-clang errors with NVIDIA CUDA 12.x

Users running `hipify-clang` with CUDA 12.x or later will encounter errors when
processing CUDA source files:

```
error: must pass in an explicit nvptx64 gpu architecture to 'ptxas'
error: must pass in an explicit nvptx64 gpu architecture to 'nvlink'
```

As a workaround, explicitly pass the `cuda-gpu-arch` flag:
```
hipify-clang --cuda-gpu-arch=sm_70...
```
This issue will be fixed in a future release.

### HIP Graph API tutorial code build fails

The HIP Graph API tutorial code fails to build on Linux due to a missing `-fPIC`
compiler flag. To resolve this issue, enable position-independent code in the
main `CMakeLists.txt` by adding `set(CMAKE_POSITION_INDEPENDENT_CODE ON)` as in the
fix in [ROCm/rocm-examples PR
#408](https://github.com/ROCm/rocm-examples/pull/408/changes#diff-1e7de1ae2d059d21e1dd75d5812d5a34b0222cef273b7c3a2af62eb747f9d20aR34).

## Upcoming changes

Future preview releases will expand support for:

* Additional ROCm Core SDK components

* Domain-specific expansion toolkits (data science, life science, finance,
  simulation, and other HPC domains)

* Extended AMD hardware support
